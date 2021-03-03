Return-Path: <SRS0=/efG=IB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56233C433E6
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 08:47:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4AF3864EDE
	for <dm-devel@archiver.kernel.org>; Wed,  3 Mar 2021 08:47:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AF3864EDE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-530-QbVpkNLYPoWX8KOD9uMyag-1; Wed, 03 Mar 2021 03:47:27 -0500
X-MC-Unique: QbVpkNLYPoWX8KOD9uMyag-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 335EA85B663;
	Wed,  3 Mar 2021 08:47:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F08D85C8B3;
	Wed,  3 Mar 2021 08:47:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4577857DFC;
	Wed,  3 Mar 2021 08:47:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1231tnxj030883 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 2 Mar 2021 20:55:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8C7342026D14; Wed,  3 Mar 2021 01:55:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8799D2026D48
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 01:55:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 002248630D2
	for <dm-devel@redhat.com>; Wed,  3 Mar 2021 01:55:46 +0000 (UTC)
Received: from out30-44.freemail.mail.aliyun.com
	(out30-44.freemail.mail.aliyun.com [115.124.30.44]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-202-Xkaf49nxM6akrtE0shk8_g-1;
	Tue, 02 Mar 2021 20:55:42 -0500
X-MC-Unique: Xkaf49nxM6akrtE0shk8_g-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R101e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=9; SR=0;
	TI=SMTPD_---0UQ9w27U_1614736537
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UQ9w27U_1614736537) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 03 Mar 2021 09:55:38 +0800
To: Mikulas Patocka <mpatocka@redhat.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
	<20210208085243.82367-12-jefflexu@linux.alibaba.com>
	<alpine.LRH.2.02.2102191351200.10545@file01.intranet.prod.int.rdu2.redhat.com>
	<af9223b9-8960-1ed4-799a-bcd56299c587@linux.alibaba.com>
	<alpine.LRH.2.02.2103021353490.9353@file01.intranet.prod.int.rdu2.redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <3ce93e18-190a-fb63-3efa-9d0d7119920c@linux.alibaba.com>
Date: Wed, 3 Mar 2021 09:55:37 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2103021353490.9353@file01.intranet.prod.int.rdu2.redhat.com>
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
X-Mailman-Approved-At: Wed, 03 Mar 2021 03:47:16 -0500
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 3/3/21 3:03 AM, Mikulas Patocka wrote:
> 
> 
> On Fri, 26 Feb 2021, JeffleXu wrote:
> 
>>
>>
>> On 2/20/21 3:38 AM, Mikulas Patocka wrote:
>>>
>>>
>>> On Mon, 8 Feb 2021, Jeffle Xu wrote:
>>>
>>>> Offer one fastpath of bio-based polling when bio submitted to dm device
>>>> is not split.
>>>>
>>>> In this case, there will be only one bio submitted to only one polling
>>>> hw queue of one underlying mq device, and thus we don't need to track
>>>> all split bios or iterate through all polling hw queues. The pointer to
>>>> the polling hw queue the bio submitted to is returned here as the
>>>> returned cookie.
>>>
>>> This doesn't seem safe - note that between submit_bio() and blk_poll(), no 
>>> locks are held - so the device mapper device may be reconfigured 
>>> arbitrarily. When you call blk_poll() with a pointer returned by 
>>> submit_bio(), the pointer may point to a stale address.
>>>
>>
>> Thanks for the feedback. Indeed maybe it's not a good idea to directly
>> return a 'struct blk_mq_hw_ctx *' pointer as the returned cookie.
>>
>> Currently I have no idea to fix it, orz... The
>> blk_get_queue()/blk_put_queue() tricks may not work in this case.
>> Because the returned cookie may not be used at all. Before calling
>> blk_poll(), the polling routine may find that the corresponding IO has
>> already completed, and thus won't call blk_poll(), in which case we have
>> no place to put the refcount.
>>
>> But I really don't want to drop this optimization, since this
>> optimization is quite intuitive when dm device maps to a lot of
>> underlying devices. Though this optimization doesn't actually achieve
>> reasonable performance gain in my test, maybe because there are at most
>> seven nvme devices in my test machine.
>>
>> Any thoughts?
>>
>> Thanks,
>> Jeffle
> 
> Hi
> 
> I reworked device mapper polling, so that we poll in the function 
> __split_and_process_bio. The pointer to a queue and the polling cookie is 
> passed only inside device mapper code, it never leaves it.
> 
> I'll send you my patches - try them and tell me how does it perform 
> compared to your patchset.
> 

Thanks. Be glad to hear that you're also working on this. I'm glad to
give some comments on your patch set.


-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

