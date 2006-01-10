From: akpm@osdl.org
Subject: [patch 1/1] md/dm: Reduce stack usage with stacked block
	devices
Date: Mon, 09 Jan 2006 18:31:10 -0800
Message-ID: <200601100231.k0A2VMYu005612@shell0.pdx.osdl.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: akpm@osdl.org, dm-devel@redhat.com, axboe@suse.de
List-Id: dm-devel.ids


From: Neil Brown <neilb@suse.de>

When stacked block devices are in-use (e.g.  md or dm), the recursive calls
to generic_make_request can use up a lot of space, and we would rather they
didn't.

As generic_make_request is a void function, and as it is generally not
expected that it will have any effect immediately, it is safe to delay any
call to generic_make_request until there is sufficient stack space
available.

As ->bi_next is reserved for the driver to use, it can have no valid value
when generic_make_request is called, and as __make_request implicitly
assumes it will be NULL (ELEVATOR_BACK_MERGE fork of switch) we can be
certain that all callers set it to NULL.  We can therefore safely use
bi_next to link pending requests together, providing we clear it before
making the real call.

So, we choose to allow each thread to only be active in one
generic_make_request at a time.  If a subsequent (recursive) call is made,
the bio is linked into a per-thread list, and is handled when the active
call completes.

As the list of pending bios is per-thread, there are no locking issues to
worry about.

I say above that it is "safe to delay any call...".  There are, however,
some behaviours of a make_request_fn which would make it unsafe.  These
include any behaviour that assumes anything will have changed after a
recursive call to generic_make_request.

These could include:
 - waiting for that call to finish and call it's bi_end_io function.
   md use to sometimes do this (marking the superblock dirty before
   completing a write) but doesn't any more
 - inspecting the bio for fields that generic_make_request might
   change, such as bi_sector or bi_bdev.  It is hard to see a good
   reason for this, and I don't think anyone actually does it.
 - inspecing the queue to see if, e.g. it is 'full' yet.  Again, I
   think this is very unlikely to be useful, or to be done.

Signed-off-by: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@suse.de>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 block/ll_rw_blk.c     |   53 +++++++++++++++++++++++++++++++++++++++-
 include/linux/sched.h |    4 +++
 2 files changed, 56 insertions(+), 1 deletion(-)

diff -puN block/ll_rw_blk.c~md-dm-reduce-stack-usage-with-stacked-block-devices block/ll_rw_blk.c
--- devel/block/ll_rw_blk.c~md-dm-reduce-stack-usage-with-stacked-block-devices	2006-01-09 18:30:39.000000000 -0800
+++ devel-akpm/block/ll_rw_blk.c	2006-01-09 18:30:42.000000000 -0800
@@ -2947,7 +2947,7 @@ static void handle_bad_sector(struct bio
  * bi_sector for remaps as it sees fit.  So the values of these fields
  * should NOT be depended on after the call to generic_make_request.
  */
-void generic_make_request(struct bio *bio)
+static inline void __generic_make_request(struct bio *bio)
 {
 	request_queue_t *q;
 	sector_t maxsector;
@@ -3014,6 +3014,57 @@ end_io:
 	} while (ret);
 }
 
+/*
+ * We only want one ->make_request_fn to be active at a time,
+ * else stack usage with stacked devices could be a problem.
+ * So use current->bio_{list,tail} to keep a list of requests
+ * submited by a make_request_fn function.
+ * current->bio_tail is also used as a flag to say if
+ * generic_make_request is currently active in this task or not.
+ * If it is NULL, then no make_request is active.  If it is non-NULL,
+ * then a make_request is active, and new requests should be added
+ * at the tail
+ */
+void generic_make_request(struct bio *bio)
+{
+	if (current->bio_tail) {
+		/* make_request is active */
+		*(current->bio_tail) = bio;
+		bio->bi_next = NULL;
+		current->bio_tail = &bio->bi_next;
+		return;
+	}
+	/* following loop may be a bit non-obvious, and so deserves some
+	 * explanation.
+	 * Before entering the loop, bio->bi_next is NULL (as all callers
+	 * ensure that) so we have a list with a single bio.
+	 * We pretend that we have just taken it off a longer list, so
+	 * we assign bio_list to the next (which is NULL) and bio_tail
+	 * to &bio_list, thus initialising the bio_list of new bios to be
+	 * added.  __generic_make_request may indeed add some more bios
+	 * through a recursive call to generic_make_request.  If it
+	 * did, we find a non-NULL value in bio_list and re-enter the loop
+	 * from the top.  In this case we really did just take the bio
+	 * of the top of the list (no pretending) and so fixup bio_list and
+	 * bio_tail or bi_next, and call into __generic_make_request again.
+	 *
+	 * The loop was structured like this to make only one call to
+	 * __generic_make_request (which is important as it is large and
+	 * inlined) and to keep the structure simple.
+	 */
+	BUG_ON(bio->bi_next);
+	do {
+		current->bio_list = bio->bi_next;
+		if (bio->bi_next == NULL)
+			current->bio_tail = &current->bio_list;
+		else
+			bio->bi_next = NULL;
+		__generic_make_request(bio);
+		bio = current->bio_list;
+	} while (bio);
+	current->bio_tail = NULL; /* deactivate */
+}
+
 EXPORT_SYMBOL(generic_make_request);
 
 /**
diff -puN include/linux/sched.h~md-dm-reduce-stack-usage-with-stacked-block-devices include/linux/sched.h
--- devel/include/linux/sched.h~md-dm-reduce-stack-usage-with-stacked-block-devices	2006-01-09 18:30:39.000000000 -0800
+++ devel-akpm/include/linux/sched.h	2006-01-09 18:30:42.000000000 -0800
@@ -39,6 +39,7 @@
 #include <linux/auxvec.h>	/* For AT_VECTOR_SIZE */
 
 struct exec_domain;
+struct bio;
 
 /*
  * cloning flags:
@@ -826,6 +827,9 @@ struct task_struct {
 /* journalling filesystem info */
 	void *journal_info;
 
+/* stacked block device info */
+	struct bio *bio_list, **bio_tail;
+
 /* VM state */
 	struct reclaim_state *reclaim_state;
 
_
