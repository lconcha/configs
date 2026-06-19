# RTX 5070 Ubuntu 22.04 LTS Workstation Deployment Guide

This guide outlines the definitive, step-by-step deployment sequence for provisioning a high-performance compute workstation featuring an **NVIDIA RTX 5070 GPU** under **Ubuntu 22.04 LTS**. This specific workflow bypasses hardware-level installation hangs, handles mandatory open-kernel driver requirements, and configures the environment to co-exist with a background **Sun Grid Engine (SGE)** cluster execution daemon.

---

## Phase 1: USB Media Preparation

1. **Download:** Obtain the latest official **Ubuntu 22.04 LTS Server ISO** (prefer point releases like 22.04.5+ to inherit a modern Hardware Enablement kernel base).
2. **Flash:** Do **not** use multi-boot utilities like Ventoy for this specific hardware profile. Use **Rufus** (explicitly selecting **"DD Mode"** when prompted) or **BalenaEtcher** to write the ISO raw to a high-quality flash drive.

---

## Phase 2: Pre-Install BIOS Adjustments

Before booting from the installation media, power on the machine, enter the BIOS/UEFI configuration utility, and apply the following parameters:

1. **Secure Boot:** Set to **Disabled**.
2. **Resizable BAR:** Set to **Disabled** *(Temporary: prevents the installer memory handoff loop).*
3. **Above 4G Decoding:** Set to **Disabled** *(Temporary).*
4. Save adjustments and exit.

---

## Phase 3: The Installation Bypass

1. Insert the installation USB into a **rear motherboard USB 3.0/3.1 port** (avoid using front panel chassis headers or unmapped Type-C slots during provisioning).
2. Power on the system to initialize the GRUB boot menu.
3. Highlight the primary installer option and press **`e`** to modify the boot command list.
4. Locate the line beginning with `linux`, navigate to the very end of that string, append a space, and add the following flags:
   ```text
   nomodeset acpi=off
   ```
5. Press **`Ctrl+X`** or **`F10`** to execute the boot process with these parameters.
6. **Network Configuration:** When configuring the manual IPv4 settings, specify the subnet mask using standard Classless Inter-Domain Routing (CIDR) block notation:
   * **Subnet:** `172.24.220.0/24`
7. Complete the installation wizard. 

> *Note: If a `grub-install: error ... Operation not permitted` fault presents at the finalization stage, select **"Continue without bootloader"** or ignore the alert. The modern UEFI layer will automatically locate the default fallback boot loader path (`/EFI/BOOT/BOOTX64.EFI`) upon restart.*

---

## Phase 4: Fixing the Config Drop (First Boot Execution)

Because booting with `acpi=off` causes the installer environment to drop local configuration commits to disk right at the finish line, you must manually establish the primary user and hostname immediately on your first boot.

1. Power on the workstation and repeatedly tap **`Esc`** (or hold **`Shift`**) to invoke the GRUB loader interface.
2. Select **Advanced Options for Ubuntu** $
ightarrow$ select the entry appended with **`(recovery mode)`** $
ightarrow$ select **`root (Drop to root shell prompt)`**.
3. Remount the filesystem root partition with write access:
   ```bash
   mount -o remount,rw /
   ```
4. Define the target system hostname (replace `carr` with your specific node designation, e.g., `carr2`):
   ```bash
   hostnamectl set-hostname carr
   ```
5. Manually register your primary user account and establish administrative authorizations:
   ```bash
   useradd -m -s /bin/bash luis
   passwd luis
   usermod -aG sudo luis
   ```
6. Flush memory changes and force a system restart:
   ```bash
   reboot
   ```

---

## Phase 5: Driver, Kernel, and Desktop Setup

Log into your freshly initialized text/graphical interface using the newly established credentials.

### 1. Install the Mandatory Open Driver
The physical firmware on the RTX 5070 architecture explicitly rejects the legacy proprietary kernel driver codebase. You **must** deploy the open-source kernel module variant along with its management utilities:
```bash
sudo apt update
sudo apt install nvidia-driver-550-open nvidia-modprobe
```

### 2. Upgrade to the Hardware Enablement (HWE) Kernel
Ensure full software and power optimization for modern multi-core processing architectures and updated chipsets:
```bash
sudo apt install --install-recommends linux-generic-hwe-22.04
```

### 3. Deploy the GNOME Desktop Environment
```bash
sudo apt install ubuntu-desktop
```
*When prompted to select the default display manager, choose **`gdm3`**.*

---


## Phase 6: Final Hardware Unlocking

1. Reboot the workstation and re-enter the BIOS utility.
2. Restore full PCIe pipeline bandwidth by switching **Resizable BAR** back to **Enabled**.
3. Set **Above 4G Decoding** back to **Enabled**.
4. Save configuration and boot cleanly into your optimized production environment.
5. Verify driver-to-hardware binding:
   ```bash
   nvidia-smi
   ```


## Phase 7: Desktop behavior
Remove the pesky "which services do you want to restart" after a sudo upgrade.
```
sudo apt remove needrestart
```
