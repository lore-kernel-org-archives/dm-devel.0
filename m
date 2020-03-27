From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] dm-zoned: allow for device size smaller than
	the capacity
Date: Fri, 27 Mar 2020 08:14:59 +0100
Message-ID: <20200327071459.67796-5-hare@suse.de>
References: <20200327071459.67796-1-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200327071459.67796-1-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Damien LeMoal <damien.lemoal@wdc.com>, Bob Liu <bob.liu@oracle.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

dm-zoned requires several zones for metadata and chunk bitmaps,
so it cannot expose the entire capacity as the device size.
Originally the code would check for the capacity being equal to
the device size, which is arguably wrong.
So relax this check and increase the interface version number
to signal to userspace that it can set a smaller device size.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-zoned-target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 7ec9dde24516..89a825d1034e 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -715,7 +715,7 @@ static int dmz_get_zoned_device(struct dm_target *ti, char *path)
 	aligned_capacity = dev->capacity &
 				~((sector_t)blk_queue_zone_sectors(q) - 1);
 	if (ti->begin ||
-	    ((ti->len != dev->capacity) && (ti->len != aligned_capacity))) {
+	    ((ti->len > dev->capacity) && (ti->len > aligned_capacity))) {
 		ti->error = "Partial mapping not supported";
 		ret = -EINVAL;
 		goto err;
@@ -1008,7 +1008,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
 
 static struct target_type dmz_type = {
 	.name		 = "zoned",
-	.version	 = {1, 2, 0},
+	.version	 = {1, 3, 0},
 	.features	 = DM_TARGET_SINGLETON | DM_TARGET_ZONED_HM,
 	.module		 = THIS_MODULE,
 	.ctr		 = dmz_ctr,
-- 
2.16.4
