From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: [RFC PATCH dm-ioband] Added in blktrace msgs for dm-ioband
Date: Fri, 24 Apr 2009 17:47:37 -0400
Message-ID: <49F23379.4010607@hp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070500080301040709040703"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758259AbZDXVsA@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ryov@valinux.co.jp
Cc: dm-devel@redhat.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070500080301040709040703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Ryo -

I don't know if you are taking in patches, but whilst trying to uncover
some odd behavior I added some blktrace messages to dm-ioband-ctl.c. If
you're keeping one code base for old stuff (2.6.18-ish RHEL stuff) and
upstream you'll have to #if around these (the blktrace message stuff
came in around 2.6.26 or 27 I think).

My test case was to take a single 400GB storage device, put two 200GB
partitions on it and then see what the "penalty" or overhead for adding
dm-ioband on top. To do this I simply created an ext2 FS on each
partition in parallel (two processes each doing a mkfs to one of the
partitions). Then I put two dm-ioband devices on top of the two
partitions (setting the weight to 100 in both cases - thus they should
have equal access).

Using default values I was seeing /very/ large differences - on the
order of 3X. When I bumped the number of tokens to a large number
(10,240) the timings got much closer (<2%). I have found that using
weight-iosize performs worse than weight (closer to 5% penalty).

I'll try to formalize these results as I go forward and report out on
them. In any event, I thought I'd share this patch with you if you are
interested...

Here's a sampling from some blktrace output (sorry for the wrapping) - I
should note that I'm a bit scared to see such large numbers of holds
going on when the token count should be >5,000 for each device...
Holding these back in an equal access situation is inhibiting the block
I/O layer to merge (most) of these (as mkfs performs lots & lots of
small but sequential I/Os).

...
  8,80  16        0     0.090651446     0  m   N ioband 1 hold_nrm 1654
  8,80  16        0     0.090653575     0  m   N ioband 1 hold_nrm 1655
  8,80  16        0     0.090655694     0  m   N ioband 1 hold_nrm 1656
  8,80  16        0     0.090657609     0  m   N ioband 1 hold_nrm 1657
  8,80  16        0     0.090659554     0  m   N ioband 1 hold_nrm 1658
  8,80  16        0     0.090661327     0  m   N ioband 1 hold_nrm 1659
  8,80  16        0     0.090666237     0  m   N ioband 1 hold_nrm 1660
  8,80  16    53036     0.090675081  4713  C   W 391420657 + 1024 [0]
  8,80  16    53037     0.090913365  4713  D   W 392995569 + 1024
[mkfs.ext2]
  8,80  16        0     0.090950380     0  m   N ioband 1 add_iss 1659 1659
  8,80  16        0     0.090951296     0  m   N ioband 1 add_iss 1658 1658
  8,80  16        0     0.090951870     0  m   N ioband 1 add_iss 1657 1657
  8,80  16        0     0.090952416     0  m   N ioband 1 add_iss 1656 1656
  8,80  16        0     0.090952965     0  m   N ioband 1 add_iss 1655 1655
  8,80  16        0     0.090953517     0  m   N ioband 1 add_iss 1654 1654
  8,80  16        0     0.090954064     0  m   N ioband 1 add_iss 1653 1653
  8,80  16        0     0.090954610     0  m   N ioband 1 add_iss 1652 1652
  8,80  16        0     0.090955280     0  m   N ioband 1 add_iss 1651 1651
  8,80  16        0     0.090956495     0  m   N ioband 1 pop_iss
  8,80  16    53038     0.090957387  4659  A  WS 396655745 + 8 <- (8,82)
6030744
  8,80  16    53039     0.090957561  4659  Q  WS 396655745 + 8 [kioband/16]
  8,80  16    53040     0.090958328  4659  M  WS 396655745 + 8 [kioband/16]
  8,80  16        0     0.090959595     0  m   N ioband 1 pop_iss
  8,80  16    53041     0.090959754  4659  A  WS 396655753 + 8 <- (8,82)
