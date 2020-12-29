resource "random_shuffle" "sub" {
  input        = [ "subnet-0bf21054", "subnet-3211fd13", "subnet-75c02113", "subnet-89efdab7", "subnet-912293dc", "subnet-b1f12abf" ]
  result_count = 1
}
