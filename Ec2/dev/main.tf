module "vp_1" {
    source = "./var"
    }

module "ec2" {
    source = "./ins"
    sg_id = module.sg3.sg3    
    subnet_id = module.subnet1.subnet1
    key_name = module.tls_private_key.tls_private_key
    }