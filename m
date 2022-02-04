Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A30FC433EF
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 06:21:47 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-7TtpcILtP8m5Ouw2IuhEoQ-1; Fri, 04 Feb 2022 01:21:45 -0500
X-MC-Unique: 7TtpcILtP8m5Ouw2IuhEoQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A9D614751;
	Fri,  4 Feb 2022 06:21:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A41C46C1B6;
	Fri,  4 Feb 2022 06:21:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB8E84BB7C;
	Fri,  4 Feb 2022 06:21:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 2146LZrt028384 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 4 Feb 2022 01:21:36 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A04052024CBA; Fri,  4 Feb 2022 06:21:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9ACC1202717B
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 06:21:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8747C296A610
	for <dm-devel@redhat.com>; Fri,  4 Feb 2022 06:21:32 +0000 (UTC)
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com
	[209.85.214.176]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-79-t3c1W3amN_-tx4CSvOZNcw-1; Fri, 04 Feb 2022 01:21:30 -0500
X-MC-Unique: t3c1W3amN_-tx4CSvOZNcw-1
Received: by mail-pl1-f176.google.com with SMTP id l13so4288718plg.9
	for <dm-devel@redhat.com>; Thu, 03 Feb 2022 22:21:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=4pCg5LRiqmbI3TAMDbxbNyx17A118iw1ZgmwbQZNhZc=;
	b=F9eqdC1agsDzJA54lKIatkm7m5Ch/qfuiMgyo5SRTULZKlPb+1GANfu+lEaS9ecakX
	aiB47RH/o4Da5fFKIBNIQrvIJeN6R4s6rq9DhE3g0ul5bfUKOm8J2GWv66XKEX/ROoZC
	rpJIptfhObLclM2CLzL6n0CJxArVNbKxoTrEwh4yjaITIaFdpvXA9+Tab4CmNm80YYjl
	UHvj2g+TGfDCqjGD3osx3xyXHeEYQd6phI5uGLGSJhwC20p1X+mC0iQjbqKxT4sP315G
	iKDMl+ujru8MyQPTwGmFIo3hnsLyvWGY3+/hbZFTJL5KWcBlVTnu6OFV7rP0baKD1nml
	YBLw==
X-Gm-Message-State: AOAM531MC6cu1NjmU8/Xwx5nrKArxks1KReUtKpPDLbhfsgeeCSL/7Dc
	dUc1lvHkqY/5XgPrPusFNKuya/ulP54xxJgz/pdQHA==
X-Google-Smtp-Source: ABdhPJxJdrprINds/3WPI72ybQtRLDGdXlGnE/VTYi5U2aLnedO5jvJlRA9psGdrpnDvDKM0rxpfae7Zs/uG9uBsBds=
X-Received: by 2002:a17:902:bcca:: with SMTP id
	o10mr1673853pls.147.1643955689386; 
	Thu, 03 Feb 2022 22:21:29 -0800 (PST)
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com>
	<20220128213150.1333552-6-jane.chu@oracle.com>
In-Reply-To: <20220128213150.1333552-6-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Feb 2022 22:21:17 -0800
Message-ID: <CAPcyv4ip=JZXcQkDOtjcSsD=y7wRJEA0GdYSbx9+UrGCg8BNvQ@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
	Mike Snitzer <snitzer@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>,
	david <david@fromorbit.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	device-mapper development <dm-devel@redhat.com>,
	Vivek Goyal <vgoyal@redhat.com>, Vishal L Verma <vishal.l.verma@intel.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
	Ira" <ira.weiny@intel.com>, linux-xfs <linux-xfs@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH v5 5/7] pmem: add pmem_recovery_write() dax op
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

