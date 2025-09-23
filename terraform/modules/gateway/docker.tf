#  resource "aws_ecr_repository" "this" {
#     name =  "${var.org}-${var.env}-app"
#     image_tag_mutability = "MUTABLE"
# }

# resource "docker_image" "latest" {
#     name = "${aws_ecr_repository.this.repository_url}:latest"
#     build {
#         context    = "../docker" # Path to your Dockerfile context
#         dockerfile = "Dockerfile"
#     }
# }

# resource "docker_registry_image" "this" {
#     name = docker_image.latest.name
#     depends_on = [docker_image.latest]
# }