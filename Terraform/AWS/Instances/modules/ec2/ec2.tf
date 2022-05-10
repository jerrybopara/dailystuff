resource "aws_key_pair" "loginkey" {
  key_name   = "default_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDEbhb/BRshQriFfectBcXLAB6zzskRCSXfggNXkLWcotdCHBIw1QzZzPtsqOyJIy9CQ+/gagjl1XHYO4CLnNr40cdUnngNmk5p/noTugreK1u3MEf//tkgJfH83gTYYXbBMaKUIMKTDHIv1uhvVfaXT/zUkHu1nJsDz/rhv0vlT8S0AW8opqeM1Ae5Sb2odhQLxB1jGT0ysprukHAPG4pVMK+P2QtBq9o47Pk+Rss/mW3I0DVWvEjU75z8jqb9KOmzISJkn+PybCMyMz0mCRopqW4NF36BxV/CL30pDUhSB/e/nWjCoXdLmh0QaVeCWY+WQIshmMlU96sE0Q00Z2eOMZrwwV3ckebReuFl2toI5rYOpBu89vhnQlMHZgioasT4NfTvUz3p3qrn3DtuhIDx96gUd3yYjBsIMqYA4iKE/CXHTsqX4HhM4M+mRf3bTOEVhYPSzCiiHfWHGBEzT8lTmIj5iWYx6NckaaY0wBao/FNAbkWre1elZ27839gAMLc= jerry@ideapad"
}

resource "aws_instance" "instance" {
  count           = var.ec2_count
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  security_groups = var.sg_id

  key_name                    = "default_key"
  associate_public_ip_address = true


  tags = {
    Name = "${var.infra_env}-${var.instance_name}"
  }
}

