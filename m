Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA68C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:56:06 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-VsWB5YDhPL6JPEqE2A91xA-1; Tue, 23 Nov 2021 17:56:02 -0500
X-MC-Unique: VsWB5YDhPL6JPEqE2A91xA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5D738799E0;
	Tue, 23 Nov 2021 22:55:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA4C05D6CF;
	Tue, 23 Nov 2021 22:55:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 92CC41832E81;
	Tue, 23 Nov 2021 22:55:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANMtu9m025971 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 17:55:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 1B19B2166B26; Tue, 23 Nov 2021 22:55:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 15E752166B25
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:55:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FB76185A7BA
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:55:53 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-403-DiQY0QkTNN2wWgSeNjinJw-1; Tue, 23 Nov 2021 17:55:49 -0500
X-MC-Unique: DiQY0QkTNN2wWgSeNjinJw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4550060F5D;
	Tue, 23 Nov 2021 22:55:48 +0000 (UTC)
Date: Tue, 23 Nov 2021 14:55:48 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211123225548.GP266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-22-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211109083309.584081-22-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 21/29] xfs: move dax device handling into
 xfs_{alloc, free}_buftarg
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

On Tue, Nov 09, 2021 at 09:33:01AM +0100, Christoph Hellwig wrote:
> Hide the DAX device lookup from the xfs_super.c code.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

This looks to be a straightforward conversion.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c   |  8 ++++----
>  fs/xfs/xfs_buf.h   |  4 ++--
>  fs/xfs/xfs_super.c | 26 +++++---------------------
>  3 files changed, 11 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 631c5a61d89b7..4d4553ffa7050 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1892,6 +1892,7 @@ xfs_free_buftarg(
>  	list_lru_destroy(&btp->bt_lru);
>  
>  	blkdev_issue_flush(btp->bt_bdev);
> +	fs_put_dax(btp->bt_daxdev);
>  
>  	kmem_free(btp);
>  }
> @@ -1932,11 +1933,10 @@ xfs_setsize_buftarg_early(
>  	return xfs_setsize_buftarg(btp, bdev_logical_block_size(bdev));
>  }
>  
> -xfs_buftarg_t *
> +struct xfs_buftarg *
>  xfs_alloc_buftarg(
>  	struct xfs_mount	*mp,
> -	struct block_device	*bdev,
> -	struct dax_device	*dax_dev)
> +	struct block_device	*bdev)
>  {
>  	xfs_buftarg_t		*btp;
>  
> @@ -1945,7 +1945,7 @@ xfs_alloc_buftarg(
>  	btp->bt_mount = mp;
>  	btp->bt_dev =  bdev->bd_dev;
>  	btp->bt_bdev = bdev;
> -	btp->bt_daxdev = dax_dev;
> +	btp->bt_daxdev = fs_dax_get_by_bdev(bdev);
>  
>  	/*
>  	 * Buffer IO error rate limiting. Limit it to no more than 10 messages
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index 6b0200b8007d1..bd7f709f0d232 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -338,8 +338,8 @@ xfs_buf_update_cksum(struct xfs_buf *bp, unsigned long cksum_offset)
>  /*
>   *	Handling of buftargs.
>   */
> -extern struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *,
> -		struct block_device *, struct dax_device *);
> +struct xfs_buftarg *xfs_alloc_buftarg(struct xfs_mount *mp,
> +		struct block_device *bdev);
>  extern void xfs_free_buftarg(struct xfs_buftarg *);
>  extern void xfs_buftarg_wait(struct xfs_buftarg *);
>  extern void xfs_buftarg_drain(struct xfs_buftarg *);
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 3a45d5caa28d5..7262716afb215 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -391,26 +391,19 @@ STATIC void
>  xfs_close_devices(
>  	struct xfs_mount	*mp)
>  {
> -	struct dax_device *dax_ddev = mp->m_ddev_targp->bt_daxdev;
> -
>  	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp) {
>  		struct block_device *logdev = mp->m_logdev_targp->bt_bdev;
> -		struct dax_device *dax_logdev = mp->m_logdev_targp->bt_daxdev;
>  
>  		xfs_free_buftarg(mp->m_logdev_targp);
>  		xfs_blkdev_put(logdev);
> -		fs_put_dax(dax_logdev);
>  	}
>  	if (mp->m_rtdev_targp) {
>  		struct block_device *rtdev = mp->m_rtdev_targp->bt_bdev;
> -		struct dax_device *dax_rtdev = mp->m_rtdev_targp->bt_daxdev;
>  
>  		xfs_free_buftarg(mp->m_rtdev_targp);
>  		xfs_blkdev_put(rtdev);
> -		fs_put_dax(dax_rtdev);
>  	}
>  	xfs_free_buftarg(mp->m_ddev_targp);
> -	fs_put_dax(dax_ddev);
>  }
>  
>  /*
> @@ -428,8 +421,6 @@ xfs_open_devices(
>  	struct xfs_mount	*mp)
>  {
>  	struct block_device	*ddev = mp->m_super->s_bdev;
> -	struct dax_device	*dax_ddev = fs_dax_get_by_bdev(ddev);
> -	struct dax_device	*dax_logdev = NULL, *dax_rtdev = NULL;
>  	struct block_device	*logdev = NULL, *rtdev = NULL;
>  	int			error;
>  
> @@ -439,8 +430,7 @@ xfs_open_devices(
>  	if (mp->m_logname) {
>  		error = xfs_blkdev_get(mp, mp->m_logname, &logdev);
>  		if (error)
> -			goto out;
> -		dax_logdev = fs_dax_get_by_bdev(logdev);
> +			return error;
>  	}
>  
>  	if (mp->m_rtname) {
> @@ -454,25 +444,24 @@ xfs_open_devices(
>  			error = -EINVAL;
>  			goto out_close_rtdev;
>  		}
> -		dax_rtdev = fs_dax_get_by_bdev(rtdev);
>  	}
>  
>  	/*
>  	 * Setup xfs_mount buffer target pointers
>  	 */
>  	error = -ENOMEM;
> -	mp->m_ddev_targp = xfs_alloc_buftarg(mp, ddev, dax_ddev);
> +	mp->m_ddev_targp = xfs_alloc_buftarg(mp, ddev);
>  	if (!mp->m_ddev_targp)
>  		goto out_close_rtdev;
>  
>  	if (rtdev) {
> -		mp->m_rtdev_targp = xfs_alloc_buftarg(mp, rtdev, dax_rtdev);
> +		mp->m_rtdev_targp = xfs_alloc_buftarg(mp, rtdev);
>  		if (!mp->m_rtdev_targp)
>  			goto out_free_ddev_targ;
>  	}
>  
>  	if (logdev && logdev != ddev) {
> -		mp->m_logdev_targp = xfs_alloc_buftarg(mp, logdev, dax_logdev);
> +		mp->m_logdev_targp = xfs_alloc_buftarg(mp, logdev);
>  		if (!mp->m_logdev_targp)
>  			goto out_free_rtdev_targ;
>  	} else {
> @@ -488,14 +477,9 @@ xfs_open_devices(
>  	xfs_free_buftarg(mp->m_ddev_targp);
>   out_close_rtdev:
>  	xfs_blkdev_put(rtdev);
> -	fs_put_dax(dax_rtdev);
>   out_close_logdev:
> -	if (logdev && logdev != ddev) {
> +	if (logdev && logdev != ddev)
>  		xfs_blkdev_put(logdev);
> -		fs_put_dax(dax_logdev);
> -	}
> - out:
> -	fs_put_dax(dax_ddev);
>  	return error;
>  }
>  
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

