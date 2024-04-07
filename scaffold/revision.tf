resource "terraform_data" "flatcar_release" {
  input = local.distros.flatcar.version
}
