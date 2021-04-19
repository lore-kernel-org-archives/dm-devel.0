Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD0AC43603
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 10:47:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id ED0126101D
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 10:47:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED0126101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-_dJ8sQ45MQiFtRXAOrWKjQ-1; Mon, 19 Apr 2021 06:47:28 -0400
X-MC-Unique: _dJ8sQ45MQiFtRXAOrWKjQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2333A801597;
	Mon, 19 Apr 2021 10:47:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BFED19CAB;
	Mon, 19 Apr 2021 10:47:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D079F44A58;
	Mon, 19 Apr 2021 10:47:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13J5joFI007834 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 01:45:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D2134217B43A; Mon, 19 Apr 2021 05:45:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CC799217B43E
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 05:45:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0BC7280A1D2
	for <dm-devel@redhat.com>; Mon, 19 Apr 2021 05:45:48 +0000 (UTC)
Received: from out30-130.freemail.mail.aliyun.com
	(out30-130.freemail.mail.aliyun.com [115.124.30.130]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-105-Y5o_VT5XO2il00xmxiq2HA-1;
	Mon, 19 Apr 2021 01:45:45 -0400
X-MC-Unique: Y5o_VT5XO2il00xmxiq2HA-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R851e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04426;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UVzpdf9_1618810821
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UVzpdf9_1618810821) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 19 Apr 2021 13:40:22 +0800
To: Ming Lei <ming.lei@redhat.com>
References: <20210401021927.343727-12-ming.lei@redhat.com>
	<20210416080037.26335-1-jefflexu@linux.alibaba.com>
	<YHlTtVtTEBpxa8Gh@T590>
	<1fb6e15e-fb4d-a2bf-9f65-2ae2aa15a8a2@linux.alibaba.com>
	<YHzpJsOYJL/AGC7k@T590>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <c0085cb4-2396-b0c2-c880-c6fa8fb7e491@linux.alibaba.com>
Date: Mon, 19 Apr 2021 13:40:21 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YHzpJsOYJL/AGC7k@T590>
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
X-Mailman-Approved-At: Mon, 19 Apr 2021 06:46:06 -0400
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
	snitzer@redhat.com
Subject: Re: [dm-devel] [PATCH] block: introduce QUEUE_FLAG_POLL_CAP flag
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



On 4/19/21 10:21 AM, Ming Lei wrote:
> On Sat, Apr 17, 2021 at 10:06:53PM +0800, JeffleXu wrote:
>>
>>
>> On 4/16/21 5:07 PM, Ming Lei wrote:
>>> On Fri, Apr 16, 2021 at 04:00:37PM +0800, Jeffle Xu wrote:
>>>> Hi,
>>>> How about this patch to remove the extra poll_capable() method?
>>>>
>>>> And the following 'dm: support IO polling for bio-based dm device' needs
>>>> following change.
>>>>
>>>> ```
>>>> +       /*
>>>> +        * Check for request-based device is remained to
>>>> +        * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
>>>> +        * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
>>>> +        * devices supporting polling.
>>>> +        */
>>>> +       if (__table_type_bio_based(t->type)) {
>>>> +               if (dm_table_supports_poll(t)) {
>>>> +                       blk_queue_flag_set(QUEUE_FLAG_POLL_CAP, q);
>>>> +                       blk_queue_flag_set(QUEUE_FLAG_POLL, q);
>>>> +               }
>>>> +               else {
>>>> +                       blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
>>>> +                       blk_queue_flag_clear(QUEUE_FLAG_POLL_CAP, q);
>>>> +               }
>>>> +       }
>>>> ```
>>>
>>> Frankly speaking, I don't see any value of using QUEUE_FLAG_POLL_CAP for
>>> DM, and the result is basically subset of treating DM as always being capable
>>> of polling.
>>>
>>> Also underlying queue change(either limits or flag) won't be propagated
>>> to DM/MD automatically. Strictly speaking it doesn't matter if all underlying
>>> queues are capable of supporting polling at the exact time of 'write sysfs/poll',
>>> cause any of them may change in future.
>>>
>>> So why not start with the simplest approach(always capable of polling)
>>> which does meet normal bio based polling requirement?
>>>
>>
>> I find one scenario where this issue may matter. Consider the scenario
>> where HIPRI bios are submitted to DM device though **all** underlying
>> devices has been disabled for polling. In this case, a **valid** cookie
>> (pid of current submitting process) is still returned. Then if @spin of
>> the following blk_poll() is true, blk_poll() will get stuck in dead loop
>> because blk_mq_poll() always returns 0, since previously submitted bios
>> are all enqueued into IRQ hw queue.
>>
>> Maybe you need to re-remove the bio from the poll context if the
>> returned cookie is BLK_QC_T_NONE?
> 
> It won't be one issue, see blk_bio_poll_preprocess() which is called
> from submit_bio_checks(), so any bio's HIPRI will be cleared if the
> queue doesn't support POLL, that code does cover underlying bios.

