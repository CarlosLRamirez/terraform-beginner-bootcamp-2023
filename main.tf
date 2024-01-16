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
  endpoint = "http://localhost:4567/api"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
  
}


#module "terrahouse_aws" {
#    source = "./modules/terrahouse_aws"
#    user_uuid = var.user_uuid
#    bucket_name = var.bucket_name
#    index_html_filepath = var.index_html_filepath
#    error_html_filepath = var.error_html_filepath
#    content_version = var.content_version
#    assets_path = var.assets_path
#  }
 

resource "terratowns_home" "myhome" {
  name = "Rise of Nations, one of my favorites game!"
    description = <<DESCRIPTION
"Rise of Nations" is a real-time strategy (RTS) video game that seamlessly combines the depth of traditional 
strategy games with the fast-paced action of real-time gameplay. Developed by Big Huge Games and published by Microsoft Game Studios,
the game was initially released in 2003. It offers a unique gaming experience by spanning across different historical eras, 
allowing players to guide their civilizations from ancient times to the modern age. - Hello World - Fixing conflicts - 
DESCRIPTION
 
   #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = "thisisatest.cloudfront.net"
  town = "gamers-grotto"
  content_version = 1 
}

