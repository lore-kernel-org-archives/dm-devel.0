Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3497C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 19:36:07 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-119-s_56v5fTPvyXSB6r2D-e8A-1; Tue, 23 Nov 2021 14:36:05 -0500
X-MC-Unique: s_56v5fTPvyXSB6r2D-e8A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B795107B27B;
	Tue, 23 Nov 2021 19:36:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B869760843;
	Tue, 23 Nov 2021 19:35:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 76C734A704;
	Tue, 23 Nov 2021 19:35:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANJZvno004624 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 14:35:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5DB424047279; Tue, 23 Nov 2021 19:35:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 59C9B4047272
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 19:35:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41E40185A7BA
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 19:35:57 +0000 (UTC)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com
	[209.85.215.176]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-234-YOMMwnm4OFC9TaWJFebHvA-1; Tue, 23 Nov 2021 14:35:55 -0500
X-MC-Unique: YOMMwnm4OFC9TaWJFebHvA-1
Received: by mail-pg1-f176.google.com with SMTP id r5so38279pgi.6
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 11:35:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=5gWZdeoaC7jqVM8zeJ3InHmY5XgJ6AqsmAXMbMD6MVc=;
	b=hAIYVU4jDEodXVOs45QukEwRaWOhpwQxM9A1R+K76OT9wmrfHYXaECIGEpNmSdVx8k
	MG6UnH73YCYrfKtnbjtTWY3fYhUF5MYMFnATPvCw7+03Vq+UYjOVqWoH3CcfoB+cgP0r
	8jZNJn4NV0gHToGLAC2cnojo+Ffu8JiA3njQjRAPWRBv8RwvAMR/+7Ww8Oa8H/xsuxsC
	Z/uPf31Fq4+qYrWnXn+TNLAt+/jhA4zdWZoMsOSqEB+Q9gm/9VSeSxzXMobKowd3aYwH
	LWeXuQ2kbBt6wRhgHlj3n4DIUVIMKVA5OzpLzDorirwVnCz2JsHgxCk1dJJyv1QsFYe+
	amzA==
X-Gm-Message-State: AOAM531u5nx/lO3fKomqCXPQ0pCX4b2lJ0cOONz/ugbS+/g8siJ2BADR
	l1S32eMkn5uOeiZOIO+DGRNDkVWr0QNitE9U021qJw==
X-Google-Smtp-Source: ABdhPJyUgiLjRKYUsHsrV83l3gO1RrPxkMBAXyAi/veRroUOh2xEn4EazOAyxkpoKqaxXeG2LfQdh/0f6yLjguWrfLs=
X-Received: by 2002:a63:5401:: with SMTP id i1mr5642151pgb.356.1637696154262; 
	Tue, 23 Nov 2021 11:35:54 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-14-hch@lst.de>
In-Reply-To: <20211109083309.584081-14-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 11:35:43 -0800
Message-ID: <CAPcyv4i=PnXu6ixHtj4Bqi0gy=bJJijrWgTNEcQ6uEJiut4PfQ@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
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
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 13/29] fsdax: use a saner calling convention
	for copy_cow_page_dax
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
> Just pass the vm_fault and iomap_iter structures, and figure out the rest
> locally.  Note that this requires moving dax_iomap_sector up in the file.

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c | 29 +++++++++++++----------------
>  1 file changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 73bd1439d8089..e51b4129d1b65 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -709,26 +709,31 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>         return __dax_invalidate_entry(mapping, index, false);
>  }
>
> -static int copy_cow_page_dax(struct block_device *bdev, struct dax_device *dax_dev,
> -                            sector_t sector, struct page *to, unsigned long vaddr)
> +static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
>  {
> +       return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
> +}
> +
> +static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter)
> +{
> +       sector_t sector = dax_iomap_sector(&iter->iomap, iter->pos);
>         void *vto, *kaddr;
>         pgoff_t pgoff;
>         long rc;
>         int id;
>
> -       rc = bdev_dax_pgoff(bdev, sector, PAGE_SIZE, &pgoff);
> +       rc = bdev_dax_pgoff(iter->iomap.bdev, sector, PAGE_SIZE, &pgoff);
>         if (rc)
>                 return rc;
>
>         id = dax_read_lock();
> -       rc = dax_direct_access(dax_dev, pgoff, 1, &kaddr, NULL);
> +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
>         if (rc < 0) {
>                 dax_read_unlock(id);
>                 return rc;
>         }
> -       vto = kmap_atomic(to);
> -       copy_user_page(vto, kaddr, vaddr, to);
> +       vto = kmap_atomic(vmf->cow_page);
> +       copy_user_page(vto, kaddr, vmf->address, vmf->cow_page);
>         kunmap_atomic(vto);
>         dax_read_unlock(id);
>         return 0;
> @@ -1005,11 +1010,6 @@ int dax_writeback_mapping_range(struct address_space *mapping,
>  }
>  EXPORT_SYMBOL_GPL(dax_writeback_mapping_range);
>
> -static sector_t dax_iomap_sector(const struct iomap *iomap, loff_t pos)
> -{
> -       return (iomap->addr + (pos & PAGE_MASK) - iomap->offset) >> 9;
> -}
> -
>  static int dax_iomap_pfn(const struct iomap *iomap, loff_t pos, size_t size,
>                          pfn_t *pfnp)
>  {
> @@ -1332,19 +1332,16 @@ static vm_fault_t dax_fault_synchronous_pfnp(pfn_t *pfnp, pfn_t pfn)
>  static vm_fault_t dax_fault_cow_page(struct vm_fault *vmf,
>                 const struct iomap_iter *iter)
>  {
> -       sector_t sector = dax_iomap_sector(&iter->iomap, iter->pos);
> -       unsigned long vaddr = vmf->address;
>         vm_fault_t ret;
>         int error = 0;
>
>         switch (iter->iomap.type) {
>         case IOMAP_HOLE:
>         case IOMAP_UNWRITTEN:
> -               clear_user_highpage(vmf->cow_page, vaddr);
> +               clear_user_highpage(vmf->cow_page, vmf->address);
>                 break;
>         case IOMAP_MAPPED:
> -               error = copy_cow_page_dax(iter->iomap.bdev, iter->iomap.dax_dev,
> -                                         sector, vmf->cow_page, vaddr);
> +               error = copy_cow_page_dax(vmf, iter);
>                 break;
>         default:
>                 WARN_ON_ONCE(1);
> --
> 2.30.2
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

