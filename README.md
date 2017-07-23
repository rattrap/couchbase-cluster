# Creates a Couchbase cluster and a set of PHP workers on AWS

## Terraform
```
cd infrastructure
terraform get
terraform plan
terraform apply
```
## Ansible
```
ansible-playbook couchbase.yml -i hosts
ansible-playbook app.yml -i hosts
```