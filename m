Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C03C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 23 Nov 2021 23:06:35 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-4Y-jVvZBOe699QNdwOMaKg-1; Tue, 23 Nov 2021 18:06:30 -0500
X-MC-Unique: 4Y-jVvZBOe699QNdwOMaKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D58611023F4D;
	Tue, 23 Nov 2021 23:06:26 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BC3B157CD3;
	Tue, 23 Nov 2021 23:06:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 6A2704A702;
	Tue, 23 Nov 2021 23:06:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1ANN1UQo026422 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 23 Nov 2021 18:01:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id B758F40CFD0D; Tue, 23 Nov 2021 23:01:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B27FD40CFD04
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:01:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99CF3811E76
	for <dm-devel@redhat.com>; Tue, 23 Nov 2021 23:01:30 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-56-aNZeY7mMPa-58NWAQkeUcw-1; Tue, 23 Nov 2021 18:01:26 -0500
X-MC-Unique: aNZeY7mMPa-58NWAQkeUcw-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA89560F9F;
	Tue, 23 Nov 2021 23:01:24 +0000 (UTC)
Date: Tue, 23 Nov 2021 15:01:24 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211123230124.GR266024@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-24-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211109083309.584081-24-hch@lst.de>
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
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 23/29] xfs: use IOMAP_DAX to check for DAX
	mappings
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
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 09, 2021 at 09:33:03AM +0100, Christoph Hellwig wrote:
> Use the explicit DAX flag instead of checking the inode flag in the
> iomap code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Any particular reason to pass this in as a flag vs. querying the inode?

Doesn't really bother me either way, was just curious.
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 7 ++++---
>  fs/xfs/xfs_iomap.h | 3 ++-
>  fs/xfs/xfs_pnfs.c  | 2 +-
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 604000b6243ec..8cef3b68cba78 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -188,6 +188,7 @@ xfs_iomap_write_direct(
>  	struct xfs_inode	*ip,
>  	xfs_fileoff_t		offset_fsb,
>  	xfs_fileoff_t		count_fsb,
> +	unsigned int		flags,
>  	struct xfs_bmbt_irec	*imap)
>  {
>  	struct xfs_mount	*mp = ip->i_mount;
> @@ -229,7 +230,7 @@ xfs_iomap_write_direct(
>  	 * the reserve block pool for bmbt block allocation if there is no space
>  	 * left but we need to do unwritten extent conversion.
>  	 */
> -	if (IS_DAX(VFS_I(ip))) {
> +	if (flags & IOMAP_DAX) {
>  		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
>  		if (imap->br_state == XFS_EXT_UNWRITTEN) {
>  			force = true;
> @@ -620,7 +621,7 @@ imap_needs_alloc(
>  	    imap->br_startblock == DELAYSTARTBLOCK)
>  		return true;
>  	/* we convert unwritten extents before copying the data for DAX */
> -	if (IS_DAX(inode) && imap->br_state == XFS_EXT_UNWRITTEN)
> +	if ((flags & IOMAP_DAX) && imap->br_state == XFS_EXT_UNWRITTEN)
>  		return true;
>  	return false;
>  }
> @@ -826,7 +827,7 @@ xfs_direct_write_iomap_begin(
>  	xfs_iunlock(ip, lockmode);
>  
>  	error = xfs_iomap_write_direct(ip, offset_fsb, end_fsb - offset_fsb,
> -			&imap);
> +			flags, &imap);
>  	if (error)
>  		return error;
>  
> diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
> index f1a281ab9328c..5648262a71736 100644
> --- a/fs/xfs/xfs_iomap.h
> +++ b/fs/xfs/xfs_iomap.h
> @@ -12,7 +12,8 @@ struct xfs_inode;
>  struct xfs_bmbt_irec;
>  
>  int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
> -		xfs_fileoff_t count_fsb, struct xfs_bmbt_irec *imap);
> +		xfs_fileoff_t count_fsb, unsigned int flags,
> +		struct xfs_bmbt_irec *imap);
>  int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
>  xfs_fileoff_t xfs_iomap_eof_align_last_fsb(struct xfs_inode *ip,
>  		xfs_fileoff_t end_fsb);
> diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
> index 5e1d29d8b2e73..e188e1cf97cc5 100644
> --- a/fs/xfs/xfs_pnfs.c
> +++ b/fs/xfs/xfs_pnfs.c
> @@ -155,7 +155,7 @@ xfs_fs_map_blocks(
>  		xfs_iunlock(ip, lock_flags);
>  
>  		error = xfs_iomap_write_direct(ip, offset_fsb,
> -				end_fsb - offset_fsb, &imap);
> +				end_fsb - offset_fsb, 0, &imap);
>  		if (error)
>  			goto out_unlock;
>  
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

