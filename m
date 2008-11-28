From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re:Announce: unlimited number of shared snapshots
Date: Fri, 28 Nov 2008 14:54:03 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0811281449520.6900@hs20-bc2-1.build.redhat.com>
References: <492FAF1C.8080401@gluesys.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <492FAF1C.8080401@gluesys.com>
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

Oh, sorry, there was a bug with big devices. I uploaded new patches at the 
same location, try them. (there's another fix for bug when sector size is 
smaller than chunk size in these new patches)

BTW. for good performance, make sure that the size of your origin 
partition is aligned to the chunk size --- otherwise, there's a serious 
inefficiency in the kernel; if you use it over a partition with odd number 
of sectors, the kernel will split all IOs to 512 bytes and it'll be very 
slow.

Mikulas

> Hi Mikulas
> Thanks for your job.
> 
> In my vmware ESXi guest OS (linux-2.6.28-rc5), the multisnap was crashed.
> 
> dd if=/dev/zero of=/dev/LD/snap bs=4096 count=1
> echo 0 `blockdev --getsize /dev/mapper/LD-ori` multisnapshot
> /dev/mapper/LD-ori /dev/mapper/LD-snap 4096|dmsetup create ms
> 
> [  298.050106] ------------[ cut here ]------------
> [  298.050106] kernel BUG at drivers/md/dm-bufio.c:156!
> [  298.050106] invalid opcode: 0000 [#1] SMP [  298.050106] last sysfs file:
> /sys/block/sde/dev
> [  298.050106] CPU 0 [  298.050106] Modules linked in: dm_multisnapshot
> hangcheck_timer e1000 e1000e megaraid_sas megaraid_mbox megaraid_mm mptsas
> mptspi mptscsih mptctl mptbase dm_mod scsi_transport_sas scsi_transport_spi
> sd_mod
> [  298.050106] Pid: 1759, comm: dmsetup Not tainted 2.6.28-rc5-1128 #1
> [  298.050106] RIP: 0010:[<ffffffffa002dae4>]  [<ffffffffa002dae4>]
> get_unclaimed_buffer+0xd4/0x130 [dm_mod]
> [  298.050106] RSP: 0018:ffff8800165edb28  EFLAGS: 00010202
> [  298.050106] RAX: 0000000000000004 RBX: ffff880016219f00 RCX:
> ffff880016219f10
> [  298.050106] RDX: 0000000000000902 RSI: 0000000000000001 RDI:
> ffff880016219f40
> [  298.050106] RBP: ffff88001624e000 R08: ffff88001624e000 R09:
> ffff8800173ca000
> [  298.050106] R10: 0000000000000003 R11: 0000000000000000 R12:
> 0000000000000001
> [  298.050106] R13: ffff88001624e000 R14: 000000000020c401 R15:
> ffff88001624e020
> [  298.050106] FS:  00007fd02c0356f0(0000) GS:ffffffff80658800(0000)
> knlGS:0000000000000000
> [  298.050106] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  298.050106] CR2: 00007f47f4405590 CR3: 00000000160f6000 CR4:
> 00000000000006a0
> [  298.050106] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  298.050106] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [  298.050106] Process dmsetup (pid: 1759, threadinfo ffff8800165ec000, task
> ffff880025174c20)
> [  298.050106] Stack:
> [  298.050106]  0000000000000000 ffff880016227000 ffff880016219f00
> ffffffffa002deab
> [  298.050106]  ffff88001624e860 ffff88001624e068 0000000000000286
> ffff8800165edc18
> [  298.050106]  0000000000000000 ffff880025174c20 ffffffff8022b950
> 0000000000000000
> [  298.050106] Call Trace:
> [  298.050106]  [<ffffffffa002deab>] ? dm_bufio_new_read+0x2ab/0x2f0 [dm_mod]
> [  298.050106]  [<ffffffff8022b950>] ? default_wake_function+0x0/0x10
> [  298.050106]  [<ffffffffa00e0918>] ? multisnap_origin_ctr+0x4f8/0xc90
> [dm_multisnapshot]
> [  298.050106]  [<ffffffffa002932b>] ? dm_table_add_target+0x18b/0x3c0
> [dm_mod]
> [  298.050106]  [<ffffffffa002b2ff>] ? table_load+0xaf/0x210 [dm_mod]
> [  298.050106]  [<ffffffff8027b28d>] ? __vmalloc_area_node+0xbd/0x130
> [  298.050106]  [<ffffffffa002b250>] ? table_load+0x0/0x210 [dm_mod]
> [  298.050106]  [<ffffffffa002c0d1>] ? dm_ctl_ioctl+0x251/0x2c0 [dm_mod]
> [  298.050106]  [<ffffffff8029784f>] ? vfs_ioctl+0x2f/0xa0
> [  298.050106]  [<ffffffff80297c00>] ? do_vfs_ioctl+0x340/0x470
> [  298.050106]  [<ffffffff80297d79>] ? sys_ioctl+0x49/0x80
> [  298.050106]  [<ffffffff8020c10b>] ? system_call_fastpath+0x16/0x1b
> [  298.050106] Code: 54 a8 02 74 aa 45 85 e4 74 e9 f6 07 02 74 a0 b9 02 00 00
> 00 48 c7 c2 20 d9 02 a0 be 01 00 00 00 e8 42 fe 4b e0 eb 88 0f 0b eb fe <0f>
> 0b eb fe 31 db eb 84 45 85 e4 90 0f 84 60 ff ff ff b9 02 00 [  298.050106] RIP
> [<ffffffffa002dae4>] get_unclaimed_buffer+0xd4/0x130 [dm_mod]
> [  298.050106]  RSP <ffff8800165edb28>
> [  298.218349] ---[ end trace 9642e91f49f4b2b1 ]---
> #dmsetup ls
> LD-snap	(254, 1)
> LD-ori	(254, 0)
> ms	(254, 2)
> #ls /dev/mapper/
> LD-ori   LD-snap  control 
> #vgdisplay -v      Finding all volume groups
>    Finding volume group "LD"
>  --- Volume group ---
>  VG Name               LD
>  System ID              Format                lvm2
>  Metadata Areas        8
>  Metadata Sequence No  3
>  VG Access             read/write
>  VG Status             resizable
>  MAX LV                0
>  Cur LV                2
>  Open LV               2
>  Max PV                0
>  Cur PV                4
>  Act PV                4
>  VG Size               53.98 GB
>  PE Size               4.00 MB
>  Total PE              13820
>  Alloc PE / Size       13312 / 52.00 GB
>  Free  PE / Size       508 / 1.98 GB
>  VG UUID               r0hOuU-L4I0-V3Zy-hK10-TtJe-toBw-9BDpCY
>    --- Logical volume ---
>  LV Name                /dev/LD/ori
>  VG Name                LD
>  LV UUID                LXOLcd-oPdk-xXoq-ZmK6-B4Qd-z8y6-Vf1WZ8
>  LV Write Access        read/write
>  LV Status              available
>  # open                 1
>  LV Size                26.00 GB
>  Current LE             6656
>  Segments               1
>  Allocation             inherit
>  Read ahead sectors     auto
>  - currently set to     256
>  Block device           254:0
>    --- Logical volume ---
>  LV Name                /dev/LD/snap
>  VG Name                LD
>  LV UUID                MlgpYW-AbNZ-7DMd-BEmc-RNiz-wmsa-vNiq1m
>  LV Write Access        read/write
>  LV Status              available
>  # open                 1
>  LV Size                26.00 GB
>  Current LE             6656
>  Segments               4
>  Allocation             inherit
>  Read ahead sectors     auto
>  - currently set to     256#vgdisplay -v      Finding all volume groups
>    Finding volume group "LD"
>  --- Volume group ---
>  VG Name               LD
>  System ID              Format                lvm2
>  Metadata Areas        8
>  Metadata Sequence No  3
>  VG Access             read/write
>  VG Status             resizable
>  MAX LV                0
>  Cur LV                2
>  Open LV               2
>  Max PV                0
>  Cur PV                4
>  Act PV                4
>  VG Size               53.98 GB
>  PE Size               4.00 MB
>  Total PE              13820
>  Alloc PE / Size       13312 / 52.00 GB
>  Free  PE / Size       508 / 1.98 GB
>  VG UUID               r0hOuU-L4I0-V3Zy-hK10-TtJe-toBw-9BDpCY
>    --- Logical volume ---
>  LV Name                /dev/LD/ori
>  VG Name                LD
>  LV UUID                LXOLcd-oPdk-xXoq-ZmK6-B4Qd-z8y6-Vf1WZ8
>  LV Write Access        read/write
>  LV Status              available
>  # open                 1
>  LV Size                26.00 GB
>  Current LE             6656
>  Segments               1
>  Allocation             inherit
>  Read ahead sectors     auto
>  - currently set to     256
>  Block device           254:0
>    --- Logical volume ---
>  LV Name                /dev/LD/snap
>  VG Name                LD
>  LV UUID                MlgpYW-AbNZ-7DMd-BEmc-RNiz-wmsa-vNiq1m
>  LV Write Access        read/write
>  LV Status              available
>  # open                 1
>  LV Size                26.00 GB
>  Current LE             6656
>  Segments               4
>  Allocation             inherit
>  Read ahead sectors     auto
>  - currently set to     256
>  Block device           254:1
>    --- Physical volumes ---
>  PV Name               /dev/sda      PV UUID
> lc8iKg-WrqG-XWyL-t6TW-TtPj-HQn1-pgbtku
>  PV Status             allocatable
>  Total PE / Free PE    7679 / 508
>    PV Name               /dev/sdc      PV UUID
> bbHAWq-adBj-ACcU-5Bp6-LM2Y-r5M6-9ncvGc
>  PV Status             allocatable
>  Total PE / Free PE    2047 / 0
>    PV Name               /dev/sdd      PV UUID
> 5B7gOQ-KKuk-XtHm-6FSr-11Q4-2p7y-lr2xGP
>  PV Status             allocatable
>  Total PE / Free PE    2047 / 0
>    PV Name               /dev/sde      PV UUID
> kXUvPh-gsVN-oQln-CiMu-XdR2-C1Xd-DgLtjb
>  PV Status             allocatable
>  Total PE / Free PE    2047 / 0
> 
>  Block device           254:1
>    --- Physical volumes ---
>  PV Name               /dev/sda      PV UUID
> lc8iKg-WrqG-XWyL-t6TW-TtPj-HQn1-pgbtku
>  PV Status             allocatable
>  Total PE / Free PE    7679 / 508
>    PV Name               /dev/sdc      PV UUID
> bbHAWq-adBj-ACcU-5Bp6-LM2Y-r5M6-9ncvGc
>  PV Status             allocatable
>  Total PE / Free PE    2047 / 0
>    PV Name               /dev/sdd      PV UUID
> 5B7gOQ-KKuk-XtHm-6FSr-11Q4-2p7y-lr2xGP
>  PV Status             allocatable
>  Total PE / Free PE    2047 / 0
>    PV Name               /dev/sde      PV UUID
> kXUvPh-gsVN-oQln-CiMu-XdR2-C1Xd-DgLtjb
>  PV Status             allocatable
>  Total PE / Free PE    2047 / 0
> 
> What's wrong with my test?
> 
> best regards
> 
