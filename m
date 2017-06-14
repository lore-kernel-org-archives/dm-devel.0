From: Jens Axboe <axboe@kernel.dk>
Subject: Re: block: missing break in process_queued_bios()
Date: Wed, 14 Jun 2017 08:23:46 -0600
Message-ID: <94a9d00d-f066-2ce3-c15c-224ec7079d36@kernel.dk>
References: <20170614090437.GA31017@elgon.mountain>
 <20170614131813.GA10647@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170614131813.GA10647@redhat.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>
Cc: Alasdair Kergon <agk@redhat.com>, Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: dm-devel.ids

On 06/14/2017 07:18 AM, Mike Snitzer wrote:
> On Wed, Jun 14 2017 at  5:04am -0400,
> Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
>> This used to be a fall through case, but we shifted code around and I
>> think we want a break here now.
>>
>> Fixes: 4e4cbee93d56 ("block: switch bios to blk_status_t")
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
>> index a7d2e0840cc5..0e8ab5bb3575 100644
>> --- a/drivers/md/dm-mpath.c
>> +++ b/drivers/md/dm-mpath.c
>> @@ -625,6 +625,7 @@ static void process_queued_bios(struct work_struct *work)
>>  		case DM_MAPIO_KILL:
>>  			bio->bi_status = BLK_STS_IOERR;
>>  			bio_endio(bio);
>> +			break;
>>  		case DM_MAPIO_REQUEUE:
>>  			bio->bi_status = BLK_STS_DM_REQUEUE;
>>  			bio_endio(bio);
> 
> Annoyed with myself for missing this during my review...
> 
> The subject should be:
> "dm mpath: add missing break in process_queued_bios()"
> 
> Also, this should go through Jens and I'll rebase my linux-dm branches
> accordingly.  Jens, please pick this up.
> 
> Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks, I've added it to the 4.13 branch.

-- 
Jens Axboe

