Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64A96C388F2
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D830322277
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D830322277
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-k-BLw1rdMm6UxsLSXS-0ZQ-1; Mon, 02 Nov 2020 02:58:33 -0500
X-MC-Unique: k-BLw1rdMm6UxsLSXS-0ZQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 804921006C96;
	Mon,  2 Nov 2020 07:58:28 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5EFFC19C78;
	Mon,  2 Nov 2020 07:58:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 304B2181A050;
	Mon,  2 Nov 2020 07:58:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A1MQjAJ029374 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 17:26:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 603D82156A4D; Sun,  1 Nov 2020 22:26:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A4532156A4A
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B088D1021F60
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:42 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-76-zt8ER_NYPVe5HGTX0prIuw-1;
	Sun, 01 Nov 2020 17:26:38 -0500
X-MC-Unique: zt8ER_NYPVe5HGTX0prIuw-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id D7A1220B36E7;
	Sun,  1 Nov 2020 14:26:36 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D7A1220B36E7
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Sun,  1 Nov 2020 14:26:22 -0800
Message-Id: <20201101222626.6111-4-tusharsu@linux.microsoft.com>
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
Subject: [dm-devel] [PATCH v5 3/7] IMA: add hook to measure critical data
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Currently, IMA does not provide a generic function for kernel subsystems
to measure their critical data. Examples of critical data in this context
could be kernel in-memory r/o structures, hash of the memory structures,
or data that represents a linux kernel subsystem state change. The 
critical data, if accidentally or maliciously altered, can compromise
the integrity of the system.

A generic function provided by IMA to measure critical data would enable
various subsystems with easier and faster on-boarding to use IMA
infrastructure and would also avoid code duplication.

Add a new IMA func CRITICAL_DATA and a corresponding IMA hook
ima_measure_critical_data() to support measuring critical data for 
various kernel subsystems. 

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 Documentation/ABI/testing/ima_policy |  2 +-
 include/linux/ima.h                  |  8 ++++++
 security/integrity/ima/ima.h         |  1 +
 security/integrity/ima/ima_api.c     |  2 +-
 security/integrity/ima/ima_main.c    | 38 ++++++++++++++++++++++++++++
 security/integrity/ima/ima_policy.c  |  2 ++
 6 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index cd572912c593..3de6c774c37e 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -29,7 +29,7 @@ Description:
 		base: 	func:= [BPRM_CHECK][MMAP_CHECK][CREDS_CHECK][FILE_CHECK][MODULE_CHECK]
 				[FIRMWARE_CHECK]
 				[KEXEC_KERNEL_CHECK] [KEXEC_INITRAMFS_CHECK]
-				[KEXEC_CMDLINE] [KEY_CHECK]
+				[KEXEC_CMDLINE] [KEY_CHECK] [CRITICAL_DATA]
 			mask:= [[^]MAY_READ] [[^]MAY_WRITE] [[^]MAY_APPEND]
 			       [[^]MAY_EXEC]
 			fsmagic:= hex value
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 8fa7bcfb2da2..60ba073f1575 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -30,6 +30,10 @@ extern int ima_post_read_file(struct file *file, void *buf, loff_t size,
 extern void ima_post_path_mknod(struct dentry *dentry);
 extern int ima_file_hash(struct file *file, char *buf, size_t buf_size);
 extern void ima_kexec_cmdline(int kernel_fd, const void *buf, int size);
+extern void ima_measure_critical_data(const char *event_data_source,
+				      const char *event_name,
+				      const void *buf, int buf_len,
+				      bool measure_buf_hash);
 
 #ifdef CONFIG_IMA_KEXEC
 extern void ima_add_kexec_buffer(struct kimage *image);
@@ -116,6 +120,10 @@ static inline int ima_file_hash(struct file *file, char *buf, size_t buf_size)
 }
 
 static inline void ima_kexec_cmdline(int kernel_fd, const void *buf, int size) {}
+static inline void ima_measure_critical_data(const char *event_data_source,
+					     const char *event_name,
+					     const void *buf, int buf_len,
+					     bool measure_buf_hash) {}
 #endif /* CONFIG_IMA */
 
 #ifndef CONFIG_IMA_KEXEC
diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 0f77e0b697a3..c1acf88e1b5d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -200,6 +200,7 @@ static inline unsigned int ima_hash_key(u8 *digest)
 	hook(POLICY_CHECK, policy)			\
 	hook(KEXEC_CMDLINE, kexec_cmdline)		\
 	hook(KEY_CHECK, key)				\
+	hook(CRITICAL_DATA, critical_data)		\
 	hook(MAX_CHECK, none)
 
 #define __ima_hook_enumify(ENUM, str)	ENUM,
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index af218babd198..9917e1730cb6 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -176,7 +176,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
  *		subj=, obj=, type=, func=, mask=, fsmagic=
  *	subj,obj, and type: are LSM specific.
  *	func: FILE_CHECK | BPRM_CHECK | CREDS_CHECK | MMAP_CHECK | MODULE_CHECK
- *	| KEXEC_CMDLINE | KEY_CHECK
+ *	| KEXEC_CMDLINE | KEY_CHECK | CRITICAL_DATA
  *	mask: contains the permission mask
  *	fsmagic: hex value
  *
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 4485d87c0aa5..6e1b11dcba53 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -921,6 +921,44 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
 	fdput(f);
 }
 
+/**
+ * ima_measure_critical_data - measure kernel subsystem data
+ * critical to integrity of the kernel
+ * @event_data_source: name of the data source being measured;
+ * typically it should be the name of the kernel subsystem that is sending
+ * the data for measurement
+ * @event_name: name of an event from the kernel subsystem that is sending
+ * the data for measurement
+ * @buf: pointer to buffer containing data to measure
+ * @buf_len: length of buffer(in bytes)
+ * @measure_buf_hash: if set to true - will measure hash of the buf,
+ *                    instead of buf
+ *
+ * A given kernel subsystem (event_data_source) may send
+ * data (buf) to be measured when the data or the subsystem state changes.
+ * The state/data change can be described by event_name.
+ * Examples of critical data (buf) could be kernel in-memory r/o structures,
+ * hash of the memory structures, or data that represents subsystem
+ * state change.
+ * measure_buf_hash can be used to save space, if the data being measured
+ * is too large.
+ * The data (buf) can only be measured, not appraised.
+ */
+void ima_measure_critical_data(const char *event_data_source,
+			       const char *event_name,
+			       const void *buf, int buf_len,
+			       bool measure_buf_hash)
+{
+	if (!event_name || !event_data_source || !buf || !buf_len) {
+		pr_err("Invalid arguments passed to %s().\n", __func__);
+		return;
+	}
+
+	process_buffer_measurement(NULL, buf, buf_len, event_name,
+				   CRITICAL_DATA, 0, event_data_source,
+				   measure_buf_hash);
+}
+
 static int __init init_ima(void)
 {
 	int error;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 4edc9be62048..f48e82450fe1 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -1251,6 +1251,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 			else if (IS_ENABLED(CONFIG_IMA_MEASURE_ASYMMETRIC_KEYS) &&
 				 strcmp(args[0].from, "KEY_CHECK") == 0)
 				entry->func = KEY_CHECK;
+			else if (strcmp(args[0].from, "CRITICAL_DATA") == 0)
+				entry->func = CRITICAL_DATA;
 			else
 				result = -EINVAL;
 			if (!result)
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

