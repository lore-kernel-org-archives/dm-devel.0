From: Ritesh Raj Sarraf <rrs@researchut.com>
Subject: Re: [dm-devel] Re: 2.6.24 Kernel Soft Lock Up with heavy I/O in dm-crypt
Date: Sat, 1 Mar 2008 00:29:12 +0530
Message-ID: <200803010029.18320.rrs@researchut.com>
References: <200802281924.03996.rrs@researchut.com> <20080228232048.51e28c1d.akpm@linux-foundation.org> <20080229184649.GJ1788@agk.fab.redhat.com>
Reply-To: Ritesh Raj Sarraf <rrs@researchut.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1219978.C8NxtIYE7P";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933484AbYB2S7s@vger.kernel.org>
In-Reply-To: <20080229184649.GJ1788@agk.fab.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Herbert Xu <herbert@gondor.apana.org.au>, Christophe Saout <christophe@saout.de>, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
List-Id: dm-devel.ids

--nextPart1219978.C8NxtIYE7P
Content-Type: multipart/mixed;
  boundary="Boundary-01=_BYFyH0Zu24oYD0D"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_BYFyH0Zu24oYD0D
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 01 March 2008, Alasdair G Kergon wrote:
> On Thu, Feb 28, 2008 at 11:20:48PM -0800, Andrew Morton wrote:
> > On Thu, 28 Feb 2008 19:24:03 +0530 Ritesh Raj Sarraf <rrs@researchut.co=
m>=20
wrote:
> > > Kernel: 2.6.24
> > > Distribution: Debian Testing/Unstable
> > > Tainted: Yes (nvidia proprietary drivers)
>
> Any chance you can try to reproduce it upstream e.g. in 2.6.25-rc3?
>
I can do that but only by Monday Evening IST.

Meanwhile I was able to reproduce the bug again with the same configuration=
=20
and the same scenario. So I believe that the bug can be reproduced=20
consistently.

Here are the steps:

1) Initialize a device using dm-crypt and LUKS
2) Create a filesystem on top of it and mount it.
3) Write huge amount of data (as a normal user). Something like 150GB.

As the load goes hight (to something like 12-14), the kernel lock-up is log=
ged=20
into dmesg.
At that moment, the OS is barely responsive.

The I/O scheduler in use is:
rrs@learner:/sys/block/sdb/queue$ cat scheduler
noop anticipatory deadline [cfq]

The kernel logs are the same like the last time but I'm attaching it. There=
=20
still is a delay of 11seconds.

Ritesh
=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."

--Boundary-01=_BYFyH0Zu24oYD0D
Content-Type: text/plain;
  charset="iso-8859-1";
  name="kernel.bug.new"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="kernel.bug.new"

