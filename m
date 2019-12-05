From: Nikos Tsironis <ntsironis@arrikto.com>
Subject: Re: [PATCH 3/3] dm clone: Flush destination device
 before committing metadata
Date: Fri, 6 Dec 2019 00:42:11 +0200
Message-ID: <09f5d4a1-1405-5304-105c-6140cdffa46b@arrikto.com>
References: <20191204140654.26214-1-ntsironis@arrikto.com>
	<20191204140654.26214-4-ntsironis@arrikto.com>
	<20191205194651.GC95063@lobo> <20191205200747.GA6447@redhat.com>
	<7f5b0f44-2d16-db40-6d16-08929d5bebfe@arrikto.com>
	<20191205220915.GA7024@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191205220915.GA7024@redhat.com>
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
Cc: vkoukis@arrikto.com, dm-devel@redhat.com, agk@redhat.com, iliastsi@arrikto.com
List-Id: dm-devel.ids

On 12/6/19 12:09 AM, Mike Snitzer wrote:
> On Thu, Dec 05 2019 at  4:49pm -0500,
> Nikos Tsironis <ntsironis@arrikto.com> wrote:
> 
>> On 12/5/19 10:07 PM, Mike Snitzer wrote:
>>> On Thu, Dec 05 2019 at  2:46pm -0500,
>>> Mike Snitzer <snitzer@redhat.com> wrote:
>>>
>>>> On Wed, Dec 04 2019 at  9:06P -0500,
>>>> Nikos Tsironis <ntsironis@arrikto.com> wrote:
>>>>
>>>>> dm-clone maintains an on-disk bitmap which records which regions are
>>>>> valid in the destination device, i.e., which regions have already been
>>>>> hydrated, or have been written to directly, via user I/O.
>>>>>
>>>>> Setting a bit in the on-disk bitmap meas the corresponding region is
>>>>> valid in the destination device and we redirect all I/O regarding it to
>>>>> the destination device.
>>>>>
>>>>> Suppose the destination device has a volatile write-back cache and the
>>>>> following sequence of events occur:
>>>>>
>>>>> 1. A region gets hydrated, either through the background hydration or
>>>>>     because it was written to directly, via user I/O.
>>>>>
>>>>> 2. The commit timeout expires and we commit the metadata, marking that
>>>>>     region as valid in the destination device.
>>>>>
>>>>> 3. The system crashes and the destination device's cache has not been
>>>>>     flushed, meaning the region's data are lost.
>>>>>
>>>>> The next time we read that region we read it from the destination
>>>>> device, since the metadata have been successfully committed, but the
>>>>> data are lost due to the crash, so we read garbage instead of the old
>>>>> data.
>>>>>
>>>>> This has several implications:
>>>>>
>>>>> 1. In case of background hydration or of writes with size smaller than
>>>>>     the region size (which means we first copy the whole region and then
>>>>>     issue the smaller write), we corrupt data that the user never
>>>>>     touched.
>>>>>
>>>>> 2. In case of writes with size equal to the device's logical block size,
>>>>>     we fail to provide atomic sector writes. When the system recovers the
>>>>>     user will read garbage from the sector instead of the old data or the
>>>>>     new data.
>>>>>
>>>>> 3. In case of writes without the FUA flag set, after the system
>>>>>     recovers, the written sectors will contain garbage instead of a
>>>>>     random mix of sectors containing either old data or new data, thus we
>>>>>     fail again to provide atomic sector writes.
>>>>>
>>>>> 4. Even when the user flushes the dm-clone device, because we first
>>>>>     commit the metadata and then pass down the flush, the same risk for
>>>>>     corruption exists (if the system crashes after the metadata have been
>>>>>     committed but before the flush is passed down).
>>>>>
>>>>> The only case which is unaffected is that of writes with size equal to
>>>>> the region size and with the FUA flag set. But, because FUA writes
>>>>> trigger metadata commits, this case can trigger the corruption
>>>>> indirectly.
>>>>>
>>>>> To solve this and avoid the potential data corruption we flush the
>>>>> destination device **before** committing the metadata.
>>>>>
>>>>> This ensures that any freshly hydrated regions, for which we commit the
>>>>> metadata, are properly written to non-volatile storage and won't be lost
>>>>> in case of a crash.
>>>>>
>>>>> Fixes: 7431b7835f55 ("dm: add clone target")
>>>>> Cc: stable@vger.kernel.org # v5.4+
>>>>> Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
>>>>> ---
>>>>>   drivers/md/dm-clone-target.c | 46 ++++++++++++++++++++++++++++++++++++++------
>>>>>   1 file changed, 40 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
>>>>> index 613c913c296c..d1e1b5b56b1b 100644
>>>>> --- a/drivers/md/dm-clone-target.c
>>>>> +++ b/drivers/md/dm-clone-target.c
>>>>> @@ -86,6 +86,12 @@ struct clone {
>>>>>   	struct dm_clone_metadata *cmd;
>>>>> +	/*
>>>>> +	 * bio used to flush the destination device, before committing the
>>>>> +	 * metadata.
>>>>> +	 */
>>>>> +	struct bio flush_bio;
>>>>> +
>>>>>   	/* Region hydration hash table */
>>>>>   	struct hash_table_bucket *ht;
>>>>> @@ -1108,10 +1114,13 @@ static bool need_commit_due_to_time(struct clone *clone)
>>>>>   /*
>>>>>    * A non-zero return indicates read-only or fail mode.
>>>>>    */
>>>>> -static int commit_metadata(struct clone *clone)
>>>>> +static int commit_metadata(struct clone *clone, bool *dest_dev_flushed)
>>>>>   {
>>>>>   	int r = 0;
>>>>> +	if (dest_dev_flushed)
>>>>> +		*dest_dev_flushed = false;
>>>>> +
>>>>>   	mutex_lock(&clone->commit_lock);
>>>>>   	if (!dm_clone_changed_this_transaction(clone->cmd))
>>>>> @@ -1128,6 +1137,19 @@ static int commit_metadata(struct clone *clone)
>>>>>   		goto out;
>>>>>   	}
>>>>> +	bio_reset(&clone->flush_bio);
>>>>> +	bio_set_dev(&clone->flush_bio, clone->dest_dev->bdev);
>>>>> +	clone->flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
>>>>> +
>>>>> +	r = submit_bio_wait(&clone->flush_bio);
>>>>> +	if (unlikely(r)) {
>>>>> +		__metadata_operation_failed(clone, "flush destination device", r);
>>>>> +		goto out;
>>>>> +	}
>>>>> +
>>>>> +	if (dest_dev_flushed)
>>>>> +		*dest_dev_flushed = true;
>>>>> +
>>>>>   	r = dm_clone_metadata_commit(clone->cmd);
>>>>>   	if (unlikely(r)) {
>>>>>   		__metadata_operation_failed(clone, "dm_clone_metadata_commit", r);
>>>>> @@ -1199,6 +1221,7 @@ static void process_deferred_bios(struct clone *clone)
>>>>>   static void process_deferred_flush_bios(struct clone *clone)
>>>>>   {
>>>>>   	struct bio *bio;
>>>>> +	bool dest_dev_flushed;
>>>>>   	struct bio_list bios = BIO_EMPTY_LIST;
>>>>>   	struct bio_list bio_completions = BIO_EMPTY_LIST;
>>>>> @@ -1218,7 +1241,7 @@ static void process_deferred_flush_bios(struct clone *clone)
>>>>>   	    !(dm_clone_changed_this_transaction(clone->cmd) && need_commit_due_to_time(clone)))
>>>>>   		return;
>>>>> -	if (commit_metadata(clone)) {
>>>>> +	if (commit_metadata(clone, &dest_dev_flushed)) {
>>>>>   		bio_list_merge(&bios, &bio_completions);
>>>>>   		while ((bio = bio_list_pop(&bios)))
>>>>> @@ -1232,8 +1255,17 @@ static void process_deferred_flush_bios(struct clone *clone)
>>>>>   	while ((bio = bio_list_pop(&bio_completions)))
>>>>>   		bio_endio(bio);
>>>>> -	while ((bio = bio_list_pop(&bios)))
>>>>> -		generic_make_request(bio);
>>>>> +	while ((bio = bio_list_pop(&bios))) {
>>>>> +		if ((bio->bi_opf & REQ_PREFLUSH) && dest_dev_flushed) {
>>>>> +			/* We just flushed the destination device as part of
>>>>> +			 * the metadata commit, so there is no reason to send
>>>>> +			 * another flush.
>>>>> +			 */
>>>>> +			bio_endio(bio);
>>>>> +		} else {
>>>>> +			generic_make_request(bio);
>>>>> +		}
>>>>> +	}
>>>>>   }
>>>>>   static void do_worker(struct work_struct *work)
>>>>> @@ -1405,7 +1437,7 @@ static void clone_status(struct dm_target *ti, status_type_t type,
>>>>>   		/* Commit to ensure statistics aren't out-of-date */
>>>>>   		if (!(status_flags & DM_STATUS_NOFLUSH_FLAG) && !dm_suspended(ti))
>>>>> -			(void) commit_metadata(clone);
>>>>> +			(void) commit_metadata(clone, NULL);
>>>>>   		r = dm_clone_get_free_metadata_block_count(clone->cmd, &nr_free_metadata_blocks);
>>>>> @@ -1839,6 +1871,7 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>>>>>   	bio_list_init(&clone->deferred_flush_completions);
>>>>>   	clone->hydration_offset = 0;
>>>>>   	atomic_set(&clone->hydrations_in_flight, 0);
>>>>> +	bio_init(&clone->flush_bio, NULL, 0);
>>>>>   	clone->wq = alloc_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM, 0);
>>>>>   	if (!clone->wq) {
>>>>> @@ -1912,6 +1945,7 @@ static void clone_dtr(struct dm_target *ti)
>>>>>   	struct clone *clone = ti->private;
>>>>>   	mutex_destroy(&clone->commit_lock);
>>>>> +	bio_uninit(&clone->flush_bio);
>>>>>   	for (i = 0; i < clone->nr_ctr_args; i++)
>>>>>   		kfree(clone->ctr_args[i]);
>>>>> @@ -1966,7 +2000,7 @@ static void clone_postsuspend(struct dm_target *ti)
>>>>>   	wait_event(clone->hydration_stopped, !atomic_read(&clone->hydrations_in_flight));
>>>>>   	flush_workqueue(clone->wq);
>>>>> -	(void) commit_metadata(clone);
>>>>> +	(void) commit_metadata(clone, NULL);
>>>>>   }
>>>>>   static void clone_resume(struct dm_target *ti)
>>>>> -- 
>>>>> 2.11.0
>>>>>
>>>>
>>>>
>>>> Like the dm-thin patch I replied to, would rather avoid open-coding
>>>> blkdev_issue_flush (also I check !bio_has_data), here is incremental:
>>>
>>> Sorry for the noise relative to !bio_has_data check.. we don't need it.
>>> DM core will split flush from data (see dec_pending()'s  REQ_PREFLUSH
>>> check).
>>>
>>
>> It's OK. I know this, that's why I didn't put the !bio_has_data check in
>> the first place.
>>
>>> I'm dropping the extra !bio_has_data() checks from the incrementals I
>>> did; will review again and push out to linux-next.. still have time to
>>> change if you fundamentally disagree with using blkdev_issue_flush()
>>>
>>
>> For dm-clone, I didn't use blkdev_issue_flush() to avoid allocating and
>> freeing a new bio every time we commit the metadata. I haven't measured
>> the allocation/freeing overhead and probably it won't be huge, but still
>> I would like to avoid it, if you don't mind.
> 
> That's fine, I've restored your code.
>   
>> For dm-thin, indeed, there is not much to gain by not using
>> blkdev_issue_flush(), since we still allocate a new bio, indirectly, in
>> the stack.
> 
> But thinp obviously could if there is actual benefit to avoiding this
> flush bio allocation, via blkdev_issue_flush, every commit.
> 

Yes, we could do the flush in thinp exactly the same way we do it in
dm-clone. Add a struct bio field in struct pool_c and use that in the
callback.

It would work since the callback is called holding a write lock on
pmd->root_lock, so it's executed only by a single thread at a time.

I didn't go for it in my implementation, because I didn't like having to
make that assumption in the callback, i.e., that it's executed under a
lock and so it's safe to have the bio in struct pool_c.

In hindsight, maybe this was a bad call, since it's technically feasible
to do it this way and we could just add a comment stating that the
callback is executed atomically.

If you want I can send a new follow-on patch tomorrow implementing the
flush in thinp the same way it's implemented in dm-clone.

Nikos

> Mike
> 
