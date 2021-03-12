Return-Path: <SRS0=VWZ+=IN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B2DC433E9
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 08:55:44 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D487E64E77
	for <dm-devel@archiver.kernel.org>; Mon, 15 Mar 2021 08:55:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D487E64E77
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-601-2uxV9JcOO_2yDKqimmFLuw-1; Mon, 15 Mar 2021 04:55:38 -0400
X-MC-Unique: 2uxV9JcOO_2yDKqimmFLuw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A5AA107ACCA;
	Mon, 15 Mar 2021 08:55:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EBDE66C32C;
	Mon, 15 Mar 2021 08:55:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id ADA7957DC1;
	Mon, 15 Mar 2021 08:55:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12C21ih5006039 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 11 Mar 2021 21:01:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 995852026D60; Fri, 12 Mar 2021 02:01:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 94E522026D6A
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 02:01:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63DB7185A7B4
	for <dm-devel@redhat.com>; Fri, 12 Mar 2021 02:01:42 +0000 (UTC)
Received: from out30-56.freemail.mail.aliyun.com
	(out30-56.freemail.mail.aliyun.com [115.124.30.56]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-457-xrVsShasNeCdr1AB2h2BUw-1;
	Thu, 11 Mar 2021 21:01:40 -0500
X-MC-Unique: xrVsShasNeCdr1AB2h2BUw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R331e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=9; SR=0;
	TI=SMTPD_---0URXfkii_1615514176
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0URXfkii_1615514176) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 12 Mar 2021 09:56:17 +0800
To: Ming Lei <ming.lei@redhat.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
	<20210303115740.127001-11-jefflexu@linux.alibaba.com>
	<YEohgwIIy5ryme8x@T590>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <40f6c434-8414-3967-0000-4b3bffc11d75@linux.alibaba.com>
Date: Fri, 12 Mar 2021 09:56:16 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YEohgwIIy5ryme8x@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 15 Mar 2021 04:55:29 -0400
Cc: axboe@kernel.dk, msnitzer@redhat.com, caspar@linux.alibaba.com,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, mpatocka@redhat.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v5 10/12] block: fastpath for bio-based
	polling
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/11/21 9:56 PM, Ming Lei wrote:
> On Wed, Mar 03, 2021 at 07:57:38PM +0800, Jeffle Xu wrote:
>> Offer one fastpath for bio-based polling when bio submitted to dm
>> device is not split.
>>
>> In this case, there will be only one bio submitted to only one polling
>> hw queue of one underlying mq device, and thus we don't need to track
>> all split bios or iterate through all polling hw queues. The pointer to
>> the polling hw queue the bio submitted to is returned here as the
>> returned cookie. In this case, the polling routine will call
>> mq_ops->poll() directly with the hw queue converted from the input
>> cookie.
>>
>> If the original bio submitted to dm device is split to multiple bios and
>> thus submitted to multiple polling hw queues, the polling routine will
>> fall back to iterating all hw queues (in polling mode) of all underlying
>> mq devices.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  block/blk-core.c          | 73 +++++++++++++++++++++++++++++++++++++--
>>  include/linux/blk_types.h | 66 +++++++++++++++++++++++++++++++++--
>>  include/linux/types.h     |  2 +-
>>  3 files changed, 135 insertions(+), 6 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 6d7d53030d7c..e5cd4ff08f5c 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -947,14 +947,22 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  {
>>  	struct bio_list bio_list_on_stack[2];
>>  	blk_qc_t ret = BLK_QC_T_NONE;
>> +	struct request_queue *top_q;
>> +	bool poll_on;
>>  
>>  	BUG_ON(bio->bi_next);
>>  
>>  	bio_list_init(&bio_list_on_stack[0]);
>>  	current->bio_list = bio_list_on_stack;
>>  
>> +	top_q = bio->bi_bdev->bd_disk->queue;
>> +	poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags) &&
>> +		  (bio->bi_opf & REQ_HIPRI);
>> +
>>  	do {
>> -		struct request_queue *q = bio->bi_bdev->bd_disk->queue;
>> +		blk_qc_t cookie;
>> +		struct block_device *bdev = bio->bi_bdev;
>> +		struct request_queue *q = bdev->bd_disk->queue;
>>  		struct bio_list lower, same;
>>  
>>  		if (unlikely(bio_queue_enter(bio) != 0))
>> @@ -966,7 +974,23 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>>  		bio_list_init(&bio_list_on_stack[0]);
>>  
>> -		ret = __submit_bio(bio);
>> +		cookie = __submit_bio(bio);
>> +
>> +		if (poll_on && blk_qc_t_valid(cookie)) {
> 
> In patch 8, dm_submit_bio() is changed to return BLK_QC_T_NONE always,
> so the returned cookie may be BLK_QC_T_NONE for DM device, such as, in
> case of DM_MAPIO_SUBMITTED returned from ->map(), and underlying bios
> can be submitted from another context, then nothing is fed to blk_poll().

Thanks for poniting out this. Indeed this issue exists. If the IO
submission is offloaded to another process context, the current simple
cookie mechanism doesn't support that.


-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