dm-2 ino=3850241 scontext=system_u:system_r:rpcd_t tcontext=system_u:object_r:bin_t tclass=dir
audit(1204228759.615:24): avc:  denied  { execute } for  pid=3279 comm="rpc.statd" name="sm-notify" dev=dm-2 ino=3850484 scontext=system_u:system_r:rpcd_t tcontext=system_u:object_r:bin_t tclass=file
audit(1204228759.615:24): avc:  denied  { read } for  pid=3279 comm="rpc.statd" name="sm-notify" dev=dm-2 ino=3850484 scontext=system_u:system_r:rpcd_t tcontext=system_u:object_r:bin_t tclass=file
audit(1204228759.615:24): avc:  denied  { execute_no_trans } for  pid=3279 comm="rpc.statd" path="/sbin/sm-notify" dev=dm-2 ino=3850484 scontext=system_u:system_r:rpcd_t tcontext=system_u:object_r:bin_t tclass=file
audit(1204228759.615:24): arch=40000003 syscall=11 success=yes exit=0 a0=804f88a a1=bf9b2cb4 a2=bf9b2edc a3=1 items=0 ppid=3278 pid=3279 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) comm="sm-notify" exe="/sbin/sm-notify" subj=system_u:system_r:rpcd_t key=(null)
audit(1204228759.943:25): avc:  denied  { search } for  pid=3279 comm="sm-notify" scontext=system_u:system_r:rpcd_t tcontext=system_u:object_r:sysctl_fs_t tclass=dir
audit(1204228759.943:25): arch=40000003 syscall=5 success=no exit=-2 a0=804a67c a1=1 a2=4 a3=bf926528 items=0 ppid=3278 pid=3279 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) comm="sm-notify" exe="/sbin/sm-notify" subj=system_u:system_r:rpcd_t key=(null)
audit(1204228760.363:26): avc:  denied  { use } for  pid=3405 comm="loadkeys" path="/dev/console" dev=tmpfs ino=628 scontext=system_u:system_r:loadkeys_t tcontext=system_u:system_r:init_t tclass=fd
audit(1204228760.363:26): arch=40000003 syscall=11 success=yes exit=0 a0=8124ae8 a1=8124f88 a2=8104008 a3=8124ae8 items=0 ppid=3303 pid=3405 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 comm="loadkeys" exe="/bin/loadkeys" subj=system_u:system_r:loadkeys_t key=(null)
audit(1204228760.664:27): avc:  denied  { read write } for  pid=3444 comm="dmesg" name="tty1" dev=tmpfs ino=724 scontext=system_u:system_r:dmesg_t tcontext=system_u:object_r:tty_device_t tclass=chr_file
audit(1204228760.664:27): arch=40000003 syscall=11 success=yes exit=0 a0=8107788 a1=8107928 a2=8101408 a3=8107788 items=0 ppid=3417 pid=3444 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 comm="dmesg" exe="/bin/dmesg" subj=system_u:system_r:dmesg_t key=(null)
audit(1204228760.676:28): avc:  denied  { read } for  pid=3444 comm="dmesg" name="ld.so.cache" dev=dm-2 ino=2834454 scontext=system_u:system_r:dmesg_t tcontext=user_u:object_r:etc_t tclass=file
audit(1204228760.676:28): arch=40000003 syscall=5 success=yes exit=3 a0=b7f03b0f a1=0 a2=0 a3=ffffffff items=0 ppid=3417 pid=3444 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 comm="dmesg" exe="/bin/dmesg" subj=system_u:system_r:dmesg_t key=(null)
audit(1204228760.676:29): avc:  denied  { getattr } for  pid=3444 comm="dmesg" path="/etc/ld.so.cache" dev=dm-2 ino=2834454 scontext=system_u:system_r:dmesg_t tcontext=user_u:object_r:etc_t tclass=file
audit(1204228760.676:29): arch=40000003 syscall=197 success=yes exit=0 a0=3 a1=bff5fa80 a2=b7f05ff4 a3=ffffffff items=0 ppid=3417 pid=3444 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=tty1 comm="dmesg" exe="/bin/dmesg" subj=system_u:system_r:dmesg_t key=(null)
audit(1204228761.035:30): avc:  denied  { setsched } for  pid=3500 comm="modprobe" scontext=system_u:system_r:insmod_t tcontext=system_u:system_r:kernel_t tclass=process
audit(1204228761.035:30): arch=40000003 syscall=128 success=yes exit=0 a0=b7f92000 a1=183a a2=805d758 a3=805d758 items=0 ppid=3481 pid=3500 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) comm="modprobe" exe="/sbin/modprobe" subj=system_u:system_r:insmod_t key=(null)
audit(1204228761.459:31): avc:  denied  { use } for  pid=3575 comm="vbetool" path="/dev/console" dev=tmpfs ino=628 scontext=system_u:system_r:vbetool_t tcontext=system_u:system_r:init_t tclass=fd
audit(1204228761.459:31): avc:  denied  { read write } for  pid=3575 comm="vbetool" path="/dev/console" dev=tmpfs ino=628 scontext=system_u:system_r:vbetool_t tcontext=system_u:object_r:console_device_t tclass=chr_file
audit(1204228761.459:31): avc:  denied  { write } for  pid=3575 comm="vbetool" path="/var/lib/acpi-support/vbestate" dev=dm-2 ino=4063580 scontext=system_u:system_r:vbetool_t tcontext=system_u:object_r:var_lib_t tclass=file
audit(1204228761.459:31): arch=40000003 syscall=11 success=yes exit=0 a0=8103708 a1=8113b48 a2=8103e08 a3=8103708 items=0 ppid=3563 pid=3575 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) comm="vbetool" exe="/usr/sbin/vbetool" subj=system_u:system_r:vbetool_t key=(null)
audit(1204228761.487:32): avc:  denied  { read } for  pid=3575 comm="vbetool" name="ld.so.cache" dev=dm-2 ino=2834454 scontext=system_u:system_r:vbetool_t tcontext=user_u:object_r:etc_t tclass=file
audit(1204228761.487:32): arch=40000003 syscall=5 success=yes exit=3 a0=b7f01b0f a1=0 a2=0 a3=ffffffff items=0 ppid=3563 pid=3575 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) comm="vbetool" exe="/usr/sbin/vbetool" subj=system_u:system_r:vbetool_t key=(null)
audit(1204228761.487:33): avc:  denied  { getattr } for  pid=3575 comm="vbetool" path="/etc/ld.so.cache" dev=dm-2 ino=2834454 scontext=system_u:system_r:vbetool_t tcontext=user_u:object_r:etc_t tclass=file
audit(1204228761.487:33): arch=40000003 syscall=197 success=yes exit=0 a0=3 a1=bfeda470 a2=b7f03ff4 a3=ffffffff items=0 ppid=3563 pid=3575 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) comm="vbetool" exe="/usr/sbin/vbetool" subj=system_u:system_r:vbetool_t key=(null)
audit(1204228762.095:34): avc:  denied  { write } for  pid=3601 comm="auditd" name="log" dev=tmpfs ino=9797 scontext=system_u:system_r:auditd_t tcontext=system_u:object_r:device_t tclass=sock_file
audit(1204228762.095:34): avc:  denied  { sendto } for  pid=3601 comm="auditd" path="/dev/log" scontext=system_u:system_r:auditd_t tcontext=system_u:system_r:initrc_t tclass=unix_dgram_socket
audit(1204228762.095:34): arch=40000003 syscall=102 success=yes exit=0 a0=3 a1=bf9e0980 a2=b7f42ff4 a3=0 items=0 ppid=3600 pid=3601 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) comm="auditd" exe="/sbin/auditd" subj=system_u:system_r:auditd_t key=(null)
audit(1204228762.095:35): audit_pid=3601 old=0 by auid=4294967295 subj=system_u:system_r:auditd_t
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ADDRCONF(NETDEV_UP): eth0: link is not ready
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
ADDRCONF(NETDEV_UP): wlan0_rename: link is not ready
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  169.09  Fri Jan 11 14:38:28 PST 2008
NET: Registered protocol family 4
NET: Registered protocol family 3
NET: Registered protocol family 5
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
wlan0_rename: Initial auth_alg=0
wlan0_rename: authenticate with AP 00:16:b6:a5:e7:1c
wlan0_rename: RX authentication from 00:16:b6:a5:e7:1c (alg=0 transaction=2 status=0)
wlan0_rename: authenticated
wlan0_rename: associate with AP 00:16:b6:a5:e7:1c
wlan0_rename: RX AssocResp from 00:16:b6:a5:e7:1c (capab=0x411 status=0 aid=2)
wlan0_rename: associated
wlan0_rename: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 burst=0
wlan0_rename: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 burst=0
wlan0_rename: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 burst=30
wlan0_rename: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 burst=15
ADDRCONF(NETDEV_CHANGE): wlan0_rename: link becomes ready
SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
wlan0_rename: no IPv6 routers present
tun0: Disabled Privacy Extensions
usb 5-1: new high speed USB device using ehci_hcd and address 7
usb 5-1: configuration #1 chosen from 1 choice
scsi3 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 7
usb-storage: waiting for device to settle before scanning
usb-storage: device scan complete
scsi 3:0:0:0: Direct-Access     WD       1600BEV External 1.04 PQ: 0 ANSI: 4
sd 3:0:0:0: [sdc] 312581808 512-byte hardware sectors (160042 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 21 00 00 00
sd 3:0:0:0: [sdc] Assuming drive cache: write through
sd 3:0:0:0: [sdc] 312581808 512-byte hardware sectors (160042 MB)
sd 3:0:0:0: [sdc] Write Protect is off
sd 3:0:0:0: [sdc] Mode Sense: 21 00 00 00
sd 3:0:0:0: [sdc] Assuming drive cache: write through
 sdc: sdc1
sd 3:0:0:0: [sdc] Attached SCSI disk
sd 3:0:0:0: Attached scsi generic sg3 type 0
SELinux: initialized (dev sdc1, type vfat), uses genfs_contexts
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev dm-3, type ext3), uses xattr
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev dm-3, type ext3), uses xattr
BUG: soft lockup - CPU#1 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b492c>] EFLAGS: 00000206 CPU: 1
EIP is at aes_enc_blk+0x92c/0xb6c [aes_i586]
EAX: 672bf2e1 EBX: 0c20e1b7 ECX: a5e532cb EDX: 00000032
ESI: 07f20dd2 EDI: 4157f550 EBP: f0534030 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: bfbe00f4 CR3: 2fc7c000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b4766>] EFLAGS: 00000202 CPU: 0
EIP is at aes_enc_blk+0x766/0xb6c [aes_i586]
EAX: 70d3e825 EBX: d2c6b2e3 ECX: 25678de9 EDX: 000000e9
ESI: 985c2cf3 EDI: a23bc889 EBP: f0534030 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 0807d9e0 CR3: 2fc7c000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b451e>] EFLAGS: 00000282 CPU: 0
EIP is at aes_enc_blk+0x51e/0xb6c [aes_i586]
EAX: 00004d54 EBX: 629c8c3d ECX: 9769e3f4 EDX: 00000005
ESI: f0d1e8b0 EDI: c8e0c4b5 EBP: f0534030 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f773c CR3: 2fc7c000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
iwl3945: Microcode SW error detected.  Restarting 0x82000008.
iwl3945: Can't stop Rx DMA.
BUG: soft lockup - CPU#1 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<c01d1c59>] EFLAGS: 00000206 CPU: 1
EIP is at scatterwalk_done+0x6/0xf
EAX: f07fbe30 EBX: 00000000 ECX: 00000000 EDX: 00000000
ESI: fffa9600 EDI: f07fbe90 EBP: f07fbe20 ESP: f07fbdc0
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f773c CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f891538e>] blkcipher_walk_done+0x140/0x1fe [blkcipher]
 [<f89183cc>] crypto_cbc_encrypt+0x132/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#1 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b4929>] EFLAGS: 00000286 CPU: 1
