From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: dm raid1: "mirror" target doesn't use all available
 legs on multiple failures
Date: Tue, 11 Oct 2016 16:56:47 +0200
Message-ID: <490142e7-1fd4-19ad-5537-9ffbd44718c6@redhat.com>
References: <1476118086-2975-1-git-send-email-heinzm@redhat.com>
	<20161010204126.GA20089@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20161010204126.GA20089@redhat.com>
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
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 10/10/2016 10:41 PM, Mike Snitzer wrote:
> On Mon, Oct 10 2016 at 12:48pm -0400,
> Heinz Mauelshagen <heinzm@redhat.com> wrote:
>
>> In case legs of a "mirror" target fail, any read will cause a new,
>> operational default leg to be selected and the read be resubmitted
>> to it. If that new default leg fails the read too, no other still
>> accessible legs are used to resubmit the read again thus failing
>> the io.
>>
>> Fix by allowing the read to get resubmitted until there's no
>> operational legs any more.
>>
>> Resolves: rhbz1383444
>>
>> Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
> Nothing seems to be checking bio_record->details.bi_bdev anymore.
> (The one you've removed really seems like a complete hack to begin with)

The very point of removing "if (!bio_record->details.bi_bdev) { ..." is
to  allow for resubmission of read bios to any other still operational leg
after an initial resubmission failed.
do_reads() will conditionally error the bio in case there are none or
no in sync ones available.

The "mirror" processing for read bios is:
1) bio gets remapped to the default mirror in mirror_map() if region is
     in sync our queued to the worker for submission
2) mirror_end_io() spots read error and requeues to the worker
3) worker
     - submits bio to new, selected default if respective region is in sync
     or
     - fails bio if it aims at a non synchronized region
4) if not already failed in do_reads(),
     mirror_end_io() processes like in step 1 _but_
     errors the read because of the "if (!bio_record->details.bi_bdev) { 
..."


My patch changes step 4 by removing the conditional to resubmit it
again in case any other operational leg is available. If none's available,
mirror_end_io() errors the read bios or the do_reads error logic applies
in case of a resubmission.

Why do you think this to be a hack?

>
> Shouldn't this patch go further by removing the other 2 places that set
> bio_record->details.bi_bdev = NULL; ?

Yes, that's a good cleanup.

Let's first settle any still open issues like other unspotted side effects
and I'll do a patch v2 with it.

>
>> ---
>>   drivers/md/dm-raid1.c | 11 -----------
>>   1 file changed, 11 deletions(-)
>>
>> diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
>> index 7a6254d..dd31019 100644
>> --- a/drivers/md/dm-raid1.c
>> +++ b/drivers/md/dm-raid1.c
>> @@ -1266,16 +1266,6 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
>>   		goto out;
>>   
>>   	if (unlikely(error)) {
>> -		if (!bio_record->details.bi_bdev) {
>> -			/*
>> -			 * There wasn't enough memory to record necessary
>> -			 * information for a retry or there was no other
>> -			 * mirror in-sync.
>> -			 */
>> -			DMERR_LIMIT("Mirror read failed.");
>> -			return -EIO;
>> -		}
>> -
>>   		m = bio_record->m;
>>   
>>   		DMERR("Mirror read failed from %s. Trying alternative device.",
>> @@ -1291,7 +1281,6 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
>>   			bd = &bio_record->details;
>>   
>>   			dm_bio_restore(bd, bio);
>> -			bio_record->details.bi_bdev = NULL;
>>   			bio->bi_error = 0;
>>   
>>   			queue_bio(ms, bio, rw);
>> -- 
>> 2.7.4
>>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
