From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 0/2] dm thin: Flush data device before
 committing metadata to avoid data corruption
Date: Thu, 5 Dec 2019 18:02:45 +0200
Message-ID: <56a62880-ce3f-6f94-a18e-3fcd7db6f286@arrikto.com>
References: <20191204140742.26273-1-ntsironis@arrikto.com>
	<alpine.LRH.2.11.1912041907490.11561@mx.ewheeler.net>
	<20191204201710.GA31432@redhat.com>
	<a60f1571-fff1-8be8-5537-f604747b39c9@arrikto.com>
	<20191205154221.GA4792@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191205154221.GA4792@redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: Eric Wheeler <dm-devel@lists.ewheeler.net>, dm-devel@redhat.com, thornber@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On 12/5/19 5:42 PM, Mike Snitzer wrote:
> On Thu, Dec 05 2019 at 10:31am -0500,
> Nikos Tsironis <ntsironis@arrikto.com> wrote:
> 
>> On 12/4/19 10:17 PM, Mike Snitzer wrote:
>>> On Wed, Dec 04 2019 at  2:58pm -0500,
>>> Eric Wheeler <dm-devel@lists.ewheeler.net> wrote:
>>>
>>>> On Wed, 4 Dec 2019, Nikos Tsironis wrote:
>>>>
>>>>> The thin provisioning target maintains per thin device mappings that map
>>>>> virtual blocks to data blocks in the data device.
>>>>>
>>>>> When we write to a shared block, in case of internal snapshots, or
>>>>> provision a new block, in case of external snapshots, we copy the shared
>>>>> block to a new data block (COW), update the mapping for the relevant
>>>>> virtual block and then issue the write to the new data block.
>>>>>
>>>>> Suppose the data device has a volatile write-back cache and the
>>>>> following sequence of events occur:
>>>>
>>>> For those with NV caches, can the data disk flush be optional (maybe as a
>>>> table flag)?
>>>
>>> IIRC block core should avoid issuing the flush if not needed.  I'll have
>>> a closer look to verify as much.
>>>
>>
>> For devices without a volatile write-back cache block core strips off
>> the REQ_PREFLUSH and REQ_FUA bits from requests with a payload and
>> completes empty REQ_PREFLUSH requests before entering the driver.
>>
>> This happens in generic_make_request_checks():
>>
>> 		/*
>> 		 * Filter flush bio's early so that make_request based
>> 		 * drivers without flush support don't have to worry
>> 		 * about them.
>> 		 */
>> 		if (op_is_flush(bio->bi_opf) &&
>> 		    !test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
>> 		        bio->bi_opf &= ~(REQ_PREFLUSH | REQ_FUA);
>> 		        if (!nr_sectors) {
>> 		                status = BLK_STS_OK;
>> 		                goto end_io;
>> 		        }
>> 		}
>>
>> If I am not mistaken, it all depends on whether the underlying device
>> reports the existence of a write back cache or not.
> 
> Yes, thanks for confirming my memory of the situation.
> 
>> You could check this by looking at /sys/block/<device>/queue/write_cache
>> If it says "write back" then flushes will be issued.
>>
>> In case the sysfs entry reports a "write back" cache for a device with a
>> non-volatile write cache, I think you can change the kernel's view of
>> the device by writing to this entry (you could also create a udev rule
>> for this).
>>
>> This way you can set the write cache as write through. This will
>> eliminate the cache flushes issued by the kernel, without altering the
>> device state (Documentation/block/queue-sysfs.rst).
> 
> Not delved into this aspect of Linux's capabilities but it strikes me as
> "dangerous" to twiddle device capabilities like this.  Best to fix
> driver to properly expose cache (or not, as the case may be).  It should
> also be noted that with DM; the capabilities are stac ked up at device
> creation time.  So any changes to the underlying devices will _not_ be
> reflected to the high level DM device.
> 

Yes, I agree completely. The queue-sysfs doc also mentions that it's not
safe to do that. I just mentioned it for completeness.

As far as DM is concerned, you are right. You would have to deactivate
and reactivate all DM devices for the change to propagate to upper
layers. That's why I mentioned udev, because that way the change will be
made to the lower level device when its queue is first created and it
will be properly propagated to upper layers.

But, again, I agree that this is not something safe to do and it's
better to make sure the driver properly exposes the cache capabilities,
as you said.

Nikos

> Mike
> 
