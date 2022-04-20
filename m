Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28E67C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 20 Apr 2022 06:26:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-CZ18WWhdMTyG5T5wYoaA9g-1; Wed, 20 Apr 2022 02:26:51 -0400
X-MC-Unique: CZ18WWhdMTyG5T5wYoaA9g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E46F38002BF;
	Wed, 20 Apr 2022 06:26:49 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3C024145B963;
	Wed, 20 Apr 2022 06:26:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 04B0C1947BBF;
	Wed, 20 Apr 2022 06:26:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1EFCB19451F2
 for <dm-devel@listman.corp.redhat.com>; Wed, 20 Apr 2022 06:26:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 01411145B96C; Wed, 20 Apr 2022 06:26:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F1A2C145B963
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 06:26:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D123238041CE
 for <dm-devel@redhat.com>; Wed, 20 Apr 2022 06:26:45 +0000 (UTC)
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com
 [209.85.214.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-QmBY3-gEMMyoV97rtEJvZQ-1; Wed, 20 Apr 2022 02:26:43 -0400
X-MC-Unique: QmBY3-gEMMyoV97rtEJvZQ-1
Received: by mail-pl1-f169.google.com with SMTP id j8so910031pll.11
 for <dm-devel@redhat.com>; Tue, 19 Apr 2022 23:26:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=i/B+07Pdy/i99xOuJm1AhASljd/y0M0ZEBVCIGcpJEk=;
 b=wdwiIUiSVEcHlbZNXTQjdlqceqJLsGFmY18hNQeGiuErwOEtCkogBdabQXL+55K6o/
 Emtz/lx+CAhm/Cqcay3vn+gYOwiOmsNAzgTqqnq6vaRcqu1Ef1S0d1xkogfMs2UVthAU
 tr8zkQIqvGpegDdKwztHQvoAZBiYaaAlVBMLfwU1hwErxTL5f1w+hakS1D783woDzd1H
 lvN7UIefGkRtR/Qn5t41JNXWoMF/UIl9ha3EDw8RX2PO0//TzuCTWDiHb1kUXGDdzxJW
 WugNekFIOybnf0j/EPCf0oQI81wx9Mf3SZaD4tFnLH+rdHrguxI8T0j8L7oCoBOVZel9
 9yVA==
X-Gm-Message-State: AOAM530G8sGKaZxxh7uOuj2+nQzR5VnbD2szWMqyrP0odz+DZSsHKnag
 wHGXSbSvhAfVWfvqOAznPjQ6QAPOgzaXX6epzMBgLA==
X-Google-Smtp-Source: ABdhPJxixqBz/WgugT7SEaDoh37n3VChx++gr3ojEoEsdleLCNUq06QhC6jeLOdiLDQ4Vb1/+A5HVkXtu9FHqLKx4aA=
X-Received: by 2002:a17:90b:4c84:b0:1d2:cadc:4e4d with SMTP id
 my4-20020a17090b4c8400b001d2cadc4e4dmr2676295pjb.8.1650436002497; Tue, 19 Apr
 2022 23:26:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220420020435.90326-1-jane.chu@oracle.com>
 <20220420020435.90326-8-jane.chu@oracle.com>
In-Reply-To: <20220420020435.90326-8-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Apr 2022 23:26:31 -0700
Message-ID: <CAPcyv4gs2rEs71c6Lmtk1La2g3POhzBrppLvM0pkGxx+QZ3SbA@mail.gmail.com>
To: Jane Chu <jane.chu@oracle.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH v8 7/7] pmem: implement pmem_recovery_write()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Dave Jiang <dave.jiang@intel.com>,
 Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 "Darrick J. Wong" <djwong@kernel.org>, X86 ML <x86@kernel.org>,
 david <david@fromorbit.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
 Dave Hansen <dave.hansen@intel.com>,
 device-mapper development <dm-devel@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Vivek Goyal <vgoyal@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Vishal L Verma <vishal.l.verma@intel.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Weiny,
 Ira" <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Apr 19, 2022 at 7:06 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> The recovery write thread started out as a normal pwrite thread and
