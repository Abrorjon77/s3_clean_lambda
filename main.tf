


resource "aws_lambda_function" "s3_cleanup" {
  filename      = "s3_cleanup.zip"
  function_name = "s3_cleanup"
  role          = aws_iam_role.lambda.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.8"
  timeout       = 60

  environment {
    variables = {
      BUCKET_NAME = "my-s3-bucket"
    }
  }
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "s3_cleanup.py"

  output_path = "s3_cleanup.zip"
}

resource "aws_iam_role" "lambda" {
  name = "lambda-s3-cleanup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "lambda" {
  name       = "lambda-s3-cleanup-attachment"
  policy_arn = aws_iam_policy.lambda.arn
  roles      = [aws_iam_role.lambda.name]
}

resource "aws_iam_policy" "lambda" {
  name = "lambda-s3-cleanup-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}

locals {
  cron_expression = "cron(0 0 ? * SUN *)"
}

resource "aws_cloudwatch_event_rule" "s3_cleanup" {
  name        = "s3_cleanup"
  description = "Runs the s3_cleanup Lambda every Sunday"
  schedule_expression = local.cron_expression
}

resource "aws_cloudwatch_event_target" "s3_cleanup" {
  target_id = "s3_cleanup"
  arn       = aws_lambda_function.s3_cleanup.arn
  rule      = aws_cloudwatch_event_rule.s3_cleanup.name 
}

