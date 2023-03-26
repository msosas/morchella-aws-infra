# IAM

resource "aws_iam_user" "morchella" {
  name = "morchella"
  path = "/morchella/"

  tags = var.default_tags
}

resource "aws_iam_access_key" "morchella" {
  user = aws_iam_user.morchella.name
}

resource "aws_iam_user_policy" "morchella" {
  name = "MorchellaAccessPolicy"
  user = aws_iam_user.morchella.name

  policy = templatefile("${path.module}/iam-policy.tftpl", { bucket_name = var.morchella_regional_bucket_name_pattern })
}

# S3

resource "aws_s3_bucket" "morchella_nodes" {
  bucket = "${var.morchella_nodes_s3_name}-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket_public_access_block" "morchella_nodes" {
  bucket = aws_s3_bucket.morchella_nodes.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "morchella_nodes" {
  bucket = aws_s3_bucket.morchella_nodes.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_iam_role" "run_command_role" {
  name               = "AmazonEC2RunCommandRoleForManagedInstances"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ssm.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.run_command_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm_directory_service_access" {
  role       = aws_iam_role.run_command_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
}

resource "aws_iam_policy" "ssm_kms_access" {
  name        = "MorchellaKMSAccessforSSM"
  path        = "/morchella/"
  description = "It give KMS access to SSM Session Manager"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ssmmessages:CreateControlChannel",
                "ssmmessages:CreateDataChannel",
                "ssmmessages:OpenControlChannel",
                "ssmmessages:OpenDataChannel"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetEncryptionConfiguration"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm_kms_access" {
  role       = aws_iam_role.run_command_role.id
  policy_arn = aws_iam_policy.ssm_kms_access.arn
}


resource "aws_iam_policy" "morchella_slack_bot" {
  name = "MorchellaSlackBot"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = ["${aws_s3_bucket.morchella_nodes.arn}", "${aws_s3_bucket.morchella_nodes.arn}/*"]
      }
    ]
  })
}

resource "aws_iam_role" "morchella_slack_bot" {
  name = "MorchellaSlackBot"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::055313672806:root"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "morchella_slack_bot" {
  policy_arn = aws_iam_policy.morchella_slack_bot.arn
  role       = aws_iam_role.morchella_slack_bot.name
}

