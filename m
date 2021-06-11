Return-Path: <SRS0=xPb5=LF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F8D5C48BE0
	for <dm-devel@archiver.kernel.org>; Fri, 11 Jun 2021 20:39:31 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F2B2D6128A
	for <dm-devel@archiver.kernel.org>; Fri, 11 Jun 2021 20:39:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2B2D6128A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-q9r6B7urOTGdXuKG2CSgnA-1; Fri, 11 Jun 2021 16:39:27 -0400
X-MC-Unique: q9r6B7urOTGdXuKG2CSgnA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F5DE107ACF6;
	Fri, 11 Jun 2021 20:39:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A48DD6091A;
	Fri, 11 Jun 2021 20:39:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A806F1809CAD;
	Fri, 11 Jun 2021 20:39:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15BKdK9c007831 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 11 Jun 2021 16:39:20 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E3FA420877CE; Fri, 11 Jun 2021 20:39:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DFADA21115F4
	for <dm-devel@redhat.com>; Fri, 11 Jun 2021 20:39:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFF8B1825067
	for <dm-devel@redhat.com>; Fri, 11 Jun 2021 20:39:16 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-278-DK_ynrR-NQyT-5R1lY2Dzg-1; Fri, 11 Jun 2021 16:39:12 -0400
X-MC-Unique: DK_ynrR-NQyT-5R1lY2Dzg-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C2CA1FD7B;
	Fri, 11 Jun 2021 20:39:10 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id 1A1CE118DD;
	Fri, 11 Jun 2021 20:39:10 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id OLr5BO7Jw2BGEgAALh3uQQ
	(envelope-from <mwilck@suse.com>); Fri, 11 Jun 2021 20:39:10 +0000
From: mwilck@suse.com
To: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
	Bart Van Assche <Bart.VanAssche@sandisk.com>, dm-devel@redhat.com,
	Hannes Reinecke <hare@suse.de>
Date: Fri, 11 Jun 2021 22:25:09 +0200
Message-Id: <20210611202509.5426-3-mwilck@suse.com>
In-Reply-To: <20210611202509.5426-1-mwilck@suse.com>
References: <20210611202509.5426-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15BKdK9c007831
X-loop: dm-devel@redhat.com
Cc: Daniel Wagner <dwagner@suse.de>, Martin Wilck <mwilck@suse.com>,
	linux-block@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [PATCH v3 2/2] dm: add CONFIG_DM_MULTIPATH_SG_IO -
	failover for SG_IO on dm-multipath
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

In virtual deployments, SCSI passthrough over dm-multipath devices is a
common setup. The qemu "pr-helper" was specifically invented for it. I
believe that this is the most important real-world scenario for sending
SG_IO ioctls to device-mapper devices.

In this configuration, guests send SCSI IO to the hypervisor in the form of
SG_IO ioctls issued by qemu. But on the device-mapper level, these SCSI
ioctls aren't treated like regular IO. Until commit 2361ae595352 ("dm mpath:
switch paths in dm_blk_ioctl() code path"), no path switching was done at
all. Worse though, if an SG_IO call fails because of a path error,
dm-multipath doesn't retry the IO on a another path; rather, the failure is
passed back to the guest, and paths are not marked as faulty.  This is in
stark contrast with regular block IO of guests on dm-multipath devices, and
certainly comes as a surprise to users who switch to SCSI passthrough in
qemu. In general, users of dm-multipath devices would probably expect failover
to work at least in a basic way.

This patch fixes this by taking a special code path for SG_IO on request-
based device mapper targets if CONFIG_DM_MULTIPATH_SG_IO is set.  Rather then
just choosing a single path, sending the IO to it, and failing to the caller
if the IO on the path failed, it retries the same IO on another path for
certain error codes, using blk_path_error() to determine if a retry would
make sense for the given error code. Moreover, it sends a message to the
multipath target to mark the path as failed.

One problem remains open: if all paths in a multipath map are failed,
normal multipath IO may switch to queueing mode (depending on
configuration). This isn't possible for SG_IO, as SG_IO requests can't
easily be queued like regular block I/O. Thus in the "no path" case, the
guest will still see an error.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 block/scsi_ioctl.c         |   5 +-
 drivers/md/Kconfig         |  11 ++++
 drivers/md/Makefile        |   4 ++
 drivers/md/dm-core.h       |   5 ++
 drivers/md/dm-rq.h         |  11 ++++
 drivers/md/dm-scsi_ioctl.c | 127 +++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c            |  20 +++++-
 include/linux/blkdev.h     |   2 +
 8 files changed, 180 insertions(+), 5 deletions(-)
 create mode 100644 drivers/md/dm-scsi_ioctl.c

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index b39e0835600f..38771f4bcf18 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -279,8 +279,8 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	return ret;
 }
 
