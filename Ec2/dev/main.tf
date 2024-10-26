module "vp_1" {
    source = "./var"
    }

module "ec2" {
    source = "./ins"
    sg_id = module.sg3.sg_id 
    subnet_id = module.subnet1.subnet1_id
    key_name = module.tls_private_key.tls_private_keyss
    }