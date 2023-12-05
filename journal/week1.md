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
├── terraform.tfvars     # the data of variables we want to load into our terraform projects
└── README.md            # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)


## Terraform and Input Variables

### Terraform Cloud Variables

In Terraform Cloud we can set two kind of variables:
 - Environment Variables
 - Terraform Variables

Both Terraform variables and environmental variables play important roles, but they serve different purposes and are used in different contexts:

#### Terraform Variables:

- **Definition:** Terraform variables are parameters defined within your Terraform configuration files. They are used to parameterize your infrastructure code and allow you to customize the behavior of your Terraform configurations.

> [!TIP]
> These are the ones that you normally set in your `terraform.tfvars` file. 

- **Scope:** Variables in Terraform can be defined at different levels, including in the main configuration file, in modules, or even passed as arguments when invoking a module.

- **Terraform Cloud Usage:** When working with Terraform Cloud, you can define workspace variables in the Terraform Cloud UI or API. These workspace variables serve a similar purpose to local Terraform variables but are managed centrally for a 
specific workspace.

- **Advantages:** Workspace variables in Terraform Cloud provide a convenient way to manage configuration values for different environments (e.g., development, staging, production) and support features like sensitive variables, default values, and overrides.

#### Environment Variables:**

> [!TIP]
> These are the ones that you would set in you bash terminal eg. AWS Credentials

**Definition:** Environmental variables are settings or values that are external to your Terraform configuration and are set at the environment level. These are typically set outside of your Terraform code, in the environment where Terraform is executed.

- **Scope:** Environmental variables are global to the process or session in which Terraform is running. They are not directly tied to a specific Terraform configuration or workspace.

- **Terraform Cloud Usage:** While environmental variables can be used in local Terraform runs, they are less commonly used in Terraform Cloud itself. This is because Terraform Cloud provides a dedicated mechanism for managing variables at the workspace level.

- **Advantages:** Environmental variables are useful for storing sensitive information or configuration settings that you don't want to include directly in your Terraform code or in Terraform Cloud. They provide a way to pass information to Terraform without modifying the configuration files.

#### Key Differences:**

- **Management:** Terraform variables are managed within the Terraform code and can be defined at different levels (e.g., workspace, module), while environmental variables are set externally to Terraform.

- **Granularity:** Terraform variables can be granular and specific to different parts of your infrastructure code, while environmental variables are typically global to the entire Terraform process.

- **Terraform Cloud Integration:** Terraform Cloud emphasizes the use of workspace variables for configuration management within the Terraform Cloud platform, making it more straightforward for teams to collaborate on infrastructure code.

In summary, while both Terraform variables and environmental variables are essential, Terraform variables (especially workspace variables in Terraform Cloud) are the primary mechanism for managing configuration values within the Terraform Cloud platform, providing a more integrated and structured approach to configuration management. Environmental variables are still relevant for local Terraform runs or when dealing with sensitive information outside of Terraform Cloud.

> [!IMPORTANT]
> We can set Terraform Cloud variables to be sensitive, so they are not visible in the UI.

### Loading Terraform Input Variables

#### var flag

The `-var` flag in Terraform is used to pass variable values from the command line when running Terraform commands such as terraform apply or terraform plan. This flag allows you to provide specific values for variables defined in your Terraform configuration files without modifying the configuration files themselves.

We can use the `var` flag to set an input variable or override a variable in `terraform.tfvars` file. eg `terraform plan -var user_id="Testing123"`

#### var-file flag

Additionally, if you have a `terraform.tfvars` file containing variable values, you can also use the `-var-file` flag to specify the path to the variable file. 

For example 
`terraform apply -var-file="path/to/terraform.tfvars"`

This allows you to keep sensitive or environment-specific variable values in a separate file, making it easier to manage configurations across different environments.

#### terraform.tfvars

