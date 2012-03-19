From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] dm-mpath: Track invalid map_context
Date: Mon, 19 Mar 2012 16:39:06 +0100
Message-ID: <1332171546-33434-1-git-send-email-hare@suse.de>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

The map_context pointer should always be set. However, we
have reports that upon requeing it is not set correctly.
So add a BUG_ON() statement and clear the pointer to
track the issue properly.

Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Acked-by: Dave Wysochanski <dwysocha@redhat.com>
---
 drivers/md/dm-mpath.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 801d92d..2ed316e 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -441,11 +441,13 @@ static void dispatch_queued_ios(struct multipath *m)
 		r = map_io(m, clone, mpio, 1);
 		if (r < 0) {
 			mempool_free(mpio, m->mpio_pool);
+			info->ptr = NULL;
 			dm_kill_unmapped_request(clone, r);
 		} else if (r == DM_MAPIO_REMAPPED)
 			dm_dispatch_request(clone);
 		else if (r == DM_MAPIO_REQUEUE) {
 			mempool_free(mpio, m->mpio_pool);
+			info->ptr = NULL;
 			dm_requeue_unmapped_request(clone);
 		}
 	}
@@ -920,8 +922,10 @@ static int multipath_map(struct dm_target *ti, struct request *clone,
 	map_context->ptr = mpio;
 	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	r = map_io(m, clone, mpio, 0);
-	if (r < 0 || r == DM_MAPIO_REQUEUE)
+	if (r < 0 || r == DM_MAPIO_REQUEUE) {
 		mempool_free(mpio, m->mpio_pool);
+		map_context->ptr = NULL;
+	}
 
 	return r;
 }
@@ -1261,6 +1265,8 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	struct path_selector *ps;
 	int r;
 
+	BUG_ON(!mpio);
+
 	r  = do_end_io(m, clone, error, mpio);
 	if (pgpath) {
 		ps = &pgpath->pg->ps;
@@ -1268,6 +1274,7 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
 	mempool_free(mpio, m->mpio_pool);
+	map_context->ptr = NULL;
 
 	return r;
 }
-- 
1.6.0.2
