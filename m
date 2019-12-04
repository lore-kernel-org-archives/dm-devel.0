From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 2/2] dm thin: Flush data device before
	committing metadata
Date: Wed, 4 Dec 2019 18:17:10 +0200
Message-ID: <4627d4b3-fced-0d22-34c5-258733c9afa9@arrikto.com>
References: <20191204140742.26273-1-ntsironis@arrikto.com>
	<20191204140742.26273-3-ntsironis@arrikto.com>
	<20191204152759.qhh2f6ybhww7ivel@reti>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191204152759.qhh2f6ybhww7ivel@reti>
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
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com, thornber@redhat.com
List-Id: dm-devel.ids

On 12/4/19 5:27 PM, Joe Thornber wrote:
> On Wed, Dec 04, 2019 at 04:07:42PM +0200, Nikos Tsironis wrote:
>> The thin provisioning target maintains per thin device mappings that map
>> virtual blocks to data blocks in the data device.
> 
> 
> Ack.  But I think we're issuing the FLUSH twice with your patch.  Since the
> original bio is still remapped and issued at the end of process_deferred_bios?
> 

Yes, that's correct. I thought of it and of putting a check in
process_deferred_bios() to complete FLUSH bios immediately, but I have
one concern and I preferred to be safe than sorry.

In __commit_transaction() there is the following check:

   if (unlikely(!pmd->in_service))
             return 0;

, which means we don't commit the metadata, and thus we don't flush the
data device, in case the pool is not in service.

Opening a thin device doesn't seem to put the pool in service, since
dm_pool_open_thin_device() uses pmd_write_lock_in_core().

Can I assume that the pool is in service if I/O can be mapped to a thin
device? If so, it's safe to put such a check in process_deferred_bios().

On second thought though, in order for a flush bio to end up in
deferred_flush_bios in the first place, someone must have changed the
metadata and thus put the pool in service. Otherwise, it would have been
submitted directly to the data device. So, it's probably safe to check
for flush bios after commit() in process_deferred_bios() and complete
them immediately.

If you confirm too that this is safe, I will send a second version of
the patch adding the check.

Thanks,
Nikos

> - Joe
> 
