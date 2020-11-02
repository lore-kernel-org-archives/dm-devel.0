Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EB58C00A89
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C96B321D91
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C96B321D91
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-QBaJSP0jMAeuMdJPpACv5Q-1; Mon, 02 Nov 2020 02:58:41 -0500
X-MC-Unique: QBaJSP0jMAeuMdJPpACv5Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0090802B7D;
	Mon,  2 Nov 2020 07:58:35 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A40006115F;
	Mon,  2 Nov 2020 07:58:35 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7988F8C7B5;
	Mon,  2 Nov 2020 07:58:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A23FB1a027261 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 22:15:13 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C68230BBC; Mon,  2 Nov 2020 03:15:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7724A30BBA
	for <dm-devel@redhat.com>; Mon,  2 Nov 2020 03:15:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39765185A790
	for <dm-devel@redhat.com>; Mon,  2 Nov 2020 03:15:08 +0000 (UTC)
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-507-bH215RkVMt-W_uRaefq-mw-1;
	Sun, 01 Nov 2020 22:15:03 -0500
X-MC-Unique: bH215RkVMt-W_uRaefq-mw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R121e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1;
	HT=alimailimapcm10staff010182156082;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=8; SR=0;
	TI=SMTPD_---0UDsZrDX_1604286896
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UDsZrDX_1604286896) by smtp.aliyun-inc.com(127.0.0.1);
	Mon, 02 Nov 2020 11:14:57 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
	<20201021203906.GA10896@redhat.com>
	<da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
	<20201026185334.GA8463@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
Date: Mon, 2 Nov 2020 11:14:56 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
	Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201026185334.GA8463@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 02 Nov 2020 02:58:01 -0500
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"


On 10/27/20 2:53 AM, Mike Snitzer wrote:
> What you detailed there isn't properly modeling what it needs to.
> A given dm_target_io could result in quite a few bios (e.g. for
> dm-striped we clone each bio for each of N stripes).  So the fan-out,
> especially if then stacked on N layers of stacked devices, to all the
> various hctx at the lowest layers is like herding cats.
>
> But the recursion in block core's submit_bio path makes that challenging
> to say the least.  So much so that any solution related to enabling
> proper bio-based IO polling is going to need a pretty significant
> investment in fixing block core (storing __submit_bio()'s cookie during
> recursion, possibly storing to driver provided memory location,
> e.g. DM initialized bio->submit_cookie pointer to a blk_qc_t within a DM
> clone bio's per-bio-data).
>
> SO __submit_bio_noacct would become:
>
>     retp = &ret;
>     if (bio->submit_cookie)
>            retp = bio->submit_cookie;
>     *retp = __submit_bio(bio);

Sorry for the late reply. Exactly I missed this point before. IF you 
have not started working on this, I'd

like to try to implement this as an RFC.


> I think you probably just got caught out by the recursive nature of the bio
> submission path -- makes creating a graph of submitted bios and their
> associated per-bio-data and generated cookies a mess to track (again,
> like herding cats).
>
> Could also be you didn't quite understand the DM code's various
> structures.
>
> In any case, the block core changes needed to make bio-based IO polling
> work is the main limiting factor right now.
Yes the logic is kind of subtle and maybe what I'm concerned here is 
really should be concerned

at the coding phase.


Thanks.

Jeffle Xu

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

