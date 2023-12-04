## Que pasa si perdemos el terraform state file?

Si perdemos el tfstate debemos "importar" nuestros recursos a Terraform, podemos utilizar el comando `terraform import` o también un block `import`, primero voy a probar con el comando `import`

1. Importar el bucket S3

De acuerdo a la documentación del [provider AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import):

`terraform import aws_s3_bucket.example mybucket-qrtrlolnx8hbxaui `

El `example` viene de como lo declaramos en el `main.tf`, y el `mybucket-qrtrlolnx8hbxaui` lo sacamos el recurso actual en AWS.

2. Importar el random_string

Como estamos usando un nombre aleatorio utilizando el proveedor random, también debemos importarlo, porque si no, al correr el `terraform apply` lo que va pasar es que va crear un bucket nuevo con otro nombre aleatorio. 

Siguiendo la documentación (https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string#import),corremos el comando:

`terraform import random_string.bucket_name qrtrlolnx8hbxaui`

UPDATE: al final no resulto como se esperaba, porque al darle `terraform plan` decía que iba a remplazar el bucket con uno nuevo. (Empezamos a ver que quizás utilizar random no es una buena idea).

Lo que vamos a hacer es que vamos a quitar el randomness del nombre del bucket y lo vamos a declarar explicitamente con el mismo nombre que ya tiene, a travez de una variable.

2.1 Borrar el proveedor random de `providers.tf`

2.2 Borrar el `random_string` de `main.tf`

2.3 Modificar el nombre del bucket en `main.tf` para que sea una variable

`bucket = var.bucket_name`

En mi caso también voy a eliminar la parte de `locals`, donde concatenaba la cadena aleatorio con "mybucket-" y lo voy a agregar directamente en el valor de la variable.

2.4 Definir la variable en `variables.tf` y validar que sea un nombre de bucket valido (con ayuda de ChatGPT)

```sh
variable "bucket_name" {
  description = "Name of the AWS S3 bucket"
  type        = string
  validation {
    condition     = regex("^[a-zA-Z0-9.-]{3,63}$", var.bucket_name)
    error_message = "Invalid bucket name. It must be between 3 and 63 characters long and can only contain alphanumeric characters, hyphens, and dots."
  }
}
```

2.5 Asignar el valor a la variable en `terraform.tfvars`

`bucket_name = "mybucket-qrtrlolnx8hbxaui"`

También agregar un ejemplo en `terraform.tfvars.example`

2.6 Actualizar el `outputs.tf

`



## Que hacer si ya empezamos a hacer cambios en main, pero queremos hacer commit de esos cambios en un nuevo branch y no en main.

1. Crear el branch (opcional: asociarla a un issue)
2. git fetch
3. git checkout 28-configuration-drift
4. git add
4. git commit 



