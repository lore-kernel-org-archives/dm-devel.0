From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 09/10] dm-integrity: handle machine reboot in
	bitmap mode
Date: Mon, 29 Apr 2019 14:57:25 +0200
Message-ID: <20190429125747.302611800@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-bitmap-reboot.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

When we are in bitmap mode, we need to clear the bitmap when we are
rebooting. This patch adds the reboot hook.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-27 10:28:35.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-04-27 10:28:35.000000000 +0200
@@ -15,6 +15,7 @@
 #include <linux/rbtree.h>
 #include <linux/delay.h>
 #include <linux/random.h>
+#include <linux/reboot.h>
 #include <crypto/hash.h>
 #include <crypto/skcipher.h>
 #include <linux/async_tx.h>
@@ -257,6 +258,8 @@ struct dm_integrity_c {
 	struct alg_spec journal_mac_alg;
 
 	atomic64_t number_of_mismatches;
+
+	struct notifier_block reboot_notifier;
 };
 
 struct dm_integrity_range {
@@ -2717,11 +2720,27 @@ clear_journal:
 		init_journal_node(&ic->journal_tree[i]);
 }
 
+static int dm_integrity_reboot(struct notifier_block *n, unsigned long code, void *x)
+{
+	struct dm_integrity_c *ic = container_of(n, struct dm_integrity_c, reboot_notifier);
+
+	if (ic->mode == 'B') {
+		DEBUG_print("dm_integrity_reboot\n");
+		cancel_delayed_work_sync(&ic->bitmap_flush_work);
+		queue_delayed_work(ic->commit_wq, &ic->bitmap_flush_work, 0);
+		flush_workqueue(ic->commit_wq);
+	}
+
+	return NOTIFY_DONE;
+}
+
 static void dm_integrity_postsuspend(struct dm_target *ti)
 {
 	struct dm_integrity_c *ic = (struct dm_integrity_c *)ti->private;
 	int r;
 
+	WARN_ON(unregister_reboot_notifier(&ic->reboot_notifier));
+
 	del_timer_sync(&ic->autocommit_timer);
 
 	WRITE_ONCE(ic->suspending, 1);
@@ -2829,6 +2848,11 @@ static void dm_integrity_resume(struct d
 			recalc_write_super(ic);
 		}
 	}
+
+	ic->reboot_notifier.notifier_call = dm_integrity_reboot;
+	ic->reboot_notifier.next = NULL;
+	ic->reboot_notifier.priority = INT_MAX - 1;	/* be notified after md and before hardware drivers */
+	WARN_ON(register_reboot_notifier(&ic->reboot_notifier));
 }
 
 static void dm_integrity_status(struct dm_target *ti, status_type_t type,
