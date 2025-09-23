terraform {
  backend "s3" {
    bucket       = "foooo"
    key          = "foooo"
    region       = "foooo"
    profile      = "foooo"
    use_lockfile = true
  }
}