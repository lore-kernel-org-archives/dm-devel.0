Return-Path: <SRS0=WDPk=PP=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1552C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 20:53:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 75C1A6109F
	for <dm-devel@archiver.kernel.org>; Wed, 27 Oct 2021 20:53:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 75C1A6109F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-311-DYu3vOpsPYmnBFjYTg1Vyw-1; Wed, 27 Oct 2021 16:53:42 -0400
X-MC-Unique: DYu3vOpsPYmnBFjYTg1Vyw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63F31A40C3;
	Wed, 27 Oct 2021 20:53:38 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D0FA160BF1;
	Wed, 27 Oct 2021 20:53:37 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 32BD61800FDD;
	Wed, 27 Oct 2021 20:53:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19RKrZGF004214 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Oct 2021 16:53:36 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D91F640D1B9D; Wed, 27 Oct 2021 20:53:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D532340C1242
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 20:53:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC9E5805AB5
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 20:53:35 +0000 (UTC)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
	[209.85.214.175]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-440-cJBGvazVMGmwlm1a7glt2A-1; Wed, 27 Oct 2021 16:53:34 -0400
X-MC-Unique: cJBGvazVMGmwlm1a7glt2A-1
Received: by mail-pl1-f175.google.com with SMTP id z11so2873700plg.8
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 13:53:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=JF27tid0jnJ4Lv4ojsqdS1ywAxF2Yh/rXBicw2Nx/Bg=;
	b=jftEVXYztm5F6o0WhOzMUN2rkzsJLG7kUsIPPO5dUvdu1oSZhtQhFPSUKGGMP/JDDp
	yhGalE9hhfWQN2WyrFIyk74OOejktkBRR+lixBp2VYsCx7Dz8HzxxoS0E71CGgL8hYj9
	SbjStiQtAJjNb6n3fc6F0mwHlGR40cP9UR2E4yNsQD0SRDUsimLeiyrvDSmC65y4BpfC
	XyAY4n7IB7D1K61JOcnwDB3Uc23ioemfNPX6ivCGiPsdU883SGp9IuB/I+97cv/RA1WS
	wFYrFzdUGhoONKa53nfQhC4kCRRi3VFs6qPcnSdK/0BjkGpCAhR7hBtBvUGYdiNVmVl+
	V8CA==
X-Gm-Message-State: AOAM53075dBozw9iUKDipHZytiRfqCvGrm//WvH7yawBmSSNROIOiIdF
	f7xHgRVfK/p5VQaDkPD+AnDZPh6DtVDOQrxRnv/7/w==
X-Google-Smtp-Source: ABdhPJzghlFw+zkjpuNy8dyEqDgjwZ/Nb0+yCd5621faImzBOeUtIgX/3CShbYonbAi1vtWBePJ7pkat1hh6sB8QXRU=
X-Received: by 2002:a17:90b:3b88:: with SMTP id pc8mr3618pjb.93.1635368012904; 
	Wed, 27 Oct 2021 13:53:32 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de>
	<20211018044054.1779424-2-hch@lst.de>
In-Reply-To: <20211018044054.1779424-2-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Oct 2021 13:53:21 -0700
Message-ID: <CAPcyv4hrEPizMOH-XhCqh=23EJDG=W6VwvQ1pVstfe-Jm-AsiQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 01/11] dm: make the DAX support dependend on
	CONFIG_FS_DAX
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
>
> The device mapper DAX support is all hanging off a block device and thus
> can't be used with device dax.  Make it depend on CONFIG_FS_DAX instead
> of CONFIG_DAX_DRIVER.  This also means that bdev_dax_pgoff only needs to
> be built under CONFIG_FS_DAX now.

Looks good.