6030752
  8,80  16    53042     0.090960007  4659  Q  WS 396655753 + 8 [kioband/16]
  8,80  16    53043     0.090960402  4659  M  WS 396655753 + 8 [kioband/16]
  8,80  16        0     0.090960962     0  m   N ioband 1 pop_iss
  8,80  16    53044     0.090961104  4659  A  WS 396655761 + 8 <- (8,82)
6030760
  8,80  16    53045     0.090961231  4659  Q  WS 396655761 + 8 [kioband/16]
  8,80  16    53046     0.090961496  4659  M  WS 396655761 + 8 [kioband/16]
  8,80  16        0     0.090961995     0  m   N ioband 1 pop_iss
  8,80  16    53047     0.090962117  4659  A  WS 396655769 + 8 <- (8,82)
6030768
  8,80  16    53048     0.090962222  4659  Q  WS 396655769 + 8 [kioband/16]
  8,80  16    53049     0.090962530  4659  M  WS 396655769 + 8 [kioband/16]
  8,80  16        0     0.090962974     0  m   N ioband 1 pop_iss
  8,80  16    53050     0.090963095  4659  A  WS 396655777 + 8 <- (8,82)
6030776
  8,80  16    53051     0.090963334  4659  Q  WS 396655777 + 8 [kioband/16]
  8,80  16    53052     0.090963518  4659  M  WS 396655777 + 8 [kioband/16]
  8,80  16        0     0.090963985     0  m   N ioband 1 pop_iss
  8,80  16    53053     0.090964220  4659  A  WS 396655785 + 8 <- (8,82)
6030784
  8,80  16    53054     0.090964327  4659  Q  WS 396655785 + 8 [kioband/16]
  8,80  16    53055     0.090964632  4659  M  WS 396655785 + 8 [kioband/16]
  8,80  16        0     0.090965094     0  m   N ioband 1 pop_iss
  8,80  16    53056     0.090965218  4659  A  WS 396655793 + 8 <- (8,82)
6030792
  8,80  16    53057     0.090965324  4659  Q  WS 396655793 + 8 [kioband/16]
  8,80  16    53058     0.090965548  4659  M  WS 396655793 + 8 [kioband/16]
  8,80  16        0     0.090965991     0  m   N ioband 1 pop_iss
  8,80  16    53059     0.090966112  4659  A  WS 396655801 + 8 <- (8,82)
6030800
  8,80  16    53060     0.090966221  4659  Q  WS 396655801 + 8 [kioband/16]
  8,80  16    53061     0.090966526  4659  M  WS 396655801 + 8 [kioband/16]
  8,80  16        0     0.090966944     0  m   N ioband 1 pop_iss
  8,80  16    53062     0.090967065  4659  A  WS 396655809 + 8 <- (8,82)
6030808
  8,80  16    53063     0.090967173  4659  Q  WS 396655809 + 8 [kioband/16]
  8,80  16    53064     0.090967383  4659  M  WS 396655809 + 8 [kioband/16]
  8,80  16        0     0.090968394     0  m   N ioband 1 add_iss 1650 1650
  8,80  16        0     0.090969068     0  m   N ioband 1 add_iss 1649 1649
  8,80  16        0     0.090969684     0  m   N ioband 1 add_iss 1648 1648
...

Regards,
Alan D. Brunelle
Hewlett-Packard

--------------070500080301040709040703
Content-Type: text/x-diff;
 name="0001-Added-in-blktrace-msgs-for-dm-ioband.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Added-in-blktrace-msgs-for-dm-ioband.patch"

From bd918c40d92e4f074763a88bc8f13593c4f2dc52 Mon Sep 17 00:00:00 2001
From: Alan D. Brunelle <alan.brunelle@hp.com>
Date: Fri, 24 Apr 2009 17:30:32 -0400
Subject: [PATCH] Added in blktrace msgs for dm-ioband

Added the following messages:

In hold_bio - added messages as they are being added to either the
urgent or normal hold lists.

  ioband <g_name> hold_urg <g_blocked>
  ioband <g_name> hold_nrm <g_blocked>

In make_issue_list - added messages when placing previously held bios
onto either the pushback or issue lists:

  ioband <g_name> add_pback <g_blocked> <c_blocked>
  ioband <g_name> add_iss <g_blocked> <c_blocked>

