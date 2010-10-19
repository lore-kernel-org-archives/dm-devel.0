From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm: use revalidate_disk to update device size
 after set_capacity
Date: Tue, 19 Oct 2010 18:07:11 -0400
Message-ID: <20101019220711.GA25169@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Avoid taking md->bdev->bd_inode->i_mutex to update the DM block device's
size.  Doing so eliminates the potential for deadlock if an fsync is
racing with a device resize.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f934e98..fd315a7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1995,10 +1995,7 @@ static void event_callback(void *context)
 static void __set_size(struct mapped_device *md, sector_t size)
 {
 	set_capacity(md->disk, size);
-
-	mutex_lock(&md->bdev->bd_inode->i_mutex);
-	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->bdev->bd_inode->i_mutex);
+	revalidate_disk(md->disk);
 }
 
 /*
