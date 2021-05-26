Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F27ECC47087
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:10:20 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8281361417
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:10:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8281361417
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379--1RFVhoNOVW4O8fdyT9T9A-1; Tue, 25 May 2021 21:10:16 -0400
X-MC-Unique: -1RFVhoNOVW4O8fdyT9T9A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 937AE8030A1;
	Wed, 26 May 2021 01:10:11 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 770046E418;
	Wed, 26 May 2021 01:10:11 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4451F1801264;
	Wed, 26 May 2021 01:10:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14Q19otw020152 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 21:09:50 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6387F208AB60; Wed, 26 May 2021 01:09:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F6C7208AB6F
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 48E0A800B26
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:50 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-232-RvZUpjnoM3-PgUAey4ZSsg-1;
	Tue, 25 May 2021 21:09:40 -0400
X-MC-Unique: RvZUpjnoM3-PgUAey4ZSsg-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 502FB20B800A;
	Tue, 25 May 2021 18:00:05 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 502FB20B800A
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com
Date: Tue, 25 May 2021 17:59:51 -0700
Message-Id: <20210526005954.31564-5-tusharsu@linux.microsoft.com>
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
Subject: [dm-devel] [RFC 4/7] dm: measure data on table clear
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
 drivers/md/dm-ima.c   | 50 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-ima.h   |  2 ++
 drivers/md/dm-ioctl.c |  3 +++
 3 files changed, 55 insertions(+)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index a93387beda9e..6670b5f74004 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -312,10 +312,60 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md)
 	kfree(md->ima.device_data);
 }
 
+/*
+ * measure ima data on table clear
+ */
+void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map)
+{
+	unsigned int noio_flag, l;
+	char *device_table_data;
+	char inactive[] = "inactive_table_hash=";
+	unsigned int inactive_len = strlen(inactive);
+
+	noio_flag = memalloc_noio_save();
+	device_table_data = kzalloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL);
+	memalloc_noio_restore(noio_flag);
+
+	if (!device_table_data)
+		goto bad;
+
+	l = strlen(md->ima.device_data);
+	memcpy(device_table_data, md->ima.device_data, l);
+	memcpy(device_table_data + l, inactive, inactive_len);
+	l += inactive_len;
+
+	memcpy(device_table_data + l, md->ima.inactive_table_hash,
+	       md->ima.inactive_table_hash_len);
+
+	l += md->ima.inactive_table_hash_len;
+
+	memcpy(device_table_data + l, ";", 1);
+	l++;
+
+	dm_ima_measure_data("table_clear", device_table_data, l);
+
+	if (new_map) {
+		kfree(md->ima.inactive_table_hash);
+		md->ima.inactive_table_hash = NULL;
+		md->ima.inactive_table_hash_len = 0;
+
+		if (md->ima.active_table_hash) {
+			md->ima.inactive_table_hash = md->ima.active_table_hash;
+			md->ima.inactive_table_hash_len = md->ima.active_table_hash_len;
+		}
+
+	}
+
+	kfree(device_table_data);
+bad:
+	return;
+}
+
 #else
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
 void dm_ima_measure_on_device_remove(struct mapped_device *md) {}
+void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map) {}
 #endif
 MODULE_AUTHOR("Tushar Sugandhi <tusharsu@linux.microsoft.com>");
 MODULE_DESCRIPTION("Enables IMA measurements for DM targets");
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index 974b14361958..ed633e031a18 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -35,4 +35,6 @@ struct dm_ima_measurements {
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
 void dm_ima_measure_on_device_remove(struct mapped_device *md);
+void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map);
+
 #endif /*DM_IMA_H*/
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index cb6392c156c2..b4f47d596985 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1509,6 +1509,7 @@ static int table_clear(struct file *filp, struct dm_ioctl *param, size_t param_s
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *old_map = NULL;
+	bool has_new_map = false;
 
 	down_write(&_hash_lock);
 
@@ -1522,6 +1523,7 @@ static int table_clear(struct file *filp, struct dm_ioctl *param, size_t param_s
 	if (hc->new_map) {
 		old_map = hc->new_map;
 		hc->new_map = NULL;
+		has_new_map = true;
 	}
 
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
@@ -1533,6 +1535,7 @@ static int table_clear(struct file *filp, struct dm_ioctl *param, size_t param_s
 		dm_sync_table(md);
 		dm_table_destroy(old_map);
 	}
+	dm_ima_measure_on_table_clear(md, has_new_map);
 	dm_put(md);
 
 	return 0;
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

