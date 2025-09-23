Initialize Terraform

```bash
terraform init -backend-config=dev.tfbackend
```

Plan Terraform

```bash
terraform plan -var-file=dev.tfvars
```