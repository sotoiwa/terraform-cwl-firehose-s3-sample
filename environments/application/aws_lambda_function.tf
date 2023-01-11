
data "archive_file" "hello" {
  type        = "zip"
  source_dir  = "app/hello"
  output_path = "archive/hello/function.zip"
}

resource "aws_lambda_function" "hello" {
  function_name = "${var.project_name}-hello-function"
  handler       = "lambda.lambda_handler"
  role          = aws_iam_role.hello.arn
  runtime       = "python3.9"

  filename         = data.archive_file.hello.output_path
  source_code_hash = data.archive_file.hello.output_base64sha256

  timeout     = 3
  memory_size = 128
}

resource "aws_lambda_permission" "hello" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hello.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.hello.arn
}
