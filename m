From: Brian Wong <bwong@pillardata.com>
Subject: Re: dm-multipath: kernel paniced when I pull out one HBA
	card
Date: Thu, 22 Dec 2005 09:53:00 -0800
Message-ID: <20051222175300.GA3980@ca-bwong3.trans.corp>
References: <SERVERfGhlKUhIECRyR00007b6d@mail.onewaveinc.com>
Reply-To: bwong@pillardata.com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <SERVERfGhlKUhIECRyR00007b6d@mail.onewaveinc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Thu, Dec 22, 2005 at 02:47:30PM +0800, =E5=AD=99=E4=BF=8A=E4=BC=9F wro=
te:
> Hello, all
>=20
> I'm testing the DM multipath.=20
> I use the packages as follows:
> kernel 2.6.14.2
> device-mapper.1.01.05
> multipath-tools-0.4.6
> udev-058-1
>=20
> I created the dm device as:
> create: 3600d0230006927de000001618fecaf00
> [size=3D476 GB][features=3D"0"][hwhandler=3D"0"]
> \_ round-robin 0 [prio=3D1]
>  \_ 0:0:0:0 sda 8:0  [undef] [ready]
> \_ round-robin 0 [prio=3D1]
>  \_ 1:0:0:0 sdb 8:16 [undef] [ready]
>=20
> Then, I tried the command: dd if=3D/dev/dm-0 of=3D/dev/null
> I saw only the device /dev/sda was readed. It's OK.
>=20
> but when I pull out the HBA which related to /dev/sdb for about 1 minut=
e,and then plug it in again,
> the kernel paniced.
>=20
> the messages are as follows:
> Dec 22 05:25:07 nd02 kernel: qla2300 0000:07:01.1: LIP reset occured (f=
823).
> Dec 22 05:25:07 nd02 kernel: qla2300 0000:07:01.1: LIP occured (f823).
> Dec 22 05:25:07 nd02 kernel: qla2300 0000:07:01.1: LOOP DOWN detected (=
2).
> Dec 22 05:25:42 nd02 kernel:  rport-1:0-1: blocked FC remote port time =
out: removing target
> Dec 22 05:25:42 nd02 multipathd: 8:16: readsector0 checker reports path=
 is down
> Dec 22 05:25:42 nd02 multipathd: checker failed path 8:16 in map 3600d0=
230006927de000001618fecaf00
> Dec 22 05:25:42 nd02 kernel: device-mapper: dm-multipath: Failing path =
8:16.
> Dec 22 05:25:42 nd02 multipathd: 3600d0230006927de000001618fecaf00: rem=
aining active paths: 1
> Dec 22 05:25:43 nd02 multipathd: remove sdb path checker
> Dec 22 05:25:43 nd02 kernel: Synchronizing SCSI cache for disk sdb:
> Dec 22 05:25:43 nd02 kernel: FAILED
> Dec 22 05:25:43 nd02 kernel:   status =3D 0, message =3D 00, host =3D 1=
, driver =3D 00
> Dec 22 05:26:12 nd02 kernel:   <6>qla2300 0000:07:01.1: LIP reset occur=
ed (f8f7).
> Dec 22 05:26:12 nd02 kernel: qla2300 0000:07:01.1: LIP occured (f8f7).
> Dec 22 05:26:12 nd02 kernel: qla2300 0000:07:01.1: LOOP UP detected (2 =
Gbps).
> Dec 22 05:26:13 nd02 kernel:   Vendor: TOYOU     Model: NetStor DA9220F=
   Rev: 342R
> Dec 22 05:26:13 nd02 kernel:   Type:   Direct-Access                   =
   ANSI SCSI revision: 03