On Fri, Jan 28, 2022 at 1:32 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> pmem_recovery_write() consists of clearing poison via DSM,
> clearing page HWPoison bit, re-state _PAGE_PRESENT bit,
> cacheflush, write, and finally clearing bad-block record.
>
> A competing pread thread is held off during recovery write
> by the presence of bad-block record. A competing recovery_write
> thread is serialized by a lock.
>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  drivers/nvdimm/pmem.c | 82 +++++++++++++++++++++++++++++++++++++++----
>  drivers/nvdimm/pmem.h |  1 +
>  2 files changed, 77 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 638e64681db9..f2d6b34d48de 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -69,6 +69,14 @@ static void hwpoison_clear(struct pmem_device *pmem,
>         }
>  }
>
> +static void pmem_clear_badblocks(struct pmem_device *pmem, sector_t sector,
> +                               long cleared_blks)
> +{
> +       badblocks_clear(&pmem->bb, sector, cleared_blks);
> +       if (pmem->bb_state)
> +               sysfs_notify_dirent(pmem->bb_state);
> +}
> +
>  static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
>                 phys_addr_t offset, unsigned int len)
>  {
> @@ -88,9 +96,7 @@ static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
>                 dev_dbg(dev, "%#llx clear %ld sector%s\n",
>                                 (unsigned long long) sector, cleared,
>                                 cleared > 1 ? "s" : "");
> -               badblocks_clear(&pmem->bb, sector, cleared);
> -               if (pmem->bb_state)
> -                       sysfs_notify_dirent(pmem->bb_state);
> +               pmem_clear_badblocks(pmem, sector, cleared);
>         }
>
>         arch_invalidate_pmem(pmem->virt_addr + offset, len);
> @@ -257,10 +263,15 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
>  __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
>                 long nr_pages, void **kaddr, pfn_t *pfn)
>  {
> +       bool bad_pmem;
> +       bool do_recovery = false;
>         resource_size_t offset = PFN_PHYS(pgoff) + pmem->data_offset;
>
> -       if (unlikely(is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> -                                       PFN_PHYS(nr_pages))))
> +       bad_pmem = is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512,
> +                               PFN_PHYS(nr_pages));
> +       if (bad_pmem && kaddr)
> +               do_recovery = dax_recovery_started(pmem->dax_dev, kaddr);
> +       if (bad_pmem && !do_recovery)
>                 return -EIO;
>
>         if (kaddr)
> @@ -301,10 +312,68 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
>         return __pmem_direct_access(pmem, pgoff, nr_pages, kaddr, pfn);
>  }
>
> +/*
> + * The recovery write thread started out as a normal pwrite thread and
> + * when the filesystem was told about potential media error in the
> + * range, filesystem turns the normal pwrite to a dax_recovery_write.
> + *
> + * The recovery write consists of clearing poison via DSM, clearing page
> + * HWPoison bit, reenable page-wide read-write permission, flush the
> + * caches and finally write.  A competing pread thread needs to be held
> + * off during the recovery process since data read back might not be valid.
> + * And that's achieved by placing the badblock records clearing after
> + * the completion of the recovery write.
> + *
> + * Any competing recovery write thread needs to be serialized, and this is
> + * done via pmem device level lock .recovery_lock.
> + */
>  static size_t pmem_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
>                 void *addr, size_t bytes, struct iov_iter *i)
>  {
> -       return 0;
> +       size_t rc, len, off;
> +       phys_addr_t pmem_off;
> +       struct pmem_device *pmem = dax_get_private(dax_dev);
> +       struct device *dev = pmem->bb.dev;
> +       sector_t sector;
> +       long cleared, cleared_blk;
> +
> +       mutex_lock(&pmem->recovery_lock);
> +
> +       /* If no poison found in the range, go ahead with write */
> +       off = (unsigned long)addr & ~PAGE_MASK;
> +       len = PFN_PHYS(PFN_UP(off + bytes));
> +       if (!is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) / 512, len)) {
> +               rc = _copy_from_iter_flushcache(addr, bytes, i);
> +               goto write_done;
> +       }

is_bad_pmem() takes a seqlock so it should be safe to move the
recovery_lock below this point.

> +
> +       /* Not page-aligned range cannot be recovered */
> +       if (off || !(PAGE_ALIGNED(bytes))) {
> +               dev_warn(dev, "Found poison, but addr(%p) or bytes(%#lx) not page aligned\n",
> +                       addr, bytes);

fs/dax.c will prevent this from happening, right? It seems like an
upper layer bug if we get this far into the recovery process without
checking if a full page is being overwritten.

> +               rc = (size_t) -EIO;
> +               goto write_done;
> +       }
> +
> +       pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> +       sector = (pmem_off - pmem->data_offset) / 512;
> +       cleared = nvdimm_clear_poison(dev, pmem->phys_addr + pmem_off, len);
> +       cleared_blk = cleared / 512;
> +       if (cleared_blk > 0) {
> +               hwpoison_clear(pmem, pmem->phys_addr + pmem_off, cleared);
> +       } else {
> +               dev_warn(dev, "pmem_recovery_write: cleared_blk: %ld\n",
> +                       cleared_blk);
> +               rc = (size_t) -EIO;
> +               goto write_done;
> +       }
> +       arch_invalidate_pmem(pmem->virt_addr + pmem_off, bytes);
> +       rc = _copy_from_iter_flushcache(addr, bytes, i);
> +       pmem_clear_badblocks(pmem, sector, cleared_blk);

This duplicates pmem_clear_poison() can more code be shared between
the 2 functions?


> +
> +write_done:
> +       mutex_unlock(&pmem->recovery_lock);
> +       return rc;
>  }
>
>  static const struct dax_operations pmem_dax_ops = {
> @@ -495,6 +564,7 @@ static int pmem_attach_disk(struct device *dev,
>                 goto out_cleanup_dax;
>         dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
>         set_dax_recovery(dax_dev);
> +       mutex_init(&pmem->recovery_lock);
>         pmem->dax_dev = dax_dev;
>
>         rc = device_add_disk(dev, disk, pmem_attribute_groups);
> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
> index 59cfe13ea8a8..971bff7552d6 100644
> --- a/drivers/nvdimm/pmem.h
> +++ b/drivers/nvdimm/pmem.h
> @@ -24,6 +24,7 @@ struct pmem_device {
>         struct dax_device       *dax_dev;
>         struct gendisk          *disk;
>         struct dev_pagemap      pgmap;
> +       struct mutex            recovery_lock;
>  };
>
>  long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
> --
> 2.18.4
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

