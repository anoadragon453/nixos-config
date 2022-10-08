# Software for AMD GPUs. Specifically my AMD Vega 64.
# Config taken from https://nixos.wiki/wiki/AMD_GPU.
{ config, lib, pkgs, modulesPath, ... }:

{
  # Use the amdgpu (open source) driver
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Tell X11 to use the 'amdgpu' driver
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable Vulkan support
  hardware.opengl.driSupport = true;
  # and for 32 bit applications
  hardware.opengl.driSupport32Bit = true;

  # Enable OpenCL support
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
}
