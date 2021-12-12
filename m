Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB245C433F5
	for <dm-devel@archiver.kernel.org>; Sun, 12 Dec 2021 14:39:41 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-5O2aFJ_KPkOGi4uIN21-aA-1; Sun, 12 Dec 2021 09:39:37 -0500
X-MC-Unique: 5O2aFJ_KPkOGi4uIN21-aA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF2442F24;
	Sun, 12 Dec 2021 14:39:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C9594ABA2;
	Sun, 12 Dec 2021 14:39:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0DE681809CB9;
	Sun, 12 Dec 2021 14:39:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BCEdUDS030312 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 12 Dec 2021 09:39:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 16C1FC159F6; Sun, 12 Dec 2021 14:39:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 11F17C23DB1
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 14:39:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED5FD800B21
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 14:39:29 +0000 (UTC)
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com
	[209.85.216.54]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-272-t_m6P2eRPwK2-sGWghB5NA-1; Sun, 12 Dec 2021 09:39:28 -0500
X-MC-Unique: t_m6P2eRPwK2-sGWghB5NA-1
Received: by mail-pj1-f54.google.com with SMTP id
	j6-20020a17090a588600b001a78a5ce46aso12891689pji.0
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 06:39:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=c2zny3Bx2o60PdHAHhyf6q+y4E1Ceap0f1n6TKcneOk=;
	b=NFjjfRm7Aflo/OvramsX7FG8okI1hB1ZxKJoRx59BG3sB4j9a0V/Hmv3pJ87A/zV/m
	1bedKTIvoHKOKLZj+5E4zK3rsCUoW+dXQECvYgT4TMER8rUAORjBKpEMX5TBPOB1sYPj
	J2qkF2eleZ05/75a6PxEwZEjyItxbNFHjrbsF0vR0Ej7muo/xvNLHfY2mAa369khqdAw
	sKZqu3LjcXTvDYj2RxYTId8DNkHdiUzI9lLFbKOBFmFrKUfUI/2GGklkY+g0HA2u+TQF
	FPYg8TohIs3uSH9ttms2abl+dtg7vqq2E3OPpOpQ8aRHKI7Y2t7DWzKnx8mYD9E14HX/
	16Tg==
X-Gm-Message-State: AOAM531LSg27JYVEnfVHJ7NY0J18dsIz9e9udlMq+W3kGbWqvliPn69Q
	2iXann1Qet689PRSL3beahO3vOZouEUDzS9Pa1u0fg==
X-Google-Smtp-Source: ABdhPJz2lbfhBkbKpu43+79k6Z3alD86owZO4X5IPgFqiWUlbzwsnwFTD+5Dey+ZqI2i+TrJIWAD/hQxem3DZ5dPHCE=
X-Received: by 2002:a17:90b:1e07:: with SMTP id
	pg7mr37441884pjb.93.1639319967232; 
	Sun, 12 Dec 2021 06:39:27 -0800 (PST)
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-5-hch@lst.de>
In-Reply-To: <20211209063828.18944-5-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 06:39:16 -0800
Message-ID: <CAPcyv4gZjkVW0vwNLChXCCBVF8CsSZityzSVmcGAk79-mt9yOw@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/5] dax: remove the copy_from_iter and
	copy_to_iter methods
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Dec 8, 2021 at 10:38 PM Christoph Hellwig <hch@lst.de> wrote:
>
> These methods indirect the actual DAX read/write path.  In the end pmem
> uses magic flush and mc safe variants and fuse and dcssblk use plain ones
> while device mapper picks redirects to the underlying device.
>
> Add set_dax_virtual() and set_dax_nomcsafe() APIs for fuse to skip these
> special variants, then use them everywhere as they fall back to the plain
> ones on s390 anyway and remove an indirect call from the read/write path
> as well as a lot of boilerplate code.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c           | 36 ++++++++++++++--
>  drivers/md/dm-linear.c        | 20 ---------
>  drivers/md/dm-log-writes.c    | 80 -----------------------------------
>  drivers/md/dm-stripe.c        | 20 ---------
>  drivers/md/dm.c               | 50 ----------------------
>  drivers/nvdimm/pmem.c         | 20 ---------
>  drivers/s390/block/dcssblk.c  | 14 ------
>  fs/dax.c                      |  5 ---
>  fs/fuse/virtio_fs.c           | 19 +--------
>  include/linux/dax.h           |  9 ++--
>  include/linux/device-mapper.h |  4 --
>  11 files changed, 37 insertions(+), 240 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e81d5ee57390f..ff676a07480c8 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -105,6 +105,10 @@ enum dax_device_flags {
>         DAXDEV_WRITE_CACHE,
>         /* flag to check if device supports synchronous flush */
>         DAXDEV_SYNC,
> +       /* do not use uncached operations to write data */
> +       DAXDEV_CACHED,
> +       /* do not use mcsafe operations to read data */
> +       DAXDEV_NOMCSAFE,

Linus did not like the mcsafe name, and this brings it back. Let's
flip the polarity to positively indicate which routine to use, and to
match the 'nofault' style which says "copy and handle faults".

/* do not leave the caches dirty after writes */
DAXDEV_NOCACHE

/* handle CPU fetch exceptions during reads */
DAXDEV_NOMC

...and then flip the use cases around.

Otherwise, nice cleanup. In retrospect I took the feedback to push
this decision to a driver a bit too literally, this is much better.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

