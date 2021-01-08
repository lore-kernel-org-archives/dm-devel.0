Return-Path: <SRS0=H596=GL=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB4C7C433E0
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 04:07:55 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 426C123601
	for <dm-devel@archiver.kernel.org>; Fri,  8 Jan 2021 04:07:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 426C123601
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-556-VJXmpIs-OB2Qs3pMaJmk9Q-1; Thu, 07 Jan 2021 23:07:52 -0500
X-MC-Unique: VJXmpIs-OB2Qs3pMaJmk9Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E923192AB73;
	Fri,  8 Jan 2021 04:07:48 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3426512D7E;
	Fri,  8 Jan 2021 04:07:48 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0C5191809CA0;
	Fri,  8 Jan 2021 04:07:48 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10847VCY008582 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 7 Jan 2021 23:07:31 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 459ADD7DE3; Fri,  8 Jan 2021 04:07:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3ABFAD7DE8
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 04:07:28 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D086F858280
	for <dm-devel@redhat.com>; Fri,  8 Jan 2021 04:07:28 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-163-IMySD7rAOKOOWn9epeet9Q-1;
	Thu, 07 Jan 2021 23:07:24 -0500
X-MC-Unique: IMySD7rAOKOOWn9epeet9Q-1
Received: from tusharsu-Ubuntu.lan (c-71-197-163-6.hsd1.wa.comcast.net
	[71.197.163.6])
	by linux.microsoft.com (Postfix) with ESMTPSA id AC33020B6C40;
	Thu,  7 Jan 2021 20:07:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com AC33020B6C40
From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com,
	casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com,
	gmazyland@gmail.com, paul@paul-moore.com
Date: Thu,  7 Jan 2021 20:07:01 -0800
Message-Id: <20210108040708.8389-2-tusharsu@linux.microsoft.com>
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
Subject: [dm-devel] [PATCH v10 1/8] IMA: generalize keyring specific
	measurement constructs
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

IMA functions such as ima_match_keyring(), process_buffer_measurement(),
ima_match_policy() etc.  handle data specific to keyrings.  Currently,
these constructs are not generic to handle any func specific data.
This makes it harder to extend them without code duplication.

Refactor the keyring specific measurement constructs to be generic and
reusable in other measurement scenarios.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Reviewed-by: Tyler Hicks <tyhicks@linux.microsoft.com>
---
 security/integrity/ima/ima.h        |  6 ++--
 security/integrity/ima/ima_api.c    |  6 ++--
 security/integrity/ima/ima_main.c   |  6 ++--
 security/integrity/ima/ima_policy.c | 43 +++++++++++++++++------------
 4 files changed, 35 insertions(+), 26 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 8e8b1e3cb847..e5622ce8cbb1 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -256,7 +256,7 @@ static inline void ima_process_queued_keys(void) {}
 int ima_get_action(struct inode *inode, const struct cred *cred, u32 secid,
 		   int mask, enum ima_hooks func, int *pcr,
 		   struct ima_template_desc **template_desc,
-		   const char *keyring);
+		   const char *func_data);
 int ima_must_measure(struct inode *inode, int mask, enum ima_hooks func);
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file, void *buf, loff_t size,
@@ -268,7 +268,7 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   struct ima_template_desc *template_desc);
 void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 				const char *eventname, enum ima_hooks func,
-				int pcr, const char *keyring);
+				int pcr, const char *func_data);
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename);
 int ima_alloc_init_template(struct ima_event_data *event_data,
@@ -284,7 +284,7 @@ const char *ima_d_path(const struct path *path, char **pathbuf, char *filename);
 int ima_match_policy(struct inode *inode, const struct cred *cred, u32 secid,
 		     enum ima_hooks func, int mask, int flags, int *pcr,
 		     struct ima_template_desc **template_desc,
-		     const char *keyring);
+		     const char *func_data);
 void ima_init_policy(void);
 void ima_update_policy(void);
 void ima_update_policy_flag(void);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 4f39fb93f278..e76499b1ce78 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -170,7 +170,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
  * @func: caller identifier
  * @pcr: pointer filled in if matched measure policy sets pcr=
  * @template_desc: pointer filled in if matched measure policy sets template=
- * @keyring: keyring name used to determine the action
+ * @func_data: func specific data, may be NULL
  *
  * The policy is defined in terms of keypairs:
  *		subj=, obj=, type=, func=, mask=, fsmagic=
