# kickstart - Autoprovisioning Microservice Container (Linux, Windows10, MacOS)

see (http://github.com/infracamp/kickstart) for more information.

## What is this project about

This Repo delivers the tools used by any kickstart flavor container.
It is included by Git submodule.

## Commands

There are these predefined commands you can specify as container
argument.

| Command | Description |
|---------|-------------|
| `debug` | Don't execute anything inside the container and provide information about the container |
| `debug-shell` | Don't execute anything inside the container and provide a bash shell |
| `build` | Build the container. Will be executed in development environment     |
| `init`  | Triggered after `build` |
| `run`   | Executed by default (if no other command is specified)               |
| | **In server mode only:** |
| `standalone` | Execute container in standalone mode (will trigger `interval` every 60 seconds |
| `interval`   | Triggered every 60 seconds |

## Available parameters to `start.sh`

### `standalone [command1 [command2]]`: Server mode

Use this for prebuild application containers. Standalone mode will
skip `build` and `init` commands.

*Standalone*-mode should be called by the `RUN` command in `Dockerfile`.

Execute `command1`, then `command2` (but not `run` - if you want to execute
`run` as well you'll have to specify it)

Execute command `interval` every 60seconds.


## Build color prompts:


export PS1="\u@\[$(tput sgr0)\]\[\033[38;5;208m\]$DEV_CONTAINER_NAME\[$(tput sgr0)\]\[\033[38;5;8m\]:\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;21m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;8m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"
