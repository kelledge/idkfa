variable "key_name" {
  description = "Name to identify the key after creation"
}

variable "key_path" {
  description = "Filesystem path to use when generating the key"
}

locals {
  key_path_sec = "${var.key_path}"
  key_path_pub = "${var.key_path}.pub"
}

resource "null_resource" "key" {
  # Trigger on cluster id
  # triggers {
  #   cluster_instance_ids = "${join(",", aws_instance.cluster.*.id)}"
  # }

  # FIXME: This is only executed *after* variables are interpolated. This means
  # variable references get an empty string, or no file errors on first run.
  provisioner "local-exec" {
    # provision SSH key
    command = "ssh-keygen -t rsa -b 2048 -N '' -C '${var.key_name}' -f ${local.key_path_sec}"
  }
}

resource "aws_key_pair" "key" {
  key_name = "${var.key_name}"
  public_key = "${file(local.key_path_pub)}"
  depends_on = ["null_resource.key"]
}

output "key_name" {
  value = "${aws_key_pair.key.key_name}"
}

output "key_path_sec" {
  value = "${local.key_path_sec}"
}

output "key_path_pub" {
  value = "${local.key_path_pub}"
}
