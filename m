From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 7/7] dm: optimize clone_rq() when
 track_peak_rq_based_ios is disabled
Date: Fri, 13 Sep 2013 13:46:43 +0900
Message-ID: <523298B3.9050400@ce.jp.nec.com>
References: <alpine.LRH.2.02.1308261012400.12373@file01.intranet.prod.int.rdu2.redhat.com>
	<1379024698-10487-1-git-send-email-snitzer@redhat.com>
	<1379024698-10487-8-git-send-email-snitzer@redhat.com>
	<alpine.LRH.2.02.1309121857440.31794@file01.intranet.prod.int.rdu2.redhat.com>
	<20130912230646.GA31577@redhat.com>
	<alpine.LRH.2.02.1309121928140.3245@file01.intranet.prod.int.rdu2.redhat.com>
	<20130912235346.GF31577@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130912235346.GF31577@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Frank Mayhar <fmayhar@google.com>
List-Id: dm-devel.ids

On 09/13/13 08:53, Mike Snitzer wrote:
> On Thu, Sep 12 2013 at  7:30pm -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
>>>>> Make use of static keys to eliminate the relevant branch in clone_rq()
>>>>> when dm_mod's 'track_peak_rq_based_ios' paramter is set to 0 (disabled).
>>>>>
>>>>> Even if 'track_peak_rq_based_ios' is set to 0 it will not take effect
>>>>> until the next request-based table reload.  Once it is disabled the
>>>>> 'peak_rq_based_ios' parameter will be reset to 0.
>>>>
>>>> This patch changes it so that the value track_peak_rq_based_ios is sampled 
>>>> only when reloading a table. I think it will be confusing to the user if 
>>>> he changes the value, but the change doesn't take effect until something 
>>>> reloads some table.
>>>
>>> Well we need to be able to notice the change but I do not wish to do so
>>> in a performance critical path (which clone_rq is).
>>
>> I think one condition isn't that bad so there is no need to use static 
>> keys.
> 
> Considering we're talking about the IO path I'd rather avoid it given
> 'track_peak_rq_based_ios' will almost always be disabled.
> 
>> If you want to use static keys, you need to refresh them in some place 
>> that it called regularly.
> 
> No you don't.  I'm assuming if someone enables 'track_peak_rq_based_ios'
> they know what they are doing.
> 
> But I'm open to suggestions on a more appropriate hook to be catching
> the update to track_peak_rq_based_ios.

Other approach might be putting the info on tracepoints.
Then the tracepoint framework will take care of the static_key thing.

Since 'the number of bios in a request' is a block-layer generic info,
you could extend the block layer events instead of having your own.

Attached patch adds it to block_rq_remap event.
You could do something like this to see requests with many bios:
  echo 'nr_bios > 32' > /sys/kernel/debug/tracing/events/block/block_rq_remap/filter
  echo 1 > /sys/kernel/debug/tracing/events/block/block_rq_remap/enable 

For example,
     kworker/1:1H-308   [001] d..1   276.242448: block_rq_remap: 8,64 W 1967760 + 512 <- (253,1) 1967760 64
     kworker/1:1H-308   [001] d..1   276.242482: block_rq_remap: 8,160 W 1968272 + 512 <- (253,1) 1968272 64
     kworker/1:1H-308   [001] d..1   276.242515: block_rq_remap: 65,0 W 1968784 + 512 <- (253,1) 1968784 64
# the last item in line is the number of bios. ("64" in this case)

---
Jun'ichi Nomura, NEC Corporation


diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2fdb4a4..0e6f765 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -862,6 +862,17 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq)
 	return blk_queue_get_max_sectors(q, rq->cmd_flags);
 }
 
+static inline unsigned int blk_rq_count_bios(struct request *rq)
+{
+	unsigned int nr_bios = 0;
+	struct bio *bio;
+
+	__rq_for_each_bio(bio, rq)
+		nr_bios++;
+
+	return nr_bios;
+}
+
 /*
  * Request issue related functions.
  */
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index 60ae7c3..4c2301d 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -618,6 +618,7 @@ TRACE_EVENT(block_rq_remap,
 		__field( unsigned int,	nr_sector	)
 		__field( dev_t,		old_dev		)
 		__field( sector_t,	old_sector	)
+		__field( unsigned int,	nr_bios		)
 		__array( char,		rwbs,	RWBS_LEN)
 	),
 
@@ -627,15 +628,16 @@ TRACE_EVENT(block_rq_remap,
 		__entry->nr_sector	= blk_rq_sectors(rq);
 		__entry->old_dev	= dev;
 		__entry->old_sector	= from;
+		__entry->nr_bios	= blk_rq_count_bios(rq);
 		blk_fill_rwbs(__entry->rwbs, rq->cmd_flags, blk_rq_bytes(rq));
 	),
 
-	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
+	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
 		  (unsigned long long)__entry->sector,
 		  __entry->nr_sector,
 		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
-		  (unsigned long long)__entry->old_sector)
+		  (unsigned long long)__entry->old_sector, __entry->nr_bios)
 );
 
 #endif /* _TRACE_BLOCK_H */
