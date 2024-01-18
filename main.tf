terraform {

  required_providers {
    
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
 
  cloud {
    organization = "CarlosLRamirez"
  
    workspaces {
      name = "terra-town"
    }
  }

  }  

provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid=var.teacherset_user_uuid
  token=var.terratowns_access_token
}


module "home_riseofnations_hosting" {
    source = "./modules/terrahome_aws"
    user_uuid = var.teacherset_user_uuid
    public_path = var.riseofnations.public_path
    content_version = var.riseofnations.content_version    
  }
 

resource "terratowns_home" "home_riseofnations" {
  name = "Rise of Nations, one of my favorites game!"
    description = <<DESCRIPTION
"Rise of Nations" is a real-time strategy (RTS) video game that seamlessly combines the depth of traditional 
strategy games with the fast-paced action of real-time gameplay. Developed by Big Huge Games and published by Microsoft Game Studios,
the game was initially released in 2003. It offers a unique gaming experience by spanning across different historical eras, 
allowing players to guide their civilizations from ancient times to the modern age.  
DESCRIPTION
 
  domain_name = module.home_riseofnations_hosting.domain_name
  #domain_name = "thisisatest.cloudfront.net"
  town = "missingo"
  content_version = var.riseofnations.content_version
}



module "home_atitlan_hosting" {
    source = "./modules/terrahome_aws"
    user_uuid = var.teacherset_user_uuid
    public_path = var.atitlan.public_path
    content_version = var.atitlan.content_version
  }
 

resource "terratowns_home" "home_atitlan" {
  name = "Trip to Atitlan Lake in Guatemala"
    description = <<DESCRIPTION
This is a description of my last trip to lake Atitlan, in Guatemala.  Lake Atitlán is a stunning and captivating natural
wonder nestled in the highlands of Guatemala, Central America. Revered as one of the most beautiful lakes in the world, 
Lake Atitlán is situated at an elevation of about 1,562 meters (5,125 feet) above sea level and is surrounded by 
towering volcanoes and picturesque indigenous villages.
DESCRIPTION
 
  domain_name = module.home_atitlan_hosting.domain_name
  #domain_name = "thisisatest.cloudfront.net"
  town = "missingo"
  content_version = var.atitlan.content_version
}

