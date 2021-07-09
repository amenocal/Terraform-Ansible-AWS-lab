#Create SG for LB

resource "aws_security_group" "lb-sg" {
  provider    = aws.region-master
  name        = "lb-sg"
  description = "Allow 443 and traffic to Jenkins SG"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow 443 from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#Create SG for Jenkins-Master

resource "aws_security_group" "jenkins-sg" {
  provider    = aws.region-master
  name        = "jenkins-sg"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = aws_vpc.vpc_master.id
  ingress {
    description = "Allow 22 from public IP"
    cidr_blocks = [var.external_ip]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    description     = "Allow anyone on port 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.lb-sg.id]
  }
  ingress {
    description = "Allow traffic from us-west-2"
    cidr_blocks = ["192.168.1.0/24"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#Create SG for Jenkins-Worker

resource "aws_security_group" "jenkins-sg-oregon" {
  provider    = aws.region-worker
  name        = "jenkins-sg-oregon"
  description = "Allow TCP/8080 & TCP/22"
  vpc_id      = aws_vpc.vpc_master_oregon.id
  ingress {
    description = "Allow 22 from public IP"
    cidr_blocks = [var.external_ip]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  ingress {
    description = "Allow traffic from us-east-1"
    cidr_blocks = ["10.0.1.0/24"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}