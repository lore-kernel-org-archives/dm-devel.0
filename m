Return-Path: <SRS0=K7rR=O5=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8747FC433EF
	for <dm-devel@archiver.kernel.org>; Sat,  9 Oct 2021 01:36:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D970660FD7
	for <dm-devel@archiver.kernel.org>; Sat,  9 Oct 2021 01:36:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D970660FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-KIgWXdV3P6y8fOO9SqyFBA-1; Fri, 08 Oct 2021 21:36:50 -0400
X-MC-Unique: KIgWXdV3P6y8fOO9SqyFBA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB1551006AA3;
	Sat,  9 Oct 2021 01:36:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7907C60657;
	Sat,  9 Oct 2021 01:36:45 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A368E4E58E;
	Sat,  9 Oct 2021 01:36:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1991ag9E018756 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 8 Oct 2021 21:36:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CD2A71186344; Sat,  9 Oct 2021 01:36:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C92DB118637B
	for <dm-devel@redhat.com>; Sat,  9 Oct 2021 01:36:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5055811E76
	for <dm-devel@redhat.com>; Sat,  9 Oct 2021 01:36:39 +0000 (UTC)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com
	[209.85.221.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-320-B9VkKEgRMzqSlV5BNFIFyw-1; Fri, 08 Oct 2021 21:36:38 -0400
X-MC-Unique: B9VkKEgRMzqSlV5BNFIFyw-1
Received: by mail-wr1-f53.google.com with SMTP id k7so34653689wrd.13;
	Fri, 08 Oct 2021 18:36:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:subject
	:content-language:to:references:from:cc:in-reply-to
	:content-transfer-encoding;
	bh=IXsf26UqG71prBjbNAlEHK1YUv86jxapYyY1ey+unI0=;
	b=uQa/4QtaMUUMJlt7MBnelUn2GTgGrQXv9MWYZGu/6EM3uIFgM9iLIzmc5G4utTRLZe
	KLQsFM+/tYEo/SjkbQlBwB4TaVUJyuuojUlCeOO3AsyagsJtrP0bZjNtNbvf4O6KQgI1
	Wpvyx4ztrvTbt6reEfeDUblCG1XgyGlnMfESdPm6XG9fPdX/gEzREPQEQHvAB1KcVyFN
	zu5WgfGr997VQRL/IjVZfoDtSLecQXsQOQza/XX1gtTq2SgoqSpMTedN1oK3Z9zUF63I
	Gur7PhpjrZoW8jzJAw+6zgzc2JCLjI1q6Aux5HaFNAaHzMddev/TgZIB2pDVqFbb2U6V
	4Wtw==
X-Gm-Message-State: AOAM53128u/q3wYMWBPSjP1Y/PCHIj2EIf66VdnReVKnWeWMt4upcm5R
	mNNZDsM7sYW7r6Pzsd70IbLFIV23iQ==
X-Google-Smtp-Source: ABdhPJxGzksVMpkNh/HLjn0+8jaXSDmodjvhtTvUImE5O4cSGjZlQkMqqVTB0JdH2FGMtxmkF9HyDQ==
X-Received: by 2002:a5d:528a:: with SMTP id c10mr8239817wrv.101.1633743396479; 
	Fri, 08 Oct 2021 18:36:36 -0700 (PDT)
Received: from localhost (67.red-83-32-34.dynamicip.rima-tde.net.
	[83.32.34.67]) by smtp.gmail.com with ESMTPSA id
	o8sm14494128wme.38.2021.10.08.18.36.35
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 08 Oct 2021 18:36:35 -0700 (PDT)
Message-ID: <38939419-5c31-2d57-538b-777f54140834@gmail.com>
Date: Sat, 9 Oct 2021 03:36:34 +0200
MIME-Version: 1.0
To: Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
References: <20211008150626.8894-1-xose.vazquez@gmail.com>
	<20211009004144.GA4718@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
In-Reply-To: <20211009004144.GA4718@agk-cloud1.hosts.prod.upshift.rdu2.redhat.com>
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
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: dm-devel is a closed ml
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
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 10/9/21 02:41, Alasdair G Kergon wrote:

> On Fri, Oct 08, 2021 at 05:06:26PM +0200, Xose Vazquez Perez wrote:
>> Just for subscribers
> 
> Although we manually moderate non-subscribers so their messages
> do get through, often a bit delayed.
> 
> Alasdair
> 

BTW, this should be added to: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/MAINTAINERS#n5433

To get:
Alasdair Kergon <agk@redhat.com> (maintainer:DEVICE-MAPPER  (LVM))
Mike Snitzer <snitzer@redhat.com> (maintainer:DEVICE-MAPPER  (LVM))
dm-devel@redhat.com (moderated list:DEVICE-MAPPER  (LVM))
linux-kernel@vger.kernel.org (open list)

---

diff --git a/MAINTAINERS b/MAINTAINERS
index a4a0c2baaf27..3b9d679c6239 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5433,8 +5433,7 @@ F:	include/linux/devm-helpers.h
  DEVICE-MAPPER  (LVM)
  M:	Alasdair Kergon <agk@redhat.com>
  M:	Mike Snitzer <snitzer@redhat.com>
-M:	dm-devel@redhat.com
-L:	dm-devel@redhat.com
+L:	dm-devel@redhat.com (moderated for non-subscribers)
  S:	Maintained
  W:	http://sources.redhat.com/dm
  Q:	http://patchwork.kernel.org/project/dm-devel/list/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

