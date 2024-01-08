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

Lo que vamos a hacer es que vamos a quitar la aleatoriedad (*"randomness"*) del nombre del bucket y lo vamos a declarar explícitamente con el mismo nombre que ya tiene, a través de una variable.

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


## Bitácora 4/Enero/2024
- Primero separé el archivo `main.tf` del modulo `terrahouse_aws` en dos archivos: `resources-storage.tf` y `resources.cdn.tf`, en uno están los recursos relacionados al bucket S3, y el el otro lo relacionado a CloudFront
- Creé la Distribución de CloudFront siguiente el video y esta documentación:
  - [Cloudfront Distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)
  - [Origin Access Control](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_control)
  - [Bucket Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy)
- Para el Bucket Policy, se puede hacer de dos formas, la primera es como esta en la documentación (utilizando `data`), y la segunda es como inline utilizando `jsonencode()`, yo lo hice de la segunda forma.
  -   [jsonencode Function](https://developer.hashicorp.com/terraform/language/functions/jsonencode)
- El ejemplo del bucket policy se tomo de [aqui](https://aws.amazon.com/blogs/networking-and-content-delivery/amazon-cloudfront-introduces-origin-access-control-oac/)
- NOTA: Hay que cambiar en el json los ":" or "=", para que funcione en Terraform. (*CONFIRMAR)

- En el Bucket Policy necesito referenciar el Account ID, para esto hago uso de los [Terraform Data Sources](https://developer.hashicorp.com/terraform/language/data-sources), lo cual es una forma de obtener datos de los recursos de la nube.
  - En este caso cree una **fuente de datos** en el `main.tf` del modulo, llamado `"aws_caller_identity" "current" {}`, y por medio de esta puedo obtener mi `account_id`.
  - También tengo que referenciar el `id` de la distribución de Cloud Front, esto lo hago directamente con `${ }`

- También utilize los [Local Values](https://developer.hashicorp.com/terraform/language/values/locals)
  - Locals allows us to define local variables.
  - It can be very useful when we need to transform data into another format and have a referenced variable.


## Bitácora 5/Enero/2024

- En los archivos `index.html` y `error.html`, es necesario especificar el content_type, si no no funciona, y trata el archivo como un binario o algo asi, porque lo descarga en lugar de mostrarlo en el explorador.

```tf
resource "aws_s3_object" "indexfile" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  #source = "${path.root}/public/index.html"
  source = var.index_html_filepath
  content_type = "text/html"
  etag = filemd5(var.index_html_filepath)
}
```

- La creación y destrucción del CF distribution toma alrededor de 4 a 5 minutos
  - Una forma de retener la Distribución para no estarla borrando cada vez, es utilizar el flag `retain_on_delete`, aún no lo he probado.

### Terraform Resources Lifecycle

- Utilizando `lifecycle`en los recursos se puede controlar cuando queremos que Terraform apliqué los cambios, se definió que los cambios en `index.html` unicamente se disparen cuando cambie la variable `content_version`y que ignore el `etag`.
- Para esto se declaró la variable para pasar el valor, y también se uso un recurso tipo "dummy" llamado `terraform_data`.

[Manage resource lifecycle](https://developer.hashicorp.com/terraform/tutorials/state/resource-lifecycle)
[The lifecycle Meta-Argument](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)
[terraform_data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Bitácora 7/Enero/2024

- Se agregaron imágenes a la pagina web, se creó una carpeta `/public/assests`, con las imágenes.
- Se actualizó el archivo `gitpod.yml` para instalar y ejecutar `http-server` durante el arranque del workspace. Esto nos ayuda a revisar la pagina web localmente, para encontrar la URL entramos a la pestaña de PORTS, del entorno de trabajo.
- Entré a la consola de Terraform por medio de `terraform console` y aprendí la función `fileset` para listar los archivos en un directorio. 
- Siguiente paseo: Se va utilizar "for each" para subir las imágenes al bucket via Terraform

[fileset](https://developer.hashicorp.com/terraform/language/functions/fileset)


## Bitácora 8/Enero/2024

- Terraform soporta varios [tipos de datos](https://developer.hashicorp.com/terraform/language/expressions/types)(esto se estudia a detalle para la certificación), en ocasiones las funciones soportan solo un tipo de datos, y es necesario transformar (*to cast*) un tipo de dato a otro.
- Para subir los archivos con las imágenes en `assets` usamos la función `for_each` en combinación con el `fileset`, se ignoró la parte de content_type para no añadirle complejidad, se podría hacer después Ver la sintaxis utilizada en `resources_storage.tf`-


[for each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

