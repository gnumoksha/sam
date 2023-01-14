# Simple Artifact Manager (SAM)

## Installation
```bash
curl -sL -o /usr/local/bin/sam https://raw.githubusercontent.com/gnumoksha/sam/master/bin/sam && chmod +x /usr/local/bin/sam
```


## Examples

```bash
sam install=jwilm/alacritty from=github-release filter=amd64
sam install=sharkdp/bat from=github-release filter="bat_[0-9.]*_amd64"
sam install=sharkdp/fd from=github-release filter="fd_[0-9.]*_amd64"
```
