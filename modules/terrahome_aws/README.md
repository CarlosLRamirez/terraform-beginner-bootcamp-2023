## Terrahome AWS

```tf
module "home_riseofnations" {
    source = "./modules/terrahome_aws"
    user_uuid = var.teacherset_user_uuid
    bucket_name = var.bucket_name
    public.path = var.riseofnations_public_path
    content_version = var.content_version    
  }
```
 
The public directory expect the following:
- index.html
- error.html
- assests

All top level files in assets will be copied, but not any subdirectories 

