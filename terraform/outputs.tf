output "post_image_url" {
  value = aws_api_gateway_stage.aircall_post_stage.invoke_url
}

output "get_image_url" {
  value = aws_api_gateway_stage.aircall_get_stage.invoke_url
}

output "aws_lambda_function_id" {
  value = aws_lambda_function.aircall_test_lambda.id
}