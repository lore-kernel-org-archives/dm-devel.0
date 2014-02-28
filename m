From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/8] dm mpath: remove map_io()
Date: Fri, 28 Feb 2014 15:33:47 +0100
Message-ID: <1393598029-67995-7-git-send-email-hare@suse.de>
References: <1393598029-67995-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393598029-67995-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

multipath_map() is now just a wrapper around map_io(), so we
can rename map_io() to multipath_map().

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm-mpath.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 13a855b..5e92d51 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -375,9 +375,13 @@ static int __must_push_back(struct multipath *m)
 
 #define pg_ready(m) (!(m)->queue_io && !(m)->pg_init_required)
 
-static int map_io(struct multipath *m, struct request *clone,
-		  union map_info *map_context)
+/*
+ * Map cloned requests
+ */
+static int multipath_map(struct dm_target *ti, struct request *clone,
+			 union map_info *map_context)
 {
+	struct multipath *m = (struct multipath *) ti->private;
 	int r = DM_MAPIO_REQUEUE;
 	size_t nr_bytes = blk_rq_bytes(clone);
 	unsigned long flags;
@@ -909,17 +913,6 @@ static void multipath_dtr(struct dm_target *ti)
 }
 
 /*
- * Map cloned requests
- */
-static int multipath_map(struct dm_target *ti, struct request *clone,
-			 union map_info *map_context)
-{
-	struct multipath *m = (struct multipath *) ti->private;
-
-	return map_io(m, clone, map_context);
-}
-
-/*
  * Take a path out of use.
  */
 static int fail_path(struct pgpath *pgpath)
-- 
1.7.12.4
