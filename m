From: Valdis.Kletnieks@vt.edu
Subject: 2.6.27-rc5-mmotm0829 - lvm issues at boot,
	possible disk_devt() related?
Date: Sun, 31 Aug 2008 23:36:16 -0400
Message-ID: <4963.1220240176@turing-police.cc.vt.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1835083488=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

--===============1835083488==
Content-Type: multipart/signed; boundary="==_Exmh_1220240176_3529P";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit

--==_Exmh_1220240176_3529P
Content-Type: text/plain; charset=us-ascii

I bisected this down to the 08/28 version of linux-next.patch that was in
mmotm-0829.  27-rc3-mmotm0814 works fine.

System boots, loads the initrd, starts running.  The initrd tries to run lvm
to find my root file system (the one drive has sda1 a small /boot, and sda2
is the rest of the disk, and LVM space).  Every single partition complains:

device-mapper: core: bdget failed in dm_suspend
device-mapper: resume ioctl failed: invalid argument
Unable to resume Volgroup00-root (254:0)

and repeats the 3 lines with different Volgroup-foo and 254:N values for
each LVM logical volume.  After this, it rolls over and dies because it
didn't find the root filesystem.  

This is with an initrd build with Fedora Rawhide current as of last night.
Using an older initrd that's been working just fine for several releases
just silently hangs around the lvm startup. (My initrd config does not include
any .ko files, just nash and lvm and similar early-userspace stuff).

Any ideas?  Am willing to try patches/debugging code, if anybody can think
what I should be instrumenting to get more info.

My gut feeling is an issue in Tejun Heo's patches to implement extended dev
numbers - one of these two or a related patch:

commit 805d265623f217cbeac02b6f704342af2c320b5b
Author: Tejun Heo <tj@kernel.org>
Date:   Mon Aug 25 19:47:22 2008 +0900

    block: implement extended dev numbers

commit 346862bf911e5f5194b13ba1a5608f8d7f1e758a
Author: Tejun Heo <tj@kernel.org>
Date:   Mon Aug 25 19:47:19 2008 +0900

    block: don't depend on consecutive minor space

