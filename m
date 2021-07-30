Return-Path: <SRS0=t7n3=MW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE72C4338F
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:55:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8AD4460F94
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jul 2021 13:55:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8AD4460F94
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1627653305;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6vpyNLjHEubqnKXZ7zPXpeZDpLbiDzHKmMY8O5tTfYg=;
	b=ULiChCDizLnoVgrtldx7XjI2tBO0mu5IT9wxcPvLyrrmnug/KFnQOasDEYfyJ9+zGd9S7i
	C5R7UKJyF8V1r2e9+SrZ7oAndnute8cV5gcdpS+HK/z53CwUB3DM/6VjPOKekBex11n+9X
	VUVtGfYSyw5Gq6chh2nMUk0LQrNcKgQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-HLe14Cq7Ol6-ySXUhH04WQ-1; Fri, 30 Jul 2021 09:55:04 -0400
X-MC-Unique: HLe14Cq7Ol6-ySXUhH04WQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 91B081006C86;
	Fri, 30 Jul 2021 13:54:56 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 772AD81F72;
	Fri, 30 Jul 2021 13:54:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4CF634A7C8;
	Fri, 30 Jul 2021 13:54:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16U9Fq34016352 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Jul 2021 05:15:52 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id A691714E79C; Fri, 30 Jul 2021 09:15:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A1D2F14E774
	for <dm-devel@redhat.com>; Fri, 30 Jul 2021 09:15:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF2891857F02
	for <dm-devel@redhat.com>; Fri, 30 Jul 2021 09:15:49 +0000 (UTC)
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
	[209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-576-0M_XCru_OB-b9v6LlfEBWg-1; Fri, 30 Jul 2021 05:15:48 -0400
X-MC-Unique: 0M_XCru_OB-b9v6LlfEBWg-1
Received: by mail-wr1-f71.google.com with SMTP id
	c5-20020a5d52850000b0290126f2836a61so3029002wrv.6
	for <dm-devel@redhat.com>; Fri, 30 Jul 2021 02:15:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20161025;
	h=x-gm-message-state:subject:to:cc:references:from:organization
	:message-id:date:user-agent:mime-version:in-reply-to
	:content-language:content-transfer-encoding;
	bh=2G6YqzVccvwwc7B9va0puf2bDyrJ3NwGJeOcoTuePQc=;
	b=TwfBB3fMQ4SNR7XC9NvMM9aggQVyd+wnEPG7nc6XX696eXe4JITDJhqTvYFd9gaTOx
	KMboGegWysg1VF0DMTA0HtA90sR+R1dqGuwhPP5t+FGJVe++15M1AGSmR24SQyQ6OmIM
	1j5vo4xiL+y/pzkTNyLh9o4ralEikjjiCd2NYoCkc5tRpNI8gYkg/oAxMNl3w/t6sl9p
	Buc3IVaXGV7gGwsO1wMacs2D0S5/Q2eb7Qm/cxzqC6mFDu+2aYy3berXhh0oY3tH5qB3
	Ywvo01S7wXCmrqHCvGZsvVwwjyyRbiHqMZ3Re5Y1Bb29DhkwXsScbAhtiCAglI43Alls
	vsqQ==
X-Gm-Message-State: AOAM530N/kBqCVbpiS/Cb6Tk53B83keM8VpPd1X+8mz2iuna3pARjQcZ
	Lcp1h507nEo7xpe9Wts5Stlca1/HCP+Qirij5W8RR+A1ZY0UCS6zmuZmY5s8iTEwwhcWUr1z7ih
	PMlBIsohuWp4EojU=
X-Received: by 2002:a05:600c:ac4:: with SMTP id
	c4mr1967690wmr.10.1627636547102; 
	Fri, 30 Jul 2021 02:15:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzG+H96dDTWqQcuJ+RbEY9tKITJ8Afuww7GOPOiwc5dZwIDUsqt9sDMj8Sm9FxLdUz+h5MzYQ==
X-Received: by 2002:a05:600c:ac4:: with SMTP id
	c4mr1967663wmr.10.1627636546757; 
	Fri, 30 Jul 2021 02:15:46 -0700 (PDT)
Received: from ?IPv6:2003:d8:2f0a:7f00:fad7:3bc9:69d:31f?
	(p200300d82f0a7f00fad73bc9069d031f.dip0.t-ipconnect.de.
	[2003:d8:2f0a:7f00:fad7:3bc9:69d:31f])
	by smtp.gmail.com with ESMTPSA id
	c204sm1176741wme.15.2021.07.30.02.15.45
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 30 Jul 2021 02:15:46 -0700 (PDT)
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, dm-devel@redhat.com
References: <20210730085245.3069812-1-ruansy.fnst@fujitsu.com>
	<20210730085245.3069812-7-ruansy.fnst@fujitsu.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <f0037d29-9402-6357-ce91-ef6e2e5b7c04@redhat.com>
Date: Fri, 30 Jul 2021 11:15:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
	Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730085245.3069812-7-ruansy.fnst@fujitsu.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 30 Jul 2021 09:53:42 -0400
Cc: snitzer@redhat.com, david@fromorbit.com, djwong@kernel.com,
	dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: Re: [dm-devel] [PATCH v6 6/9] xfs: Implement ->corrupted_range()
	for XFS
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

There is no ocurrence of "corrupted_range" in this patch. Does the patch 
subject need updating?


On 30.07.21 10:52, Shiyang Ruan wrote:
> This function is used to handle errors which may cause data lost in
> filesystem.  Such as memory failure in fsdax mode.
> 
> If the rmap feature of XFS enabled, we can query it to find files and
> metadata which are associated with the corrupt data.  For now all we do
> is kill processes with that file mapped into their address spaces, but
> future patches could actually do something about corrupt metadata.
> 
> After that, the memory failure needs to notify the processes who are
> using those files.
> 
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
> ---
>   drivers/dax/super.c |  12 ++++
>   fs/xfs/xfs_fsops.c  |   5 ++
>   fs/xfs/xfs_mount.h  |   1 +
>   fs/xfs/xfs_super.c  | 135 ++++++++++++++++++++++++++++++++++++++++++++
>   include/linux/dax.h |  13 +++++
>   5 files changed, 166 insertions(+)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 00c32dfa5665..63f7b63d078d 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -65,6 +65,18 @@ struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>   	return dax_get_by_host(bdev->bd_disk->disk_name);
>   }
>   EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
> +
> +void fs_dax_set_holder(struct dax_device *dax_dev, void *holder,
> +		const struct dax_holder_operations *ops)
> +{
> +	dax_set_holder(dax_dev, holder, ops);
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_set_holder);
> +void *fs_dax_get_holder(struct dax_device *dax_dev)
> +{
> +	return dax_get_holder(dax_dev);
> +}
> +EXPORT_SYMBOL_GPL(fs_dax_get_holder);
>   #endif
>   
>   bool __generic_fsdax_supported(struct dax_device *dax_dev,
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 6ed29b158312..e96ddb5c28bc 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -549,6 +549,11 @@ xfs_do_force_shutdown(
>   				flags, __return_address, fname, lnnum);
>   		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
>   			xfs_stack_trace();
> +	} else if (flags & SHUTDOWN_CORRUPT_META) {
> +		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
> +"Corruption of on-disk metadata detected.  Shutting down filesystem");
> +		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
> +			xfs_stack_trace();
>   	} else if (logerror) {
>   		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
>   "Log I/O error (0x%x) detected at %pS (%s:%d). Shutting down filesystem",
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c78b63fe779a..203eb62d16d0 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -277,6 +277,7 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
>   #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
>   #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
>   #define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
> +#define SHUTDOWN_CORRUPT_META	0x0010  /* corrupt metadata on device */
>   
>   /*
>    * Flags for xfs_mountfs
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 2c9e26a44546..4a362e14318d 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -37,11 +37,19 @@
>   #include "xfs_reflink.h"
>   #include "xfs_pwork.h"
>   #include "xfs_ag.h"
> +#include "xfs_alloc.h"
> +#include "xfs_rmap.h"
> +#include "xfs_rmap_btree.h"
> +#include "xfs_rtalloc.h"
> +#include "xfs_bit.h"
>   
>   #include <linux/magic.h>
>   #include <linux/fs_context.h>
>   #include <linux/fs_parser.h>
> +#include <linux/mm.h>
> +#include <linux/dax.h>
>   
> +static const struct dax_holder_operations xfs_dax_holder_operations;
>   static const struct super_operations xfs_super_operations;
>   
>   static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
> @@ -352,6 +360,7 @@ xfs_close_devices(
>   
>   		xfs_free_buftarg(mp->m_logdev_targp);
>   		xfs_blkdev_put(logdev);
> +		fs_dax_set_holder(dax_logdev, NULL, NULL);
>   		fs_put_dax(dax_logdev);
>   	}
>   	if (mp->m_rtdev_targp) {
> @@ -360,9 +369,11 @@ xfs_close_devices(
>   
>   		xfs_free_buftarg(mp->m_rtdev_targp);
>   		xfs_blkdev_put(rtdev);
> +		fs_dax_set_holder(dax_rtdev, NULL, NULL);
>   		fs_put_dax(dax_rtdev);
>   	}
>   	xfs_free_buftarg(mp->m_ddev_targp);
> +	fs_dax_set_holder(dax_ddev, NULL, NULL);
>   	fs_put_dax(dax_ddev);
>   }
>   
> @@ -386,6 +397,7 @@ xfs_open_devices(
>   	struct block_device	*logdev = NULL, *rtdev = NULL;
>   	int			error;
>   
> +	fs_dax_set_holder(dax_ddev, mp, &xfs_dax_holder_operations);
>   	/*
>   	 * Open real time and log devices - order is important.
>   	 */
> @@ -394,6 +406,9 @@ xfs_open_devices(
>   		if (error)
>   			goto out;
>   		dax_logdev = fs_dax_get_by_bdev(logdev);
> +		if (dax_logdev != dax_ddev)
> +			fs_dax_set_holder(dax_logdev, mp,
> +				       &xfs_dax_holder_operations);
>   	}
>   
>   	if (mp->m_rtname) {
> @@ -408,6 +423,7 @@ xfs_open_devices(
>   			goto out_close_rtdev;
>   		}
>   		dax_rtdev = fs_dax_get_by_bdev(rtdev);
> +		fs_dax_set_holder(dax_rtdev, mp, &xfs_dax_holder_operations);
>   	}
>   
>   	/*
> @@ -1070,6 +1086,125 @@ xfs_fs_free_cached_objects(
>   	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
>   }
>   
> +static int
> +xfs_corrupt_helper(
> +	struct xfs_btree_cur		*cur,
> +	struct xfs_rmap_irec		*rec,
> +	void				*data)
> +{
> +	struct xfs_inode		*ip;
> +	struct address_space		*mapping;
> +	int				error = 0, *flags = data, i;
> +
> +	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
> +	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))) {
> +		// TODO check and try to fix metadata
> +		xfs_force_shutdown(cur->bc_mp, SHUTDOWN_CORRUPT_META);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	/* Get files that incore, filter out others that are not in use. */
> +	error = xfs_iget(cur->bc_mp, cur->bc_tp, rec->rm_owner, XFS_IGET_INCORE,
> +			 0, &ip);
> +	if (error)
> +		return error;
> +
> +	mapping = VFS_I(ip)->i_mapping;
> +	if (IS_ENABLED(CONFIG_MEMORY_FAILURE)) {
> +		for (i = 0; i < rec->rm_blockcount; i++) {
> +			error = mf_dax_kill_procs(mapping, rec->rm_offset + i,
> +						  *flags);
> +			if (error)
> +				break;
> +		}
> +	}
> +	// TODO try to fix data
> +	xfs_irele(ip);
> +
> +	return error;
> +}
> +
> +static loff_t
> +xfs_dax_bdev_offset(
> +	struct xfs_mount *mp,
> +	struct dax_device *dax_dev,
> +	loff_t disk_offset)
> +{
> +	struct block_device *bdev;
> +
> +	if (mp->m_ddev_targp->bt_daxdev == dax_dev)
> +		bdev = mp->m_ddev_targp->bt_bdev;
> +	else if (mp->m_logdev_targp->bt_daxdev == dax_dev)
> +		bdev = mp->m_logdev_targp->bt_bdev;
> +	else
> +		bdev = mp->m_rtdev_targp->bt_bdev;
> +
> +	return disk_offset - (get_start_sect(bdev) << SECTOR_SHIFT);
> +}
> +
> +static int
> +xfs_dax_notify_failure(
> +	struct dax_device	*dax_dev,
> +	loff_t			offset,
> +	size_t			len,
> +	void			*data)
> +{
> +	struct xfs_mount	*mp = fs_dax_get_holder(dax_dev);
> +	struct xfs_trans	*tp = NULL;
> +	struct xfs_btree_cur	*cur = NULL;
> +	struct xfs_buf		*agf_bp = NULL;
> +	struct xfs_rmap_irec	rmap_low, rmap_high;
> +	loff_t 			bdev_offset = xfs_dax_bdev_offset(mp, dax_dev,
> +								  offset);
> +	xfs_fsblock_t		fsbno = XFS_B_TO_FSB(mp, bdev_offset);
> +	xfs_filblks_t		bcnt = XFS_B_TO_FSB(mp, len);
> +	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
> +	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
> +	int			error = 0;
> +
> +	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
> +	    mp->m_logdev_targp != mp->m_ddev_targp) {
> +		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_META);
> +		return -EFSCORRUPTED;
> +	}
> +
> +	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
> +		xfs_warn(mp, "notify_failure() needs rmapbt enabled!");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	error = xfs_trans_alloc_empty(mp, &tp);
> +	if (error)
> +		return error;
> +
> +	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
> +	if (error)
> +		goto out_cancel_tp;
> +
> +	cur = xfs_rmapbt_init_cursor(mp, tp, agf_bp, agf_bp->b_pag);
> +
> +	/* Construct a range for rmap query */
> +	memset(&rmap_low, 0, sizeof(rmap_low));
> +	memset(&rmap_high, 0xFF, sizeof(rmap_high));
> +	rmap_low.rm_startblock = rmap_high.rm_startblock = agbno;
> +	rmap_low.rm_blockcount = rmap_high.rm_blockcount = bcnt;
> +
> +	error = xfs_rmap_query_range(cur, &rmap_low, &rmap_high,
> +				     xfs_corrupt_helper, data);
> +
> +	xfs_btree_del_cursor(cur, error);
> +	xfs_trans_brelse(tp, agf_bp);
> +
> +out_cancel_tp:
> +	xfs_trans_cancel(tp);
> +	return error;
> +}
> +
> +static const struct dax_holder_operations xfs_dax_holder_operations = {
> +	.notify_failure = xfs_dax_notify_failure,
> +};
> +
>   static const struct super_operations xfs_super_operations = {
>   	.alloc_inode		= xfs_fs_alloc_inode,
>   	.destroy_inode		= xfs_fs_destroy_inode,
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 359e809516b8..c8a188b76031 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -160,6 +160,9 @@ static inline void fs_put_dax(struct dax_device *dax_dev)
>   }
>   
>   struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev);
> +void fs_dax_set_holder(struct dax_device *dax_dev, void *holder,
> +		const struct dax_holder_operations *ops);
> +void *fs_dax_get_holder(struct dax_device *dax_dev);
>   int dax_writeback_mapping_range(struct address_space *mapping,
>   		struct dax_device *dax_dev, struct writeback_control *wbc);
>   
> @@ -191,6 +194,16 @@ static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
>   	return NULL;
>   }
>   
> +static inline void fs_dax_set_holder(struct dax_device *dax_dev, void *holder,
> +		const struct dax_holder_operations *ops)
> +{
> +}
> +
> +static inline void *fs_dax_get_holder(struct dax_device *dax_dev)
> +{
> +	return NULL;
> +}
> +
>   static inline struct page *dax_layout_busy_page(struct address_space *mapping)
>   {
>   	return NULL;
> 


-- 
Thanks,

David / dhildenb

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

