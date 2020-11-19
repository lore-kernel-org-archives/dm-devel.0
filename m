Return-Path: <SRS0=RcAx=E2=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1134C63798
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:23:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 16F0922226
	for <dm-devel@archiver.kernel.org>; Fri, 20 Nov 2020 09:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 16F0922226
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-899fWjB3MK-4ihLdbAlIGQ-1; Fri, 20 Nov 2020 04:23:07 -0500
X-MC-Unique: 899fWjB3MK-4ihLdbAlIGQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63496184215E;
	Fri, 20 Nov 2020 09:23:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 473255D9D5;
	Fri, 20 Nov 2020 09:23:00 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1A2F65002F;
	Fri, 20 Nov 2020 09:23:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJNQUoa016081 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 18:26:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3EB911018E79; Thu, 19 Nov 2020 23:26:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3831A1018E6F
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 23:26:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 82B5B857F92
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 23:26:28 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-522-3410Qk6TO4OrqjUAQoctTA-1;
	Thu, 19 Nov 2020 18:26:25 -0500
X-MC-Unique: 3410Qk6TO4OrqjUAQoctTA-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 0411720B7133;
	Thu, 19 Nov 2020 15:26:23 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0411720B7133
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Thu, 19 Nov 2020 15:26:09 -0800
Message-Id: <20201119232611.30114-7-tusharsu@linux.microsoft.com>
In-Reply-To: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
References: <20201119232611.30114-1-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 20 Nov 2020 04:22:46 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v6 6/8] IMA: add support to critical data hook to
	limit data sources for measurement
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

The IMA hook ima_measure_critical_data() does not support a way to
specify the source of the critical data provider. Thus, the data
measurement cannot be constrained, based on the data source, through the
IMA policy.

Extend the IMA hook ima_measure_critical_data() to support passing 
the data source name as an input parameter, so that the policy rule can
be used to limit data sources being measured.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 include/linux/ima.h               |  6 ++++--
 security/integrity/ima/ima_main.c | 11 ++++++++---
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 9911a6e496b6..60ba073f1575 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -30,7 +30,8 @@ extern int ima_post_read_file(struct file *file, void *buf, loff_t size,
 extern void ima_post_path_mknod(struct dentry *dentry);
 extern int ima_file_hash(struct file *file, char *buf, size_t buf_size);
 extern void ima_kexec_cmdline(int kernel_fd, const void *buf, int size);
-extern void ima_measure_critical_data(const char *event_name,
+extern void ima_measure_critical_data(const char *event_data_source,
+				      const char *event_name,
 				      const void *buf, int buf_len,
 				      bool measure_buf_hash);
 
@@ -119,7 +120,8 @@ static inline int ima_file_hash(struct file *file, char *buf, size_t buf_size)
 }
 
 static inline void ima_kexec_cmdline(int kernel_fd, const void *buf, int size) {}
-static inline void ima_measure_critical_data(const char *event_name,
+static inline void ima_measure_critical_data(const char *event_data_source,
+					     const char *event_name,
 					     const void *buf, int buf_len,
 					     bool measure_buf_hash) {}
 #endif /* CONFIG_IMA */
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 7661f09569f3..27b8b8316622 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -924,6 +924,7 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
 
 /**
  * ima_measure_critical_data - measure kernel integrity critical data
+ * @event_data_source: kernel data source being measured
  * @event_name: event name to be used for the buffer entry
  * @buf: pointer to buffer containing data to measure
  * @buf_len: length of buffer(in bytes)
@@ -932,6 +933,9 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
  * Measure the kernel subsystem data, critical to the integrity of the kernel,
  * into the IMA log and extend the @pcr.
  *
+ * Use @event_data_source to describe the kernel data source for the buffer
+ * being measured.
+ *
  * Use @event_name to describe the state/buffer data change.
  * Examples of critical data (buf) could be kernel in-memory r/o structures,
  * hash of the memory structures, or data that represents subsystem state
@@ -944,17 +948,18 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
  *
  * The data (buf) can only be measured, not appraised.
  */
-void ima_measure_critical_data(const char *event_name,
+void ima_measure_critical_data(const char *event_data_source,
+			       const char *event_name,
 			       const void *buf, int buf_len,
 			       bool measure_buf_hash)
 {
-	if (!event_name || !buf || !buf_len) {
+	if (!event_name || !event_data_source || !buf || !buf_len) {
 		pr_err("Invalid arguments passed to %s().\n", __func__);
 		return;
 	}
 
 	process_buffer_measurement(NULL, buf, buf_len, event_name,
-				   CRITICAL_DATA, 0, NULL,
+				   CRITICAL_DATA, 0, event_data_source,
 				   measure_buf_hash);
 }
 
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

