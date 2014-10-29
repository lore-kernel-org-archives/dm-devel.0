From: heinzm@redhat.com
Subject: [PATCH] dm-raid: fix inaccessible superblocks causing
	oops in configure_discard_support
Date: Wed, 29 Oct 2014 18:05:50 +0100
Message-ID: <1414602350-3609-1-git-send-email-heinzm@redhat.com>
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

In case of missing metadata device(s), the failing read of the superblock
ause the metadata and data devices to be removed from the dev array
in struct raid_set setting references to both devces to NULL.
configure_discard_support nonetheless tries to access the data dev
unconditionally causing an oops.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>


diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 4857fa4..5818596 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1169,8 +1169,12 @@ static void configure_discard_support(struct dm_target *ti, struct raid_set *rs)
 	raid456 = (rs->md.level == 4 || rs->md.level == 5 || rs->md.level == 6);
 
 	for (i = 0; i < rs->md.raid_disks; i++) {
-		struct request_queue *q = bdev_get_queue(rs->dev[i].rdev.bdev);
+		struct request_queue *q;
 
+		if (!rs->dev[i].rdev.bdev)
+			continue;
+
+		q = bdev_get_queue(rs->dev[i].rdev.bdev);
 		if (!q || !blk_queue_discard(q))
 			return;
 
-- 
1.9.3
