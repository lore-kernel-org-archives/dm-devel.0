Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1437CC433DB
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 04:07:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 876EA236FB
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 04:07:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 876EA236FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-P1Awm4zYNq-MwZc8BcQIrQ-1; Thu, 07 Jan 2021 23:07:38 -0500
X-MC-Unique: P1Awm4zYNq-MwZc8BcQIrQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD780800D53;
	Fri,  8 Jan 2021 04:07:33 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D06519D7D;
	Fri,  8 Jan 2021 04:07:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 06C724E590;
	Fri,  8 Jan 2021 04:07:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10847V4a008583 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Jan 2021 23:07:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 469C6D7DE5; Fri,  8 Jan 2021 04:07:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F310D7DE2
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 04:07:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22A58811E78
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 04:07:31 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-544-7lgT3IWvNWKR97ftAuFcpA-1;
	Thu, 07 Jan 2021 23:07:26 -0500
X-MC-Unique: 7lgT3IWvNWKR97ftAuFcpA-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 892ED20B6C45;
	Thu,  7 Jan 2021 20:07:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 892ED20B6C45
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Thu,  7 Jan 2021 20:07:06 -0800
Message-Id: <20210108040708.8389-7-tusharsu@linux.microsoft.com>
In-Reply-To: <20210108040708.8389-1-tusharsu@linux.microsoft.com>
References: <20210108040708.8389-1-tusharsu@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v10 6/8] IMA: extend critical data hook to limit
	the measurement based on a label
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

The IMA hook ima_measure_critical_data() does not support a way to
specify the source of the critical data provider.  Thus, the data
measurement cannot be constrained based on the data source label
in the IMA policy.

Extend the IMA hook ima_measure_critical_data() to support passing 
the data source label as an input parameter, so that the policy rule can
be used to limit the measurements based on the label.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
---
 include/linux/ima.h               | 7 +++++--
 security/integrity/ima/ima_main.c | 8 +++++---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/ima.h b/include/linux/ima.h
index 37a0727c1c31..6d00542de135 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -30,7 +30,8 @@ extern int ima_post_read_file(struct file *file, void *buf, loff_t size,
 extern void ima_post_path_mknod(struct dentry *dentry);
 extern int ima_file_hash(struct file *file, char *buf, size_t buf_size);
 extern void ima_kexec_cmdline(int kernel_fd, const void *buf, int size);
-extern void ima_measure_critical_data(const char *event_name,
+extern void ima_measure_critical_data(const char *event_label,
+				      const char *event_name,
 				      const void *buf, size_t buf_len,
 				      bool hash);
 
@@ -126,9 +127,11 @@ static inline int ima_file_hash(struct file *file, char *buf, size_t buf_size)
 
 static inline void ima_kexec_cmdline(int kernel_fd, const void *buf, int size) {}
 
-static inline void ima_measure_critical_data(const char *event_name,
+static inline void ima_measure_critical_data(const char *event_label,
+					     const char *event_name,
 					     const void *buf, size_t buf_len,
 					     bool hash) {}
+
 #endif /* CONFIG_IMA */
 
 #ifndef CONFIG_IMA_KEXEC
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index ef37307e79dd..edfb1367a11d 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -915,6 +915,7 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
 
 /**
  * ima_measure_critical_data - measure kernel integrity critical data
+ * @event_label: unique event label for grouping and limiting critical data
  * @event_name: event name for the record in the IMA measurement list
  * @buf: pointer to buffer data
  * @buf_len: length of buffer data (in bytes)
@@ -925,15 +926,16 @@ void ima_kexec_cmdline(int kernel_fd, const void *buf, int size)
  * structures, policies, and states stored in kernel memory that can
  * impact the integrity of the system.
  */
-void ima_measure_critical_data(const char *event_name,
+void ima_measure_critical_data(const char *event_label,
+			       const char *event_name,
 			       const void *buf, size_t buf_len,
 			       bool hash)
 {
-	if (!event_name || !buf || !buf_len)
+	if (!event_name || !event_label || !buf || !buf_len)
 		return;
 
 	process_buffer_measurement(NULL, buf, buf_len, event_name,
-				   CRITICAL_DATA, 0, NULL,
+				   CRITICAL_DATA, 0, event_label,
 				   hash);
 }
 
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