Mike, can I get an ack to take this through nvdimm.git? (you'll likely
see me repeat this question on subsequent patches in this series).

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c        | 6 ++----
>  drivers/md/dm-linear.c     | 2 +-
>  drivers/md/dm-log-writes.c | 2 +-
>  drivers/md/dm-stripe.c     | 2 +-
>  drivers/md/dm-writecache.c | 2 +-
>  drivers/md/dm.c            | 2 +-
>  6 files changed, 7 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index b882cf8106ea3..e20d0cef10a18 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -63,7 +63,7 @@ static int dax_host_hash(const char *host)
>         return hashlen_hash(hashlen_string("DAX", host)) % DAX_HASH_SIZE;
>  }
>
> -#ifdef CONFIG_BLOCK
> +#if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
>  #include <linux/blkdev.h>
>
>  int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
> @@ -80,7 +80,6 @@ int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
>  }
>  EXPORT_SYMBOL(bdev_dax_pgoff);
>
> -#if IS_ENABLED(CONFIG_FS_DAX)
>  /**
>   * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
>   * @host: alternate name for the device registered by a dax driver
> @@ -219,8 +218,7 @@ bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
>         return ret;
>  }
>  EXPORT_SYMBOL_GPL(dax_supported);
> -#endif /* CONFIG_FS_DAX */
> -#endif /* CONFIG_BLOCK */
> +#endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
>
>  enum dax_device_flags {
>         /* !alive + rcu grace period == no new operations / mappings */
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 679b4c0a2eea1..32fbab11bf90c 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -163,7 +163,7 @@ static int linear_iterate_devices(struct dm_target *ti,
>         return fn(ti, lc->dev, lc->start, ti->len, data);
>  }
>
> -#if IS_ENABLED(CONFIG_DAX_DRIVER)
> +#if IS_ENABLED(CONFIG_FS_DAX)
>  static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>                 long nr_pages, void **kaddr, pfn_t *pfn)
>  {
> diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
> index d93a4db235124..6d694526881d0 100644
> --- a/drivers/md/dm-log-writes.c
> +++ b/drivers/md/dm-log-writes.c
> @@ -903,7 +903,7 @@ static void log_writes_io_hints(struct dm_target *ti, struct queue_limits *limit
>         limits->io_min = limits->physical_block_size;
>  }
>
> -#if IS_ENABLED(CONFIG_DAX_DRIVER)
> +#if IS_ENABLED(CONFIG_FS_DAX)
>  static int log_dax(struct log_writes_c *lc, sector_t sector, size_t bytes,
>                    struct iov_iter *i)
>  {
> diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
> index 6660b6b53d5bf..f084607220293 100644
> --- a/drivers/md/dm-stripe.c
> +++ b/drivers/md/dm-stripe.c
> @@ -300,7 +300,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
>         return DM_MAPIO_REMAPPED;
>  }
>
> -#if IS_ENABLED(CONFIG_DAX_DRIVER)
> +#if IS_ENABLED(CONFIG_FS_DAX)
>  static long stripe_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>                 long nr_pages, void **kaddr, pfn_t *pfn)
>  {
> diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
> index 18320444fb0a9..4c3a6e33604d3 100644
> --- a/drivers/md/dm-writecache.c
> +++ b/drivers/md/dm-writecache.c
> @@ -38,7 +38,7 @@
>  #define BITMAP_GRANULARITY     PAGE_SIZE
>  #endif
>
> -#if IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API) && IS_ENABLED(CONFIG_DAX_DRIVER)
> +#if IS_ENABLED(CONFIG_ARCH_HAS_PMEM_API) && IS_ENABLED(CONFIG_FS_DAX)
>  #define DM_WRITECACHE_HAS_PMEM
>  #endif
>
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 7870e6460633f..79737aee516b1 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1783,7 +1783,7 @@ static struct mapped_device *alloc_dev(int minor)
>         md->disk->private_data = md;
>         sprintf(md->disk->disk_name, "dm-%d", minor);
>
> -       if (IS_ENABLED(CONFIG_DAX_DRIVER)) {
> +       if (IS_ENABLED(CONFIG_FS_DAX)) {
>                 md->dax_dev = alloc_dax(md, md->disk->disk_name,
>                                         &dm_dax_ops, 0);
>                 if (IS_ERR(md->dax_dev))
> --
> 2.30.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

