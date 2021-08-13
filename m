Return-Path: <SRS0=J1Yh=NE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA65FC4338F
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:38:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5EDB860F51
	for <dm-devel@archiver.kernel.org>; Fri, 13 Aug 2021 21:38:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5EDB860F51
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-5oaKae-pPQCik8MGaBUJVQ-1; Fri, 13 Aug 2021 17:38:26 -0400
X-MC-Unique: 5oaKae-pPQCik8MGaBUJVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 553B62688B;
	Fri, 13 Aug 2021 21:38:22 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 391D42C607;
	Fri, 13 Aug 2021 21:38:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 73651181A0F2;
	Fri, 13 Aug 2021 21:38:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 17DLcI0f015511 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 13 Aug 2021 17:38:18 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 652F210AF9D4; Fri, 13 Aug 2021 21:38:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F5D11054F8B
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:16 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E75F980158D
	for <dm-devel@redhat.com>; Fri, 13 Aug 2021 21:38:15 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-315-mW90zXn0MMqh9wnDu6JVaw-1;
	Fri, 13 Aug 2021 17:38:11 -0400
X-MC-Unique: mW90zXn0MMqh9wnDu6JVaw-1
Received: from Lenovo-Legion-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4A5EB20C1717;
	Fri, 13 Aug 2021 14:38:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4A5EB20C1717
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com, agk@redhat.com, snitzer@redhat.com
Date: Fri, 13 Aug 2021 14:37:57 -0700
Message-Id: <20210813213801.297051-3-tusharsu@linux.microsoft.com>
In-Reply-To: <20210813213801.297051-1-tusharsu@linux.microsoft.com>
References: <20210813213801.297051-1-tusharsu@linux.microsoft.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 17DLcI0f015511
X-loop: dm-devel@redhat.com
Cc: sfr@canb.auug.org.au, zohar@linux.ibm.com, nramas@linux.microsoft.com,
	public@thson.de, tusharsu@linux.microsoft.com,
	linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH 2/6] dm ima: add version info to dm related
	events in ima log
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The DM events present in the ima log contain various attributes in the
key=value format.  The attributes' names/values may change in future,
and new attributes may also get added.  The attestation server needs
some versioning to determine which attributes are supported and are
expected in the ima log.

Add version information to the DM events present in the ima log to
help attestation servers to correctly process the attributes across
different versions.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Suggested-by: Mimi Zohar <zohar@linux.ibm.com>
---
 drivers/md/dm-ima.c | 60 ++++++++++++++++++++++++++++++++++++---------
 drivers/md/dm-ima.h |  9 +++++++
 2 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index 4bab35c8f0c7..458a3a1d78bc 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -168,6 +168,7 @@ static int dm_ima_alloc_and_copy_capacity_str(struct mapped_device *md, char **c
 void dm_ima_reset_data(struct mapped_device *md)
 {
 	memset(&(md->ima), 0, sizeof(md->ima));
+	md->ima.dm_version_str_len = strlen(DM_IMA_VERSION_STR);
 }
 
 /*
@@ -224,6 +225,9 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 	if (r)
 		goto error;
 
+	memcpy(ima_buf + l, DM_IMA_VERSION_STR, table->md->ima.dm_version_str_len);
+	l += table->md->ima.dm_version_str_len;
+
 	device_data_buf_len = strlen(device_data_buf);
 	memcpy(ima_buf + l, device_data_buf, device_data_buf_len);
 	l += device_data_buf_len;
@@ -281,6 +285,9 @@ void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_fl
 			 * prefix, so that multiple records from the same table_load for
 			 * a given device can be linked together.
 			 */
+			memcpy(ima_buf + l, DM_IMA_VERSION_STR, table->md->ima.dm_version_str_len);
+			l += table->md->ima.dm_version_str_len;
+
 			memcpy(ima_buf + l, device_data_buf, device_data_buf_len);
 			l += device_data_buf_len;
 
@@ -368,6 +375,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 	unsigned int active_len = strlen(active), capacity_len = 0;
 	unsigned int l = 0;
 	bool noio = true;
+	bool nodata = true;
 	int r;
 
 	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
@@ -378,6 +386,9 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 	if (r)
 		goto error;
 
+	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
+	l += md->ima.dm_version_str_len;
+
 	if (swap) {
 		if (md->ima.active_table.hash != md->ima.inactive_table.hash)
 			kfree(md->ima.active_table.hash);
@@ -413,8 +424,11 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 	}
 
 	if (md->ima.active_table.device_metadata) {
-		l = md->ima.active_table.device_metadata_len;
-		memcpy(device_table_data, md->ima.active_table.device_metadata, l);
+		memcpy(device_table_data + l, md->ima.active_table.device_metadata,
+		       md->ima.active_table.device_metadata_len);
+		l += md->ima.active_table.device_metadata_len;
+
+		nodata = false;
 	}
 
 	if (md->ima.active_table.hash) {
@@ -427,16 +441,18 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 
 		memcpy(device_table_data + l, ";", 1);
 		l++;
+
+		nodata = false;
 	}
 
-	if (!l) {
+	if (nodata) {
 		r = dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio);
 		if (r)
 			goto error;
 
 		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
-			  "name=%s,uuid=%s;device_resume=no_data;",
-			  dev_name, dev_uuid);
+			  "%sname=%s,uuid=%s;device_resume=no_data;",
+			  DM_IMA_VERSION_STR, dev_name, dev_uuid);
 		l += strlen(device_table_data);
 
 	}
