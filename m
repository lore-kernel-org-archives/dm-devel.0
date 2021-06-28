Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE60C2B9F4
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C5AE661C5B
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5AE661C5B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fujitsu.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-DX8wn1uoO42aNihvRZ1OgQ-1; Mon, 28 Jun 2021 05:53:02 -0400
X-MC-Unique: DX8wn1uoO42aNihvRZ1OgQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03616100C675;
	Mon, 28 Jun 2021 09:52:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D28B310074FD;
	Mon, 28 Jun 2021 09:52:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A5C371809CB5;
	Mon, 28 Jun 2021 09:52:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15S03Sq3027093 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 27 Jun 2021 20:03:29 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BFD304367C; Mon, 28 Jun 2021 00:03:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA4C5814B
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FC4E800963
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 00:03:28 +0000 (UTC)
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by relay.mimecast.com with ESMTP id us-mta-88-S6uNGItiNxO8q0V5MvUGtw-2; 
	Sun, 27 Jun 2021 20:03:23 -0400
X-MC-Unique: S6uNGItiNxO8q0V5MvUGtw-2
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3A7bW5/Kg1IWmdQNXuSnzQlSwH3XBQXuYji2hC?=
	=?us-ascii?q?6mlwRA09TyX4rbHLoB1/73LJYVkqNk3I5urrBEDtexLhHP1OkOws1NWZLWrbUQ?=
	=?us-ascii?q?KTRekM0WKI+UyDJ8SRzI5g/JYlW61/Jfm1NlJikPv9iTPSL/8QhPWB74Ck7N2z?=
	=?us-ascii?q?80tQ?=
X-IronPort-AV: E=Sophos;i="5.83,304,1616428800"; d="scan'208";a="110256386"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
	by heian.cn.fujitsu.com with ESMTP; 28 Jun 2021 08:03:21 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 545984D0C4C1;
	Mon, 28 Jun 2021 08:03:21 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
	G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 28 Jun 2021 08:03:11 +0800
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
	G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP
	Server (TLS) id 15.0.1497.2; Mon, 28 Jun 2021 08:03:11 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
	G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP
	Server
	id 15.0.1497.2 via Frontend Transport; Mon, 28 Jun 2021 08:03:11 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>, <dm-devel@redhat.com>
Date: Mon, 28 Jun 2021 08:02:15 +0800
Message-ID: <20210628000218.387833-7-ruansy.fnst@fujitsu.com>
In-Reply-To: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
References: <20210628000218.387833-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
X-yoursite-MailScanner-ID: 545984D0C4C1.AFA98
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 28 Jun 2021 05:52:34 -0400
Cc: snitzer@redhat.com, darrick.wong@oracle.com, rgoldwyn@suse.de,
	david@fromorbit.com, dan.j.williams@intel.com, hch@lst.de, agk@redhat.com
Subject: [dm-devel] [PATCH v5 6/9] xfs: Implement ->corrupted_range() for XFS
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This function is used to handle errors which may cause data lost in
filesystem.  Such as memory failure in fsdax mode.

If the rmap feature of XFS enabled, we can query it to find files and
metadata which are associated with the corrupt data.  For now all we do
is kill processes with that file mapped into their address spaces, but
future patches could actually do something about corrupt metadata.

After that, the memory failure needs to notify the processes who are
using those files.

Only support data device.  Realtime device is not supported for now.

Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
---
 fs/xfs/xfs_fsops.c |   5 ++
 fs/xfs/xfs_mount.h |   1 +
 fs/xfs/xfs_super.c | 140 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 146 insertions(+)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index be9cf88d2ad7..e89ada33d8fc 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -551,6 +551,11 @@ xfs_do_force_shutdown(
 "Corruption of in-memory data detected.  Shutting down filesystem");
 		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
 			xfs_stack_trace();
