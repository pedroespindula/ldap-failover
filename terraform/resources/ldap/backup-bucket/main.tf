resource "aws_s3_bucket" "this" {
  bucket = "lsd-ldap-backup"
}

module "serviceaccount" {
  source = "../../../modules/iam-serviceaccount"

  name       = "backuper"
  policy_arn = aws_iam_policy.allow-lsd-ldap-backup-bucket-access.arn
}
