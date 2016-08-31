From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 9/9] dm path selector: Avoid that device removal
 triggers an infinite loop
Date: Wed, 31 Aug 2016 15:18:31 -0700
Message-ID: <242bfdfc-1af1-014a-48c6-301598b8ad65@sandisk.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
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
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

If pg_init_retries is set and a request is queued against a
multipath device with all underlying block devices in the "dying"
state then an infinite loop is triggered because activate_path()
never succeeds and hence never calls pg_init_done(). Fix this by
making ql_select_path() skip dying paths.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-queue-length.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
index 23f1786..a283c66 100644
--- a/drivers/md/dm-queue-length.c
+++ b/drivers/md/dm-queue-length.c
@@ -199,11 +199,12 @@ static struct dm_path *ql_select_path(struct path_selector *ps, size_t nr_bytes)
 	list_move_tail(s->valid_paths.next, &s->valid_paths);
 
 	list_for_each_entry(pi, &s->valid_paths, list) {
-		if (!best ||
-		    (atomic_read(&pi->qlen) < atomic_read(&best->qlen)))
+		if ((!best ||
+		     atomic_read(&pi->qlen) < atomic_read(&best->qlen)) &&
+		    !blk_queue_dying(pi->path->dev->bdev->bd_queue))
 			best = pi;
 
-		if (!atomic_read(&best->qlen))
+		if (best && atomic_read(&best->qlen) == 0)
 			break;
 	}
 
-- 
2.9.3
