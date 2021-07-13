Return-Path: <SRS0=SrOh=MF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F954C11F66
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jul 2021 00:55:57 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 987E76101D
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jul 2021 00:55:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 987E76101D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-vHELAEFcM1mwsa1gmw9nVQ-1; Mon, 12 Jul 2021 20:55:52 -0400
X-MC-Unique: vHELAEFcM1mwsa1gmw9nVQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1F2C801107;
	Tue, 13 Jul 2021 00:55:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AF5F360871;
	Tue, 13 Jul 2021 00:55:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F3ACB4EA37;
	Tue, 13 Jul 2021 00:55:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16D0tgC9025258 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Jul 2021 20:55:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D2D962041ABA; Tue, 13 Jul 2021 00:55:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD338203663F
	for <dm-devel@redhat.com>; Tue, 13 Jul 2021 00:55:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DCFA100DE6E
	for <dm-devel@redhat.com>; Tue, 13 Jul 2021 00:55:41 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-446-rhO7DsdTMJmjugHLT-xqZQ-1;
	Mon, 12 Jul 2021 20:55:39 -0400
X-MC-Unique: rhO7DsdTMJmjugHLT-xqZQ-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id EB43720B800A;
	Mon, 12 Jul 2021 17:49:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EB43720B800A
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Mon, 12 Jul 2021 17:49:00 -0700
Message-Id: <20210713004904.8808-4-tusharsu@linux.microsoft.com>
In-Reply-To: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
References: <20210713004904.8808-1-tusharsu@linux.microsoft.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16D0tgC9025258
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, nramas@linux.microsoft.com,
	linux-integrity@vger.kernel.org, zohar@linux.ibm.com
Subject: [dm-devel] [PATCH 3/7] dm: measure data on device remove
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

Presence of an active block-device, configured with expected parameters,
is important for an external attestation service to determine if a system
meets the attestation requirements.  Therefore it is important for DM to
measure the device remove events.

Measure device parameters and table hashes when the device is removed,
using either remove or remove_all.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 drivers/md/dm-ima.c   | 120 ++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-ima.h   |   1 +
 drivers/md/dm-ioctl.c |   3 ++
 3 files changed, 124 insertions(+)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 1c545717adf4..47eca432a21a 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -453,10 +453,130 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 	kfree(device_table_data);
 }
 
