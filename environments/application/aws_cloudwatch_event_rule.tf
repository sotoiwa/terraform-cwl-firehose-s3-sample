resource "aws_cloudwatch_event_rule" "hello" {
  name                = "${var.project_name}-hello-rule"
  schedule_expression = "cron(* * * * ? *)"
}

resource "aws_cloudwatch_event_target" "hello" {
  rule = aws_cloudwatch_event_rule.hello.id
  arn  = aws_lambda_function.hello.arn
}
