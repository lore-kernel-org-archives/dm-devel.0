From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm mpath: Add timeout mechanism for
	queue_if_no_path
Date: Tue, 14 Jan 2020 11:15:05 -0500
Message-ID: <20200114161505.GA48507@lobo>
References: <20200113224127.3367484-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200113224127.3367484-1-krisman@collabora.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: dm-devel@redhat.com, kernel@collabora.com, khazhy@google.com
List-Id: dm-devel.ids

On Mon, Jan 13 2020 at  5:41P -0500,
Gabriel Krisman Bertazi <krisman@collabora.com> wrote:

> From: Anatol Pomazau <anatol@google.com>
> 
> Add a configurable timeout mechanism to disable queue_if_no_path without
> assistance from multipathd.  In reality, this reimplements the
> no_path_retry mechanism from multipathd in kernel space, which is
> interesting to prevent processes from hanging indefinitely in cases
> where the daemon might be unable to respond, after a failure or for
> whatever reason.
> 
> Despite replicating the policy configuration on kernel space, it is
> quite an important case to prevent IOs from hanging forever, waiting for
> userspace to behave correctly.
> 
> v2:
>   - Use a module parameter instead of configuring per table
>   - Simplify code
> 
> Co-developed-by: Frank Mayhar <fmayhar@google.com>
> Signed-off-by: Frank Mayhar <fmayhar@google.com>
> Co-developed-by: Bharath Ravi <rbharath@google.com>
> Signed-off-by: Bharath Ravi <rbharath@google.com>
> Co-developed-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
> Signed-off-by: Anatol Pomazau <anatol@google.com>
> Co-developed-by: Gabriel Krisman Bertazi <krisman@collabora.com>
> Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>

All these tags seem rather excessive (especially in that you aren't cc
most of them on the submission).  Please review/scrub.  Just seems odd
that so many had a hand in this relatively small patch.

The Signed-off-by for anatol@google.com seems wrong, or did Anatol
shephard this patch at some point?  Or did you mean Reviewed-by?
Something else?

Anyway, if in the end you hold these tags to reflect the development
evolution of this patch then so be it ;)

I've reviewed the changes and found various things I felt were
worthwhile to modify.  Summary:

- included missing <linux/timer.h>
- added MODULE_PARM_DESC
- moved new functions to reduce needed forward declarations
- tweaked queue_if_no_path_timeout_work's DMWARN message
- added lockdep_assert_held to enable_nopath_timeout
- renamed static queue_if_no_path_timeout to queue_if_no_path_timeout_secs
- use READ_ONCE when accessing queue_if_no_path_timeout_secs

Think that was it.

Please review/apply//test and if you're OK with the end result I'll
get it staged for 5.6 inclusion.

Thanks,
Mike


diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index b09e3f925f47..2bc18c9c3abc 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -20,6 +20,7 @@
 #include <linux/pagemap.h>
 #include <linux/slab.h>
 #include <linux/time.h>
+#include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <scsi/scsi_dh.h>
@@ -31,6 +32,8 @@
 #define DM_PG_INIT_DELAY_DEFAULT ((unsigned) -1)
 #define QUEUE_IF_NO_PATH_TIMEOUT_DEFAULT 0
 
+static unsigned long queue_if_no_path_timeout_secs = QUEUE_IF_NO_PATH_TIMEOUT_DEFAULT;
+
 /* Path properties */
 struct pgpath {
 	struct list_head list;
@@ -104,10 +107,6 @@ struct dm_mpath_io {
 	size_t nr_bytes;
 };
 
-static unsigned long queue_if_no_path_timeout = QUEUE_IF_NO_PATH_TIMEOUT_DEFAULT;
-module_param_named(queue_if_no_path_timeout_secs,
-                  queue_if_no_path_timeout, ulong, 0644);
-
 typedef int (*action_fn) (struct pgpath *pgpath);
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
@@ -115,10 +114,7 @@ static void trigger_event(struct work_struct *work);
 static void activate_or_offline_path(struct pgpath *pgpath);
 static void activate_path_work(struct work_struct *work);
 static void process_queued_bios(struct work_struct *work);
-
 static void queue_if_no_path_timeout_work(struct timer_list *t);
-static void enable_nopath_timeout(struct multipath *m);
-static void disable_nopath_timeout(struct multipath *m);
 
 /*-----------------------------------------------
  * Multipath state flags.
@@ -730,6 +726,43 @@ static int queue_if_no_path(struct multipath *m, bool queue_if_no_path,
 	return 0;
 }
 
+/*
+ * If the queue_if_no_path timeout fires, turn off queue_if_no_path and
+ * process any queued I/O.
+ */
+static void queue_if_no_path_timeout_work(struct timer_list *t)
+{
+	struct multipath *m = from_timer(m, t, nopath_timer);
+	struct mapped_device *md = dm_table_get_md(m->ti->table);
+
+	DMWARN("queue_if_no_path timeout on %s, failing queued IO", dm_device_name(md));
+	queue_if_no_path(m, false, false);
+}
+
+/*
+ * Enable the queue_if_no_path timeout if necessary.
+ * Called with m->lock held.
+ */
+static void enable_nopath_timeout(struct multipath *m)
+{
+	unsigned long queue_if_no_path_timeout =
+		READ_ONCE(queue_if_no_path_timeout_secs) * HZ;
+
+	lockdep_assert_held(&m->lock);
+
+	if (queue_if_no_path_timeout > 0 &&
+	    atomic_read(&m->nr_valid_paths) == 0 &&
+	    test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
+		mod_timer(&m->nopath_timer,
+			  jiffies + queue_if_no_path_timeout);
+	}
+}
+
+static void disable_nopath_timeout(struct multipath *m)
+{
+	del_timer_sync(&m->nopath_timer);
+}
+
 /*
  * An event is triggered whenever a path is taken out of use.
  * Includes path failure and PG bypass.
@@ -1231,20 +1264,6 @@ static void multipath_dtr(struct dm_target *ti)
 	free_multipath(m);
 }
 
-/*
- * If the queue_if_no_path timeout fires, turn off queue_if_no_path and
- * process any queued I/O.
- */
-static void queue_if_no_path_timeout_work(struct timer_list *t)
-{
-	struct multipath *m = from_timer(m, t, nopath_timer);
-	struct mapped_device *md = dm_table_get_md((m)->ti->table);
-
-	DMWARN("queue_if_no_path timeout on %s", dm_device_name(md));
-
-	queue_if_no_path(m, false, false);
-}
-
 /*
  * Take a path out of use.
  */
@@ -1352,25 +1371,6 @@ static int action_dev(struct multipath *m, struct dm_dev *dev,
 	return r;
 }
 
-/*
- * Enable the queue_if_no_path timeout if necessary.  Called with m->lock
- * held.
- */
-static void enable_nopath_timeout(struct multipath *m)
-{
-	if (queue_if_no_path_timeout > 0 &&
-	    atomic_read(&m->nr_valid_paths) == 0 &&
-	    test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags)) {
-		mod_timer(&m->nopath_timer,
-			  jiffies + queue_if_no_path_timeout * HZ);
-	}
-}
-
-static void disable_nopath_timeout(struct multipath *m)
-{
-	del_timer_sync(&m->nopath_timer);
-}
-
 /*
  * Temporarily try to avoid having to use the specified PG
  */
@@ -2127,6 +2127,10 @@ static void __exit dm_multipath_exit(void)
 module_init(dm_multipath_init);
 module_exit(dm_multipath_exit);
 
+module_param_named(queue_if_no_path_timeout_secs,
+		   queue_if_no_path_timeout_secs, ulong, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(queue_if_no_path_timeout_secs, "No available paths queue IO timeout in seconds");
+
 MODULE_DESCRIPTION(DM_NAME " multipath target");
 MODULE_AUTHOR("Sistina Software <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
