From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] wbt: fix incorrect throttling due to flush latency
Date: Mon, 5 Feb 2018 14:11:55 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1802051406190.15867@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

I have a workload where one process sends many asynchronous write bios
(without waiting for them) and another process sends synchronous flush
bios. During this workload, writeback throttling throttles down to one
outstanding bio, and this incorrect throttling causes performance
degradation (all write bios sleep in __wbt_wait and they couldn't be sent
in parallel).

The reason for this throttling is that wbt_data_dir counts flush requests
in the read bucket. The flush requests (that take quite a long time)
trigger this condition repeatedly:
	if (stat[READ].min > rwb->min_lat_nsec)
and that condition causes scale down to one outstanding request, despite
the fact that there are no read bios at all.

A similar problem could also show up with REQ_OP_ZONE_REPORT and
REQ_OP_ZONE_RESET - they are also counted in the read bucket.

This patch fixes the function wbt_data_dir, so that only REQ_OP_READ 
requests are counted in the read bucket. The patch improves SATA 
write+flush throughput from 130MB/s to 350MB/s.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v4.12+

---
 block/blk-wbt.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-stable/block/blk-wbt.c
===================================================================
--- linux-stable.orig/block/blk-wbt.c	2018-02-05 12:30:09.606063908 -0500
+++ linux-stable/block/blk-wbt.c	2018-02-05 13:50:02.784213501 -0500
@@ -697,7 +697,11 @@ u64 wbt_default_latency_nsec(struct requ
 
 static int wbt_data_dir(const struct request *rq)
 {
-	return rq_data_dir(rq);
+	/*
+	 * Flushes must be counted in the write bucket, so that high flush
+	 * latencies don't cause scale down.
+	 */
+	return req_op(rq) == REQ_OP_READ ? READ : WRITE;
 }
 
 int wbt_init(struct request_queue *q)
