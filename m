From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: [PATCH 1/3] IMA: generalize keyring specific measurement constructs
Date: Wed, 12 Aug 2020 12:31:00 -0700
Message-ID: <20200812193102.18636-2-tusharsu@linux.microsoft.com>
References: <20200812193102.18636-1-tusharsu@linux.microsoft.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200812193102.18636-1-tusharsu@linux.microsoft.com>
Sender: owner-linux-security-module@vger.kernel.org
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, nramas@linux.microsoft.com
List-Id: dm-devel.ids

IMA functions such as ima_match_keyring(), process_buffer_measurement(),
ima_match_policy() etc. handle data specific to keyrings. Currently,
these constructs are not generic to handle any func specific data. 
This makes it harder to extend without code duplication.

Refactor the keyring specific measurement constructs to be generic and
reusable in other measurement scenarios. Rename the parameter "size"
in process_buffer_measurement() to "buf_len" to indicate it is the
length of the buffer pointed by the parameter "buf".

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 security/integrity/ima/ima.h        | 11 ++++----
 security/integrity/ima/ima_api.c    |  6 ++---
 security/integrity/ima/ima_main.c   | 17 ++++++------
 security/integrity/ima/ima_policy.c | 40 +++++++++++++++++------------
 4 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
index 38043074ce5e..e2a151d6653d 100644
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -255,7 +255,7 @@ static inline void ima_process_queued_keys(void) {}
 int ima_get_action(struct inode *inode, const struct cred *cred, u32 secid,
 		   int mask, enum ima_hooks func, int *pcr,
 		   struct ima_template_desc **template_desc,
-		   const char *keyring);
+		   const char *func_data);
 int ima_must_measure(struct inode *inode, int mask, enum ima_hooks func);
 int ima_collect_measurement(struct integrity_iint_cache *iint,
 			    struct file *file, void *buf, loff_t size,
@@ -265,9 +265,10 @@ void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
 			   struct evm_ima_xattr_data *xattr_value,
 			   int xattr_len, const struct modsig *modsig, int pcr,
 			   struct ima_template_desc *template_desc);
-void process_buffer_measurement(struct inode *inode, const void *buf, int size,
-				const char *eventname, enum ima_hooks func,
-				int pcr, const char *keyring);
+void process_buffer_measurement(struct inode *inode, const void *buf,
+				int buf_len, const char *eventname,
+				enum ima_hooks func, int pcr,
+				const char *func_data);
 void ima_audit_measurement(struct integrity_iint_cache *iint,
 			   const unsigned char *filename);
 int ima_alloc_init_template(struct ima_event_data *event_data,
@@ -283,7 +284,7 @@ const char *ima_d_path(const struct path *path, char **pathbuf, char *filename);
 int ima_match_policy(struct inode *inode, const struct cred *cred, u32 secid,
 		     enum ima_hooks func, int mask, int flags, int *pcr,
 		     struct ima_template_desc **template_desc,
-		     const char *keyring);
+		     const char *func_data);
 void ima_init_policy(void);
 void ima_update_policy(void);
 void ima_update_policy_flag(void);
diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
index 4f39fb93f278..af218babd198 100644
--- a/security/integrity/ima/ima_api.c
+++ b/security/integrity/ima/ima_api.c
@@ -170,7 +170,7 @@ void ima_add_violation(struct file *file, const unsigned char *filename,
  * @func: caller identifier
  * @pcr: pointer filled in if matched measure policy sets pcr=
  * @template_desc: pointer filled in if matched measure policy sets template=
- * @keyring: keyring name used to determine the action
+ * @func_data: private data specific to @func, can be NULL.
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
index 8a91711ca79b..a8740b7ea417 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -728,17 +728,18 @@ int ima_load_data(enum kernel_load_data_id id)
  * process_buffer_measurement - Measure the buffer to ima log.
  * @inode: inode associated with the object being measured (NULL for KEY_CHECK)
  * @buf: pointer to the buffer that needs to be added to the log.
- * @size: size of buffer(in bytes).
+ * @buf_len: length of buffer(in bytes).
  * @eventname: event name to be used for the buffer entry.
  * @func: IMA hook
  * @pcr: pcr to extend the measurement
- * @keyring: keyring name to determine the action to be performed
+ * @func_data: private data specific to @func, can be NULL.
  *
  * Based on policy, the buffer is measured into the ima log.
  */
-void process_buffer_measurement(struct inode *inode, const void *buf, int size,
-				const char *eventname, enum ima_hooks func,
-				int pcr, const char *keyring)
+void process_buffer_measurement(struct inode *inode, const void *buf,
+				int buf_len, const char *eventname,
+				enum ima_hooks func, int pcr,
+				const char *func_data)
 {
 	int ret = 0;
 	const char *audit_cause = "ENOMEM";
@@ -747,7 +748,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 	struct ima_event_data event_data = {.iint = &iint,
 					    .filename = eventname,
 					    .buf = buf,
-					    .buf_len = size};
+					    .buf_len = buf_len};
 	struct ima_template_desc *template = NULL;
 	struct {
 		struct ima_digest_data hdr;
@@ -770,7 +771,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 	if (func) {
 		security_task_getsecid(current, &secid);
 		action = ima_get_action(inode, current_cred(), secid, 0, func,
-					&pcr, &template, keyring);
+					&pcr, &template, func_data);
 		if (!(action & IMA_MEASURE))
 			return;
 	}
@@ -795,7 +796,7 @@ void process_buffer_measurement(struct inode *inode, const void *buf, int size,
 	iint.ima_hash->algo = ima_hash_algo;
 	iint.ima_hash->length = hash_digest_size[ima_hash_algo];
 
-	ret = ima_calc_buffer_hash(buf, size, iint.ima_hash);
+	ret = ima_calc_buffer_hash(buf, buf_len, iint.ima_hash);
 	if (ret < 0) {
 		audit_cause = "hashing_error";
 		goto out;
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index fe1df373c113..4efaf8956eb8 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -451,15 +451,21 @@ int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
 }
 
 /**
- * ima_match_keyring - determine whether the keyring matches the measure rule
- * @rule: a pointer to a rule
- * @keyring: name of the keyring to match against the measure rule
+ * ima_match_rule_data - determine whether the given func_data matches
+ *			 the measure rule data
+ * @rule: IMA policy rule
+ * @opt_list: rule data to match func_data against
+ * @func_data: data to match against the measure rule data
+ * @allow_empty_opt_list: If true matches all func_data
  * @cred: a pointer to a credentials structure for user validation
  *
  * Returns true if keyring matches one in the rule, false otherwise.
  */
-static bool ima_match_keyring(struct ima_rule_entry *rule,
-			      const char *keyring, const struct cred *cred)
+static bool ima_match_rule_data(struct ima_rule_entry *rule,
+				const struct ima_rule_opt_list *opt_list,
+				const char *func_data,
+				bool allow_empty_opt_list,
+				const struct cred *cred)
 {
 	bool matched = false;
 	size_t i;
@@ -467,14 +473,14 @@ static bool ima_match_keyring(struct ima_rule_entry *rule,
 	if ((rule->flags & IMA_UID) && !rule->uid_op(cred->uid, rule->uid))
 		return false;
 
-	if (!rule->keyrings)
-		return true;
+	if (!opt_list)
+		return allow_empty_opt_list;
 
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
@@ -491,20 +497,21 @@ static bool ima_match_keyring(struct ima_rule_entry *rule,
  * @secid: the secid of the task to be validated
  * @func: LIM hook identifier
  * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
- * @keyring: keyring name to check in policy for KEY_CHECK func
+ * @func_data: private data specific to @func, can be NULL.
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
+		       ima_match_rule_data(rule, rule->keyrings, func_data,
+					   true, cred);
 	}
 	if ((rule->flags & IMA_FUNC) &&
 	    (rule->func != func && func != POST_SETATTR))
@@ -608,8 +615,7 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
  * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
  * @pcr: set the pcr to extend
  * @template_desc: the template that should be used for this rule
- * @keyring: the keyring name, if given, to be used to check in the policy.
- *           keyring can be NULL if func is anything other than KEY_CHECK.
+ * @func_data: private data specific to @func, can be NULL.
  *
  * Measure decision based on func/mask/fsmagic and LSM(subj/obj/type)
  * conditions.
@@ -621,7 +627,7 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
 int ima_match_policy(struct inode *inode, const struct cred *cred, u32 secid,
 		     enum ima_hooks func, int mask, int flags, int *pcr,
 		     struct ima_template_desc **template_desc,
-		     const char *keyring)
+		     const char *func_data)
 {
 	struct ima_rule_entry *entry;
 	int action = 0, actmask = flags | (flags << 1);
@@ -636,7 +642,7 @@ int ima_match_policy(struct inode *inode, const struct cred *cred, u32 secid,
 			continue;
 
 		if (!ima_match_rules(entry, inode, cred, secid, func, mask,
-				     keyring))
+				     func_data))
 			continue;
 
 		action |= entry->flags & IMA_ACTION_FLAGS;
-- 
2.17.1
