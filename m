From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: BUG/PATCH race between upgrade_mode and
	dm_table_any_congested
Date: Fri, 27 Mar 2009 17:28:48 +0000
Message-ID: <20090327172848.GT13664@agk.fab.redhat.com>
References: <18887.9605.64321.547734@notabene.brown>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <18887.9605.64321.547734@notabene.brown>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Neil Brown <neilb@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 23, 2009 at 05:00:36PM +1100, Neil Brown wrote:
>  The code in current mainline is exactly the same so if we are correct
>  in our assessment, then the bug is still present.
 
>  Our current patch is below.  It is a big ugly, and a better fix might
>  be a more thorough rewrite of the code.  However I offer it incase it
>  is useful.

Indeed this area of code is in need of a clean up.
 
Here's an alternative version trying additionally to avoid the theoretical risk
from overwriting the field with the same value.

Alasdair


From: Alasdair G Kergon <agk@redhat.com>

upgrade_mode() sets bdev to NULL temporarily, and does not have any
locking to exclude anything from seeing that NULL.

In dm_table_any_congested() bdev_get_queue() can dereference that NULL and
cause a reported oops.

Fix this by not changing that field during the mode upgrade.

Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-table.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

Index: linux-2.6.29/drivers/md/dm-table.c
===================================================================
--- linux-2.6.29.orig/drivers/md/dm-table.c
+++ linux-2.6.29/drivers/md/dm-table.c
@@ -399,28 +399,30 @@ static int check_device_area(struct dm_d
 }
 
 /*
- * This upgrades the mode on an already open dm_dev.  Being
+ * This upgrades the mode on an already open dm_dev, being
  * careful to leave things as they were if we fail to reopen the
- * device.
+ * device and not to touch the existing bdev field in case
+ * it is accessed concurrently inside dm_table_any_congested().
  */
 static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
 			struct mapped_device *md)
 {
 	int r;
-	struct dm_dev_internal dd_copy;
-	dev_t dev = dd->dm_dev.bdev->bd_dev;
+	struct dm_dev_internal dd_new, dd_old;
 
-	dd_copy = *dd;
+	dd_new = dd_old = *dd;
+
+	dd_new.dm_dev.mode |= new_mode;
+	dd_new.dm_dev.bdev = NULL;
+
+	r = open_dev(&dd_new, dd->dm_dev.bdev->bd_dev, md);
+	if (r)
+		return r;
 
 	dd->dm_dev.mode |= new_mode;
-	dd->dm_dev.bdev = NULL;
-	r = open_dev(dd, dev, md);
-	if (!r)
-		close_dev(&dd_copy, md);
-	else
-		*dd = dd_copy;
+	close_dev(&dd_old, md);
 
-	return r;
+	return 0;
 }
 
 /*
