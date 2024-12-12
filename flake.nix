{
  description = "lazy installer";

  outputs = { self, nixpkgs }: 
  let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { system = system; };
    scriptName = "lazyInstaller";
    buildInputs = with pkgs; [ parted nixos-install nixos-enter ];
    scriptDef = writeShellApplication scriptName {
      name = "show-nixos-org";
      runtimeInputs = [ parted ];
      text = ''
        curl -s 'https://nixos.org' | w3m -dump -T text/html
      '';
    };

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