Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A91CC433F5
	for <dm-devel@archiver.kernel.org>; Sun, 12 Dec 2021 14:48:29 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-QEHxG6xvNDyC_6XcXqTtMg-1; Sun, 12 Dec 2021 09:48:25 -0500
X-MC-Unique: QEHxG6xvNDyC_6XcXqTtMg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58CA98042E2;
	Sun, 12 Dec 2021 14:48:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D79AA7A2EF;
	Sun, 12 Dec 2021 14:48:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AB03B4BB7C;
	Sun, 12 Dec 2021 14:48:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BCEmIC8031165 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 12 Dec 2021 09:48:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id D62D640CFD11; Sun, 12 Dec 2021 14:48:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D0DA040CFD0F
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 14:48:18 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B89BE811E76
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 14:48:18 +0000 (UTC)
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com
	[209.85.216.51]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-260-Bu1oBhRqMxivkNXrGEi6KQ-1; Sun, 12 Dec 2021 09:48:16 -0500
X-MC-Unique: Bu1oBhRqMxivkNXrGEi6KQ-1
Received: by mail-pj1-f51.google.com with SMTP id
	k6-20020a17090a7f0600b001ad9d73b20bso11324778pjl.3
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 06:48:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=J9eKyZRQJSa64buH1DnQ8o+5rJ2t1cRqyeDbRJ50KfQ=;
	b=ba3snHCyQC39FOO9oEGAMD654RBkDqRnW/AsdmSpIMigLX7hK+lBaHoHP5oCjh1Som
	+c7bLBz+ty8gcmc+CxC1grlsDYO/O1pAr5T3wTKh/QkIb95fuNRq73aQ5W4QbRKO8gw6
	3dUUAnIa37kTcVemz5vUn71vQB3Ej4e19HLcMl1dFcxBP64QR83/nchuqdEKPl7V0N3k
	iK1KY3EjCwmAeDgOCSfaG8ZAM3CMVp9fQ28UEdXH6fbRQo21nDm2liO7tTw+sf9gRI9I
	8griwwAC5kPcEFhpmrV8VwERmMUixajJbNJ9/b7qX2DdO4oJ7kEs+Sok9/EZc/H9FU3b
	VWyQ==
X-Gm-Message-State: AOAM531watGYKukjJmrM+dTTTA14BwwxiEYapino2hBSq2CyvG2dj5XL
	I66I2EfUjji7BQItsHlygrYgKdQYqOzJBWEYKR2vk1Tp05E=
X-Google-Smtp-Source: ABdhPJwABq62IFvC8Je+2tS1umh6MzmN/dQD3sgNomHUgnGTTqTS7vmAyUKH5BeY5i5mGqV95jTqKs6LCe1lv/XJ4YM=
X-Received: by 2002:a17:902:7fcd:b0:142:8ab3:ec0e with SMTP id
	t13-20020a1709027fcd00b001428ab3ec0emr88266767plb.4.1639320495664;
	Sun, 12 Dec 2021 06:48:15 -0800 (PST)
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-6-hch@lst.de> <YbNejVRF5NQB0r83@redhat.com>
In-Reply-To: <YbNejVRF5NQB0r83@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 06:48:05 -0800
Message-ID: <CAPcyv4i_HdnMcq6MmDMt-a5p=ojh_vsoAiES0vUYEh7HvC1O-A@mail.gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
	Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>,
	Alasdair Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/5] dax: always use _copy_mc_to_iter in
	dax_copy_to_iter
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 10, 2021 at 6:05 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Dec 09, 2021 at 07:38:28AM +0100, Christoph Hellwig wrote:
> > While using the MC-safe copy routines is rather pointless on a virtual device
> > like virtiofs,
>
> I was wondering about that. Is it completely pointless.
>
> Typically we are just mapping host page cache into qemu address space.
> That shows as virtiofs device pfn in guest and that pfn is mapped into
> guest application address space in mmap() call.
>
> Given on host its DRAM, so I would not expect machine check on load side
> so there was no need to use machine check safe variant.

That's a broken assumption, DRAM experiences multi-bit ECC errors.
Machine checks, data aborts, etc existed before PMEM.

>  But what if host
> filesystem is on persistent memory and using DAX. In that case load in
> guest can trigger a machine check. Not sure if that machine check will
> actually travel into the guest and unblock read() operation or not.
>
> But this sounds like a good change from virtiofs point of view, anyway.
>
> Thanks
> Vivek
>
>
> > it also isn't harmful at all.  So just use _copy_mc_to_iter
> > unconditionally to simplify the code.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/dax/super.c | 10 ----------
> >  fs/fuse/virtio_fs.c |  1 -
> >  include/linux/dax.h |  1 -
> >  3 files changed, 12 deletions(-)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index ff676a07480c8..fe783234ca669 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -107,8 +107,6 @@ enum dax_device_flags {
> >       DAXDEV_SYNC,
> >       /* do not use uncached operations to write data */
> >       DAXDEV_CACHED,
> > -     /* do not use mcsafe operations to read data */
> > -     DAXDEV_NOMCSAFE,
> >  };
> >
> >  /**
> > @@ -171,8 +169,6 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
> >        * via access_ok() in vfs_red, so use the 'no check' version to bypass
> >        * the HARDENED_USERCOPY overhead.
> >        */
> > -     if (test_bit(DAXDEV_NOMCSAFE, &dax_dev->flags))
> > -             return _copy_to_iter(addr, bytes, i);
> >       return _copy_mc_to_iter(addr, bytes, i);
> >  }
> >
> > @@ -242,12 +238,6 @@ void set_dax_cached(struct dax_device *dax_dev)
> >  }
> >  EXPORT_SYMBOL_GPL(set_dax_cached);
> >
> > -void set_dax_nomcsafe(struct dax_device *dax_dev)
> > -{
> > -     set_bit(DAXDEV_NOMCSAFE, &dax_dev->flags);
> > -}
> > -EXPORT_SYMBOL_GPL(set_dax_nomcsafe);
> > -
> >  bool dax_alive(struct dax_device *dax_dev)
> >  {
> >       lockdep_assert_held(&dax_srcu);
> > diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> > index 754319ce2a29b..d9c20b148ac19 100644
> > --- a/fs/fuse/virtio_fs.c
> > +++ b/fs/fuse/virtio_fs.c
> > @@ -838,7 +838,6 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
> >       if (IS_ERR(fs->dax_dev))
> >               return PTR_ERR(fs->dax_dev);
> >       set_dax_cached(fs->dax_dev);
> > -     set_dax_nomcsafe(fs->dax_dev);
> >       return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
> >                                       fs->dax_dev);
> >  }
> > diff --git a/include/linux/dax.h b/include/linux/dax.h
> > index d22cbf03d37d2..d267331bc37e7 100644
> > --- a/include/linux/dax.h
> > +++ b/include/linux/dax.h
> > @@ -90,7 +90,6 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
> >  #endif
> >
> >  void set_dax_cached(struct dax_device *dax_dev);
> > -void set_dax_nomcsafe(struct dax_device *dax_dev);
> >
> >  struct writeback_control;
> >  #if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
> > --
> > 2.30.2
> >
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

