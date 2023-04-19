# SPDX-FileCopyrightText: 2023 Unikie

{
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  audit,
  autoPatchelfHook,
  bashInteractive,
  binutils,
  bzip2,
  cairo,
  cups,
  db,
  diffutils,
  ed,
  expat,
  fetchFromGitHub,
  file,
  findutils,
  gawk,
  gcc,
  gdk-pixbuf,
  gettext,
  glib,
  glibc,
  glibcIconv,
  glibcLocales,
  glibc_multi,
  gnome,
  gnugrep,
  gnumake,
  gnused,
  gtk3,
  gzip,
  less,
  lib,
  libdrm,
  libelf,
  libffi,
  libglvnd,
  libidn2,
  libselinux,
  libudev-zero,
  libunistring,
  libxkbcommon,
  linux-pam,
  linuxHeaders,
  makeWrapper,
  mesa,
  nodejs,
  nspr,
  nss,
  openssl,
  pango,
  patch,
  patchelf,
  pcre,
  pcre2,
  perl,
  pkgs,
  python3,
  readline,
  shadow,
  stdenv,
  unzip,
  util-linuxMinimal,
  wayland,
  wrapGAppsHook,
  xorg,
  xz,
  zlib,
  ...
}:

let
  # src = fetchFromGitHub {
  #   owner = "solita";
  #   repo = "tii-saca-ga-la";
  #   rev = "5492cfeeda15fb3205d344f0dc0396f8e7aa798f";
  # };

  src = ./tii-saca-ga-la.zip;

  nodePackages = import ./node-composition.nix {
    inherit pkgs;
    inherit (stdenv.hostPlatform) system;
    nodejs = pkgs."nodejs-16_x";
  };

  __noChroot = true;
in
nodePackages.package.override {
  pname = "gala";
  version = "0.0.1";

  inherit src;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    unzip
    wrapGAppsHook
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    audit
    bashInteractive
    binutils
    bzip2
    cairo
    cups
    db
    diffutils
    ed
    expat
    file
    findutils
    gawk
    gcc
    gdk-pixbuf
    gettext
    glib
    glibc
    glibc_multi
    gnome.gdm
    gnugrep
    gnumake
    gnused
    gtk3
    gzip
    less
    libdrm
    libelf
    libffi
    libglvnd
    libidn2
    libselinux
    libudev-zero
    libunistring
    libxkbcommon
    linux-pam
    linuxHeaders
    mesa
    nspr
    nss
    openssl
    pango
    patch
    patchelf
    pcre
    pcre2
    perl
    python3
    readline
    shadow
    stdenv
    unzip
    util-linuxMinimal
    wayland
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxcb
    xorg.libxshmfence
    xz
    zlib
  ];

  autoPatchelfIgnoreMissingDeps = [ "libc.musl-x86_64.so.1" ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/lib/node_modules/GALA/platforms/electron/build/linux-unpacked/dev.scpp.saca.gala $out/bin/gala 

    wrapProgram $out/bin/gala \
      --set LD_PRELOAD "${libudev-zero}/lib/libudev.so.1" \
      --prefix LD_LIBRARY_PATH : ${wayland}/lib:${libglvnd}/lib:$out/lib/node_modules/GALA/platforms/electron/build/linux-unpacked \
      --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland" \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with lib; {
    description = "GALA app";
    platforms = platforms.linux;
    architectures = [ "amd64" ];
  };
}
