From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] mtd: fix bdev exclusive open bugs in
	block2mtd::add_device()
Date: Mon,  1 Nov 2010 17:15:25 +0100
Message-ID: <1288628129-12811-2-git-send-email-tj__21238.5984174491$1288628313$gmane$org@kernel.org>
References: <1288628129-12811-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1288628129-12811-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, hch@infradead.org, linux-kernel@vger.kernel.org, petero2@telia.com, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, jack@suse.cz, akpm@linux-foundatio
Cc: Tejun Heo <tj@kernel.org>, linux-mtd@lists.infradead.org
List-Id: dm-devel.ids

There are two bdev exclusive open bugs.

* open_bdev_exclusive() must not be called with NULL holder.  Use dev
  as the holder.

* open_by_devnum() doesn't open the bdev exclusively but
  block2mtd_free_device() always assumes it.  Explicitly claim the
  bdev.

The latter is rather clumsy but will be simplified with future
blkdev_get/put() cleanups.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: linux-mtd@lists.infradead.org
---
 drivers/mtd/devices/block2mtd.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/devices/block2mtd.c b/drivers/mtd/devices/block2mtd.c
index 2cf0cc6..806a9ed 100644
--- a/drivers/mtd/devices/block2mtd.c
+++ b/drivers/mtd/devices/block2mtd.c
@@ -246,7 +246,7 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		return NULL;
 
 	/* Get a handle on the device */
-	bdev = open_bdev_exclusive(devname, FMODE_READ|FMODE_WRITE, NULL);
+	bdev = open_bdev_exclusive(devname, FMODE_READ|FMODE_WRITE, dev);
 #ifndef MODULE
 	if (IS_ERR(bdev)) {
 
@@ -256,6 +256,15 @@ static struct block2mtd_dev *add_device(char *devname, int erase_size)
 		dev_t devt = name_to_dev_t(devname);
 		if (devt) {
 			bdev = open_by_devnum(devt, FMODE_WRITE | FMODE_READ);
+			if (!IS_ERR(bdev)) {
+				int ret;
+				ret = bd_claim(bdev, dev);
+				if (ret) {
+					blkdev_put(bdev,
+						   FMODE_READ | FMODE_WRITE);
+					bdev = ERR_PTR(ret);
+				}
+			}
 		}
 	}
 #endif
-- 
1.7.1
