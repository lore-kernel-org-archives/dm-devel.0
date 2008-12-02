From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Announce: unlimited number of shared snapshots
Date: Tue, 2 Dec 2008 02:05:28 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0812020140540.28552@hs20-bc2-1.build.redhat.com>
References: <492FAF1C.8080401@gluesys.com>
	<Pine.LNX.4.64.0811281449520.6900@hs20-bc2-1.build.redhat.com>
	<4933684F.9060606@gluesys.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4933684F.9060606@gluesys.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: hgichon <kpkim@gluesys.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I fixed the ext2 bug (it was unsupported handling of buffer readahead) --- 
download the new version of patches from the same location.

I couldn't reproduce the XFS bug. Please retry. Are you sure that you 
didn't try to mount the _snapshot_ as XFS? Snapshots are currently not 
writeable (they will be writeable in the final version), so attempting to 
mount the snapshot read/write would return i/o error to the filesystem and 
produce an error message similar to the one displayed.

Thanks for testing it.

Mikulas

> hm... there is no difference.
> so.. i used small lv size. snapshot creation is successful!!
> 
> with xfs
> there is snapshot device mount problem.
> [ 2696.337759] Filesystem "dm-3": Disabling barriers, trial barrier write
> failed
> [ 2696.345517] XFS mounting filesystem dm-3
> [ 2696.356009] xfs_force_shutdown(dm-3,0x1) called from line 420 of file
> fs/xfs/xfs_rw.c.  Return address = 0xffffffff8037d399
> [ 2696.363710] Filesystem "dm-3": I/O Error Detected.  Shutting down
> filesystem: dm-3
> [ 2696.368085] Please umount the filesystem, and rectify the problem(s)
> [ 2696.371756] I/O error in filesystem ("dm-3") meta-data dev dm-3 block
> 0x200022       ("xlog_bwrite") error 5 buf count 2097152
> [ 2696.378402] XFS: failed to locate log tail
> [ 2696.380797] XFS: log mount/recovery failed: error 5
> [ 2696.405586] XFS: log mount failed
> 
> with ext2
> mount is ok!!
> In origin io (cp -a /etc /origin-dev/, however kernel oops detected!
> But cp is successful, and then another snapshot create command (dmsetup
> message /dev/mapper/ms 3 create) hang forever.
> 
> 
> [ 2782.652061] lost page write due to I/O error on dm-3
> [ 2788.134652] ------------[ cut here ]------------
> [ 2788.135559] kernel BUG at drivers/md/dm-multisnap-io.c:267!
> [ 2788.135559] invalid opcode: 0000 [#1] SMP
> [ 2788.135559] last sysfs file: /sys/block/sde/dev
> [ 2788.135559] CPU 0
> [ 2788.135559] Modules linked in: dm_multisnapshot hangcheck_timer e1000
> e1000e megaraid_sas megaraid_mbox megaraid_mm mptsas mptspi mptscsih mptctl
> mptbase dm_mod scsi_transport_sas scsi_transport_spi sd_mod
> [ 2788.135559] Pid: 4299, comm: kmultisnapd Not tainted 2.6.28-rc5-1128 #1
> [ 2788.135559] RIP: 0010:[<ffffffffa00e4178>]  [<ffffffffa00e4178>]
> dm_multisnap_process_bios+0x278/0x600 [dm_multisnapshot]
> [ 2788.135559] RSP: 0018:ffff88001fa77c90  EFLAGS: 00010202
> [ 2788.135559] RAX: 0000000000000001 RBX: ffff88001f8be000 RCX:
> ffff88001f8be0b0
> [ 2788.135559] RDX: ffff88001fa52808 RSI: ffff88001fa77ed0 RDI:
> ffffffffa00e7d80
> [ 2788.135559] RBP: 00000000ffffffff R08: ffff88001fa76000 R09:
> 0000000000000001
> [ 2788.135559] R10: 0000000000000000 R11: 0000000000000000 R12:
> ffff88001f8be0a8
> [ 2788.135559] R13: ffff880023cdd900 R14: 0000000000000000 R15:
> ffff88001fa77e30
> [ 2788.135559] FS:  0000000000000000(0000) GS:ffffffff80658800(0000)
> knlGS:0000000000000000
> [ 2788.135559] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> [ 2788.135559] CR2: 00007f973b475550 CR3: 000000001e11a000 CR4:
> 00000000000006a0
> [ 2788.135559] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [ 2788.135559] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [ 2788.135559] Process kmultisnapd (pid: 4299, threadinfo ffff88001fa76000,
> task ffff880025175700)
> [ 2788.135559] Stack:
> [ 2788.135559]  ffff880023d58838 ffff88001bf6f800 ffff88001fa77ce0
> ffff880023dc54d0
> [ 2788.135559]  0000000000000086 ffff88001bf6f800 ffff88001bf6f800
> 0000000000000000
> [ 2788.135559]  0000000000000000 ffff880023daac00 ffff880023dc54a0
> 0000000000000000
> [ 2788.135559] Call Trace:
> [ 2788.135559]  [<ffffffff804eee34>] ? _spin_unlock_irqrestore+0x4/0x10
> [ 2788.135559]  [<ffffffff80228a61>] ? update_curr+0x51/0xb0
> [ 2788.135559]  [<ffffffff8022eee0>] ? dequeue_task_fair+0xd0/0xf0
> [ 2788.135559]  [<ffffffff80243af0>] ? worker_thread+0x0/0xb0
> [ 2788.135559]  [<ffffffff8022b2ad>] ? __dequeue_entity+0x3d/0x50
> [ 2788.135559]  [<ffffffff8022b2e5>] ? set_next_entity+0x25/0x50
> [ 2788.135559]  [<ffffffff804ecf71>] ? thread_return+0x3a/0x5c9
> [ 2788.135559]  [<ffffffffa00e4500>] ? dm_multisnap_work+0x0/0xb0
> [dm_multisnapshot]
> [ 2788.135559]  [<ffffffffa00e4533>] ? dm_multisnap_work+0x33/0xb0
> [dm_multisnapshot]
> [ 2788.135559]  [<ffffffffa00e4500>] ? dm_multisnap_work+0x0/0xb0
> [dm_multisnapshot]
> [ 2788.135559]  [<ffffffff8024302e>] ? run_workqueue+0xbe/0x150
> [ 2788.135559]  [<ffffffff80243af0>] ? worker_thread+0x0/0xb0
> [ 2788.135559]  [<ffffffff80243af0>] ? worker_thread+0x0/0xb0
> [ 2788.135559]  [<ffffffff80243b5d>] ? worker_thread+0x6d/0xb0
> [ 2788.135559]  [<ffffffff80246d80>] ? autoremove_wake_function+0x0/0x30
> [ 2788.135559]  [<ffffffff80243af0>] ? worker_thread+0x0/0xb0
> [ 2788.135559]  [<ffffffff80243af0>] ? worker_thread+0x0/0xb0
> [ 2788.135559]  [<ffffffff8024696b>] ? kthread+0x4b/0x80
> [ 2788.135559]  [<ffffffff8020cff9>] ? child_rip+0xa/0x11
> [ 2788.135559]  [<ffffffff80246920>] ? kthread+0x0/0x80
> [ 2788.135559]  [<ffffffff8020cfef>] ? child_rip+0x0/0x11
> [ 2788.135559] Code: 8d b3 a8 00 00 00 e8 08 f9 15 e0 e9 55 ff ff ff 0f 1f 00
> 8d 72 01 e9 4a fe ff ff 48 c7 83 d0 00 00 00 00 00 00 00 e9 e3 fd ff ff <0f>
> 0b eb fe 0f 1f 40 00 48 89 df e8 88 be ff ff 85 c0 0f 85 07
> [ 2788.135559] RIP  [<ffffffffa00e4178>] dm_multisnap_process_bios+0x278/0x600
> [dm_multisnapshot]
> [ 2788.135559]  RSP <ffff88001fa77c90>
> [ 2788.324941] ---[ end trace cca5fac1560b5d2c ]---
> 
> 
> 
> 
> best regards.
> 
> Mikulas Patocka wrote:
> > Oh, sorry, there was a bug with big devices. I uploaded new patches at the
> > same location, try them. (there's another fix for bug when sector size is
> > smaller than chunk size in these new patches)
> > 
> > BTW. for good performance, make sure that the size of your origin partition
> > is aligned to the chunk size --- otherwise, there's a serious inefficiency
> > in the kernel; if you use it over a partition with odd number of sectors,
> > the kernel will split all IOs to 512 bytes and it'll be very slow.
> > 
> > Mikulas
> > 
> >   
> > > Hi Mikulas
> > > Thanks for your job.
> > > 
> > > In my vmware ESXi guest OS (linux-2.6.28-rc5), the multisnap was crashed.
> > > 
> > > dd if=/dev/zero of=/dev/LD/snap bs=4096 count=1
> > > echo 0 `blockdev --getsize /dev/mapper/LD-ori` multisnapshot
> > > /dev/mapper/LD-ori /dev/mapper/LD-snap 4096|dmsetup create ms
> > > 
> > > [  298.050106] ------------[ cut here ]------------
> > > [  298.050106] kernel BUG at drivers/md/dm-bufio.c:156!
> > > [  298.050106] invalid opcode: 0000 [#1] SMP [  298.050106] last sysfs
> > > file:
> > > /sys/block/sde/dev
> > > [  298.050106] CPU 0 [  298.050106] Modules linked in: dm_multisnapshot
> > > hangcheck_timer e1000 e1000e megaraid_sas megaraid_mbox megaraid_mm mptsas
> > > mptspi mptscsih mptctl mptbase dm_mod scsi_transport_sas
> > > scsi_transport_spi
> > > sd_mod
> > > [  298.050106] Pid: 1759, comm: dmsetup Not tainted 2.6.28-rc5-1128 #1
> > > [  298.050106] RIP: 0010:[<ffffffffa002dae4>]  [<ffffffffa002dae4>]
> > > get_unclaimed_buffer+0xd4/0x130 [dm_mod]
> > > [  298.050106] RSP: 0018:ffff8800165edb28  EFLAGS: 00010202
> > > [  298.050106] RAX: 0000000000000004 RBX: ffff880016219f00 RCX:
> > > ffff880016219f10
> > > [  298.050106] RDX: 0000000000000902 RSI: 0000000000000001 RDI:
> > > ffff880016219f40
> > > [  298.050106] RBP: ffff88001624e000 R08: ffff88001624e000 R09:
> > > ffff8800173ca000
> > > [  298.050106] R10: 0000000000000003 R11: 0000000000000000 R12:
> > > 0000000000000001
> > > [  298.050106] R13: ffff88001624e000 R14: 000000000020c401 R15:
> > > ffff88001624e020
> > > [  298.050106] FS:  00007fd02c0356f0(0000) GS:ffffffff80658800(0000)
> > > knlGS:0000000000000000
> > > [  298.050106] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > > [  298.050106] CR2: 00007f47f4405590 CR3: 00000000160f6000 CR4:
> > > 00000000000006a0
> > > [  298.050106] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > 0000000000000000
> > > [  298.050106] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> > > 0000000000000400
> > > [  298.050106] Process dmsetup (pid: 1759, threadinfo ffff8800165ec000,
> > > task
> > > ffff880025174c20)
> > > [  298.050106] Stack:
> > > [  298.050106]  0000000000000000 ffff880016227000 ffff880016219f00
> > > ffffffffa002deab
> > > [  298.050106]  ffff88001624e860 ffff88001624e068 0000000000000286
> > > ffff8800165edc18
> > > [  298.050106]  0000000000000000 ffff880025174c20 ffffffff8022b950
> > > 0000000000000000
> > > [  298.050106] Call Trace:
> > > [  298.050106]  [<ffffffffa002deab>] ? dm_bufio_new_read+0x2ab/0x2f0
> > > [dm_mod]
> > > [  298.050106]  [<ffffffff8022b950>] ? default_wake_function+0x0/0x10
> > > [  298.050106]  [<ffffffffa00e0918>] ? multisnap_origin_ctr+0x4f8/0xc90
> > > [dm_multisnapshot]
> > > [  298.050106]  [<ffffffffa002932b>] ? dm_table_add_target+0x18b/0x3c0
> > > [dm_mod]
> > > [  298.050106]  [<ffffffffa002b2ff>] ? table_load+0xaf/0x210 [dm_mod]
> > > [  298.050106]  [<ffffffff8027b28d>] ? __vmalloc_area_node+0xbd/0x130
> > > [  298.050106]  [<ffffffffa002b250>] ? table_load+0x0/0x210 [dm_mod]
> > > [  298.050106]  [<ffffffffa002c0d1>] ? dm_ctl_ioctl+0x251/0x2c0 [dm_mod]
> > > [  298.050106]  [<ffffffff8029784f>] ? vfs_ioctl+0x2f/0xa0
> > > [  298.050106]  [<ffffffff80297c00>] ? do_vfs_ioctl+0x340/0x470
> > > [  298.050106]  [<ffffffff80297d79>] ? sys_ioctl+0x49/0x80
> > > [  298.050106]  [<ffffffff8020c10b>] ? system_call_fastpath+0x16/0x1b
> > > [  298.050106] Code: 54 a8 02 74 aa 45 85 e4 74 e9 f6 07 02 74 a0 b9 02 00
> > > 00
> > > 00 48 c7 c2 20 d9 02 a0 be 01 00 00 00 e8 42 fe 4b e0 eb 88 0f 0b eb fe
> > > <0f>
> > > 0b eb fe 31 db eb 84 45 85 e4 90 0f 84 60 ff ff ff b9 02 00 [  298.050106]
> > > RIP
> > > [<ffffffffa002dae4>] get_unclaimed_buffer+0xd4/0x130 [dm_mod]
> > > [  298.050106]  RSP <ffff8800165edb28>
> > > [  298.218349] ---[ end trace 9642e91f49f4b2b1 ]---
> > > #dmsetup ls
> > > LD-snap	(254, 1)
> > > LD-ori	(254, 0)
> > > ms	(254, 2)
> > > #ls /dev/mapper/
> > > LD-ori   LD-snap  control #vgdisplay -v      Finding all volume groups
> > >    Finding volume group "LD"
> > >  --- Volume group ---
> > >  VG Name               LD
> > >  System ID              Format                lvm2
> > >  Metadata Areas        8
> > >  Metadata Sequence No  3
> > >  VG Access             read/write
> > >  VG Status             resizable
> > >  MAX LV                0
> > >  Cur LV                2
> > >  Open LV               2
> > >  Max PV                0
> > >  Cur PV                4
> > >  Act PV                4
> > >  VG Size               53.98 GB
> > >  PE Size               4.00 MB
> > >  Total PE              13820
> > >  Alloc PE / Size       13312 / 52.00 GB
> > >  Free  PE / Size       508 / 1.98 GB
> > >  VG UUID               r0hOuU-L4I0-V3Zy-hK10-TtJe-toBw-9BDpCY
> > >    --- Logical volume ---
> > >  LV Name                /dev/LD/ori
> > >  VG Name                LD
> > >  LV UUID                LXOLcd-oPdk-xXoq-ZmK6-B4Qd-z8y6-Vf1WZ8
> > >  LV Write Access        read/write
> > >  LV Status              available
> > >  # open                 1
> > >  LV Size                26.00 GB
> > >  Current LE             6656
> > >  Segments               1
> > >  Allocation             inherit
> > >  Read ahead sectors     auto
> > >  - currently set to     256
> > >  Block device           254:0
> > >    --- Logical volume ---
> > >  LV Name                /dev/LD/snap
> > >  VG Name                LD
> > >  LV UUID                MlgpYW-AbNZ-7DMd-BEmc-RNiz-wmsa-vNiq1m
> > >  LV Write Access        read/write
> > >  LV Status              available
> > >  # open                 1
> > >  LV Size                26.00 GB
> > >  Current LE             6656
> > >  Segments               4
> > >  Allocation             inherit
> > >  Read ahead sectors     auto
> > >  - currently set to     256#vgdisplay -v      Finding all volume groups
> > >    Finding volume group "LD"
> > >  --- Volume group ---
> > >  VG Name               LD
> > >  System ID              Format                lvm2
> > >  Metadata Areas        8
> > >  Metadata Sequence No  3
> > >  VG Access             read/write
> > >  VG Status             resizable
> > >  MAX LV                0
> > >  Cur LV                2
> > >  Open LV               2
> > >  Max PV                0
> > >  Cur PV                4
> > >  Act PV                4
> > >  VG Size               53.98 GB
> > >  PE Size               4.00 MB
> > >  Total PE              13820
> > >  Alloc PE / Size       13312 / 52.00 GB
> > >  Free  PE / Size       508 / 1.98 GB
> > >  VG UUID               r0hOuU-L4I0-V3Zy-hK10-TtJe-toBw-9BDpCY
> > >    --- Logical volume ---
> > >  LV Name                /dev/LD/ori
> > >  VG Name                LD
> > >  LV UUID                LXOLcd-oPdk-xXoq-ZmK6-B4Qd-z8y6-Vf1WZ8
> > >  LV Write Access        read/write
> > >  LV Status              available
> > >  # open                 1
> > >  LV Size                26.00 GB
> > >  Current LE             6656
> > >  Segments               1
> > >  Allocation             inherit
> > >  Read ahead sectors     auto
> > >  - currently set to     256
> > >  Block device           254:0
> > >    --- Logical volume ---
> > >  LV Name                /dev/LD/snap
> > >  VG Name                LD
> > >  LV UUID                MlgpYW-AbNZ-7DMd-BEmc-RNiz-wmsa-vNiq1m
> > >  LV Write Access        read/write
> > >  LV Status              available
> > >  # open                 1
> > >  LV Size                26.00 GB
> > >  Current LE             6656
> > >  Segments               4
> > >  Allocation             inherit
> > >  Read ahead sectors     auto
> > >  - currently set to     256
> > >  Block device           254:1
> > >    --- Physical volumes ---
> > >  PV Name               /dev/sda      PV UUID
> > > lc8iKg-WrqG-XWyL-t6TW-TtPj-HQn1-pgbtku
> > >  PV Status             allocatable
> > >  Total PE / Free PE    7679 / 508
> > >    PV Name               /dev/sdc      PV UUID
> > > bbHAWq-adBj-ACcU-5Bp6-LM2Y-r5M6-9ncvGc
> > >  PV Status             allocatable
> > >  Total PE / Free PE    2047 / 0
> > >    PV Name               /dev/sdd      PV UUID
> > > 5B7gOQ-KKuk-XtHm-6FSr-11Q4-2p7y-lr2xGP
> > >  PV Status             allocatable
> > >  Total PE / Free PE    2047 / 0
> > >    PV Name               /dev/sde      PV UUID
> > > kXUvPh-gsVN-oQln-CiMu-XdR2-C1Xd-DgLtjb
> > >  PV Status             allocatable
> > >  Total PE / Free PE    2047 / 0
> > > 
> > >  Block device           254:1
> > >    --- Physical volumes ---
> > >  PV Name               /dev/sda      PV UUID
> > > lc8iKg-WrqG-XWyL-t6TW-TtPj-HQn1-pgbtku
> > >  PV Status             allocatable
> > >  Total PE / Free PE    7679 / 508
> > >    PV Name               /dev/sdc      PV UUID
> > > bbHAWq-adBj-ACcU-5Bp6-LM2Y-r5M6-9ncvGc
> > >  PV Status             allocatable
> > >  Total PE / Free PE    2047 / 0
> > >    PV Name               /dev/sdd      PV UUID
> > > 5B7gOQ-KKuk-XtHm-6FSr-11Q4-2p7y-lr2xGP
> > >  PV Status             allocatable
> > >  Total PE / Free PE    2047 / 0
> > >    PV Name               /dev/sde      PV UUID
> > > kXUvPh-gsVN-oQln-CiMu-XdR2-C1Xd-DgLtjb
> > >  PV Status             allocatable
> > >  Total PE / Free PE    2047 / 0
> > > 
> > > What's wrong with my test?
> > > 
> > > best regards
> > > 
> > >     
> > 
> > 
> >   
