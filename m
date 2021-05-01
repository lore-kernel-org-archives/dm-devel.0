Return-Path: <SRS0=QF+r=J4=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79EDEC433ED
	for <dm-devel@archiver.kernel.org>; Sat,  1 May 2021 21:52:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3746D61077
	for <dm-devel@archiver.kernel.org>; Sat,  1 May 2021 21:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3746D61077
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mageta.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-Zsh7JOanPjmdafTBRA3W5w-1; Sat, 01 May 2021 17:52:25 -0400
X-MC-Unique: Zsh7JOanPjmdafTBRA3W5w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E7D9801FD8;
	Sat,  1 May 2021 21:52:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DBE45C1CF;
	Sat,  1 May 2021 21:52:16 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0018018095C4;
	Sat,  1 May 2021 21:52:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 141Lq9ja031817 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 1 May 2021 17:52:10 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 47B36205FA87; Sat,  1 May 2021 21:52:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4275C205FA84
	for <dm-devel@redhat.com>; Sat,  1 May 2021 21:52:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3D2C8CDDE6
	for <dm-devel@redhat.com>; Sat,  1 May 2021 21:52:04 +0000 (UTC)
Received: from mout4.gn-server.de (mout4.gn-server.de [87.238.194.231])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-418-xH5TVmDWPPCQpxuqRWXQ-g-1; Sat, 01 May 2021 17:51:59 -0400
X-MC-Unique: xH5TVmDWPPCQpxuqRWXQ-g-1
Received: from mout17.gn-server.de ([87.238.194.244])
	by mout4.gn-server.de with esmtp (Exim 4.92)
	(envelope-from <lkml@mageta.org>)
	id 1lcwyY-0004VK-9l; Sat, 01 May 2021 21:16:34 +0000
Received: from lc0.greatnet-hosting.de ([178.254.50.20])
	by mout17.gn-server.de with esmtp (Exim 4.92)
	(envelope-from <lkml@mageta.org>)
	id 1lcwyY-0006DW-4i; Sat, 01 May 2021 21:16:34 +0000
Received: from chlorum.ategam.org (ategam.org [88.99.83.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: work@mageta.org)
	by lc0.greatnet-hosting.de (Postfix) with ESMTPSA id D494CEDA675;
	Sat,  1 May 2021 23:16:33 +0200 (CEST)
Date: Sat, 1 May 2021 23:16:32 +0200
From: Benjamin Block <lkml@mageta.org>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <YI3FMOwBUZ3fiml+@chlorum.ategam.org>
References: <0427141cadc833d4cdf32cc5a22025c90b278a09.1619720034.git.bblock@linux.ibm.com>
MIME-Version: 1.0
In-Reply-To: <0427141cadc833d4cdf32cc5a22025c90b278a09.1619720034.git.bblock@linux.ibm.com>
X-Virus-Scanned: clamav-milter 0.102.4 at lc0
X-Virus-Status: Clean
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
Cc: Benjamin Block <bblock@linux.ibm.com>, dm-devel@redhat.com,
	Steffen Maier <maier@linux.ibm.com>,
	Alasdair Kergon <agk@redhat.com>, Martin Wilck <mwilck@suse.com>
Subject: Re: [dm-devel] [RFC PATCH] dm-rq: fix double free of blk tag set in
 dev remove after table load fails
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Apr 29, 2021 at 11:37:00PM +0200, Benjamin Block wrote:
> When loading a device-mapper table for a request-based mapped device,
> and the allocation/initialization of the blk-mq tag set for the device
> fails, a following device remove will cause a double free.
>
> [snip]
>
> Fix this by also setting the pointer to NULL in
> `dm_mq_init_request_queue()` after error-handling.
> 

Thanks for taking the fix so fast Mike :)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

