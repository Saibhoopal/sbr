import boto3
import os
import time
import subprocess
import json

region = os.environ['REGION']
aws_git_secret = os.environ['AWS_GIT_SECRET_NAME']
############# Configure app server and Rolling server restarts #######################
def main(event, context):
    action = event.get("action")
    server_type = event.get("server_type")
    instance_id = event.get("instance_id")
    version = event.get("version", "default")
    target_group_arn = event.get("target_group_arn")   
    tags = event.get("tags")

    if server_type == "jease":
        variables = clone_code(event, context)
        result = config_server(server_type, version, tags)
        return result    

    instance_ids = [] # Initialize an empty list to store instance IDs
    service_restart = event.get("service_restart")
    if service_restart == "jease":
        elbv2_client = boto3.client('elbv2', region_name=region)
        target_group = elbv2_client.describe_target_health(TargetGroupArn=target_group_arn)
        instance_ids = [target['Target']['Id'] for target in target_group['TargetHealthDescriptions']]
        result = [{'action': 'deregister_target', 'instance_id': [instance_id], 'target_group_arn': target_group_arn} for instance_id in instance_ids]
        return result

    if 'ota_service_restart' in event and bool(event['ota_service_restart']) == True:
        print('nothing to configure on ota srver')
        return

    if 'touch_service_restart' in event and bool(event['touch_service_restart']) == True:
        print('nothing to configure on touch srver')
        return
    if action == "deregister_target":
        instance_ids = event['instance_id']
        result = deregister_target(instance_ids, target_group_arn)
        return result
    elif action == "restart_target":
        instance_ids = event['instance_id']
        result = restart_target(instance_ids, target_group_arn)
        return result
    elif action == "register_target":
        instance_ids = event['instance_id']
        result = register_target(instance_ids, target_group_arn)        
        return result
    elif action == "target_health_check":
        instance_ids = event['instance_id']
        result = target_health_check(instance_ids, target_group_arn)
        return result
    else:
        return {
            'statusCode': 400,
            'body': 'Invalid action specified in the event'
        }

def clone_code(event, context):
    os.system('rm -rf /tmp/*')
    secrets_manager = boto3.client('secretsmanager', region_name=region)
    secret_value = secrets_manager.get_secret_value(SecretId=aws_git_secret)['SecretString']
    id_rsa_path = os.path.join('/tmp', 'id_rsa')
    with open(id_rsa_path, 'w') as id_rsa_file:
        id_rsa_file.write(secret_value)    
    os.chmod('/tmp/id_rsa', 0o600)
    os.system('ssh-keyscan -t rsa github.com | tee /tmp/known_hosts | ssh-keygen -lf -')
    os.environ['GIT_SSH_COMMAND'] = 'ssh -o UserKnownHostsFile=/tmp/known_hosts -i /tmp/id_rsa'
    os.system('git clone git@github.com:theICEway-CloudServices/devops-poc.git /tmp/aws')
    os.system('ls -ltr /tmp/aws')
    os.system('cat /tmp/aws/providers.tf')

def config_server(server_type, version, tags):
    ssm_client = boto3.client('ssm', region_name=region)
    ec2 = boto3.resource('ec2', region_name=region)
    # Define the path to the local config file
    local_config_path = '/tmp/aws/config.json'
    try:
        # Load configuration from the local file
        with open(local_config_path, 'r') as config_file:
            mapping = json.load(config_file)

        if server_type in mapping and version in mapping[server_type]:
            variables = mapping[server_type][version]
        else:
            return {"error": f"Mapping not found for server_type: {server_type}, version: {version}"}

    except Exception as e:
        return {"error": f"Error loading configuration from local file: {str(e)}"}

    if not mapping:
        return {"error": f"Mapping not found for server_type: {server_type}, version: {version}"}

    document_name = 'AWS-RunShellScript'
    commands = [
        f"aws s3 cp {variables['script_source']} {variables['script_destination']}",
        f"chmod +x {variables['script_destination']}/*.sh"
    ]

    # Get instances based on the specified tag
    filters = [{'Name': f'tag:{key}', 'Values': [value]} for key, value in tags.items()]
    # Add a filter for instances in the running state
    filters.append({'Name': 'instance-state-name', 'Values': ['running']})
    instances = ec2.instances.filter(Filters=filters)
    instance_ids = [instance.id for instance in instances]  # Extract instance IDs

    for instance_id in instance_ids:
        command = f"bash {variables['script_destination']}/{variables['script_name']} {variables['war_source']} {variables['war_destination']} {variables['db_destination']} {variables['db_source']}"
        commands.append(command)

    # Execute commands on all instances
    response = ssm_client.send_command(
        InstanceIds=instance_ids,
        DocumentName=document_name,
        Parameters={'commands': commands}
    )

    command_id = response['Command']['CommandId']
    result = {'action': 'register_target', 'instance_id': [instance.id for instance in instances]}
    return result


def deregister_target(instance_ids, target_group_arn):
    elbv2_client = boto3.client('elbv2', region_name=region)
    targets = [{'Id': instance_id} for instance_id in instance_ids]
    
    elbv2_client.deregister_targets(TargetGroupArn=target_group_arn, Targets=targets)
    time.sleep(180)  # Wait for a specified time to allow connections to drain
    
    result = {'action': 'restart_target', 'instance_id': instance_ids, 'target_group_arn': target_group_arn}
    return result

def restart_target(instance_ids, target_group_arn):
    ssm_client = boto3.client('ssm', region_name=region)
    document_name = 'AWS-RunShellScript'
    for instance_id in instance_ids:
        command = ['sudo systemctl restart jease']
    response = ssm_client.send_command(
        InstanceIds=instance_ids,
        DocumentName=document_name,
        Parameters={'commands': command}
    )

    command_id = response['Command']['CommandId']
    time.sleep(30)  # Wait for the instances to come back online (you might need to adjust this time)
    result = {'action': 'register_target', 'instance_id': instance_ids, 'target_group_arn': target_group_arn}
    return result

def register_target(instance_ids, target_group_arn):
    elbv2_client = boto3.client('elbv2', region_name=region)
    targets = [{'Id': instance_id} for instance_id in instance_ids]
    elbv2_client.register_targets(TargetGroupArn=target_group_arn, Targets=targets)

    time.sleep(30)  # Wait for a specified time to allow the instances to become healthy
    result = {'action': 'target_health_check', 'instance_id': instance_ids, 'target_group_arn': target_group_arn}
    return result   

def target_health_check(instance_ids, target_group_arn):
    if not instance_ids:
        return {'error_message': 'Instance IDs not provided'}

    elbv2_client = boto3.client('elbv2', region_name=region)
    try:
        # Describe health of the specified targets in the target group
        health = elbv2_client.describe_target_health(
            TargetGroupArn=target_group_arn,
            Targets=[{'Id': instance_id} for instance_id in instance_ids]
        )
        # Extract health status of the specified instances
        health_status = []
        for target in health.get('TargetHealthDescriptions', []):
            target_health = target.get('TargetHealth', {})
            instance_health_status = {'instance_id': target['Target']['Id'], 'health_status': target_health.get('State', 'Unknown')}
            health_status.append(instance_health_status)

        return {'instance_health_status': health_status}

    except Exception as e:
        return {'error_message': str(e)}


