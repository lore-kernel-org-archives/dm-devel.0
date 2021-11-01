Return-Path: <SRS0=tK5J=PU=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5E64C433F5
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 16:18:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 73D17610A5
	for <dm-devel@archiver.kernel.org>; Mon,  1 Nov 2021 16:18:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 73D17610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1635783481;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=xniEL4FaYHWETbFvg2BqcckYgdN8Em2vYLRAskHv/ZY=;
	b=belnzs76zZO6grQ6KmFfRcQvpgfkLTjzKPFJxHEvmlcz9PA1Oz5V/yMtZfwa0qhmhvcbtO
	gn5CcRu0j/PtPesEHktXmJWyp8wRrSDiJqPP+hpIOZUKAuB7JixHX/m9GR3nws/2kALPSQ
	f9en6Q2O8RBwEW5dzuedJb8B1K1hgWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-V5073ysFM0qm2QbBi-VbQw-1; Mon, 01 Nov 2021 12:17:58 -0400
X-MC-Unique: V5073ysFM0qm2QbBi-VbQw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0391C10A8E0C;
	Mon,  1 Nov 2021 16:17:53 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE6F460CC9;
	Mon,  1 Nov 2021 16:17:52 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2D9C14EA2A;
	Mon,  1 Nov 2021 16:17:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A1GHo0S003265 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 1 Nov 2021 12:17:51 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CB9A72166B3F; Mon,  1 Nov 2021 16:17:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C5CF72166B2D
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 16:17:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26208899EE2
	for <dm-devel@redhat.com>; Mon,  1 Nov 2021 16:17:47 +0000 (UTC)
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
	[209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-65-QGrYNepYPMWOv8IizH8Rvw-1; Mon, 01 Nov 2021 12:17:46 -0400
X-MC-Unique: QGrYNepYPMWOv8IizH8Rvw-1
Received: by mail-qk1-f198.google.com with SMTP id
	ay9-20020a05620a178900b00462db20ac02so7152377qkb.10
	for <dm-devel@redhat.com>; Mon, 01 Nov 2021 09:17:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:date:from:to:cc:subject:message-id:references
	:mime-version:content-disposition:in-reply-to;
	bh=F2vxwqlB6wFzeCRM5lLa77O94J13VaOz9ZvoVd+rZG8=;
	b=m+bZ2Cbth8eSHORZOQGhV9GL7Kpxx7Z8cRC0G2zMjYpLKiS8fNcahsxyUwep/XlK+1
	0rhGBynFzVsPtJj/kDSh56dRpEdx3+sh7yxeO5vMRfQTTbU/x4SfK91NR0LqtFd92gjh
	67zVHKdFTb32Mx6VEUyxcsUd17x2LKV1BG3NHmguE2B17R4a2hK2g2Wss24trQfXrq3p
	U6lRfg4ZceH4+50m7M5S4dAzSGH5EzicoMXc82+DWkMMiq4XfpCGistw5n0N1bD0me0d
	i0kKV/TJzs2SVq6UsJLj4V8+vP/UK17Wn2xBI5UvXMjEKAqxg2SDHfp6r+iVctEY8fmq
	YyGA==
X-Gm-Message-State: AOAM532ZbCA/oUOUjlwitLxwmN04Yll/IokTbISmKUUqrwkNlnN/ApVz
	+RSW+4x18EMeIrGvsa+aOBEgsuhRXiaffrEcd6NZHMj+y3arxJGlJgjiTLoM/CjItS4J8zyqsBL
	N2vhi8UQeRxlbog==
X-Received: by 2002:a05:622a:1006:: with SMTP id
	d6mr31006249qte.259.1635783465575; 
	Mon, 01 Nov 2021 09:17:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwsvnNj6Smb4Ra96XKXfYd15LiYJibYUWXpiZB6UR51qpyc+daCyIZfeeXzYlbHsOmSJkMTRA==
X-Received: by 2002:a05:622a:1006:: with SMTP id
	d6mr31006216qte.259.1635783465346; 
	Mon, 01 Nov 2021 09:17:45 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
	[68.160.176.52]) by smtp.gmail.com with ESMTPSA id
	f66sm5772868qkj.76.2021.11.01.09.17.44
	(version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
	Mon, 01 Nov 2021 09:17:44 -0700 (PDT)
Date: Mon, 1 Nov 2021 12:17:43 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <YYATJ+oDT15TD9Np@redhat.com>
References: <20211018044054.1779424-1-hch@lst.de>
	<20211018044054.1779424-8-hch@lst.de>
	<CAPcyv4gE8UXjQAe_6=BKFRCyLWNP_9CNxKFH---RpPnYfmBQLg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gE8UXjQAe_6=BKFRCyLWNP_9CNxKFH---RpPnYfmBQLg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs <linux-xfs@vger.kernel.org>,
	device-mapper development <dm-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Ira Weiny <ira.weiny@intel.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 07/11] dax: remove dax_capable
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Oct 27 2021 at  8:16P -0400,
Dan Williams <dan.j.williams@intel.com> wrote:

