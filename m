From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 09/25] dm: use is_power_of_2
Date: Fri, 12 Oct 2007 18:16:02 +0100
Message-ID: <20071012171602.GT24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1758643AbXJLRQc@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, vignesh babu <vignesh.babu@wipro.com>
List-Id: dm-devel.ids

From: vignesh babu <vignesh.babu@wipro.com>

Replacing n & (n - 1) for power of 2 check by is_power_of_2(n)

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c  |    3 ++-
 drivers/md/dm-snap.c   |    3 ++-
 drivers/md/dm-stripe.c |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.23/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-raid1.c	2007-10-12 13:15:32.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-raid1.c	2007-10-12 13:15:36.000000000 +0100
@@ -19,6 +19,7 @@
 #include <linux/time.h>
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
+#include <linux/log2.h>
 
 #define DM_MSG_PREFIX "raid1"
 #define DM_IO_PAGES 64
@@ -995,7 +996,7 @@ static void free_context(struct mirror_s
 
 static inline int _check_region_size(struct dm_target *ti, uint32_t size)
 {
-	return !(size % (PAGE_SIZE >> 9) || (size & (size - 1)) ||
+	return !(size % (PAGE_SIZE >> 9) || !is_power_of_2(size) ||
 		 size > ti->len);
 }
 
Index: linux-2.6.23/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-snap.c	2007-10-12 13:14:40.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-snap.c	2007-10-12 13:15:36.000000000 +0100
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
+#include <linux/log2.h>
 
 #include "dm-snap.h"
 #include "dm-bio-list.h"
@@ -415,7 +416,7 @@ static int set_chunk_size(struct dm_snap
 	chunk_size = round_up(chunk_size, PAGE_SIZE >> 9);
 
 	/* Check chunk_size is a power of 2 */
-	if (chunk_size & (chunk_size - 1)) {
+	if (!is_power_of_2(chunk_size)) {
 		*error = "Chunk size is not a power of 2";
 		return -EINVAL;
 	}
Index: linux-2.6.23/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-stripe.c	2007-10-12 12:36:14.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-stripe.c	2007-10-12 13:15:36.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/blkdev.h>
 #include <linux/bio.h>
 #include <linux/slab.h>
+#include <linux/log2.h>
 
 #define DM_MSG_PREFIX "striped"
 
@@ -99,7 +100,7 @@ static int stripe_ctr(struct dm_target *
 	/*
 	 * chunk_size is a power of two
 	 */
-	if (!chunk_size || (chunk_size & (chunk_size - 1)) ||
+	if (!is_power_of_2(chunk_size) ||
 	    (chunk_size < (PAGE_SIZE >> SECTOR_SHIFT))) {
 		ti->error = "Invalid chunk size";
 		return -EINVAL;
