Return-Path: <SRS0=s8Rv=LW=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD4CEC2B9F4
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7A48C61C5B
	for <dm-devel@archiver.kernel.org>; Mon, 28 Jun 2021 09:53:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A48C61C5B
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-2vDf0yjJMg-aBHtU1topFw-1; Mon, 28 Jun 2021 05:53:31 -0400
X-MC-Unique: 2vDf0yjJMg-aBHtU1topFw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B0EF100C661;
	Mon, 28 Jun 2021 09:53:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E8AD148DD;
	Mon, 28 Jun 2021 09:53:26 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id BB11F1801020;
	Mon, 28 Jun 2021 09:53:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 15S9qgup009177 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 28 Jun 2021 05:52:42 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 2D68850159; Mon, 28 Jun 2021 09:52:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2655150157
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 09:52:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BCBDB10AC3A3
	for <dm-devel@redhat.com>; Mon, 28 Jun 2021 09:52:39 +0000 (UTC)
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29]) (Using
	TLS) by relay.mimecast.com with ESMTP id
	us-mta-108-tc1M_6MvNoijRbmDHzpMhw-1; Mon, 28 Jun 2021 05:52:34 -0400
X-MC-Unique: tc1M_6MvNoijRbmDHzpMhw-1
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
	bits)) (No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 92D1F2024F;
	Mon, 28 Jun 2021 09:52:32 +0000 (UTC)
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
	by imap.suse.de (Postfix) with ESMTP id 0667311906;
	Mon, 28 Jun 2021 09:52:31 +0000 (UTC)
Received: from director2.suse.de ([192.168.254.72]) by imap3-int with ESMTPSA
	id iLV3O9+b2WAqagAALh3uQQ
	(envelope-from <mwilck@suse.com>); Mon, 28 Jun 2021 09:52:31 +0000
From: mwilck@suse.com
To: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
	Bart Van Assche <Bart.VanAssche@sandisk.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, dm-devel@redhat.com,
	Hannes Reinecke <hare@suse.de>
Date: Mon, 28 Jun 2021 11:52:08 +0200
Message-Id: <20210628095210.26249-2-mwilck@suse.com>
In-Reply-To: <20210628095210.26249-1-mwilck@suse.com>
References: <20210628095210.26249-1-mwilck@suse.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 15S9qgup009177
X-loop: dm-devel@redhat.com
Cc: Daniel Wagner <dwagner@suse.de>, emilne@redhat.com,
	Martin Wilck <mwilck@suse.com>, linux-block@vger.kernel.org,
	nkoenig@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [PATCH v4 1/3] scsi: scsi_ioctl: export
	__scsi_result_to_blk_status()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Martin Wilck <mwilck@suse.com>

This makes it possible to use scsi_result_to_blk_status() from
code that shouldn't depend on scsi_mod (e.g. device mapper).

scsi_ioctl.c is selected by CONFIG_BLK_SCSI_REQUEST, which is automatically
selected by CONFIG_SCSI.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 block/scsi_ioctl.c      | 47 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c | 24 +--------------------
 include/linux/blkdev.h  |  1 +
 3 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index fa6df11b8bdd..19b63b64ecbc 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -882,6 +882,53 @@ void scsi_req_init(struct scsi_request *req)
 }
 EXPORT_SYMBOL(scsi_req_init);
 
+/* See set_host_byte() in include/scsi/scsi_cmnd.h */
+static void __set_host_byte(int *result, char status)
+{
+	*result = (*result & 0xff00ffff) | (status << 16);
+}
+
+/**
+ * __scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
+ * @cmd:	SCSI command
+ * @cmd_result: pointer to scsi cmnd result code to be possibly changed
+ *
+ * Translate a SCSI result code into a blk_status_t value. May reset the host
+ * byte of @cmd_result.
+ */
+blk_status_t __scsi_result_to_blk_status(int *cmd_result, int result)
+{
+	switch (host_byte(result)) {
+	case DID_OK:
+		/*
+		 * Also check the other bytes than the status byte in result
+		 * to handle the case when a SCSI LLD sets result to
+		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
+		 */
+		if (scsi_status_is_good(result))
+			return BLK_STS_OK;
+		return BLK_STS_IOERR;
+	case DID_TRANSPORT_FAILFAST:
+	case DID_TRANSPORT_MARGINAL:
+		return BLK_STS_TRANSPORT;
+	case DID_TARGET_FAILURE:
+		__set_host_byte(cmd_result, DID_OK);
+		return BLK_STS_TARGET;
+	case DID_NEXUS_FAILURE:
+		__set_host_byte(cmd_result, DID_OK);
+		return BLK_STS_NEXUS;
+	case DID_ALLOC_FAILURE:
+		__set_host_byte(cmd_result, DID_OK);
+		return BLK_STS_NOSPC;
+	case DID_MEDIUM_ERROR:
+		__set_host_byte(cmd_result, DID_OK);
+		return BLK_STS_MEDIUM;
+	default:
+		return BLK_STS_IOERR;
+	}
+}
+EXPORT_SYMBOL(__scsi_result_to_blk_status);
+
 static int __init blk_scsi_ioctl_init(void)
 {
 	blk_set_cmd_filter_defaults(&blk_default_cmd_filter);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6b994baf87c2..2c0eca3693af 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -589,29 +589,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
  */
 static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 {
-	switch (host_byte(result)) {
-	case DID_OK:
-		if (scsi_status_is_good(result))
-			return BLK_STS_OK;
-		return BLK_STS_IOERR;
-	case DID_TRANSPORT_FAILFAST:
-	case DID_TRANSPORT_MARGINAL:
-		return BLK_STS_TRANSPORT;
-	case DID_TARGET_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_TARGET;
-	case DID_NEXUS_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_NEXUS;
-	case DID_ALLOC_FAILURE:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_NOSPC;
-	case DID_MEDIUM_ERROR:
-		set_host_byte(cmd, DID_OK);
-		return BLK_STS_MEDIUM;
-	default:
-		return BLK_STS_IOERR;
-	}
+	return __scsi_result_to_blk_status(&cmd->result, result);
 }
 
 /* Helper for scsi_io_completion() when "reprep" action required. */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1255823b2bc0..48497a77428d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -2021,4 +2021,5 @@ int fsync_bdev(struct block_device *bdev);
 int freeze_bdev(struct block_device *bdev);
 int thaw_bdev(struct block_device *bdev);
 
+blk_status_t __scsi_result_to_blk_status(int *cmd_result, int result);
 #endif /* _LINUX_BLKDEV_H */
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

