Return-Path: <SRS0=2AwM=KV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACEB7C47088
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:09:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 49A626142B
	for <dm-devel@archiver.kernel.org>; Wed, 26 May 2021 01:09:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49A626142B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-214-VWO8qPcINISRtnZN94A23w-1; Tue, 25 May 2021 21:09:53 -0400
X-MC-Unique: VWO8qPcINISRtnZN94A23w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8D781009465;
	Wed, 26 May 2021 01:09:49 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 95BB0100EBAF;
	Wed, 26 May 2021 01:09:49 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8299C1801029;
	Wed, 26 May 2021 01:09:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14Q19j3N020099 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 25 May 2021 21:09:45 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 43019208AB65; Wed, 26 May 2021 01:09:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E0F8208AB6F
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B34F833942
	for <dm-devel@redhat.com>; Wed, 26 May 2021 01:09:43 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-418-14ofU0RdOIOOsjCX16t9AA-1;
	Tue, 25 May 2021 21:09:40 -0400
X-MC-Unique: 14ofU0RdOIOOsjCX16t9AA-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id C6B8120B8008;
	Tue, 25 May 2021 18:00:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C6B8120B8008
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: dm-devel@redhat.com
Date: Tue, 25 May 2021 17:59:50 -0700
Message-Id: <20210526005954.31564-4-tusharsu@linux.microsoft.com>
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
Subject: [dm-devel] [RFC 3/7] dm: measure data on device remove
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

Presence of an active block-device, configured with expected parameters,
is important for an external attestation service to determine if a system
meets the attestation requirements.  Therefore it is important for DM to
measure the device remove events.

Measure device parameters, and table hashes when the device is removed.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 drivers/md/dm-ima.c   | 56 +++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-ima.h   |  1 +
 drivers/md/dm-ioctl.c |  2 ++
 3 files changed, 59 insertions(+)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index b244a7fd58fe..a93387beda9e 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -257,9 +257,65 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap)
 	kfree(device_table_data);
 }
 
+/*
+ * Measure IMA data on remove
+ */
+void dm_ima_measure_on_device_remove(struct mapped_device *md)
+{
+	unsigned int noio_flag, l;
+	char *dev_table_data;
+	char active[] = "active_table_hash=";
+	char inactive[] = "inactive_table_hash=";
+	unsigned int active_len = strlen(active);
+	unsigned int inactive_len = strlen(inactive);
+
+	noio_flag = memalloc_noio_save();
+	dev_table_data = kzalloc(DM_IMA_DEVICE_BUF_LEN, GFP_KERNEL);
+	memalloc_noio_restore(noio_flag);
+
+	if (!dev_table_data)
+		goto bad;
+	l = strlen(md->ima.device_data);
+	memcpy(dev_table_data, md->ima.device_data, l);
+
+	if (md->ima.active_table_hash) {
+		memcpy(dev_table_data + l, active, active_len);
+		l += active_len;
+
+		memcpy(dev_table_data + l,
+		md->ima.active_table_hash,
+		md->ima.active_table_hash_len);
+		l += md->ima.active_table_hash_len;
+
+		memcpy(dev_table_data + l, ";", 1);
+		l++;
+	}
+
+	if (md->ima.inactive_table_hash) {
+		memcpy(dev_table_data + l, inactive, inactive_len);
+		l += inactive_len;
+
+		memcpy(dev_table_data + l,
+		md->ima.inactive_table_hash,
+		md->ima.inactive_table_hash_len);
+
+		l += md->ima.inactive_table_hash_len;
+
+		memcpy(dev_table_data + l, ";", 1);
+		l++;
+	}
+
+	dm_ima_measure_data("device_remove", dev_table_data, l);
+
+	kfree(dev_table_data);
+bad:
+	kfree(md->ima.device_data);
+}
+
 #else
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags) {}
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap) {}
+void dm_ima_measure_on_device_remove(struct mapped_device *md) {}
 #endif
 MODULE_AUTHOR("Tushar Sugandhi <tusharsu@linux.microsoft.com>");
 MODULE_DESCRIPTION("Enables IMA measurements for DM targets");
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index 1cd0c76e0379..974b14361958 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -34,4 +34,5 @@ struct dm_ima_measurements {
 
 void dm_ima_measure_on_table_load(struct dm_table *table, unsigned int status_flags);
 void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap);
+void dm_ima_measure_on_device_remove(struct mapped_device *md);
 #endif /*DM_IMA_H*/
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index e06e256d1a7e..cb6392c156c2 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -984,6 +984,8 @@ static int dev_remove(struct file *filp, struct dm_ioctl *param, size_t param_si
 
 	param->flags &= ~DM_DEFERRED_REMOVE;
 
+	dm_ima_measure_on_device_remove(md);
+
 	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

