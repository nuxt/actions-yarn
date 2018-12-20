# GitHub Action for Yarn

This Action for [yarn](https://yarnpkg.com/en/) enables arbitrary actions with the `yarn` command-line client, including testing packages and publishing to a registry.

## Usage

An example workflow to build, test, and publish an npm package to the default public registry follows:

```hcl
workflow "Build, Test, and Publish" {
  on = "push"
  resolves = ["Publish"]
}

action "Build" {
  uses = "nuxt/actions-yarn@master"
  args = "install"
}

action "Test" {
  needs = "Build"
  uses = "nuxt/actions-yarn@master"
  args = "test"
}

# Filter for a new tag
action "Tag" {
  needs = "Test"
  uses = "actions/bin/filter@master"
  args = "tag"
}

action "Publish" {
  needs = "Tag"
  uses = "nuxt/actions-yarn@master"
  args = "publish --access public"
  secrets = ["NPM_AUTH_TOKEN"]
}
```

## Node Versions

Specify different branch name in `uses` to leverage node version.

```hcl
action "Build" {
  uses = "nuxt/actions-yarn@node-11"
  args = "install"
}
```