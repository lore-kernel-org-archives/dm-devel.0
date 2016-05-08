From: "James Johnston" <johnstonj.public@codenest.com>
Subject: bcache gets stuck flushing writeback cache when used in combination with LUKS/dm-crypt and non-default bucket size
Date: Sun, 8 May 2016 18:39:04 -0000
Message-ID: <044401d1a958$ea7ef4e0$bf7cdea0$@codenest.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-bcache-owner@vger.kernel.org
To: 'Kent Overstreet' <kent.overstreet@gmail.com>, 'Alasdair Kergon' <agk@redhat.com>, 'Mike Snitzer' <snitzer@redhat.com>
Cc: linux-bcache@vger.kernel.org, dm-devel@redhat.com, dm-crypt@saout.de
List-Id: dm-devel.ids

Hi,

[1.] One line summary of the problem:

bcache gets stuck flushing writeback cache when used in combination with
LUKS/dm-crypt and non-default bucket size

[2.] Full description of the problem/report:

I've run into a problem where the bcache writeback cache can't be flushed to
disk when the backing device is a LUKS / dm-crypt device and the cache set has
a non-default bucket size.  Basically, only a few megabytes will be flushed to
disk, and then it gets stuck.  Stuck means that the bcache writeback task
thrashes the disk by constantly reading hundreds of MB/second from the cache set
in an infinite loop, while not actually progressing (dirty_data never decreases
beyond a certain point).

I am wondering if anybody else can reproduce this apparent bug?  Apologies for
mailing both device mapper and bcache mailing lists, but I'm not sure where the
bug lies as I've only reproduced it when both are used in combination.

The situation is basically unrecoverable as far as I can tell: if you attempt
to detach the cache set then the cache set disk gets thrashed extra-hard
forever, and it's impossible to actually get the cache set detached.  The only
solution seems to be to back up the data and destroy the volume...

[3.] Keywords (i.e., modules, networking, kernel):

bcache, dm-crypt, LUKS, device mapper, LVM

[4.] Kernel information
[4.1.] Kernel version (from /proc/version):
Linux version 4.6.0-040600rc6-generic (kernel@gloin) (gcc version 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2) ) #201605012031 SMP Mon May 2 00:33:26 UTC 2016

[7.] A small shell script or example program which triggers the
     problem (if possible)

Here are the steps I used to reproduce:

1.  Set up an Ubuntu 16.04 virtual machine in VMware with three SATA hard
    drives.  Ubuntu was installed with default settings, except that: (1) guided
    partitioning used with NO LVM or dm-crypt, (2) OpenSSH server installed.
    First SATA drive has operating system installation.  Second SATA drive is
    used for bcache cache set.  Third SATA drive has dm-crypt/LUKS + bcache
    backing device.  Note that all drives have 512 byte physical sectors.  Also,
    all virtual drives are backed by a single physical SSD with 512 byte
    sectors. (i.e. not advanced format)

2.  Ubuntu was updated to latest packages as of 5/8/2016.  The problem
    reproduces with both distribution kernel 4.4.0-22-generic and also mainline
    kernel 4.6.0-040600rc6-generic distributed by Ubuntu kernel team.  Installed
    bcache-tools package was 1.0.8-2.  Installed cryptsetup-bin package was
    2:1.6.6-5ubuntu2.

3.  Set up the cache set, dm-crypt, and backing device:

sudo -s
# Make cache set on second drive
# IMPORTANT:  Problem does not occur if I omit --bucket parameter.
make-bcache --bucket 2M -C /dev/sdb
# Set up LUKS/dm-crypt on second drive.
# IMPORTANT:  Problem does not occur if I omit the dm-crypt layer.
cryptsetup luksFormat /dev/sdc
cryptsetup open --type luks /dev/sdc backCrypt
# Make bcache backing device & enable writeback
make-bcache -B /dev/mapper/backCrypt
bcache-super-show /dev/sdb | grep cset.uuid | \
cut -f 3 > /sys/block/bcache0/bcache/attach
echo writeback > /sys/block/bcache0/bcache/cache_mode

4.  Finally, this is the kill sequence to bring the system to its knees:

