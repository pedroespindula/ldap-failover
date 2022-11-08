resource "aws_iam_policy" "allow-lsd-ldap-backup-bucket-access" {
  name        = "allow-lsd-ldap-backup-bucket-access"
  path        = "/"
  description = "Allow access to service to LSD LDAP Backup bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:ListBucket",
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.this.arn
        ]
      },
      {
        Action = [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.this.arn}/*"
        ]
      },
    ]
  })
}

