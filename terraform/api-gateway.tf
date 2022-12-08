resource "aws_api_gateway_rest_api" "aircall-api-gateway-test" {
  api_key_source               = "HEADER"
  binary_media_types           = ["*/*"]
  disable_execute_api_endpoint = "false"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
  name                     = "aircall-api-gateway-test"
}

# Resources inside API 

resource "aws_api_gateway_resource" "aircall_post_image" {
  rest_api_id = aws_api_gateway_rest_api.aircall-api-gateway-test.id
  parent_id   = aws_api_gateway_rest_api.aircall-api-gateway-test.root_resource_id
  path_part   = "{image}"
}

resource "aws_api_gateway_resource" "aircall_get_image" {
  rest_api_id = aws_api_gateway_rest_api.aircall-api-gateway-test.id
  parent_id   = aws_api_gateway_rest_api.aircall-api-gateway-test.root_resource_id
  path_part   = "bucket"
}

# Methods inside API 

resource "aws_api_gateway_method" "aircall_post_method" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "POST"

  request_parameters = {
    "method.request.path.bucket" = "true"
  }

  resource_id = aws_api_gateway_resource.aircall_post_image.id
  rest_api_id = aws_api_gateway_rest_api.aircall-api-gateway-test.id
}

resource "aws_api_gateway_method" "aircall_get_method" {
  api_key_required = "false"
  authorization    = "NONE"
  http_method      = "GET"

  request_parameters = {
    "method.request.querystring.file" = "true"
  }

  resource_id = aws_api_gateway_resource.aircall_get_image.id
  rest_api_id = aws_api_gateway_rest_api.aircall-api-gateway-test.id
}

resource "aws_api_gateway_integration" "aircall_post_integration" {
  cache_namespace         = aws_api_gateway_resource.aircall_post_image.id
  connection_type         = "INTERNET"
  content_handling        = "CONVERT_TO_TEXT"
  http_method             = "POST"
  integration_http_method = "POST"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = aws_api_gateway_resource.aircall_post_image.id
  rest_api_id             = aws_api_gateway_rest_api.aircall-api-gateway-test.id
  timeout_milliseconds    = "29000"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:eu-west-1:lambda:path/2015-03-31/functions/arn:aws:lambda:eu-west-1:567673205078:function:aircalltest-lambda/invocations"
}

resource "aws_api_gateway_integration" "aircall_get_integration" {
  cache_namespace         = aws_api_gateway_resource.aircall_get_image.id
  connection_type         = "INTERNET"
  credentials             = aws_iam_role.aircall_api_gateway.arn
  http_method             = "GET"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  resource_id             = aws_api_gateway_resource.aircall_get_image.id
  rest_api_id             = aws_api_gateway_rest_api.aircall-api-gateway-test.id
  timeout_milliseconds    = "29000"
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:eu-west-1:s3:path/aircall-test/"
}

resource "aws_api_gateway_integration_response" "aircall_post_integration_response" {
  http_method = "POST"
  resource_id = aws_api_gateway_integration.aircall_post_integration.id
  rest_api_id = aws_api_gateway_rest_api.aircall-api-gateway-test.id
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "aircall_get_integration_response" {
  http_method = "GET"
  resource_id = aws_api_gateway_integration.aircall_get_integration.id
  rest_api_id = aws_api_gateway_rest_api.aircall-api-gateway-test.id
  status_code = "200"
}



# Deploy the api 

resource "aws_api_gateway_stage" "aircall_get_stage" {
  cache_cluster_enabled = "false"
  deployment_id         = "fw5obo"
  rest_api_id           = aws_api_gateway_rest_api.aircall-api-gateway-test.id
  stage_name            = "get"
  xray_tracing_enabled  = "true"
}

resource "aws_api_gateway_stage" "aircall_post_stage" {
  cache_cluster_enabled = "false"
  deployment_id         = "iyqjoi"
  rest_api_id           = aws_api_gateway_rest_api.aircall-api-gateway-test.id
  stage_name            = "post"
  xray_tracing_enabled  = "true"
}

# Method Response

resource "aws_api_gateway_method_response" "aircall_post_response" {
  http_method = "POST"
  resource_id = aws_api_gateway_method.aircall_post_method.id

  response_models = {
    "application/json" = "Empty"
  }

  rest_api_id = aws_api_gateway_rest_api.aircall-api-gateway-test.id
  status_code = "200"
}

resource "aws_api_gateway_method_response" "aircall_get_response" {
  http_method = "GET"
  resource_id = aws_api_gateway_method.aircall_get_method.id

  response_models = {
    "application/json" = "Empty"
  }

  rest_api_id = aws_api_gateway_rest_api.aircall-api-gateway-test.id
  status_code = "200"
}

resource "aws_lambda_permission" "lambda_test_permission" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aircall_test_lambda.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:eu-west-1:567673205078:${aws_api_gateway_rest_api.aircall-api-gateway-test.id}/*/POST/*"
  statement_id  = "4f823635-c698-4354-b6a8-e1e702373496"
}