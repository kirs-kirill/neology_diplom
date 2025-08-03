# # https://yandex.cloud/ru/docs/ydb/terraform/dynamodb-tables
# provider "aws" {
#   region = var.location
#   endpoints {
#     dynamodb = yandex_ydb_database_serverless.diplom-ydb.document_api_endpoint
#   }
#   # profile = "default"
#   access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
#   secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
#   skip_credentials_validation = true
#   skip_metadata_api_check = true
#   skip_region_validation = true
#   skip_requesting_account_id = true
# }

# resource "yandex_ydb_database_serverless" "diplom-ydb" {
#   name                = "diplom-ydb"
#   location_id         = var.location  // https://github.com/yandex-cloud/terraform-provider-yandex/issues/524
#   deletion_protection = false

#   serverless_database {
#     enable_throttling_rcu_limit = false
#     storage_size_limit          = 1
#   }
# }

# # https://yandex.cloud/ru/docs/ydb/terraform/dynamodb-tables

# resource "aws_dynamodb_table" "diplomTable" {
#   name         = "diplomTable"
#   billing_mode = "PAY_PER_REQUEST"

#   hash_key = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }