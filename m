From: Ryo Tsuruta <ryov@valinux.co.jp>
Subject: [PATCH 8/8] bio-cgroup: Dirty page tracking
Date: Wed, 24 Sep 2008 19:15:04 +0900 (JST)
Message-ID: <20080924.191504.59669845.ryov@valinux.co.jp>
References: <20080924.191338.112608181.ryov@valinux.co.jp>
	<20080924.191402.183039492.ryov@valinux.co.jp>
	<20080924.191432.39172089.ryov@valinux.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754355AbYIXKP1@vger.kernel.org>
In-Reply-To: <20080924.191432.39172089.ryov@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, dm-devel@redhat.com, containers@lists.linux-foundation.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xensource.com
Cc: agk@sourceware.org, balbir@linux.vnet.ibm.com, xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, fernando@oss.ntt.co.jp
List-Id: dm-devel.ids

This patch supports migrating pages between bio-cgroups with minimum overhead,

Based on 2.6.27-rc5-mm1
Signed-off-by: Ryo Tsuruta <ryov@valinux.co.jp>
Signed-off-by: Hirokazu Takahashi <taka@valinux.co.jp>

diff -Ndupr linux-2.6.27-rc5-mm1.cg3/fs/buffer.c linux-2.6.27-rc5-mm1.cg4/fs/buffer.c
--- linux-2.6.27-rc5-mm1.cg3/fs/buffer.c	2008-09-24 16:23:02.000000000 +0900
+++ linux-2.6.27-rc5-mm1.cg4/fs/buffer.c	2008-09-24 16:34:53.000000000 +0900
@@ -36,6 +36,7 @@
 #include <linux/buffer_head.h>
 #include <linux/task_io_accounting_ops.h>
 #include <linux/bio.h>
+#include <linux/biocontrol.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/bitops.h>
@@ -722,6 +723,7 @@ static int __set_page_dirty(struct page 
 			__inc_bdi_stat(mapping->backing_dev_info,
 					BDI_RECLAIMABLE);
 			task_io_account_write(PAGE_CACHE_SIZE);
+			bio_cgroup_recharge(page, current->mm);
 		}
 		radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
diff -Ndupr linux-2.6.27-rc5-mm1.cg3/include/linux/biocontrol.h linux-2.6.27-rc5-mm1.cg4/include/linux/biocontrol.h
--- linux-2.6.27-rc5-mm1.cg3/include/linux/biocontrol.h	2008-09-24 16:34:52.000000000 +0900
+++ linux-2.6.27-rc5-mm1.cg4/include/linux/biocontrol.h	2008-09-24 16:34:53.000000000 +0900
@@ -100,6 +100,8 @@ static inline struct bio_cgroup *mm_get_
 
 extern struct io_context *get_bio_cgroup_iocontext(struct bio *bio);
 
+extern void bio_cgroup_recharge(struct page *page, struct mm_struct *mm);
+
 #else	/* CONFIG_CGROUP_BIO */
 
 struct bio_cgroup;
@@ -154,6 +156,10 @@ static inline struct io_context *get_bio
 	return NULL;
 }
 
+static inline void bio_cgroup_recharge(struct page *page, struct mm_struct *mm)
+{
+}
+
 #endif	/* CONFIG_CGROUP_BIO */
 
 #endif /* _LINUX_BIOCONTROL_H */
diff -Ndupr linux-2.6.27-rc5-mm1.cg3/mm/biocontrol.c linux-2.6.27-rc5-mm1.cg4/mm/biocontrol.c
--- linux-2.6.27-rc5-mm1.cg3/mm/biocontrol.c	2008-09-24 16:34:52.000000000 +0900
+++ linux-2.6.27-rc5-mm1.cg4/mm/biocontrol.c	2008-09-24 16:34:53.000000000 +0900
@@ -217,3 +217,52 @@ struct cgroup_subsys bio_cgroup_subsys =
 	.attach		= bio_cgroup_move_task,
 	.early_init	= 0,
 };
+
+/*
+ * Change the owner of a given page.
+ */
+void bio_cgroup_recharge(struct page *page, struct mm_struct *mm)
+{
+	struct page_cgroup *pc;
+	struct bio_cgroup *biog;
+
+	if (bio_cgroup_disabled() || !mm)
+		return;
+	if (PageSwapCache(page) || PageAnon(page))
+		return;
+	/* Check if the owner should be changed without any lock. */
+	pc = page_get_page_cgroup(page);
+	if (unlikely(!pc))
+		return;
+	rcu_read_lock();
+	biog = bio_cgroup_from_task(rcu_dereference(mm->owner));
+	rcu_read_unlock();
+	/*
+	 * This won't cause any trouble even when the page_cgroup has been
+	 * released since its memory still exists where it was.
+	 */
+	if (biog == pc->bio_cgroup)
+		return;
+
+	/* Re-check if the owner should be changed with the lock. */
+	lock_page_cgroup(page);
+	pc = page_get_page_cgroup(page);
+	if (unlikely(!pc))
+		goto out;
+	rcu_read_lock();
+	biog = mm_get_bio_cgroup(mm);
+	rcu_read_unlock();
+	if (biog == pc->bio_cgroup) {
+		put_bio_cgroup(biog);
+		goto out;
+	}
+
+	/* Move the page into the bio_cgroup associating with "mm." */
+	bio_cgroup_remove_page(pc);
+	clear_bio_cgroup(pc);
+	set_bio_cgroup(pc, biog);
+	bio_cgroup_add_page(pc);
+out:
+	unlock_page_cgroup(page);
+}
+
diff -Ndupr linux-2.6.27-rc5-mm1.cg3/mm/page-writeback.c linux-2.6.27-rc5-mm1.cg4/mm/page-writeback.c
--- linux-2.6.27-rc5-mm1.cg3/mm/page-writeback.c	2008-09-24 16:23:03.000000000 +0900
+++ linux-2.6.27-rc5-mm1.cg4/mm/page-writeback.c	2008-09-24 16:34:53.000000000 +0900
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/backing-dev.h>
 #include <linux/task_io_accounting_ops.h>
+#include <linux/biocontrol.h>
 #include <linux/blkdev.h>
 #include <linux/mpage.h>
 #include <linux/rmap.h>
@@ -1094,6 +1095,7 @@ int __set_page_dirty_nobuffers(struct pa
 				__inc_bdi_stat(mapping->backing_dev_info,
 						BDI_RECLAIMABLE);
 				task_io_account_write(PAGE_CACHE_SIZE);
+				bio_cgroup_recharge(page, current->mm);
 			}
 			radix_tree_tag_set(&mapping->page_tree,
 				page_index(page), PAGECACHE_TAG_DIRTY);
