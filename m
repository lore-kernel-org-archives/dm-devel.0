From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 10/25] dm: use kzalloc
Date: Fri, 12 Oct 2007 18:16:28 +0100
Message-ID: <20071012171628.GU24157@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762370AbXJLRQx@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, Dmitry Monakhov <dmonakhov@openvz.org>
List-Id: dm-devel.ids

From: Dmitry Monakhov <dmonakhov@openvz.org>

Convert kmalloc() + memset() to kzalloc().

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-emc.c           |    6 ++----
 drivers/md/dm-hw-handler.c    |    6 ++----
 drivers/md/dm-path-selector.c |    6 ++----
 drivers/md/dm-table.c         |    3 +--
 drivers/md/dm-target.c        |    6 ++----
 5 files changed, 9 insertions(+), 18 deletions(-)

Index: linux-2.6.23/drivers/md/dm-emc.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-emc.c	2007-10-12 13:14:40.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-emc.c	2007-10-12 13:15:40.000000000 +0100
@@ -213,12 +213,10 @@ fail_path:
 
 static struct emc_handler *alloc_emc_handler(void)
 {
-	struct emc_handler *h = kmalloc(sizeof(*h), GFP_KERNEL);
+	struct emc_handler *h = kzalloc(sizeof(*h), GFP_KERNEL);
 
-	if (h) {
-		memset(h, 0, sizeof(*h));
+	if (h)
 		spin_lock_init(&h->lock);
-	}
 
 	return h;
 }
Index: linux-2.6.23/drivers/md/dm-hw-handler.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-hw-handler.c	2007-10-12 12:36:14.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-hw-handler.c	2007-10-12 13:15:40.000000000 +0100
@@ -91,12 +91,10 @@ void dm_put_hw_handler(struct hw_handler
 
 static struct hwh_internal *_alloc_hw_handler(struct hw_handler_type *hwht)
 {
-	struct hwh_internal *hwhi = kmalloc(sizeof(*hwhi), GFP_KERNEL);
+	struct hwh_internal *hwhi = kzalloc(sizeof(*hwhi), GFP_KERNEL);
 
-	if (hwhi) {
-		memset(hwhi, 0, sizeof(*hwhi));
+	if (hwhi)
 		hwhi->hwht = *hwht;
-	}
 
 	return hwhi;
 }
Index: linux-2.6.23/drivers/md/dm-path-selector.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-path-selector.c	2007-10-12 12:36:14.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-path-selector.c	2007-10-12 13:15:40.000000000 +0100
@@ -94,12 +94,10 @@ out:
 
 static struct ps_internal *_alloc_path_selector(struct path_selector_type *pst)
 {
-	struct ps_internal *psi = kmalloc(sizeof(*psi), GFP_KERNEL);
+	struct ps_internal *psi = kzalloc(sizeof(*psi), GFP_KERNEL);
 
-	if (psi) {
-		memset(psi, 0, sizeof(*psi));
+	if (psi)
 		psi->pst = *pst;
-	}
 
 	return psi;
 }
Index: linux-2.6.23/drivers/md/dm-table.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-table.c	2007-10-12 12:36:14.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-table.c	2007-10-12 13:15:40.000000000 +0100
@@ -213,12 +213,11 @@ static int alloc_targets(struct dm_table
 int dm_table_create(struct dm_table **result, int mode,
 		    unsigned num_targets, struct mapped_device *md)
 {
-	struct dm_table *t = kmalloc(sizeof(*t), GFP_KERNEL);
+	struct dm_table *t = kzalloc(sizeof(*t), GFP_KERNEL);
 
 	if (!t)
 		return -ENOMEM;
 
-	memset(t, 0, sizeof(*t));
 	INIT_LIST_HEAD(&t->devices);
 	atomic_set(&t->holders, 1);
 
Index: linux-2.6.23/drivers/md/dm-target.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-target.c	2007-10-12 12:36:14.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-target.c	2007-10-12 13:15:40.000000000 +0100
@@ -88,12 +88,10 @@ void dm_put_target_type(struct target_ty
 
 static struct tt_internal *alloc_target(struct target_type *t)
 {
-	struct tt_internal *ti = kmalloc(sizeof(*ti), GFP_KERNEL);
+	struct tt_internal *ti = kzalloc(sizeof(*ti), GFP_KERNEL);
 
-	if (ti) {
-		memset(ti, 0, sizeof(*ti));
+	if (ti)
 		ti->tt = *t;
-	}
 
 	return ti;
 }
