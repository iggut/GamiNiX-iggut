{
  lib,
  config,
  ...
}:
lib.mkIf config.mounts.enable {
  # Windows game drive nvme
  fileSystems."/run/media/iggut/gamedisk" = {
    device = "/dev/disk/by-uuid/9E049FCD049FA735";
    fsType = "ntfs3";
    options = [ "rw" "uid=1000"];
    #options = ["uid=1000" "gid=1000" "nodev" "nofail" "x-gvfs-show" "rw" "user" "exec" "umask=000"];
  };
}
