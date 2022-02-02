Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C52B4C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 19:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1643831035;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nj04FilQloPwMEoxUSdEpnsAVKBUwr4z0eDjoRfbRxg=;
	b=VPk4+b9DWOj9ztjJCL4SCrU4u70tRDOQfs/fvnJTWhYah0VGMz2C8E7e9clThtK6dOhGjH
	JrbSZyrz2RQUqBSkMZTxCtjD4NOc+2uGpUrfhdWgiWe34m8QnW9uvTDrp2nWYzq0OmW4Hg
	3hQwoAFHYgSkVn3IIdZybTS8rwmkjyk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-250-8eKv4PQwNnmyMQ6KBDjnCg-1; Wed, 02 Feb 2022 14:43:52 -0500
X-MC-Unique: 8eKv4PQwNnmyMQ6KBDjnCg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A676610B7440;
	Wed,  2 Feb 2022 19:43:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 28682604CC;
	Wed,  2 Feb 2022 19:43:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A3FF0180B654;
	Wed,  2 Feb 2022 19:43:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212JgbQq010774 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 14:42:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 23FCB141DED3; Wed,  2 Feb 2022 19:42:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 20572141DED0
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 19:42:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0707F811E7A
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 19:42:37 +0000 (UTC)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
	[209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-378-4wgzWGOLNuO58yRWHfPzSw-1; Wed, 02 Feb 2022 14:42:35 -0500
X-MC-Unique: 4wgzWGOLNuO58yRWHfPzSw-1
Received: by mail-qt1-f199.google.com with SMTP id
	x10-20020ac8700a000000b002c3ef8fc44cso159689qtm.8
	for <dm-devel@redhat.com>; Wed, 02 Feb 2022 11:42:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=Ll15QSD/t84/Hy62h63iGXwWFrEUBsyZcwen7Ur2tv4=;
	b=RCfOfmdTS8NNAYNGD4QZ3jW+hqwc/iNsM9+sHkNUN0eZGnFuAgSozDuEqywbHq17Jh
	T8bGZGakUj4uO4VeTmrGgpECFEx+dV8FZ2LY5Ythsld9S5lGp6roZ6Vn6I4UXmufcIxL
	+dmndIw7msNBnOUs1O8gnrh/ObYPhOdllWVQNWdKnHsKcW2KYQtP4iEmxJDeGtWWOy0n
	pGW9OuSIxmxBx06FE0QcKpHumM5p9N1da/+PiJp0wWe3cnq3CnXLxkb57MdjMMqW6y7c
	8NMCSSJPrqrn4VKMgbCVE/K5M4w0IbkIdM8e6jKzHPlvA7xQ2gV52Vv/JtpWUa6o+Lhh
	7UuA==
X-Gm-Message-State: AOAM530k4nbR2R8pYEKJQVaE+I/0qzSiYg2rlKTbJtm2f0ANgV4/o0QR
	JaoF7oF4PeWI+yqspPQSOu+gy4vLSdyEUPnfwkvceybZZCgC/S+QF0bkALNMwUnpw04op1P5XJ3
	x1mzXgGS2l/+c5Q==
X-Received: by 2002:a05:6214:1d0b:: with SMTP id
	e11mr28129211qvd.50.1643830955518; 
	Wed, 02 Feb 2022 11:42:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzd2HY0NfWrAJF52rEsggSv2Saz5rMDX7hMk30XVxVEf046yTiVaBhX0lsvYwv7x9JpaXU/Wg==
X-Received: by 2002:a05:6214:1d0b:: with SMTP id
	e11mr28129197qvd.50.1643830955330; 
	Wed, 02 Feb 2022 11:42:35 -0800 (PST)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52])
	by smtp.gmail.com with ESMTPSA id h6sm14065391qko.7.2022.02.02.11.42.34
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Wed, 02 Feb 2022 11:42:34 -0800 (PST)
Date: Wed, 2 Feb 2022 14:42:33 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YfreqbCOPYFrQm73@redhat.com>
References: <20220202160109.108149-1-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20220202160109.108149-1-hch@lst.de>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Philipp Reisner <philipp.reisner@linbit.com>,
	linux-block@vger.kernel.org, dm-devel@redhat.com,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Pavel Begunkov <asml.silence@gmail.com>, drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] improve the bio cloning interface v2
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

On Wed, Feb 02 2022 at 11:00P -0500,
Christoph Hellwig <hch@lst.de> wrote:

> Hi Jens,
> 
> this series changes the bio cloning interface to match the rest changes
> to the bio allocation interface and passes the block_device and operation
> to the cloning helpers.  In addition it renames the cloning helpers to
> be more descriptive.
> 
> To get there it requires a bit of refactoring in the device mapper code.
> 
> Changes since v1:
>  - rebased to the lastest for-5.18/block tree
>  - fix a fatal double initialization in device mapper
> 
> A git tree is also available here:
> 
>     git://git.infradead.org/users/hch/block.git bio_alloc-cleanup-part2
> 
> Gitweb:
> 
>     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bio_alloc-cleanup-part2
> 
> Diffstat:
>  Documentation/block/biodoc.rst   |    5 -
>  block/bio-integrity.c            |    1 
>  block/bio.c                      |  106 +++++++++++++-----------
>  block/blk-crypto.c               |    1 
>  block/blk-mq.c                   |    4 
>  block/bounce.c                   |    3 
>  drivers/block/drbd/drbd_req.c    |    5 -
>  drivers/block/drbd/drbd_worker.c |    4 
>  drivers/block/pktcdvd.c          |    4 
>  drivers/md/bcache/request.c      |    6 -
>  drivers/md/dm-cache-target.c     |   26 ++----
>  drivers/md/dm-crypt.c            |   11 +-
>  drivers/md/dm-zoned-target.c     |    3 
>  drivers/md/dm.c                  |  166 +++++++++++++--------------------------
>  drivers/md/md-faulty.c           |    4 
>  drivers/md/md-multipath.c        |    4 
>  drivers/md/md.c                  |    5 -
>  drivers/md/raid1.c               |   34 +++----
>  drivers/md/raid10.c              |   16 +--
>  drivers/md/raid5.c               |    4 
>  fs/btrfs/extent_io.c             |    4 
>  include/linux/bio.h              |    6 -
>  22 files changed, 183 insertions(+), 239 deletions(-)
> 

Looks good, for all:

Reviewed-by: Mike Snitzer <snitzer@redhat.com>

I have some DM core changes for 5.18 that I need to make and this
patchset offers enough DM churn that I'd like to base my changes
ontop.  So I'd appreciate it if this patchset could land in block's
for-5.18 ASAP.

Thanks,
Mike

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

