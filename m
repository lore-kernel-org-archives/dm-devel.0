Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FA85C4707F
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:10:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8C1A161429
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:10:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C1A161429
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-04SBYUqlM1atvtDt_pXX8A-1; Tue, 25 May 2021 21:10:09 -0400
X-MC-Unique: 04SBYUqlM1atvtDt_pXX8A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EE9B80D683;
	Wed, 26 May 2021 01:10:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 77501101E24A;
	Wed, 26 May 2021 01:10:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 304535534D;
	Wed, 26 May 2021 01:10:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14Q19jOA020100 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 21:09:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 42F06208AB60; Wed, 26 May 2021 01:09:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E17E208AB70
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16C5D800B26
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:42 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-155-GHL0CSEDNVuWJ5ia9EaosA-1;
	Tue, 25 May 2021 21:09:39 -0400
X-MC-Unique: GHL0CSEDNVuWJ5ia9EaosA-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 75F0420B8006;
	Tue, 25 May 2021 18:00:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 75F0420B8006
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com
Date: Tue, 25 May 2021 17:59:49 -0700
Message-Id: <20210526005954.31564-3-tusharsu@linux.microsoft.com>
In-Reply-To: <20210526005954.31564-1-tusharsu@linux.microsoft.com>
References: <20210526005954.31564-1-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, nramas@linux.microsoft.com,
	zohar@linux.ibm.com, snitzer@redhat.com, agk@redhat.com
Subject: [dm-devel] [RFC 2/7] dm: measure data on device resume
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
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

A given block device can load a table multiple times, with different
input parameters, before eventually resuming it.  Further, a device may
be suspended and then resumed.  The device may never resume after a
table-load.  Because of the above valid scenarios for a given device,
it is important to measure and log the device resume event using IMA.

Also, if the table is large, measuring it in clear-text each time the
device changes state, will unnecessarily increase the size of IMA log.
Since the table clear-text is already measured during table-load event,
measuring the hash during resume should be sufficient to validate the
table contents.

Measure the device parameters, and hash of the active table, when the
device is resumed.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 drivers/md/dm-ima.c   | 47 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-ima.h   |  1 +
 drivers/md/dm-ioctl.c |  8 ++++++--
 3 files changed, 54 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 8903e746ead6..b244a7fd58fe 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -211,8 +211,55 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	kfree(ima_buf_head);
 }
 
+/*
+ * Measure IMA data on device resume
+ */
+void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
+{
+	char *device_table_data;
+	unsigned int noio_flag, l;
+	char active[] = "active_table_hash=";
+	unsigned int active_len = strlen(active);
+
+	noio_flag = memalloc_noio_save();
+	device_table_data = kzalloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL);
+	memalloc_noio_restore(noio_flag);
+
+	if (!device_table_data)
+		return;
+
+	if (swap) {
+		kfree(md->ima.active_table_hash);
+		md->ima.active_table_hash = NULL;
+		md->ima.active_table_hash_len = 0;
+
+		if (md->ima.inactive_table_hash) {
+			md->ima.active_table_hash = md->ima.inactive_table_hash;
+			md->ima.active_table_hash_len = md->ima.inactive_table_hash_len;
+			md->ima.inactive_table_hash = NULL;
+			md->ima.inactive_table_hash_len = 0;
+		}
+	}
+
+	l = md->ima.device_data_len;
+	memcpy(device_table_data, md->ima.device_data, l);
+	memcpy(device_table_data + l, active, active_len);
+	l += active_len;
+
+	memcpy(device_table_data + l, md->ima.active_table_hash, md->ima.active_table_hash_len);
+	l += md->ima.active_table_hash_len;
+
+	memcpy(device_table_data + l, ";", 1);
+	l++;
+
+	dm_ima_measure_data("device_resume", device_table_data, l);
+
+	kfree(device_table_data);
+}
+
 #else
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
+void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
 #endif
 MODULE_AUTHOR("Tushar Sugandhi <tusharsu@linux.microsoft.com>");
 MODULE_DESCRIPTION("Enables IMA measurements for DM targets");
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index a71e0682fcb9..1cd0c76e0379 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -33,4 +33,5 @@ struct dm_ima_measurements {
 };
 
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
+void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 #endif /*DM_IMA_H*/
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 21deff8513a7..e06e256d1a7e 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1162,8 +1162,12 @@ static int do_resume(struct dm_ioctl *param)
 
 	if (dm_suspended_md(md)) {
 		r = dm_resume(md);
-		if (!r && !dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr))
-			param->flags |= DM_UEVENT_GENERATED_FLAG;
+		if (!r) {
+			dm_ima_measure_on_device_resume(md, new_map ? true : false);
+
+			if (!dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr))
+				param->flags |= DM_UEVENT_GENERATED_FLAG;
+		}
 	}
 
 	/*
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