+	} else if (flags & SHUTDOWN_CORRUPT_META) {
+		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
+"Corruption of on-disk metadata detected.  Shutting down filesystem");
+		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
+			xfs_stack_trace();
 	} else if (logerror) {
 		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
 			"Log I/O Error Detected. Shutting down filesystem");
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bb67274ee23f..c62ccf3e07d0 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -276,6 +276,7 @@ void xfs_do_force_shutdown(struct xfs_mount *mp, int flags, char *fname,
 #define SHUTDOWN_LOG_IO_ERROR	0x0002	/* write attempt to the log failed */
 #define SHUTDOWN_FORCE_UMOUNT	0x0004	/* shutdown from a forced unmount */
 #define SHUTDOWN_CORRUPT_INCORE	0x0008	/* corrupt in-memory data structures */
+#define SHUTDOWN_CORRUPT_META	0x0010  /* corrupt metadata on device */

 /*
  * Flags for xfs_mountfs
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a2dab05332ac..a986ddf3b248 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -36,11 +36,18 @@
 #include "xfs_bmap_item.h"
 #include "xfs_reflink.h"
 #include "xfs_pwork.h"
+#include "xfs_alloc.h"
+#include "xfs_rmap.h"
+#include "xfs_rmap_btree.h"
+#include "xfs_rtalloc.h"
+#include "xfs_bit.h"

 #include <linux/magic.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
+#include <linux/mm.h>

+static const struct dax_holder_operations xfs_dax_holder_operations;
 static const struct super_operations xfs_super_operations;

 static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
@@ -358,6 +365,7 @@ xfs_close_devices(

 		xfs_free_buftarg(mp->m_logdev_targp);
 		xfs_blkdev_put(logdev);
+		dax_set_holder(dax_logdev, NULL, NULL);
 		fs_put_dax(dax_logdev);
 	}
 	if (mp->m_rtdev_targp) {
@@ -366,9 +374,11 @@ xfs_close_devices(

 		xfs_free_buftarg(mp->m_rtdev_targp);
 		xfs_blkdev_put(rtdev);
+		dax_set_holder(dax_rtdev, NULL, NULL);
 		fs_put_dax(dax_rtdev);
 	}
 	xfs_free_buftarg(mp->m_ddev_targp);
+	dax_set_holder(dax_ddev, NULL, NULL);
 	fs_put_dax(dax_ddev);
 }

@@ -392,6 +402,7 @@ xfs_open_devices(
 	struct block_device	*logdev = NULL, *rtdev = NULL;
 	int			error;

+	dax_set_holder(dax_ddev, mp, &xfs_dax_holder_operations);
 	/*
 	 * Open real time and log devices - order is important.
 	 */
@@ -400,6 +411,9 @@ xfs_open_devices(
 		if (error)
 			goto out;
 		dax_logdev = fs_dax_get_by_bdev(logdev);
+		if (dax_logdev != dax_ddev)
+			dax_set_holder(dax_logdev, mp,
+				       &xfs_dax_holder_operations);
 	}

 	if (mp->m_rtname) {
@@ -414,6 +428,7 @@ xfs_open_devices(
 			goto out_close_rtdev;
 		}
 		dax_rtdev = fs_dax_get_by_bdev(rtdev);
+		dax_set_holder(dax_rtdev, mp, &xfs_dax_holder_operations);
 	}

 	/*
@@ -1076,6 +1091,131 @@ xfs_fs_free_cached_objects(
 	return xfs_reclaim_inodes_nr(XFS_M(sb), sc->nr_to_scan);
 }

+static int
+xfs_corrupt_helper(
+	struct xfs_btree_cur		*cur,
+	struct xfs_rmap_irec		*rec,
+	void				*data)
+{
+	struct xfs_inode		*ip;
+	struct address_space		*mapping;
+	int				error = 0;
+	int				*flags = data;
+
+	if (XFS_RMAP_NON_INODE_OWNER(rec->rm_owner) ||
+	    (rec->rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK))) {
+		// TODO check and try to fix metadata
+		xfs_force_shutdown(cur->bc_mp, SHUTDOWN_CORRUPT_META);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Get files that incore, filter out others that are not in use.
+	 */
+	error = xfs_iget(cur->bc_mp, cur->bc_tp, rec->rm_owner, XFS_IGET_INCORE,
+			0, &ip);
+	if (error)
+		return error;
+
+	mapping = VFS_I(ip)->i_mapping;
+
+#ifdef CONFIG_MEMORY_FAILURE
+	error = mf_dax_kill_procs(mapping, rec->rm_offset, *flags);
+#endif
+
+	// TODO try to fix data
+	xfs_irele(ip);
+
+	return error;
+}
+
+static loff_t
+xfs_dax_bdev_offset(
+	struct xfs_mount *mp,
+	struct dax_device *dax_dev,
+	loff_t disk_offset)
+{
+	struct block_device *bdev;
+
+	if (mp->m_ddev_targp->bt_daxdev == dax_dev)
+		bdev = mp->m_ddev_targp->bt_bdev;
+	else if (mp->m_logdev_targp->bt_daxdev == dax_dev)
+		bdev = mp->m_logdev_targp->bt_bdev;
+	else
+		bdev = mp->m_rtdev_targp->bt_bdev;
+
+	return disk_offset - (get_start_sect(bdev) << SECTOR_SHIFT);
+}
+
+static int
+xfs_dax_notify_failure(
+	struct dax_device	*dax_dev,
+	loff_t			offset,
+	size_t			len,
+	void			*data)
+{
+	struct xfs_mount	*mp = dax_get_holder(dax_dev);
+	struct xfs_trans	*tp = NULL;
+	struct xfs_btree_cur	*cur = NULL;
+	struct xfs_buf		*agf_bp = NULL;
+	struct xfs_rmap_irec	rmap_low, rmap_high;
+	loff_t 			bdev_offset = xfs_dax_bdev_offset(mp, dax_dev,
+								  offset);
+	xfs_fsblock_t		fsbno = XFS_B_TO_FSB(mp, bdev_offset);
+	xfs_filblks_t		bcnt = XFS_B_TO_FSB(mp, len);
+	xfs_agnumber_t		agno = XFS_FSB_TO_AGNO(mp, fsbno);
+	xfs_agblock_t		agbno = XFS_FSB_TO_AGBNO(mp, fsbno);
+	int			error = 0;
+
+	pr_warn("%s bno: %lld\n", __func__, bdev_offset >> SECTOR_SHIFT);
+
+	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev) {
+		xfs_warn(mp, "corrupted_range support not available for realtime device!");
+		return -EOPNOTSUPP;
+	}
+	if (mp->m_logdev_targp && mp->m_logdev_targp->bt_daxdev == dax_dev &&
+	    mp->m_logdev_targp != mp->m_ddev_targp) {
+		xfs_err(mp, "ondisk log corrupt, shutting down fs!");
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_META);
+		return -EFSCORRUPTED;
+	}
+
+	if (!xfs_sb_version_hasrmapbt(&mp->m_sb)) {
+		xfs_warn(mp, "corrupted_range needs rmapbt enabled!");
+		return -EOPNOTSUPP;
+	}
+
+	error = xfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	error = xfs_alloc_read_agf(mp, tp, agno, 0, &agf_bp);
+	if (error)
+		goto out_cancel_tp;
+
+	cur = xfs_rmapbt_init_cursor(mp, tp, agf_bp, agno);
+
+	/* Construct a range for rmap query */
+	memset(&rmap_low, 0, sizeof(rmap_low));
+	memset(&rmap_high, 0xFF, sizeof(rmap_high));
+	rmap_low.rm_startblock = rmap_high.rm_startblock = agbno;
+	rmap_low.rm_blockcount = rmap_high.rm_blockcount = bcnt;
+
+	error = xfs_rmap_query_range(cur, &rmap_low, &rmap_high,
+				     xfs_corrupt_helper, data);
+
+	xfs_btree_del_cursor(cur, error);
+	xfs_trans_brelse(tp, agf_bp);
+
+out_cancel_tp:
+	xfs_trans_cancel(tp);
+	return error;
+}
+
+static const struct dax_holder_operations xfs_dax_holder_operations = {
+	.notify_failure = xfs_dax_notify_failure,
+};
+
 static const struct super_operations xfs_super_operations = {
 	.alloc_inode		= xfs_fs_alloc_inode,
 	.destroy_inode		= xfs_fs_destroy_inode,
--
2.32.0



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

