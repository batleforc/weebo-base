# Weebo base project

This repository is meant to be a template used to bootstrap future projects.

## Starting a new project

Create a repository from this template, clone it, then:

```bash
mise trust && mise install   # task itself comes from mise
task init                    # tools, skills, git hooks, knowledge graph
task init-repo               # rename the project, set CODEOWNERS, allow the update workflow to open PRs
```

`task init-repo` needs an authenticated `gh`. Without it, enable "Allow GitHub Actions to create and approve pull requests" in Settings > Actions.

## Eclipse Che

Those future projects are built around my way of viewing Eclipse Che and how i work with it. It's not, at least now, how it's commonly viewed.

My view of Eclipse Che includes the usage of [mise](https://mise.jdx.dev/) to describe the packages needed in pair with [Weebo DotFile Che](https://github.com/batleforc/weebo-dotfiles-che) which is the base of all my workspaces.

My custom image can be found [here](https://github.com/batleforc/WeeboDevImage)

## Updating a project bootstrapped from this template

Projects created before a template change catch up with `task template:sync`. It clones this repository into `.task/template`, overwrites the files the template owns, and prints a diff for the files every project customises so you merge those by hand. `task template:diff` shows the same comparison without writing anything.

The list of owned versus reviewed files lives at the top of `.tasks/template.yaml`.

A project that predates the task itself needs the file once:

```bash
mkdir -p .tasks
curl -fsSL https://raw.githubusercontent.com/batleforc/weebo-base/main/.tasks/template.yaml -o .tasks/template.yaml
# then add "template: ./.tasks/template.yaml" under includes: in Taskfile.yaml
task template:sync
```
