# HUG Terraform Challenge — Week Three

A secure, two-tier application on AWS provisioned with Terraform: an Nginx web
server in a public subnet and a PostgreSQL RDS database in private subnets, with
least-privilege security groups and remote state.

## Architecture

```
                          Internet
                             |
                     [Internet Gateway]
                             |
        VPC 10.0.0.0/16      |
        ┌────────────────────┼─────────────────────────────┐
        │  Public subnet (10.0.0.0/24)                      │
        │    - EC2 (Nginx)  <— HTTP:80 from internet        │
        │                   <— SSH:22 from admin IP only    │
        │    - NAT Gateway (+ EIP)                          │
        │                                                   │
        │  Private subnets (10.0.1.0/24, 10.0.2.0/24)       │
        │    - RDS PostgreSQL                                │
        │        <— 5432 from compute SG only               │
        │        outbound —> NAT Gateway                     │
        └───────────────────────────────────────────────────┘
```

- **Public route table** routes `0.0.0.0/0` to the Internet Gateway.
- **Private route table** routes `0.0.0.0/0` to the NAT Gateway (egress only).
- The database spans **two** private subnets (two AZs), as RDS requires.

## Module layout

| Module | Responsibility |
|--------|----------------|
| `modules/vpc` | VPC with DNS support/hostnames enabled |
| `modules/networking` | Subnets, IGW, NAT Gateway + EIP, route tables & associations |
| `modules/security_group` | Compute SG (SSH/HTTP) and Database SG (DB port from compute SG only) |
| `modules/instance` | EC2 web server; Ubuntu 22.04 LTS via AMI data source; Nginx via user_data |
| `modules/database` | RDS PostgreSQL, DB subnet group, `publicly_accessible = false` |
| `bootstrap/` | One-time S3 bucket for remote Terraform state |

## Security groups (least privilege)

- **Compute SG**: inbound `80/tcp` from `0.0.0.0/0`; inbound `22/tcp` from your IP
  only (`ssh_cidr`); all outbound.
- **Database SG**: inbound `5432/tcp` from the **compute SG** (source security
  group, not a CIDR); all outbound. The DB is never publicly accessible.

## Prerequisites

- Terraform `>= 1.10.0`
- AWS CLI configured with a profile (default: `terraform-lab`)
- An AWS account with permissions for VPC, EC2, RDS, and S3

## Configuration

Create a `.env` file (gitignored) in the project root:

```dotenv
ENVIRONMENT=dev
TF_VAR_db_password=<a-strong-password>
```

Key variables (see `main.tf` for the full list and defaults):

| Variable | Default | Description |
|----------|---------|-------------|
| `region` | `us-east-1` | AWS region |
| `vpc_cidr` | `10.0.0.0/16` | VPC CIDR |
| `public_cidr_block` | `10.0.0.0/24` | Public subnet CIDR |
| `private_cidr_blocks` | `["10.0.1.0/24","10.0.2.0/24"]` | Private subnet CIDRs |
| `instance_type` | `t3.micro` | EC2 instance type |
| `db_instance_class` | `db.t3.micro` | RDS instance class |
| `db_allocated_storage` | `20` | RDS storage (GiB) |
| `db_port` | `5432` | Database port |
| `db_password` | — | **Required**, provided via `.env` |
| `ssh_cidr` | — | Set automatically by the Makefile to your current IP |

## Deployment

The `Makefile` wraps the full workflow.

```bash
# 1. Bootstrap the remote state bucket (one time) and initialise the backend
make setup

# 2. Review the plan (auto-detects your public IP for the SSH rule)
make plan

# 3. Apply
make apply

# ...or plan + apply in one step
make deploy

# 4. Verify the web server responds
make verify
```

`make plan` runs `terraform fmt` and `validate` first, detects your public IP
via `checkip.amazonaws.com`, and writes the SSH rule for that `/32` only.

## Outputs

| Output | Description |
|--------|-------------|
| `instance_public_ip` | Public IP of the Nginx web server |
| `vpc_id` | VPC id |
| `public_subnet_id` | Public subnet id |
| `private_subnet_ids` | Private subnet ids |
| `db_endpoint` | RDS connection endpoint |

## Teardown

```bash
make destroy          # destroy the application stack
make destroy-backend  # destroy the state bucket (after destroy)
make destroy-all      # both, in order
```

## Remote state

State is stored in an S3 bucket (versioned, encrypted, native lockfile) created
by the `bootstrap/` configuration. The backend `key` is
`hug-tf-week-three/terraform.tfstate`.

## Deliverables checklist

- [ ] Terraform code (this repository)
- [ ] README with deployment instructions (this file)
- [ ] Screenshot of the VPC
- [ ] Screenshot of the EC2 instance running
- [ ] Screenshot of the RDS database running
- [ ] Screenshot of the webpage (`http://<instance_public_ip>`)
- [ ] LinkedIn post tagging HUG Lagos and HUG Ibadan
