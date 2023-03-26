#################################################

resource "aws_iam_role" "morchella_delete_activation" {
  name               = "MorchellaDeleteActivation-${data.aws_region.current.name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "morchella_delete_activation" {
  name   = "MorchellaDeleteActivation-${data.aws_region.current.name}"
  role   = aws_iam_role.morchella_delete_activation.id
  policy = templatefile("${path.module}/${var.lambdas_code_path}/morchella_delete_activation/iam_policy.tftpl", { account_id = data.aws_caller_identity.current.account_id })
}

resource "aws_lambda_function" "morchella_delete_activation" {
  filename         = data.archive_file.morchella_delete_activation.output_path
  function_name    = "morchella-delete-activation"
  role             = aws_iam_role.morchella_delete_activation.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.morchella_delete_activation.output_base64sha256
  runtime          = "python3.9"
  architectures    = ["arm64"]
  timeout          = var.lambda_timeout
  tags             = var.default_tags
}

###############################

resource "aws_iam_role" "morchella_register_node" {
  name               = "MorchellaRegisterNode-${data.aws_region.current.name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "morchella_register_node" {
  name   = "MorchellaRegisterNode-${data.aws_region.current.name}"
  role   = aws_iam_role.morchella_register_node.id
  policy = templatefile("${path.module}/${var.lambdas_code_path}/morchella_register_node/iam_policy.tftpl", { account_id = data.aws_caller_identity.current.account_id })
}

resource "aws_lambda_function" "morchella_register_node" {
  filename         = data.archive_file.morchella_register_node.output_path
  function_name    = "morchella-register-node"
  role             = aws_iam_role.morchella_register_node.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.morchella_register_node.output_base64sha256
  runtime          = "python3.9"
  architectures    = ["arm64"]
  timeout          = var.lambda_timeout
  tags             = var.default_tags
}

################################################################

resource "aws_iam_role" "morchella_tag_resource" {
  name               = "MorchellaTagResource-${data.aws_region.current.name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "morchella_tag_resource" {
  name   = "MorchellaTagResouce-${data.aws_region.current.name}"
  role   = aws_iam_role.morchella_tag_resource.id
  policy = templatefile("${path.module}/${var.lambdas_code_path}/morchella_tag_resource/iam_policy.tftpl", { account_id = data.aws_caller_identity.current.account_id })
}

resource "aws_lambda_function" "morchella_tag_resource" {
  filename         = data.archive_file.morchella_tag_resource.output_path
  function_name    = "morchella-tag-resource"
  role             = aws_iam_role.morchella_tag_resource.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.morchella_tag_resource.output_base64sha256
  runtime          = "python3.9"
  architectures    = ["arm64"]
  timeout          = var.lambda_timeout
  tags             = var.default_tags
}

#################################################################

resource "aws_iam_role" "morchella_update_node_status" {
  name               = "MorchellaUpdateNodeStatus-${data.aws_region.current.name}"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "morchella_update_node_status" {
  name   = "MorchellaUpdateNodeStatus-${data.aws_region.current.name}"
  role   = aws_iam_role.morchella_update_node_status.id
  policy = templatefile("${path.module}/${var.lambdas_code_path}/morchella_update_node_status/iam_policy.tftpl", { aws_region = data.aws_region.current.name })
}

# I had to manually add the trigger on the lambda function. Even though it's present on EventBridge, it doesn't get activated
resource "aws_lambda_function" "morchella_update_node_status" {
  filename         = data.archive_file.morchella_update_node_status.output_path
  function_name    = "morchella-update-node-status"
  role             = aws_iam_role.morchella_update_node_status.arn
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.morchella_update_node_status.output_base64sha256
  runtime          = "python3.9"
  architectures    = ["arm64"]
  timeout          = var.lambda_timeout
  tags             = var.default_tags
}


##################################################################


resource "aws_cloudwatch_event_rule" "morchella_update_after_provision" {
  name        = "morchella-update-after-provision"
  description = "Triggers the morchella-update-node-status lambda function after the node has been provisioned with SSM Distributor (deployed the Ansible Pull Agent)"

  event_pattern = <<EOF
{
  "source": ["aws.ssm"],
  "detail-type": ["EC2 State Manager Instance Association State Change"],
  "detail": {
    "status": ["Success"]
  }
}
EOF
  tags          = var.default_tags
}


resource "aws_cloudwatch_event_target" "morchella_update_after_provision" {
  rule      = aws_cloudwatch_event_rule.morchella_update_after_provision.name
  target_id = aws_lambda_function.morchella_update_node_status.id
  arn       = aws_lambda_function.morchella_update_node_status.arn
}

resource "aws_kms_key" "session_manager" {
  description = "KMS key for encrypting Session Manager data"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = [
          "kms:*"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key for Session Manager"
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action = [
          "kms:Encrypt*",
          "kms:Decrypt*",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}


resource "aws_ssm_document" "session_manager_prefs" {
  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = <<EOF
{
  "schemaVersion": "1.0",
  "description": "Document to hold regional settings for Session Manager",
  "sessionType": "Standard_Stream",
  "inputs": {
    "s3BucketName": "",
    "s3KeyPrefix": "",
    "s3EncryptionEnabled": true,
    "cloudWatchLogGroupName": "",
    "cloudWatchEncryptionEnabled": true,
    "idleSessionTimeout": "20",
    "maxSessionDuration": "",
    "cloudWatchStreamingEnabled": true,
    "kmsKeyId": "${aws_kms_key.session_manager.id}",
    "runAsEnabled": false,
    "runAsDefaultUser": "",
    "shellProfile": {
      "windows": "",
      "linux": ""
    }
  }
}
EOF
}