> when the filesystem was told about potential media error in the
> range, filesystem turns the normal pwrite to a dax_recovery_write.
>
> The recovery write consists of clearing media poison, clearing page
> HWPoison bit, reenable page-wide read-write permission, flush the
> caches and finally write.  A competing pread thread will be held
> off during the recovery process since data read back might not be
> valid, and this is achieved by clearing the badblock records after
> the recovery write is complete. Competing recovery write threads
> are serialized by pmem device level .recovery_lock.
>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  drivers/nvdimm/pmem.c | 56 ++++++++++++++++++++++++++++++++++++++++++-
>  drivers/nvdimm/pmem.h |  1 +
>  2 files changed, 56 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index c3772304d417..134f8909eb65 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -332,10 +332,63 @@ static long pmem_dax_direct_access(struct dax_device *dax_dev,
>         return __pmem_direct_access(pmem, pgoff, nr_pages, mode, kaddr, pfn);
>  }
>
> +/*
> + * The recovery write thread started out as a normal pwrite thread and
> + * when the filesystem was told about potential media error in the
> + * range, filesystem turns the normal pwrite to a dax_recovery_write.
> + *
> + * The recovery write consists of clearing media poison, clearing page
> + * HWPoison bit, reenable page-wide read-write permission, flush the
> + * caches and finally write.  A competing pread thread will be held
> + * off during the recovery process since data read back might not be
> + * valid, and this is achieved by clearing the badblock records after
> + * the recovery write is complete. Competing recovery write threads
> + * are serialized by pmem device level .recovery_lock.
> + */
>  static size_t pmem_recovery_write(struct dax_device *dax_dev, pgoff_t pgoff,
>                 void *addr, size_t bytes, struct iov_iter *i)
>  {
> -       return 0;
> +       struct pmem_device *pmem = dax_get_private(dax_dev);
> +       size_t olen, len, off;
> +       phys_addr_t pmem_off;
> +       struct device *dev = pmem->bb.dev;
> +       long cleared;
> +
> +       off = offset_in_page(addr);
> +       len = PFN_PHYS(PFN_UP(off + bytes));
> +       if (!is_bad_pmem(&pmem->bb, PFN_PHYS(pgoff) >> SECTOR_SHIFT, len))
> +               return _copy_from_iter_flushcache(addr, bytes, i);
> +
> +       /*
> +        * Not page-aligned range cannot be recovered. This should not
> +        * happen unless something else went wrong.
> +        */
> +       if (off || !PAGE_ALIGNED(bytes)) {
> +               dev_warn(dev, "Found poison, but addr(%p) or bytes(%#lx) not page aligned\n",
> +                       addr, bytes);

If this warn stays:

s/dev_warn/dev_warn_ratelimited/

The kernel prints hashed addresses for %p, so I'm not sure printing
@addr is useful or @bytes because there is nothing actionable that can
be done with that information in the log. @pgoff is probably the only
variable worth printing (after converting to bytes or sectors) as that
might be able to be reverse mapped back to the impacted data.

> +               return 0;
> +       }
> +
> +       mutex_lock(&pmem->recovery_lock);
> +       pmem_off = PFN_PHYS(pgoff) + pmem->data_offset;
> +       cleared = __pmem_clear_poison(pmem, pmem_off, len);
> +       if (cleared > 0 && cleared < len) {
> +               dev_warn(dev, "poison cleared only %ld out of %lu bytes\n",
> +                       cleared, len);

This looks like dev_dbg() to me, or at minimum the same
dev_warn_ratelimited() print as the one above to just indicate a write
to the device at the given offset failed.

> +               mutex_unlock(&pmem->recovery_lock);
> +               return 0;
> +       }
> +       if (cleared < 0) {
> +               dev_warn(dev, "poison clear failed: %ld\n", cleared);

Same feedback here, these should probably all map to the identical
error exit ratelimited print.

> +               mutex_unlock(&pmem->recovery_lock);

It occurs to me that all callers of this are arriving through the
fsdax iomap ops and all of these callers take an exclusive lock to
prevent simultaneous access to the inode. If recovery_write() is only
used through that path then this lock is redundant. Simultaneous reads
are protected by the fact that the badblocks are cleared last. I think
this can wait to add the lock when / if a non-fsdax access path
arrives for dax_recovery_write(), and even then it should probably
enforce the single writer exclusion guarantee of the fsdax path.

> +               return 0;
> +       }
> +
> +       olen = _copy_from_iter_flushcache(addr, bytes, i);
> +       pmem_clear_bb(pmem, to_sect(pmem, pmem_off), cleared >> SECTOR_SHIFT);
> +
> +       mutex_unlock(&pmem->recovery_lock);
> +       return olen;
>  }
>
>  static const struct dax_operations pmem_dax_ops = {
> @@ -525,6 +578,7 @@ static int pmem_attach_disk(struct device *dev,
>         if (rc)
>                 goto out_cleanup_dax;
>         dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
> +       mutex_init(&pmem->recovery_lock);
>         pmem->dax_dev = dax_dev;
>
>         rc = device_add_disk(dev, disk, pmem_attribute_groups);
> diff --git a/drivers/nvdimm/pmem.h b/drivers/nvdimm/pmem.h
> index 392b0b38acb9..91e40f5e3c0e 100644
> --- a/drivers/nvdimm/pmem.h
> +++ b/drivers/nvdimm/pmem.h
> @@ -27,6 +27,7 @@ struct pmem_device {
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

