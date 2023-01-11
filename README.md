# terraform-cwl-firehose-s3-sample

CloudWatch Logs から Kinesis Firehose を使って S3 にデータ配信するサンプルです。Lambda で以下を実施しています。

- ロググループ名をプレフィックスに付与
- ログストリーム名をプレフィックスに付与
- プレフィックスを UTC から JST に変換
- timestamp と message を抽出
