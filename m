From: Jens Axboe <axboe@kernel.dk>
Subject: Re: xfstests generic/347 seems unhappy on todays block
	for-next tree
Date: Mon, 10 Dec 2018 15:40:05 -0700
Message-ID: <36632a47-3bc6-2d71-d7f5-3de5ea64b151@kernel.dk>
References: <20181210213724.GA27905@infradead.org>
	<f7854d23-cba0-d5ce-e136-6cacd052a6da@kernel.dk>
	<20181210215356.GA20174@infradead.org>
	<695940bb-3783-c8f6-6747-dfd548df7ca7@kernel.dk>
	<d3939eed-d2cc-d247-ffbc-117fbae74118@kernel.dk>
	<0742acda-f5eb-9d1a-a368-a30c43c56c13@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <0742acda-f5eb-9d1a-a368-a30c43c56c13@kernel.dk>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

On 12/10/18 3:36 PM, Jens Axboe wrote:
> On 12/10/18 3:09 PM, Jens Axboe wrote:
>> On 12/10/18 3:00 PM, Jens Axboe wrote:
>>> On 12/10/18 2:53 PM, Christoph Hellwig wrote:
>>>> On Mon, Dec 10, 2018 at 02:39:39PM -0700, Jens Axboe wrote:
>>>>> On 12/10/18 2:37 PM, Christoph Hellwig wrote:
>>>>>> This test is described as:
>>>>>>
>>>>>> # Test very basic thin device usage, exhaustion, and growth
>>>>>
>>>>> Does that tree have:
>>>>>
>>>>> commit c616cbee97aed4bc6178f148a7240206dcdb85a6
>>>>> Author: Jens Axboe <axboe@kernel.dk>
>>>>> Date:   Thu Dec 6 22:17:44 2018 -0700
>>>>>
>>>>>     blk-mq: punt failed direct issue to dispatch list
>>>>>
>>>>> ?
>>>>
>>>> yes.
>>>>
>>>> The latest commit is 6f75723190d88e1319bea623bfe0292bf3917965
>>>
>>> Reproduces here, guessing it's the inflight counters... Trying without.
>>
>> Yep, works without the inflight changes. Deferring to Mike to sort
>> this one out.
> 
> I think this should work much better...

We can improve upon that, we don't need to ever read the inflight
counter from IO completion. Testing this one now.


diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 70568f8b6c53..79ad4b3d215c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -650,14 +650,14 @@ static bool md_in_flight(struct mapped_device *md)
 {
 	int cpu;
 	struct hd_struct *part = &dm_disk(md)->part0;
+	long sum = 0;
 
 	for_each_possible_cpu(cpu) {
-		if (part_stat_local_read_cpu(part, in_flight[0], cpu) ||
-		    part_stat_local_read_cpu(part, in_flight[1], cpu))
-			return true;
+		sum += part_stat_local_read_cpu(part, in_flight[0], cpu);
+		sum += part_stat_local_read_cpu(part, in_flight[1], cpu);
 	}
 
-	return false;
+	return sum != 0;
 }
 
 static void start_io_acct(struct dm_io *io)
@@ -691,10 +691,8 @@ static void end_io_acct(struct dm_io *io)
 				    true, duration, &io->stats_aux);
 
 	/* nudge anyone waiting on suspend queue */
-	if (unlikely(waitqueue_active(&md->wait))) {
-		if (!md_in_flight(md))
-			wake_up(&md->wait);
-	}
+	if (unlikely(waitqueue_active(&md->wait)))
+		wake_up(&md->wait);
 }
 
 /*

-- 
Jens Axboe
