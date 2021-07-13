Return-Path: <SRS0=SrOh=MF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 893A6C11F66
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jul 2021 00:56:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1E1E2611CB
	for <dm-devel@archiver.kernel.org>; Tue, 13 Jul 2021 00:56:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E1E2611CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-Ikz4fyVrP26WkOQCWlOpwQ-1; Mon, 12 Jul 2021 20:56:08 -0400
X-MC-Unique: Ikz4fyVrP26WkOQCWlOpwQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A00F801AAA;
	Tue, 13 Jul 2021 00:56:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E5C360C9F;
	Tue, 13 Jul 2021 00:56:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0352F1809CAC;
	Tue, 13 Jul 2021 00:56:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 16D0thfq025262 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 12 Jul 2021 20:55:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 0CB2DC77D7; Tue, 13 Jul 2021 00:55:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 052E6C77CE
	for <dm-devel@redhat.com>; Tue, 13 Jul 2021 00:55:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 309E6805F4A
	for <dm-devel@redhat.com>; Tue, 13 Jul 2021 00:55:40 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-570-I9iIePb1MNW3VsZpJJnUsg-1;
	Mon, 12 Jul 2021 20:55:38 -0400
X-MC-Unique: I9iIePb1MNW3VsZpJJnUsg-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 44CBB20B8010;
	Mon, 12 Jul 2021 17:49:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 44CBB20B8010
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Mon, 12 Jul 2021 17:49:01 -0700
Message-Id: <20210713004904.8808-5-tusharsu@linux.microsoft.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 16D0thfq025262
X-loop: dm-devel@redhat.com
Cc: tusharsu@linux.microsoft.com, nramas@linux.microsoft.com,
	linux-integrity@vger.kernel.org, zohar@linux.ibm.com
Subject: [dm-devel] [PATCH 4/7] dm: measure data on table clear
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

For a given block device, an inactive table slot contains the parameters
to configure the device with.  The inactive table can be cleared
multiple times, accidentally or maliciously, which may impact the
functionality of the device, and compromise the system.  Therefore it is
important to measure and log the event when a table is cleared.

Measure device parameters, and table hashes when the inactive table slot
is cleared.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 drivers/md/dm-ima.c   | 93 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-ima.h   |  2 +
 drivers/md/dm-ioctl.c |  3 ++
 3 files changed, 98 insertions(+)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 47eca432a21a..b1e1cf6bb4e7 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -572,11 +572,104 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 	kfree(dev_uuid);
 }
 
+/*
+ * Measure ima data on table clear.
+ */
+void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
+{
+	unsigned int l = 0, capacity_len = 0;
+	char *device_table_data = NULL, *dev_name = NULL, *dev_uuid = NULL, *capacity_str = NULL;
+	char inactive_str[] = "inactive_table_hash=";
+	unsigned int inactive_len = strlen(inactive_str);
+	bool noio = true;
+	int r;
+
+	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
+	if (!device_table_data)
+		return;
+
+	r = dm_ima_alloc_and_copy_capacity_str(md, &capacity_str, noio);
+	if (r)
+		goto error1;
+
+	if (md->ima.inactive_table.device_metadata_len &&
+	    md->ima.inactive_table.hash_len) {
+		memcpy(device_table_data + l, md->ima.inactive_table.device_metadata,
+		       md->ima.inactive_table.device_metadata_len);
+		l += md->ima.inactive_table.device_metadata_len;
+
+		memcpy(device_table_data + l, inactive_str, inactive_len);
+		l += inactive_len;
+
+		memcpy(device_table_data + l, md->ima.inactive_table.hash,
+			   md->ima.inactive_table.hash_len);
+
+		l += md->ima.inactive_table.hash_len;
+
+		memcpy(device_table_data + l, ";", 1);
+		l++;
+	}
+
+	if (!l) {
+		if (dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio))
+			goto error2;
+
+		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
+			  "name=%s,uuid=%s;table_clear=no_data;", dev_name, dev_uuid);
+		l += strlen(device_table_data);
+	}
+
+	capacity_len = strlen(capacity_str);
+	memcpy(device_table_data + l, capacity_str, capacity_len);
+	l += capacity_len;
+
+	dm_ima_measure_data("table_clear", device_table_data, l, noio);
+
+	if (new_map) {
+		if (md->ima.inactive_table.hash &&
+		    md->ima.inactive_table.hash != md->ima.active_table.hash)
+			kfree(md->ima.inactive_table.hash);
+
+		md->ima.inactive_table.hash = NULL;
+		md->ima.inactive_table.hash_len = 0;
+
+		if (md->ima.inactive_table.device_metadata &&
+		    md->ima.inactive_table.device_metadata != md->ima.active_table.device_metadata)
+			kfree(md->ima.inactive_table.device_metadata);
+
+		md->ima.inactive_table.device_metadata = NULL;
+		md->ima.inactive_table.device_metadata_len = 0;
+		md->ima.inactive_table.num_targets = 0;
+
+		if (md->ima.active_table.hash) {
+			md->ima.inactive_table.hash = md->ima.active_table.hash;
+			md->ima.inactive_table.hash_len = md->ima.active_table.hash_len;
+		}
+
+		if (md->ima.active_table.device_metadata) {
+			md->ima.inactive_table.device_metadata =
+				md->ima.active_table.device_metadata;
+			md->ima.inactive_table.device_metadata_len =
+				md->ima.active_table.device_metadata_len;
+			md->ima.inactive_table.num_targets =
+				md->ima.active_table.num_targets;
+		}
+	}
+
+	kfree(dev_name);
+	kfree(dev_uuid);
+error2:
+	kfree(capacity_str);
+error1:
+	kfree(device_table_data);
+}
+
 #else
 void dm_ima_reset_data(struct mapped_device *md) {}
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
 void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all) {}
+void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map) {}
 #endif
 MODULE_AUTHOR("Tushar Sugandhi <tusharsu@linux.microsoft.com>");
 MODULE_DESCRIPTION("Enables IMA measurements for DM targets");
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index cb7b883ed35b..a17ae953dc67 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -50,4 +50,6 @@ void dm_ima_reset_data(struct mapped_device *md);
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all);
+void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map);
+
 #endif /*DM_IMA_H*/
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2d4475f6de7d..b07c19037c7c 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1508,6 +1508,7 @@ static int table_clear(struct file *filp, struct dm_ioctl *param, size_t param_s
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *old_map = NULL;
+	bool has_new_map = false;
 
 	down_write(&_hash_lock);
 
@@ -1521,6 +1522,7 @@ static int table_clear(struct file *filp, struct dm_ioctl *param, size_t param_s
 	if (hc->new_map) {
 		old_map = hc->new_map;
 		hc->new_map = NULL;
+		has_new_map = true;
 	}
 
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
@@ -1532,6 +1534,7 @@ static int table_clear(struct file *filp, struct dm_ioctl *param, size_t param_s
 		dm_sync_table(md);
 		dm_table_destroy(old_map);
 	}
+	dm_ima_measure_on_table_clear(md, has_new_map);
 	dm_put(md);
 
 	return 0;
-- 
2.25.1


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

