From: heinzm@redhat.com
Subject: [PATCH 2/3] md raid0: access mddev->queue (request queue
	member) conditionally because it is not set when accessed
	from dm-raid
Date: Fri, 13 Feb 2015 19:48:07 +0100
Message-ID: <1423853288-6278-3-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

The patch makes 3 references to mddev->queue in the raid0 personality
conditional in order to allow for it to be accessed from dm-raid.
Mandatory, because md instances underneath dm-raid don't manage
a request queue of their own which'd lead to oopses without the patch.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/raid0.c | 48 +++++++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 21 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index a13f738..d2e037d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -271,14 +271,16 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		goto abort;
 	}
 
-	blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
-	blk_queue_io_opt(mddev->queue,
-			 (mddev->chunk_sectors << 9) * mddev->raid_disks);
-
-	if (!discard_supported)
-		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
-	else
-		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+	if (mddev->queue) {
+		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
+		blk_queue_io_opt(mddev->queue,
+				 (mddev->chunk_sectors << 9) * mddev->raid_disks);
+
+		if (!discard_supported)
+			queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+		else
+			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, mddev->queue);
+	}
 
 	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
 	*private_conf = conf;
@@ -429,9 +431,12 @@ static int raid0_run(struct mddev *mddev)
 	}
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
-	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
-	blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
-	blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
+
+	if (mddev->queue) {
+		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
+		blk_queue_max_write_same_sectors(mddev->queue, mddev->chunk_sectors);
+		blk_queue_max_discard_sectors(mddev->queue, mddev->chunk_sectors);
+	}
 
 	/* if private is not null, we are here after takeover */
 	if (mddev->private == NULL) {
@@ -448,16 +453,17 @@ static int raid0_run(struct mddev *mddev)
 	printk(KERN_INFO "md/raid0:%s: md_size is %llu sectors.\n",
 	       mdname(mddev),
 	       (unsigned long long)mddev->array_sectors);
-	/* calculate the max read-ahead size.
-	 * For read-ahead of large files to be effective, we need to
-	 * readahead at least twice a whole stripe. i.e. number of devices
-	 * multiplied by chunk size times 2.
-	 * If an individual device has an ra_pages greater than the
-	 * chunk size, then we will not drive that device as hard as it
-	 * wants.  We consider this a configuration error: a larger
-	 * chunksize should be used in that case.
-	 */
-	{
+
+	if (mddev->queue) {
+		/* calculate the max read-ahead size.
+		 * For read-ahead of large files to be effective, we need to
+		 * readahead at least twice a whole stripe. i.e. number of devices
+		 * multiplied by chunk size times 2.
+		 * If an individual device has an ra_pages greater than the
+		 * chunk size, then we will not drive that device as hard as it
+		 * wants.  We consider this a configuration error: a larger
+		 * chunksize should be used in that case.
+		 */
 		int stripe = mddev->raid_disks *
 			(mddev->chunk_sectors << 9) / PAGE_SIZE;
 		if (mddev->queue->backing_dev_info.ra_pages < 2* stripe)
-- 
2.1.0
