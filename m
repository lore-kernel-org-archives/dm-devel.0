From: Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH v3 RESEND 2/2] blk-throttle: fix wrong initialization in
 case of dm device
Date: Fri, 19 Jan 2018 11:57:34 +0800
Message-ID: <47c56350-e27a-245c-14fd-3ed5b1f39765@linux.alibaba.com>
References: <d644ea70-4130-7cbb-fdd8-240a77481f9f@linux.alibaba.com>
 <20180119032908.GA22562@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180119032908.GA22562@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, caspar@linux.alibaba.com
List-Id: dm-devel.ids

Hi Mike,

On 18/1/19 11:29, Mike Snitzer wrote:
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
Yes, if we call dm_table_set_restrictions before blk_register_queue now,
we can make sure the initialization is correct by checking whether flag
QUEUE_FLAG_NONROT is set or not. So my patch is no longer needed.
Jens, please ignore this patch, thanks.

Thanks,
Joseph