-static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
-		struct sg_io_hdr *hdr, fmode_t mode)
+int sg_io(struct request_queue *q, struct gendisk *bd_disk,
+	  struct sg_io_hdr *hdr, fmode_t mode)
 {
 	unsigned long start_time;
 	ssize_t ret = 0;
@@ -365,6 +365,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	blk_put_request(rq);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sg_io);
 
 /**
  * sg_scsi_ioctl  --  handle deprecated SCSI_IOCTL_SEND_COMMAND ioctl
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index f2014385d48b..f28f29e3bd11 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -473,6 +473,17 @@ config DM_MULTIPATH_IOA
 
 	  If unsure, say N.
 
+config DM_MULTIPATH_SG_IO
+       bool "Retry SCSI generic I/O on multipath devices"
+       depends on DM_MULTIPATH && BLK_SCSI_REQUEST
+       help
+	 With this option, SCSI generic (SG) requests issued on multipath
+	 devices will behave similar to regular block I/O: upon failure,
+	 they are repeated on a different path, and the erroring device
+	 is marked as failed.
+
+	 If unsure, say N.
+
 config DM_DELAY
 	tristate "I/O delaying target"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index ef7ddc27685c..187ea469f64a 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -88,6 +88,10 @@ ifeq ($(CONFIG_DM_INIT),y)
 dm-mod-objs			+= dm-init.o
 endif
 
+ifeq ($(CONFIG_DM_MULTIPATH_SG_IO),y)
+dm-mod-objs			+= dm-scsi_ioctl.o
+endif
+
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
 endif
diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 5953ff2bd260..8bd8a8e3916e 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -189,4 +189,9 @@ extern atomic_t dm_global_event_nr;
 extern wait_queue_head_t dm_global_eventq;
 void dm_issue_global_event(void);
 
+int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
+		       struct block_device **bdev,
+		       struct dm_target **target);
+void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx);
+
 #endif
diff --git a/drivers/md/dm-rq.h b/drivers/md/dm-rq.h
index 1eea0da641db..c6d2853e4d1d 100644
--- a/drivers/md/dm-rq.h
+++ b/drivers/md/dm-rq.h
@@ -44,4 +44,15 @@ ssize_t dm_attr_rq_based_seq_io_merge_deadline_show(struct mapped_device *md, ch
 ssize_t dm_attr_rq_based_seq_io_merge_deadline_store(struct mapped_device *md,
 						     const char *buf, size_t count);
 
+#ifdef CONFIG_DM_MULTIPATH_SG_IO
+int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
+		   unsigned int cmd, unsigned long uarg);
+#else
+static inline int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
+				 unsigned int cmd, unsigned long uarg)
+{
+	return -ENOTTY;
+}
+#endif
+
 #endif
diff --git a/drivers/md/dm-scsi_ioctl.c b/drivers/md/dm-scsi_ioctl.c
new file mode 100644
index 000000000000..a696e2a6557e
--- /dev/null
+++ b/drivers/md/dm-scsi_ioctl.c
@@ -0,0 +1,127 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2021 Martin Wilck, SUSE LLC
+ */
+
+#include "dm-core.h"
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/kernel.h>
+#include <linux/uaccess.h>
+#include <linux/blk_types.h>
+#include <linux/blkdev.h>
+#include <linux/device-mapper.h>
+#include <scsi/sg.h>
+#include <scsi/scsi_cmnd.h>
+
+#define DM_MSG_PREFIX "sg_io"
+
+int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
+		   unsigned int cmd, unsigned long uarg)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	struct sg_io_hdr hdr;
+	void __user *arg = (void __user *)uarg;
+	int rc, srcu_idx;
+	char path_name[BDEVNAME_SIZE];
+
+	if (cmd != SG_IO)
+		return -ENOTTY;
+
+	if (copy_from_user(&hdr, arg, sizeof(hdr)))
+		return -EFAULT;
+
+	if (hdr.interface_id != 'S')
+		return -EINVAL;
+
+	if (hdr.dxfer_len > (queue_max_hw_sectors(bdev->bd_disk->queue) << 9))
+		return -EIO;
+
+	for (;;) {
+		struct dm_target *tgt;
+		struct sg_io_hdr rhdr;
+
+		rc = __dm_prepare_ioctl(md, &srcu_idx, &bdev, &tgt);
+		if (rc < 0) {
+			DMERR("%s: failed to get path: %d",
+			      __func__, rc);
+			goto out;
+		}
+
+		rhdr = hdr;
+
+		rc = sg_io(bdev->bd_disk->queue, bdev->bd_disk, &rhdr, mode);
+
+		DMDEBUG("SG_IO via %s: rc = %d D%02xH%02xM%02xS%02x",
+			bdevname(bdev, path_name), rc,
+			rhdr.driver_status, rhdr.host_status,
+			rhdr.msg_status, rhdr.status);
+
+		/*
+		 * Errors resulting from invalid parameters shouldn't be retried
+		 * on another path.
+		 */
+		switch (rc) {
+		case -ENOIOCTLCMD:
+		case -EFAULT:
+		case -EINVAL:
+		case -EPERM:
+			goto out;
+		default:
+			break;
+		}
+
+		if (rhdr.info & SG_INFO_CHECK) {
+			int result;
+			blk_status_t sts;
+
+			result = rhdr.status |
+				(rhdr.msg_status << 8) |
+				(rhdr.host_status << 16) |
+				(rhdr.driver_status << 24);
+
+			sts = __scsi_result_to_blk_status(&result, result);
+			rhdr.host_status = host_byte(result);
+
+			/* See if this is a target or path error. */
+			if (sts == BLK_STS_OK)
+				rc = 0;
+			else if (blk_path_error(sts))
+				rc = -EIO;
+			else {
+				rc = blk_status_to_errno(sts);
+				goto out;
+			}
+		}
+
+		if (rc == 0) {
+			/* success */
+			if (copy_to_user(arg, &rhdr, sizeof(rhdr)))
+				rc = -EFAULT;
+			goto out;
+		}
+
+		/* Failure - fail path by sending a message to the target */
+		if (!tgt->type->message) {
+			DMWARN("invalid target!");
+			rc = -EIO;
+			goto out;
+		} else {
+			char bdbuf[BDEVT_SIZE];
+			char *argv[2] = { "fail_path", bdbuf };
+
+			scnprintf(bdbuf, sizeof(bdbuf), "%u:%u",
+				  MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
+
+			DMDEBUG("sending \"%s %s\" to target", argv[0], argv[1]);
+			rc = tgt->type->message(tgt, 2, argv, NULL, 0);
+			if (rc < 0)
+				goto out;
+		}
+
+		dm_unprepare_ioctl(md, srcu_idx);
+	}
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return rc;
+}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca2aedd8ee7d..29b93fb3929e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -522,8 +522,9 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 #define dm_blk_report_zones		NULL
 #endif /* CONFIG_BLK_DEV_ZONED */
 