> I am going to change the subject of this patch to:
> 
> dax: remove ->dax_supported()
> 
> On Sun, Oct 17, 2021 at 9:41 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> 
> I'll add a bit more background to help others review this.
> 
> The ->dax_supported() operation arranges for a stack of devices to
> each answer the question "is dax operational". That request routes to
> generic_fsdax_supported() at last level device and that attempted an
> actual dax_direct_access() call and did some sanity checks. However,
> those sanity checks can be validated in other ways and with those
> removed the only question to answer is "has each block device driver
> in the stack performed dax_add_host()". That can be validated without
> a dax_operation. So, just open code the block size and dax_dev == NULL
> checks in the callers, and delete ->dax_supported().
> 
> Mike, let me know if you have any concerns.

Thanks for your additional background, it helped.


> 
> > Just open code the block size and dax_dev == NULL checks in the callers.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/dax/super.c          | 36 ------------------------------------
> >  drivers/md/dm-table.c        | 22 +++++++++++-----------
> >  drivers/md/dm.c              | 21 ---------------------
> >  drivers/md/dm.h              |  4 ----
> >  drivers/nvdimm/pmem.c        |  1 -
> >  drivers/s390/block/dcssblk.c |  1 -
> >  fs/erofs/super.c             | 11 +++++++----
> >  fs/ext2/super.c              |  6 ++++--
> >  fs/ext4/super.c              |  9 ++++++---
> >  fs/xfs/xfs_super.c           | 21 ++++++++-------------
> >  include/linux/dax.h          | 14 --------------
> >  11 files changed, 36 insertions(+), 110 deletions(-)
> >
> > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> > index 482fe775324a4..803942586d1b6 100644
> > --- a/drivers/dax/super.c
> > +++ b/drivers/dax/super.c
> > @@ -108,42 +108,6 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
> >         return dax_dev;
> >  }
> >  EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> > -
> > -bool generic_fsdax_supported(struct dax_device *dax_dev,
> > -               struct block_device *bdev, int blocksize, sector_t start,
> > -               sector_t sectors)
> > -{
> > -       if (blocksize != PAGE_SIZE) {
> > -               pr_info("%pg: error: unsupported blocksize for dax\n", bdev);
> > -               return false;
> > -       }
> > -
> > -       if (!dax_dev) {
> > -               pr_debug("%pg: error: dax unsupported by block device\n", bdev);
> > -               return false;
> > -       }
> > -
> > -       return true;
> > -}
> > -EXPORT_SYMBOL_GPL(generic_fsdax_supported);
> > -
> > -bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
> > -               int blocksize, sector_t start, sector_t len)
> > -{
> > -       bool ret = false;
> > -       int id;
> > -
> > -       if (!dax_dev)
> > -               return false;
> > -
> > -       id = dax_read_lock();
> > -       if (dax_alive(dax_dev) && dax_dev->ops->dax_supported)
> > -               ret = dax_dev->ops->dax_supported(dax_dev, bdev, blocksize,
> > -                                                 start, len);
> > -       dax_read_unlock(id);
> > -       return ret;
> > -}
> > -EXPORT_SYMBOL_GPL(dax_supported);
> >  #endif /* CONFIG_BLOCK && CONFIG_FS_DAX */
> >
> >  enum dax_device_flags {
> > diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> > index 1fa4d5582dca5..4ae671c2168ea 100644
> > --- a/drivers/md/dm-table.c
> > +++ b/drivers/md/dm-table.c
> > @@ -807,12 +807,14 @@ void dm_table_set_type(struct dm_table *t, enum dm_queue_mode type)
> >  EXPORT_SYMBOL_GPL(dm_table_set_type);
> >
> >  /* validate the dax capability of the target device span */
> > -int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
> > +static int device_not_dax_capable(struct dm_target *ti, struct dm_dev *dev,
> >                         sector_t start, sector_t len, void *data)
> >  {
> > -       int blocksize = *(int *) data;
> > +       if (dev->dax_dev)
> > +               return false;
> >
> > -       return !dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
> > +       pr_debug("%pg: error: dax unsupported by block device\n", dev->bdev);

Would prefer the use of DMDEBUG() here (which doesn't need trailing \n)

But otherwise:
Acked-by: Mike Snitzer <snitzer@redhat.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

