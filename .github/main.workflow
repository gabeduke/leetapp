workflow "Bump Version" {
  on = "push"
  resolves = ["Publish"]
}

# Filter for master branch
action "Master" {
  uses = "actions/bin/filter@master"
  args = "branch test"
}

action "Publish" {
  needs = "Master"
  uses = "tomologic/bumpversion@latest"
  args = "-v $PWD:/src -w /src"
  runs = "/usr/local/bin/bumpversion patch"
}
