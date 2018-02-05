From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] wbt: fix incorrect throttling due to flush latency
Date: Mon, 5 Feb 2018 12:35:07 -0700
Message-ID: <6bf3dd42-eb4a-8408-eb09-3b6c4dd18354@kernel.dk>
References: <alpine.LRH.2.02.1802051406190.15867@file01.intranet.prod.int.rdu2.redhat.com>
 <33d2d1ab-d57e-8a3f-94df-e79704b5d863@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <33d2d1ab-d57e-8a3f-94df-e79704b5d863@kernel.dk>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 2/5/18 12:22 PM, Jens Axboe wrote:
> On 2/5/18 12:11 PM, Mikulas Patocka wrote:
>> I have a workload where one process sends many asynchronous write bios
>> (without waiting for them) and another process sends synchronous flush
>> bios. During this workload, writeback throttling throttles down to one
>> outstanding bio, and this incorrect throttling causes performance
>> degradation (all write bios sleep in __wbt_wait and they couldn't be sent
>> in parallel).
>>
>> The reason for this throttling is that wbt_data_dir counts flush requests
>> in the read bucket. The flush requests (that take quite a long time)
>> trigger this condition repeatedly:
>> 	if (stat[READ].min > rwb->min_lat_nsec)
>> and that condition causes scale down to one outstanding request, despite
>> the fact that there are no read bios at all.
>>
>> A similar problem could also show up with REQ_OP_ZONE_REPORT and
>> REQ_OP_ZONE_RESET - they are also counted in the read bucket.
>>
>> This patch fixes the function wbt_data_dir, so that only REQ_OP_READ 
>> requests are counted in the read bucket. The patch improves SATA 
>> write+flush throughput from 130MB/s to 350MB/s.
> 
> Good catch. But I do wonder if we should account them at all. It
> might make sense to account flushes as writes, but we really
> should not account anything that isn't regular read/write IO 
> related.
> 
> Something like the below? Potentially including REQ_OP_FLUSH in the
> write latencies as well.

Thinking about it, flush should just be counted as writes, and the
rest disregarded. Ala below.


diff --git a/block/blk-wbt.c b/block/blk-wbt.c
index ae8de9780085..f92fc84b5e2c 100644
--- a/block/blk-wbt.c
+++ b/block/blk-wbt.c
@@ -697,7 +697,15 @@ u64 wbt_default_latency_nsec(struct request_queue *q)
 
 static int wbt_data_dir(const struct request *rq)
 {
-	return rq_data_dir(rq);
+	const int op = req_op(rq);
+
+	if (op == REQ_OP_READ)
+		return READ;
+	else if (op == REQ_OP_WRITE || op == REQ_OP_FLUSH)
+		return WRITE;
+
+	/* don't account */
+	return -1;
 }
 
 int wbt_init(struct request_queue *q)

-- 
Jens Axboe
