resource "aws_s3_bucket" "test-bucket-2" {
  bucket = "test-bucket"
#   force_destroy = true
# }

# resource "null_resource" "empty_bucket" {
#   depends_on = [aws_s3_bucket.test-bucket-2]

#   provisioner "local-exec" {
#     command = "aws s3 rm s3://${aws_s3_bucket.test-bucket-2.bucket} --recursive --endpoint-url=http://localhost:4566 --profile localstack"
#   }
}