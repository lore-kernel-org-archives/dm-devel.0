From: Stefan Maier <maier@idowa.de>
Subject: Re: multipathd: BUG: unable to handle kernel NULL
 pointer dereference
Date: Wed, 23 Jan 2013 16:38:12 +0100
Message-ID: <510003E4.5050009@idowa.de>
References: <20130122111950.149768tojz4wvgzq@webmail.idowa.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130122111950.149768tojz4wvgzq@webmail.idowa.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Replying to myself:

Switching to a custom build 2.6.39.4 seems to have fixed the issue.



On 1/22/13 11:19 AM, Stefan Maier wrote:
> Hi,
>
> I've got SuSE 11.4 running multipath tools compiled from git.
> It looks like I've got the same problem as described here: http://www.spi=
nics.net/lists/dm-devel/msg17038.html
>
> What is the status on this issue?
>
>
>
> Jan 22 10:59:20 kemper kernel: [  738.009813] device-mapper: multipath: a=
dding disabled device 65:160
> Jan 22 10:59:20 kemper kernel: [  738.010368] BUG: unable to handle kerne=
l NULL pointer dereference at           (null)
> Jan 22 10:59:20 kemper kernel: [  738.010379] IP: [<ffffffffa01f78a3>] dm=
_set_device_limits+0x23/0x140 [dm_mod]
> Jan 22 10:59:20 kemper kernel: [  738.010392] PGD 84a9c9067 PUD 84afd8067=
 PMD 0
