From: majianpeng <majianpeng@gmail.com>
Subject: [PATCH] dm-cache: Add handle to contlr if cache_create
	failed.
Date: Fri, 08 Mar 2013 09:51:24 +0800
Message-ID: <5139441C.7000309@gmail.com>
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
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

It  ignored to judge the result of cache_create.
If cache_create failed, but the copy_ctr_args successed.
It will incur oops. Kernel messages as following:
[   73.533782] device-mapper: cache-policy: unknown policy type
[   73.533808] BUG: unable to handle kernel NULL pointer dereference at 0000000000000338
[   73.533841] IP: [<ffffffffa00bf76d>] cache_ctr+0xb2d/0xc90 [dm_cache]
[   73.533864] PGD 57caa067 PUD 56665067 PMD 0
[   73.533881] Oops: 0002 [#1] SMP
[   73.533896] Modules linked in: dm_cache dm_bio_prison dm_persistent_data dm_bufio libcrc32c fuse dm_mod dcdbas raid456 async_pq async_xor xor async_memcpy async_raid6_recov ata_piix r8169 raid6_pq
async_tx raid1
[   73.533974] CPU 0
[   73.533983] Pid: 5479, comm: dmsetup Not tainted 3.9.0-rc1+ #25 Dell Inc. OptiPlex 390/0M5DCD
[   73.534008] RIP: 0010:[<ffffffffa00bf76d>]  [<ffffffffa00bf76d>] cache_ctr+0xb2d/0xc90 [dm_cache]
[   73.534035] RSP: 0018:ffff88004dbb9b58  EFLAGS: 00010246
[   73.534051] RAX: ffffc90004552040 RBX: ffff88004db12840 RCX: 0000000000000000
[   73.534072] RDX: 0000000000000005 RSI: ffff8800500d41ba RDI: ffff880070096b8a
[   73.534092] RBP: ffff88004dbb9bf8 R08: ffff880075dd6400 R09: ffff880057c71300
[   73.534112] R10: 0000000000000005 R11: 0000000000000000 R12: 0000000000000000
[   73.534132] R13: ffff88006f932000 R14: 0000000000000005 R15: ffff880057c71300
[   73.534152] FS:  00007f60cc261700(0000) GS:ffff880075c00000(0000) knlGS:0000000000000000
[   73.534175] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   73.534192] CR2: 0000000000000338 CR3: 000000004daea000 CR4: 00000000000407f0
[   73.534212] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   73.534232] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   73.534252] Process dmsetup (pid: 5479, threadinfo ffff88004dbb8000, task ffff8800659a0000)
[   73.534275] Stack:
[   73.534282]  ffff88006f932000 0000000000000000 0000000000000000 ffff88004db12840
[   73.534307]  ffffc90004552040 0000000500000000 ffff8800500d4160 0000000002800000
[   73.534333]  ffff88004dbb9bf8 ffffffffa007e91c 0000000002800000 ffff880000000000
[   73.534358] Call Trace:
[   73.534370]  [<ffffffffa007e91c>] ? dm_split_args+0x5c/0x160 [dm_mod]
[   73.534390]  [<ffffffffa007ebbc>] dm_table_add_target+0x19c/0x450 [dm_mod]
[   73.534412]  [<ffffffffa0081b24>] table_load+0xe4/0x330 [dm_mod]
[   73.534431]  [<ffffffffa0081a40>] ? list_devices+0x190/0x190 [dm_mod]
[   73.534451]  [<ffffffffa00831a6>] ctl_ioctl+0x246/0x4d0 [dm_mod]
[   73.534471]  [<ffffffff81666900>] ? __do_page_fault+0x190/0x4f0
[   73.534489]  [<ffffffffa0083443>] dm_ctl_ioctl+0x13/0x20 [dm_mod]
[   73.534508]  [<ffffffff8116ca66>] do_vfs_ioctl+0x96/0x570
[   73.534526]  [<ffffffff81267eba>] ? inode_has_perm.isra.30.constprop.62+0x2a/0x30
[   73.534547]  [<ffffffff81269797>] ? file_has_perm+0x97/0xb0
[   73.534564]  [<ffffffff8116cfd1>] sys_ioctl+0x91/0xb0
[   73.534581]  [<ffffffff812c1d6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   73.534600]  [<ffffffff8166b342>] system_call_fastpath+0x16/0x1b
[   73.534617] Code: 41 8d 45 ff 75 e8 4c 89 ff e8 90 43 09 e1 e9 8d fa ff ff 0f 1f 00 48 8b 9d 78 ff ff ff 4c 8b a5 70 ff ff ff 8b 55 8c 48 8b 45 80 <4d> 89 bc 24 38 03 00 00 41 89 94 24 30 03 00 00
4c 89 60 40 e9
[   73.534762] RIP  [<ffffffffa00bf76d>] cache_ctr+0xb2d/0xc90 [dm_cache]
[   73.534783]  RSP <ffff88004dbb9b58>
[   73.534794] CR2: 0000000000000338
[   73.538947] ---[ end trace 86024887f593090b ]---

Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
---
 drivers/md/dm-cache-target.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 0f4e84b..6cfd43d 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2002,6 +2002,8 @@ static int cache_ctr(struct dm_target *ti, unsigned argc, char **argv)
         goto out;
 
     r = cache_create(ca, &cache);
+    if (r)
+        goto out;
 
     r = copy_ctr_args(cache, argc - 3, (const char **)argv + 3);
     if (r) {
-- 
1.8.2.rc2.4.g7799588
