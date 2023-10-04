locals {
  tags = {
    owner    = "terraform"
    purpose  = "cicd"
    dept     = "devops"
    sub-dept = "cicd"
  }

}

resource "aws_iam_role" "jenkins_instance_role" {
  name = "Jenkins-${var.environment}-ci-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
  tags = local.tags
}

resource "aws_iam_policy" "s3_policy" {
  description = "Allow Jenkins Instanse to Access s3 Buckets"
  name        = "Jenkins-${var.environment}_s3_access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "JenkinsS3LimitedAccess",
        "Action" : [
          "s3:GetObject",
          "s3:GetObjectAttributes",
          "s3:GetObjectVersion",
          "s3:ListAccessPoints",
          "s3:ListAllMyBuckets",
          "s3:ListBucket",
          "s3:ListBuckets",
          "s3:ListObjectsV2",
          "s3:ListBucket",
          "s3:PutObject"
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::*temp*",
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  description = "Allow Jenkins Instanse to Access s3 Buckets"
  name        = "${var.environment}-jenkins_ecr_access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "JenkinsECRAccess",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:DeleteRegistryPolicy",
          "ecr:DeleteRepositoryPolicy",
          "ecr:DescribeImages",
          "ecr:DescribeRegistry",
          "ecr:DescribeRepositories",
          "ecr:GetAuthorizationToken",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:InitiateLayerUpload",
          "ecr:ListImages",
          "ecr:ListTagsForResource",
          "ecr:PutImage",
          "ecr:PutImageTagMutability",
          "ecr:PutLifecyclePolicy",
          "ecr:PutRegistryPolicy",
          "ecr:TagResource",
          "ecr:UploadLayerPart",
        ],
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:ecr:*:*:repository/temp*",
        ]
      }
    ]
  })
}

/* Attach created policies to Jenkins Role */

resource "aws_iam_role_policy_attachment" "s3_attachment" {

  role       = aws_iam_role.jenkins_instance_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecr_attachment" {

  role       = aws_iam_role.jenkins_instance_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}


output "jenkins_iam_role_name" {
  value = aws_iam_role.jenkins_instance_role.name
}
