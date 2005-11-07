From: akpm@osdl.org
Subject: +
	md-dm-reduce-stack-usage-with-stacked-block-devices.patch
	added to -mm tree
Date: Mon,  7 Nov 2005 15:37:13 -0800
Message-ID: <200511072336.jA7Naqwe004894@shell0.pdx.osdl.net>
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
To: neilb@suse.de, axboe@suse.de, dm-devel@redhat.com, mm-commits@vger.kernel.org
List-Id: dm-devel.ids


The patch titled

     md/dm: Reduce stack usage with stacked block devices

has been added to the -mm tree.  Its filename is

     md-dm-reduce-stack-usage-with-stacked-block-devices.patch


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

 block/ll_rw_blk.c     |   53 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/sched.h |    3 ++
 2 files changed, 55 insertions(+), 1 deletion(-)

diff -puN block/ll_rw_blk.c~md-dm-reduce-stack-usage-with-stacked-block-devices block/ll_rw_blk.c
--- 25/block/ll_rw_blk.c~md-dm-reduce-stack-usage-with-stacked-block-devices	Mon Nov  7 15:30:31 2005
+++ 25-akpm/block/ll_rw_blk.c	Mon Nov  7 15:30:31 2005
@@ -2831,7 +2831,7 @@ static void handle_bad_sector(struct bio
  * bi_sector for remaps as it sees fit.  So the values of these fields
  * should NOT be depended on after the call to generic_make_request.
  */
-void generic_make_request(struct bio *bio)
+static inline void __generic_make_request(struct bio *bio)
 {
 	request_queue_t *q;
 	sector_t maxsector;
@@ -2898,6 +2898,57 @@ end_io:
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
+	 * explantion.
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
+	 * __generic_make_request (which is important as it is large and inlined)
+	 * and to keep the structure simple.
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
--- 25/include/linux/sched.h~md-dm-reduce-stack-usage-with-stacked-block-devices	Mon Nov  7 15:30:31 2005
+++ 25-akpm/include/linux/sched.h	Mon Nov  7 15:30:31 2005
@@ -836,6 +836,9 @@ struct task_struct {
 /* journalling filesystem info */
 	void *journal_info;
 
+/* stacked block device info */
+	struct bio *bio_list, **bio_tail;
+
 /* VM state */
 	struct reclaim_state *reclaim_state;
 
_

Patches currently in -mm which might be from neilb@suse.de are

linus.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
md-better-handling-of-readerrors-with-raid5.patch
md-initial-sysfs-support-for-md.patch
md-extend-md-sysfs-support-to-component-devices.patch
md-add-kobject-sysfs-support-to-raid5.patch
md-allow-a-manual-resync-with-md.patch
md-teach-raid5-the-difference-between-check-and-repair.patch
md-provide-proper-rcu_dereference--rcu_assign_pointer-annotations-in-md.patch
md-fix-ref-counting-problems-with-kobjects-in-md.patch
md-minor-md-fixes.patch
md-change-raid5-sysfs-attribute-to-not-create-a-new-directory.patch
md-improvements-to-raid5-handling-of-read-errors.patch
md-convert-faulty-and-in_sync-fields-to-bits-in-flags-field.patch
md-make-md-on-disk-bitmaps-not-host-endian.patch
md-support-bio_rw_barrier-for-md-raid1.patch
md-remove-attempt-to-use-dynamic-names-in-sysfs-for-component-devices-on-an-md-array.patch
md-allow-md-arrays-to-be-started-read-only-module-parameter.patch
md-make-sure-block-link-in-sys-md-goes-to-correct-devices.patch
md-make-manual-repair-work-for-raid1.patch
md-make-sure-a-user-request-sync-of-raid5-ignores-intent-bitmap.patch
md-fix-some-locking-and-module-refcounting-issues-with-mds-use-of-sysfs.patch
md-split-off-some-md-attributes-in-sysfs-to-a-separate-group.patch
md-only-try-to-print-recovery-resync-status-for-personalities-that-support-recovery.patch
md-ignore-auto-readonly-flag-for-arrays-where-it-isnt-meaningful.patch
md-complete-conversion-of-md-to-use-kthreads.patch
md-improve-scan_mode-and-rename-it-to-sync_action.patch
md-document-sysfs-usage-of-md-and-make-a-couple-of-small-refinements.patch
