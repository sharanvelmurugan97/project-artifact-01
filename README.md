# AWS VPC + EC2 Infrastructure

Terraform project that provisions a VPC with public/private subnets and an EC2 instance with Docker, kubectl, and Terraform pre-installed.

## Architecture

- VPC (`10.0.0.0/16`)
- Public subnet (`10.0.1.0/24`) with Internet Gateway
- Private subnet (`10.0.2.0/24`)
- EC2 instance (Ubuntu, `t2.large`, 20GB gp3) in public subnet
- Security group allowing inbound traffic from your IP only

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- AWS CLI configured with valid credentials
- EC2 key pair named `terraform-key` in `us-east-1`

## Usage

```bash
terraform init
terraform plan
terraform apply
```

## Files

| File | Description |
|------|-------------|
| `main.tf` | VPC module configuration |
| `ec2.tf` | EC2 instance, security group, AMI lookup |
| `install.sh` | User data script (Docker, kubectl, Terraform) |

## Notes

- Security group auto-detects your public IP at apply time
- `install.sh` runs on first boot via cloud-init — check status with `cloud-init status` on the instance
- SSH access: `ssh -i terraform-key.pem ubuntu@<public-ip>`