@@ -186,14 +186,14 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
 int ima_get_action(struct inode *inode, const struct cred *cred, u32 secid,
 		   int mask, enum ima_hooks func, int *pcr,
 		   struct ima_template_desc **template_desc,
-		   const char *keyring)
+		   const char *func_data)
 {
 	int flags = IMA_MEASURE | IMA_AUDIT | IMA_APPRAISE | IMA_HASH;
 
 	flags &= ima_policy_flag;
 
 	return ima_match_policy(inode, cred, secid, func, mask, flags, pcr,
-				template_desc, keyring);
+				template_desc, func_data);
 }
 
 /*
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 68956e884403..b4ed611cd2a4 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -786,13 +786,13 @@ int ima_post_load_data(char *buf, loff_t size,
  * @eventname: event name to be used for the buffer entry.
  * @func: IMA hook
  * @pcr: pcr to extend the measurement
- * @keyring: keyring name to determine the action to be performed
+ * @func_data: func specific data, may be NULL
  *
  * Based on policy, the buffer is measured into the ima log.
  */
 void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 				const char *eventname, enum ima_hooks func,
-				int pcr, const char *keyring)
+				int pcr, const char *func_data)
 {
 	int ret = 0;
 	const char *audit_cause = "ENOMEM";
@@ -831,7 +831,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 	if (func) {
 		security_task_getsecid(current, &secid);
 		action = ima_get_action(inode, current_cred(), secid, 0, func,
-					&pcr, &template, keyring);
+					&pcr, &template, func_data);
 		if (!(action & IMA_MEASURE))
 			return;
 	}
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 823a0c1379cb..b93966034368 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -453,30 +453,40 @@ int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
 }
 
 /**
- * ima_match_keyring - determine whether the keyring matches the measure rule
+ * ima_match_rule_data - determine whether func_data matches the policy rule
  * @rule: a pointer to a rule
- * @keyring: name of the keyring to match against the measure rule
+ * @func_data: data to match against the measure rule data
  * @cred: a pointer to a credentials structure for user validation
  *
- * Returns true if keyring matches one in the rule, false otherwise.
+ * Returns true if func_data matches one in the rule, false otherwise.
  */
-static bool ima_match_keyring(struct ima_rule_entry *rule,
-			      const char *keyring, const struct cred *cred)
+static bool ima_match_rule_data(struct ima_rule_entry *rule,
+				const char *func_data,
+				const struct cred *cred)
 {
+	const struct ima_rule_opt_list *opt_list = NULL;
 	bool matched = false;
 	size_t i;
 
 	if ((rule->flags & IMA_UID) && !rule->uid_op(cred->uid, rule->uid))
 		return false;
 
-	if (!rule->keyrings)
-		return true;
+	switch (rule->func) {
+	case KEY_CHECK:
+		if (!rule->keyrings)
+			return true;
+
+		opt_list = rule->keyrings;
+		break;
+	default:
+		return false;
+	}
 
-	if (!keyring)
+	if (!func_data)
 		return false;
 
-	for (i = 0; i < rule->keyrings->count; i++) {
-		if (!strcmp(rule->keyrings->items[i], keyring)) {
+	for (i = 0; i < opt_list->count; i++) {
+		if (!strcmp(opt_list->items[i], func_data)) {
 			matched = true;
 			break;
 		}
@@ -493,20 +503,20 @@ static bool ima_match_keyring(struct ima_rule_entry *rule,
  * @secid: the secid of the task to be validated
  * @func: LIM hook identifier
  * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
- * @keyring: keyring name to check in policy for KEY_CHECK func
+ * @func_data: func specific data, may be NULL
  *
  * Returns true on rule match, false on failure.
  */
 static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 			    const struct cred *cred, u32 secid,
 			    enum ima_hooks func, int mask,
-			    const char *keyring)
+			    const char *func_data)
 {
 	int i;
 
 	if (func == KEY_CHECK) {
 		return (rule->flags & IMA_FUNC) && (rule->func == func) &&
-		       ima_match_keyring(rule, keyring, cred);
+			ima_match_rule_data(rule, func_data, cred);
 	}
 	if ((rule->flags & IMA_FUNC) &&
 	    (rule->func != func && func != POST_SETATTR))
@@ -610,8 +620,7 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
  * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
  * @pcr: set the pcr to extend
  * @template_desc: the template that should be used for this rule
- * @keyring: the keyring name, if given, to be used to check in the policy.
- *           keyring can be NULL if func is anything other than KEY_CHECK.
+ * @func_data: func specific data, may be NULL
  *
  * Measure decision based on func/mask/fsmagic and LSM(subj/obj/type)
  * conditions.
@@ -623,7 +632,7 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
 int ima_match_policy(struct inode *inode, const struct cred *cred, u32 secid,
 		     enum ima_hooks func, int mask, int flags, int *pcr,
 		     struct ima_template_desc **template_desc,
-		     const char *keyring)
+		     const char *func_data)
 {
 	struct ima_rule_entry *entry;
 	int action = 0, actmask = flags | (flags << 1);
@@ -638,7 +647,7 @@ int ima_match_policy(struct inode *inode, const struct cred *cred, u32 secid,
 			continue;
 
 		if (!ima_match_rules(entry, inode, cred, secid, func, mask,
-				     keyring))
+				     func_data))
 			continue;
 
 		action |= entry->flags & IMA_ACTION_FLAGS;
-- 
2.17.1

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

