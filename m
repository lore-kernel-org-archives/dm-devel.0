Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEF9FC433E0
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 04:07:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1475E23601
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 04:07:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1475E23601
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-Hc8apkGCP82UHPolURPo1A-1; Thu, 07 Jan 2021 23:07:38 -0500
X-MC-Unique: Hc8apkGCP82UHPolURPo1A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DE77801A9E;
	Fri,  8 Jan 2021 04:07:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 225BA7046E;
	Fri,  8 Jan 2021 04:07:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F28BE4E58E;
	Fri,  8 Jan 2021 04:07:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10847UFR008567 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Jan 2021 23:07:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 863C0114B9BC; Fri,  8 Jan 2021 04:07:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 82551114B9AC
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 04:07:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70305800889
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 04:07:30 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-109-OUCpxX4vOxmtERqFZIprEA-1;
	Thu, 07 Jan 2021 23:07:26 -0500
X-MC-Unique: OUCpxX4vOxmtERqFZIprEA-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id F12E520B6C44;
	Thu,  7 Jan 2021 20:07:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F12E520B6C44
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Thu,  7 Jan 2021 20:07:05 -0800
Message-Id: <20210108040708.8389-6-tusharsu@linux.microsoft.com>
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v10 5/8] IMA: limit critical data measurement
	based on a label
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

Integrity critical data may belong to a single subsystem or it may
arise from cross subsystem interaction.  Currently there is no mechanism
to group or limit the data based on certain label.  Limiting and
grouping critical data based on a label would make it flexible and
configurable to measure.

Define "label:=", a new IMA policy condition, for the IMA func
CRITICAL_DATA to allow grouping and limiting measurement of integrity
critical data.

Limit the measurement to the labels that are specified in the IMA
policy - CRITICAL_DATA+"label:=".  If "label:=" is not provided with
the func CRITICAL_DATA, measure all the input integrity critical data.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
---
 Documentation/ABI/testing/ima_policy |  2 ++
 security/integrity/ima/ima_policy.c  | 37 +++++++++++++++++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index 6ec7daa87cba..54fe1c15ed50 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -52,6 +52,8 @@ Description:
 			template:= name of a defined IMA template type
 			(eg, ima-ng). Only valid when action is "measure".
 			pcr:= decimal value
+			label:= [data_label]
+			data_label:= a unique string used for grouping and limiting critical data.
 
 		  default policy:
 			# PROC_SUPER_MAGIC
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 96ba4273c4d0..2c9db2d0b434 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -34,6 +34,7 @@
 #define IMA_PCR		0x0100
 #define IMA_FSNAME	0x0200
 #define IMA_KEYRINGS	0x0400
+#define IMA_LABEL	0x0800
 
 #define UNKNOWN		0
 #define MEASURE		0x0001	/* same as IMA_MEASURE */
@@ -85,6 +86,7 @@ struct ima_rule_entry {
 	} lsm[MAX_LSM_RULES];
 	char *fsname;
 	struct ima_rule_opt_list *keyrings; /* Measure keys added to these keyrings */
+	struct ima_rule_opt_list *label; /* Measure data grouped under this label */
 	struct ima_template_desc *template;
 };
 
@@ -479,7 +481,11 @@ static bool ima_match_rule_data(struct ima_rule_entry *rule,
 		opt_list = rule->keyrings;
 		break;
 	case CRITICAL_DATA:
-		return true;
+		if (!rule->label)
+			return true;
+
+		opt_list = rule->label;
+		break;
 	default:
 		return false;
 	}
@@ -924,7 +930,7 @@ enum {
 	Opt_uid_lt, Opt_euid_lt, Opt_fowner_lt,
 	Opt_appraise_type, Opt_appraise_flag,
 	Opt_permit_directio, Opt_pcr, Opt_template, Opt_keyrings,
-	Opt_err
+	Opt_label, Opt_err
 };
 
 static const match_table_t policy_tokens = {
@@ -961,6 +967,7 @@ static const match_table_t policy_tokens = {
 	{Opt_pcr, "pcr=%s"},
 	{Opt_template, "template=%s"},
 	{Opt_keyrings, "keyrings=%s"},
+	{Opt_label, "label=%s"},
 	{Opt_err, NULL}
 };
 
@@ -1128,7 +1135,8 @@ static bool ima_validate_rule(struct ima_rule_entry *entry)
 		if (entry->action & ~(MEASURE | DONT_MEASURE))
 			return false;
 
-		if (entry->flags & ~(IMA_FUNC | IMA_UID | IMA_PCR))
+		if (entry->flags & ~(IMA_FUNC | IMA_UID | IMA_PCR |
+				     IMA_LABEL))
 			return false;
 
 		if (ima_rule_contains_lsm_cond(entry))
@@ -1338,6 +1346,23 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 
 			entry->flags |= IMA_KEYRINGS;
 			break;
+		case Opt_label:
+			ima_log_string(ab, "label", args[0].from);
+
+			if (entry->label) {
+				result = -EINVAL;
+				break;
+			}
+
+			entry->label = ima_alloc_rule_opt_list(args);
+			if (IS_ERR(entry->label)) {
+				result = PTR_ERR(entry->label);
+				entry->label = NULL;
+				break;
+			}
+
+			entry->flags |= IMA_LABEL;
+			break;
 		case Opt_fsuuid:
 			ima_log_string(ab, "fsuuid", args[0].from);
 
@@ -1718,6 +1743,12 @@ int ima_policy_show(struct seq_file *m, void *v)
 		seq_puts(m, " ");
 	}
 
+	if (entry->flags & IMA_LABEL) {
+		seq_puts(m, "label=");
+		ima_show_rule_opt_list(m, entry->label);
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

