Return-Path: <SRS0=SrOh=MF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78693C07E9C
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jul 2021 00:55:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id F110B611F1
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jul 2021 00:55:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F110B611F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-529-7uJEmXvANICD-Xrn4ZK71w-1; Mon, 12 Jul 2021 20:55:52 -0400
X-MC-Unique: 7uJEmXvANICD-Xrn4ZK71w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E52DD100C660;
	Tue, 13 Jul 2021 00:55:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AFC3310027A5;
	Tue, 13 Jul 2021 00:55:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C98DF4EA2A;
	Tue, 13 Jul 2021 00:55:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16D0tgOT025257 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Jul 2021 20:55:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D6917218ADFE; Tue, 13 Jul 2021 00:55:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CD8EE218ADFD
	for <dm-devel@redhat.com>; Tue, 13 Jul 2021 00:55:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16DEC100DE6B
	for <dm-devel@redhat.com>; Tue, 13 Jul 2021 00:55:40 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-100-AzEMZE3uP4ivXVZzz5eT_A-1;
	Mon, 12 Jul 2021 20:55:38 -0400
X-MC-Unique: AzEMZE3uP4ivXVZzz5eT_A-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 9A5E520B6AEE;
	Mon, 12 Jul 2021 17:49:12 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9A5E520B6AEE
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Mon, 12 Jul 2021 17:48:59 -0700
Message-Id: <20210713004904.8808-3-tusharsu@linux.microsoft.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16D0tgOT025257
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, nramas@linux.microsoft.com,
	linux-integrity@vger.kernel.org, zohar@linux.ibm.com
Subject: [dm-devel] [PATCH 2/7] dm: measure data on device resume
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
 drivers/md/dm-ima.c   | 118 ++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-ima.h   |   2 +
 drivers/md/dm-ioctl.c |   8 ++-
 3 files changed, 126 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index b752517380c3..1c545717adf4 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -145,6 +145,27 @@ static void dm_ima_measure_data(const char *event_name, const void *buf, size_t
 		memalloc_noio_restore(noio_flag);
 }
 
+/*
+ * Internal function to allocate and copy current device capacity for IMA measurements.
+ */
+
+static int dm_ima_alloc_and_copy_capacity_str(struct mapped_device *md, char **capacity_str,
+					      bool noio)
+{
+	sector_t capacity;
+
+	capacity = get_capacity(md->disk);
+
+	*capacity_str = dm_ima_alloc(DM_IMA_DEVICE_CAPACITY_BUF_LEN, GFP_KERNEL, noio);
+	if (!(*capacity_str))
+		return -ENOMEM;
+
+	scnprintf(*capacity_str, DM_IMA_DEVICE_BUF_LEN, "current_device_capacity=%llu;",
+		  capacity);
+
+	return 0;
+}
+
 /*
  * Initialize the dm ima related data structure variables.
  */
@@ -336,9 +357,106 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	kfree(target_data_buf);
 }
 
+/*
+ * Measure IMA data on device resume.
+ */
+void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
+{
+	char *device_table_data, *dev_name = NULL, *dev_uuid = NULL, *capacity_str = NULL;
+	char active[] = "active_table_hash=";
+	unsigned int active_len = strlen(active), capacity_len = 0;
+	unsigned int l = 0;
+	bool noio = true;
+	int r;
+
+	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
+	if (!device_table_data)
+		return;
+
+	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
+	if (r)
+		goto error;
+
+	if (swap) {
+		if (md->ima.active_table.hash != md->ima.inactive_table.hash)
+			kfree(md->ima.active_table.hash);
+
+		md->ima.active_table.hash = NULL;
+		md->ima.active_table.hash_len = 0;
+
+		if (md->ima.active_table.device_metadata !=
+		    md->ima.inactive_table.device_metadata)
+			kfree(md->ima.active_table.device_metadata);
+
+		md->ima.active_table.device_metadata = NULL;
+		md->ima.active_table.device_metadata_len = 0;
+		md->ima.active_table.num_targets = 0;
+
+		if (md->ima.inactive_table.hash) {
+			md->ima.active_table.hash = md->ima.inactive_table.hash;
+			md->ima.active_table.hash_len = md->ima.inactive_table.hash_len;
+			md->ima.inactive_table.hash = NULL;
+			md->ima.inactive_table.hash_len = 0;
+		}
+
+		if (md->ima.inactive_table.device_metadata) {
+			md->ima.active_table.device_metadata =
+				md->ima.inactive_table.device_metadata;
+			md->ima.active_table.device_metadata_len =
+				md->ima.inactive_table.device_metadata_len;
+			md->ima.active_table.num_targets = md->ima.inactive_table.num_targets;
+			md->ima.inactive_table.device_metadata = NULL;
+			md->ima.inactive_table.device_metadata_len = 0;
+			md->ima.inactive_table.num_targets = 0;
+		}
+	}
+
+	if (md->ima.active_table.device_metadata) {
+		l = md->ima.active_table.device_metadata_len;
+		memcpy(device_table_data, md->ima.active_table.device_metadata, l);
+	}
+
+	if (md->ima.active_table.hash) {
+		memcpy(device_table_data + l, active, active_len);
+		l += active_len;
+
+		memcpy(device_table_data + l, md->ima.active_table.hash,
+		       md->ima.active_table.hash_len);
+		l += md->ima.active_table.hash_len;
+
+		memcpy(device_table_data + l, ";", 1);
+		l++;
+	}
+
+	if (!l) {
+		r = dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio);
+		if (r)
+			goto error;
+
+		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
+			  "name=%s,uuid=%s;device_resume=no_data;",
+			  dev_name, dev_uuid);
+		l += strlen(device_table_data);
+
+	}
+
+	capacity_len = strlen(capacity_str);
+	memcpy(device_table_data + l, capacity_str, capacity_len);
+	l += capacity_len;
+
+	dm_ima_measure_data("device_resume", device_table_data, l, noio);
+
+	kfree(dev_name);
+	kfree(dev_uuid);
+error:
+	kfree(capacity_str);
+	kfree(device_table_data);
+}
+
 #else
 void dm_ima_reset_data(struct mapped_device *md) {}
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
+void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
 #endif
 MODULE_AUTHOR("Tushar Sugandhi <tusharsu@linux.microsoft.com>");
 MODULE_DESCRIPTION("Enables IMA measurements for DM targets");
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index 3c92a2523284..cafdcf5064c7 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -15,6 +15,7 @@
 #define DM_IMA_DEVICE_BUF_LEN		1024
 #define DM_IMA_TARGET_METADATA_BUF_LEN	128
 #define DM_IMA_TARGET_DATA_BUF_LEN	2048
+#define DM_IMA_DEVICE_CAPACITY_BUF_LEN	128
 
 struct dm_ima_device_table_metadata {
 	/*
@@ -47,4 +48,5 @@ struct dm_ima_measurements {
 
 void dm_ima_reset_data(struct mapped_device *md);
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
+void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 #endif /*DM_IMA_H*/
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index e6e9fe74baf9..11af40f9b9c0 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1160,8 +1160,12 @@ static int do_resume(struct dm_ioctl *param)
 
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
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

