Return-Path: <SRS0=AlgS=HU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8653FC433DB
	for <dm-devel@archiver.kernel.org>; Thu, 18 Feb 2021 03:23:04 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D928B64D79
	for <dm-devel@archiver.kernel.org>; Thu, 18 Feb 2021 03:23:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D928B64D79
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=chinatelecom.cn
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-QKSEH59MPImCkoVxFMfyRA-1; Wed, 17 Feb 2021 22:22:56 -0500
X-MC-Unique: QKSEH59MPImCkoVxFMfyRA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C40F79EC0;
	Thu, 18 Feb 2021 03:22:52 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C6E15C730;
	Thu, 18 Feb 2021 03:22:51 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BD7754E58E;
	Thu, 18 Feb 2021 03:22:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11I3Mcih017601 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Feb 2021 22:22:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B7658200AC37; Thu, 18 Feb 2021 03:22:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1ACA2126C9E
	for <dm-devel@redhat.com>; Thu, 18 Feb 2021 03:22:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B67B3800B28
	for <dm-devel@redhat.com>; Thu, 18 Feb 2021 03:22:35 +0000 (UTC)
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.220]) by
	relay.mimecast.com with ESMTP id us-mta-174-rHFZWMtLOnWDYJIBI-zhyg-1;
	Wed, 17 Feb 2021 22:22:31 -0500
X-MC-Unique: rHFZWMtLOnWDYJIBI-zhyg-1
HMM_SOURCE_IP: 172.18.0.92:13115.1919750152
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.21?logid-9eb2d1d5db9340d2af8aa147d4e0424c
	(unknown [172.18.0.92])
	by chinatelecom.cn (HERMES) with SMTP id 6050E2800AF;
	Thu, 18 Feb 2021 11:22:20 +0800 (CST)
X-189-SAVE-TO-SEND: wucy11@chinatelecom.cn
Received: from  ([172.18.0.92])
	by App0021 with ESMTP id 9eb2d1d5db9340d2af8aa147d4e0424c for
	christophe.varoqui@opensvc.com; Thu Feb 18 11:22:30 2021
X-Transaction-ID: 9eb2d1d5db9340d2af8aa147d4e0424c
X-filter-score: filter<0>
X-Real-From: wucy11@chinatelecom.cn
X-Receive-IP: 172.18.0.92
X-MEDUSA-Status: 0
To: Martin Wilck <martin.wilck@suse.com>,
	"bmarzins@redhat.com" <bmarzins@redhat.com>
References: <1612847967-8813-1-git-send-email-bmarzins@redhat.com>
	<1612847967-8813-3-git-send-email-bmarzins@redhat.com>
	<e8131e361f84ef1caee140183a26c9f60b172f24.camel@suse.com>
	<20210211044833.GJ15006@octiron.msp.redhat.com>
	<293ad1261123efb63dcfff4d02440e1728b3c013.camel@suse.com>
From: Chongyun Wu <wucy11@chinatelecom.cn>
Message-ID: <e930e111-d98d-bae2-baad-501c2c591d02@chinatelecom.cn>
Date: Thu, 18 Feb 2021 11:22:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
	Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <293ad1261123efb63dcfff4d02440e1728b3c013.camel@suse.com>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] multipathd: add recheck_wwid_time option
 to verify the path wwid
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"



On 2021/2/11 20:14, Martin Wilck wrote:

>>> But foremost, do we really have to try to deal with configuration
>>> mistakes as blatant as this? What if a user sets the same WWID for
>>> different devices, or re-uses the same WWID on different storage
>>> servers? I already hesitated about the code I added myself for
>>> catching
>>> user errors in the WWIDs file, but this seems even more far-
>>> fetched.
>>>
>>> Please convince me.
>>
>> Err.. An important customer corrupted their data and while they admit
>> that they were at fault, it's hard for them to guarantee that
>> something
>> like this won't happen in the future, and they asked if multipath
>> could
>> do a better job of catching these sorts of mistakes. Obviously this
>> is
>> more convincing when it's coming from your customer. But the fact
>> still
>> stands that this has happened to multiple users even with our
>> existing
>> code to catch this.
> 
> I wasn't aware of multiple affected users. I saw Chongyun's post and it
> looked to me as if this had happend once, likely in his organization.
> It wasn't even clear to me whether production data were affected.
> 
Had customers have made incorrect storage back-end operations during the 
expansion process, which has caused the destruction of customer data, which 
cannot be repaired using any tools. And I reproduce it in our lab too.
Customers definitely hope that multipath-tools can probide protection in
this case, becuase if it is important custmer data storage in the LUN, the
loss will be great.

-- 
Best Regard,
Chongyun Wu

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