-static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
-			    struct block_device **bdev)
+int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
+		       struct block_device **bdev,
+		       struct dm_target **target)
 {
 	struct dm_target *tgt;
 	struct dm_table *map;
@@ -553,10 +554,19 @@ static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 		goto retry;
 	}
 
+	if (r >= 0 && target)
+		*target = tgt;
+
 	return r;
 }
 
-static void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
+static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
+			    struct block_device **bdev)
+{
+	return __dm_prepare_ioctl(md, srcu_idx, bdev, NULL);
+}
+
+void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
 {
 	dm_put_live_table(md, srcu_idx);
 }
@@ -567,6 +577,10 @@ static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	int r, srcu_idx;
 
+	if ((dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) &&
+	    ((r = dm_sg_io_ioctl(bdev, mode, cmd, arg)) != -ENOTTY))
+		return r;
+
 	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
 	if (r < 0)
 		goto out;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 48497a77428d..b8f1d603cc7a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -923,6 +923,8 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			  unsigned int, void __user *);
 extern int sg_scsi_ioctl(struct request_queue *, struct gendisk *, fmode_t,
 			 struct scsi_ioctl_command __user *);
+extern int sg_io(struct request_queue *, struct gendisk *,
+		 struct sg_io_hdr *, fmode_t);
 extern int get_sg_io_hdr(struct sg_io_hdr *hdr, const void __user *argp);
 extern int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp);
 
-- 
2.31.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

