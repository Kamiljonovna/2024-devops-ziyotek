resource "aws_instance" "web_server1" {
  ami                         = var.ec2_ami_id 
  subnet_id                   = aws_subnet.tory_subnet_public.id
  vpc_security_group_ids      = [aws_security_group.tory_security_group.id]
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type 
  key_name                    = aws_key_pair.deployer.key_name
  ebs_optimized               = var.ebs_optimize
  secondary_private_ips       = var.secondary_private_ips
  availability_zone           = var.az
  iam_instance_profile        = aws_iam_instance_profile.test_profile.id
}  

resource "tls_private_key" "rsa-4096-example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "ziyotek-key"
  public_key = tls_private_key.rsa-4096-example.public_key_openssh
}

resource "aws_ssm_parameter" "bar" {
  name  = "tory-key.pem"
  type  = "String"
  value = tls_private_key.rsa-4096-example.private_key_pem
}
