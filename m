From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 7/9] blk: Mark requests aborted
Date: Mon,  3 May 2010 20:37:06 -0700
Message-ID: <1272944228-30511-8-git-send-email-andmike@linux.vnet.ibm.com>
References: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1272944228-30511-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axobe <jens.axboe@oracle.com>, James Bottomley <James.Bottomley@suse.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

Mark requests aborted using blk_mark_rq_aborted to assist lower levels in
identifying aborted requests.

Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Jens Axobe <jens.axboe@oracle.com>
---
 block/blk-timeout.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index ad45b44..d8610c1 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -229,9 +229,17 @@ void blk_abort_queue(struct request_queue *q)
 	 */
 	list_splice_init(&q->timeout_list, &list);
 
-	list_for_each_entry_safe(rq, tmp, &list, timeout_list)
+	list_for_each_entry_safe(rq, tmp, &list, timeout_list) {
+                /*
+                 * Mark all requests even if we are unable to abort. The
+                 * aborted flag can used by lower levels to indicate that
+                 * the request should finished as soon as possible.
+                 */
+		blk_mark_rq_aborted(rq);
+
 		if (!blk_queue_stopped(q))
 			blk_abort_request(rq);
+	}
 
 	/*
 	 * Occasionally, blk_abort_request() will return without
-- 
1.6.6.1

