From: Ming Lei <tom.leiming@gmail.com>
Subject: [BUG] DM: kernel BUG at block/bio.c:1872!
Date: Thu, 21 Feb 2019 09:15:25 +0800
Message-ID: <CACVXFVOrduLjUL6ecHb3XvcGFNTc__ERZKhkjx+FnVBJTKspKg@mail.gmail.com>
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
To: Mike Snitzer <snitzer@redhat.com>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>
Cc: linux-block <linux-block@vger.kernel.org>
List-Id: dm-devel.ids

Hi,

Just saw the following kernel panic on today's -next by running
generic/081 of xfstests.

[  307.026552] run fstests generic/081 at 2019-02-20 17:01:42
[  307.647611] ------------[ cut here ]------------
[  307.648318] kernel BUG at block/bio.c:1872!
[  307.648950] invalid opcode: 0000 [#1] PREEMPT SMP PTI
[  307.649695] CPU: 0 PID: 20837 Comm: mkfs.ext4 Not tainted
5.0.0-rc7_abf446c90405_master-next-20190220 #1
[  307.651039] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.10.2-2.fc27 04/01/2014
[  307.652267] RIP: 0010:bio_split+0xf/0x70
[  307.652828] Code: e8 64 e1 02 00 85 c0 79 0a 48 89 df 31 db e8 cc
f9 ff ff 48 89 d8 5b 5d 41 5c c3 0f 1f 44 00 00 85 f6 41 54 55 89 f5
53 7f 02 <0f> 0b 89 d6 8b 57 30 c1 ea 09 39 ea 77 02 0f 0b 48 89 ca 49
89 fc
[  307.655473] RSP: 0018:ffffc90000a13ae8 EFLAGS: 00010246
[  307.656230] RAX: ffff88807e8997d0 RBX: ffff888073660a00 RCX: ffff88807e899de0
[  307.657250] RDX: 0000000000000c00 RSI: 0000000000000000 RDI: ffff888073660a00
[  307.658263] RBP: 0000000000000000 R08: 00000000f461fd9b R09: 0000000000000006
[  307.659268] R10: ffffc90000a13a38 R11: ffff88817662fcf8 R12: ffffc90000955040
[  307.660288] R13: ffff8880710a0000 R14: ffff88807f14c580 R15: 0000000000000000
[  307.661303] FS:  00007f503aa59780(0000) GS:ffff888079200000(0000)
knlGS:0000000000000000
[  307.662447] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  307.663243] CR2: 00005611c738e408 CR3: 000000007ecec006 CR4: 0000000000760ef0
[  307.664264] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  307.665275] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  307.666268] PKRU: 55555554
[  307.666654] Call Trace:
[  307.667014]  __split_and_process_bio+0x10a/0x244 [dm_mod]
[  307.667814]  ? get_page_from_freelist+0xa91/0x1031
[  307.668526]  ? bd_set_size+0x1d/0x37
[  307.669061]  dm_process_bio+0x321/0x335 [dm_mod]
[  307.669728]  ? generic_make_request_checks+0x4b1/0x55a
[  307.670481]  dm_make_request+0x66/0x7f [dm_mod]
[  307.671161]  generic_make_request+0x1b6/0x322
[  307.671784]  ? submit_bio+0x103/0x11f
[  307.672332]  submit_bio+0x103/0x11f
[  307.672841]  ? bio_associate_blkg+0x4d/0x53
[  307.673468]  submit_bio_wait+0x53/0x7f
[  307.674036]  blkdev_issue_discard+0x7c/0xc2
[  307.674656]  ? blk_ioctl_discard+0xd1/0xf3
[  307.675252]  blk_ioctl_discard+0xd1/0xf3
[  307.675827]  blkdev_ioctl+0x315/0x8be
[  307.676365]  block_ioctl+0x3c/0x3f
[  307.676856]  vfs_ioctl+0x1e/0x2b
[  307.677345]  do_vfs_ioctl+0x531/0x559
[  307.677888]  ? handle_mm_fault+0x1a8/0x1f9
[  307.678480]  ksys_ioctl+0x3e/0x5d
[  307.678974]  __x64_sys_ioctl+0x16/0x19
[  307.679536]  do_syscall_64+0x84/0x13f
[  307.680066]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  307.680813] RIP: 0033:0x7f50398c7267
[  307.681349] Code: b3 66 90 48 8b 05 19 3c 2c 00 64 c7 00 26 00 00
00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 b8 10 00 00
00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 3b 2c 00 f7 d8 64 89
01 48
[  307.684000] RSP: 002b:00007ffc3fd8fb68 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[  307.685098] RAX: ffffffffffffffda RBX: 00005611c738d020 RCX: 00007f50398c7267
[  307.686130] RDX: 00007ffc3fd8fb70 RSI: 0000000000001277 RDI: 0000000000000003
[  307.687156] RBP: 00007f503a842660 R08: 00005611c7388fc0 R09: 0000000000000000
[  307.688196] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  307.689222] R13: 0000000000040000 R14: 0000000000000000 R15: 0000000000000000
[  307.690252] Modules linked in: dm_snapshot dm_bufio xfs libcrc32c
dm_flakey isofs dm_service_time dm_multipath iTCO_wdt
iTCO_vendor_support i2c_i801 i2c_core lpc_ich mfd_core ip_tables
sr_mod sd_mod cdrom usb_storage ahci libahci libata crc32c_intel
virtio_scsi qemu_fw_cfg dm_mirror dm_region_hash dm_log dm_mod
[  307.694201] Dumping ftrace buffer:
[  307.694700]    (ftrace buffer empty)
[  307.695262] ---[ end trace f8142e64e118e61c ]---

Thanks,
Ming Lei
