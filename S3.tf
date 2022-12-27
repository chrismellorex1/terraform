module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket"
  acl    = "private"

  versioning = {
    enabled = true
  }

}
#Bucket with ELB access log delivery policy attached
module "s3_bucket_for_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket-for-logs"
  acl    = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true

  attach_elb_log_delivery_policy = true
}
#Bucket with ALB/NLB access log delivery policy attached
module "s3_bucket_for_logs" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket-for-logs"
  acl    = "log-delivery-write"

  # Allow deletion of non-empty bucket
  force_destroy = true

  attach_elb_log_delivery_policy = true  # Required for ALB logs
  attach_lb_log_delivery_policy  = true  # Required for ALB/NLB logs
}
#Conditional creation
#Sometimes you need to have a way to create S3 resources conditionally but Terraform does not allow to use count inside module block, so the solution is to specify argument create_bucket.

# This S3 bucket will not be created
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  create_bucket = false
  # ... omitted
}
