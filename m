From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] dm-mpath: Fix a race condition
Date: Mon, 11 Dec 2017 16:26:24 -0800
Message-ID: <20171212002624.7747-1-bart.vanassche@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, stable@vger.kernel.org
List-Id: dm-devel.ids

Hold multipath.lock around all code that iterates over the
priority_groups list. This patch fixes the following crash:

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

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm-mpath.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c8faa2b85842..61def92f306a 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -237,10 +237,19 @@ static int alloc_multipath_stage2(struct dm_target *ti, struct multipath *m)
 
 static void free_multipath(struct multipath *m)
 {
-	struct priority_group *pg, *tmp;
+	struct priority_group *pg;
+	unsigned long flags;
+
+	while (true) {
+		spin_lock_irqsave(&m->lock, flags);
+		pg = list_first_entry_or_null(&m->priority_groups, typeof(*pg),
+					      list);
+		if (pg)
+			list_del(&pg->list);
+		spin_unlock_irqrestore(&m->lock, flags);
 
-	list_for_each_entry_safe(pg, tmp, &m->priority_groups, list) {
-		list_del(&pg->list);
+		if (!pg)
+			break;
 		free_priority_group(pg, m->ti);
 	}
 
@@ -337,6 +346,7 @@ static int pg_init_all_paths(struct multipath *m)
 }
 
 static void __switch_pg(struct multipath *m, struct priority_group *pg)
+	__must_hold(&m->lock)
 {
 	m->current_pg = pg;
 
@@ -355,8 +365,8 @@ static void __switch_pg(struct multipath *m, struct priority_group *pg)
 static struct pgpath *choose_path_in_pg(struct multipath *m,
 					struct priority_group *pg,
 					size_t nr_bytes)
+	__must_hold(&m->lock)
 {
-	unsigned long flags;
 	struct dm_path *path;
 	struct pgpath *pgpath;
 
@@ -368,10 +378,8 @@ static struct pgpath *choose_path_in_pg(struct multipath *m,
 
 	if (unlikely(READ_ONCE(m->current_pg) != pg)) {
 		/* Only update current_pgpath if pg changed */
-		spin_lock_irqsave(&m->lock, flags);
 		m->current_pgpath = pgpath;
 		__switch_pg(m, pg);
-		spin_unlock_irqrestore(&m->lock, flags);
 	}
 
 	return pgpath;
@@ -381,7 +389,7 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 {
 	unsigned long flags;
 	struct priority_group *pg;
-	struct pgpath *pgpath;
+	struct pgpath *pgpath, *res = NULL;
 	unsigned bypassed = 1;
 
 	if (!atomic_read(&m->nr_valid_paths)) {
@@ -419,6 +427,7 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 	 * Second time we only try the ones we skipped, but set
 	 * pg_init_delay_retry so we do not hammer controllers.
 	 */
+	spin_lock_irqsave(&m->lock, flags);
 	do {
 		list_for_each_entry(pg, &m->priority_groups, list) {
 			if (pg->bypassed == !!bypassed)
@@ -427,18 +436,22 @@ static struct pgpath *choose_pgpath(struct multipath *m, size_t nr_bytes)
 			if (!IS_ERR_OR_NULL(pgpath)) {
 				if (!bypassed)
 					set_bit(MPATHF_PG_INIT_DELAY_RETRY, &m->flags);
-				return pgpath;
+				res = pgpath;
+				break;
 			}
 		}
-	} while (bypassed--);
+	} while (!res && bypassed--);
+	spin_unlock_irqrestore(&m->lock, flags);
 
 failed:
 	spin_lock_irqsave(&m->lock, flags);
-	m->current_pgpath = NULL;
-	m->current_pg = NULL;
+	if (!res) {
+		m->current_pgpath = NULL;
+		m->current_pg = NULL;
+	}
 	spin_unlock_irqrestore(&m->lock, flags);
 
-	return NULL;
+	return res;
 }
 
 /*
@@ -1875,6 +1888,7 @@ static int multipath_busy(struct dm_target *ti)
 	struct multipath *m = ti->private;
 	struct priority_group *pg, *next_pg;
 	struct pgpath *pgpath;
+	unsigned long flags;
 
 	/* pg_init in progress */
 	if (atomic_read(&m->pg_init_in_progress))
@@ -1906,6 +1920,7 @@ static int multipath_busy(struct dm_target *ti)
 	 * will be able to select it. So we consider such a pg as not busy.
 	 */
 	busy = true;
+	spin_lock_irqsave(&m->lock, flags);
 	list_for_each_entry(pgpath, &pg->pgpaths, list) {
 		if (pgpath->is_active) {
 			has_active = true;
@@ -1915,6 +1930,7 @@ static int multipath_busy(struct dm_target *ti)
 			}
 		}
 	}
+	spin_unlock_irqrestore(&m->lock, flags);
 
 	if (!has_active) {
 		/*
-- 
2.15.1
