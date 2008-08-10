From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] dm: kill lookup_device wrapper
Date: Mon, 11 Aug 2008 00:24:08 +0200
Message-ID: <20080810222408.GA8331@lst.de>
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
To: dm-devel@redhat.com, viro@zeniv.linux.org.uk
List-Id: dm-devel.ids

Now that lookup_bdev is exported and used by dm just use it directly
instead of through a trivial wrapper.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2008-08-02 00:05:04.000000000 +0200
+++ linux-2.6/drivers/md/dm-table.c	2008-08-02 00:06:02.000000000 +0200
@@ -312,19 +312,6 @@ static inline int check_space(struct dm_
 }
 
 /*
- * Convert a device path to a dev_t.
- */
-static int lookup_device(const char *path, dev_t *dev)
-{
-	struct block_device *bdev = lookup_bdev(path);
-	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
-	*dev = bdev->bd_dev;
-	bdput(bdev);
-	return 0;
-}
-
-/*
  * See if we've already got a device in the list.
  */
 static struct dm_dev *find_device(struct list_head *l, dev_t dev)
@@ -433,8 +420,12 @@ static int __table_get_device(struct dm_
 			return -EOVERFLOW;
 	} else {
 		/* convert the path to a device */
-		if ((r = lookup_device(path, &dev)))
-			return r;
+		struct block_device *bdev = lookup_bdev(path);
+
+		if (IS_ERR(bdev))
+			return PTR_ERR(bdev);
+		dev = bdev->bd_dev;
+		bdput(bdev);
 	}
 
 	dd = find_device(&t->devices, dev);
