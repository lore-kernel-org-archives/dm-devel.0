Return-Path: <SRS0=MR+g=QE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFAE7C433F5
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 17:31:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 70B3661C4F
	for <dm-devel@archiver.kernel.org>; Wed, 17 Nov 2021 17:31:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 70B3661C4F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-200-e2S4bCodOoi8uoIF8_mudA-1; Wed, 17 Nov 2021 12:31:44 -0500
X-MC-Unique: e2S4bCodOoi8uoIF8_mudA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B58E10055A7;
	Wed, 17 Nov 2021 17:31:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0DD685D9DE;
	Wed, 17 Nov 2021 17:31:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 715184E58F;
	Wed, 17 Nov 2021 17:31:39 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AHHVadN001138 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 17 Nov 2021 12:31:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CA2591121319; Wed, 17 Nov 2021 17:31:36 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C58431121315
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 17:31:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F68A800141
	for <dm-devel@redhat.com>; Wed, 17 Nov 2021 17:31:14 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-225-SXD-DtLTNQCgRwfiAOjEXg-1; Wed, 17 Nov 2021 12:31:12 -0500
X-MC-Unique: SXD-DtLTNQCgRwfiAOjEXg-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A92261B9F;
	Wed, 17 Nov 2021 17:31:11 +0000 (UTC)
Date: Wed, 17 Nov 2021 09:31:11 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20211117173111.GZ24307@magnolia>
References: <20211109083309.584081-1-hch@lst.de>
	<20211109083309.584081-8-hch@lst.de>
MIME-Version: 1.0
In-Reply-To: <20211109083309.584081-8-hch@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: nvdimm@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
	linux-s390@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	virtualization@lists.linux-foundation.org,
	linux-xfs@vger.kernel.org, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
	linux-ext4@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [dm-devel] [PATCH 07/29] xfs: factor out a xfs_setup_dax_always
	helper
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Tue, Nov 09, 2021 at 09:32:47AM +0100, Christoph Hellwig wrote:
> Factor out another DAX setup helper to simplify future changes.  Also
> move the experimental warning after the checks to not clutter the log
> too much if the setup failed.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_super.c | 47 +++++++++++++++++++++++++++-------------------
>  1 file changed, 28 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index e21459f9923a8..875fd3151d6c9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -340,6 +340,32 @@ xfs_buftarg_is_dax(
>  			bdev_nr_sectors(bt->bt_bdev));
>  }
>  
> +static int
> +xfs_setup_dax_always(
> +	struct xfs_mount	*mp)
> +{
> +	struct super_block	*sb = mp->m_super;
> +
> +	if (!xfs_buftarg_is_dax(sb, mp->m_ddev_targp) &&
> +	   (!mp->m_rtdev_targp || !xfs_buftarg_is_dax(sb, mp->m_rtdev_targp))) {
> +		xfs_alert(mp,
> +			"DAX unsupported by block device. Turning off DAX.");
> +		goto disable_dax;
> +	}
> +
> +	if (xfs_has_reflink(mp)) {
> +		xfs_alert(mp, "DAX and reflink cannot be used together!");
> +		return -EINVAL;
> +	}
> +
> +	xfs_warn(mp, "DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
> +	return 0;
> +
> +disable_dax:
> +	xfs_mount_set_dax_mode(mp, XFS_DAX_NEVER);
> +	return 0;
> +}
> +
>  STATIC int
>  xfs_blkdev_get(
>  	xfs_mount_t		*mp,
> @@ -1593,26 +1619,9 @@ xfs_fs_fill_super(
>  		sb->s_flags |= SB_I_VERSION;
>  
>  	if (xfs_has_dax_always(mp)) {
> -		bool rtdev_is_dax = false, datadev_is_dax;
> -
> -		xfs_warn(mp,
> -		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
> -
> -		datadev_is_dax = xfs_buftarg_is_dax(sb, mp->m_ddev_targp);
> -		if (mp->m_rtdev_targp)
> -			rtdev_is_dax = xfs_buftarg_is_dax(sb,
> -						mp->m_rtdev_targp);
> -		if (!rtdev_is_dax && !datadev_is_dax) {
> -			xfs_alert(mp,
> -			"DAX unsupported by block device. Turning off DAX.");
> -			xfs_mount_set_dax_mode(mp, XFS_DAX_NEVER);
> -		}
> -		if (xfs_has_reflink(mp)) {
> -			xfs_alert(mp,
> -		"DAX and reflink cannot be used together!");
> -			error = -EINVAL;
> +		error = xfs_setup_dax_always(mp);
> +		if (error)
>  			goto out_filestream_unmount;
> -		}
>  	}
>  
>  	if (xfs_has_discard(mp)) {
> -- 
> 2.30.2
> 

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

