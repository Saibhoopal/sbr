data "aws_iam_role" "existing_instance_role" {
  name = var.aws_role_name
}

resource "aws_sfn_state_machine" "iceway_app_config_sfn_state_machine" {
  name     = "iceway-app-config"
  role_arn = data.aws_iam_role.existing_instance_role.arn

#  definition = file("${path.module}/iceway_app_config_defination.json")
  definition = <<DEFINITION
{
  "Comment": "Configure_App_Servers",
  "StartAt": "Action",
  "States": {
    "Action": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.server_type",
          "StringEquals": "jease",
          "Next": "Configure_Jease"
        },
        {
          "Variable": "$.server_type",
          "StringEquals": "ota",
          "Next": "Configure_Ota"
        },
        {
          "Variable": "$.server_type",
          "StringEquals": "touch",
          "Next": "Configure_Touch"
        }
      ],
      "Default": "Finish"
    },
    "Configure_Jease": {
      "Type": "Task",
      "Resource": "${var.lambda_function_arn}",
      "ResultPath": "$.currentInstance",
      "Next": "Finish"
    },
    "Configure_Ota": {
      "Type": "Task",
      "Resource": "${var.lambda_function_arn}",
      "ResultPath": "$.currentInstance",
      "Next": "Finish"
    },
    "Configure_Touch": {
      "Type": "Task",
      "Resource": "${var.lambda_function_arn}",
      "ResultPath": "$.currentInstance",
      "Next": "Finish"
    },
    "Finish": {
      "Type": "Succeed"
    }
  }
}
DEFINITION
}
resource "aws_sfn_state_machine" "rolling_server_restart_sfn_state_machine" {
  name     = "rolling-server-restart"
  role_arn = data.aws_iam_role.existing_instance_role.arn

#  definition = file("${path.module}/rolling_server_restart_defination.json")
  definition = <<DEFINITION
{
  "Comment": "Rolling Server Restarts",
  "StartAt": "Action",
  "States": {
    "Action": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.service_restart",
          "StringEquals": "jease",
          "Next": "Restart_Jease"
        },
        {
          "Variable": "$.service_restart",
          "StringEquals": "ota",
          "Next": "Restart_Ota"
        },
        {
          "Variable": "$.service_restart",
          "StringEquals": "touch",
          "Next": "Restart_Touch"
        }
      ],
      "Default": "Finish"
    },
    "Restart_Jease": {
      "Type": "Task",
      "Resource": "${var.lambda_function_arn}",
      "ResultPath": "$.currentInstance",
      "Next": "IterateTargets"
    },
    "Restart_Ota": {
      "Type": "Task",
      "Resource": "${var.lambda_function_arn}",
      "ResultPath": "$.currentInstance",
      "Next": "IterateTargets"
    },
    "Restart_Touch": {
      "Type": "Task",
      "Resource": "${var.lambda_function_arn}",
      "ResultPath": "$.currentInstance",
      "Next": "IterateTargets"
    },
    "IterateTargets": {
      "Type": "Map",
      "ItemsPath": "$.currentInstance",
      "MaxConcurrency": 1,
      "ResultPath": "$.currentTarget",
      "Iterator": {
        "StartAt": "Deregister_Target",
        "States": {
          "Deregister_Target": {
            "Type": "Task",
            "Resource": "${var.lambda_function_arn}",
            "Next": "Restart_Target"
          },
          "Restart_Target": {
            "Type": "Task",
            "Resource": "${var.lambda_function_arn}",
            "Next": "Register_Target"
          },
          "Register_Target": {
            "Type": "Task",
            "Resource": "${var.lambda_function_arn}",
            "Next": "Target_Health_Check"
          },
          "Target_Health_Check": {
            "Type": "Task",
            "Resource": "${var.lambda_function_arn}",
            "Next": "CheckHealthStatus"
          },
          "CheckHealthStatus": {
            "Type": "Choice",
            "Choices": [
              {
                "Variable": "$.instance_health_status[0].health_status",
                "StringEquals": "healthy",
                "Next": "ProceedTo_NextTarget"
              }
            ],
            "Default": "ExitStateMachine"
          },
          "ProceedTo_NextTarget": {
            "Type": "Pass",
            "Result": "Proceeding to Iteration Next Target",
            "End": true
          },
          "ExitStateMachine": {
            "Type": "Fail",
            "Error": "UnhealthyInstance",
            "Cause": "Instance is not healthy, exiting state machine"
          }
        }
      },
      "End": true
    },
    "Finish": {
      "Type": "Succeed"
    }
  }
}
DEFINITION
}
