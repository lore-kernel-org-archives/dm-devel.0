Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F151C4742C
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 808F221556
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 808F221556
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-jpy3R9q_MAGwy7JZFgLZ6g-1; Mon, 02 Nov 2020 02:58:35 -0500
X-MC-Unique: jpy3R9q_MAGwy7JZFgLZ6g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67B5D1006CA7;
	Mon,  2 Nov 2020 07:58:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4760A5E9D0;
	Mon,  2 Nov 2020 07:58:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E9CAA181A06C;
	Mon,  2 Nov 2020 07:58:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A1MQhxX029355 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 17:26:43 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4BE83202348A; Sun,  1 Nov 2020 22:26:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 477F420235B7
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:43 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1F81C8D632D
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:43 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-284-1a1dvGTmMKeO9oHg6Vr8SA-1;
	Sun, 01 Nov 2020 17:26:38 -0500
X-MC-Unique: 1a1dvGTmMKeO9oHg6Vr8SA-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id 743722089EFD;
	Sun,  1 Nov 2020 14:26:37 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 743722089EFD
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Sun,  1 Nov 2020 14:26:23 -0800
Message-Id: <20201101222626.6111-5-tusharsu@linux.microsoft.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 02 Nov 2020 02:58:01 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v5 4/7] IMA: add policy to measure critical data
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

System administrators should be able to choose which kernel subsystems
they want to measure the critical data for. To enable that, an IMA policy
option to choose specific kernel subsystems is needed. This policy option
would constrain the measurement of the critical data to the given kernel
subsystems.

Add a new IMA policy option - "data_sources:=" to the IMA func 
CRITICAL_DATA to allow measurement of various kernel subsystems. This
policy option would enable the system administrators to limit the
measurement to the subsystems listed in "data_sources:=", if the 
subsystem measures its data by calling ima_measure_critical_data().

Limit the measurement to the subsystems that are specified in the IMA
policy - CRITICAL_DATA+"data_sources:=". If "data_sources:=" is not
provided with the func CRITICAL_DATA, measure the data from all the
supported kernel subsystems.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 Documentation/ABI/testing/ima_policy |  4 ++
 security/integrity/ima/ima_policy.c  | 62 +++++++++++++++++++++++++---
 2 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 3de6c774c37e..15be8b16f6f3 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -48,6 +48,10 @@ Description:
 			template:= name of a defined IMA template type
 			(eg, ima-ng). Only valid when action is "measure".
 			pcr:= decimal value
+			data_sources:= list of kernel subsystems that contain
+			kernel in-memory data critical to the integrity of the kernel.
+			Only valid when action is "measure" and func is
+			CRITICAL_DATA.
 
 		default policy:
 			# PROC_SUPER_MAGIC
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index f48e82450fe1..ec99e0bb6c6f 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -34,6 +34,7 @@
 #define IMA_PCR		0x0100
 #define IMA_FSNAME	0x0200
 #define IMA_KEYRINGS	0x0400
+#define IMA_DATA_SOURCES	0x0800
 
 #define UNKNOWN		0
 #define MEASURE		0x0001	/* same as IMA_MEASURE */
@@ -85,6 +86,7 @@ struct ima_rule_entry {
 	} lsm[MAX_LSM_RULES];
 	char *fsname;
 	struct ima_rule_opt_list *keyrings; /* Measure keys added to these keyrings */
+	struct ima_rule_opt_list *data_sources; /* Measure data from these sources */
 	struct ima_template_desc *template;
 };
 
@@ -479,6 +481,12 @@ static bool ima_match_rule_data(struct ima_rule_entry *rule,
 		else
 			opt_list = rule->keyrings;
 		break;
+	case CRITICAL_DATA:
+		if (!rule->data_sources)
+			return true;
+		else
+			opt_list = rule->data_sources;
+		break;
 	default:
 		break;
 	}
@@ -518,13 +526,19 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 {
 	int i;
 
-	if (func == KEY_CHECK) {
-		return (rule->flags & IMA_FUNC) && (rule->func == func) &&
-			ima_match_rule_data(rule, func_data, cred);
-	}
 	if ((rule->flags & IMA_FUNC) &&
 	    (rule->func != func && func != POST_SETATTR))
 		return false;
+
+	switch (func) {
+	case KEY_CHECK:
+	case CRITICAL_DATA:
+		return ((rule->func == func) &&
+			ima_match_rule_data(rule, func_data, cred));
+	default:
+		break;
+	}
+
 	if ((rule->flags & IMA_MASK) &&
 	    (rule->mask != mask && func != POST_SETATTR))
 		return false;
@@ -920,7 +934,7 @@ enum {
 	Opt_uid_lt, Opt_euid_lt, Opt_fowner_lt,
 	Opt_appraise_type, Opt_appraise_flag,
 	Opt_permit_directio, Opt_pcr, Opt_template, Opt_keyrings,
-	Opt_err
+	Opt_data_sources, Opt_err
 };
 
 static const match_table_t policy_tokens = {
@@ -957,6 +971,7 @@ static const match_table_t policy_tokens = {
 	{Opt_pcr, "pcr=%s"},
 	{Opt_template, "template=%s"},
 	{Opt_keyrings, "keyrings=%s"},
+	{Opt_data_sources, "data_sources=%s"},
 	{Opt_err, NULL}
 };
 
@@ -1119,6 +1134,19 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 		if (ima_rule_contains_lsm_cond(entry))
 			return false;
 
+		break;
+	case CRITICAL_DATA:
+		if (entry->action & ~(MEASURE | DONT_MEASURE))
+			return false;
+
+		if (!(entry->flags & IMA_DATA_SOURCES) ||
+		    (entry->flags & ~(IMA_FUNC | IMA_UID | IMA_PCR |
+		    IMA_DATA_SOURCES)))
+			return false;
+
+		if (ima_rule_contains_lsm_cond(entry))
+			return false;
+
 		break;
 	default:
 		return false;
@@ -1323,6 +1351,24 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 
 			entry->flags |= IMA_KEYRINGS;
 			break;
+		case Opt_data_sources:
+			ima_log_string(ab, "data_sources",
+				       args[0].from);
+
+			if (entry->data_sources) {
+				result = -EINVAL;
+				break;
+			}
+
+			entry->data_sources = ima_alloc_rule_opt_list(args);
+			if (IS_ERR(entry->data_sources)) {
+				result = PTR_ERR(entry->data_sources);
+				entry->data_sources = NULL;
+				break;
+			}
+
+			entry->flags |= IMA_DATA_SOURCES;
+			break;
 		case Opt_fsuuid:
 			ima_log_string(ab, "fsuuid", args[0].from);
 
@@ -1703,6 +1749,12 @@ int ima_policy_show(struct seq_file *m, void *v)
 		seq_puts(m, " ");
 	}
 
+	if (entry->flags & IMA_DATA_SOURCES) {
+		seq_puts(m, "data_sources=");
+		ima_show_rule_opt_list(m, entry->data_sources);
+		seq_puts(m, " ");
+	}
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

