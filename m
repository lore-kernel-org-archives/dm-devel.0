Return-Path: <SRS0=NHnu=EJ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16039C2D0A3
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 12:33:24 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 47E9220735
	for <dm-devel@archiver.kernel.org>; Tue,  3 Nov 2020 12:33:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47E9220735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-ahGSPV0mN4qFFIloohPNNg-1; Tue, 03 Nov 2020 07:32:52 -0500
X-MC-Unique: ahGSPV0mN4qFFIloohPNNg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F259E107465D;
	Tue,  3 Nov 2020 12:32:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 007F25B4DC;
	Tue,  3 Nov 2020 12:32:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 02B90180B657;
	Tue,  3 Nov 2020 12:32:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A38xmUH018933 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 3 Nov 2020 03:59:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3E270110F0AF; Tue,  3 Nov 2020 08:59:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 39A2A110F0AB
	for <dm-devel@redhat.com>; Tue,  3 Nov 2020 08:59:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF737803525
	for <dm-devel@redhat.com>; Tue,  3 Nov 2020 08:59:43 +0000 (UTC)
Received: from out30-57.freemail.mail.aliyun.com
	(out30-57.freemail.mail.aliyun.com [115.124.30.57]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-288-MEIjixYhO52sxiWNhEJCIw-1;
	Tue, 03 Nov 2020 03:59:38 -0500
X-MC-Unique: MEIjixYhO52sxiWNhEJCIw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R321e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UE4qbMW_1604393972
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UE4qbMW_1604393972) by smtp.aliyun-inc.com(127.0.0.1);
	Tue, 03 Nov 2020 16:59:33 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
	<20201021203906.GA10896@redhat.com>
	<da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
	<20201026185334.GA8463@redhat.com>
	<33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
	<20201102152822.GA20466@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <ed72109d-0929-eb3a-0b73-b3d94abdea3f@linux.alibaba.com>
Date: Tue, 3 Nov 2020 16:59:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201102152822.GA20466@redhat.com>
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
X-Mailman-Approved-At: Tue, 03 Nov 2020 07:32:40 -0500
Cc: axboe@kernel.dk, xiaoguang.wang@linux.alibaba.com,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, haoxu@linux.alibaba.com, io-uring@vger.kernel.org
Subject: Re: [dm-devel] [RFC 0/3] Add support of iopoll for dm device
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


On 11/2/20 11:28 PM, Mike Snitzer wrote:
> On Sun, Nov 01 2020 at 10:14pm -0500,
> JeffleXu <jefflexu@linux.alibaba.com> wrote:
>
>> On 10/27/20 2:53 AM, Mike Snitzer wrote:
>>> What you detailed there isn't properly modeling what it needs to.
>>> A given dm_target_io could result in quite a few bios (e.g. for
>>> dm-striped we clone each bio for each of N stripes).  So the fan-out,
>>> especially if then stacked on N layers of stacked devices, to all the
>>> various hctx at the lowest layers is like herding cats.
>>>
>>> But the recursion in block core's submit_bio path makes that challenging
>>> to say the least.  So much so that any solution related to enabling
>>> proper bio-based IO polling is going to need a pretty significant
>>> investment in fixing block core (storing __submit_bio()'s cookie during
>>> recursion, possibly storing to driver provided memory location,
>>> e.g. DM initialized bio->submit_cookie pointer to a blk_qc_t within a DM
>>> clone bio's per-bio-data).
>>>
>>> SO __submit_bio_noacct would become:
>>>
>>>     retp = &ret;
>>>     if (bio->submit_cookie)
>>>            retp = bio->submit_cookie;
>>>     *retp = __submit_bio(bio);
>> Sorry for the late reply. Exactly I missed this point before. IF you
>> have not started working on this, I'd like to try to implement this as
>> an RFC.
> I did start on this line of development but it needs quite a bit more
> work.  Even the pseudo code I provided above isn't useful in the context
> of DM clone bios that have their own per-bio-data to assist with this
> implementation.  Because the __submit_bio_noacct() recursive call
> drivers/md/dm.c:__split_and_process_bio() makes is supplying the
> original bio (modified to only point to remaining work).
>
> But sure, I'm not opposed to you carrying this line of work forward.  I
> can always lend a hand if you need help later or if you need to hand it
> off to me.

Thanks. I will continue working on this.

Jeffle


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

