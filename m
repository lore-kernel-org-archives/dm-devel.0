From: =?KOI8-R?B?89TF0MHOIOajxM/Sz9c=?= <stepan.fedorov@clodo.ru>
Subject: dm_ioband - BUG: unable to handle kernel NULL pointer
	dereference at (null)
Date: Fri, 27 May 2011 16:02:06 +0400
Message-ID: <BANLkTimeS4nXWKRD5ncdLfUGpi-LtKZCwg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hello!

I have subj error on two nodes with difference in several minutes.

Nodes configuration: SLES11SP1 with 2.6.32.36-0.5-xen kernel, and
dm-ioband-1.14.0 module.

After this error both nodes become inaccessible by network, with no
reaction on keyboard and needs to be power cycled:

May 27 15:47:27 xen39/xen39 kernel: [607952.607083] BUG: unable to
handle kernel NULL pointer dereference at (null)
May 27 15:47:27 xen39/xen39 kernel: [607952.607092] IP:
[<ffffffffa0071d17>] ioband_map+0x377/0x750 [dm_ioband]
May 27 15:47:27 xen39/xen39 kernel: [607952.607102] PGD 10c1b6067 PUD
104176067 PMD 0
May 27 15:47:27 xen39/xen39 kernel: [607952.607108] Oops: 0000 [#1] SMP
May 27 15:47:27 xen39/xen39 kernel: [607952.607111] last sysfs file:
/sys/devices/xen-backend/vif-13-0/net/vif13.0/statistics/rx_bytes
May 27 15:47:27 xen39/xen39 kernel: [607952.607115] CPU 0
May 27 15:47:27 xen39/xen39 kernel: [607952.607117] Modules linked in:
raid1 dm_ioband(N) raid10 dm_round_robin sg sd_mod crc_t10dif usbbk
gntdev netbk blkbk blkback_pagemap blktap domctl xenbus_be iscsi_tcp l
ibiscsi_tcp nfs lockd fscache nfs_acl auth_rpcgss sunrpc xt_tcpudp
xt_multiport iptable_filter ip_tables x_tables bridge stp llc bonding
rdma_ucm ib_iser(F) libiscsi(F) scsi_transport_iscsi(F) rdma_cm iw_cm
ib
_addr dm_multipath scsi_dh ib_srp scsi_transport_srp scsi_tgt ib_ipoib
ib_cm ib_sa ipv6 ib_uverbs ib_umad mlx4_ib ib_mad ib_core loop ext2
mbcache xenblk cdrom xennet dm_mod brd serio_raw af_packet bnx2 joydev
 uhci_hcd ahci ehci_hcd mlx4_core rtc_cmos rtc_core rtc_lib 8250_pnp
8250 serial_core pcspkr button tpm_tis tpm tpm_bios libata iTCO_wdt
iTCO_vendor_support scsi_mod igb dca usbcore thermal processor
thermal_s
ys hwmon
May 27 15:47:27 xen39/xen39 kernel: [607952.607186] Supported: No,
Unsupported modules are loaded
May 27 15:47:27 xen39/xen39 kernel: [607952.607190] Pid: 19767, comm:
kdmflush Tainted: GF         N  2.6.32.36-0.5-xen #1 ProLiant DL170h
G6
May 27 15:47:27 xen39/xen39 kernel: [607952.607194] RIP:
e030:[<ffffffffa0071d17>]  [<ffffffffa0071d17>] ioband_map+0x377/0x750
[dm_ioband]
May 27 15:47:27 xen39/xen39 kernel: [607952.607200] RSP:
e02b:ffff88013c229bf0  EFLAGS: 00010002
May 27 15:47:27 xen39/xen39 kernel: [607952.607203] RAX:
0000000000000000 RBX: ffff8801368b8200 RCX: ffff88010eecf400
May 27 15:47:27 xen39/xen39 kernel: [607952.607206] RDX:
0000000000000000 RSI: 00000000e9bae9ba RDI: ffff8801360f2cc0
May 27 15:47:27 xen39/xen39 kernel: [607952.607209] RBP:
ffff88010eecf400 R08: ffff880104ba2c40 R09: 00000000ffffffff
May 27 15:47:27 xen39/xen39 kernel: [607952.607212] R10:
00000001090df298 R11: 0000000000000001 R12: 0000000000000000
May 27 15:47:27 xen39/xen39 kernel: [607952.607215] R13:
0000000000000001 R14: ffff8801360f2cc0 R15: 0000000000000000
May 27 15:47:27 xen39/xen39 kernel: [607952.607223] FS:
00007fe8404d7700(0000) GS:ffff88000800a000(0000)
knlGS:0000000000000000
May 27 15:47:27 xen39/xen39 kernel: [607952.607227] CS:  e033 DS: 0000
ES: 0000 CR0: 000000008005003b
May 27 15:47:27 xen39/xen39 kernel: [607952.607229] CR2:
0000000000000000 CR3: 0000000115289000 CR4: 0000000000002660
May 27 15:47:27 xen39/xen39 kernel: [607952.607233] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 27 15:47:27 xen39/xen39 kernel: [607952.607236] DR3:
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 27 15:47:27 xen39/xen39 kernel: [607952.607239] Process kdmflush
(pid: 19767, threadinfo ffff88013c228000, task ffff8801008a0180)
May 27 15:47:27 xen39/xen39 kernel: [607952.607242] Stack:
May 27 15:47:27 xen39/xen39 kernel: [607952.607244]  ffff88013c229c10
ffffffff8009d3d2 ffffc900100bb080 ffff88010eecf4b0
May 27 15:47:27 xen39/xen39 kernel: [607952.607248] <0>
ffff88010eecf400 0000000000000000 ffff88013c229c48 ffff8801008a0180
May 27 15:47:27 xen39/xen39 kernel: [607952.607253] <0>
0000000000000001 0000000000000000 0000000300000000 0000000000000000
May 27 15:47:27 xen39/xen39 kernel: [607952.607259] Call Trace:
May 27 15:47:27 xen39/xen39 kernel: [607952.607283]
[<ffffffffa0251d0d>] __map_bio+0x2d/0xb0 [dm_mod]
May 27 15:47:27 xen39/xen39 kernel: [607952.607293]
[<ffffffffa02521fd>] __clone_and_map+0x46d/0x480 [dm_mod]
May 27 15:47:27 xen39/xen39 kernel: [607952.607302]
[<ffffffffa02531b5>] __split_and_process_bio+0xf5/0x190 [dm_mod]
May 27 15:47:27 xen39/xen39 kernel: [607952.607312]
[<ffffffffa025329e>] dm_flush+0x4e/0x70 [dm_mod]
May 27 15:47:27 xen39/xen39 kernel: [607952.607322]
[<ffffffffa02538c7>] process_barrier+0x27/0x150 [dm_mod]
May 27 15:47:27 xen39/xen39 kernel: [607952.607332]
[<ffffffffa0253a33>] dm_wq_work+0x43/0x150 [dm_mod]
May 27 15:47:27 xen39/xen39 kernel: [607952.607342]
[<ffffffff80053333>] run_workqueue+0xa3/0x1f0
May 27 15:47:27 xen39/xen39 kernel: [607952.607348]
[<ffffffff80053516>] worker_thread+0x96/0x110
May 27 15:47:27 xen39/xen39 kernel: [607952.607354]
[<ffffffff80056bb6>] kthread+0x96/0xa0
May 27 15:47:27 xen39/xen39 kernel: [607952.607359]
[<ffffffff80007f0a>] child_rip+0xa/0x20
May 27 15:47:27 xen39/xen39 kernel: [607952.607363] Code: 8b 42 10 49
29 06 4d 63 e7 49 8d 44 24 2c 8b 44 83 04 85 c0 0f 84 32 02 00 00 48
8b 6b 38 42 83 84 a5 a8 00 00 00 01 49 8b 46 48 <48> 8b 00 48 8b 00 a9
 00 00 10 00 0f 84 c8 02 00 00 ba 01 00 00
May 27 15:47:27 xen39/xen39 kernel: [607952.607395] RIP
[<ffffffffa0071d17>] ioband_map+0x377/0x750 [dm_ioband]
May 27 15:47:27 xen39/xen39 kernel: [607952.607400]  RSP <ffff88013c229bf0>
May 27 15:47:27 xen39/xen39 kernel: [607952.607402] CR2: 0000000000000000
May 27 15:47:27 xen39/xen39 kernel: [607952.607405] ---[ end trace
e861109e586028ec ]---
