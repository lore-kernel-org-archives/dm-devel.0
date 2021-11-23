Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2F17C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 22:37:31 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-602-JPEHcXQUMVKLJ2C55-r_pg-1; Tue, 23 Nov 2021 17:37:29 -0500
X-MC-Unique: JPEHcXQUMVKLJ2C55-r_pg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1ADC8100C660;
	Tue, 23 Nov 2021 22:37:25 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EFF3F79453;
	Tue, 23 Nov 2021 22:37:24 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C47964A703;
	Tue, 23 Nov 2021 22:37:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANMbN8I024740 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 17:37:23 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2CAD340CFD0D; Tue, 23 Nov 2021 22:37:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 27A3440CFD04
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:37:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0D4FE1066559
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 22:37:23 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-179-wnnbeDQ5OT6OP0R3wiSzQA-1; Tue, 23 Nov 2021 17:37:19 -0500
X-MC-Unique: wnnbeDQ5OT6OP0R3wiSzQA-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 089CA60C49;
	Tue, 23 Nov 2021 22:37:18 +0000 (UTC)
Date: Tue, 23 Nov 2021 14:37:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211123223717.GJ266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-16-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211109083309.584081-16-hch@lst.de>
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
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: Re: [dm-devel] [PATCH 15/29] xfs: add xfs_zero_range and
 xfs_truncate_page helpers
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 09, 2021 at 09:32:55AM +0100, Christoph Hellwig wrote:
> From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> 
> Add helpers to prepare for using different DAX operations.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> [hch: split from a larger patch + slight cleanups]
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_bmap_util.c |  7 +++----
>  fs/xfs/xfs_file.c      |  3 +--
>  fs/xfs/xfs_iomap.c     | 25 +++++++++++++++++++++++++
>  fs/xfs/xfs_iomap.h     |  4 ++++
>  fs/xfs/xfs_iops.c      |  7 +++----
>  fs/xfs/xfs_reflink.c   |  3 +--
>  6 files changed, 37 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> index 73a36b7be3bd1..797ea0c8b14e1 100644
> --- a/fs/xfs/xfs_bmap_util.c
> +++ b/fs/xfs/xfs_bmap_util.c
> @@ -1001,7 +1001,7 @@ xfs_free_file_space(
>  
>  	/*
>  	 * Now that we've unmap all full blocks we'll have to zero out any
> -	 * partial block at the beginning and/or end.  iomap_zero_range is smart
> +	 * partial block at the beginning and/or end.  xfs_zero_range is smart
>  	 * enough to skip any holes, including those we just created, but we
>  	 * must take care not to zero beyond EOF and enlarge i_size.
>  	 */
> @@ -1009,15 +1009,14 @@ xfs_free_file_space(
>  		return 0;
>  	if (offset + len > XFS_ISIZE(ip))
>  		len = XFS_ISIZE(ip) - offset;
> -	error = iomap_zero_range(VFS_I(ip), offset, len, NULL,
> -			&xfs_buffered_write_iomap_ops);
> +	error = xfs_zero_range(ip, offset, len, NULL);
>  	if (error)
>  		return error;
>  
>  	/*
>  	 * If we zeroed right up to EOF and EOF straddles a page boundary we
>  	 * must make sure that the post-EOF area is also zeroed because the
> -	 * page could be mmap'd and iomap_zero_range doesn't do that for us.
> +	 * page could be mmap'd and xfs_zero_range doesn't do that for us.
>  	 * Writeback of the eof page will do this, albeit clumsily.
>  	 */
>  	if (offset + len >= XFS_ISIZE(ip) && offset_in_page(offset + len) > 0) {
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 27594738b0d18..8d4c5ca261bd7 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -437,8 +437,7 @@ xfs_file_write_checks(
>  		}
>  
>  		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
> -		error = iomap_zero_range(inode, isize, iocb->ki_pos - isize,
> -				NULL, &xfs_buffered_write_iomap_ops);
> +		error = xfs_zero_range(ip, isize, iocb->ki_pos - isize, NULL);
>  		if (error)
>  			return error;
>  	} else
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 093758440ad53..d6d71ae9f2ae4 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1311,3 +1311,28 @@ xfs_xattr_iomap_begin(
>  const struct iomap_ops xfs_xattr_iomap_ops = {
>  	.iomap_begin		= xfs_xattr_iomap_begin,
>  };
> +
> +int
> +xfs_zero_range(
> +	struct xfs_inode	*ip,
> +	loff_t			pos,
> +	loff_t			len,
> +	bool			*did_zero)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +
> +	return iomap_zero_range(inode, pos, len, did_zero,
> +				&xfs_buffered_write_iomap_ops);
> +}
> +
> +int
> +xfs_truncate_page(
> +	struct xfs_inode	*ip,
> +	loff_t			pos,
> +	bool			*did_zero)
> +{
> +	struct inode		*inode = VFS_I(ip);
> +
> +	return iomap_truncate_page(inode, pos, did_zero,
> +				   &xfs_buffered_write_iomap_ops);
> +}
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index 7d3703556d0e0..f1a281ab9328c 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -20,6 +20,10 @@ xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
>  int xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
>  		struct xfs_bmbt_irec *, u16);
>  
> +int xfs_zero_range(struct xfs_inode *ip, loff_t pos, loff_t len,
> +		bool *did_zero);
> +int xfs_truncate_page(struct xfs_inode *ip, loff_t pos, bool *did_zero);
> +
>  static inline xfs_filblks_t
>  xfs_aligned_fsb_count(
>  	xfs_fileoff_t		offset_fsb,
> diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
> index a607d6aca5c4d..ab5ef52b2a9ff 100644
> --- a/fs/xfs/xfs_iops.c
> +++ b/fs/xfs/xfs_iops.c
> @@ -911,8 +911,8 @@ xfs_setattr_size(
>  	 */
>  	if (newsize > oldsize) {
>  		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
> -		error = iomap_zero_range(inode, oldsize, newsize - oldsize,
> -				&did_zeroing, &xfs_buffered_write_iomap_ops);
> +		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
> +				&did_zeroing);
>  	} else {
>  		/*
>  		 * iomap won't detect a dirty page over an unwritten block (or a
> @@ -924,8 +924,7 @@ xfs_setattr_size(
>  						     newsize);
>  		if (error)
>  			return error;
> -		error = iomap_truncate_page(inode, newsize, &did_zeroing,
> -				&xfs_buffered_write_iomap_ops);
> +		error = xfs_truncate_page(ip, newsize, &did_zeroing);
>  	}
>  
>  	if (error)
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index cb0edb1d68ef1..facce5c076d83 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1269,8 +1269,7 @@ xfs_reflink_zero_posteof(
>  		return 0;
>  
>  	trace_xfs_zero_eof(ip, isize, pos - isize);
> -	return iomap_zero_range(VFS_I(ip), isize, pos - isize, NULL,
> -			&xfs_buffered_write_iomap_ops);
> +	return xfs_zero_range(ip, isize, pos - isize, NULL);
>  }
>  
>  /*
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

