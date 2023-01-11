
data "archive_file" "logs_prosessor" {
  type        = "zip"
  source_dir  = "app/logs-prosessor"
  output_path = "archive/logs-prosessor/function.zip"
}

resource "aws_lambda_function" "logs_prosessor" {
  function_name = "${var.project_name}-logs-prosessor-function"
  handler       = "lambda.lambda_handler"
  role          = aws_iam_role.logs_prosessor.arn
  runtime       = "python3.9"

  filename         = data.archive_file.logs_prosessor.output_path
  source_code_hash = data.archive_file.logs_prosessor.output_base64sha256

  timeout     = 60
  memory_size = 128
}
