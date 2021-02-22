Return-Path: <SRS0=l+U7=HY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4407C433DB
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 21:12:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 6B8FE64E25
	for <dm-devel@archiver.kernel.org>; Mon, 22 Feb 2021 21:12:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B8FE64E25
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57--tKE4UF_PM6Y6cq3DrbZBA-1; Mon, 22 Feb 2021 16:12:44 -0500
X-MC-Unique: -tKE4UF_PM6Y6cq3DrbZBA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id ADCE680402C;
	Mon, 22 Feb 2021 21:12:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3675A60C04;
	Mon, 22 Feb 2021 21:12:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C370718095CC;
	Mon, 22 Feb 2021 21:12:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 11MLCKl5014154 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 22 Feb 2021 16:12:20 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5312D200BFD2; Mon, 22 Feb 2021 21:12:20 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4DA272166B2F
	for <dm-devel@redhat.com>; Mon, 22 Feb 2021 21:12:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB6C29291B3
	for <dm-devel@redhat.com>; Mon, 22 Feb 2021 21:12:17 +0000 (UTC)
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-488-SJVi7hKvPdKX1Kd9cWA6xA-1; Mon, 22 Feb 2021 16:11:22 -0500
X-MC-Unique: SJVi7hKvPdKX1Kd9cWA6xA-1
IronPort-SDR: n1N4E2TR0mqz6bGgvDPa7nDiTiz40RKwRqa5WFWfEsH48b0kLNtNVOaiB333QhbIXEf7qvfSBj
	sDkJnBzMyezTBC5IhwmPz7AaJHsK0edCfAQCT4WuRYd0WwMjlpMUuVuagA7MIRv0fc0kQIY7F8
	0MF7eS3HVIP5Pqmo9cBbCCP0xVRf8YdLXMItAcbVesBImSN3R7krGYBUVgAOy1uxOa9CxmaWlB
	TeogZKjahDfDnJvnweEKz9k4sFu9ylSAPVzPs/JOQRvTduVrBugxpPhXEY0cdzP/O1/A/659g/
	pC0=
X-IronPort-AV: E=Sophos;i="5.81,198,1610380800"; d="scan'208";a="271076472"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com)
	([199.255.45.14])
	by ob1.hgst.iphmx.com with ESMTP; 23 Feb 2021 05:11:20 +0800
IronPort-SDR: 4WHcNgP18mnIuYtMDlLN8v8WHrWL51B/W6iLwCBoqfq78HpgbXdRZ5XaQRcfCVxmmguiFzxpEf
	WNFl97UaqTXF/fCl11oF4pjig96bdxCwOag0kVeccMMXd/xl3C9LO30JcfUIQCb2c5e+/212b/
	+k0pOUKHnaciZjtGDfQqc21hI4YY4mseaShrPxV7UOmgWqT3qNbF2AMDx+S7R7grRKuX63E4K1
	0iPQ0JIYvxGzUMTQKrJdQbxERbVo5QxzBiQ0pPo4hxaX/RO6cAjro2REhL9bx9aNQVpbqLZgBK
	OcQWx4xvDVOBLC16bBiTrcYV
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
	by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384;
	22 Feb 2021 12:54:39 -0800
IronPort-SDR: fRfcqDGdkdW2oAob0INVPkDULHy7+ONF7bYg/WFeMyp4ZTsYLxwO5t5AsMobCB+iAJnTe+hSsV
	RpYQpp97z4En5D6sT5iJ4fAB9bG/1B+bPRG1NbnOwN4/OhEyb3kmMTVEzGUl8hD9Kj+CD6oru3
	ksK5mTMQzY/7FXlG0X2OQeEadwyEk+/OXCJ2zdSkcbAV89dpPklnd/7q1RTWV0V1sHjlwWEM41
	0/0lfUKBXQK5nHKuIwsVn4J0JP/NeZUdqGegDiGTcG2cZAf6+qUJpttLO42bRi5wHBp779dIwZ
	KHY=