> Dec 22 05:26:13 nd02 kernel: SCSI device sdc: 999950336 512-byte hdwr s=
ectors (511975 MB)
> Dec 22 05:26:13 nd02 kernel: SCSI device sdc: drive cache: write back
> Dec 22 05:26:13 nd02 kernel: SCSI device sdc: 999950336 512-byte hdwr s=
ectors (511975 MB)
> Dec 22 05:26:14 nd02 kernel: SCSI device sdc: drive cache: write back
> Dec 22 05:26:14 nd02 kernel:  sdc:
> Dec 22 05:26:14 nd02 kernel: Attached scsi disk sdc at scsi1, channel 0=
, id 0, lun 0
> Dec 22 05:26:14 nd02 kernel: Attached scsi generic sg1 at scsi1, channe=
l 0, id 0, lun 0,  type 0
> Dec 22 05:26:14 nd02 scsi.agent[4098]: disk at /devices/pci0000:00/0000=
:00:02.0/0000:05:1d.0/0000:07:01.1/host1/rport-1:0-1/target1:0:0/1:0:0:0
>=20
> --------------------->> All right above here.
>=20
> Dec 22 05:26:14 nd02 kernel:   Vendor: TOYOU     Model: NetStor DA9220F=
   Rev: 342R
> Dec 22 05:26:14 nd02 kernel:   Type:   Direct-Access                   =
   ANSI SCSI revision: 03
