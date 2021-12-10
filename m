Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B10AC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 10 Dec 2021 14:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1639145367;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=MyeftgpK41Om51vs8aE843Wjt/kZFhAJziy3h/Z5tiY=;
	b=D+VqggJ07usGg/N5zF2unPac3SfxyTicxbiAOOHIPkwHqsiSMzbpNnRI32yKOXicB71im3
	c6nA4tc7ce0v5BIziZ0f6MzBwuYlisD1Fi0uYvBEEOY9DXudHRFGE3V/nMZSm66pHIcMVj
	qtJY/kZKjCasAS9rU9so5a5pG9//55c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-167-_wuZ5zgiOZ-SrMmB3M5c_Q-1; Fri, 10 Dec 2021 09:09:22 -0500
X-MC-Unique: _wuZ5zgiOZ-SrMmB3M5c_Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B543A100CCC2;
	Fri, 10 Dec 2021 14:09:16 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 96B9110016F5;
	Fri, 10 Dec 2021 14:09:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BEB094BB7C;
	Fri, 10 Dec 2021 14:09:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
	[10.5.11.23])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1BAE5Tk3003485 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 10 Dec 2021 09:05:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EB6A4A211; Fri, 10 Dec 2021 14:05:29 +0000 (UTC)
Received: from horse.redhat.com (unknown [10.22.17.42])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C13919C59;
	Fri, 10 Dec 2021 14:05:02 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
	id AC32F2209DD; Fri, 10 Dec 2021 09:05:01 -0500 (EST)
Date: Fri, 10 Dec 2021 09:05:01 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <YbNejVRF5NQB0r83@redhat.com>
References: <20211209063828.18944-1-hch@lst.de>
	<20211209063828.18944-6-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211209063828.18944-6-hch@lst.de>
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Dec 09, 2021 at 07:38:28AM +0100, Christoph Hellwig wrote:
> While using the MC-safe copy routines is rather pointless on a virtual device
> like virtiofs,

I was wondering about that. Is it completely pointless.

Typically we are just mapping host page cache into qemu address space.
That shows as virtiofs device pfn in guest and that pfn is mapped into
guest application address space in mmap() call.

Given on host its DRAM, so I would not expect machine check on load side
so there was no need to use machine check safe variant. But what if host
filesystem is on persistent memory and using DAX. In that case load in
guest can trigger a machine check. Not sure if that machine check will
actually travel into the guest and unblock read() operation or not.

But this sounds like a good change from virtiofs point of view, anyway.

Thanks
Vivek


> it also isn't harmful at all.  So just use _copy_mc_to_iter
> unconditionally to simplify the code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/dax/super.c | 10 ----------
>  fs/fuse/virtio_fs.c |  1 -
>  include/linux/dax.h |  1 -
>  3 files changed, 12 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index ff676a07480c8..fe783234ca669 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -107,8 +107,6 @@ enum dax_device_flags {
>  	DAXDEV_SYNC,
>  	/* do not use uncached operations to write data */
>  	DAXDEV_CACHED,
> -	/* do not use mcsafe operations to read data */
> -	DAXDEV_NOMCSAFE,
>  };
>  
>  /**
> @@ -171,8 +169,6 @@ size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>  	 * via access_ok() in vfs_red, so use the 'no check' version to bypass
>  	 * the HARDENED_USERCOPY overhead.
>  	 */
> -	if (test_bit(DAXDEV_NOMCSAFE, &dax_dev->flags))
> -		return _copy_to_iter(addr, bytes, i);
>  	return _copy_mc_to_iter(addr, bytes, i);
>  }
>  
> @@ -242,12 +238,6 @@ void set_dax_cached(struct dax_device *dax_dev)
>  }
>  EXPORT_SYMBOL_GPL(set_dax_cached);
>  
> -void set_dax_nomcsafe(struct dax_device *dax_dev)
> -{
> -	set_bit(DAXDEV_NOMCSAFE, &dax_dev->flags);
> -}
> -EXPORT_SYMBOL_GPL(set_dax_nomcsafe);
> -
>  bool dax_alive(struct dax_device *dax_dev)
>  {
>  	lockdep_assert_held(&dax_srcu);
> diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
> index 754319ce2a29b..d9c20b148ac19 100644
> --- a/fs/fuse/virtio_fs.c
> +++ b/fs/fuse/virtio_fs.c
> @@ -838,7 +838,6 @@ static int virtio_fs_setup_dax(struct virtio_device *vdev, struct virtio_fs *fs)
>  	if (IS_ERR(fs->dax_dev))
>  		return PTR_ERR(fs->dax_dev);
>  	set_dax_cached(fs->dax_dev);
> -	set_dax_nomcsafe(fs->dax_dev);
>  	return devm_add_action_or_reset(&vdev->dev, virtio_fs_cleanup_dax,
>  					fs->dax_dev);
>  }
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index d22cbf03d37d2..d267331bc37e7 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -90,7 +90,6 @@ static inline bool daxdev_mapping_supported(struct vm_area_struct *vma,
>  #endif
>  
>  void set_dax_cached(struct dax_device *dax_dev);
> -void set_dax_nomcsafe(struct dax_device *dax_dev);
>  
>  struct writeback_control;
>  #if defined(CONFIG_BLOCK) && defined(CONFIG_FS_DAX)
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

