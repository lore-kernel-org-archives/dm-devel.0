Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8714AC433EF
	for <dm-devel@archiver.kernel.org>; Mon, 13 Dec 2021 16:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639412287;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=qqtKojLBcbnwaUeYWiyGABC/FOjwO++4993H8gPbi1c=;
	b=S9ABR4JN5L7wKL8lPR6z8fyeVAXWMkWN7VDFjsXEcpOvtA1iPGM7nkwxv4tUjSxHE5X6x5
	+5B8F/b0bVDmmWaStCEgTOtlYIogSpZk5aceWJpAdVFdu39mJPzs//ZMwFmJ02csnzW2H8
	4rlIbf+asdOWj6Ia5+mwV3STo0H2jio=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-535-lHaQ91NMONKFgEJbG6rfiQ-1; Mon, 13 Dec 2021 11:18:05 -0500
X-MC-Unique: lHaQ91NMONKFgEJbG6rfiQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15B4885B6C2;
	Mon, 13 Dec 2021 16:17:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DC025D6BA;
	Mon, 13 Dec 2021 16:17:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F3ACB1809CB8;
	Mon, 13 Dec 2021 16:17:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
	[10.5.11.12])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BDGHpfR015240 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 13 Dec 2021 11:17:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B6D84369A; Mon, 13 Dec 2021 16:17:51 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.17.75])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A17260C9F;
	Mon, 13 Dec 2021 16:17:50 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id D90BB2209DD; Mon, 13 Dec 2021 11:17:49 -0500 (EST)
Date: Mon, 13 Dec 2021 11:17:49 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dan Williams <dan.j.williams@intel.com>
Message-ID: <YbdyLc+V1xyp8sc5@redhat.com>
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-5-hch@lst.de> <YbNhPXBg7G/ridkV@redhat.com>
	<CAPcyv4g4_yFqDeS+pnAZOxcB=Ua+iArK5mqn0iMG4PX6oL=F_A@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g4_yFqDeS+pnAZOxcB=Ua+iArK5mqn0iMG4PX6oL=F_A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-loop: dm-devel@redhat.com
Cc: Linux NVDIMM <nvdimm@lists.linux.dev>,
	linux-s390 <linux-s390@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
	Vasily Gorbik <gor@linux.ibm.com>, Mike Snitzer <snitzer@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	"Dr. David Alan Gilbert" <dgilbert@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Sun, Dec 12, 2021 at 06:44:26AM -0800, Dan Williams wrote:
> On Fri, Dec 10, 2021 at 6:17 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Thu, Dec 09, 2021 at 07:38:27AM +0100, Christoph Hellwig wrote:
> > > These methods indirect the actual DAX read/write path.  In the end pmem
> > > uses magic flush and mc safe variants and fuse and dcssblk use plain ones
> > > while device mapper picks redirects to the underlying device.
> > >
> > > Add set_dax_virtual() and set_dax_nomcsafe() APIs for fuse to skip these
> > > special variants, then use them everywhere as they fall back to the plain
> > > ones on s390 anyway and remove an indirect call from the read/write path
> > > as well as a lot of boilerplate code.
> > >
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > ---
> > >  drivers/dax/super.c           | 36 ++++++++++++++--
> > >  drivers/md/dm-linear.c        | 20 ---------
> > >  drivers/md/dm-log-writes.c    | 80 -----------------------------------
> > >  drivers/md/dm-stripe.c        | 20 ---------
> > >  drivers/md/dm.c               | 50 ----------------------
> > >  drivers/nvdimm/pmem.c         | 20 ---------
> > >  drivers/s390/block/dcssblk.c  | 14 ------
> > >  fs/dax.c                      |  5 ---
> > >  fs/fuse/virtio_fs.c           | 19 +--------
> > >  include/linux/dax.h           |  9 ++--
> > >  include/linux/device-mapper.h |  4 --
> > >  11 files changed, 37 insertions(+), 240 deletions(-)
> > >
> >
> > [..]
> > > diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> > > index 5c03a0364a9bb..754319ce2a29b 100644
> > > --- a/fs/fuse/virtio_fs.c
> > > +++ b/fs/fuse/virtio_fs.c
> > > @@ -753,20 +753,6 @@ static long virtio_fs_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
> > >       return nr_pages > max_nr_pages ? max_nr_pages : nr_pages;
> > >  }
> > >
> > > -static size_t virtio_fs_copy_from_iter(struct dax_device *dax_dev,
> > > -                                    pgoff_t pgoff, void *addr,
> > > -                                    size_t bytes, struct iov_iter *i)
> > > -{
> > > -     return copy_from_iter(addr, bytes, i);
> > > -}
> > > -
> > > -static size_t virtio_fs_copy_to_iter(struct dax_device *dax_dev,
> > > -                                    pgoff_t pgoff, void *addr,
> > > -                                    size_t bytes, struct iov_iter *i)
> > > -{
> > > -     return copy_to_iter(addr, bytes, i);
> > > -}
> > > -
> > >  static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
> > >                                    pgoff_t pgoff, size_t nr_pages)
> > >  {
> > > @@ -783,8 +769,6 @@ static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
> > >
> > >  static const struct dax_operations virtio_fs_dax_ops = {
> > >       .direct_access = virtio_fs_direct_access,
> > > -     .copy_from_iter = virtio_fs_copy_from_iter,
> > > -     .copy_to_iter = virtio_fs_copy_to_iter,
> > >       .zero_page_range = virtio_fs_zero_page_range,
> > >  };
> > >
> > > @@ -853,7 +837,8 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
> > >       fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
> > >       if (IS_ERR(fs->dax_dev))
> > >               return PTR_ERR(fs->dax_dev);
> > > -
> > > +     set_dax_cached(fs->dax_dev);
> >
> > Looks good to me from virtiofs point of view.
> >
> > Reviewed-by: Vivek Goyal <vgoyal@redhat.com>
> >
> > Going forward, I am wondering should virtiofs use flushcache version as
> > well. What if host filesystem is using DAX and mapping persistent memory
> > pfn directly into qemu address space. I have never tested that.
> >
> > Right now we are relying on applications to do fsync/msync on virtiofs
> > for data persistence.
> 
> This sounds like it would need coordination with a paravirtualized
> driver that can indicate whether the host side is pmem or not, like
> the virtio_pmem driver.

Agreed. Let me check the details of virtio_pmem driver.

> However, if the guest sends any fsync/msync
> you would still need to go explicitly cache flush any dirty page
> because you can't necessarily trust that the guest did that already.

So host dax functionality will already take care of that, IIUC, right?
I see a dax_flush() call in dax_writeback_one(). I am assuming that's
the will take care of flushing dirty pages when guest issues
fsync()/msync(). So probably don't have to do anything extra here.

I think qemu should map files using MAP_SYNC though in this case though.
Any read/writes to virtiofs files will turn into host file load/store
operations. So flushcache in guest makes more sense with MAP_SYNC which
should make sure any filesystem metadata will already persist after
fault completion. And later guest can do writes followed by flush and
ensure data persists too.

IOW, I probably only need to do following.

- In virtiofs virtual device, add a notion of kind of dax window or memory
  it supports. So may be some kind of "writethrough" property of virtiofs
  dax cache.

- Use this property in virtiofs driver to decide whether to use 
  plain copy_from_iter() or _copy_from_iter_flushcache().

- qemu should use mmap(MAP_SYNC) if host filesystem is on persistent
  memory.

Thanks
Vivek

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

