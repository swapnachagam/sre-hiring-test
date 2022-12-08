resource "aws_lambda_function" "aircall_test_lambda" {

  environment {
    variables = {
      S3_BUCKET = "aircall-test"
    }
  }

  ephemeral_storage {
    size = "512"
  }

  function_name                  = "aircalltest-lambda"
  image_uri                      = var.image_url
  memory_size                    = "128"
  package_type                   = "Image"
  role                           = aws_iam_role.aircall_lambda_role.arn
  timeout                        = "60"

  tracing_config {
    mode = "PassThrough"
  }
}

