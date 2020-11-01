Return-Path: <SRS0=kRAg=EI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F341FC388F2
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5AFD72222B
	for <dm-devel@archiver.kernel.org>; Mon,  2 Nov 2020 07:58:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AFD72222B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-Ru5xBamrOCqJRSig6S9_WQ-1; Mon, 02 Nov 2020 02:58:11 -0500
X-MC-Unique: Ru5xBamrOCqJRSig6S9_WQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 86996802B46;
	Mon,  2 Nov 2020 07:58:06 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A6B55C1C2;
	Mon,  2 Nov 2020 07:58:06 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E112A1800B72;
	Mon,  2 Nov 2020 07:58:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0A1MQl3x029392 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 1 Nov 2020 17:26:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C3DD933239; Sun,  1 Nov 2020 22:26:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BEC803323C
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E41F858280
	for <dm-devel@redhat.com>; Sun,  1 Nov 2020 22:26:44 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-415-5mhAmR_TOMidjHREeRWocA-1;
	Sun, 01 Nov 2020 17:26:39 -0500
X-MC-Unique: 5mhAmR_TOMidjHREeRWocA-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id A228920C1713;
	Sun,  1 Nov 2020 14:26:38 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A228920C1713
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Sun,  1 Nov 2020 14:26:25 -0800
Message-Id: <20201101222626.6111-7-tusharsu@linux.microsoft.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 02 Nov 2020 02:58:01 -0500
Cc: sashal@kernel.org, dm-devel@redhat.com, selinux@vger.kernel.org,
	jmorris@namei.org, linux-kernel@vger.kernel.org,
	nramas@linux.microsoft.com, linux-security-module@vger.kernel.org,
	tyhicks@linux.microsoft.com, linux-integrity@vger.kernel.org
Subject: [dm-devel] [PATCH v5 6/7] IMA: add critical_data to the built-in
	policy rules
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>

The IMA hook to measure kernel critical data, namely
ima_measure_critical_data(), could be called before a custom IMA policy
is loaded. For example, SELinux calls ima_measure_critical_data() to
measure its state and policy when they are initialized. This occurs
before a custom IMA policy is loaded, and hence IMA hook will not
measure the data. A built-in policy is therefore needed to measure
critical data provided by callers before a custom IMA policy is loaded.

Add CRITICAL_DATA to built-in IMA rules if the kernel command line
contains "ima_policy=critical_data". Set the IMA template for this rule
to "ima-buf" since ima_measure_critical_data() measures a buffer.

Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
---
 security/integrity/ima/ima_policy.c | 32 +++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index ec99e0bb6c6f..dc8fe969d3fe 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -206,6 +206,10 @@ static struct ima_rule_entry secure_boot_rules[] __ro_after_init = {
 	 .flags = IMA_FUNC | IMA_DIGSIG_REQUIRED},
 };
 
+static struct ima_rule_entry critical_data_rules[] __ro_after_init = {
+	{.action = MEASURE, .func = CRITICAL_DATA, .flags = IMA_FUNC},
+};
+
 /* An array of architecture specific rules */
 static struct ima_rule_entry *arch_policy_entry __ro_after_init;
 
@@ -228,6 +232,7 @@ __setup("ima_tcb", default_measure_policy_setup);
 
 static bool ima_use_appraise_tcb __initdata;
 static bool ima_use_secure_boot __initdata;
+static bool ima_use_critical_data __ro_after_init;
 static bool ima_fail_unverifiable_sigs __ro_after_init;
 static int __init policy_setup(char *str)
 {
@@ -242,6 +247,8 @@ static int __init policy_setup(char *str)
 			ima_use_appraise_tcb = true;
 		else if (strcmp(p, "secure_boot") == 0)
 			ima_use_secure_boot = true;
+		else if (strcmp(p, "critical_data") == 0)
+			ima_use_critical_data = true;
 		else if (strcmp(p, "fail_securely") == 0)
 			ima_fail_unverifiable_sigs = true;
 		else
@@ -813,6 +820,8 @@ static int __init ima_init_arch_policy(void)
 void __init ima_init_policy(void)
 {
 	int build_appraise_entries, arch_entries;
+	struct ima_template_desc *template = NULL;
+	int ret = 0;
 
 	/* if !ima_policy, we load NO default rules */
 	if (ima_policy)
@@ -875,6 +884,29 @@ void __init ima_init_policy(void)
 			  ARRAY_SIZE(default_appraise_rules),
 			  IMA_DEFAULT_POLICY);
 
+	if (ima_use_critical_data) {
+		template = lookup_template_desc("ima-buf");
+		if (!template) {
+			ret = -EINVAL;
+			goto out;
+		}
+
+		ret = template_desc_init_fields(template->fmt,
+						&(template->fields),
+						&(template->num_fields));
+		if (ret)
+			goto out;
+
+		critical_data_rules[0].template = template;
+		add_rules(critical_data_rules,
+			  ARRAY_SIZE(critical_data_rules),
+			  IMA_DEFAULT_POLICY);
+	}
+
+out:
+	if (ret)
+		pr_err("%s failed, result: %d\n", __func__, ret);
+
 	ima_update_policy_flag();
 }
 
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

