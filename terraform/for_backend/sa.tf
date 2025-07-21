# Создаем сервисный аккаунт с правами на редактирование

resource "yandex_iam_service_account" "sa" {
  name        = "diplom"
  description = "diplom-sa"
  folder_id   = var.folder_id
}

# https://yandex.cloud/ru/docs/iam/operations/sa/assign-role-for-sa

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}