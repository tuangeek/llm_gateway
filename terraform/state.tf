terraform {
  backend "s3" {
    bucket       = "foooo"
    key          = "foooo"
    region       = "foooo"
    use_lockfile = true
  }
}