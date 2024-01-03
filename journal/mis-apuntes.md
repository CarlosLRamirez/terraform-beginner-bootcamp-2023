## Bitácora: 4/Dic/2023

### Que pasa si perdemos el terraform state file?

Si perdemos el tfstate debemos "importar" nuestros recursos a Terraform, podemos utilizar el comando `terraform import` o también un block `import`, primero voy a probar con el comando `import`

1. Importar el bucket S3

De acuerdo a la documentación del [provider AWS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import):

`terraform import aws_s3_bucket.website_bucket mybucket-qrtrlolnx8hbxaui`

El `website_bucket` viene de como lo declaramos en el `main.tf`, y el `mybucket-qrtrlolnx8hbxaui` lo sacamos el recurso actual en AWS.

2. Importar el random_string

Como estamos usando un nombre aleatorio utilizando el proveedor random, también debemos importarlo, porque si no, al correr el `terraform apply` lo que va pasar es que va crear un bucket nuevo con otro nombre aleatorio. 

Siguiendo la [documentación del provedor](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string#import), corremos el comando:

`terraform import random_string.bucket_name qrtrlolnx8hbxaui`

**UPDATE:** al final no resulto como se esperaba, porque al darle `terraform plan` decía que iba a remplazar el bucket con uno nuevo. (Empezamos a ver que quizás utilizar random no es una buena idea).

Lo que vamos a hacer es que vamos a quitar la aleatoriedad (*"randomness"*) del nombre del bucket y lo vamos a declarar explicitamente con el mismo nombre que ya tiene, a través de una variable.

> [!TIP]
> Los import creados por comando, solo son validos mientras el ambiente de Gitpod esta activo, porque recordemos que el tfstate es efimero en este caso.

3. Quitar el randomness del nombre del bucket

3.1 Borrar el proveedor random de `providers.tf`

3.2 Borrar el `random_string` de `main.tf`

3.3 Modificar el nombre del bucket en `main.tf` para que sea una variable

`bucket = var.bucket_name`

En mi caso también voy a eliminar la parte de `locals`, donde concatenaba la cadena aleatorio con "mybucket-" y lo voy a agregar directamente en el valor de la variable.

3.4 Definir la variable en `variables.tf` y validar que sea un nombre de bucket valido (con ayuda de ChatGPT)

```sh
variable "bucket_name" {
  description = "Name of the AWS S3 bucket"
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]{3,63}$", var.bucket_name))
    error_message = "Invalid bucket name. It must be between 3 and 63 characters long and can only contain alphanumeric characters, hyphens, and dots."
  }
}
```

3.5 Asignar el valor a la variable en `terraform.tfvars`

`bucket_name = "mybucket-qrtrlolnx8hbxaui"`

También agregar un ejemplo en `terraform.tfvars.example`

3.6 Actualizar el `outputs.tf

Colocar el valor asignado al bucket `value = aws_s3_bucket.website_bucket.bucket`.

### Que hacer si ya empezamos a hacer cambios en main, pero queremos hacer commit de esos cambios en un nuevo branch y no en main.

1. Crear el branch (opcional: asociarla a un issue)
2. git fetch
3. git checkout 28-configuration-drift
4. git add
4. git commit 

## Bitácora: 5/Dic/2023

- Modifique el nombre del recurso de `example` a `website-bucket` en `main.tf``
- Corregí un error en la validación del nombre del bucket en `variables.tf` 
- Agregué via AWS Consola un nuevo Tag al bucket, para ver que pasaba: 
  - Cuando le di `plan` me lo detectó, y cuando le di `apply` dice que lo agregó, sin embargo en el `tfstate` no veo nada, y tampoco me agrego nada al `main.tf`. 
- Tengo una duda: todavía tenemos el tfstate en el .gitignore ?? que va pasar???
- al final destruí el bucket

## Bitácora: 6/Dic/2023

### Creación del Módulo "terrahouse_aws"
- Creé el directorio `/modules/terrahouse_aws`
- Adentro cree los archivos `main.tf`, `variables.tf`, `outputs.tf`, `README.md` y `LICENSE`
- En el nuevo `main.tf` del modulo quedaron solo las secciones de:
  - `required_providers`
  - ~~`provider "aws"`~~
  - `resource`
- En el `main.tf` de la raiz se agrega la declaración del módulo y se pasan las variables que espera el módulo. Ojo :eyes: esto debe quedar fuera del primer nivel`terraform { }`:

```
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

- El contenido de `./variables.tf` lo copie al mismo archivo del modulo, y en el `./variables.tf` se puede quitar la parte de validación ya que esto se hace en el dentro del modulo, incluso se podría quitar la descripción.

-  En contenido del archivo `./outputs.tf` se copia al archivo del modulo, y en el `./outputs.tf` se debe especificar que el contenido lo debe obtener del output del módulo.

```
output "bucket_name" {
    description = "Bucket name for our static web hosting"
    value = module.terrahouse_aws.bucket_name
}
```

- Para ver los outputs despues de un `apply` utilizamos el comando `terraform output` 

[Terraform Modules](https://developer.hashicorp.com/terraform/language/modules)

## Bitácora 17/Dic/2023

- Agregue el recurso "aws_s3_bucket_website_configuration" en el main.tf del modulo terrahouse_aws, según la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration)
- Actualicé los outputs, (tanto en el modulo como el main), para mostrar el website_endpoint del bucket S3.
- Para "subir" el archivo index.html al bucket utilizamos el recurso `aws_s3_object`, según la [documentación](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object), en el `main.tf` del modulo.
- En Terraform existe una variable especial llamada `path` que nos permite referenciar a ubicaciones locales, según se describe en esta sección de [Filesystem and Workspace Info](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info).
    - `path.module` para obtener el path modulo actual
    - `path.root` para obtener el path del módulo raíz
- Creé un nuevo directorio `/public` con los archivos `index.html` y `error.html`, y los referencie utilizando la variable `path.root`, (por el momento comenté la parte de *etag*)
- Observación: luego de haber creado el objeto la primera vez en el bucket con `terraform apply`, si modificamos el **contenido** del archivo fuente, el objeto no se actualiza luego de un nuevo `terraform apply`, esto es porque TF cheque la existencia del objeto, pero no los datos en el mismo -> para esto es que sirve el *etag*
  - Para crear el *etag*, utilizamos la función de terraform [*filemd5*](https://developer.hashicorp.com/terraform/language/functions/filemd5), la cual obtiene un hash a partir del contenido del archivo, con esto no aseguramos que el valor cambié cada vez que modificamos el archivo.
- Luego lo modifiqué para que el path lo pase por medio de una variable, 

## Bitácora 3/Enero/2024

- Voy a repetir lo anterior para el archivo `error.html`
- NOTA: al pasar el valor de las variables por medio del `terraform.tfvars` no acepta el uso de `{path.root}`, por lo que debemos poner el path explícitamente.
- NOTA: Necesito repasar el uso de variables y porque se deben declarar tanto dentro del módulo como del directorio raíz.
