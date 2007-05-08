From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 10/26] dm: allow offline devices
Date: Tue, 8 May 2007 20:46:10 +0100
Message-ID: <20070508194610.GQ24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Anderson <andmike@us.ibm.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Mike Anderson <andmike@us.ibm.com>

Allow check_device_area to succeed if a device has an i_size of zero. This
addresses an issue seen on DASD devices setting up a multipath table for
paths in online and offline state.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

 drivers/md/dm-table.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6.21/drivers/md/dm-table.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-table.c	2007-05-01 17:40:45.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-table.c	2007-05-01 17:40:50.000000000 +0100
@@ -428,13 +428,15 @@ static void close_dev(struct dm_dev *d, 
 }
 
 /*
- * If possible (ie. blk_size[major] is set), this checks an area
- * of a destination device is valid.
+ * If possible, this checks an area of a destination device is valid.
  */
 static int check_device_area(struct dm_dev *dd, sector_t start, sector_t len)
 {
-	sector_t dev_size;
-	dev_size = dd->bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	sector_t dev_size = dd->bdev->bd_inode->i_size >> SECTOR_SHIFT;
+
+	if (!dev_size)
+		return 1;
+
 	return ((start < dev_size) && (len <= (dev_size - start)));
 }
 
