Return-Path: <SRS0=6nCw=HB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0FA1C433E0
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jan 2021 00:46:12 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 48A2E64E0C
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jan 2021 00:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48A2E64E0C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-0uvRcYQlO0iUVJQCnh8ctQ-1; Fri, 29 Jan 2021 19:46:09 -0500
X-MC-Unique: 0uvRcYQlO0iUVJQCnh8ctQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9E99A107ACE8;
	Sat, 30 Jan 2021 00:46:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 811F46F7E7;
	Sat, 30 Jan 2021 00:46:04 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 579DD5003B;
	Sat, 30 Jan 2021 00:46:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10U0jbLM011382 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Jan 2021 19:45:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 00E622166B2B; Sat, 30 Jan 2021 00:45:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF5DD2166B2A
	for <dm-devel@redhat.com>; Sat, 30 Jan 2021 00:45:35 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8C10F88CC41
	for <dm-devel@redhat.com>; Sat, 30 Jan 2021 00:45:35 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-596-YB24OWOqM9alarCMTJoJAw-1;
	Fri, 29 Jan 2021 19:45:31 -0500
X-MC-Unique: YB24OWOqM9alarCMTJoJAw-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 7588820B6C42;
	Fri, 29 Jan 2021 16:45:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7588820B6C42
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Fri, 29 Jan 2021 16:45:19 -0800
Message-Id: <20210130004519.25106-4-tusharsu@linux.microsoft.com>
In-Reply-To: <20210130004519.25106-1-tusharsu@linux.microsoft.com>
References: <20210130004519.25106-1-tusharsu@linux.microsoft.com>
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
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH 3/3] IMA: add support to measure duplicate buffer
	for critical data hook
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

process_buffer_measurement() and the underlying functions do not use the
policy condition to measure duplicate buffer entries for integrity
critical data.

Update process_buffer_measurement(), ima_add_template_entry(), and
ima_store_template() to use the policy condition to decide if a
duplicate buffer entry for integrity critical data should be measured.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 security/integrity/ima/ima.h       | 4 ++--
 security/integrity/ima/ima_api.c   | 9 +++++----
 security/integrity/ima/ima_init.c  | 2 +-
 security/integrity/ima/ima_main.c  | 5 +++--
 security/integrity/ima/ima_queue.c | 5 +++--
 5 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 59324173497f..b06732560949 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -139,7 +139,7 @@ int ima_init(void);
 int ima_fs_init(void);
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode,
-			   const unsigned char *filename);
+			   const unsigned char *filename, bool allow_dup);
 int ima_calc_file_hash(struct file *file, struct ima_digest_data *hash);
 int ima_calc_buffer_hash(const void *buf, loff_t len,
 			 struct ima_digest_data *hash);
@@ -278,7 +278,7 @@ int ima_alloc_init_template(struct ima_event_data *event_data,
 			    struct ima_template_desc *template_desc);
 int ima_store_template(struct ima_template_entry *entry, int violation,
 		       struct inode *inode,
-		       const unsigned char *filename, int pcr);
+		       const unsigned char *filename, int pcr, bool allow_dup);
 void ima_free_template_entry(struct ima_template_entry *entry);
 const char *ima_d_path(const struct path *path, char **pathbuf, char *filename);
 
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index d273373e6be9..f84369f9905e 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -101,7 +101,7 @@ int ima_alloc_init_template(struct ima_event_data *event_data,
  */
 int ima_store_template(struct ima_template_entry *entry,
 		       int violation, struct inode *inode,
-		       const unsigned char *filename, int pcr)
+		       const unsigned char *filename, int pcr, bool allow_dup)
 {
 	static const char op[] = "add_template_measure";
 	static const char audit_cause[] = "hashing_error";
@@ -119,7 +119,8 @@ int ima_store_template(struct ima_template_entry *entry,
 		}
 	}
 	entry->pcr = pcr;
-	result = ima_add_template_entry(entry, violation, op, inode, filename);
+	result = ima_add_template_entry(entry, violation, op, inode, filename,
+					allow_dup);
 	return result;
 }
 
@@ -152,7 +153,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 		goto err_out;
 	}
 	result = ima_store_template(entry, violation, inode,
-				    filename, CONFIG_IMA_MEASURE_PCR_IDX);
+				    filename, CONFIG_IMA_MEASURE_PCR_IDX, false);
 	if (result < 0)
 		ima_free_template_entry(entry);
 err_out:
@@ -330,7 +331,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
 		return;
 	}
 
-	result = ima_store_template(entry, violation, inode, filename, pcr);
+	result = ima_store_template(entry, violation, inode, filename, pcr, false);
 	if ((!result || result == -EEXIST) && !(file->f_flags & O_DIRECT)) {
 		iint->flags |= IMA_MEASURED;
 		iint->measured_pcrs |= (0x1 << pcr);
diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
index 6e8742916d1d..d0a79d7b8d89 100644
--- a/security/integrity/ima/ima_init.c
+++ b/security/integrity/ima/ima_init.c
@@ -88,7 +88,7 @@ static int __init ima_add_boot_aggregate(void)
 
 	result = ima_store_template(entry, violation, NULL,
 				    boot_aggregate_name,
-				    CONFIG_IMA_MEASURE_PCR_IDX);
+				    CONFIG_IMA_MEASURE_PCR_IDX, false);
 	if (result < 0) {
 		ima_free_template_entry(entry);
 		audit_cause = "store_entry";
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 2774139845b6..ff6d15d7594c 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -843,6 +843,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 	int digest_hash_len = hash_digest_size[ima_hash_algo];
 	int violation = 0;
 	int action = 0;
+	bool allow_dup = false;
 	u32 secid;
 
 	if (!ima_policy_flag)
@@ -865,7 +866,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 	if (func) {
 		security_task_getsecid(current, &secid);
 		action = ima_get_action(inode, current_cred(), secid, 0, func,
-					&pcr, &template, func_data, NULL);
+					&pcr, &template, func_data, &allow_dup);
 		if (!(action & IMA_MEASURE))
 			return;
 	}
@@ -903,7 +904,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 		goto out;
 	}
 
-	ret = ima_store_template(entry, violation, NULL, event_data.buf, pcr);
+	ret = ima_store_template(entry, violation, NULL, event_data.buf, pcr, allow_dup);
 	if (ret < 0) {
 		audit_cause = "store_entry";
 		ima_free_template_entry(entry);
diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
index c096ef8945c7..fbf359495fa8 100644
--- a/security/integrity/ima/ima_queue.c
+++ b/security/integrity/ima/ima_queue.c
@@ -158,7 +158,7 @@ static int ima_pcr_extend(struct tpm_digest *digests_arg, int pcr)
  */
 int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 			   const char *op, struct inode *inode,
-			   const unsigned char *filename)
+			   const unsigned char *filename, bool allow_dup)
 {
 	u8 *digest = entry->digests[ima_hash_algo_idx].digest;
 	struct tpm_digest *digests_arg = entry->digests;
@@ -169,7 +169,8 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
 
 	mutex_lock(&ima_extend_list_mutex);
 	if (!violation) {
-		if (ima_lookup_digest_entry(digest, entry->pcr)) {
+		if (!allow_dup &&
+		    ima_lookup_digest_entry(digest, entry->pcr)) {
 			audit_cause = "hash_exists";
 			result = -EEXIST;
 			goto out;
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

