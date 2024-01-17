terraform {

  required_providers {
    
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
 
  #cloud {
  #  organization = "CarlosLRamirez"
  #
  #  workspaces {
  #    name = "terra-house-1"
  #  }
  #}

  }  

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid=var.teacherset_user_uuid
  token=var.terratowns_access_token
}


module "terrahouse_aws" {
    source = "./modules/terrahouse_aws"
    user_uuid = var.teacherset_user_uuid
    bucket_name = var.bucket_name
    index_html_filepath = var.index_html_filepath
    error_html_filepath = var.error_html_filepath
    content_version = var.content_version
    assets_path = var.assets_path
  }
 

resource "terratowns_home" "myhome" {
  name = "Rise of Nations, one of my favorites game!"
    description = <<DESCRIPTION
"Rise of Nations" is a real-time strategy (RTS) video game that seamlessly combines the depth of traditional 
strategy games with the fast-paced action of real-time gameplay. Developed by Big Huge Games and published by Microsoft Game Studios,
the game was initially released in 2003. It offers a unique gaming experience by spanning across different historical eras, 
allowing players to guide their civilizations from ancient times to the modern age.  
DESCRIPTION
 
  domain_name = module.terrahouse_aws.cloudfront_url
  #domain_name = "thisisatest.cloudfront.net"
  town = "missingo"
  content_version = 1 
}