output "codepipeline_name" {
  value = aws_codepipeline.app_pipeline.name
}

output "artifacts_bucket" {
  value = aws_s3_bucket.artifacts.bucket
}

output "pipeline_notifications_sns_topic_arn" {
  value = aws_sns_topic.pipeline_notifications.arn
}