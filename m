Return-Path: <SRS0=Uigt=FO=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A33AC4167B
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 11:42:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F2D3B23D57
	for <dm-devel@archiver.kernel.org>; Thu, 10 Dec 2020 11:42:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2D3B23D57
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.de
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-_dhK9VzeOBm6advN0XZOpw-1; Thu, 10 Dec 2020 06:42:21 -0500
X-MC-Unique: _dhK9VzeOBm6advN0XZOpw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D38E9800D53;
	Thu, 10 Dec 2020 11:42:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EAFE45D9E2;
	Thu, 10 Dec 2020 11:42:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DFC4B180954D;
	Thu, 10 Dec 2020 11:42:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BABg860029301 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 10 Dec 2020 06:42:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5F388D7B3C; Thu, 10 Dec 2020 11:42:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5692DD7DE0
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 11:42:05 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A564E811E76
	for <dm-devel@redhat.com>; Thu, 10 Dec 2020 11:42:05 +0000 (UTC)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-524-f5WPkCjaN7uiGXRxgx_t3g-1;
	Thu, 10 Dec 2020 06:42:01 -0500
X-MC-Unique: f5WPkCjaN7uiGXRxgx_t3g-1
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
	by mx2.suse.de (Postfix) with ESMTP id 4BA4AAF0C;
	Thu, 10 Dec 2020 11:41:57 +0000 (UTC)
From: Hannes Reinecke <hare@suse.de>
To: Mike Snitzer <snitzer@redhat.com>
Date: Thu, 10 Dec 2020 10:24:59 +0100
Message-Id: <20201210092459.81939-1-hare@suse.de>
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
Cc: dm-devel@redhat.com
Subject: [dm-devel] [PATCH] dm: avoid filesystem lookup in dm_get_dev_t()
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

dm_get_dev_t() is just used to convert an arbitrary 'path' string
into a dev_t. It doesn't presume that the device is present; that
check will be done later, as the only caller is dm_get_device(),
which does a dm_get_table_device() later on, which will properly
open the device.
So if the path string already _is_ in major:minor representation
we can convert it directly, avoiding a recursion into the filesystem
to lookup the block device.
This avoids a hang in multipath_message() when the filesystem is
inaccessible.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/md/dm-table.c     |  6 ++++++
 drivers/scsi/scsi_error.c | 18 ++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0142dc0e6798..d71808be006b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -411,7 +411,13 @@ dev_t dm_get_dev_t(const char *path)
 {
 	dev_t dev;
 	struct block_device *bdev;
+	unsigned int maj, min;
 
+	if (sscanf(path, "%u:%u", &maj, &min) == 2) {
+		dev = MKDEV(maj, min);
+		if (maj == MAJOR(dev) && min == MINOR(dev))
+			return dev;
+	}
 	bdev = lookup_bdev(path);
 	if (IS_ERR(bdev))
 		dev = name_to_dev_t(path);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6e01e90d83af..deee3e99aed0 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -133,16 +133,6 @@ scmd_eh_abort_handler(struct work_struct *work)
 	struct scsi_device *sdev = scmd->device;
 	int rtn;
 
-#ifndef __GENKSYMS__
-	if (scmd->eh_eflags & SCSI_EH_INTERNAL_TIMEOUT) {
-		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
-			"internal timeout\n"));
-		set_host_byte(scmd, DID_TIME_OUT);
-		scmd->eh_eflags &= ~SCSI_EH_INTERNAL_TIMEOUT;
-		scsi_finish_command(scmd);
-		return;
-	}
-#endif
 	if (scsi_host_eh_past_deadline(sdev->host)) {
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
@@ -934,6 +924,14 @@ static int scsi_try_bus_device_reset(struct scsi_cmnd *scmd)
 static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
 				 struct scsi_cmnd *scmd)
 {
+#ifndef __GENKSYMS__
+	if (scmd->eh_eflags & SCSI_EH_INTERNAL_TIMEOUT) {
+		SCSI_LOG_ERROR_RECOVERY(3, scmd_printk(KERN_INFO, scmd,
+			"internal timeout\n"));
+		scmd->eh_eflags &= ~SCSI_EH_INTERNAL_TIMEOUT;
+		return SUCCESS;
+	}
+#endif
 	if (!hostt->eh_abort_handler)
 		return FAILED;
 
-- 
2.16.4

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

