iam-account:

module "iam_account" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-account"

  account_alias = "awesome-company"

  minimum_password_length = 37
  require_numbers         = false
}
iam-assumable-role:

module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::307990089504:root",
    "arn:aws:iam::835367859851:user/anton",
  ]

  create_role = true

  role_name         = "custom"
  role_requires_mfa = true

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonCognitoReadOnly",
    "arn:aws:iam::aws:policy/AlexaForBusinessFullAccess",
  ]
  number_of_custom_role_policy_arns = 2
}
iam-assumable-role-with-oidc:

module "iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role = true

  role_name = "role-with-oidc"

  tags = {
    Role = "role-with-oidc"
  }

  provider_url = "oidc.eks.eu-west-1.amazonaws.com/id/BA9E170D464AF7B92084EF72A69B9DC8"

  role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  ]
  number_of_role_policy_arns = 1
}
iam-assumable-role-with-saml:

module "iam_assumable_role_with_saml" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-saml"

  create_role = true

  role_name = "role-with-saml"

  tags = {
    Role = "role-with-saml"
  }

  provider_id = "arn:aws:iam::235367859851:saml-provider/idp_saml"

  role_policy_arns = [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
  number_of_role_policy_arns = 1
}
iam-assumable-roles:

module "iam_assumable_roles" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles"

  trusted_role_arns = [
    "arn:aws:iam::307990089504:root",
    "arn:aws:iam::835367859851:user/anton",
  ]

  create_admin_role = true

  create_poweruser_role = true
  poweruser_role_name   = "developer"

  create_readonly_role       = true
  readonly_role_requires_mfa = false
}
iam-assumable-roles-with-saml:

module "iam_assumable_roles_with_saml" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-roles-with-saml"

  create_admin_role = true

  create_poweruser_role = true
  poweruser_role_name   = "developer"

  create_readonly_role = true

  provider_id   = "arn:aws:iam::235367859851:saml-provider/idp_saml"
}
iam-eks-role:

module "iam_eks_role" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-eks-role"

  role_name   = "my-app"

  cluster_service_accounts = {
    "cluster1" = ["default:my-app"]
    "cluster2" = [
      "default:my-app",
      "canary:my-app",
    ]
  }

  tags = {
    Name = "eks-role"
  }

  role_policy_arns = {
    AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }
}
iam-github-oidc-provider:

module "iam_github_oidc_provider" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"

  tags = {
    Environment = "test"
  }
}
iam-github-oidc-role:

module "iam_github_oidc_role" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-role"

  # This should be updated to suit your organization, repository, references/branches, etc.
  subjects = ["terraform-aws-modules/terraform-aws-iam:*"]

  policies = {
    S3ReadOnly = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  }

  tags = {
    Environment = "test"
  }
}
iam-group-with-assumable-roles-policy:

module "iam_group_with_assumable_roles_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-assumable-roles-policy"

  name = "production-readonly"

  assumable_roles = [
    "arn:aws:iam::835367859855:role/readonly"  # these roles can be created using `iam_assumable_roles` submodule
  ]

  group_users = [
    "user1",
    "user2"
  ]
}
iam-group-with-policies:

module "iam_group_with_policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name = "superadmins"

  group_users = [
    "user1",
    "user2"
  ]

  attach_iam_self_management_policy = true

  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]

  custom_group_policies = [
    {
      name   = "AllowS3Listing"
      policy = data.aws_iam_policy_document.sample.json
    }
  ]
}
iam-policy:

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "example"
  path        = "/"
  description = "My example policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
iam-read-only-policy:

module "iam_read_only_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-read-only-policy"

  name        = "example"
  path        = "/"
  description = "My example read-only policy"

  allowed_services = ["rds", "dynamo", "health"]
}
iam-role-for-service-accounts-eks:

module "vpc_cni_irsa" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name   = "vpc-cni"

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = "arn:aws:iam::012345678901:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/5C54DDF35ER19312844C7333374CC09D"
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = {
    Name = "vpc-cni-irsa"
  }
}
iam-user:

module "iam_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"

  name          = "vasya.pupkin"
  force_destroy = true

  pgp_key = "keybase:test"

  password_reset_required = false
}