EIP is at aes_enc_blk+0x929/0xb6c [aes_i586]
EAX: f85e870b EBX: 5454cd9b ECX: b3b420c2 EDX: 000000c2
ESI: ae1d0541 EDI: 1c0a4fb7 EBP: f0534030 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f773c CR3: 2fc7c000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<c0128f6c>] EFLAGS: 00000202 CPU: 0
EIP is at __do_softirq+0x57/0xd3
EAX: c03b4860 EBX: 00000020 ECX: 00000009 EDX: 01c5c000
ESI: c036a200 EDI: 0000000a EBP: 00000000 ESP: f07fbd54
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f773c CR3: 1f8cb000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c012902d>] do_softirq+0x45/0x53
 [<c0129291>] irq_exit+0x38/0x6b
 [<c01066f2>] do_IRQ+0x5a/0x70
 [<f8852a06>] ehci_irq+0x13e/0x161 [ehci_hcd]
 [<c01048c3>] common_interrupt+0x23/0x28
 [<c01d007b>] cap_syslog+0x1d/0x20
 [<f89b4517>] aes_enc_blk+0x517/0xb6c [aes_i586]
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b4035>] EFLAGS: 00000293 CPU: 0
EIP is at aes_enc_blk+0x35/0xb6c [aes_i586]
EAX: 4458f5df EBX: 83636dd3 ECX: f07fbe80 EDX: 0000000a
ESI: a9e624c0 EDI: 9114fb98 EBP: f0534030 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: b7f6a000 CR3: 2fc7c000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b47ec>] EFLAGS: 00000282 CPU: 0
EIP is at aes_enc_blk+0x7ec/0xb6c [aes_i586]
EAX: a99a76bf EBX: 3560b875 ECX: 295127af EDX: 0000001a
ESI: c842b8d6 EDI: 3235a54f EBP: f0534030 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 0830fbdc CR3: 37fde000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b402f>] EFLAGS: 00000296 CPU: 0
EIP is at aes_enc_blk+0x2f/0xb6c [aes_i586]
EAX: 22254b51 EBX: ac4d2980 ECX: f07fbe80 EDX: 0000000a
ESI: 8e10c34b EDI: 1b82caec EBP: f0534020 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 0838c178 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b4609>] EFLAGS: 00000286 CPU: 0
EIP is at aes_enc_blk+0x609/0xb6c [aes_i586]
EAX: d64cf16b EBX: c668b39c ECX: a70e014d EDX: 0000004d
ESI: f9912a33 EDI: 71758637 EBP: f0534030 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 0807d9e0 CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b4001>] EFLAGS: 00000292 CPU: 0
EIP is at aes_enc_blk+0x1/0xb6c [aes_i586]
EAX: f0534400 EBX: f0534400 ECX: f07fbe80 EDX: f07fbe80
ESI: f120dac0 EDI: f07fbe90 EBP: f07fbebc ESP: f07fbe44
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 084b0fb0 CR3: 1f8cb000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f889fc08>] crypt_iv_essiv_gen+0x45/0x4c [dm_crypt]
 [<f889f629>] crypt_convert_scatterlist+0x54/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b4446>] EFLAGS: 00000286 CPU: 0
