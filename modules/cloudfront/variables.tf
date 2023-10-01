variable "bucket_name" {
  type        = string
  description = "S3 bucket names"
}

variable "create_s3" {
  type        = bool
  description = "Whether to create the S3 bucket"
}

variable "s3_origin_id" {
  type        = string
  description = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "create_origin_access_control" {
  description = "Controls if CloudFront origin access control should be created"
  type        = bool
  default     = false
}

variable "origin_access_control" {
  description = "Map of CloudFront origin access control"
  type = map(object({
    name             = string
    description      = string
    origin_type      = string
    signing_behavior = string
    signing_protocol = string
  }))

  default = {
    s3 = {
      name             = "s3"
      description      = "",
      origin_type      = "s3",
      signing_behavior = "always",
      signing_protocol = "sigv4"
    }
  }
}


variable "aliases" {
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  type        = list(string)
  default     = null
}

variable "comment" {
  description = "Any comments you want to include about the distribution."
  type        = string
  default     = null
}

variable "default_root_object" {
  description = "The object that you want CloudFront to return (for example, index.html) when an end user requests the root URL."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the distribution is enabled to accept end user requests for content."
  type        = bool
  default     = true
}

variable "http_version" {
  description = "The maximum HTTP version to support on the distribution. Allowed values are http1.1, http2, http2and3, and http3. The default is http2."
  type        = string
  default     = "http2"
}

variable "is_ipv6_enabled" {
  description = "Whether the IPv6 is enabled for the distribution."
  type        = bool
  default     = null
}

variable "price_class" {
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  type        = string
  default     = null
}

variable "retain_on_delete" {
  description = "Disables the distribution instead of deleting it when destroying the resource through Terraform. If this is set, the distribution needs to be deleted manually afterwards."
  type        = bool
  default     = false
}

variable "wait_for_deployment" {
  description = "If enabled, the resource will wait for the distribution status to change from InProgress to Deployed. Setting this to false will skip the process."
  type        = bool
  default     = true
}

variable "web_acl_id" {
  description = "If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and the credentials configuring this argument must have waf:GetWebACL permissions assigned. If using WAFv2, provide the ARN of the web ACL."
  type        = string
  default     = null
}

variable "default_cache" {
  description = "Configuration for default cache behavior"
  type = object({
    min_ttl                = number
    default_ttl            = number
    max_ttl                = number
    cached_methods         = list(string)
    allowed_methods        = list(string)
    viewer_protocol_policy = string
  })
  default = {
    min_ttl                = 0
    default_ttl            = 360
    max_ttl                = 8640
    cached_methods         = ["GET", "HEAD"]
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    viewer_protocol_policy = "redirect-to-https"
  }
}