In release_urgent bios - added a message indicating that an urgent bio
was added to the issue list:

  ioband <g_name> urg_add_iss> <g_blocked>

In ioband_conduct - added messages as bios are being popped and executed
(sent to generic_make_request) or pushed back (bio_endio):

  ioband <g_name> pop_iss
  ioband <g_name> pop_pback

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
---
 drivers/md/dm-ioband-ctl.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-ioband-ctl.c b/drivers/md/dm-ioband-ctl.c
index 29bef11..26ad7a5 100644
--- a/drivers/md/dm-ioband-ctl.c
+++ b/drivers/md/dm-ioband-ctl.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/rbtree.h>
+#include <linux/blktrace_api.h>
 #include "dm.h"
 #include "md.h"
 #include "dm-bio-list.h"
@@ -633,9 +634,15 @@ static void hold_bio(struct ioband_group *gp, struct bio *bio)
 		 */
 		dp->g_prepare_bio(gp, bio, IOBAND_URGENT);
 		bio_list_add(&dp->g_urgent_bios, bio);
+		blk_add_trace_msg(bdev_get_queue(bio->bi_bdev),
+				  "ioband %s hold_urg %d", dp->g_name,
+				  dp->g_blocked);
 	} else {
 		gp->c_blocked++;
 		dp->g_hold_bio(gp, bio);
+		blk_add_trace_msg(bdev_get_queue(bio->bi_bdev),
+				  "ioband %s hold_nrm %d", dp->g_name,
+				  gp->c_blocked);
 	}
 }
 
@@ -676,14 +683,21 @@ static int make_issue_list(struct ioband_group *gp, struct bio *bio,
 		clear_group_blocked(gp);
 		wake_up_all(&gp->c_waitq);
 	}
-	if (should_pushback_bio(gp))
+	if (should_pushback_bio(gp)) {
 		bio_list_add(pushback_list, bio);
+		blk_add_trace_msg(bdev_get_queue(bio->bi_bdev),
+				  "ioband %s add_pback %d %d", dp->g_name,
+				  dp->g_blocked, gp->c_blocked);
+	}
 	else {
 		int rw = bio_data_dir(bio);
 
 		gp->c_stat[rw].deferred++;
 		gp->c_stat[rw].sectors += bio_sectors(bio);
 		bio_list_add(issue_list, bio);
+		blk_add_trace_msg(bdev_get_queue(bio->bi_bdev),
+				  "ioband %s add_iss %d %d", dp->g_name,
+				  dp->g_blocked, gp->c_blocked);
 	}
 	return prepare_to_issue(gp, bio);
 }
@@ -703,6 +717,9 @@ static void release_urgent_bios(struct ioband_device *dp,
 		dp->g_blocked--;
 		dp->g_issued[bio_data_dir(bio)]++;
 		bio_list_add(issue_list, bio);
+		blk_add_trace_msg(bdev_get_queue(bio->bi_bdev),
+				  "ioband %s urg_add_iss %d", dp->g_name,
+				  dp->g_blocked);
 	}
 }
 
@@ -916,10 +933,17 @@ static void ioband_conduct(struct work_struct *work)
 
 	spin_unlock_irqrestore(&dp->g_lock, flags);
 
-	while ((bio = bio_list_pop(&issue_list)))
+	while ((bio = bio_list_pop(&issue_list))) {
+		blk_add_trace_msg(bdev_get_queue(bio->bi_bdev),
+				  "ioband %s pop_iss", dp->g_name);
 		generic_make_request(bio);
-	while ((bio = bio_list_pop(&pushback_list)))
+	}
+
+	while ((bio = bio_list_pop(&pushback_list))) {
+		blk_add_trace_msg(bdev_get_queue(bio->bi_bdev),
+				  "ioband %s pop_pback", dp->g_name);
 		bio_endio(bio, -EIO);
+	}
 }
 
 static int ioband_end_io(struct dm_target *ti, struct bio *bio,
-- 
1.5.6.3


--------------070500080301040709040703--
