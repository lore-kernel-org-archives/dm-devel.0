From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] dm: Fix a recently introduced reference counting bug
Date: Wed, 13 Dec 2017 13:46:18 -0800
Message-ID: <20171213214618.21767-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Bart Van Assche <bart.vanassche@wdc.com>, Elena Reshetova <elena.reshetova@intel.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>, Hans Liljestrand <ishkamiel@gmail.com>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

This patch avoids that the following message occurs sporadically
in the system log (revealing that pgpath->path.dev->name became
a dangling pointer):

device-mapper: table: 254:2: device kkkkkkkkkkkkkkkkkkk?????????x0?a?????E??????????????E??????F?????2?????pF??????PF?????9[F??????]F???????#???????#??????'f????? not in table devices list

This patch also fixes the following kernel crash:

general protection fault: 0000 [#1] PREEMPT SMP
RIP: 0010:multipath_busy+0x77/0xd0 [dm_multipath]
Call Trace:
 dm_mq_queue_rq+0x44/0x110 [dm_mod]
 blk_mq_dispatch_rq_list+0x73/0x440
 blk_mq_do_dispatch_sched+0x60/0xe0
 blk_mq_sched_dispatch_requests+0x11a/0x1a0
 __blk_mq_run_hw_queue+0x11f/0x1c0
 __blk_mq_delay_run_hw_queue+0x95/0xe0
 blk_mq_run_hw_queue+0x25/0x80
 blk_mq_flush_plug_list+0x197/0x420
 blk_flush_plug_list+0xe4/0x270
 blk_finish_plug+0x27/0x40
 __do_page_cache_readahead+0x2b4/0x370
 force_page_cache_readahead+0xb4/0x110
 generic_file_read_iter+0x755/0x970
 __vfs_read+0xd2/0x140
 vfs_read+0x9b/0x140
 SyS_read+0x45/0xa0
 do_syscall_64+0x56/0x1a0
 entry_SYSCALL64_slow_path+0x25/0x25

From the disassembly of multipath_busy (0x77 = 119):

./include/linux/blkdev.h:
992             return bdev->bd_disk->queue;    /* this is never NULL */
   0x00000000000006b4 <+116>:   mov    (%rax),%rax
   0x00000000000006b7 <+119>:   mov    0xe0(%rax),%rax

Fixes: commit 2a0b4682e09d ("dm: convert dm_dev_internal.count from atomic_t to refcount_t")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dwindsor@gmail.com>
Cc: Hans Liljestrand <ishkamiel@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: stable@vger.kernel.org # v4.15
---
 drivers/md/dm-table.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 88130b5d95f9..ee5c389e7256 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -459,6 +459,8 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		if (r)
 			return r;
 		refcount_inc(&dd->count);
+	} else {
+		refcount_inc(&dd->count);
 	}
 
 	*result = dd->dm_dev;
-- 
2.15.1
