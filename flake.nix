{
    description = "Opinionated bootstrap templates for 'nix flake init'";

    outputs = { self }: {
        templates = builtins.mapAttrs (k: v:
            if v == "directory"
            then {
              path = ./src + "/${k}";
              description = "${k} template";
            }
            else {}
        ) (builtins.readDir ./src);
    };
}
