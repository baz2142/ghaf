# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (pkgs.callPackage ./apps/gala/default.nix {})
    zathura
  ];
}
