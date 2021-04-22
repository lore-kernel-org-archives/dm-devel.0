Return-Path: <SRS0=6Nrr=JT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF55C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 20:22:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1DB936137D
	for <dm-devel@archiver.kernel.org>; Thu, 22 Apr 2021 20:22:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1DB936137D
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-L3G-mVdrMcC4et_gxoyc8A-1; Thu, 22 Apr 2021 16:22:26 -0400
X-MC-Unique: L3G-mVdrMcC4et_gxoyc8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51A82343A2;
	Thu, 22 Apr 2021 20:22:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DDCF260BE5;
	Thu, 22 Apr 2021 20:22:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B8CB91806D0F;
	Thu, 22 Apr 2021 20:22:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13MKMBaj031644 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 22 Apr 2021 16:22:11 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1BEE720962C6; Thu, 22 Apr 2021 20:22:11 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 16AC220962C1
	for <dm-devel@redhat.com>; Thu, 22 Apr 2021 20:22:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B074A28807
	for <dm-devel@redhat.com>; Thu, 22 Apr 2021 20:22:08 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-414-ZIz-A_qsOo-lG38SKRt8Dg-1;
	Thu, 22 Apr 2021 16:22:01 -0400
X-MC-Unique: ZIz-A_qsOo-lG38SKRt8Dg-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id EE9AAAF98;
	Thu, 22 Apr 2021 20:21:59 +0000 (UTC)
From: mwilck@suse.com
To: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
	dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>
Date: Thu, 22 Apr 2021 22:21:30 +0200
Message-Id: <20210422202130.30906-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13MKMBaj031644
X-loop: dm-devel@redhat.com
Cc: Daniel Wagner <dwagner@suse.de>, Martin Wilck <mwilck@suse.com>,
	linux-block@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [PATCH] dm: dm_blk_ioctl(): implement failover for SG_IO
	on dm-multipath
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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
based device mapper targets. Rather then just choosing a single path,
sending the IO to it, and failing to the caller if the IO on the path
failed, it retries the same IO on another path for certain error codes,
using the same logic as blk_path_error() to determine if a retry would make
sense for the given error code. Moreover, it sends a message to the
multipath target to mark the path as failed.

I am aware that this looks sort of hack-ish. I'm submitting it here as an
RFC, asking for guidance how to reach a clean implementation that would be
acceptable in mainline. I believe that it fixes an important problem.
Actually, it fixes the qemu SCSI-passthrough use case on dm-multipath,
which is non-functional without it.

One problem remains open: if all paths in a multipath map are failed,
normal multipath IO may switch to queueing mode (depending on
configuration). This isn't possible for SG_IO, as SG_IO requests can't
easily be queued like regular block I/O. Thus in the "no path" case, the
guest will still see an error. If anybody can conceive of a solution for
that, I'd be interested.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 block/scsi_ioctl.c     |   5 +-
 drivers/md/dm.c        | 134 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/blkdev.h |   2 +
 3 files changed, 137 insertions(+), 4 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 6599bac0a78c..bcc60552f7b1 100644
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
@@ -369,6 +369,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 	blk_put_request(rq);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sg_io);
 
 /**
  * sg_scsi_ioctl  --  handle deprecated SCSI_IOCTL_SEND_COMMAND ioctl
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 50b693d776d6..443ac5e5406c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -29,6 +29,8 @@
 #include <linux/part_stat.h>
 #include <linux/blk-crypto.h>
 #include <linux/keyslot-manager.h>
+#include <scsi/sg.h>
+#include <scsi/scsi.h>
 
 #define DM_MSG_PREFIX "core"
 
@@ -522,8 +524,9 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 #define dm_blk_report_zones		NULL
 #endif /* CONFIG_BLK_DEV_ZONED */
 
-static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
-			    struct block_device **bdev)
+static int _dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
+			     struct block_device **bdev,
+			     struct dm_target **target)
 {
 	struct dm_target *tgt;
 	struct dm_table *map;
@@ -553,20 +556,147 @@ static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 		goto retry;
 	}
 
+	if (r >= 0 && target)
+		*target = tgt;
+
 	return r;
 }
 
+static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
+			    struct block_device **bdev)
+{
+	return _dm_prepare_ioctl(md, srcu_idx, bdev, NULL);
+}
+
 static void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
 {
 	dm_put_live_table(md, srcu_idx);
 }
 
+static int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
+			  void __user *arg)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	struct sg_io_hdr hdr;
+	int rc, srcu_idx;
+	char path_name[BDEVNAME_SIZE];
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
+		rc = _dm_prepare_ioctl(md, &srcu_idx, &bdev, &tgt);
+		if (rc < 0) {
+			DMERR("%s: failed to get path: %d\n",
+			      __func__, rc);
+			goto out;
+		}
+
+		rhdr = hdr;
+
+		rc = sg_io(bdev->bd_disk->queue, bdev->bd_disk, &rhdr, mode);
+
+		DMDEBUG("SG_IO via %s: rc = %d D%02xH%02xM%02xS%02x\n",
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
+		case -ENOTTY:
+		case -EFAULT:
+		case -EINVAL:
+		case -EPERM:
+			goto out;
+		default:
+			break;
+		}
+
+		if (rhdr.info & SG_INFO_CHECK) {
+			/*
+			 * See if this is a target or path error.
+			 * Compare blk_path_error(), scsi_result_to_blk_status(),
+			 * blk_errors[].
+			 */
+			switch (rhdr.host_status) {
+			case DID_OK:
+				if (scsi_status_is_good(rhdr.status))
+					rc = 0;
+				break;
+			case DID_TARGET_FAILURE:
+				rc = -EREMOTEIO;
+				goto out;
+			case DID_NEXUS_FAILURE:
+				rc = -EBADE;
+				goto out;
+			case DID_ALLOC_FAILURE:
+				rc = -ENOSPC;
+				goto out;
+			case DID_MEDIUM_ERROR:
+				rc = -ENODATA;
+				goto out;
+			default:
+				/* Everything else is a path error */
+				rc = -EIO;
+				break;
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
+			DMDEBUG("sending \"%s %s\" to target\n", argv[0], argv[1]);
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
+
 static int dm_blk_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned int cmd, unsigned long arg)
 {
 	struct mapped_device *md = bdev->bd_disk->private_data;
 	int r, srcu_idx;
 
+	if ((dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) &&
+	    cmd == SG_IO)
+		return dm_sg_io_ioctl(bdev, mode, (void __user *)arg);
+
 	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
 	if (r < 0)
 		goto out;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c032cfe133c7..bded0e6546da 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -934,6 +934,8 @@ extern int scsi_cmd_ioctl(struct request_queue *, struct gendisk *, fmode_t,
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

