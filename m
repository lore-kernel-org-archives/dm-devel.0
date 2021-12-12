Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 595D9C433EF
	for <dm-devel@archiver.kernel.org>; Sun, 12 Dec 2021 14:44:52 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-507-FOxGmgnKP7C1JNwMwfAjZQ-1; Sun, 12 Dec 2021 09:44:47 -0500
X-MC-Unique: FOxGmgnKP7C1JNwMwfAjZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 135F18042A2;
	Sun, 12 Dec 2021 14:44:43 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D9B7B19729;
	Sun, 12 Dec 2021 14:44:42 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 629891809CB8;
	Sun, 12 Dec 2021 14:44:42 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BCEie1J030524 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 12 Dec 2021 09:44:40 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2ACBD40CFD11; Sun, 12 Dec 2021 14:44:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2593840CFD0F
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 14:44:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED2283806720
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 14:44:39 +0000 (UTC)
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com
	[209.85.216.49]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-453-AeQW0-hZM5CGHBVvdSahZA-1; Sun, 12 Dec 2021 09:44:38 -0500
X-MC-Unique: AeQW0-hZM5CGHBVvdSahZA-1
Received: by mail-pj1-f49.google.com with SMTP id iq11so10122673pjb.3
	for <dm-devel@redhat.com>; Sun, 12 Dec 2021 06:44:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:mime-version:references:in-reply-to:from:date
	:message-id:subject:to:cc;
	bh=agYW6DcaeuP+q4nan8V1VqgSNwzlJAeR6akaOZ2DEVE=;
	b=PAs1JCFBfVdqupqQN2p69ur/IrN2nmlO3DBtH/HBhvhW1Oqsh8va3Tj+PfGufSMQTR
	fuaU/QiWnBrtuiH4AYOzaDgBU97KvTfZ+6GJyYViw4rDW3QEZinKUCdZo/ttFaeZOGb9
	OQALwFRaiUYeknigv0mMvYQwekBdedZSWsoIzI8WpbjiXpxpuobFxRzLIdK9BOIJT+N9
	pyx7E7jN7ZIdBe+ifewUSEAKZaafRakn0haCfgT3cuf91gkuqFnOLapXtlfH90o+eZi4
	LbjxiB7QXWfLHjAiW7Zp+9HHdQbraQK0LobH0jV8fJT7huZ1IhptBeJGQAA58o1cMu+8
	jc2Q==
X-Gm-Message-State: AOAM530RiJvgLugqZOyN/Ijo+2loA7wgyeAxq0TReF+nn8S1dsz+eDEA
	xpt6UXscJnLSmrmn0hgiqTdpbNoNHku4h3oVQilQlA==
X-Google-Smtp-Source: ABdhPJwLj56PBRqvGExnBUnnCkX5apEf9je516CrVNM0D8M9K2XSCF8Su7nlWxjv1JO1vwplQ6ww7tAn0NH7STTpMKQ=
X-Received: by 2002:a17:902:7fcd:b0:142:8ab3:ec0e with SMTP id
	t13-20020a1709027fcd00b001428ab3ec0emr88249325plb.4.1639320277138;
	Sun, 12 Dec 2021 06:44:37 -0800 (PST)
MIME-Version: 1.0
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-5-hch@lst.de> <YbNhPXBg7G/ridkV@redhat.com>
In-Reply-To: <YbNhPXBg7G/ridkV@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 12 Dec 2021 06:44:26 -0800
Message-ID: <CAPcyv4g4_yFqDeS+pnAZOxcB=Ua+iArK5mqn0iMG4PX6oL=F_A@mail.gmail.com>
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
Subject: Re: [dm-devel] [PATCH 4/5] dax: remove the copy_from_iter and
	copy_to_iter methods
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 10, 2021 at 6:17 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Dec 09, 2021 at 07:38:27AM +0100, Christoph Hellwig wrote:
> > These methods indirect the actual DAX read/write path.  In the end pmem
> > uses magic flush and mc safe variants and fuse and dcssblk use plain ones
> > while device mapper picks redirects to the underlying device.
> >
> > Add set_dax_virtual() and set_dax_nomcsafe() APIs for fuse to skip these
> > special variants, then use them everywhere as they fall back to the plain
> > ones on s390 anyway and remove an indirect call from the read/write path
> > as well as a lot of boilerplate code.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  drivers/dax/super.c           | 36 ++++++++++++++--
> >  drivers/md/dm-linear.c        | 20 ---------
> >  drivers/md/dm-log-writes.c    | 80 -----------------------------------
> >  drivers/md/dm-stripe.c        | 20 ---------
> >  drivers/md/dm.c               | 50 ----------------------
> >  drivers/nvdimm/pmem.c         | 20 ---------
> >  drivers/s390/block/dcssblk.c  | 14 ------
> >  fs/dax.c                      |  5 ---
> >  fs/fuse/virtio_fs.c           | 19 +--------
> >  include/linux/dax.h           |  9 ++--
> >  include/linux/device-mapper.h |  4 --
> >  11 files changed, 37 insertions(+), 240 deletions(-)
> >
>
> [..]
> > diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> > index 5c03a0364a9bb..754319ce2a29b 100644
> > --- a/fs/fuse/virtio_fs.c
> > +++ b/fs/fuse/virtio_fs.c
> > @@ -753,20 +753,6 @@ static long virtio_fs_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> >       return nr_pages > max_nr_pages ? max_nr_pages : nr_pages;
> >  }
> >
> > -static size_t virtio_fs_copy_from_iter(struct dax_device *dax_dev,
> > -                                    pgoff_t pgoff, void *addr,
> > -                                    size_t bytes, struct iov_iter *i)
> > -{
> > -     return copy_from_iter(addr, bytes, i);
> > -}
> > -
> > -static size_t virtio_fs_copy_to_iter(struct dax_device *dax_dev,
> > -                                    pgoff_t pgoff, void *addr,
> > -                                    size_t bytes, struct iov_iter *i)
> > -{
> > -     return copy_to_iter(addr, bytes, i);
> > -}
> > -
> >  static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
> >                                    pgoff_t pgoff, size_t nr_pages)
> >  {
> > @@ -783,8 +769,6 @@ static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
> >
> >  static const struct dax_operations virtio_fs_dax_ops = {
> >       .direct_access = virtio_fs_direct_access,
> > -     .copy_from_iter = virtio_fs_copy_from_iter,
> > -     .copy_to_iter = virtio_fs_copy_to_iter,
> >       .zero_page_range = virtio_fs_zero_page_range,
> >  };
> >
> > @@ -853,7 +837,8 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
> >       fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
> >       if (IS_ERR(fs->dax_dev))
> >               return PTR_ERR(fs->dax_dev);
> > -
> > +     set_dax_cached(fs->dax_dev);
>
> Looks good to me from virtiofs point of view.
>
> Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
>
> Going forward, I am wondering should virtiofs use flushcache version as
> well. What if host filesystem is using DAX and mapping persistent memory
> pfn directly into qemu address space. I have never tested that.
>
> Right now we are relying on applications to do fsync/msync on virtiofs
> for data persistence.

This sounds like it would need coordination with a paravirtualized
driver that can indicate whether the host side is pmem or not, like
the virtio_pmem driver. However, if the guest sends any fsync/msync
you would still need to go explicitly cache flush any dirty page
because you can't necessarily trust that the guest did that already.

>
> > +     set_dax_nomcsafe(fs->dax_dev);
> >       return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
> >                                       fs->dax_dev);
> >  }
>
> Thanks
> Vivek
>
>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

