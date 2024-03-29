resource "aws_iam_user" "this" {
  name = var.name
  path = "/serviceaccounts/"
}

resource "aws_iam_user_policy_attachment" "this" {
  user       = aws_iam_user.this.name
  policy_arn = var.policy_arn
}

resource "aws_iam_access_key" "this" {
  user = aws_iam_user.this.name
}
