terraform {
  required_version = ">= 1.6.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0, < 7.0"
    }
  }

  # Remote state must be encrypted, versioned and access-controlled. Bootstrap
  # this bucket once (outside this root), then uncomment:
  #
  # backend "gcs" {
  #   bucket = "REPLACE-with-your-tfstate-bucket"
  #   prefix = "ai-security-control-model/sandbox"
  # }
}