sudo -s
cd /sys/block/bcache0/bcache
echo 0 > sequential_cutoff
# Verify that the cache is attached (i.e. does not say "no cache").  It should
# say that it's clean since we haven't written anything yet.
cat state
# Copy some random data.
dd if=/dev/urandom of=/dev/bcache0 bs=1M count=250
# Show current state.  On my system approximately 20 to 25 MB remain in
# writeback cache.
cat dirty_data
cat state
# Detach the cache set.  This will start the cache set disk thrashing.
echo 1 > detach
# After a few moments, confirm that the cache set is not going anywhere.  On
# my system, only a few MB have been flushed as evidenced by a small decrease
# in dirty_data.  State remains dirty.
cat dirty_data
cat state
# At this point, the hypervisor system reports hundreds of MB/second of reads
# to the underlying physical SSD coming from the virtual machine; the hard drive
# light is stuck on...  hypervisor status bar shows the activity is on cache
# set.  No writes seem to be occurring on any disk.

[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)
Linux bcachetest2 4.6.0-040600rc6-generic #201605012031 SMP Mon May 2 00:33:26 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

Util-linux              2.27.1
Mount                   2.27.1
Module-init-tools       22
E2fsprogs               1.42.13
Xfsprogs                4.3.0
Linux C Library         2.23
Dynamic linker (ldd)    2.23
Linux C++ Library       6.0.21
Procps                  3.3.10
Net-tools               1.60
Kbd                     1.15.5
Console-tools           1.15.5
Sh-utils                8.25
Udev                    229
Modules Loaded          8250_fintek ablk_helper aesni_intel aes_x86_64 ahci async_memcpy async_pq async_raid6_recov async_tx async_xor autofs4 btrfs configfs coretemp crc32_pclmul crct10dif_pclmul cryptd drm drm_kms_helper e1000 fb_sys_fops fjes gf128mul ghash_clmulni_intel glue_helper hid hid_generic i2c_piix4 ib_addr ib_cm ib_core ib_iser ib_mad ib_sa input_leds iscsi_tcp iw_cm joydev libahci libcrc32c libiscsi libiscsi_tcp linear lrw mac_hid mptbase mptscsih mptspi multipath nfit parport parport_pc pata_acpi ppdev psmouse raid0 raid10 raid1 raid456 raid6_pq rdma_cm scsi_transport_iscsi scsi_transport_spi serio_raw shpchp syscopyarea sysfillrect sysimgblt ttm usbhid vmw_balloon vmwgfx vmw_vmci vmw_vsock_vmci_transport vsock xor

