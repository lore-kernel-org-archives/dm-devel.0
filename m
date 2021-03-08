Return-Path: <SRS0=Ydjc=IG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.9 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MALFORMED_FREEMAIL,MISSING_HEADERS,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A6BFC433DB
	for <dm-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:20:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0F8F5651CC
	for <dm-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:20:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0F8F5651CC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-548-sb3K7R9wPEWZtmrLXgc5NQ-1; Mon, 08 Mar 2021 09:20:30 -0500
X-MC-Unique: sb3K7R9wPEWZtmrLXgc5NQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4C52E8018A1;
	Mon,  8 Mar 2021 14:20:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C5FC10074EF;
	Mon,  8 Mar 2021 14:20:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9CF271809C86;
	Mon,  8 Mar 2021 14:20:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 128EKIYA006758 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 8 Mar 2021 09:20:18 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E96EF30505; Mon,  8 Mar 2021 14:20:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E2B2A30509
	for <dm-devel@redhat.com>; Mon,  8 Mar 2021 14:20:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A57598551E2
	for <dm-devel@redhat.com>; Mon,  8 Mar 2021 14:20:15 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com
	[209.85.128.53]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-37-mhMLGLmqMiuUWos8KPCbow-1; Mon, 08 Mar 2021 09:20:13 -0500
X-MC-Unique: mhMLGLmqMiuUWos8KPCbow-1
Received: by mail-wm1-f53.google.com with SMTP id
	d139-20020a1c1d910000b029010b895cb6f2so3904501wmd.5; 
	Mon, 08 Mar 2021 06:20:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=ZvZTuaNXFKXz2YkaM8MZVnXnxA+iqxZl3hILT6AQxLo=;
	b=Jh7MWLzo5CL54pzSZf5UDYcP1UCBpfqmNnztmUK2u/xSIpbkkjQzxZTPFNQt6jCxJw
	LNhX1dUsD8y8rZXkeMYiqIH/98mJqh4EeZhGJk0w2LHBUtoBuBOKaQLM5yLyBqQTk8zs
	LkvrT/l6A/FY1/sZwJ3/9ZxWzMhtT1nFtHUUsaMPqZu0D15KuDYvgswj1XsFoSUKccEn
	khMcEYeWDx/e9Sgo4wluPyKdx15uisopb284c+y02C1O3MgHjigqSuioWebXw0NPkjHe
	taDAWKPCnKDQCpJNopRAXjxcdiDiUEXo1QtncgZvtyYC9+yXR9T19tmghiprYElIm1a8
	Gp1g==
X-Gm-Message-State: AOAM530TzuSvlkqIMwrgaOuBEQdXNXfgwMsNLSieO85fy0XNZeXdzsxA
	PHlWxmvOMAGOqDXgc4QLbU/Y4DTRVw==
X-Google-Smtp-Source: ABdhPJzP1bH5I80mLj/JY8rwZVTYXQxxHr+SxsdrqDPMebWoYxHCQpHDvNWnHt9bCNBPKTGjpDNuPg==
X-Received: by 2002:a1c:bad6:: with SMTP id k205mr13795664wmf.16.1615213211581;
	Mon, 08 Mar 2021 06:20:11 -0800 (PST)
Received: from localhost (215.red-81-43-178.staticip.rima-tde.net.
	[81.43.178.215]) by smtp.gmail.com with ESMTPSA id
	f7sm21282281wrm.36.2021.03.08.06.20.10
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Mon, 08 Mar 2021 06:20:11 -0800 (PST)
References: <20210306153022.38449-1-xose.vazquez@gmail.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <67f704b6-85a2-cd7f-c5ca-e7781168109e@gmail.com>
Date: Mon, 8 Mar 2021 15:20:09 +0100
MIME-Version: 1.0
In-Reply-To: <20210306153022.38449-1-xose.vazquez@gmail.com>
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
Cc: Martin Wilck <mwilck@suse.com>, DM-DEVEL ML <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipath-tools: add more info about
 max_sectors_kb in multipath.conf.5
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 2
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 3/6/21 4:30 PM, Xose Vazquez Perez wrote:

> To query the device:
> sg_inq -p 0xb0 /dev/sdX | grep "[ml] transfer length:"
> 
> 
> Note: some arrays does not report any value.
>        3PAR: 65534 blocks
>        RDAC: not reported
>        Hitachi VSP: query error

I was wrong. I rechecked the 3par, and it's 32768 blocks.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

