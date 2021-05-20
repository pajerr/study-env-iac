resource "aws_key_pair" "ciserver" {
  key_name   = "ciserver"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}
