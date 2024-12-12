{
  description = "lazy installer";

  outputs = { self, nixpkgs }: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { ${system} = "x86_64-linux"; };
    scriptName = "lazyInstaller";
    buildInputs = with pkgs; [ parted nixos-install nixos-enter ];
    scriptDef = pkgs.writeShellScriptBin scriptName ./test.sh;

  in {
    defaultPackage.${system} = self.packages.${system}.${script-name};

    packages.${system}.${script-name} = 
      pkgs.symlinkJoin {
      name = scriptName;
      paths = [ scriptDef ] ++ buildInputs;
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = "wrapProgram $out/bin/${scriptName} --prefix PATH : $out/bin";
    };
  };
}