Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A837BC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 23 Feb 2022 03:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1645585400;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yNbbF+9TycfoivowYGsfFxFUnP5KDz1tGmj26m4St28=;
	b=c7uXPcI/yKa1HNfUHTJKufCXn9KKC/A15YyZiCTMpUnZzZHGZP05kHjuFj7vNdcEPPAfPL
	y7/0BdRtAaQck2ToUal65/0k+mVPHgtrU3jFeyaDNKqi/VruZsGzmGnEnm7v+i9MfAdITb
	i1LsDd319x1jR40GkfgG9IqCMYNn8n0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-505-0OE1pOdAMQeCLHKcifAfiw-1; Tue, 22 Feb 2022 22:03:16 -0500
X-MC-Unique: 0OE1pOdAMQeCLHKcifAfiw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18B2F1091DA2;
	Wed, 23 Feb 2022 03:03:12 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 50214E2E8;
	Wed, 23 Feb 2022 03:03:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 89F554A701;
	Wed, 23 Feb 2022 03:03:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21N33418006493 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 22 Feb 2022 22:03:04 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 91924407E1C1; Wed, 23 Feb 2022 03:03:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DE05407E1C0
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 03:03:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 749AA3C01C08
	for <dm-devel@redhat.com>; Wed, 23 Feb 2022 03:03:04 +0000 (UTC)
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
	[209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-357-nUC7opAUN9mK5xtYnxQU-g-1; Tue, 22 Feb 2022 22:03:03 -0500
X-MC-Unique: nUC7opAUN9mK5xtYnxQU-g-1
Received: by mail-yw1-f197.google.com with SMTP id
	00721157ae682-2d6994a6942so158090687b3.17
	for <dm-devel@redhat.com>; Tue, 22 Feb 2022 19:03:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=bnCDqCPu5W0nS2hNz/cxEej5P/bK9uYNkG/dZB6UyI0=;
	b=TDJafwAmM+Dn0Er0CeVz1w6TyDmssLW+Jau2PQ/pCMznGkSdRtE+4Fi5vVezjG+dja
	6lTctnCtLC5RPkC0uQaxHd26jhTm+tV5TcKbAC4prJmBN8PNL6agfqO/kKVdLaCu2UMF
	E6LO1xJlIE2mlg3jW8iSZQcHreIclg4oZB9eAr4XHko0I4D2WbXh0aMbjLbAITgXVRrn
	yKhVv6fJPEUKE1WaJXD/o2khNkJoSSwJeyZZkYfNCYdOrgkAvGuTfwkKp7+8HEaytDMo
	pyat49lPc7zqfUjPt2mdsj849Hfnj4+OzDmxCalD6ZWH3OKjhHrbUm8mozl2xXPrHtjk
	7DMQ==
X-Gm-Message-State: AOAM533N9B0kQxxpC5Ig2ZtGduEyU8kNrnL/Gl4BBuqrQvcqPR9xamJ2
	EZDBSaHZBQWY57v9nSkXS2DpEK9sMDEwuSzzyvXP7Rl10MiIQRfPW8eI9uzQjcpge7VDYo6zKAP
	9r2PlJjVQgToISX8TYcEQPdSnhrqqMw==
X-Received: by 2002:a0d:fa43:0:b0:2d1:8d8f:c269 with SMTP id
	k64-20020a0dfa43000000b002d18d8fc269mr27001639ywf.339.1645585382380;
	Tue, 22 Feb 2022 19:03:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwj++PjFVV0e3k8Op/BtxxBb6FKBeMdRJEFc7pr6Ga0zPM8zbz70fzZ/wC/g+9TFN6DjPgpZJZvDmn1UAi0+Ls=
X-Received: by 2002:a0d:fa43:0:b0:2d1:8d8f:c269 with SMTP id
	k64-20020a0dfa43000000b002d18d8fc269mr27001622ywf.339.1645585382182;
	Tue, 22 Feb 2022 19:03:02 -0800 (PST)
MIME-Version: 1.0
References: <c64d2143-284e-7621-440c-971e3405b4d8@virtuozzo.com>
	<d209a0b1-2514-79a0-257a-22bcb372785a@virtuozzo.com>
	<1d287c7e-8aff-beea-1bd6-4b2226f9f3db@opensource.wdc.com>
In-Reply-To: <1d287c7e-8aff-beea-1bd6-4b2226f9f3db@opensource.wdc.com>
From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 22 Feb 2022 22:02:51 -0500
Message-ID: <CAH6w=ayrR0yRCumgjtyB+mt_+33S6PHxBQDcwYVcuQ79ECYd7A@mail.gmail.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	Kirill Tkhai <ktkhai@virtuozzo.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"agk@redhat.com" <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH RESEND v2] dm: Fix use-after-free in
	dm_cleanup_zoned_dev()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 17, 2022 at 5:49 AM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> On 2/17/22 19:13, Kirill Tkhai wrote:
> >
> > dm_cleanup_zoned_dev() uses queue, so it must be called
> > before blk_cleanup_disk() starts its killing:
> >
> > blk_cleanup_disk->blk_cleanup_queue()->kobject_put()->blk_release_queue()->
> > ->...RCU...->blk_free_queue_rcu()->kmem_cache_free()
> >
> > Otherwise, RCU callback may be executed first,
> > and dm_cleanup_zoned_dev() touches freed memory:
>
> Mike,
>
> Can you queue this please ?

I queued it earlier today, please see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.18&id=588b7f5df0cb64f281290c7672470c006abe7160

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

