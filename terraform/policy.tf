resource "aws_iam_policy" "aircall_lambda_policy" {
  name   = "aircall-lambda-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : [ aws_s3_bucket.aircall_bucket.arn,
        "${aws_s3_bucket.aircall_bucket.arn}/*" ]
      },
      {
        Action : [
          "logs:CreateLogGroup"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      },
      {
        Action : [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Effect : "Allow"
        Resource : "arn:aws:s3:::${aws_s3_bucket.aircall_bucket.id}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aircall_lambda_policy_attachment" {
  role = aws_iam_role.aircall_lambda_role.id
  policy_arn = aws_iam_policy.aircall_lambda_policy.arn
}