@@ -473,6 +489,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 	unsigned int capacity_len = 0;
 	unsigned int l = 0;
 	bool noio = true;
+	bool nodata = true;
 	int r;
 
 	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN*2, GFP_KERNEL, noio);
@@ -485,6 +502,9 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 		goto exit;
 	}
 
+	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
+	l += md->ima.dm_version_str_len;
+
 	if (md->ima.active_table.device_metadata) {
 		memcpy(device_table_data + l, device_active_str, device_active_len);
 		l += device_active_len;
@@ -492,6 +512,8 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 		memcpy(device_table_data + l, md->ima.active_table.device_metadata,
 		       md->ima.active_table.device_metadata_len);
 		l += md->ima.active_table.device_metadata_len;
+
+		nodata = false;
 	}
 
 	if (md->ima.inactive_table.device_metadata) {
@@ -501,6 +523,8 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 		memcpy(device_table_data + l, md->ima.inactive_table.device_metadata,
 		       md->ima.inactive_table.device_metadata_len);
 		l += md->ima.inactive_table.device_metadata_len;
+
+		nodata = false;
 	}
 
 	if (md->ima.active_table.hash) {
@@ -513,6 +537,8 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 
 		memcpy(device_table_data + l, ",", 1);
 		l++;
+
+		nodata = false;
 	}
 
 	if (md->ima.inactive_table.hash) {
@@ -525,19 +551,21 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all)
 
 		memcpy(device_table_data + l, ",", 1);
 		l++;
+
+		nodata = false;
 	}
 	/*
 	 * In case both active and inactive tables, and corresponding
 	 * device metadata is cleared/missing - record the name and uuid
 	 * in IMA measurements.
 	 */
-	if (!l) {
+	if (nodata) {
 		if (dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio))
 			goto error;
 
 		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
-			  "name=%s,uuid=%s;device_remove=no_data;",
-			  dev_name, dev_uuid);
+			  "%sname=%s,uuid=%s;device_remove=no_data;",
+			  DM_IMA_VERSION_STR, dev_name, dev_uuid);
 		l += strlen(device_table_data);
 	}
 
@@ -583,6 +611,7 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 	char inactive_str[] = "inactive_table_hash=";
 	unsigned int inactive_len = strlen(inactive_str);
 	bool noio = true;
+	bool nodata = true;
 	int r;
 
 	device_table_data = dm_ima_alloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL, noio);
@@ -593,6 +622,9 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 	if (r)
 		goto error1;
 
+	memcpy(device_table_data + l, DM_IMA_VERSION_STR, md->ima.dm_version_str_len);
+	l += md->ima.dm_version_str_len;
+
 	if (md->ima.inactive_table.device_metadata_len &&
 	    md->ima.inactive_table.hash_len) {
 		memcpy(device_table_data + l, md->ima.inactive_table.device_metadata,
@@ -609,14 +641,17 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
 
 		memcpy(device_table_data + l, ";", 1);
 		l++;
+
+		nodata = false;
 	}
 
-	if (!l) {
+	if (nodata) {
 		if (dm_ima_alloc_and_copy_name_uuid(md, &dev_name, &dev_uuid, noio))
 			goto error2;
 
 		scnprintf(device_table_data, DM_IMA_DEVICE_BUF_LEN,
-			  "name=%s,uuid=%s;table_clear=no_data;", dev_name, dev_uuid);
+			  "%sname=%s,uuid=%s;table_clear=no_data;",
+			   DM_IMA_VERSION_STR, dev_name, dev_uuid);
 		l += strlen(device_table_data);
 	}
 
@@ -695,8 +730,9 @@ void dm_ima_measure_on_device_rename(struct mapped_device *md)
 	md->ima.active_table.device_metadata = new_device_data;
 	md->ima.active_table.device_metadata_len = strlen(new_device_data);
 
-	scnprintf(combined_device_data, DM_IMA_DEVICE_BUF_LEN * 2, "%snew_name=%s,new_uuid=%s;%s",
-		  old_device_data, new_dev_name, new_dev_uuid, capacity_str);
+	scnprintf(combined_device_data, DM_IMA_DEVICE_BUF_LEN * 2,
+		  "%s%snew_name=%s,new_uuid=%s;%s", DM_IMA_VERSION_STR, old_device_data,
+		  new_dev_name, new_dev_uuid, capacity_str);
 
 	dm_ima_measure_data("device_rename", combined_device_data, strlen(combined_device_data),
 			    noio);
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index 0731a51565d6..b8c3b614670b 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -18,6 +18,14 @@
 #define DM_IMA_DEVICE_CAPACITY_BUF_LEN	128
 #define DM_IMA_TABLE_HASH_ALG		"sha256"
 
+#define __dm_ima_stringify(s) #s
+#define __dm_ima_str(s) __dm_ima_stringify(s)
+
+#define DM_IMA_VERSION_STR "dm_version="	\
+	__dm_ima_str(DM_VERSION_MAJOR) "."	\
+	__dm_ima_str(DM_VERSION_MINOR) "."	\
+	__dm_ima_str(DM_VERSION_PATCHLEVEL) ";"
+
 #ifdef CONFIG_IMA
 
 struct dm_ima_device_table_metadata {
@@ -46,6 +54,7 @@ struct dm_ima_device_table_metadata {
 struct dm_ima_measurements {
 	struct dm_ima_device_table_metadata active_table;
 	struct dm_ima_device_table_metadata inactive_table;
+	unsigned int dm_version_str_len;
 };
 
 void dm_ima_reset_data(struct mapped_device *md);
-- 
2.32.0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

