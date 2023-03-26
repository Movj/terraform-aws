output "apigw_invoke_url" {
  value = "${aws_api_gateway_stage.test_stage.invoke_url}/${aws_api_gateway_resource.test_resource.path_part}"
}