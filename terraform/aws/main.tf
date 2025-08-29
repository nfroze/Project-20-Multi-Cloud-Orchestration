resource "aws_key_pair" "p20" {
  key_name   = "${var.project_name}-key"
  public_key = file("${path.module}/../keys/p20-key.pub")
}

resource "aws_instance" "p20" {
  ami           = "ami-0b4c7755cdf0d9219"  # Amazon Linux 2023 in eu-west-2
  instance_type = var.instance_type
  key_name      = aws_key_pair.p20.key_name
  
  vpc_security_group_ids = [aws_security_group.p20.id]
  
  tags = {
    Name = "${var.project_name}-aws"
  }
}

resource "aws_security_group" "p20" {
  name_prefix = "${var.project_name}-"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}