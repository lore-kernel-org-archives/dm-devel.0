Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D814BC433EF
	for <dm-devel@archiver.kernel.org>; Tue, 30 Nov 2021 18:59:36 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-CfQvAGwIPAej7WMyUejODQ-1; Tue, 30 Nov 2021 13:59:34 -0500
X-MC-Unique: CfQvAGwIPAej7WMyUejODQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DE5AE102CC42;
	Tue, 30 Nov 2021 18:59:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE7E05D6BA;
	Tue, 30 Nov 2021 18:59:29 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 838F74CA93;
	Tue, 30 Nov 2021 18:59:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AUIxRLg017370 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 30 Nov 2021 13:59:27 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 15BA91458303; Tue, 30 Nov 2021 18:59:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1141D1458302
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 18:59:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA7258001E9
	for <dm-devel@redhat.com>; Tue, 30 Nov 2021 18:59:26 +0000 (UTC)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-597-5Knrg0cHOla09NANQCyltQ-1; Tue, 30 Nov 2021 13:59:22 -0500
X-MC-Unique: 5Knrg0cHOla09NANQCyltQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.source.kernel.org (Postfix) with ESMTPS id 50945CE1AFA;
	Tue, 30 Nov 2021 18:59:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F1EC53FCC;
	Tue, 30 Nov 2021 18:59:16 +0000 (UTC)
Date: Tue, 30 Nov 2021 10:59:16 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211130185916.GG8467@magnolia>
References: <20211129102203.2243509-1-hch@lst.de>
	<20211129102203.2243509-24-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211129102203.2243509-24-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 23/29] xfs: pass the mapping flags to
	xfs_bmbt_to_iomap
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

