variable "cloud" {
  type        = string
  description = "The cloud to use as specified in your `clouds.yml` configuration file"
  default     = "beluga"
}

variable "teams" {
  type        = list(string)
  description = "The teams to deploy an app cluster for"
  default = [
    "epistemopratique",
    "otherteam"
  ]
}