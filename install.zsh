#!/usr/bin/env zsh
zparseopts -E -F -D -- -flake=flake \
                       -user=user \
                       -host=host \
                       -dest=dest \
                       -root=root || exit 1

local root="${root[2]:-/mnt}"
local flake="${flake[2]:-$root/etc/dotfiles}"
local host="${host[2]:-$HOST}"
local user="${user[2]:-chu}"
local dest="${dest[2]:-$root/home/$user/.config/dotfiles}"

if [[ "$USER" == nixos ]]; then
  >&2 echo "Error: not in the nixos installer"
  exit 1
elif [[ -z "$host" ]]; then
  >&2 echo "Error: no --host set"
  exit 2
fi

set -e
if [[ ! -d "$flake" ]]; then
  local url=https://github.com/chumutt/dogfiles
  [[ "$user" == chu ]] && url="git@github.com:chumutt/dogfiles.git"
  rm -rf "$flake"
  git clone --recursive "$url" "$flake"
  chown "$user:users" -R "$flake"
fi

# export HEYENV="{\"user\":\"$user\",\"host\":\"$host\",\"path\":\"${flake#$root}\",\"theme\":\"$THEME\"}"
nixos-install \
    --impure \
    --show-trace \
    --root "$root" \
    --flake "${flake}#${host}"
