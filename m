Return-Path: <SRS0=rauK=PQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BBD0C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 01:37:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A54C660D07
	for <dm-devel@archiver.kernel.org>; Thu, 28 Oct 2021 01:37:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A54C660D07
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-27DmAKwjOWGs7Ov3MLVu2g-1; Wed, 27 Oct 2021 21:37:00 -0400
X-MC-Unique: 27DmAKwjOWGs7Ov3MLVu2g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87EE2362F9;
	Thu, 28 Oct 2021 01:36:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6168169FA0;
	Thu, 28 Oct 2021 01:36:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1BEFE1800B9E;
	Thu, 28 Oct 2021 01:36:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19S1XKQS028443 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 27 Oct 2021 21:33:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 11EEE2144B22; Thu, 28 Oct 2021 01:33:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C46E2144B20
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 01:33:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 28764811E7F
	for <dm-devel@redhat.com>; Thu, 28 Oct 2021 01:33:15 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
	[209.85.216.46]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-6-P6mT_bjAN5CoNuA3YsgBEw-1; Wed, 27 Oct 2021 21:33:11 -0400
X-MC-Unique: P6mT_bjAN5CoNuA3YsgBEw-1
Received: by mail-pj1-f46.google.com with SMTP id
	lx5-20020a17090b4b0500b001a262880e99so3419476pjb.5
	for <dm-devel@redhat.com>; Wed, 27 Oct 2021 18:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=pAiaBNCk1xnEBH3C9EMpKzrgqAPJnlmXDrtIiJ0dt1I=;
	b=G/cgUWsMtQ3AILOL4Dfq2pgjeUmtxEiaMsHZGK2QhAQsY3b4UY/GGDbctunoDiZs2j
	Is51yuu2a4YccHygaSCGalMDSrzCdvK/ALUZoG/gd2dHOEbvppl5Oac6JM8wUKxtStsp
	4JkFREOtSBx6+6XL6/iYtT0X3ugr+TbP7cXr/wvQCjdKWv0ov2ms/5YEbtNXV4Xm48EH
	IQnvsaM5OwOA17lzqBL6Yl/XSAr/WZd+6PEwLyJW2ACEsM1QyOXz+B+aqfmsn7gxXkgJ
	hzKNz0wqXjBDthZbGv5bmuhAfKmHVw7SFwuCUkfLUd2UOWGrxLgJWtVGEgRAEVeToGUE
	XXgw==
X-Gm-Message-State: AOAM531RlEslmsVxFnOLuun0HrlPOjI8FD9QitwYMmjdR57AHt10f9XS
	mE6nz5ZgyWU6/0hlv4x6qAU/1ynaD2nqpSHF7X8ceQ==
X-Google-Smtp-Source: ABdhPJxm6eCpHzum4moJkAnlQxDuj0JlmT3Vix8IBxxMECN3GUzGEt1VHXlaU6FsHMYZFBw/KnWLJLzVXyU36Brr9pk=
X-Received: by 2002:a17:90b:3b88:: with SMTP id
	pc8mr1221700pjb.93.1635384790364; 
	Wed, 27 Oct 2021 18:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20211018044054.1779424-1-hch@lst.de>
	<20211018044054.1779424-9-hch@lst.de>
In-Reply-To: <20211018044054.1779424-9-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 27 Oct 2021 18:32:58 -0700
Message-ID: <CAPcyv4iK-Op9Nxoq91YLv0aRj6PkGF64UY0Z_kfovF0cpuJ_JQ@mail.gmail.com>
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
Subject: Re: [dm-devel] [PATCH 08/11] dm-linear: add a linear_dax_pgoff
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Looks good.

Mike, ack?

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-linear.c | 49 +++++++++++++-----------------------------
>  1 file changed, 15 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 32fbab11bf90c..bf03f73fd0f36 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -164,63 +164,44 @@ static int linear_iterate_devices(struct dm_target *ti,
>  }
>
>  #if IS_ENABLED(CONFIG_FS_DAX)
> +static struct dax_device *linear_dax_pgoff(struct dm_target *ti, pgoff_t *pgoff)
> +{
> +       struct linear_c *lc = ti->private;
> +       sector_t sector = linear_map_sector(ti, *pgoff << PAGE_SECTORS_SHIFT);
> +
> +       *pgoff = (get_start_sect(lc->dev->bdev) + sector) >> PAGE_SECTORS_SHIFT;
> +       return lc->dev->dax_dev;
> +}
> +
>  static long linear_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
>                 long nr_pages, void **kaddr, pfn_t *pfn)
>  {
> -       long ret;
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> -
> -       dev_sector = linear_map_sector(ti, sector);
> -       ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
> -       if (ret)
> -               return ret;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
> +
>         return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
>  }
>
>  static size_t linear_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
>                 void *addr, size_t bytes, struct iov_iter *i)
>  {
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
>
> -       dev_sector = linear_map_sector(ti, sector);
> -       if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
> -               return 0;
>         return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
>  }
>
>  static size_t linear_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
>                 void *addr, size_t bytes, struct iov_iter *i)
>  {
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
>
> -       dev_sector = linear_map_sector(ti, sector);
> -       if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
> -               return 0;
>         return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
>  }
>
>  static int linear_dax_zero_page_range(struct dm_target *ti, pgoff_t pgoff,
>                                       size_t nr_pages)
>  {
> -       int ret;
> -       struct linear_c *lc = ti->private;
> -       struct block_device *bdev = lc->dev->bdev;
> -       struct dax_device *dax_dev = lc->dev->dax_dev;
> -       sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
> -
> -       dev_sector = linear_map_sector(ti, sector);
> -       ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages << PAGE_SHIFT, &pgoff);
> -       if (ret)
> -               return ret;
> +       struct dax_device *dax_dev = linear_dax_pgoff(ti, &pgoff);
> +
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

