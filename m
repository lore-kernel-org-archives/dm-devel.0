Return-Path: <SRS0=6nCw=HB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F06C433E6
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jan 2021 00:45:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1181964E0F
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jan 2021 00:45:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1181964E0F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-tfxtS70fPjOto7HA7GLD8g-1; Fri, 29 Jan 2021 19:45:45 -0500
X-MC-Unique: tfxtS70fPjOto7HA7GLD8g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51D04802B42;
	Sat, 30 Jan 2021 00:45:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 68AF56F7E7;
	Sat, 30 Jan 2021 00:45:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id AF6231809C9F;
	Sat, 30 Jan 2021 00:45:38 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10U0jbCr011383 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 29 Jan 2021 19:45:37 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 00EC22166B2C; Sat, 30 Jan 2021 00:45:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EF5942166B27
	for <dm-devel@redhat.com>; Sat, 30 Jan 2021 00:45:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 829BC800BFF
	for <dm-devel@redhat.com>; Sat, 30 Jan 2021 00:45:34 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-375-9bF3_-DLOc6KOKAQsuiWIg-1;
	Fri, 29 Jan 2021 19:45:30 -0500
X-MC-Unique: 9bF3_-DLOc6KOKAQsuiWIg-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 233C620B6C40;
	Fri, 29 Jan 2021 16:45:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 233C620B6C40
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Fri, 29 Jan 2021 16:45:17 -0800
Message-Id: <20210130004519.25106-2-tusharsu@linux.microsoft.com>
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
Subject: [dm-devel] [PATCH 1/3] IMA: add policy condition to measure
	duplicate critical data
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

IMA needs to support duplicate measurements of integrity
critical data to accurately determine the current state of that data
on the system.  Further, since measurement of duplicate data is not
required for all the use cases, it needs to be policy driven.

Define "allow_dup", a new IMA policy condition, for the IMA func
CRITICAL_DATA to allow duplicate buffer measurement of integrity
critical data.

Limit the ability to measure duplicate buffer data when action is
"measure" and func is CRITICAL_DATA.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 Documentation/ABI/testing/ima_policy |  4 +++-
 security/integrity/ima/ima_policy.c  | 24 ++++++++++++++++++++++--
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index bc8e1cbe5e61..9598287e3bbf 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -27,7 +27,7 @@ Description:
 			lsm:	[[subj_user=] [subj_role=] [subj_type=]
 				 [obj_user=] [obj_role=] [obj_type=]]
 			option:	[[appraise_type=]] [template=] [permit_directio]
-				[appraise_flag=] [keyrings=]
+				[appraise_flag=] [keyrings=] [allow_dup]
 		  base:
 			func:= [BPRM_CHECK][MMAP_CHECK][CREDS_CHECK][FILE_CHECK]MODULE_CHECK]
 			        [FIRMWARE_CHECK]
@@ -55,6 +55,8 @@ Description:
 			label:= [selinux]|[kernel_info]|[data_label]
 			data_label:= a unique string used for grouping and limiting critical data.
 			For example, "selinux" to measure critical data for SELinux.
+			allow_dup allows measurement of duplicate data.  Only valid
+			when action is "measure" and func is CRITICAL_DATA.
 
 		  default policy:
 			# PROC_SUPER_MAGIC
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 9b45d064a87d..b89eb768dd05 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -35,6 +35,7 @@
 #define IMA_FSNAME	0x0200
 #define IMA_KEYRINGS	0x0400
 #define IMA_LABEL	0x0800
+#define IMA_ALLOW_DUP	0x1000
 
 #define UNKNOWN		0
 #define MEASURE		0x0001	/* same as IMA_MEASURE */
@@ -87,6 +88,7 @@ struct ima_rule_entry {
 	char *fsname;
 	struct ima_rule_opt_list *keyrings; /* Measure keys added to these keyrings */
 	struct ima_rule_opt_list *label; /* Measure data grouped under this label */
+	bool allow_dup; /* Allow duplicate buffer entry measurement */
 	struct ima_template_desc *template;
 };
 
@@ -942,7 +944,7 @@ enum {
 	Opt_uid_lt, Opt_euid_lt, Opt_fowner_lt,
 	Opt_appraise_type, Opt_appraise_flag,
 	Opt_permit_directio, Opt_pcr, Opt_template, Opt_keyrings,
-	Opt_label, Opt_err
+	Opt_label, Opt_allow_dup, Opt_err
 };
 
 static const match_table_t policy_tokens = {
@@ -980,6 +982,7 @@ static const match_table_t policy_tokens = {
 	{Opt_template, "template=%s"},
 	{Opt_keyrings, "keyrings=%s"},
 	{Opt_label, "label=%s"},
+	{Opt_allow_dup, "allow_dup"},
 	{Opt_err, NULL}
 };
 
@@ -1148,7 +1151,7 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 			return false;
 
 		if (entry->flags & ~(IMA_FUNC | IMA_UID | IMA_PCR |
-				     IMA_LABEL))
+				     IMA_LABEL | IMA_ALLOW_DUP))
 			return false;
 
 		if (ima_rule_contains_lsm_cond(entry))
@@ -1184,6 +1187,7 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 	entry->uid_op = &uid_eq;
 	entry->fowner_op = &uid_eq;
 	entry->action = UNKNOWN;
+	entry->allow_dup = false;
 	while ((p = strsep(&rule, " \t")) != NULL) {
 		substring_t args[MAX_OPT_ARGS];
 		int token;
@@ -1375,6 +1379,19 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 
 			entry->flags |= IMA_LABEL;
 			break;
+		case Opt_allow_dup:
+			ima_log_string(ab, "allow_dup", NULL);
+
+			if ((entry->func != CRITICAL_DATA) ||
+			    (entry->action != MEASURE)) {
+				result = -EINVAL;
+				break;
+			}
+
+			entry->allow_dup = true;
+
+			entry->flags |= IMA_ALLOW_DUP;
+			break;
 		case Opt_fsuuid:
 			ima_log_string(ab, "fsuuid", args[0].from);
 
@@ -1761,6 +1778,9 @@ int ima_policy_show(struct seq_file *m, void *v)
 		seq_puts(m, " ");
 	}
 
+	if (entry->flags & IMA_ALLOW_DUP)
+		seq_puts(m, "allow_dup");
+
 	if (entry->flags & IMA_PCR) {
 		snprintf(tbuf, sizeof(tbuf), "%d", entry->pcr);
 		seq_printf(m, pt(Opt_pcr), tbuf);
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

