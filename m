Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECECCC433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 19:46:53 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-ZJWZmpDlPyuHtY4A_I0Y-A-1; Tue, 23 Nov 2021 14:46:51 -0500
X-MC-Unique: ZJWZmpDlPyuHtY4A_I0Y-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BEEB98799ED;
	Tue, 23 Nov 2021 19:46:46 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 641EA60862;
	Tue, 23 Nov 2021 19:46:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 101BC4E58F;
	Tue, 23 Nov 2021 19:46:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANJjFYv005091 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 14:45:15 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6DD0951E5; Tue, 23 Nov 2021 19:45:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67BB151E4
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 19:45:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EEEC802802
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 19:45:12 +0000 (UTC)
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com
	[209.85.210.180]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-355-3P4e0dHfPm6KxwQCDQPtrQ-1; Tue, 23 Nov 2021 14:45:10 -0500
X-MC-Unique: 3P4e0dHfPm6KxwQCDQPtrQ-1
Received: by mail-pf1-f180.google.com with SMTP id n85so290181pfd.10
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 11:45:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=w+rFmLhgbnDpLxCzHmV2glN1Ln3seAnXjsHProy9jpQ=;
	b=RDyK1LRpOVoZrgQSVUAQeOfN/atR9OxHeutAQyG+PF7EWMTl6G/cwObXXB67qdzjEy
	zBSNxk8po8q1qPW/WEhT54qsCKnZ8d/1CYnvVmbMuHuaGb+5N95IB7lyB81n2gIKKOpV
	0+t6d7LYmUtisM+dZTBpFqNsDrGUfsAR1XiG+FIfo0TS/rRlqtW2DZ6+W5sl9Xc6siZJ
	06fQdxf7JcE2B5sn5ifGOusc5D2ygOcqzGw6Od20vDvjmxnmZyi3wqIYrXN0v+2fu5cz
	zSJTZM90TmK8TP7y0zSu2oBUK2ZokoMNvu2P5XfjYMO0uzMRze3VakRxOqSvCGxcFs4I
	DPLA==
X-Gm-Message-State: AOAM531uz2u/CFz8hv3xrnBST4hhjC+uwqVVckw3l6w61vL4jYlBfZ9n
	alFZgH8QPWslvAgKlumjiWtA6c7RDB8EIJcrloKyYo9Uau0=
X-Google-Smtp-Source: ABdhPJyXaOgPCWXg03K7i5Yu4pkRtA/C9CDsmT0Wx6XfkWLs2OyDjuogWwUi8QvAPldXDBn8n1H52ogjjyzkBt9HYEc=
X-Received: by 2002:aa7:8d0a:0:b0:4a2:82d7:1695 with SMTP id
	j10-20020aa78d0a000000b004a282d71695mr8142364pfe.86.1637696709602;
	Tue, 23 Nov 2021 11:45:09 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-15-hch@lst.de>
In-Reply-To: <20211109083309.584081-15-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 11:44:59 -0800
Message-ID: <CAPcyv4gVjR05Go=WpK9k-FYO53o+X9PZz2nFL9gniz85nCXu4w@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 14/29] fsdax: simplify the pgoff calculation
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

