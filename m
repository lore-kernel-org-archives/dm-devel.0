Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7D3DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 27 Jan 2022 22:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643324236;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=3AkfxXX58oL2DtztBrpLxSvWkofJWv703S22kjZ7WXw=;
	b=Dn8pvcu+dkkFw5PQ5nrnhGAeOJBTZDsiOYhh1CmGSMmPPIWiMlfgKTtftLPs4BCxg8ZO3L
	yttOw8zaikCbcZPYefC0f0ZH0hc7UAzM/6/Qx3hwuDAIwmxXp58HCJbLbs03PnkL3SLVkh
	FUGzDDzD0qe9z7yZRX9/nl+G9dvWoCw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-uGu0_h3xNEyq18RUhRboyg-1; Thu, 27 Jan 2022 17:57:13 -0500
X-MC-Unique: uGu0_h3xNEyq18RUhRboyg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C99C31091DA1;
	Thu, 27 Jan 2022 22:56:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BD295DB98;
	Thu, 27 Jan 2022 22:56:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4FF451809CB8;
	Thu, 27 Jan 2022 22:56:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20RMusM3019704 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 27 Jan 2022 17:56:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E21C8C080B3; Thu, 27 Jan 2022 22:56:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE635C07F3F
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 22:56:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C537D185A794
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 22:56:53 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
	[209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-580-ONCmIR5GOiy8Qa2fbtGo-A-1; Thu, 27 Jan 2022 17:56:50 -0500
X-MC-Unique: ONCmIR5GOiy8Qa2fbtGo-A-1
Received: by mail-qk1-f198.google.com with SMTP id
	z205-20020a3765d6000000b0047db3b020dfso3466853qkb.22
	for <dm-devel@redhat.com>; Thu, 27 Jan 2022 14:56:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:from:to:cc:subject:date:message-id;
	bh=4ypfieO2Jyh9U46NiitKLMWIe9+KPUMGQFOBN1h1jsM=;
	b=nNisSWTrb7vAZmnXa3KMpjD3s7wYGN/S4VyKPw1lkfaIJPhvn3XD1vv61yDCmAwUiZ
	wTUK4jWIU4a4eVCiXB+FqFYBvjT1NX1U8UGboARs9Hzjh4W4bedBTIyUg6/onJEFUy6e
	lX4M+v1jpEbhHyvEdhuTnB48qcBQlKF3OzNsQUZ5mWLn812j4CuHHZT/olq21zo2Pkck
	tJct42pIDfTUsMd23nmnnqu13zW33aQhUBSIsylQvJljCDfkIIs9LQsFJn4c2wzdZ73u
	C3dFAbzs3CQOEOzap1dzsUvqkn86HxXValdl97Y82kcicOG3Aj+tT1OJhPAxcftxZ1yF
	HHwQ==
X-Gm-Message-State: AOAM531Y8esw8SnJGaWiHBqyKXdkstypB0JzDv8l/1GGgZR3ByiEQUo9
	8CPdORA3VUn8U4fD8AoFpzPIUEsAJGArgjWW5zNqpAbc+3Ac7/tTlOM9MviVX33v/ygK/uJJVHb
	aFreYmeNcROmtUg==
X-Received: by 2002:ac8:5aca:: with SMTP id d10mr4388379qtd.565.1643324209841; 
	Thu, 27 Jan 2022 14:56:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzmS1pI1ksa1bPtOtG1Lk5tKoq80e0w9eNzyrwLb/Qwj5C/dnVzsFjiOSoSy1ZOXd0q6GooYw==
X-Received: by 2002:ac8:5aca:: with SMTP id d10mr4388368qtd.565.1643324209642; 
	Thu, 27 Jan 2022 14:56:49 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	m130sm1979335qke.55.2022.01.27.14.56.48
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Thu, 27 Jan 2022 14:56:49 -0800 (PST)
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Date: Thu, 27 Jan 2022 17:56:45 -0500
Message-Id: <20220127225648.28729-1-snitzer@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
Subject: [dm-devel] [PATCH v2 0/3] block/dm: fix bio-based DM IO accounting
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Jens,

Just over 3 years ago, with commit a1e1cb72d9649 ("dm: fix redundant
IO accounting for bios that need splitting") I focused too narrowly on
fixing the reported potential for redundant accounting for IO totals.
Which, at least mentally for me, papered over how inaccurate all other
bio-based DM's IO accounting is for bios that get split.

This set fixes things up properly by allowing DM to start IO
accounting _after_ IO is submitted and a split is occurred.  The
proper start_time is still established (prior to submission), it is
passed in to a new bio_start_io_acct_time().  This eliminates the need
for any DM hack to rewind block core's excessive accounting in the
face of a split bio recursing back to block core.

All said: If you'd provide your Acked-by(s) I'm happy to send this set
to Linus for v5.17-rc (and shepherd the changes into stable@ kernels).
Or you're welcome to pickup this set to send along (I'd obviously
still do any stable@ backports). NOTE: the 3rd patch references the
linux-dm.git commit id for the 1st patch.. so that'll require tweaking
no matter who sends the changes to Linus.

Please advise, thanks.
Mike

v1 -> v2: made block changes suggested by Christoph

Mike Snitzer (3):
  block: add bio_start_io_acct_time() to control start_time
  dm: revert partial fix for redundant bio-based IO accounting
  dm: properly fix redundant bio-based IO accounting

 block/blk-core.c       | 25 +++++++++++++++++++------
 drivers/md/dm.c        | 20 +++-----------------
 include/linux/blkdev.h |  1 +
 3 files changed, 23 insertions(+), 23 deletions(-)

-- 
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

