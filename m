Return-Path: <SRS0=/aYG=FG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1004C64E7C
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:55:39 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2062222203
	for <dm-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:55:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2062222203
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-1yGE3JepN_Spq3ZTdfyXZg-1; Wed, 02 Dec 2020 04:55:36 -0500
X-MC-Unique: 1yGE3JepN_Spq3ZTdfyXZg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32E638558F8;
	Wed,  2 Dec 2020 09:55:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 12FF05D9CA;
	Wed,  2 Dec 2020 09:55:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DCD7D5002E;
	Wed,  2 Dec 2020 09:55:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B26Zfnl018584 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Dec 2020 01:35:41 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 295F0A9F1E; Wed,  2 Dec 2020 06:35:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 243BFA9F1F
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 06:35:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 914658007D9
	for <dm-devel@redhat.com>; Wed,  2 Dec 2020 06:35:36 +0000 (UTC)
Received: from out30-42.freemail.mail.aliyun.com
	(out30-42.freemail.mail.aliyun.com [115.124.30.42]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-426-0HFragenNt6e3cdGGhMkdw-1;
	Wed, 02 Dec 2020 01:35:34 -0500
X-MC-Unique: 0HFragenNt6e3cdGGhMkdw-1
X-Alimail-AntiSpam: AC=PASS; BC=-1|-1; BR=01201311R191e4; CH=green; DM=||false|;
	DS=||; FP=0|-1|-1|-1|0|-1|-1|-1; HT=e01e04420;
	MF=jefflexu@linux.alibaba.com; NM=1; PH=DS; RN=4; SR=0;
	TI=SMTPD_---0UHIapdb_1606890926
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com
	fp:SMTPD_---0UHIapdb_1606890926) by smtp.aliyun-inc.com(127.0.0.1);
	Wed, 02 Dec 2020 14:35:26 +0800
From: JeffleXu <jefflexu@linux.alibaba.com>
To: Mike Snitzer <snitzer@redhat.com>
References: <20201201160709.31748-1-snitzer@redhat.com>
	<20201202033855.60882-1-jefflexu@linux.alibaba.com>
	<20201202033855.60882-2-jefflexu@linux.alibaba.com>
	<feb19a02-5ece-505f-e905-86dc84cdb204@linux.alibaba.com>
	<20201202050343.GA20535@redhat.com> <20201202051438.GB20535@redhat.com>
	<bee06a80-302e-ab1a-3eda-79a25adaf0d0@linux.alibaba.com>
Message-ID: <06464bd6-622e-6c24-07b7-b3dcabb066a5@linux.alibaba.com>
Date: Wed, 2 Dec 2020 14:35:26 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
	Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <bee06a80-302e-ab1a-3eda-79a25adaf0d0@linux.alibaba.com>
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
X-Mailman-Approved-At: Wed, 02 Dec 2020 04:55:04 -0500
Cc: linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
	dm-devel@redhat.com
Subject: Re: [dm-devel] dm: use gcd() to fix chunk_sectors limit stacking
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On 12/2/20 2:31 PM, JeffleXu wrote:
> 
> 
> On 12/2/20 1:14 PM, Mike Snitzer wrote:
>> On Wed, Dec 02 2020 at 12:03am -0500,
>> Mike Snitzer <snitzer@redhat.com> wrote:
>>
>>> What you've done here is fairly chaotic/disruptive:
>>> 1) you emailed a patch out that isn't needed or ideal, I dealt already
>>>    staged a DM fix in linux-next for 5.10-rcX, see:
>>>    https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.10-rcX&id=f28de262ddf09b635095bdeaf0e07ff507b3c41b
>>> 2) you replied to your patch and started referencing snippets of this
>>>    other patch's header (now staged for 5.10-rcX via Jens' block tree):
>>>    https://git.kernel.dk/cgit/linux-block/commit/?h=block-5.10&id=7e7986f9d3ba69a7375a41080a1f8c8012cb0923
>>>    - why not reply to _that_ patch in response something stated in it?
>>
>> I now see you did reply to the original v2 patch:
>> https://www.redhat.com/archives/dm-devel/2020-December/msg00006.html
>>
>> but you changed the Subject to have a "dm" prefix for some reason.
> 
> In my original purpose, this is a new patch, 'dm: XXXXXXXX'. This patch
> should coexist with your patch 'block: XXXXXX'.
> 
> Can I say that it's totally a mistake ;)
s/mistake/misunderstanding

> 
> 
>> Strange but OK.. though it got really weird when you cut-and-paste your
>> other DM patch in reply at the bottom of your email.  If you find
>> yourself cross referencing emails and cutting and pasting like that, you
>> probably shouldn't.  Makes it chaotic for others to follow along.
>>
>> Thanks,
>> Mike
>>
> 

-- 
Thanks,
Jeffle

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

