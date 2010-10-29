From: Mike Snitzer <snitzer@redhat.com>
Subject: dm: lock bd_mutex when setting device size
Date: Fri, 29 Oct 2010 17:50:01 -0400
Message-ID: <20101029215001.GA4827@redhat.com>
References: <20101019220711.GA25169@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20101019220711.GA25169@redhat.com>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

Avoid taking md->bdev->bd_inode->i_mutex to update the DM block device's
size.  Using md->bdev->bd_mutex eliminates the potential for deadlock if
an fsync is racing with a device resize.

revalidate_disk() was avoided because it would flush_disk() while the DM
device is suspended.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Jun'ichi, was the following your implict Acked-by?  Care to make it
explicit?
"Anyway, I think your bd_mutex patch should be fine for now and is
better than the current code with i_mutex, which has a real deadlock
issue."

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cb1352..248794a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1996,9 +1996,9 @@ static void __set_size(struct mapped_device *md, sector_t size)
 {
 	set_capacity(md->disk, size);
 
-	mutex_lock(&md->bdev->bd_inode->i_mutex);
+	mutex_lock(&md->bdev->bd_mutex);
 	i_size_write(md->bdev->bd_inode, (loff_t)size << SECTOR_SHIFT);
-	mutex_unlock(&md->bdev->bd_inode->i_mutex);
+	mutex_unlock(&md->bdev->bd_mutex);
 }
 
 /*