WDCIronportException: Internal
Received: from vm.labspan.wdc.com (HELO vm.sc.wdc.com) ([10.6.137.102])
	by uls-op-cesaip02.wdc.com with ESMTP; 22 Feb 2021 13:11:20 -0800
From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	virtualization@lists.linux-foundation.org, linux-ide@vger.kernel.org,
	linux-mmc@vger.kernel.org, target-devel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com
Date: Mon, 22 Feb 2021 13:11:15 -0800
Message-Id: <20210222211115.30416-1-chaitanya.kulkarni@wdc.com>
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
X-loop: dm-devel@redhat.com
Cc: ulf.hansson@linaro.org, snitzer@redhat.com, mst@redhat.com,
	jasowang@redhat.com, Kai.Makisara@kolumbus.fi,
	bfields@fieldses.org, cang@codeaurora.org,
	alim.akhtar@samsung.com, agk@redhat.com, beanhuo@micron.com,
	tim@cyberelk.net, dgilbert@interlog.com, vbadigan@codeaurora.org,
	richard.peng@oppo.com, chaitanya.kulkarni@wdc.com,
	jejb@linux.ibm.com, avri.altman@wdc.com, bp@alien8.de,
	stefanha@redhat.com, jaegeuk@kernel.org,
	stanley.chu@mediatek.com, axboe@kernel.dk,
	guoqing.jiang@cloud.ionos.com, martin.petersen@oracle.com,
	baolin.wang@linaro.org, fujita.tomonori@lab.ntt.co.jp,
	chuck.lever@oracle.com, zliua@micron.com, pbonzini@redhat.com,
	davem@davemloft.net, asutoshd@codeaurora.org
Subject: [dm-devel] [RFC PATCH] blk-core: remove blk_put_request()
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

The function blk_put_request() is just a wrapper to
blk_mq_free_request(), remove the unnecessary wrapper.

Any feedback is welcome on this RFC.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-core.c                   |  6 ------
 block/blk-merge.c                  |  2 +-
 block/bsg-lib.c                    |  4 ++--
 block/bsg.c                        |  4 ++--
 block/scsi_ioctl.c                 |  6 +++---
 drivers/block/paride/pd.c          |  2 +-
 drivers/block/pktcdvd.c            |  2 +-
 drivers/block/virtio_blk.c         |  2 +-
 drivers/cdrom/cdrom.c              |  4 ++--
 drivers/ide/ide-atapi.c            |  2 +-
 drivers/ide/ide-cd.c               |  4 ++--
 drivers/ide/ide-cd_ioctl.c         |  2 +-
 drivers/ide/ide-devsets.c          |  2 +-
 drivers/ide/ide-disk.c             |  2 +-
 drivers/ide/ide-ioctls.c           |  4 ++--
 drivers/ide/ide-park.c             |  2 +-
 drivers/ide/ide-pm.c               |  4 ++--
 drivers/ide/ide-tape.c             |  2 +-
 drivers/ide/ide-taskfile.c         |  2 +-
 drivers/md/dm-mpath.c              |  2 +-
 drivers/mmc/core/block.c           | 10 +++++-----
 drivers/scsi/scsi_error.c          |  2 +-
 drivers/scsi/scsi_lib.c            |  2 +-
 drivers/scsi/sg.c                  |  6 +++---
 drivers/scsi/st.c                  |  4 ++--
 drivers/scsi/ufs/ufshcd.c          |  6 +++---
 drivers/target/target_core_pscsi.c |  4 ++--
 fs/nfsd/blocklayout.c              |  4 ++--
 include/linux/blkdev.h             |  1 -
 29 files changed, 46 insertions(+), 53 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fc60ff208497..1754f5e7cc80 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -642,12 +642,6 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
 }
 EXPORT_SYMBOL(blk_get_request);
 
