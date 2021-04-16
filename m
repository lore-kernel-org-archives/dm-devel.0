Return-Path: <SRS0=qgW3=JQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C37EAC433ED
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 10:47:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4531061157
	for <dm-devel@archiver.kernel.org>; Mon, 19 Apr 2021 10:47:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4531061157
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-BrohodyXM5yka5d4cAJD2w-1; Mon, 19 Apr 2021 06:47:21 -0400
X-MC-Unique: BrohodyXM5yka5d4cAJD2w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E6E6107ACC7;
	Mon, 19 Apr 2021 10:47:17 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 55BA42C15A;
	Mon, 19 Apr 2021 10:47:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E1EBC1806D17;
	Mon, 19 Apr 2021 10:47:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13GAKXUt009055 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 06:20:34 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 50ABA21D0DC4; Fri, 16 Apr 2021 10:20:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A1F621D0DB0
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 10:20:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F776100E7F8
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 10:20:30 +0000 (UTC)
Received: from out30-44.freemail.mail.aliyun.com
	(out30-44.freemail.mail.aliyun.com [115.124.30.44]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-442-W07P68jwMeKF9tHDjuJbKg-1;
	Fri, 16 Apr 2021 06:20:26 -0400
X-MC-Unique: W07P68jwMeKF9tHDjuJbKg-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R171e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=5; SR=0;
	TI=SMTPD_---0UVk99mh_1618568422
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UVk99mh_1618568422) by smtp.aliyun-inc.com(127.0.0.1);
	Fri, 16 Apr 2021 18:20:22 +0800
To: Ming Lei <ming.lei@redhat.com>
References: <20210401021927.343727-12-ming.lei@redhat.com>
	<20210416080037.26335-1-jefflexu@linux.alibaba.com>
	<YHlTtVtTEBpxa8Gh@T590>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <bb95d78b-9924-7c4c-5314-f221af524619@linux.alibaba.com>
Date: Fri, 16 Apr 2021 18:20:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YHlTtVtTEBpxa8Gh@T590>
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



On 4/16/21 5:07 PM, Ming Lei wrote:
> On Fri, Apr 16, 2021 at 04:00:37PM +0800, Jeffle Xu wrote:
>> Hi,
>> How about this patch to remove the extra poll_capable() method?
>>
>> And the following 'dm: support IO polling for bio-based dm device' needs
>> following change.
>>
>> ```
>> +       /*
>> +        * Check for request-based device is remained to
>> +        * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
>> +        * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
>> +        * devices supporting polling.
>> +        */
>> +       if (__table_type_bio_based(t->type)) {
>> +               if (dm_table_supports_poll(t)) {
>> +                       blk_queue_flag_set(QUEUE_FLAG_POLL_CAP, q);
>> +                       blk_queue_flag_set(QUEUE_FLAG_POLL, q);
>> +               }
>> +               else {
>> +                       blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
>> +                       blk_queue_flag_clear(QUEUE_FLAG_POLL_CAP, q);
>> +               }
>> +       }
>> ```
> 
> Frankly speaking, I don't see any value of using QUEUE_FLAG_POLL_CAP for
> DM, and the result is basically subset of treating DM as always being capable
> of polling.
> 
> Also underlying queue change(either limits or flag) won't be propagated
> to DM/MD automatically. Strictly speaking it doesn't matter if all underlying
> queues are capable of supporting polling at the exact time of 'write sysfs/poll',
> cause any of them may change in future.

Yes it is.

> 
> So why not start with the simplest approach(always capable of polling)
> which does meet normal bio based polling requirement?
> 

I agree if we have no better way. Though the handling of "sysfs/io_poll"
is somehow inconsistent between blk-mq and bio-based device then.

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

