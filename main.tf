
resource "aws_s3_bucket" "data_team_bucketA" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
    Terraform =true
  }

   server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.mykey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  
   }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  enable_key_rotation = true
  policy = data.aws_iam_policy_document.key_policy.json
}
data "aws_caller_identity" "current"{}

data "aws_iam_policy_document" "key_policy" {
  statement {
    sid = "alllow root user access to this key"
    effect = "Allow"
    principals{
        type = "AWS"
        identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    
    actions = ["kms:*"]
    resources = ["*"]
  }

}