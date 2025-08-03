output "access_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  sensitive = true
}

output "secret_key" {
  value     = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  sensitive = true
}

# output "dynamodb" {
#   value     = yandex_ydb_database_serverless.diplom-ydb.document_api_endpoint
#   sensitive = true
# }