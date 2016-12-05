1. Add following text to /ets/sudoers

## Allows people in group wheel to run all commands
%wheel        ALL=(ALL)       ALL


2. Add `wheel` group, run command: sudo groupadd wheel
3. Add users to `wheel` group: