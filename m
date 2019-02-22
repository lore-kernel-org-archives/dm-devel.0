From: Jens Axboe <axboe@kernel.dk>
Subject: Re: block: be more careful about status in __bio_chain_endio
Date: Fri, 22 Feb 2019 15:46:43 -0700
Message-ID: <7f0aeb7b-fdaa-0625-f785-05c342047550@kernel.dk>
References: <70cda2a3-f246-d45b-f600-1f9d15ba22ff@gmail.com>
 <87eflmpqkb.fsf@notabene.neil.brown.name> <20190222211006.GA10987@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222211006.GA10987@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, NeilBrown <neilb@suse.com>
Cc: linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Milan Broz <gmazyland@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: dm-devel.ids

On 2/22/19 2:10 PM, Mike Snitzer wrote:
> On Thu, Feb 15 2018 at  4:09am -0500,
> NeilBrown <neilb@suse.com> wrote:
> 
>>
>> If two bios are chained under the one parent (with bio_chain())
>> it is possible that one will succeed and the other will fail.
>> __bio_chain_endio must ensure that the failure error status
>> is reported for the whole, rather than the success.
>>
>> It currently tries to be careful, but this test is racy.
>> If both children finish at the same time, they might both see that
>> parent->bi_status as zero, and so will assign their own status.
>> If the assignment to parent->bi_status by the successful bio happens
>> last, the error status will be lost which can lead to silent data
>> corruption.
>>
>> Instead, __bio_chain_endio should only assign a non-zero status
>> to parent->bi_status.  There is then no need to test the current
>> value of parent->bi_status - a test that would be racy anyway.
>>
>> Note that this bug hasn't been seen in practice.  It was only discovered
>> by examination after a similar bug was found in dm.c
>>
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>  block/bio.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/block/bio.c b/block/bio.c
>> index e1708db48258..ad77140edc6f 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -312,7 +312,7 @@ static struct bio *__bio_chain_endio(struct bio *bio)
>>  {
>>  	struct bio *parent = bio->bi_private;
>>  
>> -	if (!parent->bi_status)
>> +	if (bio->bi_status)
>>  		parent->bi_status = bio->bi_status;
>>  	bio_put(bio);
>>  	return parent;
>> -- 
>> 2.14.0.rc0.dirty
>>
> 
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>
> 
> Jens, this one slipped through the crack just over a year ago.
> It is available in patchwork here:
> https://patchwork.kernel.org/patch/10220727/

Should this be:

	if (!parent->bi_status && bio->bi_status)
		parent->bi_status = bio->bi_status;

perhaps?

-- 
Jens Axboe
