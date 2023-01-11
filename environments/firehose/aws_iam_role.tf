resource "aws_iam_role" "firehose_to_s3" {
  name = "${var.project_name}-firehose-to-s3-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "firehose_to_s3" {
  name = "${var.project_name}-firehose-to-s3-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.cwl_to_s3.arn}",
          "${aws_s3_bucket.cwl_to_s3.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "lambda:InvokeFunction",
          "lambda:GetFunctionConfiguration"
        ],
        Resource = [
          "${aws_lambda_function.logs_prosessor.qualified_arn}",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_to_s3" {
  role       = aws_iam_role.firehose_to_s3.name
  policy_arn = aws_iam_policy.firehose_to_s3.arn
}

resource "aws_iam_role" "cwl_to_firehose" {
  name = "${var.project_name}-cwl-to-firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "logs.${local.aws_region}.amazonaws.com"
        }
        Condition = {
          StringLike = {
            "aws:SourceArn" = "arn:aws:logs:${local.aws_region}:${local.aws_account_id}:*"
          }
        }
      },
    ]
  })
}

resource "aws_iam_policy" "cwl_to_firehose" {
  name = "${var.project_name}-cwl-to-firehose-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "firehose:PutRecord",
        ]
        Resource = [
          "${aws_kinesis_firehose_delivery_stream.cwl_to_s3.arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cwl_to_firehose" {
  role       = aws_iam_role.cwl_to_firehose.name
  policy_arn = aws_iam_policy.cwl_to_firehose.arn
}

resource "aws_iam_role" "logs_prosessor" {
  name = "${var.project_name}-logs-prosessor-funciton-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "logs_prosessor" {
  role       = aws_iam_role.logs_prosessor.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
