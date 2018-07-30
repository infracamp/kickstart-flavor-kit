# kickstart - Autoprovisioning Microservice Container (Linux, Windows10, MacOS)

see (http://github.com/infracamp/kickstart) for more information.

## What is this project about

This Repo delivers the tools used by any kickstart flavor container.
It is included by Git submodule.



## Available parameters to `start.sh`

### `standalone [command1 [command2]]`: Server mode

Use this for prebuild application containers. Standalone mode will
skip `build` and `init` commands.

*Standalone*-mode should be called by the `RUN` command in `Dockerfile`.

Execute `command1`, then `command2` (but not `run` - if you want to execute
`run` as well you'll have to specify it)

Execute command `interval` every 60seconds.
