Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFC81C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 24 Nov 2021 03:22:22 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-kAHCshTLO62ooV8VR67bKg-1; Tue, 23 Nov 2021 22:22:18 -0500
X-MC-Unique: kAHCshTLO62ooV8VR67bKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1DA491808322;
	Wed, 24 Nov 2021 03:22:13 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 97383418E;
	Wed, 24 Nov 2021 03:22:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4E08C4BB7C;
	Wed, 24 Nov 2021 03:22:08 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AO3M5En019691 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 22:22:05 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 87CE01121319; Wed, 24 Nov 2021 03:22:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 832D11121318
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 03:22:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CE937100E658
	for <dm-devel@redhat.com>; Wed, 24 Nov 2021 03:22:01 +0000 (UTC)
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com
	[209.85.216.41]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-306-tuonM_B7NYOuihHlK2kGQQ-1; Tue, 23 Nov 2021 22:22:00 -0500
X-MC-Unique: tuonM_B7NYOuihHlK2kGQQ-1
Received: by mail-pj1-f41.google.com with SMTP id
	j6-20020a17090a588600b001a78a5ce46aso3880675pji.0
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 19:21:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=EL31Cy62VKrYRYptuLHbJfb/IYu8BUfyrtV7sdQIaLc=;
	b=W6/+Z+thrseWiIKppoWo2GmKy+Di/OojYo5EWLxFaXj6d/cCeCCfsPhlHp3MmZcgYr
	/b8p4Zy6i9Sm5KFoSznVT1vToaX52JUG0NPFNRxy6ddyNt6YWMggla995ie7Ni9nKDeO
	9DJKqUhw3R2L1B8+oTo0oKsD8jq1jc8/HtPM/WXrnOsYqRtrd2o5r73mD7av+/vuGlbT
	wrvySn73rv4plKquD/U6SdyqrV82Zg4OSWO+FrOhRARKr1nwDoejkmfVjUMg+TBX8jeK
	UyKEGvU0bo2LxMYvVZjKYfZFZKaMLMl/kCYzKI9DyfdqYRlshtXK/ThYKZK+3lXqRcrW
	pu0A==
X-Gm-Message-State: AOAM531VxKxd/NBRrk096cJ6uf+GQhSxCn6268kb3P7Zc4EXcMKJZ1Gs
	Tav8BgOaUbKTKBL8jYzUnT3V31uGM8ki1+9QS1IeNAP3v+umxg==
X-Google-Smtp-Source: ABdhPJy2aFen0PqWttd8BjEdIQsqphuBXqzJVHlhc+QCr5UJA27t1P+Fp9qpkknnP9tnEfW8e0xOGoy/eRGZQ5QtCf0=
X-Received: by 2002:a17:90b:1e49:: with SMTP id
	pi9mr3873250pjb.220.1637724118856; 
	Tue, 23 Nov 2021 19:21:58 -0800 (PST)
MIME-Version: 1.0
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-27-hch@lst.de>
In-Reply-To: <20211109083309.584081-27-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Nov 2021 19:21:47 -0800
Message-ID: <CAPcyv4hHQMngb634K87hJkEgQEhMkGKft30JCbFy2eEXA57oKA@mail.gmail.com>
To: Christoph Hellwig <hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>, Mike Snitzer <snitzer@redhat.com>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 26/29] fsdax: shift partition offset handling
 into the file systems
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

On Tue, Nov 9, 2021 at 12:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Remove the last user of ->bdev in dax.c by requiring the file system to
> pass in an address that already includes the DAX offset.  As part of the
> only set ->bdev or ->daxdev when actually required in the ->iomap_begin
> methods.

Changes look good except for what looks like an argument position
fixup needed for an xfs_bmbt_to_iomap() caller below...

>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/dax.c                 |  6 +-----
>  fs/erofs/data.c          | 11 ++++++++--
>  fs/erofs/internal.h      |  1 +
>  fs/ext2/inode.c          |  8 +++++--
>  fs/ext4/inode.c          | 16 +++++++++-----
>  fs/xfs/libxfs/xfs_bmap.c |  4 ++--
>  fs/xfs/xfs_aops.c        |  2 +-
>  fs/xfs/xfs_iomap.c       | 45 +++++++++++++++++++++++++---------------
>  fs/xfs/xfs_iomap.h       |  5 +++--
>  fs/xfs/xfs_pnfs.c        |  2 +-
>  10 files changed, 63 insertions(+), 37 deletions(-)
>
> diff --git a/fs/dax.c b/fs/dax.c
> index 0bd6cdcbacfc4..2c13c681edf09 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -711,11 +711,7 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
>
>  static pgoff_t dax_iomap_pgoff(const struct iomap *iomap, loff_t pos)
>  {
> -       phys_addr_t paddr = iomap->addr + (pos & PAGE_MASK) - iomap->offset;
> -
> -       if (iomap->bdev)
> -               paddr += (get_start_sect(iomap->bdev) << SECTOR_SHIFT);
> -       return PHYS_PFN(paddr);
> +       return PHYS_PFN(iomap->addr + (pos & PAGE_MASK) - iomap->offset);
>  }
>
>  static int copy_cow_page_dax(struct vm_fault *vmf, const struct iomap_iter *iter)
> diff --git a/fs/erofs/data.c b/fs/erofs/data.c
> index 0e35ef3f9f3d7..9b1bb177ce303 100644
> --- a/fs/erofs/data.c
> +++ b/fs/erofs/data.c
[..]
               }
> @@ -215,9 +218,13 @@ static int erofs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
>         if (ret)
>                 return ret;
>
> -       iomap->bdev = mdev.m_bdev;
> -       iomap->dax_dev = mdev.m_daxdev;
>         iomap->offset = map.m_la;
> +       if (flags & IOMAP_DAX) {
> +               iomap->dax_dev = mdev.m_daxdev;
> +               iomap->offset += mdev.m_dax_part_off;
> +       } else {
> +               iomap->bdev = mdev.m_bdev;
> +       }

Ah, that's what IOMAP_DAX is for, to stop making iomap carry bdev
details unnecessarily.

[..]
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 704292c6ce0c7..74dbf1fd99d39 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -54,7 +54,8 @@ xfs_bmbt_to_iomap(
>         struct xfs_inode        *ip,
>         struct iomap            *iomap,
>         struct xfs_bmbt_irec    *imap,
> -       u16                     flags)
> +       unsigned int            flags,
> +       u16                     iomap_flags)

It would be nice if the compiler could help with making sure that
right 'flags' values are passed to the right 'flags' parameter, but I
can't think of

[..]
> @@ -1053,23 +1061,24 @@ xfs_buffered_write_iomap_begin(
>          */
>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
>         trace_xfs_iomap_alloc(ip, offset, count, allocfork, &imap);
> -       return xfs_bmbt_to_iomap(ip, iomap, &imap, IOMAP_F_NEW);
> +       return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_NEW);
>
>  found_imap:
>         xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -       return xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
> +       return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);

The iomap flags are supposed to be the last argument, right?

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

