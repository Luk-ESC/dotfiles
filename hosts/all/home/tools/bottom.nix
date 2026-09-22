{ osConfig, ... }: {
  programs.bottom = {
    enable = true;
    settings = {
      memory.cache_memory = true;
      network_graph.use_bytes = true;
      processes = {
        hide_k_threads = true;
        default_memory_value = true;
      };

      disk.mount_filter = {
        is_list_ignored = false;
        whole_word = true;
        list = builtins.attrNames osConfig.fileSystems;
      };
    };
  };
}
