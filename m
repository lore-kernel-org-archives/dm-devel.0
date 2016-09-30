From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH] dm-mpath: Only reprocess queued IO after pg
 initialization finished
Date: Fri, 30 Sep 2016 08:59:06 -0700
Message-ID: <fdedde34-4785-fe1d-f88f-a2d6b3713500@sandisk.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

At least with dm-mq this patch reduces the number of multipath_busy()
calls while scsi_dh_activate() is in progress from a few million to
a few thousand.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm-mpath.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index dd80af2..dd66653 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -343,12 +343,15 @@ static void multipath_init_per_bio_data(struct bio *bio, struct dm_mpath_io **mp
  * Path selection
  *-----------------------------------------------*/
 
+/* Returns a value > 0 if path group initialization is still in progress. */
 static int __pg_init_all_paths(struct multipath *m)
 {
 	struct pgpath *pgpath;
 	unsigned long pg_init_delay = 0;
 
-	if (atomic_read(&m->pg_init_in_progress) || test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
+	if (atomic_read(&m->pg_init_in_progress))
+		return 1;
+	if (test_bit(MPATHF_PG_INIT_DISABLED, &m->flags))
 		return 0;
 
 	atomic_inc(&m->pg_init_count);
-- 
2.10.0
