Return-Path: <SRS0=OpRm=H4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D20C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 26 Feb 2021 08:42:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2045F64EE7
	for <dm-devel@archiver.kernel.org>; Fri, 26 Feb 2021 08:42:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2045F64EE7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-PidwaxvZNMCwuz2ar_LyRg-1; Fri, 26 Feb 2021 03:42:52 -0500
X-MC-Unique: PidwaxvZNMCwuz2ar_LyRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ED42918B62A4;
	Fri, 26 Feb 2021 08:42:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9ED1C60BF3;
	Fri, 26 Feb 2021 08:42:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 3F48018095CC;
	Fri, 26 Feb 2021 08:42:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11Q8CZdj031353 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Feb 2021 03:12:35 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2CCEE2166B2D; Fri, 26 Feb 2021 08:12:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25D742166B27
	for <dm-devel@redhat.com>; Fri, 26 Feb 2021 08:12:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 80816800B28
	for <dm-devel@redhat.com>; Fri, 26 Feb 2021 08:12:32 +0000 (UTC)
Received: from out30-44.freemail.mail.aliyun.com
	(out30-44.freemail.mail.aliyun.com [115.124.30.44]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-19-FiWtwP-PNh2P_D1N85Dybw-1;
	Fri, 26 Feb 2021 03:12:25 -0500
X-MC-Unique: FiWtwP-PNh2P_D1N85Dybw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R861e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04394;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=9; SR=0;
	TI=SMTPD_---0UPckvXq_1614327140
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UPckvXq_1614327140) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 26 Feb 2021 16:12:20 +0800
To: Mikulas Patocka <mpatocka@redhat.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
	<20210208085243.82367-12-jefflexu@linux.alibaba.com>
	<alpine.LRH.2.02.2102191351200.10545@file01.intranet.prod.int.rdu2.redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <af9223b9-8960-1ed4-799a-bcd56299c587@linux.alibaba.com>
Date: Fri, 26 Feb 2021 16:12:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2102191351200.10545@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 26 Feb 2021 03:42:42 -0500
Cc: axboe@kernel.dk, snitzer@redhat.com, caspar@linux.alibaba.com, hch@lst.de,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v3 11/11] dm: fastpath of bio-based polling
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 2/20/21 3:38 AM, Mikulas Patocka wrote:
> 
> 
> On Mon, 8 Feb 2021, Jeffle Xu wrote:
> 
>> Offer one fastpath of bio-based polling when bio submitted to dm device
>> is not split.
>>
>> In this case, there will be only one bio submitted to only one polling
>> hw queue of one underlying mq device, and thus we don't need to track
>> all split bios or iterate through all polling hw queues. The pointer to
>> the polling hw queue the bio submitted to is returned here as the
>> returned cookie.
> 
> This doesn't seem safe - note that between submit_bio() and blk_poll(), no 
> locks are held - so the device mapper device may be reconfigured 
> arbitrarily. When you call blk_poll() with a pointer returned by 
> submit_bio(), the pointer may point to a stale address.
> 

Thanks for the feedback. Indeed maybe it's not a good idea to directly
return a 'struct blk_mq_hw_ctx *' pointer as the returned cookie.

Currently I have no idea to fix it, orz... The
blk_get_queue()/blk_put_queue() tricks may not work in this case.
Because the returned cookie may not be used at all. Before calling
blk_poll(), the polling routine may find that the corresponding IO has
already completed, and thus won't call blk_poll(), in which case we have
no place to put the refcount.

But I really don't want to drop this optimization, since this
optimization is quite intuitive when dm device maps to a lot of
underlying devices. Though this optimization doesn't actually achieve
reasonable performance gain in my test, maybe because there are at most
seven nvme devices in my test machine.

Any thoughts?

Thanks,
Jeffle