EIP is at aes_enc_blk+0x446/0xb6c [aes_i586]
EAX: 8b9d3e63 EBX: a71d3357 ECX: 175afea6 EDX: 000000a6
ESI: 65c1c3a1 EDI: a332ca36 EBP: f0534030 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f773c CR3: 31216000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b49f3>] EFLAGS: 00000202 CPU: 0
EIP is at aes_enc_blk+0x9f3/0xb6c [aes_i586]
EAX: f9681c08 EBX: 4728e46f ECX: 85bbb6a5 EDX: 00000099
ESI: 0345141f EDI: 453c0181 EBP: f0534030 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f773c CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b4026>] EFLAGS: 00000202 CPU: 0
EIP is at aes_enc_blk+0x26/0xb6c [aes_i586]
EAX: 9f4295a8 EBX: 09b75cbc ECX: f07fbe80 EDX: 0000000a
ESI: 9b040326 EDI: afa57368 EBP: f0534020 ESP: f07fbdd4
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f773c CR3: 2fc7c000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<c01dd80a>] cfq_allow_merge+0x0/0x5a
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<c011ad36>] EFLAGS: 00000292 CPU: 0
EIP is at native_flush_tlb_single+0x3/0x4
EAX: fffb7000 EBX: fffb7000 ECX: c03b6edc EDX: fffb7000
ESI: c0345160 EDI: 00000003 EBP: 00000000 ESP: f07fbda8
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 08251e90 CR3: 2fc7c000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c011d0e9>] kunmap_atomic+0x60/0x94
 [<f89152d5>] blkcipher_walk_done+0x87/0x1fe [blkcipher]
 [<f89183cc>] crypto_cbc_encrypt+0x132/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0135554>] prepare_to_wait+0x12/0x49
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
BUG: soft lockup - CPU#0 stuck for 11s! [kcryptd:10051]

