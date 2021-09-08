locals {
  principal_type = var.assumable_type == "service" ? "Service" : "AWS"
}

resource "aws_iam_role" "role" {
  name = var.name
  path = var.path

  assume_role_policy = data.aws_iam_policy_document.policy.json
}

data "aws_iam_policy_document" "policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      identifiers = [
        var.assumable_identifier
      ]
      type        = local.principal_type
    }
    dynamic "condition" {
      for_each = compact([var.assumable_additional_id])
      content {
        test     = "StringEquals"
        values   = [condition.value]
        variable = "sts:ExternalId"
      }
    }
  }
}

resource "aws_iam_role_policy" "inline_policy" {
  count = length(var.policy_documents)
  role  = aws_iam_role.role.id

  policy = element(var.policy_documents, count.index)
}

resource "aws_iam_role_policy_attachment" "attached_policy" {
  count = length(var.policy_arns)
  role  = aws_iam_role.role.id

  policy_arn = element(var.policy_arns, count.index)
}
