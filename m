Return-Path: <SRS0=tECb=HA=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21E80C433E0
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 14:12:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 4DD5764DF1
	for <dm-devel@archiver.kernel.org>; Fri, 29 Jan 2021 14:12:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4DD5764DF1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-528-C0QSgu-zORST7BIGqqQnsQ-1; Fri, 29 Jan 2021 09:12:15 -0500
X-MC-Unique: C0QSgu-zORST7BIGqqQnsQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 964B01926DA3;
	Fri, 29 Jan 2021 14:12:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 40B0119D9F;
	Fri, 29 Jan 2021 14:12:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id D915850038;
	Fri, 29 Jan 2021 14:12:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10TEC7fK027252 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Jan 2021 09:12:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id F1661100BFEF; Fri, 29 Jan 2021 14:12:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED2EE10CD919
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 14:12:03 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AC58800B3B
	for <dm-devel@redhat.com>; Fri, 29 Jan 2021 14:12:03 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-268-ESIvrfLKO3OrCrPp6LxzUQ-1;
	Fri, 29 Jan 2021 09:12:00 -0500
X-MC-Unique: ESIvrfLKO3OrCrPp6LxzUQ-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 6EB55B16A;
	Fri, 29 Jan 2021 14:11:59 +0000 (UTC)
To: Alasdair G Kergon <agk@redhat.com>
References: <41f1923b-8f45-ff49-e0d9-06bc5a4a6fad@suse.de>
	<20210129135725.GA27059@agk.fab.redhat.com>
From: Coly Li <colyli@suse.de>
Message-ID: <17df7322-8796-b6f3-dc5e-140f29dedf1b@suse.de>
Date: Fri, 29 Jan 2021 22:11:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
	Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210129135725.GA27059@agk.fab.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10TEC7fK027252
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] dm thin-volume hung as swap: bug or as-design ?
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 1/29/21 9:57 PM, Alasdair G Kergon wrote:
> On Fri, Jan 29, 2021 at 06:40:06PM +0800, Coly Li wrote:
>> Recently I receive a report that whole system hung and no response after
>> a while with I/O load. The special configuration is the dm thin-pool
>> volume is used as the swap partition of the system.
>> My questions are,
>> - Can a thin-pool volume be used as swap device?
> 
> Yes in principle, but it won't get much testing as it's not 
> necessarily a particularly sensible configuration.
> - You'd normally prefer fully-pre-allocated disk space for swap
>   and turn off the zeroing.
> 
> Is there some use-case where it does make more sense?
> 

What I see is on a system there are dozens of partitions created on top
of many thin-pool for each, including the swap partition. People just
use thin-pool volumes in this way, and bug triggered.


>> - The above description is a bug, or an already know issue which should
>> be avoided ?
>  
> Bug.
> 

Thanks for the confirmation. I tried to change all memory allocation
into GFP_NOIO or with memalloc_noio_save(), the deadlock still exists.
What I suspect yet is might be from the memory allocation from the
kworkers, but this is only my guess and no evidence.

If there is patch addressed this hung issue (thin-pool volume as swap),
I'd like to help testing, because my local environment may 100%
reproduce the problem in 5 minutes.

Thanks.

Coly Li


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

