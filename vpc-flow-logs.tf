# Create CloudWatch Log Group for flow logs
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/vpc/flowlogs"
  retention_in_days = 7

  tags = {
    Name = "vpc-flow-logs"
  }
}

# Create IAM role for VPC flow logs
resource "aws_iam_role" "vpc_flow_logs_role" {
  name = "vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        },
        Effect = "Allow",
        Sid    = ""
      }
    ]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "vpc_flow_logs_attach" {
  role       = aws_iam_role.vpc_flow_logs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

# Enable VPC Flow Logs
resource "aws_flow_log" "vpc_flow_logs" {
  log_destination_type = "cloud-watch-logs"
  log_group_name       = aws_cloudwatch_log_group.vpc_flow_logs.name
  iam_role_arn         = aws_iam_role.vpc_flow_logs_role.arn
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.main.id

  tags = {
    Name = "vpc-flow-log"
  }
}


resource "aws_kms_key" "cloudwatch_logs" {
  description             = "KMS CMK for CloudWatch Log Group encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "secure_log_group" {
  name              = "/app/my-super-secure-logs"
  retention_in_days = 7
  kms_key_id        = aws_kms_key.cloudwatch_logs.arn # 👈 Use CMK here

  tags = {
    Environment = "dev"
    Owner       = "devops"
  }
}
