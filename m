Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA5CC433E6
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 10:31:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C6DE623770
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 10:31:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C6DE623770
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-TIU8xSXmOFGfyEQ08-zZNg-1; Fri, 08 Jan 2021 05:31:52 -0500
X-MC-Unique: TIU8xSXmOFGfyEQ08-zZNg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 090F18049CE;
	Fri,  8 Jan 2021 10:31:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1510B2C305;
	Fri,  8 Jan 2021 10:31:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9EBEF180954D;
	Fri,  8 Jan 2021 10:31:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1083OVgc003961 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Jan 2021 22:24:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A58D42166B29; Fri,  8 Jan 2021 03:24:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A06142166B28
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 03:24:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6094D858EEC
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 03:24:29 +0000 (UTC)
Received: from out30-54.freemail.mail.aliyun.com
	(out30-54.freemail.mail.aliyun.com [115.124.30.54]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-4-iIjq1cWvNxa0EdW1DzwEjg-1;
	Thu, 07 Jan 2021 22:24:26 -0500
X-MC-Unique: iIjq1cWvNxa0EdW1DzwEjg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R631e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UL1YaJf_1610076260
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UL1YaJf_1610076260) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 08 Jan 2021 11:24:20 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
	<20201223112624.78955-4-jefflexu@linux.alibaba.com>
	<20210107214758.GC21239@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <b081f3bd-fc6f-f7c1-80eb-c8380fc8e8b9@linux.alibaba.com>
