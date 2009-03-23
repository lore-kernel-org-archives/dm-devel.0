From: Neil Brown <neilb@suse.de>
Subject: BUG/PATCH race between upgrade_mode and
	dm_table_any_congested
Date: Mon, 23 Mar 2009 17:00:36 +1100
Message-ID: <18887.9605.64321.547734@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids


Hi,
 A customer recently reported an Oops in dm_table_any_congested (in a
 2.6.16 based kernel) that was due to dd->bdev being NULL.
 so bdev_get_queue dereferenced that NULL and caused the oops.

 The only credible explanation for this that we can find is that
 upgrade_mode sets bdev to NULL temporarily, and does not have any
 locking to exclude anything from seeing that NULL.

 The code in current mainline is exactly the same so if we are correct
 in our assessment, then the bug is still present.

 The Oops has only occurred once and cannot be reproduced so we cannot
 be certain that this is the cause.  However if it really is a bug -
 and there is not something else which causes mutual exclusion of
 these two routines, then it should probably be fixed.

 Our current patch is below.  It is a big ugly, and a better fix might
 be a more thorough rewrite of the code.  However I offer it incase it
 is useful.

Thanks,
NeilBrown



Signed-off-By: NeilBrown <neilb@suse.de>
---
 drivers/md/dm-table.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.16-SLES10_SP2_BRANCH/drivers/md/dm-table.c
===================================================================
--- linux-2.6.16-SLES10_SP2_BRANCH.orig/drivers/md/dm-table.c	2009-03-20 11:03:14.000000000 +0530
+++ linux-2.6.16-SLES10_SP2_BRANCH/drivers/md/dm-table.c	2009-03-20 11:22:07.000000000 +0530
@@ -414,14 +414,14 @@ static int upgrade_mode(struct dm_dev *d
 
 	dd_copy = *dd;
 
-	dd->mode |= new_mode;
-	dd->bdev = NULL;
-	r = open_dev(dd, dev);
-	if (!r)
-		close_dev(&dd_copy);
-	else
+	dd_copy.mode |= new_mode;
+	dd_copy.bdev = NULL;
+	r = open_dev(&dd_copy, dev);
+	if (!r) {
+		struct dm_dev dd_copy2 = *dd;
 		*dd = dd_copy;
-
+		close_dev(&dd_copy2);
+	}
 	return r;
 }
 
