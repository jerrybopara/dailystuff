provider "aws" {
    region = "${var.AWS_REGION}"
    profile = "${var.AWS_PROFILE}"
    shared_config_files      = ["$HOME/.aws/config"]
    shared_credentials_files = ["$HOME/.aws/credentials"]
}