-void blk_put_request(struct request *req)
-{
-	blk_mq_free_request(req);
-}
-EXPORT_SYMBOL(blk_put_request);
-
 static void handle_bad_sector(struct bio *bio, sector_t maxsector)
 {
 	char b[BDEVNAME_SIZE];
diff --git a/block/blk-merge.c b/block/blk-merge.c
index ffb4aa0ea68b..f3493ee243fd 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -845,7 +845,7 @@ int blk_attempt_req_merge(struct request_queue *q, struct request *rq,
 
 	free = attempt_merge(q, rq, next);
 	if (free) {
-		blk_put_request(free);
+		blk_mq_free_request(free);
 		return 1;
 	}
 
diff --git a/block/bsg-lib.c b/block/bsg-lib.c
index 330fede77271..8ea2b33783fb 100644
--- a/block/bsg-lib.c
+++ b/block/bsg-lib.c
@@ -67,7 +67,7 @@ static int bsg_transport_fill_hdr(struct request *rq, struct sg_io_v4 *hdr,
 
 out_free_bidi_rq:
 	if (job->bidi_rq)
-		blk_put_request(job->bidi_rq);
+		blk_mq_free_request(job->bidi_rq);
 out:
 	kfree(job->request);
 	return ret;
@@ -128,7 +128,7 @@ static void bsg_transport_free_rq(struct request *rq)
 
 	if (job->bidi_rq) {
 		blk_rq_unmap_user(job->bidi_bio);
-		blk_put_request(job->bidi_rq);
+		blk_mq_free_request(job->bidi_rq);
 	}
 
 	kfree(job->request);
diff --git a/block/bsg.c b/block/bsg.c
index bd10922d5cbb..4ddc84aebecf 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -158,7 +158,7 @@ static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 
 	ret = q->bsg_dev.ops->fill_hdr(rq, &hdr, mode);
 	if (ret) {
-		blk_put_request(rq);
+		blk_mq_free_request(rq);
 		return ret;
 	}
 
@@ -189,7 +189,7 @@ static int bsg_sg_io(struct request_queue *q, fmode_t mode, void __user *uarg)
 
 out_free_rq:
 	rq->q->bsg_dev.ops->free_rq(rq);
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	if (!ret && copy_to_user(uarg, &hdr, sizeof(hdr)))
 		return -EFAULT;
 	return ret;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 6599bac0a78c..52cd3fd924fc 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -366,7 +366,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 out_free_cdb:
 	scsi_req_free_cmd(req);
 out_put_request:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return ret;
 }
 
@@ -509,7 +509,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	}
 	
 error:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 
 error_free_buffer:
 	kfree(buffer);
@@ -534,7 +534,7 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	scsi_req(rq)->cmd_len = 6;
 	blk_execute_rq(bd_disk, rq, 0);
 	err = scsi_req(rq)->result ? -EIO : 0;
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 
 	return err;
 }
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 897acda20ac8..381fc0cf0b35 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -782,7 +782,7 @@ static int pd_special_command(struct pd_unit *disk,
 
 	req->func = func;
 	blk_execute_rq(disk->gd, rq, 0);
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return 0;
 }
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index fc4b0f1aa86d..bb8d7ad52550 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -726,7 +726,7 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 	if (scsi_req(rq)->result)
 		ret = -EIO;
 out:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return ret;
 }
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index b0285db7cf4f..691d6d7ab135 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -323,7 +323,7 @@ static int virtblk_get_id(struct gendisk *disk, char *id_str)
 	blk_execute_rq(vblk->disk, req, false);
 	err = blk_status_to_errno(virtblk_result(blk_mq_rq_to_pdu(req)));
 out:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 	return err;
 }
 
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 90ad34c6ef8e..9131438da983 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2195,7 +2195,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		ret = blk_rq_map_user(q, rq, NULL, ubuf, len, GFP_KERNEL);
 		if (ret) {
-			blk_put_request(rq);
+			blk_mq_free_request(rq);
 			break;
 		}
 