(The second adds disk_devt() to drivers/md/dm-ioctl.c, which is (a) where
we are dying and (b) would cause us to die if it was broken, and (c) most
of the code change to dm-ioctl.c - so I'm suspicious...)

This looks suspicious as well:

commit d15722bcd6dfd88e9ce108405f2313266a5ae1d2
Author: Tejun Heo <tj@kernel.org>
Date:   Mon Aug 25 19:56:17 2008 +0900

    block: allow disk to have extended device number
...
    * If CONFIG_DEBUG_EXT_DEVT is set, both sd and ide-disk always set
      minors to 0 and use extended device numbers.

For the sd and ide cases, this patch adds code that looks like:

+#if !defined(CONFIG_DEBUG_BLOCK_EXT_DEVT)
+#define SD_MINORS      16
+#else
+#define SD_MINORS      0
+#endif

Is a similar chunk missing in the LVM case?

Additional info:

Note that this kernel is built with "# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set".

I had a .config that worked on the kernel created with all patches up to,
but not including linux-next.patch - after 'quilt push linux-next.patch'
I did a 'make silentoldconfig'.  Here's what got changed by that:

--- conf.works	2008-08-31 09:47:39.000000000 -0400
+++ .config	2008-08-31 09:51:59.000000000 -0400
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux kernel version: 2.6.27-rc5
-# Sun Aug 31 05:28:14 2008
+# Sun Aug 31 09:51:59 2008
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
@@ -92,6 +92,7 @@
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
+# CONFIG_FASTBOOT is not set
 CONFIG_SYSCTL=y
 CONFIG_EMBEDDED=y
 CONFIG_UID16=y
@@ -118,8 +119,10 @@
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
 CONFIG_PROFILING=y
+CONFIG_TRACEPOINTS=y
 CONFIG_MARKERS=y
 CONFIG_OPROFILE=m
+# CONFIG_OPROFILE_IBS is not set
 CONFIG_HAVE_OPROFILE=y
 CONFIG_KPROBES=y
 CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
@@ -127,10 +130,11 @@
 CONFIG_HAVE_IOREMAP_PROT=y
 CONFIG_HAVE_KPROBES=y
 CONFIG_HAVE_KRETPROBES=y
-# CONFIG_HAVE_ARCH_TRACEHOOK is not set
+CONFIG_HAVE_ARCH_TRACEHOOK=y
 # CONFIG_HAVE_DMA_ATTRS is not set
 CONFIG_USE_GENERIC_SMP_HELPERS=y
 # CONFIG_HAVE_CLK is not set
+CONFIG_HAVE_DYN_ARRAY=y
 CONFIG_PROC_PAGE_MONITOR=y
 # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_SLABINFO=y
@@ -143,7 +147,6 @@
 CONFIG_MODULE_FORCE_UNLOAD=y
 # CONFIG_MODVERSIONS is not set
 CONFIG_MODULE_SRCVERSION_ALL=y
-CONFIG_KMOD=y
 CONFIG_STOP_MACHINE=y
 CONFIG_BLOCK=y
 CONFIG_BLK_DEV_IO_TRACE=y
@@ -173,6 +176,7 @@
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
+# CONFIG_HAVE_SPARSE_IRQ is not set
 CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y
 CONFIG_X86_PC=y
@@ -222,6 +226,10 @@
 CONFIG_X86_CMOV=y
 CONFIG_X86_MINIMUM_CPU_FAMILY=64
 CONFIG_X86_DEBUGCTLMSR=y
+CONFIG_PROCESSOR_SELECT=y
+CONFIG_CPU_SUP_INTEL_64=y
+# CONFIG_CPU_SUP_AMD_64 is not set
+# CONFIG_CPU_SUP_CENTAUR_64 is not set
 CONFIG_HPET_TIMER=y
 CONFIG_HPET_EMULATE_RTC=y
 CONFIG_DMI=y
@@ -244,6 +252,8 @@
 # CONFIG_X86_MCE_AMD is not set
 CONFIG_I8K=m
 CONFIG_MICROCODE=m
+CONFIG_MICROCODE_INTEL=m
+# CONFIG_MICROCODE_AMD is not set
 CONFIG_MICROCODE_OLD_INTERFACE=y
 CONFIG_X86_MSR=m
 CONFIG_X86_CPUID=m
@@ -251,6 +261,7 @@
 CONFIG_ARCH_SPARSEMEM_DEFAULT=y
 CONFIG_ARCH_SPARSEMEM_ENABLE=y
 CONFIG_ARCH_SELECT_MEMORY_MODEL=y
+CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
 CONFIG_SELECT_MEMORY_MODEL=y
 # CONFIG_FLATMEM_MANUAL is not set
 # CONFIG_DISCONTIGMEM_MANUAL is not set
@@ -275,6 +286,7 @@
 CONFIG_X86_PAT=y
 # CONFIG_EFI is not set
 # CONFIG_SECCOMP is not set
+# CONFIG_CC_STACKPROTECTOR is not set
 # CONFIG_HZ_100 is not set
 # CONFIG_HZ_250 is not set
 # CONFIG_HZ_300 is not set
@@ -288,6 +300,7 @@
 CONFIG_PHYSICAL_ALIGN=0x200000
 CONFIG_HOTPLUG_CPU=y
 # CONFIG_COMPAT_VDSO is not set
+# CONFIG_CMDLINE_BOOL is not set
 CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
 
 #
@@ -318,6 +331,7 @@
 CONFIG_ACPI_THERMAL=m
 # CONFIG_ACPI_WMI is not set
 # CONFIG_ACPI_ASUS is not set
+# CONFIG_ACPI_PANASONIC is not set
 # CONFIG_ACPI_TOSHIBA is not set
 # CONFIG_ACPI_CUSTOM_DSDT is not set
 CONFIG_ACPI_BLACKLIST_YEAR=0
@@ -374,6 +388,7 @@
 CONFIG_PCI_MMCONFIG=y
 CONFIG_PCI_DOMAINS=y
 # CONFIG_DMAR is not set
+# CONFIG_INTR_REMAP is not set
 CONFIG_PCIEPORTBUS=y
 CONFIG_PCIEAER=y
 CONFIG_PCIEASPM=y
@@ -736,10 +751,7 @@
 # CONFIG_MCS_FIR is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
-
-#
-# Wireless
-#
+CONFIG_WIRELESS=y
 CONFIG_CFG80211=m
 CONFIG_NL80211=y
 CONFIG_WIRELESS_EXT=y
@@ -783,7 +795,7 @@
 # CONFIG_MTD is not set
 # CONFIG_PARPORT is not set
 CONFIG_PNP=y
-# CONFIG_PNP_DEBUG is not set
+CONFIG_PNP_DEBUG_MESSAGES=y
 
 #
 # Protocols
@@ -1066,6 +1078,7 @@
 # CONFIG_IPW2100 is not set
 # CONFIG_IPW2200 is not set
 # CONFIG_LIBERTAS is not set
+# CONFIG_LIBERTAS_THINFIRM is not set
 # CONFIG_AIRO is not set
 # CONFIG_HERMES is not set
 # CONFIG_ATMEL is not set
@@ -1292,6 +1305,7 @@
 #
 # External I2C/SMBus adapter drivers
 #
+# CONFIG_I2C_FLOPPY is not set
 # CONFIG_I2C_PARPORT_LIGHT is not set
 # CONFIG_I2C_TAOS_EVM is not set
 # CONFIG_I2C_TINY_USB is not set
@@ -1455,6 +1469,7 @@
 # CONFIG_MFD_CORE is not set
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
+# CONFIG_UCB1400_CORE is not set
 # CONFIG_MFD_TMIO is not set
 
 #
@@ -1504,17 +1519,16 @@
 # CONFIG_VIDEO_CPIA2 is not set
 # CONFIG_VIDEO_SAA5246A is not set
 # CONFIG_VIDEO_SAA5249 is not set
-# CONFIG_TUNER_3036 is not set
 # CONFIG_VIDEO_STRADIS is not set
 # CONFIG_VIDEO_ZORAN is not set
 # CONFIG_VIDEO_SAA7134 is not set
 # CONFIG_VIDEO_MXB is not set
-# CONFIG_VIDEO_DPC is not set
 # CONFIG_VIDEO_HEXIUM_ORION is not set
 # CONFIG_VIDEO_HEXIUM_GEMINI is not set
 # CONFIG_VIDEO_CX88 is not set
 # CONFIG_VIDEO_IVTV is not set
 # CONFIG_VIDEO_CAFE_CCIC is not set
+# CONFIG_SOC_CAMERA is not set
 CONFIG_V4L_USB_DRIVERS=y
 CONFIG_USB_VIDEO_CLASS=m
 CONFIG_USB_VIDEO_CLASS_INPUT_EVDEV=y
@@ -1528,7 +1542,6 @@
 # CONFIG_USB_QUICKCAM_MESSENGER is not set
 # CONFIG_USB_ET61X251 is not set
 # CONFIG_VIDEO_OVCAMCHIP is not set
-# CONFIG_USB_W9968CF is not set
 # CONFIG_USB_OV511 is not set
 # CONFIG_USB_SE401 is not set
 # CONFIG_USB_SN9C102 is not set
@@ -1538,8 +1551,6 @@
 # CONFIG_USB_ZR364XX is not set
 # CONFIG_USB_STKWEBCAM is not set
 # CONFIG_USB_S2255 is not set
-# CONFIG_SOC_CAMERA is not set
-# CONFIG_VIDEO_SH_MOBILE_CEU is not set
 # CONFIG_RADIO_ADAPTERS is not set
 # CONFIG_DAB is not set
 
@@ -1615,6 +1626,7 @@
 # CONFIG_FB_CARMINE is not set
 # CONFIG_FB_GEODE is not set
 # CONFIG_FB_VIRTUAL is not set
+# CONFIG_FB_METRONOME is not set
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 CONFIG_LCD_CLASS_DEVICE=m
 # CONFIG_LCD_ILI9320 is not set
@@ -1716,6 +1728,7 @@
 # CONFIG_SND_FM801 is not set
 CONFIG_SND_HDA_INTEL=m
 # CONFIG_SND_HDA_HWDEP is not set
+CONFIG_SND_HDA_INPUT_BEEP=y
 # CONFIG_SND_HDA_CODEC_REALTEK is not set
 # CONFIG_SND_HDA_CODEC_ANALOG is not set
 CONFIG_SND_HDA_CODEC_SIGMATEL=y
@@ -1754,6 +1767,7 @@
 # CONFIG_SND_USB_AUDIO is not set
 # CONFIG_SND_USB_USX2Y is not set
 # CONFIG_SND_USB_CAIAQ is not set
+# CONFIG_SND_USB_US122L is not set
 CONFIG_SND_PCMCIA=y
 # CONFIG_SND_VXPOCKET is not set
 # CONFIG_SND_PDAUDIOCF is not set
@@ -1769,9 +1783,29 @@
 # USB Input Devices
 #
 CONFIG_USB_HID=y
-# CONFIG_USB_HIDINPUT_POWERBOOK is not set
 # CONFIG_HID_FF is not set
 # CONFIG_USB_HIDDEV is not set
+
+#
+# Special HID drivers
+#
+CONFIG_HID_COMPAT=y
+# CONFIG_HID_A4TECH is not set
+# CONFIG_HID_APPLE is not set
+# CONFIG_HID_BELKIN is not set
+# CONFIG_HID_CHERRY is not set
+# CONFIG_HID_CHICONY is not set
+# CONFIG_HID_CYPRESS is not set
+# CONFIG_HID_DELL is not set
+# CONFIG_HID_EZKEY is not set
+# CONFIG_HID_GYRATION is not set
+# CONFIG_HID_LOGITECH is not set
+# CONFIG_HID_MICROSOFT is not set
+# CONFIG_HID_MONTEREY is not set
+# CONFIG_HID_PETALYNX is not set
+# CONFIG_HID_SAMSUNG is not set
+# CONFIG_HID_SONY is not set
+# CONFIG_HID_SUNPLUS is not set
 CONFIG_USB_SUPPORT=y
 CONFIG_USB_ARCH_HAS_HCD=y
 CONFIG_USB_ARCH_HAS_OHCI=y
@@ -1815,6 +1849,7 @@
 # CONFIG_USB_ACM is not set
 # CONFIG_USB_PRINTER is not set
 # CONFIG_USB_WDM is not set
+# CONFIG_USB_TMC is not set
 
 #
 # NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
@@ -1836,7 +1871,6 @@
 # CONFIG_USB_STORAGE_ALAUDA is not set
 # CONFIG_USB_STORAGE_ONETOUCH is not set
 # CONFIG_USB_STORAGE_KARMA is not set
-# CONFIG_USB_STORAGE_SIERRA is not set
 # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
 # CONFIG_USB_LIBUSUAL is not set
 
@@ -1857,6 +1891,7 @@
 # CONFIG_USB_EMI62 is not set
 # CONFIG_USB_EMI26 is not set
 # CONFIG_USB_ADUTUX is not set
+# CONFIG_USB_SEVSEG is not set
 # CONFIG_USB_RIO500 is not set
 # CONFIG_USB_LEGOTOWER is not set
 # CONFIG_USB_LCD is not set
@@ -1874,6 +1909,7 @@
 # CONFIG_USB_IOWARRIOR is not set
 # CONFIG_USB_TEST is not set
 # CONFIG_USB_ISIGHTFW is not set
+# CONFIG_USB_GOTEMP is not set
 # CONFIG_USB_GADGET is not set
 # CONFIG_MMC is not set
 # CONFIG_MEMSTICK is not set
@@ -1955,6 +1991,7 @@
 CONFIG_JFS_DEBUG=y
 CONFIG_JFS_STATISTICS=y
 CONFIG_FS_POSIX_ACL=y
+CONFIG_FILE_LOCKING=y
 CONFIG_XFS_FS=m
 CONFIG_XFS_QUOTA=y
 CONFIG_XFS_POSIX_ACL=y
@@ -2049,6 +2086,7 @@
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=m
 CONFIG_SUNRPC_GSS=m
+# CONFIG_SUNRPC_REGISTER_V4 is not set
 CONFIG_RPCSEC_GSS_KRB5=m
 CONFIG_RPCSEC_GSS_SPKM3=m
 # CONFIG_SMB_FS is not set
@@ -2137,7 +2175,6 @@
 # CONFIG_DEBUG_SLAB is not set
 # CONFIG_DEBUG_PREEMPT is not set
 # CONFIG_DEBUG_RT_MUTEXES is not set
-# CONFIG_RT_MUTEX_TESTER is not set
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
 # CONFIG_DEBUG_LOCK_ALLOC is not set
@@ -2145,7 +2182,6 @@
 # CONFIG_LOCK_STAT is not set
 CONFIG_TRACE_IRQFLAGS=y
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
-# CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
 CONFIG_STACKTRACE=y
 # CONFIG_DEBUG_KOBJECT is not set
 CONFIG_DEBUG_BUGVERBOSE=y
@@ -2155,16 +2191,16 @@
 CONFIG_DEBUG_MEMORY_INIT=y
 CONFIG_DEBUG_LIST=y
 # CONFIG_DEBUG_SG is not set
+# CONFIG_DEBUG_NOTIFIERS is not set
 CONFIG_FRAME_POINTER=y
 CONFIG_BOOT_PRINTK_DELAY=y
-# CONFIG_RCU_TORTURE_TEST is not set
-# CONFIG_KPROBES_SANITY_TEST is not set
-# CONFIG_BACKTRACE_SELF_TEST is not set
-# CONFIG_LKDTM is not set
+# CONFIG_RCU_CPU_STALL is not set
+# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_LATENCYTOP=y
 CONFIG_HAVE_FTRACE=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
+CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
 CONFIG_TRACER_MAX_TRACE=y
 CONFIG_TRACING=y
 # CONFIG_FTRACE is not set
@@ -2175,12 +2211,16 @@
 CONFIG_CONTEXT_SWITCH_TRACER=y
 # CONFIG_FTRACE_STARTUP_TEST is not set
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
+# CONFIG_KMEMTRACE is not set
+# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
+# CONFIG_KERNEL_TESTS is not set
 CONFIG_STRICT_DEVMEM=y
 # CONFIG_X86_VERBOSE_BOOTUP is not set
 CONFIG_EARLY_PRINTK=y
+# CONFIG_EARLY_PRINTK_DBGP is not set
 CONFIG_DEBUG_STACKOVERFLOW=y
 CONFIG_DEBUG_STACK_USAGE=y
 # CONFIG_DEBUG_PAGEALLOC is not set
@@ -2233,10 +2273,12 @@
 #
 # Crypto core or helper
 #
+CONFIG_CRYPTO_FIPS=y
 CONFIG_CRYPTO_ALGAPI=y
 CONFIG_CRYPTO_AEAD=y
 CONFIG_CRYPTO_BLKCIPHER=y
 CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_RNG=y
 CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_GF128MUL=m
 CONFIG_CRYPTO_NULL=m
@@ -2272,6 +2314,7 @@
 # Digest
 #
 CONFIG_CRYPTO_CRC32C=m
+CONFIG_CRYPTO_CRC32C_INTEL=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MD5=y
 CONFIG_CRYPTO_MICHAEL_MIC=m
@@ -2313,6 +2356,11 @@
 #
 CONFIG_CRYPTO_DEFLATE=y
 CONFIG_CRYPTO_LZO=m
+
+#
+# Random Number Generation
+#
+CONFIG_CRYPTO_ANSI_CPRNG=m
 # CONFIG_CRYPTO_HW is not set
 CONFIG_HAVE_KVM=y
 CONFIG_VIRTUALIZATION=y



--==_Exmh_1220240176_3529P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFIu2MwcC3lWbTT17ARAixPAKDuR9D3cjgm89SmGtv+ZEw9UCwtXQCfZMIj
IeVmV8HIRHxZNt93zaTVMS4=
=xcnr
-----END PGP SIGNATURE-----

--==_Exmh_1220240176_3529P--


--===============1835083488==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1835083488==--
