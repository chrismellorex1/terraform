module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda1"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "../src/lambda-function1"

  tags = {
    Name = "my-lambda1"
  }
}
#Lambda Function and Lambda Layer (store packages on S3)
module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "lambda-with-layer"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"
  publish       = true

  source_path = "../src/lambda-function1"

  store_on_s3 = true
  s3_bucket   = "my-bucket-id-with-lambda-builds"

  layers = [
    module.lambda_layer_s3.lambda_layer_arn,
  ]

  environment_variables = {
    Serverless = "Terraform"
  }

  tags = {
    Module = "lambda-with-layer"
  }
}

module "lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "lambda-layer-s3"
  description         = "My amazing lambda layer (deployed from S3)"
  compatible_runtimes = ["python3.8"]

  source_path = "../src/lambda-layer"

  store_on_s3 = true
  s3_bucket   = "my-bucket-id-with-lambda-builds"
}
#Lambda Functions with existing package (prebuilt) stored locally
module "lambda_function_existing_package_local" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-existing-package-local"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  create_package         = false
  local_existing_package = "../existing_package.zip"
}

module "lambda_function_externally_managed_package" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-externally-managed-package"
  description   = "My lambda function code is deployed separately"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  create_package         = false
  local_existing_package = "./lambda_functions/code.zip"

  ignore_source_code_hash = true
}

locals {
  my_function_source = "../path/to/package.zip"
}

resource "aws_s3_bucket" "builds" {
  bucket = "my-builds"
  acl    = "private"
}

resource "aws_s3_object" "my_function" {
  bucket = aws_s3_bucket.builds.id
  key    = "${filemd5(local.my_function_source)}.zip"
  source = local.my_function_source
}

module "lambda_function_existing_package_s3" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-existing-package-local"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  create_package      = false
  s3_existing_package = {
    bucket = aws_s3_bucket.builds.id
    key    = aws_s3_object.my_function.id
  }
}
module "lambda_function_container_image" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-existing-package-local"
  description   = "My awesome lambda function"

  create_package = false

  image_uri    = "132367819851.dkr.ecr.eu-west-1.amazonaws.com/complete-cow:1.0"
  package_type = "Image"
}
module "lambda_layer_local" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "my-layer-local"
  description         = "My amazing lambda layer (deployed from local)"
  compatible_runtimes = ["python3.8"]

  source_path = "../fixtures/python3.8-app1"
}

module "lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"

  create_layer = true

  layer_name          = "my-layer-s3"
  description         = "My amazing lambda layer (deployed from S3)"
  compatible_runtimes = ["python3.8"]

  source_path = "../fixtures/python3.8-app1"

  store_on_s3 = true
  s3_bucket   = "my-bucket-id-with-lambda-builds"
}

module "lambda_at_edge" {
  source = "terraform-aws-modules/lambda/aws"

  lambda_at_edge = true

  function_name = "my-lambda-at-edge"
  description   = "My awesome lambda@edge function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "../fixtures/python3.8-app1"

  tags = {
    Module = "lambda-at-edge"
  }
}
#Lambda Function in VPC
module "lambda_function_in_vpc" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "my-lambda-in-vpc"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  source_path = "../fixtures/python3.8-app1"

  vpc_subnet_ids         = module.vpc.intra_subnets
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  attach_network_policy = true
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.10.0.0/16"

  # Specify at least one of: intra_subnets, private_subnets, or public_subnets
  azs           = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  intra_subnets = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
}
