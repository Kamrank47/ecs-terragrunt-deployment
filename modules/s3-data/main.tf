resource "aws_s3_bucket" "ecs_data" {
  bucket        = "${var.environment}-nestjs-app-storage"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket_cors_configuration" "ecs_data_cors" {
  bucket = aws_s3_bucket.ecs_data.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE"]
    allowed_origins = ["https://your-frontend.vercel.app"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
