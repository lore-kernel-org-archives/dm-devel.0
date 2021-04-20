Return-Path: <SRS0=/8Iv=JS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2B9C433ED
	for <dm-devel@archiver.kernel.org>; Wed, 21 Apr 2021 07:30:17 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BAE226142B
	for <dm-devel@archiver.kernel.org>; Wed, 21 Apr 2021 07:30:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BAE226142B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-RHpEcbnEPDWxHhGLxp329w-1; Wed, 21 Apr 2021 03:30:11 -0400
X-MC-Unique: RHpEcbnEPDWxHhGLxp329w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 882FE107AD51;
	Wed, 21 Apr 2021 07:30:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 80DDC687C1;
	Wed, 21 Apr 2021 07:30:03 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AE3CC1806D0F;
	Wed, 21 Apr 2021 07:29:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13K7MEXS029741 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 20 Apr 2021 03:22:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D237C10085CE; Tue, 20 Apr 2021 07:22:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CDCA61134CD7
	for <dm-devel@redhat.com>; Tue, 20 Apr 2021 07:22:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5C2E2185A7B8
	for <dm-devel@redhat.com>; Tue, 20 Apr 2021 07:22:12 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
	(out30-132.freemail.mail.aliyun.com [115.124.30.132]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-471-7vwXrgNoNTGsZ7zhGztsBQ-1;
	Tue, 20 Apr 2021 03:22:01 -0400
X-MC-Unique: 7vwXrgNoNTGsZ7zhGztsBQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04400;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
	TI=SMTPD_---0UWBJ92o_1618903315
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UWBJ92o_1618903315) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 20 Apr 2021 15:21:57 +0800
To: Ming Lei <ming.lei@redhat.com>
References: <20210415103310.1513841-1-ming.lei@redhat.com>
	<20210415103310.1513841-3-ming.lei@redhat.com>
	<b1db72f3-f0a1-72f2-be12-6fd50c29e231@linux.alibaba.com>
	<YH2Kr8ZIn2fWKFyl@T590>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <42c79dce-ad99-4e59-6566-727fa08a66bc@linux.alibaba.com>
Date: Tue, 20 Apr 2021 15:21:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YH2Kr8ZIn2fWKFyl@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Wed, 21 Apr 2021 03:27:41 -0400
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>, Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org, linux-raid@vger.kernel.org,
	Song Liu <song@kernel.org>, dm-devel@redhat.com,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [RFC PATCH 2/2] block: support to freeze bio based
 request queue
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 4/19/21 9:50 PM, Ming Lei wrote:
> On Mon, Apr 19, 2021 at 08:05:46PM +0800, JeffleXu wrote:
>>
>>
>> On 4/15/21 6:33 PM, Ming Lei wrote:
>>> For bio based request queue, the queue usage refcnt is only grabbed
>>> during submission, which isn't consistent with request base queue.
>>>
>>> Queue freezing has been used widely, and turns out it is very useful
>>> to quiesce queue activity.
>>>
>>> Support to freeze bio based request queue by the following approach:
>>>
>>> 1) grab two queue usage refcount for blk-mq before submitting blk-mq
>>> bio, one is for bio, anther is for request;
>>
>>
>> Hi, I can't understand the sense of grabbing two refcounts on the
>> @q_usage_count of the underlying blk-mq device, while
>> @q_usage_count of the MD/DM device is kept untouched.
> 
> Follows the point:
> 
> 1) for blk-mq, we hold one refcount for bio and another for request, and
> release one after ending bio or completing request.

Blk-mq has already implemented queue freezing semantics, even without
this 'grabbing two refcount'. So is this just for the code consisdency
with the bio-based queue?


> 
> 2) for bio based queue, just holding one refcount for bio, and release it
> after the bio is ended.

OK.

> 
> As I mentioned to you, the current in-tree code only grabs the refcount
> during submitting bio for bio base queue, and the refcount is released
> after returning from submission, see __submit_bio().

Yes. I ignored that the refcount grabbed in the entry of bio submission
has been returned back when the submission completes for bio-based queue.

> 
>>
>> In the following calling stack
>>
>> ```
>> queue_poll_store
>> 	blk_mq_freeze_queue(q)
>> ```
>>
>> Is the input @q still the request queue of MD/DM device?
> 
> It can be either one after bio based io polling is supported,
> queue/io_poll is exposed for both blk-mq and bio based queue.
> 
> However, I guess bio based polling doesn't need such strict bio queue
> freezing, cause QUEUE_FLAG_POLL is only read in submission path, so
> looks current freezing just during submission is enough.

Not actually.

blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	struct blk_mq_hw_ctx *hctx;
 	long state;

-	if (!blk_qc_t_valid(cookie) || !blk_queue_poll(q))
+	if (!blk_queue_poll(q) || (queue_is_mq(q) && !blk_qc_t_valid(cookie)))

Here QUEUE_FLAG_POLL is still checked in blk_poll() for bio-based queue,
at least in your latest patch for bio-based polling.

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

