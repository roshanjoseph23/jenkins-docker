resource "aws_instance" "jenkinsserver" {

  ami                         = "ami-0be2609ba883822ec"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [ "sg-71d92e5c" ]
  key_name                    = "project"
  subnet_id                   = random_shuffle.sub.result[0]
  user_data                   = file("jenkins.sh")
  root_block_device {
    volume_size = "8"
  }
  tags = {
    Name = "Jenkins-server"
  }
}

output "Jenkins_Server_Public_IP" {
  value=aws_instance.jenkinsserver.public_ip
}

resource "aws_instance" "jenkinstest" {

  ami                         = "ami-0be2609ba883822ec"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [ "sg-71d92e5c" ]
  key_name                    = "project"
  subnet_id                   = random_shuffle.sub.result[0]
  root_block_device {
    volume_size = "8"
  }
  tags = {
    Name = "Jenkins-test"
  }
}

output "Jenkins_Test_Public_IP" {
  value = aws_instance.jenkinstest.private_ip
}

resource "aws_instance" "jenkinsbuild" {

  ami                         = "ami-0be2609ba883822ec"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [ "sg-71d92e5c" ]
  key_name                    = "project"
  subnet_id                   = random_shuffle.sub.result[0]
  root_block_device {
    volume_size = "8"
  }
  tags = {
    Name = "Jenkins-build"
  }
}

output "Jenkins_Build_Public_IP" {
  value = aws_instance.jenkinsbuild.private_ip
}