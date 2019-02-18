From: yangerkun <yangerkun@huawei.com>
Subject: Re: dm: clear BIO_SEG_VALID in clone_bio
Date: Mon, 18 Feb 2019 11:15:13 +0800
Message-ID: <a2dceb8b-12a5-714b-e48d-43e79e73c26d@huawei.com>
References: <20190214091930.121952-1-yangerkun@huawei.com>
	<20190214185536.GA15733@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190214185536.GA15733@redhat.com>
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
Cc: dm-devel@redhat.com, miaoxie@huawei.com, Ming Lei <minlei@redhat.com>, agk@redhat.com, houtao1@huawei.com
List-Id: dm-devel.ids

Hi,

Mike Snitzer wrote on 2019/2/15 2:55:
> On Thu, Feb 14 2019 at  4:19am -0500,
> yangerkun <yangerkun@huawei.com> wrote:
> 
>> Since 57c36519e4("dm: fix clone_bio() to trigger blk_recount_segments()")
>> has been reverted by fa8db494("dm: don't use bio_trim() afterall"), the
>> problem that clone bio won't trigger blk_recount_segments will exits
>> again. So just clean the flag in clone_bio.
>>
>> Fixes: fa8db4948f522("dm: don't use bio_trim() afterall")
>> Signed-off-by: yangerkun <yangerkun@huawei.com>
>> ---
>>   drivers/md/dm.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>> index 515e6af..b22ac04 100644
>> --- a/drivers/md/dm.c
>> +++ b/drivers/md/dm.c
>> @@ -1336,6 +1336,7 @@ static int clone_bio(struct dm_target_io *tio, struct bio *bio,
>>   			return r;
>>   	}
>>   
>> +	bio_clear_flag(clone, BIO_SEG_VALID);
>>   	bio_advance(clone, to_bytes(sector - clone->bi_iter.bi_sector));
>>   	clone->bi_iter.bi_size = to_bytes(len);
>>   
>> -- 
>> 2.9.5
>>
> 
> Yes, when I wrote commit fa8db4948f522 I purposely did _not_ clear
> BIO_SEG_VALID.  Commit 57c36519e4 wasn't born out of an observed need to
> blk_recount_segments() (e.g. otherwise something would fail).
> 
> So I just reverted to what DM has done in clone_bio() for quite a long
> time once using bio_trim() became a liability (since fixed in dm-crypt,
> but not staged upstream yet).
> 
> Anyway: I'm open to reconsidering, by taking your patch, if there is a
> genuine benefit/fix associated with triggering blk_recount_segments()
> for clones.  I'm unaware of why it's needed...

Re-read the code, clone_bio won't copy flags from source bio, so the 
flag bio_clear_flag of clone won't set anyway. So no need for this 
patch, Right?

Thanks,
Kun.
> 
> Mike
> 
> .
> 
