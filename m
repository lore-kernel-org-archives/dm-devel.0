From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] dm: remove dm_mutex (after bkl conversion)
Date: Mon, 29 Nov 2010 23:53:05 +0100
Message-ID: <1291071187-6231-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

During the BKL conversion, commit
2a48fc0ab24241755dc93bfd4f01d68efab47f5a
pushed down lock_kernel() into dm_blk_open/close calls
and commit 2a48fc0ab24241755dc93bfd4f01d68efab47f5a
converted it to local mutex.

Patch removes this mutex, DM does not need it, there is
_minor_lock in open call covering create/remove DM device
operation.

In close call there is just atomic reference decrementation
which does not need to be covered by lock.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7cb1352..5ca9fc2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -32,7 +32,6 @@
 #define DM_COOKIE_ENV_VAR_NAME "DM_COOKIE"
 #define DM_COOKIE_LENGTH 24
 
-static DEFINE_MUTEX(dm_mutex);
 static const char *_name = DM_NAME;
 
 static unsigned int major = 0;
@@ -328,7 +327,6 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mapped_device *md;
 
-	mutex_lock(&dm_mutex);
 	spin_lock(&_minor_lock);
 
 	md = bdev->bd_disk->private_data;
@@ -346,7 +344,6 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 
 out:
 	spin_unlock(&_minor_lock);
-	mutex_unlock(&dm_mutex);
 
 	return md ? 0 : -ENXIO;
 }
@@ -355,10 +352,8 @@ static int dm_blk_close(struct gendisk *disk, fmode_t mode)
 {
 	struct mapped_device *md = disk->private_data;
 
-	mutex_lock(&dm_mutex);
 	atomic_dec(&md->open_count);
 	dm_put(md);
-	mutex_unlock(&dm_mutex);
 
 	return 0;
 }
-- 
1.7.2.3