On Tue, Nov 9, 2021 at 12:33 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Replace the two steps of dax_iomap_sector and bdev_dax_pgoff with a
> single dax_iomap_pgoff helper that avoids lots of cumbersome sector
> conversions.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c | 14 --------------
>  fs/dax.c            | 35 ++++++++++-------------------------
>  include/linux/dax.h |  1 -
>  3 files changed, 10 insertions(+), 40 deletions(-)
>
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 803942586d1b6..c0910687fbcb2 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -67,20 +67,6 @@ void dax_remove_host(struct gendisk *disk)
>  }
>  EXPORT_SYMBOL_GPL(dax_remove_host);
>
> -int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
> -               pgoff_t *pgoff)
> -{
> -       sector_t start_sect = bdev ? get_start_sect(bdev) : 0;
> -       phys_addr_t phys_off = (start_sect + sector) * 512;
> -
> -       if (pgoff)
> -               *pgoff = PHYS_PFN(phys_off);
> -       if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
> -               return -EINVAL;
> -       return 0;
> -}
> -EXPORT_SYMBOL(bdev_dax_pgoff);
> -
>  /**
>   * dax_get_by_host() - temporary lookup mechanism for filesystem-dax
>   * @bdev: block device to find a dax_device for
> diff --git a/fs/dax.c b/fs/dax.c
> index e51b4129d1b65..5364549d67a48 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -709,23 +709,22 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>         return __dax_invalidate_entry(mapping, index, false);
>  }
>
> -static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
> +static pgoff_t dax_iomap_pgoff(const struct iomap *iomap, loff_t pos)
>  {
> -       return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
> +       phys_addr_t paddr = iomap->addr + (pos & PAGE_MASK) - iomap->offset;
> +
> +       if (iomap->bdev)
> +               paddr += (get_start_sect(iomap->bdev) << SECTOR_SHIFT);
> +       return PHYS_PFN(paddr);
>  }
>
>  static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter)
>  {
> -       sector_t sector = dax_iomap_sector(&iter->iomap, iter->pos);
> +       pgoff_t pgoff = dax_iomap_pgoff(&iter->iomap, iter->pos);
>         void *vto, *kaddr;
> -       pgoff_t pgoff;
>         long rc;
>         int id;
>
> -       rc = bdev_dax_pgoff(iter->iomap.bdev, sector, PAGE_SIZE, &pgoff);
> -       if (rc)
> -               return rc;
> -
>         id = dax_read_lock();
>         rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
>         if (rc < 0) {
> @@ -1013,14 +1012,10 @@ EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
>  static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
>                          pfn_t *pfnp)
>  {
> -       const sector_t sector = dax_iomap_sector(iomap, pos);
> -       pgoff_t pgoff;
> +       pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
>         int id, rc;
>         long length;
>
> -       rc = bdev_dax_pgoff(iomap->bdev, sector, size, &pgoff);
> -       if (rc)
> -               return rc;
>         id = dax_read_lock();
>         length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
>                                    NULL, pfnp);
> @@ -1129,7 +1124,7 @@ static vm_fault_t dax_pmd_load_hole(struct xa_state *xas, struct vm_fault *vmf,
>  s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>  {
>         sector_t sector = iomap_sector(iomap, pos & PAGE_MASK);
> -       pgoff_t pgoff;
> +       pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
>         long rc, id;
>         void *kaddr;
>         bool page_aligned = false;
> @@ -1140,10 +1135,6 @@ s64 dax_iomap_zero(loff_t pos, u64 length, struct iomap *iomap)
>             (size == PAGE_SIZE))
>                 page_aligned = true;
>
> -       rc = bdev_dax_pgoff(iomap->bdev, sector, PAGE_SIZE, &pgoff);
> -       if (rc)
> -               return rc;
> -
>         id = dax_read_lock();
>
>         if (page_aligned)
> @@ -1169,7 +1160,6 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>         const struct iomap *iomap = &iomi->iomap;
>         loff_t length = iomap_length(iomi);
>         loff_t pos = iomi->pos;
> -       struct block_device *bdev = iomap->bdev;
>         struct dax_device *dax_dev = iomap->dax_dev;
>         loff_t end = pos + length, done = 0;
>         ssize_t ret = 0;
> @@ -1203,9 +1193,8 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>         while (pos < end) {
>                 unsigned offset = pos & (PAGE_SIZE - 1);
>                 const size_t size = ALIGN(length + offset, PAGE_SIZE);
> -               const sector_t sector = dax_iomap_sector(iomap, pos);
> +               pgoff_t pgoff = dax_iomap_pgoff(iomap, pos);
>                 ssize_t map_len;
> -               pgoff_t pgoff;
>                 void *kaddr;
>
>                 if (fatal_signal_pending(current)) {
> @@ -1213,10 +1202,6 @@ static loff_t dax_iomap_iter(const struct iomap_iter *iomi,
>                         break;
>                 }
>
> -               ret = bdev_dax_pgoff(bdev, sector, size, &pgoff);
> -               if (ret)
> -                       break;
> -
>                 map_len = dax_direct_access(dax_dev, pgoff, PHYS_PFN(size),
>                                 &kaddr, NULL);
>                 if (map_len < 0) {
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 439c3c70e347b..324363b798ecd 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -107,7 +107,6 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
>  #endif
>
>  struct writeback_control;
> -int bdev_dax_pgoff(struct block_device *, sector_t, size_t, pgoff_t *pgoff);
>  #if IS_ENABLED(CONFIG_FS_DAX)
>  int dax_add_host(struct dax_device *dax_dev, struct gendisk *disk);
>  void dax_remove_host(struct gendisk *disk);
> --
> 2.30.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