> Jan 22 10:59:20 kemper kernel: [  738.010396] Oops: 0000 [#1] SMP
> Jan 22 10:59:20 kemper kernel: [  738.010400] last sysfs file: /sys/modul=
e/scsi_dh_emc/initstate
> Jan 22 10:59:20 kemper kernel: [  738.010404] CPU 6
> Jan 22 10:59:20 kemper kernel: [  738.010405] Modules linked in: raid1 dm=
_service_time dm_round_robin scsi_dh_emc dm_multipath scsi_dh edd microcode=
 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mper=
f ext4 jbd2 crc16 dm_mod qla2xxx scsi_transport_fc scsi_tgt igb ghes pcspkr=
 hed joydev sg i2c_i801 iTCO_wdt iTCO_vendor_support dca button container u=
sbhid xfs exportfs ehci_hcd usbcore fan processor 3w_sas thermal thermal_sys
> Jan 22 10:59:20 kemper kernel: [  738.010438]
> Jan 22 10:59:20 kemper kernel: [  738.010442] Pid: 3008, comm: multipathd=
 Not tainted 2.6.37.6-24-default #1 Thomas-Krenn.AG X9DR3-F/X9DR3-F
> Jan 22 10:59:20 kemper kernel: [  738.010449] RIP: 0010:[<ffffffffa01f78a=
3>]  [<ffffffffa01f78a3>] dm_set_device_limits+0x23/0x140 [dm_mod]
> Jan 22 10:59:20 kemper kernel: [  738.010457] RSP: 0018:ffff880857bb9c78 =
 EFLAGS: 00010296
> Jan 22 10:59:20 kemper kernel: [  738.010460] RAX: ffff8810447db9f8 RBX: =
ffff8810493ba140 RCX: 0000000000200000
> Jan 22 10:59:20 kemper kernel: [  738.010464] RDX: 0000000000000000 RSI: =
0000000000000000 RDI: ffffc900207f1040
> Jan 22 10:59:20 kemper kernel: [  738.010468] RBP: ffffc900207f1040 R08: =
ffff880857bb9d58 R09: 0000000000000200
> Jan 22 10:59:20 kemper kernel: [  738.010472] R10: 0000160000000000 R11: =
0000000000000001 R12: ffff8810447db9f8
> Jan 22 10:59:20 kemper kernel: [  738.010476] R13: 0000000000000000 R14: =
ffff880857bb9d58 R15: ffff8810447db9c0
> Jan 22 10:59:20 kemper kernel: [  738.010480] FS:  00007fb404e55700(0000)=
 GS:ffff88107fc00000(0000) knlGS:0000000000000000
> Jan 22 10:59:20 kemper kernel: [  738.010484] CS:  0010 DS: 0000 ES: 0000=
 CR0: 000000008005003b
> Jan 22 10:59:20 kemper kernel: [  738.010488] CR2: 0000000000000000 CR3: =
000000084c1c3000 CR4: 00000000000406e0
> Jan 22 10:59:20 kemper kernel: [  738.010491] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
> Jan 22 10:59:20 kemper kernel: [  738.010495] DR3: 0000000000000000 DR6: =
00000000ffff0ff0 DR7: 0000000000000400
> Jan 22 10:59:20 kemper kernel: [  738.010500] Process multipathd (pid: 30=
08, threadinfo ffff880857bb8000, task ffff880857bb62c0)
> Jan 22 10:59:20 kemper kernel: [  738.010503] Stack:
> Jan 22 10:59:20 kemper kernel: [  738.010506]  00000000ffffffff ffff88087=
f85ab80 ffff880857bb9cc8 000000000000000d
> Jan 22 10:59:20 kemper kernel: [  738.010513]  ffff88087f85abe8 000000000=
0000001 ffff88087f85aba0 ffffffff81071b9f
> Jan 22 10:59:20 kemper kernel: [  738.010519]  ffff880857bb9ce8 ffffffff8=
1041732 ffff8810493ba140 ffffc900207f1040
> Jan 22 10:59:20 kemper kernel: [  738.010525] Call Trace:
> Jan 22 10:59:20 kemper kernel: [  738.010548]  [<ffffffffa01b6425>] multi=
path_iterate_devices+0x55/0x80 [dm_multipath]
> Jan 22 10:59:20 kemper kernel: [  738.010559]  [<ffffffffa01f866c>] dm_ca=
lculate_queue_limits+0x8c/0x130 [dm_mod]
> Jan 22 10:59:20 kemper kernel: [  738.010576]  [<ffffffffa01f657b>] dm_sw=
ap_table+0x6b/0x90 [dm_mod]
> Jan 22 10:59:20 kemper kernel: [  738.010589]  [<ffffffffa01fae88>] do_re=
sume+0x88/0x1b0 [dm_mod]
> Jan 22 10:59:20 kemper kernel: [  738.010609]  [<ffffffffa01fbcac>] ctl_i=
octl+0x1ac/0x250 [dm_mod]
> Jan 22 10:59:20 kemper kernel: [  738.010629]  [<ffffffffa01fbd5e>] dm_ct=
l_ioctl+0xe/0x20 [dm_mod]
> Jan 22 10:59:20 kemper kernel: [  738.010651]  [<ffffffff81159197>] do_vf=
s_ioctl+0x77/0x2f0
> Jan 22 10:59:20 kemper kernel: [  738.010660]  [<ffffffff81159490>] sys_i=
octl+0x80/0xa0
> Jan 22 10:59:20 kemper kernel: [  738.010670]  [<ffffffff8100304b>] trace=
sys+0xd9/0xde
> Jan 22 10:59:20 kemper kernel: [  738.010677]  [<00007fb403926d87>] 0x7fb=
403926d87
> Jan 22 10:59:20 kemper kernel: [  738.010680] Code: fd ff ff 0f 1f 44 00 =
00 48 83 ec 78 48 89 6c 24 58 4c 89 64 24 60 48 89 fd 4c 89 6c 24 68 48 89 =
5c 24 50 49 89 d5 4c 89 74 24 70 <4c> 8b 36 4d 89 c4 49 8b 86 98 00 00 00 4=
8 8b 98 08 03 00 00 48
> Jan 22 10:59:20 kemper kernel: [  738.010708] RIP  [<ffffffffa01f78a3>] d=
m_set_device_limits+0x23/0x140 [dm_mod]
> Jan 22 10:59:20 kemper kernel: [  738.010714]  RSP <ffff880857bb9c78>
> Jan 22 10:59:20 kemper kernel: [  738.010717] CR2: 0000000000000000
> Jan 22 10:59:20 kemper kernel: [  738.119186] ---[ end trace 61248b01dfe0=
b885 ]---
>
>
>


-- =

Mit freundlichen Gr=FC=DFen

Stefan Maier

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
Straubinger Tagblatt
EDV-Abteilung                     FON:   +49 9421 940 5382
Ludwigsplatz 32                   FAX:   +49 9421 940 5399
94315 Straubing
http://www.idowa.de               E-Mail: maier@idowa.de
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
  Zeitungsgruppe Straubinger Tagblatt / Landshuter Zeitung
        Cl. Attenkofer'sche Buch- und Kunstdruckerei
              Verlagsbuchhandlung Straubing KG
      Registergericht: Amtsgericht Straubing, HRA 1118
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