Pid: 10051, comm: kcryptd Tainted: P        (2.6.24-1-686 #1)
EIP: 0060:[<f89b4850>] EFLAGS: 00000282 CPU: 0
EIP is at aes_enc_blk+0x850/0xb6c [aes_i586]
EAX: fb6342c0 EBX: 9266f5c2 ECX: a132d120 EDX: 0000009b
ESI: a68a3829 EDI: 5de8424b EBP: f0534030 ESP: f07fbdcc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: 080f773c CR3: 003b5000 CR4: 000026d0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<f89b5702>] aes_encrypt+0x13/0x17 [aes_i586]
 [<f891838d>] crypto_cbc_encrypt+0xf3/0x146 [cbc]
 [<f891802f>] xor_128+0x0/0x17 [cbc]
 [<f89b56ef>] aes_encrypt+0x0/0x17 [aes_i586]
 [<f889f648>] crypt_convert_scatterlist+0x73/0xc3 [dm_crypt]
 [<f889f7e0>] crypt_convert+0x148/0x185 [dm_crypt]
 [<f889f9fe>] kcryptd_do_crypt+0x1e1/0x25e [dm_crypt]
 [<f889f81d>] kcryptd_do_crypt+0x0/0x25e [dm_crypt]
 [<c0132225>] run_workqueue+0x7d/0x109
 [<c0132a9b>] worker_thread+0x0/0xc5
 [<c0132b55>] worker_thread+0xba/0xc5
 [<c0135441>] autoremove_wake_function+0x0/0x35
 [<c013537a>] kthread+0x38/0x5e
 [<c0135342>] kthread+0x0/0x5e
 [<c0104b0f>] kernel_thread_helper+0x7/0x10
 =======================
ADDRCONF(NETDEV_CHANGE): wlan0_rename: link becomes ready
wlan0_rename: deauthenticate(reason=3)
ADDRCONF(NETDEV_UP): wlan0_rename: link is not ready
wlan0_rename: Initial auth_alg=0
wlan0_rename: authenticate with AP 00:16:b6:a5:e7:1c
wlan0_rename: RX authentication from 00:16:b6:a5:e7:1c (alg=0 transaction=2 status=0)
wlan0_rename: authenticated
wlan0_rename: associate with AP 00:16:b6:a5:e7:1c
wlan0_rename: RX AssocResp from 00:16:b6:a5:e7:1c (capab=0x411 status=0 aid=2)
wlan0_rename: associated
wlan0_rename: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 burst=0
wlan0_rename: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 burst=0
wlan0_rename: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 burst=30
wlan0_rename: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 burst=15
ADDRCONF(NETDEV_CHANGE): wlan0_rename: link becomes ready
wlan0_rename: no IPv6 routers present
tun0: Disabled Privacy Extensions

--Boundary-01=_BYFyH0Zu24oYD0D--

--nextPart1219978.C8NxtIYE7P
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHyFYG4Rhi6gTxMLwRAl4dAJ9Wv07q2knglTyoTJBOwvCG59/0cwCfTWnv
nv0UK55S/rYkBYCABqnAaow=
=Vsbo
-----END PGP SIGNATURE-----

--nextPart1219978.C8NxtIYE7P--
