locals{
    ami_id = data.aws_ami.ami_info.id
    common_tags = {
        Project = var.project
        Environment = var.environment
        Terraform = "true"
    }
}