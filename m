Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D26C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 15 Feb 2022 02:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1644892860;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=E0tXMUeBzhe/wPRuIIXQ26Al/8WhWKagoytq9L4MWoI=;
	b=DnX691URNFIe17ZYd5/LJR5vYHEGu5FiOGwDMlgjdgzfQPAt2cJpeuQwGJh7N8hRJdPly2
	zZEOSSd4SF0Hx33hbgW2odKsQCYrKlE0CCqhyZpU0zzOe2MTXptj9evNhYloIEN4QOApeU
	2VJQBUoJdcMmuKYxqS+ai83dXWLpZIQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-35-y5WcBTJIPqGCS3YGszmZ7w-1; Mon, 14 Feb 2022 21:40:56 -0500
X-MC-Unique: y5WcBTJIPqGCS3YGszmZ7w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B6AAD839A42;
	Tue, 15 Feb 2022 02:40:51 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 58EC856F7D;
	Tue, 15 Feb 2022 02:40:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6647D4BB7C;
	Tue, 15 Feb 2022 02:40:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21F2ebMM007930 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 21:40:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 0A006145FBAA; Tue, 15 Feb 2022 02:40:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 065BE145FBA0
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 02:40:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFA551C07CCE
	for <dm-devel@redhat.com>; Tue, 15 Feb 2022 02:40:36 +0000 (UTC)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
	[209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-141-Ko_2cuVPMh6rOv2XWuAQMw-1; Mon, 14 Feb 2022 21:40:35 -0500
X-MC-Unique: Ko_2cuVPMh6rOv2XWuAQMw-1
Received: by mail-qv1-f69.google.com with SMTP id
	c8-20020a0ce7c8000000b0042c12357076so13067924qvo.6
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 18:40:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=7xZ94wx0xxHGjFOz2gdvaz5q0yIBiNDZwqvRJ9bfyDQ=;
	b=5Ox/2WBFNk3c/XeerZO4ICTmdDVANSW2B/CRIU/C+PGtfJLkbQzOaV2s1WoLpsQBhz
	Lk9Hkzp/MSf7emVatAw7i+YGg52IUMMknMD2Rr8T1pPclN93hhtkTg8w7xuaBK6EIkmN
	bik2drvnNkE70ipjBnzJPHKhuMN+wdIZgo054qTXc3NAy8kadfLz5/0hqW9ySz44oyuP
	fz8CEa5cMOcXPmAF3yIsihHdCsHqps9mntB4BA96ZkxcBCLOTRQKH+Mjh8U56jra0lvw
	q8GhjouqRd1C3jsij0J3JT34VlStP1ND5H4+KOzmY0bwus9IR+/swLsXcKR+rgGWdJQt
	A4qA==
X-Gm-Message-State: AOAM530JaEGKlnmm3S7vKUncU4IBKSfkG9KquyiIHcy25iuKxCesX3v6
	cOCJKAn7uS40GXnRB0aRALiM3mmwt9Z28ww2v/uv5kaRqIkTz3Kfkuy3CrffPjdhOprivRY7/d2
	BMMsARxM2wu+LEg==
X-Received: by 2002:ad4:576b:: with SMTP id r11mr1174316qvx.34.1644892834729; 
	Mon, 14 Feb 2022 18:40:34 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyjUxIh8PAkN+Wc/wo+m+HrG05WY5hQjIOeVqxluyBFBdCgdkI1egd9MPDeXG+iCh1nwO6+rA==
X-Received: by 2002:ad4:576b:: with SMTP id r11mr1174306qvx.34.1644892834506; 
	Mon, 14 Feb 2022 18:40:34 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	r2sm19304798qta.15.2022.02.14.18.40.33
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 14 Feb 2022 18:40:34 -0800 (PST)
Date: Mon, 14 Feb 2022 21:40:33 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Message-ID: <YgsSoZvc8YHBflfM@redhat.com>
References: <20220211214057.40612-1-snitzer@redhat.com>
	<20220211214057.40612-11-snitzer@redhat.com>
	<YgphC67SVZIWfhhs@infradead.org>
MIME-Version: 1.0
In-Reply-To: <YgphC67SVZIWfhhs@infradead.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 10/14] block: add
 bio_start_io_acct_remapped for the benefit of DM
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 14 2022 at  9:02P -0500,
Christoph Hellwig <hch@infradead.org> wrote:

> On Fri, Feb 11, 2022 at 04:40:53PM -0500, Mike Snitzer wrote:
> > DM needs the ability to account a clone bio's IO to the original
> > block_device. So add @orig_bdev argument to bio_start_io_acct_time.
> > 
> > Rename bio_start_io_acct_time to bio_start_io_acct_remapped.
> > 
> > Also, follow bio_end_io_acct and bio_end_io_acct_remapped pattern by
> > moving bio_start_io_acct to blkdev.h and have it call
> > bio_start_io_acct_remapped.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks.

But turns out I don't need this patch afterall.

DM can't account IO to the DM device in terms of clone bios because
they may not be simple remaps, the payload could change in size such
that the original vs clone varies widely.  Also, dmstats imposes the
additional constraint that the same bio be used for the
{start,end}_io_acct's calls to dm_stats_account_io().

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

