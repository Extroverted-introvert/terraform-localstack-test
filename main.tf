provider "aws" {
  region = "us-east-1"  # Change to your preferred AWS region
}

data "archive_file" "lambda_code" {
  type        = "zip"
  source_file = "lambda_code/lambda_function.py"
  output_path = "lambda_code/lambda_code.zip"
}

resource "aws_lambda_function" "sum_function" {
  function_name = "sum_lambda"
  handler       = "lambda_function.handler"
  runtime       = "python3.8"
  filename      = "lambda_code/lambda_code.zip"  # Change to the actual path of your Lambda function code
  source_code_hash  = data.archive_file.lambda_code.output_base64sha256 # Change to the actual path of your Lambda function code
  role          = aws_iam_role.lambda_execution_role.arn
  timeout       = 10
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_api_gateway_rest_api" "my_api" {
  name        = "my_api"
  description = "My API Gateway"
}

resource "aws_api_gateway_resource" "my_resource" {
  rest_api_id = aws_api_gateway_rest_api.my_api.id
  parent_id   = aws_api_gateway_rest_api.my_api.root_resource_id
  path_part   = "sum"
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.my_api.id
  resource_id   = aws_api_gateway_resource.my_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.my_api.id
  resource_id             = aws_api_gateway_resource.my_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.sum_function.invoke_arn
}

resource "aws_lambda_permission" "allow_apigateway_invoke" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sum_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_api_gateway_rest_api.my_api.execution_arn
}
