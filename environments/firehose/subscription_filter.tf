resource "aws_cloudwatch_log_subscription_filter" "logfilter" {
  name            = "${var.project_name}-logfilter"
  role_arn        = aws_iam_role.cwl_to_firehose.arn
  log_group_name  = var.log_group_name
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.cwl_to_s3.arn
}
