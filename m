Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54AD9C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 28 Feb 2022 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1646065685;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=mI1llvXVPdmVCQg2wLC0EPEH2W+t+U6o2pJ7s98dcgY=;
	b=QrTiTjmkGrBuDZnpX8jl4GsASE+/KMWmZA32hk24zynYF9E2AAgMMpmIVXGnedMI1xQHuG
	neAOu/x0agH85FtMQvGM/CV6FYq/6oAzB5aCASfTrQ1vuHe9Wtai1NMT5TT8PeU5TEg4nf
	vWQZ8H399NLFjquI7pa6HcCfm1vUzd4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-Wb6gCZbaOiavKHFC7UddnA-1; Mon, 28 Feb 2022 11:28:01 -0500
X-MC-Unique: Wb6gCZbaOiavKHFC7UddnA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59C39800422;
	Mon, 28 Feb 2022 16:27:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 22DA17DE33;
	Mon, 28 Feb 2022 16:27:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6611E1809C98;
	Mon, 28 Feb 2022 16:27:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21SGRs0u021998 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Feb 2022 11:27:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 004E92026D69; Mon, 28 Feb 2022 16:27:54 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE7FF2026D6B
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 16:27:48 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7557F2999B2C
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 16:27:48 +0000 (UTC)
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
	[209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-460-0-5kRTk5PVKuM9KhFixmEw-1; Mon, 28 Feb 2022 11:27:47 -0500
X-MC-Unique: 0-5kRTk5PVKuM9KhFixmEw-1
Received: by mail-qv1-f72.google.com with SMTP id
	o4-20020a0ccb04000000b0043299e903e5so11410282qvk.9
	for <dm-devel@redhat.com>; Mon, 28 Feb 2022 08:27:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=qkqO4WyPsrXQ7pdah2RqVsOYeXGLOr/c/Kjxy3SJ4Tg=;
	b=TXNE5TfXwPIW5TBX+H5syWesygbDn4vViEmHt6nP6wWPuYYStw7KcHQVaTox6oYSQ6
	WH3clNOqxM+smp0Em48ElF+bKMyfPyOZjMDCAQz28xgxvCWmb5n479icIHyKiVgXupaT
	lKZ8oYWbn7JqN0fftPGhnQyuYV8kb8Bqn+g4ayri15e4u1TTY6szTVtGO9VKDspLgMxB
	zRSFUk2uaG7Z13noysAwG+qvjSpNTm23/9cj7ArFGIaOOWdjymW3d4QGr6PPcHjnB3Jg
	kf+REIpUW6UTBMRlng0qfotehloeVBRz1k/m/sNQPPILcispjAP89iNVel+tsYFpFrf4
	JbVA==
X-Gm-Message-State: AOAM530bW5VJ4lMFUNWffw/hebv+A3I+66Cv5e91tEa8y0w60CIv2836
	1p1Kerjf0XodUqLkBGZDwoZn23Gko7HdMgwy1lzDS+szQU7XfzT6fpglww9tIAwJYAQXvxF9Lty
	InaxJAHb3r6mKwQ==
X-Received: by 2002:a37:a2ca:0:b0:47d:8c2f:c3d3 with SMTP id
	l193-20020a37a2ca000000b0047d8c2fc3d3mr11162126qke.287.1646065666424;
	Mon, 28 Feb 2022 08:27:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwA60xCEtiITWiusl7AJY0rzXeBFgfRODZ5ofroFmbcGfRe3sjw1d3qMMbiZc0x9vEX0ccabg==
X-Received: by 2002:a37:a2ca:0:b0:47d:8c2f:c3d3 with SMTP id
	l193-20020a37a2ca000000b0047d8c2fc3d3mr11162121qke.287.1646065666206;
	Mon, 28 Feb 2022 08:27:46 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	c6-20020ac87d86000000b002ddd9f33ed1sm6847024qtd.44.2022.02.28.08.27.45
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 28 Feb 2022 08:27:45 -0800 (PST)
Date: Mon, 28 Feb 2022 11:27:44 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <Yhz4AGXcn0DUeSwq@redhat.com>
References: <20210623074032.1484665-1-ming.lei@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20210623074032.1484665-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	dm-devel@redhat.com, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH V3 0/3] block/dm: support bio polling
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

On Wed, Jun 23 2021 at  3:40P -0400,
Ming Lei <ming.lei@redhat.com> wrote:

> Hello Guys,
> 
> Based on Christoph's bio based polling model[1], implement DM bio polling
> with one very simple approach.
> 
> Patch 1 adds helper of blk_queue_poll().
> 
> Patch 2 adds .bio_poll() callback to block_device_operations, so bio
> driver can implement its own logic for io polling.
> 
> Patch 3 implements bio polling for device mapper.
> 
> 
> V3:
> 	- patch style change as suggested by Christoph(2/3)
> 	- fix kernel panic issue caused by nested dm polling, which is found
> 	  & figured out by Jeffle Xu (3/3)
> 	- re-organize setup polling code (3/3)
> 	- remove RFC
> 
> V2:
> 	- drop patch to add new fields into bio
> 	- support io polling for dm native bio splitting
> 	- add comment
> 
> Ming Lei (3):
>   block: add helper of blk_queue_poll
>   block: add ->poll_bio to block_device_operations
>   dm: support bio polling
> 
>  block/blk-core.c         |  18 +++---
>  block/blk-sysfs.c        |   4 +-
>  block/genhd.c            |   2 +
>  drivers/md/dm-table.c    |  24 +++++++
>  drivers/md/dm.c          | 131 ++++++++++++++++++++++++++++++++++++++-
>  drivers/nvme/host/core.c |   2 +-
>  include/linux/blkdev.h   |   2 +
>  7 files changed, 170 insertions(+), 13 deletions(-)
> 
> -- 
> 2.31.1
> 

Hey Ming,

I'd like us to follow-through with adding bio-based polling support.
Kind of strange none of us that were sent this V3 ever responded,
sorry about that!

Do you have interest in rebasing this patchset (against linux-dm.git's
"dm-5.18" branch since there has been quite some churn)?  Or are you
OK with me doing the rebase?

thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

