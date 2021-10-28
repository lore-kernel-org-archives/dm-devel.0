Return-Path: <SRS0=rauK=PQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10DFC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 01:41:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3E1C361107
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 01:41:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3E1C361107
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-k2Sn4s5uPo2Q9DjE7SlwdQ-1; Wed, 27 Oct 2021 21:41:41 -0400
X-MC-Unique: k2Sn4s5uPo2Q9DjE7SlwdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 16CAC1808324;
	Thu, 28 Oct 2021 01:41:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA0081ACBB;
	Thu, 28 Oct 2021 01:41:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7338A4A703;
	Thu, 28 Oct 2021 01:41:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19S1fXwm028883 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Oct 2021 21:41:33 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2D7A82144B22; Thu, 28 Oct 2021 01:41:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2840B2144B20
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 01:41:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 429698022F4
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 01:41:30 +0000 (UTC)
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com
	[209.85.216.44]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-497-ERgbEc9ZP9eXFXdMCm9Lvg-1; Wed, 27 Oct 2021 21:41:26 -0400
X-MC-Unique: ERgbEc9ZP9eXFXdMCm9Lvg-1
Received: by mail-pj1-f44.google.com with SMTP id
	x1-20020a17090a530100b001a1efa4ebe6so4387044pjh.0
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 18:41:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=+57OykW2c30gUJR4jUskDQk4x1gwxn9Qbm17JsREFMA=;
	b=WpvcEC//DZG2pu9pzZD8hmPLZuZNIcJxZSkGfBy2PnhnI2+te4MgdauBg4P0BAyx/T
	Edv/UUYCJOYWVVhJ6GFQTmdwyMH00RVulG2K8Ka6rjHixxX+BHRHCsY1HVrDiPMq0XS5
	gCT7KfL6vFFk/NfCe7MjOvX3X4uIlOC/CzvlmTXYkzewXyGLtdgTf9McUuvsGpOyWjLu
	Qnlwt/8hQmczAM/XG8mf6xl8LpKXrtwXE4YUzesZBlyItVCuB9DspXI2FHepFcyH+Q9M
	zNDiHxhLA26S+QtLL/IztY7iPdf39k/sn/yKPEY8tsYcQjyRGhBRjgJjPhZxsqvvQfy/
	C8sA==
X-Gm-Message-State: AOAM531zZ83XCgu2bTh5AiBFVO9I/JSdn9V4nhLgqnq8waf3I5Ppuds0
	fyGLBcGpmq8p9v4XezkdRcZIHQv0ZiEeq+2vmj9vMQ==
X-Google-Smtp-Source: ABdhPJy+l4+hDjjFqjiYrNzY24jHwGCV82yPyLMD7+lqHF6GqMdOIsbo6sHeOhaMgqSlqL4IZjgKI/J2hsCPQtYDPIA=
X-Received: by 2002:a17:902:ab50:b0:13f:4c70:9322 with SMTP id
	ij16-20020a170902ab5000b0013f4c709322mr995386plb.89.1635385285322;
	Wed, 27 Oct 2021 18:41:25 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de>
	<20211018044054.1779424-11-hch@lst.de>
In-Reply-To: <20211018044054.1779424-11-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Oct 2021 18:41:13 -0700
Message-ID: <CAPcyv4iLbbqyAsy1yjFXT48D3Ssp+jy4EMJt+Sj_o2W-WMgK9w@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 10/11] dm-stripe: add a stripe_dax_pgoff
	helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> Add a helper to perform the entire remapping for DAX accesses.  This
> helper open codes bdev_dax_pgoff given that the alignment checks have
> already been done by the submitting file system and don't need to be
> repeated.

Again, looks good. Kind of embarrassing when the open-coded version is
less LOC than using the helper.

Mike, ack?

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-stripe.c | 63 ++++++++++--------------------------------
>  1 file changed, 15 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index f084607220293..50dba3f39274c 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -301,83 +301,50 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
>  }
>
>  #if IS_ENABLED(CONFIG_FS_DAX)
> -static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
> -               long nr_pages, void **kaddr, pfn_t *pfn)
> +static struct dax_device *stripe_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
>  {
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
>         struct stripe_c *sc = ti->private;
> -       struct dax_device *dax_dev;
>         struct block_device *bdev;
> +       sector_t dev_sector;
>         uint32_t stripe;
> -       long ret;
>
> -       stripe_map_sector(sc, sector, &stripe, &dev_sector);
> +       stripe_map_sector(sc, *pgoff * PAGE_SECTORS, &stripe, &dev_sector);
>         dev_sector += sc->stripe[stripe].physical_start;
> -       dax_dev = sc->stripe[stripe].dev->dax_dev;
>         bdev = sc->stripe[stripe].dev->bdev;
>
> -       ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
> -       if (ret)
> -               return ret;
> +       *pgoff = (get_start_sect(bdev) + dev_sector) >> PAGE_SECTORS_SHIFT;
> +       return sc->stripe[stripe].dev->dax_dev;
> +}
> +
> +static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
> +               long nr_pages, void **kaddr, pfn_t *pfn)
> +{
> +       struct dax_device *dax_dev = stripe_dax_pgoff(ti, &pgoff);
> +
>         return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
>  }
>
>  static size_t stripe_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
>                 void *addr, size_t bytes, struct iov_iter *i)
>  {
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> -       struct stripe_c *sc = ti->private;
> -       struct dax_device *dax_dev;
> -       struct block_device *bdev;
> -       uint32_t stripe;
> -
> -       stripe_map_sector(sc, sector, &stripe, &dev_sector);
> -       dev_sector += sc->stripe[stripe].physical_start;
> -       dax_dev = sc->stripe[stripe].dev->dax_dev;
> -       bdev = sc->stripe[stripe].dev->bdev;
> +       struct dax_device *dax_dev = stripe_dax_pgoff(ti, &pgoff);
>
> -       if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
> -               return 0;
>         return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
>  }
>
>  static size_t stripe_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
>                 void *addr, size_t bytes, struct iov_iter *i)
>  {
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> -       struct stripe_c *sc = ti->private;
> -       struct dax_device *dax_dev;
> -       struct block_device *bdev;
> -       uint32_t stripe;
> -
> -       stripe_map_sector(sc, sector, &stripe, &dev_sector);
> -       dev_sector += sc->stripe[stripe].physical_start;
> -       dax_dev = sc->stripe[stripe].dev->dax_dev;
> -       bdev = sc->stripe[stripe].dev->bdev;
> +       struct dax_device *dax_dev = stripe_dax_pgoff(ti, &pgoff);
>
> -       if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
> -               return 0;
>         return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
>  }
>
>  static int stripe_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
>                                       size_t nr_pages)
>  {
> -       int ret;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> -       struct stripe_c *sc = ti->private;
> -       struct dax_device *dax_dev;
> -       struct block_device *bdev;
> -       uint32_t stripe;
> +       struct dax_device *dax_dev = stripe_dax_pgoff(ti, &pgoff);
>
> -       stripe_map_sector(sc, sector, &stripe, &dev_sector);
> -       dev_sector += sc->stripe[stripe].physical_start;
> -       dax_dev = sc->stripe[stripe].dev->dax_dev;
> -       bdev = sc->stripe[stripe].dev->bdev;
> -
> -       ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages << PAGE_SHIFT, &pgoff);
> -       if (ret)
> -               return ret;
>         return dax_zero_page_range(dax_dev, pgoff, nr_pages);
>  }
>
> --
> 2.30.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

