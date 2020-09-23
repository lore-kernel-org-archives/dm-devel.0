From: Tushar Sugandhi <tusharsu@linux.microsoft.com>
Subject: [PATCH v4 2/6] IMA: conditionally allow empty rule data
Date: Wed, 23 Sep 2020 12:20:07 -0700
Message-ID: <20200923192011.5293-3-tusharsu@linux.microsoft.com>
References: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20200923192011.5293-1-tusharsu@linux.microsoft.com>
To: zohar@linux.ibm.com, stephen.smalley.work@gmail.com, casey@schaufler-ca.com, agk@redhat.com, snitzer@redhat.com, gmazyland@gmail.com
Cc: tyhicks@linux.microsoft.com, sashal@kernel.org, jmorris@namei.org, nramas@linux.microsoft.com, linux-integrity@vger.kernel.org, selinux@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

ima_match_rule_data() permits the func to pass empty func_data.
For instance, for the following func, the func_data keyrings= is
optional.
    measure func=KEY_CHECK keyrings=.ima

But a new func in future may want to constrain the func_data to
be non-empty.  ima_match_rule_data() should support this constraint
and it shouldn't be hard-coded in ima_match_rule_data().

Update ima_match_rule_data() to conditionally allow empty func_data
for the func that needs it.

Signed-off-by: Tushar Sugandhi <tusharsu@linux.microsoft.com>
---
 security/integrity/ima/ima_policy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 31a772d8a86b..8866e84d0062 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -456,6 +456,7 @@ int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
  * @rule: IMA policy rule
  * @opt_list: rule data to match func_data against
  * @func_data: data to match against the measure rule data
+ * @allow_empty_opt_list: If true matches all func_data
  * @cred: a pointer to a credentials structure for user validation
  *
  * Returns true if func_data matches one in the rule, false otherwise.
@@ -463,6 +464,7 @@ int ima_lsm_policy_change(struct notifier_block *nb, unsigned long event,
 static bool ima_match_rule_data(struct ima_rule_entry *rule,
 				const struct ima_rule_opt_list *opt_list,
 				const char *func_data,
+				bool allow_empty_opt_list,
 				const struct cred *cred)
 {
 	bool matched = false;
@@ -472,7 +474,7 @@ static bool ima_match_rule_data(struct ima_rule_entry *rule,
 		return false;
 
 	if (!opt_list)
-		return true;
+		return allow_empty_opt_list;
 
 	if (!func_data)
 		return false;
@@ -509,7 +511,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 	if (func == KEY_CHECK) {
 		return (rule->flags & IMA_FUNC) && (rule->func == func) &&
 		       ima_match_rule_data(rule, rule->keyrings, func_data,
-					   cred);
+					   true, cred);
 	}
 	if ((rule->flags & IMA_FUNC) &&
 	    (rule->func != func && func != POST_SETATTR))
-- 
2.17.1
