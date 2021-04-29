Return-Path: <SRS0=KYOW=J2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52118C433B4
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 15:51:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9FE8F6144E
	for <dm-devel@archiver.kernel.org>; Thu, 29 Apr 2021 15:51:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9FE8F6144E
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-tBd5GWpCNIyI06J5PEUsew-1; Thu, 29 Apr 2021 11:51:11 -0400
X-MC-Unique: tBd5GWpCNIyI06J5PEUsew-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54CD48186E5;
	Thu, 29 Apr 2021 15:51:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8DA2060C17;
	Thu, 29 Apr 2021 15:51:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id B59141806D06;
	Thu, 29 Apr 2021 15:51:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13TFp0NA010167 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 29 Apr 2021 11:51:00 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 53F0921EE57C; Thu, 29 Apr 2021 15:51:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F27221EE583
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 15:50:54 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8167FA28816
	for <dm-devel@redhat.com>; Thu, 29 Apr 2021 15:50:54 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-319-XScNJs0UO1q6_kyfuDumAA-1;
	Thu, 29 Apr 2021 11:50:49 -0400
X-MC-Unique: XScNJs0UO1q6_kyfuDumAA-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 162BCAFB1;
	Thu, 29 Apr 2021 15:50:48 +0000 (UTC)
From: mwilck@suse.com
To: Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>,
	dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>
Date: Thu, 29 Apr 2021 17:50:23 +0200
Message-Id: <20210429155024.4947-2-mwilck@suse.com>
In-Reply-To: <20210429155024.4947-1-mwilck@suse.com>
References: <20210429155024.4947-1-mwilck@suse.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13TFp0NA010167
X-loop: dm-devel@redhat.com
Cc: Daniel Wagner <dwagner@suse.de>, Martin Wilck <mwilck@suse.com>,
	linux-block@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [dm-devel] [RFC PATCH v2 1/2] scsi: convert
	scsi_result_to_blk_status() to inline
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

This makes it possible to use scsi_result_to_blk_status() from
code that shouldn't depend on scsi_mod (e.g. device mapper).

Also, create variants of set_host_byte() etc. that don't expect
a struct scsi_cmnd *, but just a pointer to the result to be
modified/fixed.

Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/scsi/scsi_lib.c  | 40 -------------------
 include/scsi/scsi_cmnd.h | 83 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 79 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d7c0d5a5f263..e423184f2bba 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -610,46 +610,6 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 	return false;
 }
 
-/**
- * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
- * @cmd:	SCSI command
- * @result:	scsi error code
- *
- * Translate a SCSI result code into a blk_status_t value. May reset the host
- * byte of @cmd->result.
- */
-static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
-{
-	switch (host_byte(result)) {
-	case DID_OK:
-		/*
-		 * Also check the other bytes than the status byte in result
-		 * to handle the case when a SCSI LLD sets result to
-		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
-		 */
-		if (scsi_status_is_good(result) && (result & ~0xff) == 0)
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
-}
-
 /* Helper for scsi_io_completion() when "reprep" action required. */
 static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
 				      struct request_queue *q)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 83f7e520be48..ba1e69d3bed9 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -311,24 +311,44 @@ static inline struct scsi_data_buffer *scsi_prot(struct scsi_cmnd *cmd)
 #define scsi_for_each_prot_sg(cmd, sg, nseg, __i)		\
 	for_each_sg(scsi_prot_sglist(cmd), sg, nseg, __i)
 
+static inline void __set_status_byte(int *result, char status)
+{
+	*result = (*result & 0xffffff00) | status;
+}
+
 static inline void set_status_byte(struct scsi_cmnd *cmd, char status)
 {
-	cmd->result = (cmd->result & 0xffffff00) | status;
+	__set_status_byte(&cmd->result, status);
+}
+
+static inline void __set_msg_byte(int *result, char status)
+{
+	*result = (*result & 0xffff00ff) | (status << 8);
 }
 
 static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
 {
-	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
+	__set_msg_byte(&cmd->result, status);
+}
+
+static inline void __set_host_byte(int *result, char status)
+{
+	*result = (*result & 0xff00ffff) | (status << 16);
 }
 
 static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
 {
-	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
+	__set_host_byte(&cmd->result, status);
+}
+
+static inline void __set_driver_byte(int *result, char status)
+{
+	*result = (*result & 0x00ffffff) | (status << 24);
 }
 
 static inline void set_driver_byte(struct scsi_cmnd *cmd, char status)
 {
-	cmd->result = (cmd->result & 0x00ffffff) | (status << 24);
+	__set_driver_byte(&cmd->result, status);
 }
 
 static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
@@ -342,4 +362,59 @@ static inline unsigned scsi_transfer_length(struct scsi_cmnd *scmd)
 	return xfer_len;
 }
 
+/**
+ * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
+ * @result:	scsi error code
+ * @cmd_result: pointer to scsi cmnd result code to be possibly changed
+ *
+ * Translate a SCSI result code into a blk_status_t value. May reset the host
+ * byte of @cmd_result.
+ */
+static inline blk_status_t __scsi_result_to_blk_status(int *cmd_result, int result)
+{
+	switch (host_byte(result)) {
+	case DID_OK:
+		/*
+		 * Also check the other bytes than the status byte in result
+		 * to handle the case when a SCSI LLD sets result to
+		 * DRIVER_SENSE << 24 without setting SAM_STAT_CHECK_CONDITION.
+		 */
+		if (scsi_status_is_good(result) && (result & ~0xff) == 0)
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
+
+/**
+ * scsi_result_to_blk_status - translate a SCSI result code into blk_status_t
+ * @cmd:	SCSI command
+ * @result:	scsi error code
+ *
+ * Translate a SCSI result code into a blk_status_t value. May reset the host
+ * byte of @cmd->result.
+ */
+static inline blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd,
+						     int result)
+{
+	return __scsi_result_to_blk_status(&cmd->result, result);
+}
+
+
 #endif /* _SCSI_SCSI_CMND_H */
-- 
2.31.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

