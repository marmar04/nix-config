# For installation of games
{ inputs, lib, config, pkgs, ... }: {
  programs = {
    zathura = {
      enable = true;
      options = {
        adjust-open = "best-fit";
        scroll-page-aware = "true";
        font = "inconsolata 15";
        default-bg = "#000000";
        default-fg = "#F7F7F6";

        statusbar-bg = "#B0B0B0";
        statusbar-fg = "#F7F7F6";

        inputbar-bg = "#151515";
        inputbar-fg = "#FFFFFF";

        highlight-color = "#F4BF75";
        highlight-active-color = "#6A9FB5";

        completion-highlight-fg = "#151515";
        completion-highlight-bg = "#90A959";

        completion-bg = "#303030";
        completion-fg = "#E0E0E0";

        recolor = "true";
        recolor-lightcolor = "#282828";
        recolor-darkcolor = "#f3f5c6";
        recolor-reverse-video = "true";
        recolor-keephue = "true";

        render-loading = "false";
      };
    };
  };
}
