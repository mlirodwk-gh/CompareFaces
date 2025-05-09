resource "aws_lambda_function" "html_lambda" {
  filename         = "faceRecoFunc.zip"
  function_name    = "faceRecoLambdaFunc"
  role             = aws_iam_role.lambda_role.arn
  handler          = "faceRecoFunc.lambda_handler"
  runtime          = "python3.9"
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

#resource "aws_iam_role_policy_attachment" "lambda_basic" {
#  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#  role       = aws_iam_role.lambda_role.name
#}


resource "aws_iam_role_policy_attachment" "lambda_AWSLambdaExecute" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "AmazonRekognitionFullAccess" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRekognitionFullAccess"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.html_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api_gw_lambda_func.execution_arn}/*/*/*"
}

data "archive_file" "lambda_package" {
  type        = "zip"
  source_file = "faceRecoFunc.py"
  output_path = "faceRecoFunc.zip"
}

