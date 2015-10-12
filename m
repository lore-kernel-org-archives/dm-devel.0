From: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: Next-20151009 - crash during boot
Date: Mon, 12 Oct 2015 17:50:08 -0400
Message-ID: <7951.1444686608@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1444686608_3721P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

--==_Exmh_1444686608_3721P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

Next-20151009 crashes early in boot (right after I feed cryptsetup
the passphrase for my root filesystem).

(Yes, the kernel is 10 commits past linux-next - they're all cleanup patc=
hes for
drivers/staging that shouldn't enter into it)

It appears to possibly be the same one reported by the =22Linux Test Robo=
t=22,
which called this out:

commit e817ef9b89e5bbfdb2a67ca9896909f414b2af91 (=22dm ioctl: use kvfree(=
) in free_params()=22)

=5B    3.091763=5D systemd=5B1=5D: Started Setup Virtual Console.
=5B    3.093577=5D systemd=5B1=5D: Started Journal Service.
=5B    3.065868=5D input: HDA NVidia HDMI as /devices/pci0000:00/0000:00:=
01.0/0000:01:00.1/sound/card1/input16
=5B    3.092036=5D audit: type=3D1130 audit(1444682380.795:4): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsyst=
emd-vconsole-setup comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    3.093873=5D audit: type=3D1130 audit(1444682380.797:5): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsyst=
emd-journald comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 ho=
stname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    3.109485=5D usb 3-1: New USB device found, idVendor=3D8087, idProd=
uct=3D0024
=5B    3.109489=5D usb 3-1: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
=5B    3.109911=5D hub 3-1:1.0: USB hub found
=5B    3.109972=5D hub 3-1:1.0: 6 ports detected
=5B    3.134620=5D usb 4-1: New USB device found, idVendor=3D8087, idProd=
uct=3D0024
=5B    3.134625=5D usb 4-1: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
=5B    3.135035=5D hub 4-1:1.0: USB hub found
=5B    3.135094=5D hub 4-1:1.0: 8 ports detected
=5B    3.147376=5D audit: type=3D1130 audit(1444682380.851:6): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Ddrac=
ut-cmdline comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 host=
name=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    3.189141=5D audit: type=3D1130 audit(1444682380.892:7): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Ddrac=
ut-pre-udev comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 hos=
tname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    3.202732=5D audit: type=3D1130 audit(1444682380.906:8): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsyst=
emd-udevd comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 hostn=
ame=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    3.211218=5D usb 1-1: New USB device found, idVendor=3D045e, idProd=
uct=3D0023
=5B    3.211224=5D usb 1-1: New USB device strings: Mfr=3D1, Product=3D2,=
 SerialNumber=3D0
=5B    3.211228=5D usb 1-1: Product: Microsoft Trackball Optical=AE
=5B    3.211231=5D usb 1-1: Manufacturer: Microsoft
=5B    3.211660=5D usb 1-1: ep 0x81 - rounding interval to 64 microframes=
, ep desc says 80 microframes
=5B    3.219238=5D input: Microsoft Microsoft Trackball Optical=AE as /de=
vices/pci0000:00/0000:00:14.0/usb1/1-1/1-1:1.0/0003:045E:0023.0001/input/=
input17
=5B    3.221834=5D hid-generic 0003:045E:0023.0001: input,hidraw0: USB HI=
D v1.00 Mouse =5BMicrosoft Microsoft Trackball Optical=AE=5D on usb-0000:=
00:14.0-1/input0
=5B    3.295262=5D tsc: Refined TSC clocksource calibration: 2691.266 MHz=

=5B    3.295267=5D clocksource: tsc: mask: 0xffffffffffffffff max_cycles:=
 0x26cb03e1271, max_idle_ns: 440795257954 ns
=5B    3.325988=5D input: PS/2 Generic Mouse as /devices/platform/i8042/s=
erio1/input/input7
=5B    3.379168=5D usb 1-4: new high-speed USB device number 3 using xhci=
_hcd
=5B    3.411161=5D usb 4-1.7: new high-speed USB device number 3 using eh=
ci-pci
=5B    3.496624=5D usb 4-1.7: New USB device found, idVendor=3D413c, idPr=
oduct=3D2513
=5B    3.496630=5D usb 4-1.7: New USB device strings: Mfr=3D0, Product=3D=
0, SerialNumber=3D0
=5B    3.503287=5D e1000e 0000:00:19.0 eno1: renamed from eth0
=5B    3.505607=5D hub 4-1.7:1.0: USB hub found
=5B    3.505748=5D hub 4-1.7:1.0: 3 ports detected
=5B    3.512446=5D audit: type=3D1130 audit(1444682381.216:9): pid=3D1 ui=
d=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsyst=
emd-udev-trigger comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=
=22 hostname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    3.514678=5D udevadm (328) used greatest stack depth: 12584 bytes l=
eft
=5B    3.544576=5D usb 1-4: New USB device found, idVendor=3D413c, idProd=
uct=3D2134
=5B    3.544581=5D usb 1-4: New USB device strings: Mfr=3D1, Product=3D2,=
 SerialNumber=3D0
=5B    3.544585=5D usb 1-4: Product: USB2134
=5B    3.544588=5D usb 1-4: Manufacturer: SMSC
=5B    3.565003=5D hub 1-4:1.0: USB hub found
=5B    3.565062=5D hub 1-4:1.0: 3 ports detected
=5B    3.606174=5D usb 4-1.8: new full-speed USB device number 4 using eh=
ci-pci
=5B    3.715922=5D usb 4-1.8: New USB device found, idVendor=3D0a5c, idPr=
oduct=3D5801
=5B    3.715926=5D usb 4-1.8: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D3
=5B    3.715928=5D usb 4-1.8: Product: 5880
=5B    3.715930=5D usb 4-1.8: Manufacturer: Broadcom Corp
=5B    3.715931=5D usb 4-1.8: SerialNumber: 0123456789ABCD
=5B    3.716285=5D usb 4-1.8: config 0 descriptor??
=5B    3.817615=5D systemd-udevd (335) used greatest stack depth: 12568 b=
ytes left
=5B    3.849204=5D usb 1-4.2: new low-speed USB device number 4 using xhc=
i_hcd
=5B    3.851516=5D audit: type=3D1130 audit(1444682381.555:10): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dply=
mouth-start comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 hos=
tname=3D? addr=3D? terminal=3D? res=3Dsuccess'
=5B    3.940154=5D usb 1-4.2: New USB device found, idVendor=3D0e8f, idPr=
oduct=3D0020
=5B    3.940201=5D usb 1-4.2: New USB device strings: Mfr=3D1, Product=3D=
2, SerialNumber=3D0
=5B    3.940205=5D usb 1-4.2: Product: PS2toUSB Adapter
=5B    3.940208=5D usb 1-4.2: Manufacturer: GASIA
=5B    3.944917=5D input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0=
000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.0/0003:0E8F:0020.0002/input/input18
=5B    3.997233=5D hid-generic 0003:0E8F:0020.0002: input,hidraw1: USB HI=
D v1.10 Keyboard =5BGASIA PS2toUSB Adapter=5D on usb-0000:00:14.0-4.2/inp=
ut0
=5B    4.003490=5D input: GASIA PS2toUSB Adapter as /devices/pci0000:00/0=
000:00:14.0/usb1/1-4/1-4.2/1-4.2:1.1/0003:0E8F:0020.0003/input/input19
=5B    4.055761=5D hid-generic 0003:0E8F:0020.0003: input,hidraw2: USB HI=
D v1.10 Mouse =5BGASIA PS2toUSB Adapter=5D on usb-0000:00:14.0-4.2/input1=

=5B    4.296246=5D clocksource: Switched to clocksource tsc
=5B    7.812523=5D random: nonblocking pool is initialized
=5B   16.510093=5D BUG: sleeping function called from invalid context at =
arch/x86/mm/fault.c:1191
=5B   16.510144=5D in_atomic(): 0, irqs_disabled(): 1, pid: 389, name: sy=
stemd-cryptse
=5B   16.510183=5D 1 lock held by systemd-cryptse/389:
=5B   16.510185=5D  =230:  (&mm->mmap_sem)=7B++++++=7D, at: =5B<ffffffff9=
7048d01>=5D __do_page_fault+0x371/0x740
=5B   16.510198=5D irq event stamp: 27424
=5B   16.510200=5D hardirqs last  enabled at (27423): =5B<ffffffff979828b=
5>=5D __mutex_unlock_slowpath+0xf5/0x1f0
=5B   16.510206=5D hardirqs last disabled at (27424): =5B<ffffffff971d5bc=
2>=5D kfree+0x152/0x2d0
=5B   16.510212=5D softirqs last  enabled at (27418): =5B<ffffffff97063f3=
e>=5D __do_softirq+0x45e/0x5a0
=5B   16.510217=5D softirqs last disabled at (27411): =5B<ffffffff9706425=
4>=5D irq_exit+0xd4/0xe0
=5B   16.510223=5D CPU: 3 PID: 389 Comm: systemd-cryptse Tainted: G      =
  W       4.3.0-rc4-next-20151009-00010-g6b3cb144089f =23109
=5B   16.510226=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
17 08/19/2015
=5B   16.510229=5D  0000000000000000 000000006ccfbbff ffff880221033af0 ff=
ffffff973d30f0
=5B   16.510235=5D  ffff880221e1c880 ffffffff97ce70de ffff880221033b18 ff=
ffffff9708be85
=5B   16.510241=5D  ffff880221e1c880 ffffffff97ce70de 00000000000004a7 ff=
ff880221033b58
=5B   16.510247=5D Call Trace:
=5B   16.510252=5D  =5B<ffffffff973d30f0>=5D dump_stack+0x50/0xb0
=5B   16.510256=5D  =5B<ffffffff9708be85>=5D ___might_sleep+0x135/0x1e0
=5B   16.510260=5D  =5B<ffffffff9708bff9>=5D __might_sleep+0xc9/0x120
=5B   16.510264=5D  =5B<ffffffff97048ff8>=5D __do_page_fault+0x668/0x740
=5B   16.510267=5D  =5B<ffffffff970490dc>=5D do_page_fault+0xc/0x10
=5B   16.510271=5D  =5B<ffffffff97988002>=5D page_fault+0x22/0x30
=5B   16.510275=5D  =5B<ffffffff971d5c25>=5D ? kfree+0x1b5/0x2d0
=5B   16.510278=5D  =5B<ffffffff971d5c13>=5D ? kfree+0x1a3/0x2d0
=5B   16.510283=5D  =5B<ffffffff9719eaea>=5D kvfree+0x2a/0x40
=5B   16.510287=5D  =5B<ffffffff9762306e>=5D ctl_ioctl+0x42e/0x5e0
=5B   16.510293=5D  =5B<ffffffff97623233>=5D dm_ctl_ioctl+0x13/0x20
=5B   16.510296=5D  =5B<ffffffff9720574a>=5D do_vfs_ioctl+0x2da/0x5c0
=5B   16.510302=5D  =5B<ffffffff971245fb>=5D ? __audit_syscall_entry+0xfb=
/0x160
=5B   16.510305=5D  =5B<ffffffff97205aa9>=5D SyS_ioctl+0x79/0x90
=5B   16.510309=5D  =5B<ffffffff97986357>=5D entry_SYSCALL_64_fastpath+0x=
12/0x6f
=5B   16.510315=5D BUG: unable to handle kernel NULL pointer dereference =
at 0000000000000074
=5B   16.510362=5D IP: =5B<ffffffff971d5c25>=5D kfree+0x1b5/0x2d0
=5B   16.510394=5D PGD 0=20
=5B   16.510410=5D Oops: 0000 =5B=231=5D PREEMPT SMP=20
=5B   16.510442=5D Modules linked in:
=5B   16.510465=5D CPU: 3 PID: 389 Comm: systemd-cryptse Tainted: G      =
  W       4.3.0-rc4-next-20151009-00010-g6b3cb144089f =23109
=5B   16.510522=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
17 08/19/2015
=5B   16.510560=5D task: ffff880221e1c880 ti: ffff880221030000 task.ti: f=
fff880221030000
=5B   16.510599=5D RIP: 0010:=5B<ffffffff971d5c25>=5D  =5B<ffffffff971d5c=
25>=5D kfree+0x1b5/0x2d0
=5B   16.510646=5D RSP: 0018:ffff880221033c98  EFLAGS: 00010046
=5B   16.510677=5D RAX: ffffea0007738b28 RBX: ffffea0007738b28 RCX: 00000=
00000000000
=5B   16.510716=5D RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8=
80221033d10
=5B   16.510768=5D RBP: ffff880221033cc0 R08: 0000000000000000 R09: 00000=
00000000000
=5B   16.510830=5D R10: 0000000000000001 R11: 0000000000000000 R12: ffff8=
80221033d10
=5B   16.510893=5D R13: 0000000000000286 R14: 0000000000000000 R15: 00000=
00000000000
=5B   16.510956=5D FS:  00007f30b94de880(0000) GS:ffff88022dd80000(0000) =
knlGS:0000000000000000
=5B   16.511040=5D CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
=5B   16.511092=5D CR2: 0000000000000074 CR3: 0000000221e60000 CR4: 00000=
000001406e0
=5B   16.511155=5D Stack:
=5B   16.511178=5D  0000000000000000 000055ec10061800 0000000000000138 00=
00000000000131
=5B   16.511266=5D  ffff880221033d10 ffff880221033cd0 ffffffff9719eaea ff=
ff880221033e78
=5B   16.511353=5D  ffffffff9762306e 0000000000000000 0000000000000001 00=
00000000000000
=5B   16.511442=5D Call Trace:
=5B   16.511474=5D  =5B<ffffffff9719eaea>=5D kvfree+0x2a/0x40
=5B   16.511521=5D  =5B<ffffffff9762306e>=5D ctl_ioctl+0x42e/0x5e0
=5B   16.511575=5D  =5B<ffffffff97623233>=5D dm_ctl_ioctl+0x13/0x20
=5B   16.511625=5D  =5B<ffffffff9720574a>=5D do_vfs_ioctl+0x2da/0x5c0
=5B   16.511679=5D  =5B<ffffffff971245fb>=5D ? __audit_syscall_entry+0xfb=
/0x160
=5B   16.511737=5D  =5B<ffffffff97205aa9>=5D SyS_ioctl+0x79/0x90
=5B   16.511786=5D  =5B<ffffffff97986357>=5D entry_SYSCALL_64_fastpath+0x=
12/0x6f
=5B   16.511844=5D Code: 20 4d 89 f7 41 83 e7 01 31 d2 44 89 fe 48 c7 c7 =
58 0e f3 97 e8 4d 9d f7 ff 49 8d 46 ff 4d 85 ff 4c 89 e7 48 0f 44 c3 4c 8=
b 70 30 <49> 63 76 74 e8 22 71 ee ff 49 8b 1e 65 48 03 1d bf 44 e3 68 8b =

=5B   16.512356=5D RIP  =5B<ffffffff971d5c25>=5D kfree+0x1b5/0x2d0
=5B   16.512411=5D  RSP <ffff880221033c98>
=5B   16.512444=5D CR2: 0000000000000074
=5B   16.512480=5D ---=5B end trace 883ed7b099d3373a =5D---
=5B   19.677505=5D systemd-cryptse (389) used greatest stack depth: 12376=
 bytes left
=5B   19.681406=5D audit_printk_skb: 3 callbacks suppressed
=5B   19.681452=5D audit: type=3D1130 audit(1444682397.380:12): pid=3D1 u=
id=3D0 auid=3D4294967295 ses=3D4294967295 subj=3Dkernel msg=3D'unit=3Dsys=
temd-cryptsetup=40luks=5Cx2d665bb147=5Cx2d9e39=5Cx2d4003=5Cx2db3ae=5Cx2d7=
be925f51a97 comm=3D=22systemd=22 exe=3D=22/usr/lib/systemd/systemd=22 hos=
tname=3D? addr=3D? terminal=3D? res=3Dfailed'
=5B   21.136483=5D BUG: sleeping function called from invalid context at =
arch/x86/mm/fault.c:1191
=5B   21.136517=5D in_atomic(): 0, irqs_disabled(): 1, pid: 456, name: sy=
stemd-cryptse
=5B   21.136541=5D INFO: lockdep is turned off.
=5B   21.137927=5D irq event stamp: 0
=5B   21.139296=5D hardirqs last  enabled at (0): =5B<          (null)>=
=5D           (null)
=5B   21.140683=5D hardirqs last disabled at (0): =5B<ffffffff9705bc4f>=
=5D copy_process+0x67f/0x20d0
=5B   21.142088=5D softirqs last  enabled at (0): =5B<ffffffff9705bc4f>=
=5D copy_process+0x67f/0x20d0
=5B   21.143472=5D softirqs last disabled at (0): =5B<          (null)>=
=5D           (null)
=5B   21.144870=5D CPU: 0 PID: 456 Comm: systemd-cryptse Tainted: G      =
D W       4.3.0-rc4-next-20151009-00010-g6b3cb144089f =23109
=5B   21.146291=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
17 08/19/2015
=5B   21.147721=5D  0000000000000000 0000000019806602 ffff88022297baf0 ff=
ffffff973d30f0
=5B   21.149163=5D  ffff8800bbcb0c00 ffffffff97ce70de ffff88022297bb18 ff=
ffffff9708be85
=5B   21.150610=5D  ffff8800bbcb0c00 ffffffff97ce70de 00000000000004a7 ff=
ff88022297bb58
=5B   21.152048=5D Call Trace:
=5B   21.153476=5D  =5B<ffffffff973d30f0>=5D dump_stack+0x50/0xb0
=5B   21.154912=5D  =5B<ffffffff9708be85>=5D ___might_sleep+0x135/0x1e0
=5B   21.156357=5D  =5B<ffffffff9708bff9>=5D __might_sleep+0xc9/0x120
=5B   21.157794=5D  =5B<ffffffff97048ff8>=5D __do_page_fault+0x668/0x740
=5B   21.159241=5D  =5B<ffffffff970b99bf>=5D ? trace_hardirqs_off_caller+=
0x1f/0xb0
=5B   21.160835=5D  =5B<ffffffff970490dc>=5D do_page_fault+0xc/0x10
=5B   21.162217=5D  =5B<ffffffff97988002>=5D page_fault+0x22/0x30
=5B   21.163623=5D  =5B<ffffffff971d5c25>=5D ? kfree+0x1b5/0x2d0
=5B   21.164990=5D  =5B<ffffffff971d5c13>=5D ? kfree+0x1a3/0x2d0
=5B   21.166354=5D  =5B<ffffffff9719eaea>=5D kvfree+0x2a/0x40
=5B   21.167697=5D  =5B<ffffffff9762306e>=5D ctl_ioctl+0x42e/0x5e0
=5B   21.169015=5D  =5B<ffffffff97623233>=5D dm_ctl_ioctl+0x13/0x20
=5B   21.170330=5D  =5B<ffffffff9720574a>=5D do_vfs_ioctl+0x2da/0x5c0
=5B   21.171639=5D  =5B<ffffffff971245fb>=5D ? __audit_syscall_entry+0xfb=
/0x160
=5B   21.172931=5D  =5B<ffffffff97205aa9>=5D SyS_ioctl+0x79/0x90
=5B   21.174221=5D  =5B<ffffffff97986357>=5D entry_SYSCALL_64_fastpath+0x=
12/0x6f
=5B   21.175543=5D BUG: unable to handle kernel NULL pointer dereference =
at 0000000000000074
=5B   21.176903=5D IP: =5B<ffffffff971d5c25>=5D kfree+0x1b5/0x2d0
=5B   21.178200=5D PGD 0=20
=5B   21.179496=5D Oops: 0000 =5B=232=5D PREEMPT SMP=20
=5B   21.180773=5D Modules linked in:
=5B   21.182034=5D CPU: 0 PID: 456 Comm: systemd-cryptse Tainted: G      =
D W       4.3.0-rc4-next-20151009-00010-g6b3cb144089f =23109
=5B   21.183332=5D Hardware name: Dell Inc. Latitude E6530/07Y85M, BIOS A=
17 08/19/2015
=5B   21.184633=5D task: ffff8800bbcb0c00 ti: ffff880222978000 task.ti: f=
fff880222978000
=5B   21.185927=5D RIP: 0010:=5B<ffffffff971d5c25>=5D  =5B<ffffffff971d5c=
25>=5D kfree+0x1b5/0x2d0
=5B   21.187230=5D RSP: 0018:ffff88022297bc98  EFLAGS: 00010046
=5B   21.188551=5D RAX: ffffea00077912e8 RBX: ffffea00077912e8 RCX: 00000=
00000000000
=5B   21.189860=5D RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8=
8022297bd10
=5B   21.191168=5D RBP: ffff88022297bcc0 R08: 0000000000000000 R09: 00000=
00000000000
=5B   21.192490=5D R10: 0000000000000000 R11: 0000000000000000 R12: ffff8=
8022297bd10
=5B   21.193787=5D R13: 0000000000000286 R14: 0000000000000000 R15: 00000=
00000000000
=5B   21.195077=5D FS:  00007fa313d43880(0000) GS:ffff88022dc00000(0000) =
knlGS:0000000000000000
=5B   21.196388=5D CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
=5B   21.197674=5D CR2: 0000000000000074 CR3: 00000000bca5c000 CR4: 00000=
000001406f0
=5B   21.198984=5D Stack:
=5B   21.200259=5D  0000000000000000 0000560844c482a0 0000000000000138 00=
00000000000131
=5B   21.201587=5D  ffff88022297bd10 ffff88022297bcd0 ffffffff9719eaea ff=
ff88022297be78
=5B   21.202903=5D  ffffffff9762306e 0000000000000000 0000000000000001 00=
00000000000000
=5B   21.204225=5D Call Trace:
=5B   21.205560=5D  =5B<ffffffff9719eaea>=5D kvfree+0x2a/0x40
=5B   21.206880=5D  =5B<ffffffff9762306e>=5D ctl_ioctl+0x42e/0x5e0
=5B   21.208198=5D  =5B<ffffffff97623233>=5D dm_ctl_ioctl+0x13/0x20
=5B   21.209531=5D  =5B<ffffffff9720574a>=5D do_vfs_ioctl+0x2da/0x5c0
=5B   21.210798=5D  =5B<ffffffff971245fb>=5D ? __audit_syscall_entry+0xfb=
/0x160
=5B   21.212022=5D  =5B<ffffffff97205aa9>=5D SyS_ioctl+0x79/0x90
=5B   21.213243=5D  =5B<ffffffff97986357>=5D entry_SYSCALL_64_fastpath+0x=
12/0x6f
=5B   21.214493=5D Code: 20 4d 89 f7 41 83 e7 01 31 d2 44 89 fe 48 c7 c7 =
58 0e f3 97 e8 4d 9d f7 ff 49 8d 46 ff 4d 85 ff 4c 89 e7 48 0f 44 c3 4c 8=
b 70 30 <49> 63 76 74 e8 22 71 ee ff 49 8b 1e 65 48 03 1d bf 44 e3 68 8b =

=5B   21.215937=5D RIP  =5B<ffffffff971d5c25>=5D kfree+0x1b5/0x2d0
=5B   21.217248=5D  RSP <ffff88022297bc98>
=5B   21.218566=5D CR2: 0000000000000074
=5B   21.219822=5D ---=5B end trace 883ed7b099d3373b =5D---
=5B   22.877079=5D RSP: 0018:ffff880221d47c98  EFLAGS: 00010046
=5B   22.878388=5D RAX: ffffea0007766788 RBX: ffffea0007766788 RCX: 00000=
00000000000
=5B   22.879722=5D RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8=
80221d47d10
=5B   22.881032=5D RBP: ffff880221d47cc0 R08: 0000000000000000 R09: 00000=
00000000000
=5B   22.882335=5D R10: 0000000000000000 R11: 0000000000000000 R12: ffff8=
80221d47d10
=5B   22.883667=5D R13: 0000000000000286 R14: 0000000000000000 R15: 00000=
00000000000
=5B   22.884971=5D FS:  00007fb1402d1880(0000) GS:ffff88022dd80000(0000) =
knlGS:0000000000000000
=5B   22.886285=5D CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
=5B   22.887672=5D CR2: 0000000000000074 CR3: 00000000bc7fe000 CR4: 00000=
000001406e0
=5B   22.888982=5D Stack:
=5B   22.890280=5D  0000000000000000 000055d9bbacd260 0000000000000138 00=
00000000000131
=5B   22.891623=5D  ffff880221d47d10 ffff880221d47cd0 ffffffff9719eaea ff=
ff880221d47e78
=5B   22.892942=5D  ffffffff9762306e 0000000000000000 0000000000000001 00=
00000000000000
=5B   22.894262=5D Call Trace:
=5B   22.895583=5D  =5B<ffffffff9719eaea>=5D kvfree+0x2a/0x40
=5B   22.896883=5D  =5B<ffffffff9762306e>=5D ctl_ioctl+0x42e/0x5e0
=5B   22.898184=5D  =5B<ffffffff97623233>=5D dm_ctl_ioctl+0x13/0x20
=5B   22.899503=5D  =5B<ffffffff9720574a>=5D do_vfs_ioctl+0x2da/0x5c0
=5B   22.900803=5D  =5B<ffffffff971245fb>=5D ? __audit_syscall_entry+0xfb=
/0x160
=5B   22.902108=5D  =5B<ffffffff97205aa9>=5D SyS_ioctl+0x79/0x90
=5B   22.903409=5D  =5B<ffffffff97986357>=5D entry_SYSCALL_64_fastpath+0x=
12/0x6f
=5B   22.904738=5D Code: 20 4d 89 f7 41 83 e7 01 31 d2 44 89 fe 48 c7 c7 =
58 0e f3 97 e8 4d 9d f7 ff 49 8d 46 ff 4d 85 ff 4c 89 e7 48 0f 44 c3 4c 8=
b 70 30 <49> 63 76 74 e8 22 71 ee ff 49 8b 1e 65 48 03 1d bf 44 e3 68 8b =

=5B   22.906263=5D RIP  =5B<ffffffff971d5c25>=5D kfree+0x1b5/0x2d0
=5B   22.907636=5D  RSP <ffff880221d47c98>
=5B   22.908935=5D CR2: 0000000000000074
=5B   22.910235=5D ---=5B end trace 883ed7b099d3373c =5D---


--==_Exmh_1444686608_3721P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBVhwrEAdmEQWDXROgAQKoGg//ZZ411Mez+X0HLskRZANYS6DahPdIYQod
MAMrYcGABcSspbY3WuAiQTnuUl7zxprpqUsGuLO/P4ByUnJgKN/bv/OotLErYC7k
23ywhvf+YIJEoghkMLtMCbj5JYZVsdyTc8YlObz8jYz/r6OOTd4Qo1/h7UvkJMoq
pyudBDanLez8WbrKVOALkTLo8WrHOmKXymHkL7u6rOAvxWe+3mnG1ygiXVLUTlIP
+KLxSmwbJ/R6aOuJabJItaXTwRL+7SZYTS6jB3FKiqoLJe4BoY5Wrbivku8/ECPv
n8VguaJW7Ts5I+rgRaQ5SPXMGvRAroN0Po9bNbvZBHI7l2Fbyhr8hSF4QWkXfzHc
2mGm5R7fL/nex50LhCCwRgWHX8iNzyLVEl52M8sYnhN7UeTdBpo66+1B2cGlVmXT
ob7+x2BzrgXBxhHV15XHYfVu5CuTro1A0aJPSunDCwy2nGxa2yJeaemGEzPM1u+3
Y0d4qglX/A83TJ8yI2V3Ug1tAov7I6JMLbBbIa7LxH9+8VTIRGtLRe9++DvlfUN3
wmJHUotbjClQ6eiLepNLKBvbK5tCPkokCaAD/zICeeOcp21GRfz3gq08V9/i4YpD
KTETdRixgXzcJTlO65rm//54cfTtoezzno1A/HT8a4jfcz2oKj1TtJlnKBRmVGqu
v5LAfVFqKZQ=
=v9a/
-----END PGP SIGNATURE-----

--==_Exmh_1444686608_3721P--