[8.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 42
model name      : Intel(R) Core(TM) i5-2520M CPU @ 2.50GHz
stepping        : 7
microcode       : 0x29
cpu MHz         : 2491.980
cache size      : 3072 KB
physical id     : 0
siblings        : 1
core id         : 0
cpu cores       : 1
apicid          : 0
initial apicid  : 0
fpu             : yes
fpu_exception   : yes
cpuid level     : 13
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts mmx fxsr sse sse2 ss syscall nx rdtscp lm constant_tsc arch_perfmon pebs bts nopl xtopology tsc_reliable nonstop_tsc aperfmperf eagerfpu pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic popcnt tsc_deadline_timer aes xsave avx hypervisor lahf_lm epb tsc_adjust dtherm ida arat pln pts
bugs            :
bogomips        : 4983.96
clflush size    : 64
cache_alignment : 64
address sizes   : 42 bits physical, 48 bits virtual
power management:

[8.3.] Module information (from /proc/modules):
ppdev 20480 0 - Live 0x0000000000000000
vmw_balloon 20480 0 - Live 0x0000000000000000
vmw_vsock_vmci_transport 28672 1 - Live 0x0000000000000000
vsock 36864 2 vmw_vsock_vmci_transport, Live 0x0000000000000000
coretemp 16384 0 - Live 0x0000000000000000
joydev 20480 0 - Live 0x0000000000000000
input_leds 16384 0 - Live 0x0000000000000000
serio_raw 16384 0 - Live 0x0000000000000000
shpchp 36864 0 - Live 0x0000000000000000
vmw_vmci 65536 2 vmw_balloon,vmw_vsock_vmci_transport, Live 0x0000000000000000
i2c_piix4 24576 0 - Live 0x0000000000000000
nfit 40960 0 - Live 0x0000000000000000
8250_fintek 16384 0 - Live 0x0000000000000000
parport_pc 32768 0 - Live 0x0000000000000000
parport 49152 2 ppdev,parport_pc, Live 0x0000000000000000
mac_hid 16384 0 - Live 0x0000000000000000
ib_iser 49152 0 - Live 0x0000000000000000
rdma_cm 53248 1 ib_iser, Live 0x0000000000000000
iw_cm 49152 1 rdma_cm, Live 0x0000000000000000
ib_cm 45056 1 rdma_cm, Live 0x0000000000000000
ib_sa 36864 2 rdma_cm,ib_cm, Live 0x0000000000000000
ib_mad 49152 2 ib_cm,ib_sa, Live 0x0000000000000000
ib_core 122880 6 ib_iser,rdma_cm,iw_cm,ib_cm,ib_sa,ib_mad, Live 0x0000000000000000
ib_addr 20480 3 rdma_cm,ib_sa,ib_core, Live 0x0000000000000000
configfs 40960 2 rdma_cm, Live 0x0000000000000000
iscsi_tcp 20480 0 - Live 0x0000000000000000
libiscsi_tcp 24576 1 iscsi_tcp, Live 0x0000000000000000
libiscsi 53248 3 ib_iser,iscsi_tcp,libiscsi_tcp, Live 0x0000000000000000
scsi_transport_iscsi 98304 4 ib_iser,iscsi_tcp,libiscsi, Live 0x0000000000000000
autofs4 40960 2 - Live 0x0000000000000000
btrfs 1024000 0 - Live 0x0000000000000000
raid10 49152 0 - Live 0x0000000000000000
raid456 110592 0 - Live 0x0000000000000000
async_raid6_recov 20480 1 raid456, Live 0x0000000000000000
async_memcpy 16384 2 raid456,async_raid6_recov, Live 0x0000000000000000
async_pq 16384 2 raid456,async_raid6_recov, Live 0x0000000000000000
async_xor 16384 3 raid456,async_raid6_recov,async_pq, Live 0x0000000000000000
async_tx 16384 5 raid456,async_raid6_recov,async_memcpy,async_pq,async_xor, Live 0x0000000000000000
xor 24576 2 btrfs,async_xor, Live 0x0000000000000000
raid6_pq 102400 4 btrfs,raid456,async_raid6_recov,async_pq, Live 0x0000000000000000
libcrc32c 16384 1 raid456, Live 0x0000000000000000
raid1 36864 0 - Live 0x0000000000000000
raid0 20480 0 - Live 0x0000000000000000
multipath 16384 0 - Live 0x0000000000000000
linear 16384 0 - Live 0x0000000000000000
hid_generic 16384 0 - Live 0x0000000000000000
usbhid 49152 0 - Live 0x0000000000000000
hid 122880 2 hid_generic,usbhid, Live 0x0000000000000000
crct10dif_pclmul 16384 0 - Live 0x0000000000000000
crc32_pclmul 16384 0 - Live 0x0000000000000000
ghash_clmulni_intel 16384 0 - Live 0x0000000000000000
aesni_intel 167936 0 - Live 0x0000000000000000
aes_x86_64 20480 1 aesni_intel, Live 0x0000000000000000
lrw 16384 1 aesni_intel, Live 0x0000000000000000
gf128mul 16384 1 lrw, Live 0x0000000000000000
glue_helper 16384 1 aesni_intel, Live 0x0000000000000000
ablk_helper 16384 1 aesni_intel, Live 0x0000000000000000
cryptd 20480 3 ghash_clmulni_intel,aesni_intel,ablk_helper, Live 0x0000000000000000
vmwgfx 237568 1 - Live 0x0000000000000000
ttm 98304 1 vmwgfx, Live 0x0000000000000000
drm_kms_helper 147456 1 vmwgfx, Live 0x0000000000000000
syscopyarea 16384 1 drm_kms_helper, Live 0x0000000000000000
psmouse 131072 0 - Live 0x0000000000000000
sysfillrect 16384 1 drm_kms_helper, Live 0x0000000000000000
sysimgblt 16384 1 drm_kms_helper, Live 0x0000000000000000
fb_sys_fops 16384 1 drm_kms_helper, Live 0x0000000000000000
drm 364544 4 vmwgfx,ttm,drm_kms_helper, Live 0x0000000000000000
ahci 36864 2 - Live 0x0000000000000000
libahci 32768 1 ahci, Live 0x0000000000000000
e1000 135168 0 - Live 0x0000000000000000
mptspi 24576 0 - Live 0x0000000000000000
mptscsih 40960 1 mptspi, Live 0x0000000000000000
mptbase 102400 2 mptspi,mptscsih, Live 0x0000000000000000
scsi_transport_spi 32768 1 mptspi, Live 0x0000000000000000
pata_acpi 16384 0 - Live 0x0000000000000000
fjes 28672 0 - Live 0x0000000000000000

[8.6.] SCSI information (from /proc/scsi/scsi)
Attached devices:
Host: scsi3 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: VMware Virtual S Rev: 0001
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: NECVMWar Model: VMware SATA CD01 Rev: 1.00
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi5 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: VMware Virtual S Rev: 0001
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi6 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: VMware Virtual S Rev: 0001
  Type:   Direct-Access                    ANSI  SCSI revision: 05

Best regards,

James Johnston
