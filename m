From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH v7 6/6] loop: Add support for REQ_ALLOCATE
Date: Thu, 13 Feb 2020 10:39:35 +0300
Message-ID: <158157957565.111879.5952051034259419400.stgit@localhost.localdomain>
References: <158157930219.111879.12072477040351921368.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <158157930219.111879.12072477040351921368.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, bob.liu@oracle.com, axboe@kernel.dk, darrick.wong@oracle.com
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, chaitanya.kulkarni@wdc.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ktkhai@virtuozzo.com
List-Id: dm-devel.ids

Support for new modifier of REQ_OP_WRITE_ZEROES command.
This results in allocation extents in backing file instead
of actual blocks zeroing.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 drivers/block/loop.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 739b372a5112..0704167a5aaa 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -581,6 +581,16 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	return 0;
 }
 
+/* Convert REQ_OP_WRITE_ZEROES modifiers into fallocate mode */
+static unsigned int write_zeroes_to_fallocate_mode(unsigned int flags)
+{
+	if (flags & REQ_ALLOCATE)
+		return 0;
+	if (flags & REQ_NOUNMAP)
+		return FALLOC_FL_ZERO_RANGE;
+	return FALLOC_FL_PUNCH_HOLE;
+}
+
 static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 {
 	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
@@ -599,14 +609,8 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	case REQ_OP_FLUSH:
 		return lo_req_flush(lo, rq);
 	case REQ_OP_WRITE_ZEROES:
-		/*
-		 * If the caller doesn't want deallocation, call zeroout to
-		 * write zeroes the range.  Otherwise, punch them out.
-		 */
 		return lo_fallocate(lo, rq, pos,
-			(rq->cmd_flags & REQ_NOUNMAP) ?
-				FALLOC_FL_ZERO_RANGE :
-				FALLOC_FL_PUNCH_HOLE);
+			write_zeroes_to_fallocate_mode(rq->cmd_flags));
 	case REQ_OP_DISCARD:
 		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
 	case REQ_OP_WRITE:
@@ -877,6 +881,7 @@ static void loop_config_discard(struct loop_device *lo)
 		q->limits.discard_alignment = 0;
 		blk_queue_max_discard_sectors(q, 0);
 		blk_queue_max_write_zeroes_sectors(q, 0);
+		blk_queue_max_allocate_sectors(q, 0);
 		blk_queue_flag_clear(QUEUE_FLAG_DISCARD, q);
 		return;
 	}
@@ -886,6 +891,7 @@ static void loop_config_discard(struct loop_device *lo)
 
 	blk_queue_max_discard_sectors(q, UINT_MAX >> 9);
 	blk_queue_max_write_zeroes_sectors(q, UINT_MAX >> 9);
+	blk_queue_max_allocate_sectors(q, UINT_MAX >> 9);
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
 }
 