On Mon, Nov 29, 2021 at 11:21:57AM +0100, Christoph Hellwig wrote:
> To prepare for looking at the IOMAP_DAX flag in xfs_bmbt_to_iomap pass in
> the input mapping flags to xfs_bmbt_to_iomap.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Thanks for changing the argument names to be less confusing,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_bmap.c |  4 ++--
>  fs/xfs/xfs_aops.c        |  2 +-
>  fs/xfs/xfs_iomap.c       | 35 ++++++++++++++++++++---------------
>  fs/xfs/xfs_iomap.h       |  5 +++--
>  fs/xfs/xfs_pnfs.c        |  2 +-
>  5 files changed, 27 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 4dccd4d90622d..74198dd82b035 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4551,7 +4551,7 @@ xfs_bmapi_convert_delalloc(
>  	 * the extent.  Just return the real extent at this offset.
>  	 */
>  	if (!isnullstartblock(bma.got.br_startblock)) {
> -		xfs_bmbt_to_iomap(ip, iomap, &bma.got, flags);
> +		xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags);
>  		*seq = READ_ONCE(ifp->if_seq);
>  		goto out_trans_cancel;
>  	}
> @@ -4598,7 +4598,7 @@ xfs_bmapi_convert_delalloc(
>  	XFS_STATS_INC(mp, xs_xstrat_quick);
>  
>  	ASSERT(!isnullstartblock(bma.got.br_startblock));
> -	xfs_bmbt_to_iomap(ip, iomap, &bma.got, flags);
> +	xfs_bmbt_to_iomap(ip, iomap, &bma.got, 0, flags);
>  	*seq = READ_ONCE(ifp->if_seq);
>  
>  	if (whichfork == XFS_COW_FORK)
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index c8c15c3c31471..6ac3449a68ba0 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -359,7 +359,7 @@ xfs_map_blocks(
>  	    isnullstartblock(imap.br_startblock))
>  		goto allocate_blocks;
>  
> -	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0);
> +	xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0);
>  	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
>  	return 0;
>  allocate_blocks:
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 9b7f92c6aef33..d6beb1502f8bc 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -53,7 +53,8 @@ xfs_bmbt_to_iomap(
>  	struct xfs_inode	*ip,
>  	struct iomap		*iomap,
>  	struct xfs_bmbt_irec	*imap,
> -	u16			flags)
> +	unsigned int		mapping_flags,
> +	u16			iomap_flags)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
>  	struct xfs_buftarg	*target = xfs_inode_buftarg(ip);
> @@ -79,7 +80,7 @@ xfs_bmbt_to_iomap(
>  	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
>  	iomap->bdev = target->bt_bdev;
>  	iomap->dax_dev = target->bt_daxdev;
> -	iomap->flags = flags;
> +	iomap->flags = iomap_flags;
>  
>  	if (xfs_ipincount(ip) &&
>  	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
> @@ -799,7 +800,7 @@ xfs_direct_write_iomap_begin(
>  
>  	xfs_iunlock(ip, lockmode);
>  	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
> -	return xfs_bmbt_to_iomap(ip, iomap, &imap, iomap_flags);
> +	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, iomap_flags);
>  
>  allocate_blocks:
>  	error = -EAGAIN;
> @@ -830,18 +831,19 @@ xfs_direct_write_iomap_begin(
>  		return error;
>  
>  	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
> -	return xfs_bmbt_to_iomap(ip, iomap, &imap, iomap_flags | IOMAP_F_NEW);
> +	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
> +				 iomap_flags | IOMAP_F_NEW);
>  
>  out_found_cow:
>  	xfs_iunlock(ip, lockmode);
>  	length = XFS_FSB_TO_B(mp, cmap.br_startoff + cmap.br_blockcount);
>  	trace_xfs_iomap_found(ip, offset, length - offset, XFS_COW_FORK, &cmap);
>  	if (imap.br_startblock != HOLESTARTBLOCK) {
> -		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
> +		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0);
>  		if (error)
>  			return error;
>  	}
> -	return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
> +	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, IOMAP_F_SHARED);
>  
>  out_unlock:
>  	if (lockmode)
> @@ -1051,23 +1053,24 @@ xfs_buffered_write_iomap_begin(
>  	 */
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	trace_xfs_iomap_alloc(ip, offset, count, allocfork, &imap);
> -	return xfs_bmbt_to_iomap(ip, iomap, &imap, IOMAP_F_NEW);
> +	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, IOMAP_F_NEW);
>  
>  found_imap:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	return xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
> +	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
>  
>  found_cow:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
>  	if (imap.br_startoff <= offset_fsb) {
> -		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
> +		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, flags, 0);
>  		if (error)
>  			return error;
> -		return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
> +		return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
> +					 IOMAP_F_SHARED);
>  	}
>  
>  	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
> -	return xfs_bmbt_to_iomap(ip, iomap, &cmap, 0);
> +	return xfs_bmbt_to_iomap(ip, iomap, &cmap, flags, 0);
>  
>  out_unlock:
>  	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> @@ -1176,7 +1179,8 @@ xfs_read_iomap_begin(
>  	if (error)
>  		return error;
>  	trace_xfs_iomap_found(ip, offset, length, XFS_DATA_FORK, &imap);
> -	return xfs_bmbt_to_iomap(ip, iomap, &imap, shared ? IOMAP_F_SHARED : 0);
> +	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags,
> +				 shared ? IOMAP_F_SHARED : 0);
>  }
>  
>  const struct iomap_ops xfs_read_iomap_ops = {
> @@ -1235,7 +1239,8 @@ xfs_seek_iomap_begin(
>  		if (data_fsb < cow_fsb + cmap.br_blockcount)
>  			end_fsb = min(end_fsb, data_fsb);
>  		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
> -		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
> +		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, flags,
> +					  IOMAP_F_SHARED);
>  		/*
>  		 * This is a COW extent, so we must probe the page cache
>  		 * because there could be dirty page cache being backed
> @@ -1257,7 +1262,7 @@ xfs_seek_iomap_begin(
>  	imap.br_state = XFS_EXT_NORM;
>  done:
>  	xfs_trim_extent(&imap, offset_fsb, end_fsb);
> -	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
> +	error = xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
>  out_unlock:
>  	xfs_iunlock(ip, lockmode);
>  	return error;
> @@ -1304,7 +1309,7 @@ xfs_xattr_iomap_begin(
>  	if (error)
>  		return error;
>  	ASSERT(nimaps);
> -	return xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
> +	return xfs_bmbt_to_iomap(ip, iomap, &imap, flags, 0);
>  }
>  
>  const struct iomap_ops xfs_xattr_iomap_ops = {
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index f1a281ab9328c..657cc02290f22 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -17,8 +17,9 @@ int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
>  xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
>  		xfs_fileoff_t end_fsb);
>  
> -int xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
> -		struct xfs_bmbt_irec *, u16);
> +int xfs_bmbt_to_iomap(struct xfs_inode *ip, struct iomap *iomap,
> +		struct xfs_bmbt_irec *imap, unsigned int mapping_flags,
> +		u16 iomap_flags);
>  
>  int xfs_zero_range(struct xfs_inode *ip, loff_t pos, loff_t len,
>  		bool *did_zero);
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 5e1d29d8b2e73..7ce1ea11fc3f3 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -173,7 +173,7 @@ xfs_fs_map_blocks(
>  	}
>  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  
> -	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
> +	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0, 0);
>  	*device_generation = mp->m_generation;
>  	return error;
>  out_unlock:
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

