resource "aws_kinesis_firehose_delivery_stream" "cwl_to_s3" {
  name        = "${var.project_name}-cwl-to-s3-delivery-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_to_s3.arn
    bucket_arn = aws_s3_bucket.cwl_to_s3.arn

    buffer_interval = 60
    buffer_size     = 128

    prefix              = "loggroup=!{partitionKeyFromLambda:logGroup}/logstream=!{partitionKeyFromLambda:logStream}/year=!{partitionKeyFromLambda:year}/month=!{partitionKeyFromLambda:month}/day=!{partitionKeyFromLambda:day}/hour=!{partitionKeyFromLambda:hour}/"
    error_output_prefix = "errors/result=!{firehose:error-output-type}/!{timestamp:yyyy/MM/dd}/"

    processing_configuration {
      enabled = "true"

      processors {
        type = "Lambda"

        parameters {
          parameter_name  = "LambdaArn"
          parameter_value = "${aws_lambda_function.logs_prosessor.arn}:$LATEST"
        }
      }
    }

    dynamic_partitioning_configuration {
      enabled = "true"
    }
  }
}