Sorry there may be some confusion in my description. Let's discuss in
the following scenario: MD/DM advertise QUEUE_FLAG_POLL, though **all**
underlying devices are without QUEUE_FLAG_POLL. This scenario is
possible, if you want to enable MD/DM's polling without checking the
capability of underlying devices.

In this case, it seems that REQ_HIPRI is kept for both MD/DM and
underlying blk-mq devices. I used to think that REQ_HIPRI will be
cleared for underlying blk-mq deivces, but now it seems that REQ_HIPRI
of bios submitted to underlying blk-mq deivces won't be cleared, since
submit_bio_checks() is only called in the entry of submit_bio(), not in
the while() loop of __submit_bio_noacct_ctx(). Though these underlying
blk-mq devices don't support IO polling at all, or they all have been
disabled for polling, REQ_HIPRI bios are finally submitted down.

Or do I miss something?


> 
>>
>>
>> Something like:
>>
>> -static blk_qc_t __submit_bio_noacct(struct bio *bio)
>> +static blk_qc_t __submit_bio_noacct_ctx(struct bio *bio, struct
>> io_context *ioc)
>>  {
>>  	struct bio_list bio_list_on_stack[2];
>>  	blk_qc_t ret = BLK_QC_T_NONE;
>> @@ -1047,7 +1163,15 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>>  		bio_list_init(&bio_list_on_stack[0]);
>>
>> 		if (ioc && queue_is_mq(q) && (bio->bi_opf & REQ_HIPRI)) {
> 
> REQ_HIPRI won't be set for underlying bios which queue doesn't support
> poll, so this branch won't be reached. 

Sorry I missed the '(bio->bi_opf & REQ_HIPRI)' condition here. Indeed
bio without REQ_HIPRI won't be enqueued into the poll_context.

> And the submission queue will
> be empty, and blk_poll() for DM/MD(bio based queue) checks nothing, but
> the polling won't be stopped until the iocb is completed. And this
> handling is actually same with current polling on IRQ based queue.
> 
>> 			bool queued = blk_bio_poll_prep_submit(ioc, bio);
>>
>> 			ret = __submit_bio(bio);
>> +			if (queued && !blk_qc_t_valid(ret))
>> 				/* TODO:remove bio from poll_context */
>> 				
>> 				bio_set_private_data(bio, ret);
>> 		} else {
>> 			ret = __submit_bio(bio);
>> 		}
>>
>>
>> Then if you'd like fix this in this way, the returned value of
>> .submit_bio() of DM/MD also needs to return BLK_QC_T_NONE now. Currently
>> .submit_bio() of DM actually returns the cookie of the last split bio
>> (to underlying mq deivice).
> 
> I am a bit confused, this patch requires .submit_bio() of DM/MD(bio
> based queue) to return either 0 or pid of the submission task.
> 
> 
> Thanks,
> Ming
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

