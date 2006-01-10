From: akpm@osdl.org
Subject: -
	md-dm-reduce-stack-usage-with-stacked-block-devices-fixes.patch
	removed from -mm tree
Date: Mon, 09 Jan 2006 18:30:42 -0800
Message-ID: <200601100230.k0A2Us1M005580@shell0.pdx.osdl.net>
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
To: akpm@osdl.org, axboe@suse.de, dm-devel@redhat.com, neilb@suse.de, mm-commits@vger.kernel.org
List-Id: dm-devel.ids


The patch titled

     md-dm-reduce-stack-usage-with-stacked-block-devices-fixes

has been removed from the -mm tree.  Its filename is

     md-dm-reduce-stack-usage-with-stacked-block-devices-fixes.patch

This patch was probably dropped from -mm because
it has already been merged into a subsystem tree
or into Linus's tree


From: Andrew Morton <akpm@osdl.org>

Cc: Neil Brown <neilb@suse.de>
Cc: Jens Axboe <axboe@suse.de>
Cc: <dm-devel@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 block/ll_rw_blk.c     |    6 +++---
 include/linux/sched.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN block/ll_rw_blk.c~md-dm-reduce-stack-usage-with-stacked-block-devices-fixes block/ll_rw_blk.c
--- devel/block/ll_rw_blk.c~md-dm-reduce-stack-usage-with-stacked-block-devices-fixes	2006-01-08 22:21:35.000000000 -0800
+++ devel-akpm/block/ll_rw_blk.c	2006-01-08 22:21:35.000000000 -0800
@@ -3086,7 +3086,7 @@ void generic_make_request(struct bio *bi
 		return;
 	}
 	/* following loop may be a bit non-obvious, and so deserves some
-	 * explantion.
+	 * explanation.
 	 * Before entering the loop, bio->bi_next is NULL (as all callers
 	 * ensure that) so we have a list with a single bio.
 	 * We pretend that we have just taken it off a longer list, so
@@ -3100,8 +3100,8 @@ void generic_make_request(struct bio *bi
 	 * bio_tail or bi_next, and call into __generic_make_request again.
 	 *
 	 * The loop was structured like this to make only one call to
-	 * __generic_make_request (which is important as it is large and inlined)
-	 * and to keep the structure simple.
+	 * __generic_make_request (which is important as it is large and
+	 * inlined) and to keep the structure simple.
 	 */
 	BUG_ON(bio->bi_next);
 	do {
diff -puN include/linux/sched.h~md-dm-reduce-stack-usage-with-stacked-block-devices-fixes include/linux/sched.h
--- devel/include/linux/sched.h~md-dm-reduce-stack-usage-with-stacked-block-devices-fixes	2006-01-08 22:21:35.000000000 -0800
+++ devel-akpm/include/linux/sched.h	2006-01-08 22:21:35.000000000 -0800
@@ -39,6 +39,7 @@
 #include <linux/auxvec.h>	/* For AT_VECTOR_SIZE */
 
 struct exec_domain;
+struct bio;
 
 /*
  * cloning flags:
_

Patches currently in -mm which might be from akpm@osdl.org are

linus.patch
remove-asm-serialh-from-synclink_gt.patch
ocfs-update-atime-borkage.patch
hrtimer-export-deinlined-mktime.patch
md-dm-reduce-stack-usage-with-stacked-block-devices.patch
md-dm-reduce-stack-usage-with-stacked-block-devices-fixes.patch
vfa-at-functions-core-sparc64-fix.patch
nr_blockdev_pages-in_interrupt-warning.patch
sysfs-crash-debugging.patch
device-suspend-debug.patch
tty-layer-buffering-revamp-jsm-is-broken.patch
tty-layer-buffering-revamp-pmac_zilog-warning-fix.patch
tty-layer-buffering-revamp-sunsab-build-fix.patch
isicom-pci-probing-added-fix-vs-gregkh-pci-pci-driver-owner-removal.patch
lindent-rio-drivers.patch
