self: super:
let
  libPath = with super; lib.concatStringsSep ":" [
    "${lib.getLib libgccjit}/lib/gcc/${stdenv.targetPlatform.config}/$libgccjit.version}"
    "${lib.getLib stdenv.cc.cc}/lib"
    "${lib.getLib stdenv.glibc}/lib"
  ];

  emacs-overlay =
    let
      src = builtins.fetchTarball
        {
          url = https://github.com/nix-community/emacs-overlay/archive/f7fbaaa9222dfb256955190a80002ea910098f0a.tar.gz;
          sha256 = "19bkpwnnz4rybzqdc88i7p4ba44zbclz4si5ylpfnl664s0x9vnv";
        };
    in import src self super;
in {

  emacsGccWrapped = super.symlinkJoin {
    name = "emacsGccWrapped";
    paths = [ emacs-overlay.emacsGcc ];
    buildInputs = [ super.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/emacs \
      --set LIBRARY_PATH ${libPath}
    '';
    meta.platforms = super.stdenv.lib.platforms.linux;
    passthru.nativeComp = true;
    src = emacs-overlay.emacsGcc.src;
  };
}  // emacs-overlay