> 
>> In this case, the polling routine will call
>> mq_ops->poll() directly with the hw queue converted from the input
>> cookie.
>>
>> If the original bio submitted to dm device is split to multiple bios and
>> thus submitted to multiple polling hw queues, the bio submission routine
>> will return BLK_QC_T_BIO_MULTI, while the polling routine will fall
>> back to iterating all hw queues (in polling mode) of all underlying mq
>> devices.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  block/blk-core.c          | 33 +++++++++++++++++++++++++++++++--
>>  include/linux/blk_types.h |  8 ++++++++
>>  include/linux/types.h     |  2 +-
>>  3 files changed, 40 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 37aa513da5f2..cb24b33a4870 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -956,11 +956,19 @@ static blk_qc_t __submit_bio(struct bio *bio)
>>   * bio_list_on_stack[0] contains bios submitted by the current ->submit_bio.
>>   * bio_list_on_stack[1] contains bios that were submitted before the current
>>   *	->submit_bio_bio, but that haven't been processed yet.
>> + *
>> + * Return:
>> + *   - BLK_QC_T_NONE, no need for IO polling.
>> + *   - BLK_QC_T_BIO_MULTI, @bio gets split and enqueued into multi hw queues.
>> + *   - Otherwise, @bio is not split, returning the pointer to the corresponding
>> + *     hw queue that the bio enqueued into as the returned cookie.
>>   */
>>  static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  {
>>  	struct bio_list bio_list_on_stack[2];
>>  	blk_qc_t ret = BLK_QC_T_NONE;
>> +	struct request_queue *top_q = bio->bi_disk->queue;
>> +	bool poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags);
>>  
>>  	BUG_ON(bio->bi_next);
>>  
>> @@ -968,6 +976,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  	current->bio_list = bio_list_on_stack;
>>  
>>  	do {
>> +		blk_qc_t cookie;
>>  		struct request_queue *q = bio->bi_disk->queue;
>>  		struct bio_list lower, same;
>>  
>> @@ -980,7 +989,20 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>>  		bio_list_init(&bio_list_on_stack[0]);
>>  
>> -		ret = __submit_bio(bio);
>> +		cookie = __submit_bio(bio);
>> +
>> +		if (poll_on &&
>> +		    blk_qc_t_bio_valid(ret) && blk_qc_t_valid(cookie)) {
>> +			unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
>> +			struct blk_mq_hw_ctx *hctx = q->queue_hw_ctx[queue_num];
>> +
>> +			cookie = (blk_qc_t)hctx;
>> +
>> +			if (!blk_qc_t_valid(ret)) /* set initial value */
>> +				ret = cookie;
>> +			else if (ret != cookie)   /* bio got split */
>> +				ret = BLK_QC_T_BIO_MULTI;
>> +		}
>>  
>>  		/*
>>  		 * Sort new bios into those for a lower level and those for the
>> @@ -1003,6 +1025,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
>>  
>>  	current->bio_list = NULL;
>> +
>>  	return ret;
>>  }
>>  
>> @@ -1142,7 +1165,13 @@ static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>>  	do {
>>  		int ret;
>>  
>> -		ret = disk->fops->poll(q, cookie);
>> +		if (blk_qc_t_bio_valid(cookie)) {
>> +			struct blk_mq_hw_ctx *hctx = (struct blk_mq_hw_ctx *)cookie;
>> +			struct request_queue *target_q = hctx->queue;
>> +
>> +			ret = blk_mq_poll_hctx(target_q, hctx);
>> +		} else
>> +			ret = disk->fops->poll(q, cookie);
>>  		if (ret > 0) {
>>  			__set_current_state(TASK_RUNNING);
>>  			return ret;
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 2e05244fc16d..4173754532c0 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -557,6 +557,14 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
>>  	return (cookie & BLK_QC_T_INTERNAL) != 0;
>>  }
>>  
>> +/* Macros for blk_qc_t used for bio-based polling */
>> +#define BLK_QC_T_BIO_MULTI	-2U
>> +
>> +static inline bool blk_qc_t_bio_valid(blk_qc_t cookie)
>> +{
>> +	return cookie != BLK_QC_T_BIO_MULTI;
>> +}
>> +
>>  struct blk_rq_stat {
>>  	u64 mean;
>>  	u64 min;
>> diff --git a/include/linux/types.h b/include/linux/types.h
>> index da5ca7e1bea9..f6301014a459 100644
>> --- a/include/linux/types.h
>> +++ b/include/linux/types.h
>> @@ -126,7 +126,7 @@ typedef u64 sector_t;
>>  typedef u64 blkcnt_t;
>>  
>>  /* cookie used for IO polling */
>> -typedef unsigned int blk_qc_t;
>> +typedef uintptr_t blk_qc_t;
>>  
>>  /*
>>   * The type of an index into the pagecache.
>> -- 
>> 2.27.0
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://listman.redhat.com/mailman/listinfo/dm-devel
>>
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

