Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE61C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 10 Dec 2021 14:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639145839;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6LYvxJrmhGyYlwq2lzAhQ3fezq5quM/D/CFV8PHt9TI=;
	b=gM0KrgxSfPSfzP/V+KENQGytQrE5DzSZlrj2z2unrdFe88kHO798FIDawndwRI3YVd26EY
	511dLn8nwasFW9djVgw0GNjSsW0tgCkMoa3XSPfz8vXmeLcCNqFDtTI3JQWlsnpxY9SnmN
	qll8W8D79vwG4hOjaIMSmKwL37NyQBA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-61DvkR-4MpK9ToHjgopf9Q-1; Fri, 10 Dec 2021 09:17:15 -0500
X-MC-Unique: 61DvkR-4MpK9ToHjgopf9Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CDD9801962;
	Fri, 10 Dec 2021 14:17:10 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E95C10016F5;
	Fri, 10 Dec 2021 14:17:10 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 714F04BB7C;
	Fri, 10 Dec 2021 14:17:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BAEH7wf004470 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Dec 2021 09:17:07 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 22A6B45D9; Fri, 10 Dec 2021 14:17:07 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.17.42])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 12ED719C59;
	Fri, 10 Dec 2021 14:16:30 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id 967302209DD; Fri, 10 Dec 2021 09:16:29 -0500 (EST)
Date: Fri, 10 Dec 2021 09:16:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YbNhPXBg7G/ridkV@redhat.com>
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-5-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211209063828.18944-5-hch@lst.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, linux-s390@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>, Vasily Gorbik <gor@linux.ibm.com>,
	Mike Snitzer <snitzer@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Heiko Carstens <hca@linux.ibm.com>, Matthew Wilcox <willy@infradead.org>,
	virtualization@lists.linux-foundation.org,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	dm-devel@redhat.com, Stefan Hajnoczi <stefanha@redhat.com>,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>, Alasdair Kergon <agk@redhat.com>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 09, 2021 at 07:38:27AM +0100, Christoph Hellwig wrote:
> These methods indirect the actual DAX read/write path.  In the end pmem
> uses magic flush and mc safe variants and fuse and dcssblk use plain ones
> while device mapper picks redirects to the underlying device.
> 
> Add set_dax_virtual() and set_dax_nomcsafe() APIs for fuse to skip these
> special variants, then use them everywhere as they fall back to the plain
> ones on s390 anyway and remove an indirect call from the read/write path
> as well as a lot of boilerplate code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c           | 36 ++++++++++++++--
>  drivers/md/dm-linear.c        | 20 ---------
>  drivers/md/dm-log-writes.c    | 80 -----------------------------------
>  drivers/md/dm-stripe.c        | 20 ---------
>  drivers/md/dm.c               | 50 ----------------------
>  drivers/nvdimm/pmem.c         | 20 ---------
>  drivers/s390/block/dcssblk.c  | 14 ------
>  fs/dax.c                      |  5 ---
>  fs/fuse/virtio_fs.c           | 19 +--------
>  include/linux/dax.h           |  9 ++--
>  include/linux/device-mapper.h |  4 --
>  11 files changed, 37 insertions(+), 240 deletions(-)
> 

[..]
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 5c03a0364a9bb..754319ce2a29b 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -753,20 +753,6 @@ static long virtio_fs_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  	return nr_pages > max_nr_pages ? max_nr_pages : nr_pages;
>  }
>  
> -static size_t virtio_fs_copy_from_iter(struct dax_device *dax_dev,
> -				       pgoff_t pgoff, void *addr,
> -				       size_t bytes, struct iov_iter *i)
> -{
> -	return copy_from_iter(addr, bytes, i);
> -}
> -
> -static size_t virtio_fs_copy_to_iter(struct dax_device *dax_dev,
> -				       pgoff_t pgoff, void *addr,
> -				       size_t bytes, struct iov_iter *i)
> -{
> -	return copy_to_iter(addr, bytes, i);
> -}
> -
>  static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
>  				     pgoff_t pgoff, size_t nr_pages)
>  {
> @@ -783,8 +769,6 @@ static int virtio_fs_zero_page_range(struct dax_device *dax_dev,
>  
>  static const struct dax_operations virtio_fs_dax_ops = {
>  	.direct_access = virtio_fs_direct_access,
> -	.copy_from_iter = virtio_fs_copy_from_iter,
> -	.copy_to_iter = virtio_fs_copy_to_iter,
>  	.zero_page_range = virtio_fs_zero_page_range,
>  };
>  
> @@ -853,7 +837,8 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
>  	fs->dax_dev = alloc_dax(fs, &virtio_fs_dax_ops);
>  	if (IS_ERR(fs->dax_dev))
>  		return PTR_ERR(fs->dax_dev);
> -
> +	set_dax_cached(fs->dax_dev);

Looks good to me from virtiofs point of view.

Reviewed-by: Vivek Goyal <vgoyal@redhat.com>

Going forward, I am wondering should virtiofs use flushcache version as
well. What if host filesystem is using DAX and mapping persistent memory
pfn directly into qemu address space. I have never tested that.

Right now we are relying on applications to do fsync/msync on virtiofs
for data persistence.

> +	set_dax_nomcsafe(fs->dax_dev);
>  	return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
>  					fs->dax_dev);
>  }

Thanks
Vivek

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