> Dec 22 05:26:14 nd02 kernel: error 1
> Dec 22 05:26:14 nd02 kernel: scsi: Unexpected response from host 1 chan=
nel 0 id 0 lun 0 while scanning, scan aborted
> Dec 22 05:26:14 nd02 kernel: Badness in kref_get at lib/kref.c:32
> Dec 22 05:26:14 nd02 kernel:  [<c01d9c6a>] kref_get+0x3f/0x41
> Dec 22 05:26:14 nd02 kernel:  [<c01d92e0>] kobject_get+0x17/0x1e
> Dec 22 05:26:14 nd02 kernel:  [<c019d896>] sysfs_getlink+0x38/0xfa
> Dec 22 05:26:14 nd02 kernel:  [<c019d999>] sysfs_follow_link+0x41/0x59
> Dec 22 05:26:14 nd02 kernel:  [<c016ee2f>] generic_readlink+0x2a/0x85
> Dec 22 05:26:14 nd02 kernel:  [<c017fc72>] __mark_inode_dirty+0x52/0x1a=
8
> Dec 22 05:26:14 nd02 kernel:  [<c012332f>] current_fs_time+0x59/0x67
> Dec 22 05:26:14 nd02 kernel:  [<c0177e61>] update_atime+0x67/0x8c
> Dec 22 05:26:14 nd02 kernel:  [<c01674b5>] sys_readlink+0x7e/0x82
> Dec 22 05:26:14 nd02 kernel:  [<c0103af3>] sysenter_past_esp+0x54/0x75
> Dec 22 05:26:17 nd02 kernel: Unable to handle kernel paging requestBadn=
ess in kref_get at lib/kref.c:32
> Dec 22 05:26:17 nd02 kernel:  [<c01d9c6a>] kref_get+0x3f/0x41
> Dec 22 05:26:17 nd02 kernel:  [<c01d92e0>] kobject_get+0x17/0x1e
> Dec 22 05:26:17 nd02 kernel:  [<c019d896>] sysfs_getlink+0x38/0xfa
> Dec 22 05:26:17 nd02 kernel:  [<c019d999>] sysfs_follow_link+0x41/0x59
> Dec 22 05:26:17 nd02 kernel:  [<c016ee2f>] generic_readlink+0x2a/0x85
> Dec 22 05:26:17 nd02 kernel:  [<c012332f>] current_fs_time+0x59/0x67
> Dec 22 05:26:17 nd02 kernel:  [<c0177e61>] update_atime+0x67/0x8c
> Dec 22 05:26:17 nd02 kernel:  [<c01674b5>] sys_readlink+0x7e/0x82
> Dec 22 05:26:17 nd02 kernel:  [<c0103af3>] sysenter_past_esp+0x54/0x75
> Dec 22 05:26:17 nd02 kernel:  at virtual address 00200200
> Dec 22 05:26:17 nd02 kernel:  printing eip:
> Dec 22 05:26:17 nd02 kernel: c02583a1
> Dec 22 05:26:17 nd02 kernel: *pde =3D 37eb7001
> Dec 22 05:26:17 nd02 kernel: Oops: 0002 [#1]
> Dec 22 05:26:17 nd02 kernel: SMP
> Dec 22 05:26:17 nd02 kernel: Modules linked in: dm_round_robin dm_multi=
path binfmt_misc dm_mirror dm_mod video thermal proces
> sor fan button battery ac uhci_hcd usbcore hw_random shpchp pci_hotplug=
 e1000 qla2300 qla2xxx scsi_transport_fc sd_mod
> Dec 22 05:26:17 nd02 kernel: CPU:    1
> Dec 22 05:26:17 nd02 kernel: EIP:    0060:[<c02583a1>]    Not tainted V=
LI
> Dec 22 05:26:17 nd02 kernel: EFLAGS: 00010002   (2.6.14.2smp)
> Dec 22 05:26:17 nd02 kernel: EIP is at scsi_device_dev_release+0x3d/0x1=
13
> Dec 22 05:26:17 nd02 kernel: eax: 00100100   ebx: c2c03194   ecx: 00200=
200   edx: 00000286
> Dec 22 05:26:17 nd02 kernel: esi: c2c03008   edi: c2c03000   ebp: c229d=
814   esp: d326fe68
> Dec 22 05:26:17 nd02 kernel: ds: 007b   es: 007b   ss: 0068
> Dec 22 05:26:17 nd02 kernel: Process udev (pid: 4108, threadinfo=3Dd326=
e000 task=3Df6e3ca30)
> Dec 22 05:26:17 nd02 kernel: Stack: 7f7e7d7c c2c0320c c0371b08 c0371b20=
 c229d88c c01d935e c2c03194 c2c03224
> Dec 22 05:26:17 nd02 kernel:        c01d9362 c03754b8 c2c0320c c01d9c9e=
 c2c0320c c019d854 c03754b8 ef1ac000
> Dec 22 05:26:17 nd02 kernel:        c0365040 00000000 c01d938a c2c03224=
 c01d9362 c019d927 c2c0320c c03754b8
> Dec 22 05:26:17 nd02 kernel: Call Trace:
> Dec 22 05:26:17 nd02 kernel:  [<c01d935e>] kobject_cleanup+0x77/0x7b
> Dec 22 05:26:17 nd02 kernel:  [<c01d9362>] kobject_release+0x0/0xa
> Dec 22 05:26:17 nd02 kernel:  [<c01d9c9e>] kref_put+0x32/0x84
> Dec 22 05:26:17 nd02 kernel:  [<c019d854>] sysfs_get_target_path+0x73/0=
x7d
> Dec 22 05:26:17 nd02 kernel:  [<c01d938a>] kobject_put+0x1e/0x22
> Dec 22 05:26:17 nd02 kernel:  [<c01d9362>] kobject_release+0x0/0xa
> Dec 22 05:26:17 nd02 kernel:  [<c019d927>] sysfs_getlink+0xc9/0xfa
> Dec 22 05:26:17 nd02 kernel:  [<c019d999>] sysfs_follow_link+0x41/0x59
> Dec 22 05:26:17 nd02 kernel:  [<c016ee2f>] generic_readlink+0x2a/0x85
> Dec 22 05:26:17 nd02 kernel:  [<c017fc72>] __mark_inode_dirty+0x52/0x1a=
8
> Dec 22 05:26:17 nd02 kernel:  [<c012332f>] current_fs_time+0x59/0x67
> Dec 22 05:26:17 nd02 kernel:  [<c0177e61>] update_atime+0x67/0x8c
> Dec 22 05:26:17 nd02 kernel:  [<c01674b5>] sys_readlink+0x7e/0x82
> Dec 22 05:26:17 nd02 kernel:  [<c0103af3>] sysenter_past_esp+0x54/0x75
> Dec 22 05:26:17 nd02 kernel: Code: ff ff 8d bb 6c fe ff ff 8d 75 ec 8b =
40 2c e8 cc df 0a 00 83 86 34 01 00 00 01 8d b3 74 fe
> ff ff 8b 4e 04 89 c2 8b 83 74 fe ff ff <89> 01 89 48 04 c7 46 04 00 02 =
20 00 8d b3 7c fe ff ff 8b 83 7c
> Dec 22 05:26:19 nd02 multipathd: sdc: path checker registered
>=20
> What can I do ?=20

looks like a failure in sysfs support code in the scsi module.  might be =
worth posting to the LKML.
