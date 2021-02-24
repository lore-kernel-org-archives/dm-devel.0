Return-Path: <SRS0=mVW8=H2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A80C433E0
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:59:01 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A201064EC3
	for <dm-devel@archiver.kernel.org>; Wed, 24 Feb 2021 06:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A201064EC3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-1skuOwwmNdamC6dR-nJ_YQ-1; Wed, 24 Feb 2021 01:58:57 -0500
X-MC-Unique: 1skuOwwmNdamC6dR-nJ_YQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6486835E21;
	Wed, 24 Feb 2021 06:58:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C6B2018A9E;
	Wed, 24 Feb 2021 06:58:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 662B618095CB;
	Wed, 24 Feb 2021 06:58:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11O1j0qR000929 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Feb 2021 20:45:00 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 97853200BFFD; Wed, 24 Feb 2021 01:45:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9029F2015D7F
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 01:44:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 72041800B28
	for <dm-devel@redhat.com>; Wed, 24 Feb 2021 01:44:58 +0000 (UTC)
Received: from out30-132.freemail.mail.aliyun.com
	(out30-132.freemail.mail.aliyun.com [115.124.30.132]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-164-XXwcp403MpSZStkFfbk1SQ-1;
	Tue, 23 Feb 2021 20:44:55 -0500
X-MC-Unique: XXwcp403MpSZStkFfbk1SQ-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R481e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e01424;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=10; SR=0;
	TI=SMTPD_---0UPPc0lB_1614131089
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UPPc0lB_1614131089) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 24 Feb 2021 09:44:49 +0800
To: Mike Snitzer <snitzer@redhat.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
	<e3b3fc0a-cd07-a09c-5a8d-2d81c5d00435@linux.alibaba.com>
	<20210223205434.GB25684@redhat.com>
From: JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <5c4e6bab-63be-f390-55a8-3f700eebf98b@linux.alibaba.com>
Date: Wed, 24 Feb 2021 09:44:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223205434.GB25684@redhat.com>
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
X-Mailman-Approved-At: Wed, 24 Feb 2021 01:58:50 -0500
Cc: axboe@kernel.dk, caspar@linux.alibaba.com, io-uring@vger.kernel.org,
	linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>,
	ming.lei@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH v4 00/12] dm: support IO polling
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



On 2/24/21 4:54 AM, Mike Snitzer wrote:
> On Mon, Feb 22 2021 at 10:55pm -0500,
> JeffleXu <jefflexu@linux.alibaba.com> wrote:
> 
>>
>>
>> On 2/20/21 7:06 PM, Jeffle Xu wrote:
>>> [Changes since v3]
>>> - newly add patch 7 and patch 11, as a new optimization improving
>>> performance of multiple polling processes. Now performance of multiple
>>> polling processes can be as scalable as single polling process (~30%).
>>> Refer to the following [Performance] chapter for more details.
>>>
>>
>> Hi Mike, would please evaluate this new version patch set? I think this
>> mechanism is near maturity, since multi-thread performance is as
>> scalable as single-thread (~30%) now.
> 
> OK, can do. But first I think you need to repost with a v5 that
> addresses Mikulas' v3 feedback:
> 
> https://listman.redhat.com/archives/dm-devel/2021-February/msg00254.html
> https://listman.redhat.com/archives/dm-devel/2021-February/msg00255.html
> 

Will do. Besides I will also rebase to 5.12 in the next version.

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

