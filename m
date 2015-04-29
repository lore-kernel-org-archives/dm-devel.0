From: heinzm@redhat.com
Subject: [PATCH v2 2/4] md-raid0: conditional mddev->queue access
	to suit dm-raid
Date: Wed, 29 Apr 2015 14:03:05 +0200
Message-ID: <1430308987-24703-3-git-send-email-heinzm@redhat.com>
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


This patch is a prerequisite for dm-raid "raid0" support to allow
dm-raid to access the MD RAID0 personality doing unconditional
accesses to mddev->queue, which is NULL in case of dm-raid stacked
on top of MD.

Most of the conditional mddev->queue accesses made it to upstream
but this missing one, which prohibits md raid0 to set disk stack limits
(being done in dm core in case of md underneath dm).


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Tested-by: Heinz Mauelshagen <heinzm@redhat.com>

---
 drivers/md/raid0.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 2cb59a6..6a68ef5 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -188,8 +188,9 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		}
 		dev[j] = rdev1;
 
-		disk_stack_limits(mddev->gendisk, rdev1->bdev,
-				  rdev1->data_offset << 9);
+		if (mddev->queue)
+			disk_stack_limits(mddev->gendisk, rdev1->bdev,
+					  rdev1->data_offset << 9);
 
 		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn)
 			conf->has_merge_bvec = 1;
-- 
2.1.0
