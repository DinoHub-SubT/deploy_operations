# Compose Deployer Example Commands

# UGV

- Build docker image: `./deployer -e arch=x86 robot=r1 ws=planning -s compose.docker.planning `
- Clone repo: `./deployer -e arch=x86 service=planning robot=r1 ws=planning -s compose.ws.clone`
- Build repo: `./deployer -e arch=x86 service=planning robot=r1 computer=ppc ws=planning -s compose.ws.build`

# Basestation

- Build docker image: `./deployer -e arch=x86 robot=desktop ws=planning -s compose.docker.planning `
- Clone repo: `./deployer -e arch=x86 service=basestation robot=desktop ws=planning -s compose.ws.clone`
- Build repo: `./deployer -e arch=x86 service=basestation robot=desktop ws=planning -s compose.ws.build`