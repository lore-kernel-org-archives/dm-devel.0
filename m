From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 RESEND 2/2] blk-throttle: fix wrong initialization in
 case of dm device
Date: Thu, 18 Jan 2018 20:53:20 -0700
Message-ID: <445f3921-f257-c653-383a-b698ec552096@kernel.dk>
References: <d644ea70-4130-7cbb-fdd8-240a77481f9f@linux.alibaba.com>
 <20180119032908.GA22562@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180119032908.GA22562@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: linux-block <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, caspar@linux.alibaba.com
List-Id: dm-devel.ids

On 1/18/18 8:29 PM, Mike Snitzer wrote:
> On Thu, Jan 18 2018 at 10:09pm -0500,
> Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
> 
>> From: Joseph Qi <joseph.qi@linux.alibaba.com>
>>
>> DM device sets QUEUE_FLAG_NONROT after the queue is registered. That is
>> to mean, the previous initialization in blk_throtl_register_queue is
>> wrong in this case.
>> Fix it by checking and then updating the info during root tg
>> initialization as we don't have a better choice.
>>
>> Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
>> Reviewed-by: Shaohua Li <shli@kernel.org>
>> ---
>>  block/blk-throttle.c | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
>> index bf52035..7150f14 100644
>> --- a/block/blk-throttle.c
>> +++ b/block/blk-throttle.c
>> @@ -541,6 +541,25 @@ static void throtl_pd_init(struct blkg_policy_data *pd)
>>  	if (cgroup_subsys_on_dfl(io_cgrp_subsys) && blkg->parent)
>>  		sq->parent_sq = &blkg_to_tg(blkg->parent)->service_queue;
>>  	tg->td = td;
>> +
>> +#ifdef CONFIG_BLK_DEV_THROTTLING_LOW
>> +	/*
>> +	 * DM device sets QUEUE_FLAG_NONROT after the queue is registered,
>> +	 * so the previous initialization is wrong in this case. Check and
>> +	 * update it here.
>> +	 */
>> +	if (blk_queue_nonrot(blkg->q) &&
>> +	    td->filtered_latency != LATENCY_FILTERED_SSD) {
>> +		int i;
>> +
>> +		td->throtl_slice = DFL_THROTL_SLICE_SSD;
>> +		td->filtered_latency = LATENCY_FILTERED_SSD;
>> +		for (i = 0; i < LATENCY_BUCKET_SIZE; i++) {
>> +			td->avg_buckets[READ][i].latency = 0;
>> +			td->avg_buckets[WRITE][i].latency = 0;
>> +		}
>> +	}
>> +#endif
>>  }
>>  
>>  /*
>> -- 
>> 1.9.4
> 
> This should be fixed for 4.16, please see these block tree commits:
> http://git.kernel.dk/cgit/linux-block/commit/?h=for-4.16/block&id=fa70d2e2c4a0a54ced98260c6a176cc94c876d27
> http://git.kernel.dk/cgit/linux-block/commit/?h=for-4.16/block&id=c100ec49fdd2222836ff8a17c7bfcc7611d2ee2b
> 
> The last commit's patch header even references the previous submission
> you had for this patch with:
> 
> "These changes also stave off the need to introduce new DM-specific
> workarounds in block core, e.g. this proposal:
> https://patchwork.kernel.org/patch/10067961/"
> 

Joseph, please confirm if it works like it should with the dm tree.  The
point of Mike's work was to avoid special casing stuff like this, so
hopefully it took care of yours too.

-- 
Jens Axboe
