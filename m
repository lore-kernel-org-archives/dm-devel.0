From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] dm missing bdput/thaw_bdev at removal
Date: Thu, 23 Feb 2006 19:05:09 -0500
Message-ID: <43FE4DB5.5050904@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010607050004060606030302"
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
--------------010607050004060606030302
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Hello,

The following script stalls at the 2nd suspend.
It's because bdput() isn't called for the suspended_bdev.

So the inode with bd_mount_sem held is just reused
in the next mapped_device device.
Then dm_suspend will try to freeze_bdev and wait forever.

Attached patch fixes this problem.

------------------------------------------------------------
#!/bin/sh -x

map=a
while true; do
  dmsetup create $map --notable
  dmsetup suspend $map
  dmsetup remove $map
done
------------------------------------------------------------

-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------010607050004060606030302
Content-Type: text/x-patch;
 name="dm-missing-bdput.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-missing-bdput.patch"

Need to unfreeze and release bdev
otherwise the bdev inode with inconsistent state is reused later
and cause problem.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

--- linux-2.6.15.orig/drivers/md/dm.c	2006-02-23 18:28:23.000000000 -0500
+++ linux-2.6.15/drivers/md/dm.c	2006-02-23 18:29:04.000000000 -0500
@@ -812,6 +812,10 @@ static struct mapped_device *alloc_dev(u
 
 static void free_dev(struct mapped_device *md)
 {
+	if (md->suspended_bdev) {
+		thaw_bdev(md->suspended_bdev, NULL);
+		bdput(md->suspended_bdev);
+	}
 	free_minor(md->disk->first_minor);
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);

--------------010607050004060606030302
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010607050004060606030302--
