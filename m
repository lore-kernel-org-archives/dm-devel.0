Return-Path: <SRS0=GP8t=EO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 870F4C388F7
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 00:06:36 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E2CDC206A4
	for <dm-devel@archiver.kernel.org>; Sun,  8 Nov 2020 00:06:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2CDC206A4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-Ytwbgf7TO_mKOeIx5vEWVg-1; Sat, 07 Nov 2020 19:06:32 -0500
X-MC-Unique: Ytwbgf7TO_mKOeIx5vEWVg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8A45107AFAE;
	Sun,  8 Nov 2020 00:06:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 21B2F2634D;
	Sun,  8 Nov 2020 00:06:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AD90E922F9;
	Sun,  8 Nov 2020 00:06:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A806HNv014167 for <dm-devel@listman.util.phx.redhat.com>;
	Sat, 7 Nov 2020 19:06:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 334D25D237; Sun,  8 Nov 2020 00:06:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E01A5D231
	for <dm-devel@redhat.com>; Sun,  8 Nov 2020 00:06:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C63CA801224
	for <dm-devel@redhat.com>; Sun,  8 Nov 2020 00:06:14 +0000 (UTC)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
	[209.85.128.65]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-493-0HWmd3QEOkC10N739nK_Hg-1; Sat, 07 Nov 2020 19:06:12 -0500
X-MC-Unique: 0HWmd3QEOkC10N739nK_Hg-1
Received: by mail-wm1-f65.google.com with SMTP id a65so4679664wme.1;
	Sat, 07 Nov 2020 16:06:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:message-id:date
	:mime-version:in-reply-to:content-language:content-transfer-encoding;
	bh=kFn6cqfX/TpmmfINj6czeavmpFKnZ6z6sQTNqxq/lo8=;
	b=qZStg61McY0O2YB1B3o4QJuo6FZfFLQ+dO5EatKMaTBenh2QjwJuEFQwRgqF9uxTXW
	+kY/18g9v0lcv4qlovuksbICalIarrqep00H/UWJntM5Q2vuM/y0Re8/O2dcyT6nkGUy
	ZVRu4ffVoU/Njw8kmP+r9SVgeqMO5L+B3DGaKHKIlEL8rhK7EBcQ6MdhlAa32Tg4lTaf
	+TXHYI9xlQAPBp6mUur27jqeE51RqZD8FSblo6uAew02g/fzQnLjNHb1xXK2Iot8C+jO
	M85wxm6r9ub8IVRdVH0CeeTUABMZ1QFTyTHSlUXE4CC+DqbPBJJlVJ/3vxTZIGvwFiNd
	wt8g==
X-Gm-Message-State: AOAM533uFsLqnMwBR9nuZf2/33AYBOntH1SjN00P6dlKyDfK+N5G6AMm
	XZuDyj+3LWoT6AOe32CTlULv0CIS9g==
X-Google-Smtp-Source: ABdhPJzCU/556Bu6Y3sGGBETfKGuFiXCP1vOoJ0YI0IlUrno1WjRoiFopmFMaijOFNXW4Cv5xpnrHA==
X-Received: by 2002:a1c:2203:: with SMTP id i3mr7057347wmi.144.1604793970984; 
	Sat, 07 Nov 2020 16:06:10 -0800 (PST)
Received: from localhost (52.red-37-12-21.dynamicip.rima-tde.net.
	[37.12.21.52])
	by smtp.gmail.com with ESMTPSA id i5sm757899wrw.45.2020.11.07.16.06.09
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Sat, 07 Nov 2020 16:06:10 -0800 (PST)
To: Martin Wilck <mwilck@suse.com>, Benjamin Marzinski <bmarzins@redhat.com>, 
	Christophe Varoqui <christophe.varoqui@opensvc.com>
References: <20201105114952.1059-1-mwilck@suse.com>
	<20201106004115.GH3384@octiron.msp.redhat.com>
	<39c3227eb6fc8c9edb0f8927b180005e5b4ff445.camel@suse.com>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Message-ID: <86a2e07b-6e5b-3da5-4da4-2fa181aee0d1@gmail.com>
Date: Sun, 8 Nov 2020 01:06:08 +0100
MIME-Version: 1.0
In-Reply-To: <39c3227eb6fc8c9edb0f8927b180005e5b4ff445.camel@suse.com>
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
Cc: dm-devel@redhat.com
Subject: Re: [dm-devel] [RFC PATCH] libmultipath: prevent DSO unloading with
 astray checker threads
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 11/6/20 6:32 PM, Martin Wilck wrote:

> @Christophe, any chance to move forward with the merge?
> (then we can go ahead with this patch later, too...)

These two are trivial enough, and they are missing at upstream-queue:
https://marc.info/?t=160400981300001
https://marc.info/?t=160401170800001

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

