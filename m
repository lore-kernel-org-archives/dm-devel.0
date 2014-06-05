From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 5/7] dm: move free_rq_clone() out of
	dm_unprep_request()
Date: Thu,  5 Jun 2014 15:11:05 +0200
Message-ID: <1401973867-121561-6-git-send-email-hare@suse.de>
References: <1401973867-121561-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1401973867-121561-1-git-send-email-hare@suse.de>
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
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5109c76..b2240f7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -902,12 +902,8 @@ static void dm_end_request(struct request *clone, int error)
 
 static void dm_unprep_request(struct request *rq)
 {
-	struct request *clone = rq->special;
-
 	rq->special = NULL;
 	rq->cmd_flags &= ~REQ_DONTPREP;
-
-	free_rq_clone(clone);
 }
 
 /*
@@ -977,6 +973,7 @@ static void dm_done(struct request *clone, struct dm_rq_target_io *tio,
 		rq_completed(md, rw, true);
 	} else if (r == DM_ENDIO_REQUEUE) {
 		/* The target wants to requeue the I/O */
+		free_rq_clone(clone);
 		dm_requeue_unmapped_request(rq);
 		rq_completed(md, rw, false);
 	} else {
@@ -1604,6 +1601,7 @@ static int map_request(struct dm_target *ti, struct request *clone,
 		break;
 	case DM_MAPIO_REQUEUE:
 		/* The target wants to requeue the I/O */
+		free_rq_clone(clone);
 		dm_requeue_unmapped_request(rq);
 		rq_completed(md, rw, false);
 		requeued = 1;
-- 
1.7.12.4
