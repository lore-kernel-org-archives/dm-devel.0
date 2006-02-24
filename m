From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dm free minor after unlink gendisk
Date: Fri, 24 Feb 2006 12:27:34 -0500
Message-ID: <43FF4206.2030209@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020402090500010402070201"
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
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------020402090500010402070201
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hello,

free_dev() releases minor number before unregistering gendisk.
It creates a window where two registered gendisk with same number
exist, which will cause problem.

Typically, if you run the following script,
you will hit WARN_ON() in kref_get().

#!/bin/sh
(while dmsetup create a --notable; do dmsetup remove a; done) &
(while dmsetup create b --notable; do dmsetup remove b; done) &

Attached patch fixes this problem.

-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------020402090500010402070201
Content-Type: text/x-patch;
 name="dm-free-minor-after-del_gendisk.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="dm-free-minor-after-del_gendisk.patch"

minor number should be freed after del_gendisk().
Otherwise, there could be a window where 2 registered gendisk
has same minor number.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

--- linux-2.6.15.orig/drivers/md/dm.c	2006-02-24 11:05:05.000000000 -0500
+++ linux-2.6.15/drivers/md/dm.c	2006-02-24 11:17:54.000000000 -0500
@@ -812,14 +812,16 @@ static struct mapped_device *alloc_dev(u
 
 static void free_dev(struct mapped_device *md)
 {
+	unsigned int minor = md->disk->first_minor;
+
 	if (md->suspended_bdev) {
 		thaw_bdev(md->suspended_bdev, NULL);
 		bdput(md->suspended_bdev);
 	}
-	free_minor(md->disk->first_minor);
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
 	del_gendisk(md->disk);
+	free_minor(minor);
 	put_disk(md->disk);
 	blk_put_queue(md->queue);
 	kfree(md);

--------------020402090500010402070201
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------020402090500010402070201--