@@ -2226,7 +2226,7 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 
 		if (blk_rq_unmap_user(bio))
 			ret = -EFAULT;
-		blk_put_request(rq);
+		blk_mq_free_request(rq);
 
 		if (ret)
 			break;
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index a1ce9f5ac3aa..0e8446189d67 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -110,7 +110,7 @@ int ide_queue_pc_tail(ide_drive_t *drive, struct gendisk *disk,
 	blk_execute_rq(disk, rq, 0);
 	error = scsi_req(rq)->result ? -EIO : 0;
 put_req:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return error;
 }
 EXPORT_SYMBOL_GPL(ide_queue_pc_tail);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index cffbcc27a34c..c32022a40ce7 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -462,7 +462,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 			error = blk_rq_map_kern(drive->queue, rq, buffer,
 						*bufflen, GFP_NOIO);
 			if (error) {
-				blk_put_request(rq);
+				blk_mq_free_request(rq);
 				return error;
 			}
 		}
@@ -501,7 +501,7 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
 			}
 			--retries;
 		}
-		blk_put_request(rq);
+		blk_mq_free_request(rq);
 		if (delay)
 			ssleep(2);
 	} while (failed && retries >= 0);
diff --git a/drivers/ide/ide-cd_ioctl.c b/drivers/ide/ide-cd_ioctl.c
index 011eab9c69b7..83920542bdcb 100644
--- a/drivers/ide/ide-cd_ioctl.c
+++ b/drivers/ide/ide-cd_ioctl.c
@@ -301,7 +301,7 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi)
 	rq->rq_flags = RQF_QUIET;
 	blk_execute_rq(cd->disk, rq, 0);
 	ret = scsi_req(rq)->result ? -EIO : 0;
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	/*
 	 * A reset will unlock the door. If it was previously locked,
 	 * lock it again.
diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index ca1d4b3d3878..3d09a17b0f93 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -175,7 +175,7 @@ int ide_devset_execute(ide_drive_t *drive, const struct ide_devset *setting,
 
 	blk_execute_rq(NULL, rq, 0);
 	ret = scsi_req(rq)->result;
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 
 	return ret;
 }
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 8413731c6259..afa94ab8c7e3 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -483,7 +483,7 @@ static int set_multcount(ide_drive_t *drive, int arg)
 	drive->mult_req = arg;
 	drive->special_flags |= IDE_SFLAG_SET_MULTMODE;
 	blk_execute_rq(NULL, rq, 0);
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 
 	return (drive->mult_count == arg) ? 0 : -EIO;
 }
diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index 43fbc37d85c3..8096f3afae12 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -139,7 +139,7 @@ static int ide_cmd_ioctl(ide_drive_t *drive, void __user *argp)
 		ide_req(rq)->type = ATA_PRIV_TASKFILE;
 		blk_execute_rq(NULL, rq, 0);
 		err = scsi_req(rq)->result ? -EIO : 0;
-		blk_put_request(rq);
+		blk_mq_free_request(rq);
 
 		return err;
 	}
@@ -237,7 +237,7 @@ static int generic_drive_reset(ide_drive_t *drive)
 	scsi_req(rq)->cmd[0] = REQ_DRIVE_RESET;
 	blk_execute_rq(NULL, rq, 1);
 	ret = scsi_req(rq)->result;
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return ret;
 }
 
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index a80a0f28f7b9..38e7194b69df 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -39,7 +39,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	ide_req(rq)->special = &timeout;
 	blk_execute_rq(NULL, rq, 1);
 	rc = scsi_req(rq)->result ? -EIO : 0;
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	if (rc)
 		goto out;
 
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index d680b3e3295f..75105188b2b1 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -29,7 +29,7 @@ int generic_ide_suspend(struct device *dev, pm_message_t mesg)
 
 	blk_execute_rq(NULL, rq, 0);
 	ret = scsi_req(rq)->result ? -EIO : 0;
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 
 	if (ret == 0 && ide_port_acpi(hwif)) {
 		/* call ACPI _PS3 only after both devices are suspended */