Date: Fri, 8 Jan 2021 11:24:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210107214758.GC21239@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Mimecast-Bulk-Signature: yes
X-Mimecast-Spam-Signature: bulk
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 08 Jan 2021 05:31:42 -0500
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH RFC 3/7] block: add iopoll method for non-mq
 device
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 1/8/21 5:47 AM, Mike Snitzer wrote:
> On Wed, Dec 23 2020 at  6:26am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> ->poll_fn is introduced in commit ea435e1b9392 ("block: add a poll_fn
>> callback to struct request_queue") for supporting non-mq queues such as
>> nvme multipath, but removed in commit 529262d56dbe ("block: remove
>> ->poll_fn").
>>
>> To add support of IO polling for non-mq device, this method need to be
>> back. Since commit c62b37d96b6e ("block: move ->make_request_fn to
>> struct block_device_operations") has moved all callbacks into struct
>> block_device_operations in gendisk, we also add the new method named
>> ->iopoll in block_device_operations.
> 
> Please update patch subject and header to:
> 
> block: add iopoll method to support bio-based IO polling
> 
> ->poll_fn was introduced in commit ea435e1b9392 ("block: add a poll_fn
> callback to struct request_queue") to support bio-based queues such as
> nvme multipath, but was later removed in commit 529262d56dbe ("block:
> remove ->poll_fn").
> 
> Given commit c62b37d96b6e ("block: move ->make_request_fn to struct
> block_device_operations") restore the possibility of bio-based IO
> polling support by adding an ->iopoll method to gendisk->fops.
> Elevate bulk of blk_mq_poll() implementation to blk_poll() and reduce
> blk_mq_poll() to blk-mq specific code that is called from blk_poll().
> 
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  block/blk-core.c       | 79 ++++++++++++++++++++++++++++++++++++++++++
>>  block/blk-mq.c         | 70 +++++--------------------------------
>>  include/linux/blk-mq.h |  3 ++
>>  include/linux/blkdev.h |  1 +
>>  4 files changed, 92 insertions(+), 61 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 96e5fcd7f071..2f5c51ce32e3 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1131,6 +1131,85 @@ blk_qc_t submit_bio(struct bio *bio)
>>  }
>>  EXPORT_SYMBOL(submit_bio);
>>  
>> +static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
>> +{
>> +	struct blk_mq_hw_ctx *hctx;
>> +
>> +	/* TODO: bio-based device doesn't support hybrid poll. */
>> +	if (!queue_is_mq(q))
>> +		return false;
>> +
>> +	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
>> +	if (blk_mq_poll_hybrid(q, hctx, cookie))
>> +		return true;
>> +
>> +	hctx->poll_considered++;
>> +	return false;
>> +}
> 
> I don't see where you ever backfill bio-based hybrid support (in
> the following patches in this series, so it is lingering TODO).

Yes the hybrid polling is not implemented and thus bypassed for
bio-based device currently.

> 
>> +
>> +/**
>> + * blk_poll - poll for IO completions
>> + * @q:  the queue
>> + * @cookie: cookie passed back at IO submission time
>> + * @spin: whether to spin for completions
>> + *
>> + * Description:
>> + *    Poll for completions on the passed in queue. Returns number of
>> + *    completed entries found. If @spin is true, then blk_poll will continue
>> + *    looping until at least one completion is found, unless the task is
>> + *    otherwise marked running (or we need to reschedule).
>> + */
>> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>> +{
>> +	long state;
>> +
>> +	if (!blk_qc_t_valid(cookie) ||
>> +	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
>> +		return 0;
>> +
>> +	if (current->plug)
>> +		blk_flush_plug_list(current->plug, false);
>> +
>> +	/*
>> +	 * If we sleep, have the caller restart the poll loop to reset
>> +	 * the state. Like for the other success return cases, the
>> +	 * caller is responsible for checking if the IO completed. If
>> +	 * the IO isn't complete, we'll get called again and will go
>> +	 * straight to the busy poll loop. If specified not to spin,
>> +	 * we also should not sleep.
>> +	 */
>> +	if (spin && blk_poll_hybrid(q, cookie))
>> +		return 1;
>> +
>> +	state = current->state;
>> +	do {
>> +		int ret;
>> +		struct gendisk *disk = queue_to_disk(q);
>> +
>> +		if (disk->fops->iopoll)
>> +			ret = disk->fops->iopoll(q, cookie);
>> +		else
>> +			ret = blk_mq_poll(q, cookie);

The original code is indeed buggy. For bio-based device, ->iopoll() may
not be implemented while QUEUE_FLAG_POLL flag is still set, in which
case blk_mq_poll() will be called for this bio-based device.

> 
> Really don't like that blk-mq is needlessly getting gendisk and checking
> disk->fops->iopoll.
> 
> This is just to give an idea, whitespace damaged due to coding in mail
> client, but why not remove above blk_poll_hybrid() and do:
> 
> struct blk_mq_hw_ctx *hctx = NULL;
> struct gendisk *disk = NULL;
> ...
> 
> if (queue_is_mq(q)) {
> 	/*
> 	 * If we sleep, have the caller restart the poll loop to reset
> 	 * the state. Like for the other success return cases, the
> 	 * caller is responsible for checking if the IO completed. If
> 	 * the IO isn't complete, we'll get called again and will go
> 	 * straight to the busy poll loop. If specified not to spin,
> 	 * we also should not sleep.
> 	 */
> 	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> 	if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
> 		return 1;
> 	hctx->poll_considered++;   
> } else {
> 	disk = queue_to_disk(q);
> }
> 
> do {
> 	int ret;
> 
> 	if (hctx)
> 	        ret = blk_mq_poll(q, hctx, cookie);
> 	else if (disk->fops->iopoll)
> 		ret = disk->fops->iopoll(q, cookie);
> 		

Regards.


>> +		if (ret > 0) {
>> +			__set_current_state(TASK_RUNNING);
>> +			return ret;
>> +		}
>> +
>> +		if (signal_pending_state(state, current))
>> +			__set_current_state(TASK_RUNNING);
>> +
>> +		if (current->state == TASK_RUNNING)
>> +			return 1;
>> +		if (ret < 0 || !spin)
>> +			break;
>> +		cpu_relax();
>> +	} while (!need_resched());
>> +
>> +	__set_current_state(TASK_RUNNING);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(blk_poll);
>> +
>>  /**
>>   * blk_cloned_rq_check_limits - Helper function to check a cloned request
>>   *                              for the new queue limits
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index b09ce00cc6af..85258958e9f1 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -3818,8 +3818,8 @@ static bool blk_mq_poll_hybrid_sleep(struct request_queue *q,
>>  	return true;
>>  }
>>  
>> -static bool blk_mq_poll_hybrid(struct request_queue *q,
>> -			       struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
>> +bool blk_mq_poll_hybrid(struct request_queue *q,
>> +			struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
>>  {
>>  	struct request *rq;
>>  
>> @@ -3843,72 +3843,20 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
>>  	return blk_mq_poll_hybrid_sleep(q, rq);
>>  }
>>  
>> -/**
>> - * blk_poll - poll for IO completions
>> - * @q:  the queue
>> - * @cookie: cookie passed back at IO submission time
>> - * @spin: whether to spin for completions
>> - *
>> - * Description:
>> - *    Poll for completions on the passed in queue. Returns number of
>> - *    completed entries found. If @spin is true, then blk_poll will continue
>> - *    looping until at least one completion is found, unless the task is
>> - *    otherwise marked running (or we need to reschedule).
>> - */
>> -int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>> +int blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
>>  {
>> +	int ret;
>>  	struct blk_mq_hw_ctx *hctx;
>> -	long state;
>> -
>> -	if (!blk_qc_t_valid(cookie) ||
>> -	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
>> -		return 0;
>> -
>> -	if (current->plug)
>> -		blk_flush_plug_list(current->plug, false);
>>  
>>  	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> 
> 
> Given my suggested code changes above, pass hctx in to blk_mq_poll() to
> avoid redundant code to access it in q->queue_hw_ctx[], so:
> 
> int blk_mq_poll(struct request_queue *q,
>     		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
> 

Regards.

>> -	/*
>> -	 * If we sleep, have the caller restart the poll loop to reset
>> -	 * the state. Like for the other success return cases, the
>> -	 * caller is responsible for checking if the IO completed. If
>> -	 * the IO isn't complete, we'll get called again and will go
>> -	 * straight to the busy poll loop. If specified not to spin,
>> -	 * we also should not sleep.
>> -	 */
>> -	if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
>> -		return 1;
>> -
>> -	hctx->poll_considered++;
>> +	hctx->poll_invoked++;
>> +	ret = q->mq_ops->poll(hctx);
>> +	if (ret > 0)
>> +		hctx->poll_success++;
>>  
>> -	state = current->state;
>> -	do {
>> -		int ret;
>> -
>> -		hctx->poll_invoked++;
>> -
>> -		ret = q->mq_ops->poll(hctx);
>> -		if (ret > 0) {
>> -			hctx->poll_success++;
>> -			__set_current_state(TASK_RUNNING);
>> -			return ret;
>> -		}
>> -
>> -		if (signal_pending_state(state, current))
>> -			__set_current_state(TASK_RUNNING);
>> -
>> -		if (current->state == TASK_RUNNING)
>> -			return 1;
>> -		if (ret < 0 || !spin)
>> -			break;
>> -		cpu_relax();
>> -	} while (!need_resched());
>> -
>> -	__set_current_state(TASK_RUNNING);
>> -	return 0;
>> +	return ret;
>>  }
>> -EXPORT_SYMBOL_GPL(blk_poll);
>>  
>>  unsigned int blk_mq_rq_cpu(struct request *rq)
>>  {
>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
>> index 47b021952ac7..032e08ecd42e 100644
>> --- a/include/linux/blk-mq.h
>> +++ b/include/linux/blk-mq.h
>> @@ -607,6 +607,9 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
>>  }
>>  
>>  blk_qc_t blk_mq_submit_bio(struct bio *bio);
>> +int blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
>> +bool blk_mq_poll_hybrid(struct request_queue *q,
>> +		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
>>  void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
>>  		struct lock_class_key *key);
>>  
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 2303d06a5a82..e8965879eb90 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1845,6 +1845,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
>>  
>>  struct block_device_operations {
>>  	blk_qc_t (*submit_bio) (struct bio *bio);
>> +	int (*iopoll)(struct request_queue *q, blk_qc_t cookie);
>>  	int (*open) (struct block_device *, fmode_t);
>>  	void (*release) (struct gendisk *, fmode_t);
>>  	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
>> -- 
>> 2.27.0
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