+/*
+ * Measure IMA data on remove.
+ */
+void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
+{
+	char *device_table_data, *dev_name = NULL, *dev_uuid = NULL, *capacity_str = NULL;
+	char active_table_str[] = "active_table_hash=";
+	char inactive_table_str[] = "inactive_table_hash=";
+	char device_active_str[] = "device_active_metadata=";
+	char device_inactive_str[] = "device_inactive_metadata=";
+	char remove_all_str[] = "remove_all=";
+	unsigned int active_table_len = strlen(active_table_str);
+	unsigned int inactive_table_len = strlen(inactive_table_str);
+	unsigned int device_active_len = strlen(device_active_str);
+	unsigned int device_inactive_len = strlen(device_inactive_str);
+	unsigned int remove_all_len = strlen(remove_all_str);
+	unsigned int capacity_len = 0;
+	unsigned int l = 0;
+	bool noio = true;
+	int r;
+
+	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN*2, GFP_KERNEL, noio);
+	if (!device_table_data)
+		goto exit;
+
+	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
+	if (r) {
+		kfree(device_table_data);
+		goto exit;
+	}
+
+	if (md->ima.active_table.device_metadata) {
+		memcpy(device_table_data + l, device_active_str, device_active_len);
+		l += device_active_len;
+
+		memcpy(device_table_data + l, md->ima.active_table.device_metadata,
+		       md->ima.active_table.device_metadata_len);
+		l += md->ima.active_table.device_metadata_len;
+	}
+
+	if (md->ima.inactive_table.device_metadata) {
+		memcpy(device_table_data + l, device_inactive_str, device_inactive_len);
+		l += device_inactive_len;
+
+		memcpy(device_table_data + l, md->ima.inactive_table.device_metadata,
+		       md->ima.inactive_table.device_metadata_len);
+		l += md->ima.inactive_table.device_metadata_len;
+	}
+
+	if (md->ima.active_table.hash) {
+		memcpy(device_table_data + l, active_table_str, active_table_len);
+		l += active_table_len;
+
+		memcpy(device_table_data + l, md->ima.active_table.hash,
+			   md->ima.active_table.hash_len);
+		l += md->ima.active_table.hash_len;
+
+		memcpy(device_table_data + l, ",", 1);
+		l++;
+	}
+
+	if (md->ima.inactive_table.hash) {
+		memcpy(device_table_data + l, inactive_table_str, inactive_table_len);
+		l += inactive_table_len;
+
+		memcpy(device_table_data + l, md->ima.inactive_table.hash,
+		       md->ima.inactive_table.hash_len);
+		l += md->ima.inactive_table.hash_len;
+
+		memcpy(device_table_data + l, ",", 1);
+		l++;
+	}
+	/*
+	 * In case both active and inactive tables, and corresponding
+	 * device metadata is cleared/missing - record the name and uuid
+	 * in IMA measurements.
+	 */
+	if (!l) {
+		if (dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio))
+			goto error;
+
+		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
+			  "name=%s,uuid=%s;device_remove=no_data;",
+			  dev_name, dev_uuid);
+		l += strlen(device_table_data);
+	}
+
+	memcpy(device_table_data + l, remove_all_str, remove_all_len);
+	l += remove_all_len;
+	memcpy(device_table_data + l, remove_all ? "y;" : "n;", 2);
+	l += 2;
+
+	capacity_len = strlen(capacity_str);
+	memcpy(device_table_data + l, capacity_str, capacity_len);
+	l += capacity_len;
+
+	dm_ima_measure_data("device_remove", device_table_data, l, noio);
+
+error:
+	kfree(device_table_data);
+	kfree(capacity_str);
+exit:
+	kfree(md->ima.active_table.device_metadata);
+
+	if (md->ima.active_table.device_metadata !=
+	    md->ima.inactive_table.device_metadata)
+		kfree(md->ima.inactive_table.device_metadata);
+
+	kfree(md->ima.active_table.hash);
+
+	if (md->ima.active_table.hash != md->ima.inactive_table.hash)
+		kfree(md->ima.inactive_table.hash);
+
+	dm_ima_reset_data(md);
+
+	kfree(dev_name);
+	kfree(dev_uuid);
+}
+
 #else
 void dm_ima_reset_data(struct mapped_device *md) {}
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
+void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
 #endif
 MODULE_AUTHOR("Tushar Sugandhi <tusharsu@linux.microsoft.com>");
 MODULE_DESCRIPTION("Enables IMA measurements for DM targets");
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index cafdcf5064c7..cb7b883ed35b 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -49,4 +49,5 @@ struct dm_ima_measurements {
 void dm_ima_reset_data(struct mapped_device *md);
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
+void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
 #endif /*DM_IMA_H*/
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 11af40f9b9c0..2d4475f6de7d 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -348,6 +348,7 @@ static void dm_hash_remove_all(bool keep_open_devices, bool mark_deferred, bool
 			dm_sync_table(md);
 			dm_table_destroy(t);
 		}
+		dm_ima_measure_on_device_remove(md, true);
 		dm_put(md);
 		if (likely(keep_open_devices))
 			dm_destroy(md);
@@ -982,6 +983,8 @@ static int dev_remove(struct file *filp, struct dm_ioctl *param, size_t param_si
 
 	param->flags &= ~DM_DEFERRED_REMOVE;
 
+	dm_ima_measure_on_device_remove(md, false);
+
 	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