@@ -84,7 +84,7 @@ int generic_ide_resume(struct device *dev)
 	rqpm.pm_state = PM_EVENT_ON;
 
 	err = ide_pm_execute_rq(rq);
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 
 	if (err == 0 && dev->driver) {
 		struct ide_driver *drv = to_ide_driver(dev->driver);
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index fa05e7e7d609..696f175d565d 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -882,7 +882,7 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int size)
 	if (scsi_req(rq)->result == IDE_DRV_ERROR_GENERAL)
 		ret = -EIO;
 out_put:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return ret;
 }
 
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 6665fc4724b9..b7624e0e9fb1 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -446,7 +446,7 @@ int ide_raw_taskfile(ide_drive_t *drive, struct ide_cmd *cmd, u8 *buf,
 	blk_execute_rq(NULL, rq, 0);
 	error = scsi_req(rq)->result ? -EIO : 0;
 put_req:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 	return error;
 }
 EXPORT_SYMBOL(ide_raw_taskfile);
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bced42f082b0..4189ddeb305e 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -579,7 +579,7 @@ static void multipath_release_clone(struct request *clone,
 						    clone->io_start_time_ns);
 	}
 
-	blk_put_request(clone);
+	blk_mq_free_request(clone);
 }
 
 /*
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index a1d6b68320ae..64e889f702f7 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -255,7 +255,7 @@ static ssize_t power_ro_lock_store(struct device *dev,
 	req_to_mmc_queue_req(req)->drv_op = MMC_DRV_OP_BOOT_WP;
 	blk_execute_rq(NULL, req, 0);
 	ret = req_to_mmc_queue_req(req)->drv_op_result;
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 	if (!ret) {
 		pr_info("%s: Locking boot partition ro until next power on\n",
@@ -632,7 +632,7 @@ static int mmc_blk_ioctl_cmd(struct mmc_blk_data *md,
 	blk_execute_rq(NULL, req, 0);
 	ioc_err = req_to_mmc_queue_req(req)->drv_op_result;
 	err = mmc_blk_ioctl_copy_to_user(ic_ptr, idata);
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 cmd_done:
 	kfree(idata->buf);
@@ -705,7 +705,7 @@ static int mmc_blk_ioctl_multi_cmd(struct mmc_blk_data *md,
 	for (i = 0; i < num_of_cmds && !err; i++)
 		err = mmc_blk_ioctl_copy_to_user(&cmds[i], idata[i]);
 
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 cmd_err:
 	for (i = 0; i < num_of_cmds; i++) {
@@ -2728,7 +2728,7 @@ static int mmc_dbg_card_status_get(void *data, u64 *val)
 		*val = ret;
 		ret = 0;
 	}
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 	return ret;
 }
@@ -2763,7 +2763,7 @@ static int mmc_ext_csd_open(struct inode *inode, struct file *filp)
 	req_to_mmc_queue_req(req)->drv_op_data = &ext_csd;
 	blk_execute_rq(NULL, req, 0);
 	err = req_to_mmc_queue_req(req)->drv_op_result;
-	blk_put_request(req);
+	blk_mq_free_request(req);
 	if (err) {
 		pr_err("FAILED %d\n", err);
 		goto out_free;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c00f06e9ecb0..9ae8a699b934 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1971,7 +1971,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 
 static void eh_lock_door_done(struct request *req, blk_status_t status)
 {
-	blk_put_request(req);
+	blk_mq_free_request(req);
 }
 
 /**
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4d2280658559..48a0a2cbec6b 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -288,7 +288,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 		scsi_normalize_sense(rq->sense, rq->sense_len, sshdr);
 	ret = rq->result;
  out:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 	return ret;
 }
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4383d93110f8..7fd52e117737 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -811,7 +811,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	if (atomic_read(&sdp->detaching)) {
 		if (srp->bio) {
 			scsi_req_free_cmd(scsi_req(srp->rq));
-			blk_put_request(srp->rq);
+			blk_mq_free_request(srp->rq);
 			srp->rq = NULL;
 		}
 
@@ -1407,7 +1407,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	 */
 	srp->rq = NULL;
 	scsi_req_free_cmd(scsi_req(rq));
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (unlikely(srp->orphan)) {
@@ -1862,7 +1862,7 @@ sg_finish_rem_req(Sg_request *srp)
 
 	if (srp->rq) {
 		scsi_req_free_cmd(scsi_req(srp->rq));
-		blk_put_request(srp->rq);
+		blk_mq_free_request(srp->rq);
 	}
 
 	if (srp->res_used)
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 841ad2fc369a..4bc4e2318090 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -534,7 +534,7 @@ static void st_scsi_execute_end(struct request *req, blk_status_t status)
 		complete(SRpnt->waiting);
 
 	blk_rq_unmap_user(tmp);
-	blk_put_request(req);
+	blk_mq_free_request(req);
 }
 
 static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
