Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64298C00A89
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id A878821556
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A878821556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-521-Ua2_jABhPtiCn2JM1Ozr5Q-1; Mon, 02 Nov 2020 02:58:11 -0500
X-MC-Unique: Ua2_jABhPtiCn2JM1Ozr5Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82A0257085;
	Mon,  2 Nov 2020 07:58:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A51B5B4BC;
	Mon,  2 Nov 2020 07:58:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C46A18005A2;
	Mon,  2 Nov 2020 07:58:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A1MQjRu029369 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 17:26:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 066842166B44; Sun,  1 Nov 2020 22:26:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0049E2166B27
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E948801224
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:41 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-536-oM7irKBxMni_yl6NBzbFRA-1;
	Sun, 01 Nov 2020 17:26:39 -0500
X-MC-Unique: oM7irKBxMni_yl6NBzbFRA-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 127BC20BE4BC;
	Sun,  1 Nov 2020 14:26:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 127BC20BE4BC
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Sun,  1 Nov 2020 14:26:24 -0800
Message-Id: <20201101222626.6111-6-tusharsu@linux.microsoft.com>
In-Reply-To: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
References: <20201101222626.6111-1-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 02 Nov 2020 02:58:01 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v5 5/7] IMA: validate supported kernel data
	sources before measurement
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently, IMA does not restrict random data sources from measuring
their data using ima_measure_critical_data(). Any kernel data source can
call the function, and it's data will get measured as long as the input
event_data_source is part of the IMA policy - CRITICAL_DATA+data_sources.

To ensure that only data from supported sources are measured, the kernel
subsystem name needs to be added to a compile-time list of supported
sources (an "allowed list of components"). IMA then validates the input
parameter - "event_data_source" passed to ima_measure_critical_data()
against this allowed list at run-time.

This compile-time list must be updated when kernel subsystems are
updated to measure their data using IMA.

Provide an infrastructure for kernel data sources to be added to
IMA's supported data sources list at compile-time. Update
ima_measure_critical_data() to validate, at run-time, that the data
source is supported before measuring the data coming from that source.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 security/integrity/ima/ima.h      | 29 +++++++++++++++++++++++++++++
 security/integrity/ima/ima_main.c | 12 ++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index c1acf88e1b5d..4a35db010d91 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -228,6 +228,35 @@ extern const char *const func_tokens[];
 
 struct modsig;
 
+#define __ima_supported_kernel_data_sources(source)	\
+	source(MIN_SOURCE, min_source)			\
+	source(MAX_SOURCE, max_source)
+
+#define __ima_enum_stringify(ENUM, str) (#str),
+
+enum ima_supported_kernel_data_sources {
+	__ima_supported_kernel_data_sources(__ima_hook_enumify)
+};
+
+static const char * const ima_supported_kernel_data_sources_str[] = {
+	__ima_supported_kernel_data_sources(__ima_enum_stringify)
+};
+
+static inline bool ima_kernel_data_source_is_supported(const char *source)
+{
+	int i;
+
+	if (!source)
+		return false;
+
+	for (i = MIN_SOURCE + 1; i < MAX_SOURCE; i++) {
+		if (!strcmp(ima_supported_kernel_data_sources_str[i], source))
+			return true;
+	}
+
+	return false;
+}
+
 #ifdef CONFIG_IMA_QUEUE_EARLY_BOOT_KEYS
 /*
  * To track keys that need to be measured.
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 6e1b11dcba53..091c2e58f3c7 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -937,6 +937,12 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
  * A given kernel subsystem (event_data_source) may send
  * data (buf) to be measured when the data or the subsystem state changes.
  * The state/data change can be described by event_name.
+ * Before the first use of this function by a given kernel subsystem,
+ * the subsystem name (event_data_source) must be added to the
+ * compile-time list of data sources being measured -
+ * i.e. __ima_supported_kernel_data_sources.
+ * Otherwise, IMA will not measure any data for that event_data_source
+ * at run-time.
  * Examples of critical data (buf) could be kernel in-memory r/o structures,
  * hash of the memory structures, or data that represents subsystem
  * state change.
@@ -954,6 +960,12 @@ void ima_measure_critical_data(const char *event_data_source,
 		return;
 	}
 
+	if (!ima_kernel_data_source_is_supported(event_data_source)) {
+		pr_err("measuring data source %s is not permitted",
+		       event_data_source);
+		return;
+	}
+
 	process_buffer_measurement(NULL, buf, buf_len, event_name,
 				   CRITICAL_DATA, 0, event_data_source,
 				   measure_buf_hash);
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

