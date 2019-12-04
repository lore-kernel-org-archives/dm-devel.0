From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 2/2] dm thin: Flush data device before
	committing metadata
Date: Wed, 4 Dec 2019 18:47:34 +0200
Message-ID: <79971756-2f21-09e1-bfec-7fbc16eba44e@arrikto.com>
References: <20191204140742.26273-1-ntsironis@arrikto.com>
	<20191204140742.26273-3-ntsironis@arrikto.com>
	<20191204152759.qhh2f6ybhww7ivel@reti>
	<4627d4b3-fced-0d22-34c5-258733c9afa9@arrikto.com>
	<20191204163939.GA30305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191204163939.GA30305@redhat.com>
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
Cc: dm-devel@redhat.com, thornber@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

On 12/4/19 6:39 PM, Mike Snitzer wrote:>
On Wed, Dec 04 2019 at 11:17am -0500,
> Nikos Tsironis <ntsironis@arrikto.com> wrote:
> 
>> On 12/4/19 5:27 PM, Joe Thornber wrote:
>>> On Wed, Dec 04, 2019 at 04:07:42PM +0200, Nikos Tsironis wrote:
>>>> The thin provisioning target maintains per thin device mappings that map
>>>> virtual blocks to data blocks in the data device.
>>>
>>>
>>> Ack.  But I think we're issuing the FLUSH twice with your patch.  Since the
>>> original bio is still remapped and issued at the end of process_deferred_bios?
>>>
>>
>> Yes, that's correct. I thought of it and of putting a check in
>> process_deferred_bios() to complete FLUSH bios immediately, but I have
>> one concern and I preferred to be safe than sorry.
>>
>> In __commit_transaction() there is the following check:
>>
>>    if (unlikely(!pmd->in_service))
>>              return 0;
>>
>> , which means we don't commit the metadata, and thus we don't flush the
>> data device, in case the pool is not in service.
>>
>> Opening a thin device doesn't seem to put the pool in service, since
>> dm_pool_open_thin_device() uses pmd_write_lock_in_core().
>>
>> Can I assume that the pool is in service if I/O can be mapped to a thin
>> device? If so, it's safe to put such a check in process_deferred_bios().
> 
> In service means upper layer has issued a write to a thin device of a
> pool.  The header for commit 873f258becca87 gets into more detail.
> 
>> On second thought though, in order for a flush bio to end up in
>> deferred_flush_bios in the first place, someone must have changed the
>> metadata and thus put the pool in service. Otherwise, it would have been
>> submitted directly to the data device. So, it's probably safe to check
>> for flush bios after commit() in process_deferred_bios() and complete
>> them immediately.
> 
> Yes, I think so, which was Joe's original point.
>   
>> If you confirm too that this is safe, I will send a second version of
>> the patch adding the check.
> 
> Not seeing why we need another in_service check.  After your changes are
> applied, any commit will trigger a preceeding flush.. so the deferred
> flushes are redundant.
> 

Yes, I meant add a check in process_deferred_bios(), after commit(), to
check for REQ_PREFLUSH bios and complete them immediately. I should have
clarified that.

> By definition, these deferred bios imply the pool is in service.
> 
> I'd be fine with seeing a 3rd follow-on thinp patch that completes the
> redundant flushes immediately.
> 

Ack, I will send another patch fixing this.

Nikos

> Thanks,
> Mike
> 