@@ -561,7 +561,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 		err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen,
 				      GFP_KERNEL);
 		if (err) {
-			blk_put_request(req);
+			blk_mq_free_request(req);
 			return DRIVER_ERROR << 24;
 		}
 	}
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fb32d122f2e3..ff205fd3c555 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2871,7 +2871,7 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
 			err ? "query_complete_err" : "query_complete");
 
 out_put_tag:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
@@ -6409,7 +6409,7 @@ static int __ufshcd_issue_tm_cmd(struct ufs_hba *hba,
 	__clear_bit(free_slot, &hba->outstanding_tasks);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
-	blk_put_request(req);
+	blk_mq_free_request(req);
 
 	ufshcd_release(hba);
 	return err;
@@ -6584,7 +6584,7 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
 	}
 
 out:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 out_unlock:
 	up_read(&hba->clk_scaling_lock);
 	return err;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 33770e5808ce..3fa30a3d1d81 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1006,7 +1006,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 	return 0;
 
 fail_put_request:
-	blk_put_request(req);
+	blk_mq_free_request(req);
 fail:
 	kfree(pt);
 	return ret;
@@ -1061,7 +1061,7 @@ static void pscsi_req_done(struct request *req, blk_status_t status)
 		break;
 	}
 
-	blk_put_request(req);
+	blk_mq_free_request(req);
 	kfree(pt);
 }
 
diff --git a/fs/nfsd/blocklayout.c b/fs/nfsd/blocklayout.c
index 1058659a8d31..bd3ecdbeb3fe 100644
--- a/fs/nfsd/blocklayout.c
+++ b/fs/nfsd/blocklayout.c
@@ -265,7 +265,7 @@ static int nfsd4_scsi_identify_device(struct block_device *bdev,
 	len = (buf[2] << 8) + buf[3] + 4;
 	if (len > bufflen) {
 		if (len <= maxlen && retries--) {
-			blk_put_request(rq);
+			blk_mq_free_request(rq);
 			kfree(buf);
 			bufflen = len;
 			goto again;
@@ -308,7 +308,7 @@ static int nfsd4_scsi_identify_device(struct block_device *bdev,
 	}
 
 out_put_request:
-	blk_put_request(rq);
+	blk_mq_free_request(rq);
 out_free_buf:
 	kfree(buf);
 	return error;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c032cfe133c7..ed150b724015 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -914,7 +914,6 @@ extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 blk_qc_t submit_bio_noacct(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
-extern void blk_put_request(struct request *);
 extern struct request *blk_get_request(struct request_queue *, unsigned int op,
 				       blk_mq_req_flags_t flags);
 extern int blk_lld_busy(struct request_queue *q);
-- 
2.22.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

