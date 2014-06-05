From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/7] dm: remove handling of DM_ENDIO_INCOMPLETE
Date: Thu,  5 Jun 2014 15:11:02 +0200
Message-ID: <1401973867-121561-3-git-send-email-hare@suse.de>
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

Never used, so no need to handle it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index de88fac..0fa0884 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -980,9 +980,6 @@ static void dm_done(struct request *clone, struct dm_rq_target_io *tio,
 	if (r <= 0)
 		/* The target wants to complete the I/O */
 		dm_end_request(clone, r);
-	else if (r == DM_ENDIO_INCOMPLETE)
-		/* The target will handle the I/O */
-		return;
 	else if (r == DM_ENDIO_REQUEUE)
 		/* The target wants to requeue the I/O */
 		dm_requeue_unmapped_request(clone);
-- 
1.7.12.4
