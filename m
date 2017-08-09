From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 4/9] md: raid5 nowait support
Date: Wed, 9 Aug 2017 06:45:09 -0500
Message-ID: <4cb8677e-7717-2f00-b5d9-c7aa3ab1c51d@suse.de>
References: <20170726235806.12148-1-rgoldwyn@suse.de>
 <20170726235806.12148-5-rgoldwyn@suse.de>
 <20170808204343.mzt5ujazevrkyro3@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170808204343.mzt5ujazevrkyro3@kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-block@vger.kernel.org, hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids



On 08/08/2017 03:43 PM, Shaohua Li wrote:
> On Wed, Jul 26, 2017 at 06:58:01PM -0500, Goldwyn Rodrigues wrote:
>> From: Goldwyn Rodrigues <rgoldwyn@suse.com>
>>
>> Return EAGAIN in case RAID5 would block because of waiting due to:
>>  + Reshaping
>>  + Suspension
>>  + Stripe Expansion
>>
>> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
>> ---
>>  drivers/md/raid5.c | 20 ++++++++++++++++++++
>>  1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index aeeb8d6854e2..d1b3bcf26d29 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5635,6 +5635,11 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>>  				    ? logical_sector < conf->reshape_safe
>>  				    : logical_sector >= conf->reshape_safe) {
>>  					spin_unlock_irq(&conf->device_lock);
>> +					if (bi->bi_opf & REQ_NOWAIT) {
>> +						bio_wouldblock_error(bi);
>> +						finish_wait(&conf->wait_for_overlap, &w);
>> +						return true;
>> +					}
> 
> A bio could use several stripes. If one stripe block, simpliy return bio here
> doesn't really make the whole bio finish.

My understanding is a little weak here.
How would you have to terminate the entire bio since one of the stripes
is blocking?

> 
>>  					schedule();
>>  					do_prepare = true;
>>  					goto retry;
>> @@ -5672,6 +5677,11 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>>  				spin_unlock_irq(&conf->device_lock);
>>  				if (must_retry) {
>>  					raid5_release_stripe(sh);
>> +					if (bi->bi_opf & REQ_NOWAIT) {
>> +						bio_wouldblock_error(bi);
>> +						finish_wait(&conf->wait_for_overlap, &w);
>> +						return true;
>> +					}
>>  					schedule();
>>  					do_prepare = true;
>>  					goto retry;
>> @@ -5700,6 +5710,11 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>>  					sigset_t full, old;
>>  					sigfillset(&full);
>>  					sigprocmask(SIG_BLOCK, &full, &old);
>> +					if (bi->bi_opf & REQ_NOWAIT) {
>> +						bio_wouldblock_error(bi);
>> +						finish_wait(&conf->wait_for_overlap, &w);
>> +						return true;
>> +					}
>>  					schedule();
>>  					sigprocmask(SIG_SETMASK, &old, NULL);
>>  					do_prepare = true;
>> @@ -5715,6 +5730,11 @@ static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
>>  				 */
>>  				md_wakeup_thread(mddev->thread);
>>  				raid5_release_stripe(sh);
>> +				if (bi->bi_opf & REQ_NOWAIT) {
>> +					bio_wouldblock_error(bi);
>> +					finish_wait(&conf->wait_for_overlap, &w);
>> +					return true;
>> +				}
>>  				schedule();
>>  				do_prepare = true;
>>  				goto retry;
>> -- 
>> 2.12.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Goldwyn
