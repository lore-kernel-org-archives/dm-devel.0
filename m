From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/6] block: Adjust elv_iosched_show to return
	"none" for bio-based DM
Date: Sun, 23 May 2010 17:44:56 -0400
Message-ID: <1274651101-9784-2-git-send-email-snitzer@redhat.com>
References: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1274651101-9784-1-git-send-email-snitzer@redhat.com>
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
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Alasdair Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

Bio-based DM doesn't use an elevator (queue is !blk_queue_stackable()).

Longer-term DM will not allocate an elevator for bio-based DM.  But even
then there will be small potential for an elevator to be allocated for
a request-based DM table only to have a bio-based table be loaded in the
end.

Displaying "none" for bio-based DM will help avoid user confusion.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/elevator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-block/block/elevator.c
===================================================================
--- linux-2.6-block.orig/block/elevator.c
+++ linux-2.6-block/block/elevator.c
@@ -1097,7 +1097,7 @@ ssize_t elv_iosched_show(struct request_
 	struct elevator_type *__e;
 	int len = 0;
 
-	if (!q->elevator)
+	if (!q->elevator || !blk_queue_stackable(q))
 		return sprintf(name, "none\n");
 
 	elv = e->elevator_type;
