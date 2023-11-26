# Terraform Beginner Bootcamp - Week 1

## Root Modules Structure

Our root module structure is as follow:

```
PROJECT_ROOT
|
├── main.tf              # everything else
├── variables.tf         # store the structure of input variables
├── providers.tf         # defined required providers and their configuration
├── outputs.tf           # stores our outputs
├── terraform-tfvars     # the data of variables we want to load into our terraform projects
└── README.md            # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)
