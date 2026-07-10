{ config, pkgs, ... }:

{
  home.username = "lumirelle";
  home.homeDirectory = "/home/lumirelle";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
	nushell
	starship
	mise
	neovim
	opencode
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
