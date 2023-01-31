#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# Download package.json and package-lock.json

node2nix \
  --nodejs-16 \
  --node-env ../../../development/node-packages/node-env.nix \
  --development \
  --input package.json \
  --lock package-lock.json \
  --supplement-input supplement.json \
  --output node-packages.nix \
  --composition node-composition.nix