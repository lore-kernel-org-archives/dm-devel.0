From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] dm: Allow tables to have devices with zero size
Date: Mon, 8 Jan 2007 14:57:46 -0800
Message-ID: <20070108225746.GA3966@us.ibm.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Mike Anderson <andmike@us.ibm.com>

Allow check_device_area to succeed if a device has an i_size of zero. This
addresses an issue seen on DASD devices setting up a multipath table for
paths in online and offline state.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>
---

 drivers/md/dm-table.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-patched/drivers/md/dm-table.c
===================================================================
--- linux-2.6-patched.orig/drivers/md/dm-table.c	2006-12-31 16:53:20.000000000 -0800
+++ linux-2.6-patched/drivers/md/dm-table.c	2007-01-08 08:15:33.000000000 -0800
@@ -432,7 +432,8 @@
 {
 	sector_t dev_size;
 	dev_size = dd->bdev->bd_inode->i_size >> SECTOR_SHIFT;
-	return ((start < dev_size) && (len <= (dev_size - start)));
+	return dev_size ?
+		((start < dev_size) && (len <= (dev_size - start))) : 1;
 }
 
 /*
