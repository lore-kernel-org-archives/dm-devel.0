From: "Jason Cai (Xiang Feng)" <jason.cai.kern@gmail.com>
Subject: [PATCH] dm thin: add sanity checks on creating thin-pool and
 external snapshot
Date: Sun, 20 Jan 2019 22:39:13 +0800
Message-ID: <20190120143913.GA27003@ali-6c96cfde3a47.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: snitzer@redhat.com, agk@redhat.com, ejt@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: jason.cai.kern@gmail.com
List-Id: dm-devel.ids

Invoking `dm_get_device` twice on the same device path with different
modes is dangerous. Because in that case, `upgrade_mode()` will place
a new `dm_dev` and free the old one, which may be referenced by a
previous caller. Subsequently dereference the dangling pointer will
trigger kernel NULL pointer dereference.

The following two cases can reproduce this issue. Actually, they are
invalid setups. And we need to prevent them from triggering panic.

e.g.:

1. Creating a thin-pool with read_only mode, and the same device as
both metadata and data.

```
dmsetup create thinp --table \
    "0 41943040 thin-pool /dev/vdb /dev/vdb 128 0 1 read_only"

BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 0 PID: 4024 Comm: dmsetup Tainted: G           O 4.19.14 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
RIP: 0010:submit_io+0x90/0x220 [dm_bufio]
Code: 0f 8e 92 01 00 00 31 d2 bf 00 12 40 00 e8 b8 66 22 e1 48 85 c0 49 89 c7 0f 84 e7 00 00 00 4c 89 60 28 48 8b 43 60 48 8b 40 50 <48> 8b 80 80 00 00 00 49 39 47
08 74 16 66 41 81 67 14 ff fd 48 8b
RSP: 0018:ffffc9000193ba30 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8881f45250c8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88822f1a3bd8
RBP: ffffc9000193ba88 R08: ffff88822f1a3b40 R09: ffff888237403380
R10: 0000000000240000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: ffff88822f1a3b40
FS:  00007fb5d0b41680(0000) GS:ffff888237a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000080 CR3: 0000000234a88005 CR4: 00000000001606f0
Call Trace:
 new_read+0xfb/0x110 [dm_bufio]
 dm_bm_read_lock+0x43/0x190 [dm_persistent_data]
 ? kmem_cache_alloc_trace+0x15c/0x1e0
 __create_persistent_data_objects+0x65/0x3e0 [dm_thin_pool]
 dm_pool_metadata_open+0x8c/0xf0 [dm_thin_pool]
 pool_ctr.cold.79+0x213/0x913 [dm_thin_pool]
 ? realloc_argv+0x50/0x70 [dm_mod]
 dm_table_add_target+0x14e/0x330 [dm_mod]
 table_load+0x122/0x2e0 [dm_mod]
 ? dev_status+0x40/0x40 [dm_mod]
 ctl_ioctl+0x1aa/0x3e0 [dm_mod]
 dm_ctl_ioctl+0xa/0x10 [dm_mod]
 do_vfs_ioctl+0xa2/0x600
 ? handle_mm_fault+0xda/0x200
 ? __do_page_fault+0x26c/0x4f0
 ksys_ioctl+0x60/0x90
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x55/0x150
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
```

2. Creating a external snapshot using the same thin-pool device.

```
dmsetup create thinp --table \
    "0 41943040 thin-pool /dev/vdc /dev/vdb 128 0 2 ignore_discard"
dmsetup message /dev/mapper/thinp 0 "create_thin 0"
dmsetup create snap --table \
            "0 204800 thin /dev/mapper/thinp 0 /dev/mapper/thinp"

BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
PGD 0 P4D 0
Oops: 0000 [#2] SMP
CPU: 4 PID: 1806 Comm: dmsetup Tainted: G      D 4.19.14 #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
RIP: 0010:thin_status+0xc1/0x220 [dm_thin_pool]
Code: c2 bc 78 33 a0 e8 ff 1e 53 e1 4c 63 e8 48 8b 43 18 48 85 c0 74 41 4c 39 ed 7e 3c 48 8b 00 48 8d 7c 24 18 48 c7 c6 76 78 33 a0 <8b> 10 89 d1 c1 ea 14 81 e1 ff
ff 0f 00 e8 5d 1f 53 e1 48 89 ee 48
RSP: 0018:ffffc90001c4bbe0 EFLAGS: 00010216
RAX: 0000000000000000 RBX: ffff8882333b1f00 RCX: 0000000000000000
RDX: 0000000000000007 RSI: ffffffffa0337876 RDI: ffffc90001c4bbf8
RBP: 0000000000003ea0 R08: ffffc90001c4bbf7 R09: 00000000fe3b4408
R10: ffff8882335f0000 R11: ffff8882335ec167 R12: ffff8882335ec160
R13: 0000000000000007 R14: ffff8882335ec160 R15: ffffc90001379040
FS:  00007f2f5ae30680(0000) GS:ffff888237b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000022f778002 CR4: 00000000001606e0
Call Trace:
? __alloc_pages_nodemask+0x13c/0x2e0
retrieve_status+0xa5/0x1f0 [dm_mod]
? dm_get_live_or_inactive_table.isra.7+0x20/0x20 [dm_mod]
 table_status+0x61/0xa0 [dm_mod]
 ctl_ioctl+0x1aa/0x3e0 [dm_mod]
 dm_ctl_ioctl+0xa/0x10 [dm_mod]
 do_vfs_ioctl+0xa2/0x600
 ksys_ioctl+0x60/0x90
 ? ksys_write+0x4f/0xb0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x55/0x150
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
```

Signed-off-by: Jason Cai (Xiang Feng) <jason.cai@linux.alibaba.com>
---
 drivers/md/dm-thin.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index dadd9696340c..23cc401a6340 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3238,6 +3238,13 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	as.argc = argc;
 	as.argv = argv;
 
+	/* make sure metadata and data are different devices */
+	if (!strcmp(argv[0], argv[1])) {
+		ti->error = "Error setting metadata or data device";
+		r = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Set default pool features.
 	 */
@@ -4122,6 +4129,12 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	tc->sort_bio_list = RB_ROOT;
 
 	if (argc == 3) {
+		if (!strcmp(argv[0], argv[2])) {
+			ti->error = "Error setting origin device";
+			r = -EINVAL;
+			goto bad_origin_dev;
+		}
+
 		r = dm_get_device(ti, argv[2], FMODE_READ, &origin_dev);
 		if (r) {
 			ti->error = "Error opening origin device";
-- 
2.17.0