The `terraform.tfvars` file is used to store variable values that are referenced in your Terraform configuration files (typically with a .tf extension). This file allows you to define and set values for variables, making it easier to manage and share configuration details without hardcoding them directly into your Terraform code.

terraform.tfvars example:
``` sh
example_var = "new_value"
```

#### auto.tfvars

When working with Terraform Cloud, the `auto.tfvars` file serves a similar purpose to the traditional terraform.tfvars file in local Terraform workflows. It provides a way to automatically load variable values without requiring explicit command-line flags or manual intervention. This can be especially convenient in automated or CI/CD environments.

Here's an example directory structure:

```plaintext
.
├── main.tf
├── variables.tf
└── auto.tfvars
```
In this example, `main.tf` contains your main Terraform configuration, `variables.tf `defines your variables, and `auto.tfvars` can be used to set default values for those variables.

It's important to note that while `auto.tfvars` provides a convenient way to automatically load variable values, it's just one option. Terraform Cloud also allows you to manage variables through the Terraform Cloud UI or API at the workspace level, providing a centralized and collaborative approach to configuration management.

#### Precedence of Terraform variables

 In Terraform, variable values can be set in multiple locations, and the precedence of these values determines which one takes effect. Here is the general order of precedence for Terraform variables:

1. **Environment Variables:**
   - Terraform checks for environment variables prefixed with `TF_VAR_`. For example, if you have a variable named `example_var`, Terraform will check for an environment variable named `TF_VAR_example_var` and use its value.

     ```bash
     export TF_VAR_example_var="value_from_env"
     ```

2. **Terraform Files:**
   - Variable values can be defined directly in the Terraform configuration files (`.tf` files) using the `variable` block.

     ```hcl
     variable "example_var" {
       type    = string
       default = "value_from_config_file"
     }
     ```

3. **`terraform.tfvars` and `*.auto.tfvars` Files:**
   - Terraform automatically loads values from files named `terraform.tfvars` or files with a `.auto.tfvars` extension. These files can contain variable definitions and values.

4. **CLI Flags:**
   - You can pass variable values directly from the command line using the `-var` flag. This allows you to override values defined in the Terraform configuration files or loaded from other sources.

     ```bash
     terraform apply -var="example_var=value_from_cli"
     ```

5. **Variable Defaults:**
   - If a variable has a default value specified in the Terraform configuration, that default value is used if no other value is provided.

     ```hcl
     variable "example_var" {
       type    = string
       default = "default_value"
     }
     ```

6. **Workspace Variables (Terraform Cloud):**
   - When using Terraform Cloud, variable values can be set at the workspace level through the Terraform Cloud UI or API. Workspace variables override values set in other locations.

7. **Variable Overrides in Runs (Terraform Cloud):**
   - When triggering a Terraform run in Terraform Cloud, you can override variable values for that specific run. These overrides take precedence over values set in other locations.

8. **Command Line Configuration (`-var` Flags and `-var-file` Flags):**
   - When running Terraform commands, you can use the `-var` and `-var-file` flags to specify variable values. Values provided through these flags take precedence over values set in other locations.

   ```bash
   terraform apply -var="example_var=value_from_cli" -var-file="path/to/override.tfvars"
   ```

In summary, variable values are determined by their precedence, with values set through environment variables taking the highest precedence and default values taking the lowest. Understanding this order helps you manage and control the values of variables in different environments and scenarios.


[Terraform Input Variables Documentation](https://developer.hashicorp.com/terraform/language/values/variables)

## Dealing With Configuration Drift

### What happen if we lose our state file?

If you lose your statefile, you most likely have to tear down all your cloud infrastructure manually.

You can use terraform import but it won't work for all cloud resources. You need to check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)

[S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

example: 
```sh
terraform import aws_s3_bucket.bucket bucket-name
```

### Fix Manual Configuration

If someone goes and delete or modifies cloud resource manually through clickops.

If we run Terraform plan again will attempt to put our infrastructure back into the expected state fixing the configuration drift.


