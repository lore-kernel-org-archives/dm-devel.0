From: deven.desai@linux.microsoft.com
Subject: [RESEND PATCH 02/11] security: add ipe lsm
Date: Mon,  6 Apr 2020 11:10:36 -0700
Message-ID: <20200406181045.1024164-3-deven.desai@linux.microsoft.com>
References: <20200406181045.1024164-1-deven.desai@linux.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200406181045.1024164-1-deven.desai@linux.microsoft.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, axboe@kernel.dk, snitzer@redhat.com, jmorris@namei.org, serge@hallyn.com, zohar@linux.ibm.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, dm-devel@redhat.com, linux-block@vger.kernel.org
Cc: sashal@kernel.org, pasha.tatashin@soleen.com, mdsakib@linux.microsoft.com, nramas@linux.microsoft.com, tyhicks@linux.microsoft.com, jaskarankhurana@linux.microsoft.com
List-Id: dm-devel.ids

From: Deven Bowers <deven.desai@linux.microsoft.com>

Add the Integrity Policy Enforcement LSM, a LSM designed to provide
guarantees of the integrity of executable code for highly-locked down
systems.

This includes a tool for generation of an IPE policy to be compiled into
the kernel, which will be enforced until the policy is changed via userland
policy deployment.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---
 MAINTAINERS                      |   7 +
 include/uapi/linux/audit.h       |   4 +
 security/Kconfig                 |  12 +-
 security/Makefile                |   2 +
 security/ipe/.gitignore          |   2 +
 security/ipe/Kconfig             |  41 ++
 security/ipe/Makefile            |  29 +
 security/ipe/ipe-audit.c         | 313 +++++++++++
 security/ipe/ipe-audit.h         |  76 +++
 security/ipe/ipe-engine.c        | 344 ++++++++++++
 security/ipe/ipe-engine.h        |  49 ++
 security/ipe/ipe-hooks.c         | 151 ++++++
 security/ipe/ipe-hooks.h         | 114 ++++
 security/ipe/ipe-parse.c         | 898 +++++++++++++++++++++++++++++++
 security/ipe/ipe-parse.h         |  35 ++
 security/ipe/ipe-policy.c        | 181 +++++++
 security/ipe/ipe-policy.h        | 116 ++++
 security/ipe/ipe-prop-internal.h |  43 ++
 security/ipe/ipe-property.c      | 112 ++++
 security/ipe/ipe-property.h      | 159 ++++++
 security/ipe/ipe-secfs.c         | 814 ++++++++++++++++++++++++++++
 security/ipe/ipe-secfs.h         |  25 +
 security/ipe/ipe-sysfs.c         | 203 +++++++
 security/ipe/ipe-sysfs.h         |  21 +
 security/ipe/ipe.c               | 112 ++++
 security/ipe/ipe.h               |  21 +
 26 files changed, 3878 insertions(+), 6 deletions(-)
 create mode 100644 security/ipe/.gitignore
 create mode 100644 security/ipe/Kconfig
 create mode 100644 security/ipe/Makefile
 create mode 100644 security/ipe/ipe-audit.c
 create mode 100644 security/ipe/ipe-audit.h
 create mode 100644 security/ipe/ipe-engine.c
 create mode 100644 security/ipe/ipe-engine.h
 create mode 100644 security/ipe/ipe-hooks.c
 create mode 100644 security/ipe/ipe-hooks.h
 create mode 100644 security/ipe/ipe-parse.c
 create mode 100644 security/ipe/ipe-parse.h
 create mode 100644 security/ipe/ipe-policy.c
 create mode 100644 security/ipe/ipe-policy.h
 create mode 100644 security/ipe/ipe-prop-internal.h
 create mode 100644 security/ipe/ipe-property.c
 create mode 100644 security/ipe/ipe-property.h
 create mode 100644 security/ipe/ipe-secfs.c
 create mode 100644 security/ipe/ipe-secfs.h
 create mode 100644 security/ipe/ipe-sysfs.c
 create mode 100644 security/ipe/ipe-sysfs.h
 create mode 100644 security/ipe/ipe.c
 create mode 100644 security/ipe/ipe.h

diff --git a/MAINTAINERS b/MAINTAINERS
index eeff55560759..ab9adcd37a0c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8437,6 +8437,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
 S:	Supported
 F:	security/integrity/ima/
 
+INTEGRITY POLICY ENFORCEMENT (IPE)
+M:	Deven Bowers <deven.desai@linux.microsoft.com>
+L:	linux-integrity@vger.kernel.org
+S:	Supported
+F:	scripts/ipe/
+F:	security/ipe/
+
 INTEL 810/815 FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
 L:	linux-fbdev@vger.kernel.org
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index a534d71e689a..4e0122a0ed0c 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -153,6 +153,10 @@
 #define AUDIT_INTEGRITY_RULE	    1805 /* policy rule */
 #define AUDIT_INTEGRITY_EVM_XATTR   1806 /* New EVM-covered xattr */
 #define AUDIT_INTEGRITY_POLICY_RULE 1807 /* IMA policy rules */
+#define AUDIT_INTEGRITY_POLICY_LOAD	1808 /* IPE Policy Load */
+#define AUDIT_INTEGRITY_POLICY_ACTIVATE	1809 /* IPE Policy Activation */
+#define AUDIT_INTEGRITY_EVENT		1810 /* IPE Evaluation Event */
+#define AUDIT_INTEGRITY_MODE		1811 /* IPE Mode Switch */
 
 #define AUDIT_KERNEL		2000	/* Asynchronous audit record. NOT A REQUEST. */
 
diff --git a/security/Kconfig b/security/Kconfig
index cd3cc7da3a55..94924556b637 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -238,6 +238,7 @@ source "security/loadpin/Kconfig"
 source "security/yama/Kconfig"
 source "security/safesetid/Kconfig"
 source "security/lockdown/Kconfig"
+source "security/ipe/Kconfig"
 
 source "security/integrity/Kconfig"
 
@@ -277,11 +278,11 @@ endchoice
 
 config LSM
 	string "Ordered list of enabled LSMs"
-	default "lockdown,yama,loadpin,safesetid,integrity,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
-	default "lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
-	default "lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
-	default "lockdown,yama,loadpin,safesetid,integrity,bpf" if DEFAULT_SECURITY_DAC
-	default "lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"
+	default "lockdown,yama,loadpin,ipe,safesetid,integrity,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
+	default "lockdown,yama,loadpin,ipe,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
+	default "lockdown,yama,loadpin,ipe,safesetid,integrity,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
+	default "lockdown,yama,loadpin,ipe,safesetid,integrity,bpf" if DEFAULT_SECURITY_DAC
+	default "lockdown,yama,loadpin,ipe,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"
 	help
 	  A comma-separated list of LSMs, in initialization order.
 	  Any LSMs left off this list will be ignored. This can be
@@ -292,4 +293,3 @@ config LSM
 source "security/Kconfig.hardening"
 
 endmenu
-
diff --git a/security/Makefile b/security/Makefile
index 22e73a3482bd..f2e1ae9ff64b 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -13,6 +13,7 @@ subdir-$(CONFIG_SECURITY_LOADPIN)	+= loadpin
 subdir-$(CONFIG_SECURITY_SAFESETID)    += safesetid
 subdir-$(CONFIG_SECURITY_LOCKDOWN_LSM)	+= lockdown
 subdir-$(CONFIG_BPF_LSM)		+= bpf
+subdir-$(CONFIG_SECURITY_IPE)		+= ipe
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -30,6 +31,7 @@ obj-$(CONFIG_SECURITY_YAMA)		+= yama/
 obj-$(CONFIG_SECURITY_LOADPIN)		+= loadpin/
 obj-$(CONFIG_SECURITY_SAFESETID)       += safesetid/
 obj-$(CONFIG_SECURITY_LOCKDOWN_LSM)	+= lockdown/
+obj-$(CONFIG_SECURITY_IPE)		+= ipe/
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 obj-$(CONFIG_BPF_LSM)			+= bpf/
 
diff --git a/security/ipe/.gitignore b/security/ipe/.gitignore
new file mode 100644
index 000000000000..bbf824e665d7
--- /dev/null
+++ b/security/ipe/.gitignore
@@ -0,0 +1,2 @@
+# Generated Boot Policy
+ipe-bp.c
diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
new file mode 100644
index 000000000000..ef6fb019be6f
--- /dev/null
+++ b/security/ipe/Kconfig
@@ -0,0 +1,41 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Integrity Policy Enforcement (IPE) configuration
+#
+
+menuconfig SECURITY_IPE
+	bool "Integrity Policy Enforcement (IPE)"
+	depends on SECURITY && AUDIT && SECURITYFS
+	select SYSTEM_DATA_VERIFICATION
+	help
+	  This option enables the Integrity Policy Enforcement subsystem,
+	  allowing systems to enforce integrity requirements on various
+	  aspects of user-mode applications. These requirements are
+	  controlled by a policy.
+
+	  If unsure, answer N.
+
+if SECURITY_IPE
+
+config SECURITY_IPE_BOOT_POLICY
+	string "Integrity policy to apply on system startup"
+	help
+	  This option specifies a filepath to a IPE policy that is compiled
+	  into the kernel. This policy will be enforced until a policy update
+	  is deployed via the "ipe.policy" sysctl.
+
+	  If unsure, leave blank.
+
+config SECURITY_IPE_PERMISSIVE_SWITCH
+	bool "Enable the ability to switch IPE to permissive mode"
+	default y
+	help
+	  This option enables two ways of switching IPE to permissive mode,
+	  a sysctl (if enabled), `ipe.enforce`, or a kernel command line
+	  parameter, `ipe.enforce`. If either of these are set to 0, files
+	  will be subject to IPE's policy, audit messages will be logged, but
+	  the policy will not be enforced.
+
+	  If unsure, answer Y.
+
+endif
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
new file mode 100644
index 000000000000..4dcfc5b26b58
--- /dev/null
+++ b/security/ipe/Makefile
@@ -0,0 +1,29 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) Microsoft Corporation. All rights reserved.
+#
+# Makefile for building the IPE module as part of the kernel tree.
+#
+
+quiet_cmd_polgen  = IPE_POL $(patsubst "%",%,$(2))
+      cmd_polgen  = scripts/ipe/polgen/polgen security/ipe/ipe-bp.c $(2)
+
+$(eval $(call config_filename,SECURITY_IPE_BOOT_POLICY))
+
+targets += ipe-bp.c
+$(obj)/ipe-bp.c: scripts/ipe/polgen/polgen $(SECURITY_IPE_BOOT_POLICY_FILENAME) FORCE
+	$(call if_changed,polgen,$(SECURITY_IPE_BOOT_POLICY_FILENAME))
+
+obj-$(CONFIG_SECURITY_IPE) += \
+	ipe.o \
+	ipe-audit.o \
+	ipe-bp.o \
+	ipe-engine.o \
+	ipe-parse.o \
+	ipe-policy.o \
+	ipe-property.o \
+	ipe-hooks.o \
+	ipe-secfs.o \
+	ipe-sysfs.o \
+
+clean-files := ipe-bp.c
diff --git a/security/ipe/ipe-audit.c b/security/ipe/ipe-audit.c
new file mode 100644
index 000000000000..f83beff1054f
--- /dev/null
+++ b/security/ipe/ipe-audit.c
@@ -0,0 +1,313 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ipe-audit.h"
+#include "ipe-engine.h"
+#include "ipe-prop-internal.h"
+
+#include <linux/types.h>
+#include <linux/audit.h>
+#include <linux/rcupdate.h>
+#include <linux/lsm_audit.h>
+#include <linux/rbtree.h>
+#include <crypto/hash.h>
+#include <crypto/sha1_base.h>
+
+#define ACTION_STR(a) ((a) == ipe_action_allow ? "ALLOW" : "DENY")
+
+#define POLICY_LOAD_FSTR	"IPE policy_name=\"%s\" policy_version=%hu.%hu.%hu sha1="
+#define POLICY_ACTIVATE_STR	"IPE policy_name=\"%s\" policy_version=%hu.%hu.%hu"
+#define IPE_UNKNOWN		"UNKNOWN"
+
+/* Keep in sync with ipe_op in ipe-hooks.h */
+const char *audit_op_names[] = {
+	IPE_OP_EXECUTE,
+	IPE_OP_FIRMWARE,
+	IPE_OP_KEXEC_IMAGE,
+	IPE_OP_KEXEC_INITRAMFS,
+	IPE_OP_X509_CERTIFICATE,
+	IPE_OP_POLICY,
+	IPE_OP_KMODULE,
+	IPE_OP_KERNEL_READ,
+	IPE_UNKNOWN,
+};
+
+/* Keep in sync with ipe_hook in ipe-hooks.h */
+const char *audit_hook_names[] = {
+	IPE_HOOK_EXEC,
+	IPE_HOOK_MMAP,
+	IPE_HOOK_MPROTECT,
+	IPE_HOOK_KERNEL_READ,
+	IPE_HOOK_KERNEL_LOAD,
+	IPE_UNKNOWN,
+};
+
+/**
+ * ipe_audit_mode: Emit an audit event indicating what mode IPE is currently
+ *		   in.
+ *
+ * This event is of form "IPE mode=(enforce|audit)"
+ */
+void ipe_audit_mode(void)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(audit_context(), GFP_ATOMIC | __GFP_NOWARN,
+			     AUDIT_INTEGRITY_MODE);
+	if (!ab)
+		return;
+
+	audit_log_format(ab, "IPE mode=%s", (enforce) ? IPE_MODE_ENFORCE :
+							IPE_MODE_PERMISSIVE);
+
+	audit_log_end(ab);
+}
+
+/**
+ * audit_engine_ctx: Add the string representation of ipe_engine_ctx to the
+ *		     end of an audit buffer.
+ * @ab: the audit buffer to append the string representation of @ctx
+ * @ctx: the ipe_engine_ctx structure to transform into a string
+ *	 representation
+ *
+ * This string representation is of form:
+ * "ctx_pid=%d ctx_op=%s ctx_hook=%s ctx_comm=%s ctx_audit_pathname=%s ctx_ino=%ld ctx_dev=%s"
+ *
+ * Certain fields may be omitted or replaced with ERR(%d).
+ *
+ */
+static void audit_engine_ctx(struct audit_buffer *ab,
+			     const struct ipe_engine_ctx *ctx)
+{
+	audit_log_format(ab, "ctx_pid=%d ctx_op=%s ctx_hook=%s ctx_comm=",
+			 task_tgid_nr(current),
+			 audit_op_names[ctx->op],
+			 audit_hook_names[ctx->hook]);
+
+	audit_log_untrustedstring(ab, current->comm);
+
+	if (ctx->file) {
+		if (IS_ERR(ctx->audit_pathname)) {
+			audit_log_format(ab, " ctx_audit_pathname=ERR(%ld) ",
+					 PTR_ERR(ctx->audit_pathname));
+		} else {
+			audit_log_format(ab, " ctx_audit_pathname=\"%s\" ",
+					 ctx->audit_pathname);
+		}
+
+		audit_log_format(ab, "ctx_ino=%ld ctx_dev=%s",
+				 ctx->file->f_inode->i_ino,
+				 ctx->file->f_inode->i_sb->s_id);
+	}
+}
+
+/**
+ * audit_eval_properties: Append the string representation of evaluated
+ *			  properties to an audit buffer.
+ * @ab: the audit buffer to append the string representation of the evaluated
+ *	properties.
+ * @ctx: the ipe_engine_ctx structure to pass to property audit function.
+ * @vals: The root of the red-black tree that is the per-evaluation
+ *	  cache for IPE's properties.
+ *
+ * This string representation is of form:
+ * "prop_key1=value1 prop_key2=value2 ... "
+ *
+ * Certain values may be replaced with ERR(%d). Prop may also be empty,
+ * and thus omitted entirely.
+ *
+ */
+static void audit_eval_properties(struct audit_buffer *ab,
+				  const struct ipe_engine_ctx *ctx,
+				  const struct rb_root *vals)
+{
+	struct rb_node *node;
+	struct ipe_prop_cache *val;
+
+	for (node = rb_first(vals); node; node = rb_next(node)) {
+		val = container_of(node, struct ipe_prop_cache, node);
+
+		audit_log_format(ab, "prop_%s=", val->prop->property_name);
+
+		val->prop->ctx_audit(ab, ctx, val->storage);
+
+		audit_log_format(ab, " ");
+	}
+}
+
+/**
+ * audit_rule: Add the string representation of a non-default IPE rule to the
+ *	       end of an audit buffer.
+ * @ab: the audit buffer to append the string representation of a rule.
+ * @rule: the ipe_rule structure to transform into a string representation.
+ *
+ * This string representation is of form:
+ * "rule={op=%s key1=value1 key2=value2 ... action=%s}"
+ *
+ * Certain values may be replaced with ERR(%d). Prop may also be empty.
+ *
+ */
+static void audit_rule(struct audit_buffer *ab,
+		       const struct ipe_rule *rule)
+{
+	struct ipe_prop_container *ptr;
+
+	audit_log_format(ab, "rule=\"op=%s ", audit_op_names[rule->op]);
+
+	list_for_each_entry(ptr, &rule->props, next) {
+		audit_log_format(ab, "%s=", ptr->prop->property_name);
+
+		ptr->prop->rule_audit(ab, ptr->value);
+
+		audit_log_format(ab, " ");
+	}
+
+	audit_log_format(ab, "action=%s\"", ACTION_STR(rule->action));
+}
+
+/**
+ * ipe_audit_match: Emit an audit event indicating that the IPE engine has
+ *		    determined a match to a rule in IPE policy.
+ * @ctx: the engine context structure to audit
+ * @vals: The root of the red-black tree that is the per-evaluation
+ *	  cache for IPE's properties.
+ * @rule: The rule that was matched. If NULL, then assumed to be a default
+ *	  either operation specific, indicated by table, or global.
+ * @table: the operation-specific rule table. If NULL, then it assumed
+ *	   that the global default is matched.
+ * @match_type: The type of match that the engine used during evaluation
+ * @action: The action that the engine decided to take
+ * @rule: The rule that was matched. Must be set if @match_type is
+ *	  ipe_match_rule and NULL otherwise.
+ */
+void ipe_audit_match(const struct ipe_engine_ctx *ctx,
+		     const struct rb_root *vals, enum ipe_match match_type,
+		     enum ipe_action action, const struct ipe_rule *rule)
+{
+	struct audit_buffer *ab;
+
+	if (!success_audit && action == ipe_action_allow)
+		return;
+
+	ab = audit_log_start(audit_context(), GFP_ATOMIC | __GFP_NOWARN,
+			     AUDIT_INTEGRITY_EVENT);
+	if (!ab)
+		return;
+
+	audit_log_format(ab, "IPE ");
+
+	audit_engine_ctx(ab, ctx);
+
+	audit_log_format(ab, " ");
+
+	audit_eval_properties(ab, ctx, vals);
+
+	if (match_type == ipe_match_rule)
+		audit_rule(ab, rule);
+	else if (match_type == ipe_match_table)
+		audit_log_format(ab, "rule=\"DEFAULT op=%s action=%s\"",
+				 audit_op_names[ctx->op], ACTION_STR(action));
+	else if (match_type == ipe_match_global)
+		audit_log_format(ab, "rule=\"DEFAULT action=%s\"",
+				 ACTION_STR(action));
+
+	audit_log_end(ab);
+}
+
+/**
+ * ipe_audit_policy_load: Emit an audit event that an IPE policy has been
+ *			  loaded, with the name of the policy, the policy
+ *			  version triple, and a flat hash of the content.
+ * @pol: The parsed policy to derive the policy_name and policy_version
+ *	 triple.
+ * @raw: The raw content that was passed to the ipe.policy sysctl to derive
+ *	 the sha1 hash.
+ * @raw_size: the length of @raw.
+ * @tfm: shash structure allocated by the caller, used to fingerprint the
+ *	 policy being deployed
+ */
+void ipe_audit_policy_load(const struct ipe_policy *pol, const uint8_t *raw,
+			   size_t raw_size, struct crypto_shash *tfm)
+{
+	int rc = 0;
+	struct audit_buffer *ab;
+	u8 digest[SHA1_DIGEST_SIZE];
+	SHASH_DESC_ON_STACK(desc, tfm);
+
+	ab = audit_log_start(audit_context(), GFP_ATOMIC | __GFP_NOWARN,
+			     AUDIT_INTEGRITY_POLICY_LOAD);
+	if (!ab)
+		return;
+
+	audit_log_format(ab, POLICY_LOAD_FSTR, pol->policy_name,
+			 pol->policy_version.major, pol->policy_version.minor,
+			 pol->policy_version.rev);
+
+	desc->tfm = tfm;
+
+	if (crypto_shash_init(desc) != 0)
+		goto err;
+
+	if (crypto_shash_update(desc, raw, raw_size) != 0)
+		goto err;
+
+	if (crypto_shash_final(desc, digest) != 0)
+		goto err;
+
+	audit_log_n_hex(ab, digest, crypto_shash_digestsize(tfm));
+
+err:
+	if (rc != 0)
+		audit_log_format(ab, "ERR(%d)", rc);
+
+	audit_log_end(ab);
+}
+
+/**
+ * ipe_audit_unset_remap: Emit an warning indicating that the operation
+ *			  represented by @op is unset and will implicitly
+ *			  allow everything under that op.
+ * @op: the operation to emit an audit message for.
+ */
+void ipe_audit_unset_remap(enum ipe_op op)
+{
+	pr_warn("op=%s default was unset, remapping to \"DEFAULT op=%s action=ALLOW\" for compatibility",
+		audit_op_names[op],
+		audit_op_names[op]);
+}
+
+/**
+ * ipe_audit_ignore_line: Emit a warning that the line was not understood by
+ *			  IPE's parser and the line will be ignored and not
+ *			  parsed.
+ * @line_num: line number that is being ignored.
+ */
+void ipe_audit_ignore_line(size_t i)
+{
+	pr_warn("failed to parse line number %zu, ignoring", i);
+}
+
+/**
+ * ipe_audit_policy_activation: Emit an audit event that a specific policy
+ *				was activated as the active policy.
+ * @pol: policy that is being activated
+ */
+void ipe_audit_policy_activation(const struct ipe_policy *pol)
+{
+	struct audit_buffer *ab;
+
+	ab = audit_log_start(audit_context(), GFP_ATOMIC | __GFP_NOWARN,
+			     AUDIT_INTEGRITY_POLICY_ACTIVATE);
+
+	if (!ab)
+		return;
+
+	audit_log_format(ab, POLICY_ACTIVATE_STR, pol->policy_name,
+			 pol->policy_version.major, pol->policy_version.minor,
+			 pol->policy_version.rev);
+
+	audit_log_end(ab);
+}
diff --git a/security/ipe/ipe-audit.h b/security/ipe/ipe-audit.h
new file mode 100644
index 000000000000..adb427e0e027
--- /dev/null
+++ b/security/ipe/ipe-audit.h
@@ -0,0 +1,76 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe-engine.h"
+#include "ipe-policy.h"
+
+#ifndef IPE_AUDIT_H
+#define IPE_AUDIT_H
+
+/**
+ * ipe_audit_mode: Emit an audit event indicating what mode IPE is current in.
+ *
+ * This event is of form "IPE mode=(enforce|audit)"
+ */
+void ipe_audit_mode(void);
+
+/**
+ * ipe_audit_match: Emit an audit event indicating that the IPE engine has
+ *		    determined a match to a rule in IPE policy.
+ * @ctx: the engine context structure to audit
+ * @vals: The root of the red-black tree that is the per-evaluation
+ *	  cache for IPE's properties.
+ * @rule: The rule that was matched. If NULL, then assumed to be a default
+ *	  either operation specific, indicated by table, or global.
+ * @table: the operation-specific rule table. If NULL, then it assumed
+ *	   that the global default is matched.
+ * @match_type: The type of match that the engine used during evaluation
+ * @action: The action that the engine decided to take
+ * @rule: The rule that was matched. Must be set if @match_type is
+ *	  ipe_match_rule and NULL otherwise.
+ */
+void ipe_audit_match(const struct ipe_engine_ctx *ctx,
+		     const struct rb_root *vals, enum ipe_match match_type,
+		     enum ipe_action action, const struct ipe_rule *rule);
+
+/**
+ * ipe_audit_policy_load: Emit an audit event that an IPE policy has been
+ *			  loaded, with the name of the policy, the policy
+ *			  version triple, and a flat hash of the content.
+ * @pol: The parsed policy to derive the policy_name and policy_version
+ *	 triple.
+ * @raw: The raw content that was passed to the ipe.policy sysctl to derive
+ *	 the sha1 hash.
+ * @raw_size: the length of @raw.
+ * @tfm: shash structure allocated by the caller, used to fingerprint the
+ *	 policy being deployed
+ */
+void ipe_audit_policy_load(const struct ipe_policy *pol, const uint8_t *raw,
+			   size_t raw_size, struct crypto_shash *tfm);
+
+/**
+ * ipe_audit_unset_remap: Emit an warning indicating that the operation
+ *			  represented by @op is unset and will implicitly
+ *			  allow everything under that op.
+ * @op: the operation to emit an audit message for.
+ */
+void ipe_audit_unset_remap(enum ipe_op op);
+
+/**
+ * ipe_audit_ignore_line: Emit a warning that the line was not understood by
+ *			  IPE's parser and the line will be ignored and not
+ *			  parsed.
+ * @line_num: line number that is being ignored.
+ */
+void ipe_audit_ignore_line(size_t line_num);
+
+/**
+ * ipe_audit_policy_activation: Emit an audit event that a specific policy
+ *				was activated as the active policy.
+ * @pol: policy that is being activated
+ */
+void ipe_audit_policy_activation(const struct ipe_policy *pol);
+
+#endif /* IPE_AUDIT_H */
diff --git a/security/ipe/ipe-engine.c b/security/ipe/ipe-engine.c
new file mode 100644
index 000000000000..3e05fa911e71
--- /dev/null
+++ b/security/ipe/ipe-engine.c
@@ -0,0 +1,344 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ipe-property.h"
+#include "ipe-prop-internal.h"
+#include "ipe-policy.h"
+#include "ipe-engine.h"
+#include "ipe-audit.h"
+
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/list.h>
+#include <linux/rbtree.h>
+#include <linux/rcupdate.h>
+#include <linux/security.h>
+
+/**
+ * get_audit_pathname: Return the absolute path of the file struct passed in
+ * @file: file to derive an absolute path from.
+ *
+ * This function walks past chroots and mount points.
+ *
+ * Return:
+ * !NULL - OK
+ * ERR_PTR(-ENOENT) - No File
+ * ERR_PTR(-ENOMEM) - No Memory
+ * ERR_PTR(-ENAMETOOLONG) - Path Exceeds PATH_MAX
+ */
+static char *get_audit_pathname(const struct file *file)
+{
+	int rc = 0;
+	char *pos = NULL;
+	char *pathbuf = NULL;
+	struct super_block *sb;
+	char *temp_path = NULL;
+
+	/* No File to get Path From */
+	if (!file) {
+		rc = -ENOENT;
+		goto err;
+	}
+
+	sb = file->f_path.dentry->d_sb;
+
+	pathbuf = __getname();
+	if (!pathbuf) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	pos = d_absolute_path(&file->f_path, pathbuf, PATH_MAX);
+	if (IS_ERR(pos)) {
+		rc = PTR_ERR(pos);
+		goto err;
+	}
+
+	temp_path = __getname();
+	if (!temp_path) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	strlcpy(temp_path, pos, PATH_MAX);
+
+	if (pathbuf)
+		__putname(pathbuf);
+
+	return temp_path;
+err:
+	if (pathbuf)
+		__putname(pathbuf);
+	if (temp_path)
+		__putname(temp_path);
+
+	return ERR_PTR(rc);
+}
+
+/**
+ * free_ctx: free a previously allocated ipe_engine_ctx struct
+ * @ctx: structure to allocate.
+ *
+ * The caller is required to free @ctx, if previously allocated.
+ */
+static void free_ctx(struct ipe_engine_ctx *ctx)
+{
+	if (IS_ERR_OR_NULL(ctx))
+		return;
+
+	if (!IS_ERR_OR_NULL(ctx->audit_pathname))
+		__putname(ctx->audit_pathname);
+
+	kfree(ctx);
+}
+
+/**
+ * build_ctx: allocate a new ipe_engine_ctx structure
+ * @file: File that is being evaluated against IPE policy.
+ * @op: Operation that the file is being evaluated against.
+ * @hook: Specific hook that the file is being evaluated through.
+ *
+ * Return:
+ * !NULL - OK
+ * ERR_PTR(-ENOMEM) - no memory
+ */
+static struct ipe_engine_ctx *build_ctx(const struct file *file,
+					enum ipe_op op, enum ipe_hook hook)
+{
+	struct ipe_engine_ctx *local;
+
+	local = kzalloc(sizeof(*local), GFP_KERNEL);
+	if (!local)
+		return ERR_PTR(-ENOMEM);
+
+	/* if there's an error here, it's O.K. */
+	local->audit_pathname = get_audit_pathname(file);
+	local->file = file;
+	local->op = op;
+	local->hook = hook;
+
+	return local;
+}
+
+/**
+ * insert_or_find_cache: Create a node in a for a property if it does not exist,
+ *			 If it does exist, then return that node.
+ * @cache: the red-black tree root to create a tree around.
+ * @prop: the property to create a node for.
+ * @rv: ERR_PTR or the ipe_prop_cache structure that was inserted into the
+ *	tree.
+ *
+ * These nodes are used to be as a cache for properties to store expensive
+ * evaluation results
+ *
+ * Return:
+ * -ENOMEM: (No Memory)
+ */
+static
+struct ipe_prop_cache *insert_or_find_cache(struct rb_root *cache,
+					    const struct ipe_property *prop)
+{
+	struct rb_node *parent = NULL;
+	struct rb_node **new = &cache->rb_node;
+	struct ipe_prop_cache *new_data = NULL;
+
+	while (*new) {
+		int r;
+		struct ipe_prop_cache *n =
+			container_of(*new, struct ipe_prop_cache, node);
+
+		parent = *new;
+
+		r = strcmp(prop->property_name, n->prop->property_name);
+		if (r == 0)
+			return n;
+		else if (r > 0)
+			new = &((*new)->rb_right);
+		else
+			new = &((*new)->rb_left);
+	}
+
+	new_data = kzalloc(sizeof(*new_data), GFP_KERNEL);
+	if (!new_data)
+		return ERR_PTR(-ENOMEM);
+
+	new_data->prop = prop;
+
+	rb_link_node(&new_data->node, parent, new);
+	rb_insert_color(&new_data->node, cache);
+
+	return new_data;
+}
+
+/**
+ * destroy_cache: dellocate an entire cache tree, where each node was
+ *		  created via `insert_or_find_cache`.
+ * @cache: the red-black tree root containing the structure to destroy.
+ *
+ * This function invalidates @cache, as the nodes are not removed from
+ * the tree.
+ */
+static void destroy_cache(struct rb_root *cache)
+{
+	struct ipe_prop_cache *ptr, *n;
+
+	rbtree_postorder_for_each_entry_safe(ptr, n, cache, node) {
+		if (ptr->prop->free_storage)
+			ptr->prop->free_storage(&ptr->storage);
+		kfree(ptr);
+	}
+}
+
+/**
+ * prealloc_cache: preallocate the cache tree for all ipe properties, so
+ *		   that this data maybe used later in the read side critical
+ *		   section.
+ * @ctx: Ipe engine context structure passed to the property prealloc function.
+ * @cache: Root of the cache tree to insert nodes under.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM - Out of memory
+ * Other - See individual property preallocator functions.
+ */
+static int prealloc_cache(struct ipe_engine_ctx *ctx,
+			  struct rb_root *cache)
+{
+	int rc = 0;
+	struct rb_node *node;
+	struct ipe_prop_reg *reg;
+	struct ipe_prop_cache *storage;
+
+	for (node = rb_first(&ipe_registry_root); node; node = rb_next(node)) {
+		reg = container_of(node, struct ipe_prop_reg, node);
+
+		storage = insert_or_find_cache(cache, reg->prop);
+		if (IS_ERR(storage))
+			return PTR_ERR(storage);
+
+		if (reg->prop->prealloc) {
+			rc = reg->prop->prealloc(ctx, &storage->storage);
+			if (rc != 0)
+				return rc;
+		}
+	}
+
+	return rc;
+}
+
+/**
+ * evaluate: Process an @ctx against IPE's current active policy.
+ * @ctx: the engine ctx to perform an evaluation on.
+ * @cache: the red-black tree root that is used for cache storage.
+ *
+ * This uses a preallocated @cache as storage for the properties to avoid
+ * re-evaulation.
+ *
+ * Return:
+ * -EACCES - A match occurred against a "action=DENY" rule
+ * -ENOMEM - Out of memory
+ */
+static int evaluate(struct ipe_engine_ctx *ctx, struct rb_root *cache)
+{
+	int rc = 0;
+	bool match = false;
+	enum ipe_action action;
+	struct ipe_prop_cache *c;
+	enum ipe_match match_type;
+	const struct ipe_rule *rule;
+	const struct ipe_policy *pol;
+	const struct ipe_rule_table *rules;
+	const struct ipe_prop_container *prop;
+
+	if (!ipe_active_policy)
+		return rc;
+
+	rcu_read_lock();
+
+	pol = rcu_dereference(ipe_active_policy);
+
+	rules = &pol->ops[ctx->op];
+
+	list_for_each_entry(rule, &rules->rules, next) {
+		match = true;
+
+		list_for_each_entry(prop, &rule->props, next) {
+			void *cache = NULL;
+
+			if (prop->prop->prealloc) {
+				c = insert_or_find_cache(cache, prop->prop);
+				if (IS_ERR(c))
+					return PTR_ERR(c);
+
+				cache = c->storage;
+			}
+
+			match = match && prop->prop->eval(ctx, prop->value,
+							  &cache);
+		}
+
+		if (match)
+			break;
+	}
+
+	if (match) {
+		match_type = ipe_match_rule;
+		action = rule->action;
+	} else if (rules->def != ipe_action_unset) {
+		match_type = ipe_match_table;
+		action = rules->def;
+		rule = NULL;
+	} else {
+		match_type = ipe_match_global;
+		action = pol->def;
+		rule = NULL;
+	}
+
+	ipe_audit_match(ctx, cache, match_type, action, rule);
+
+	if (action == ipe_action_deny)
+		rc = -EACCES;
+
+	if (enforce == 0)
+		rc = 0;
+
+	rcu_read_unlock();
+	return rc;
+}
+
+/**
+ * ipe_process_event: Perform an evaluation of @file, @op, and @hook against
+ *		      IPE's current active policy.
+ * @file: File that is being evaluated against IPE policy.
+ * @op: Operation that the file is being evaluated against.
+ * @hook: Specific hook that the file is being evaluated through.
+ *
+ * Return:
+ * -ENOMEM: (No Memory)
+ * -EACCES: (A match occurred against a "action=DENY" rule)
+ */
+int ipe_process_event(const struct file *file, enum ipe_op op,
+		      enum ipe_hook hook)
+{
+	int rc = 0;
+	struct ipe_engine_ctx *ctx;
+	struct rb_root cache = RB_ROOT;
+
+	ctx = build_ctx(file, op, hook);
+	if (IS_ERR(ctx))
+		goto cleanup;
+
+	rc = prealloc_cache(ctx, &cache);
+	if (rc != 0)
+		goto cleanup;
+
+	rc = evaluate(ctx, &cache);
+
+cleanup:
+	free_ctx(ctx);
+	destroy_cache(&cache);
+	return rc;
+}
diff --git a/security/ipe/ipe-engine.h b/security/ipe/ipe-engine.h
new file mode 100644
index 000000000000..3f7c471929e2
--- /dev/null
+++ b/security/ipe/ipe-engine.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe-hooks.h"
+
+#include <linux/types.h>
+#include <linux/rbtree.h>
+#include <linux/fs.h>
+
+#ifndef IPE_ENGINE_H
+#define IPE_ENGINE_H
+
+struct ipe_engine_ctx {
+	enum ipe_op op;
+	enum ipe_hook hook;
+	const struct file *file;
+	const char *audit_pathname;
+};
+
+struct ipe_prop_cache {
+	struct rb_node node;
+	void *storage;
+	const struct ipe_property *prop;
+};
+
+enum ipe_match {
+	ipe_match_rule = 0,
+	ipe_match_table,
+	ipe_match_global
+};
+
+/**
+ * ipe_process_event: Perform an evaluation of @file, @op, and @hook against
+ *		      IPE's current active policy.
+ *
+ * @ctx: the engine ctx to perform an evaluation on.
+ * @cache: the red-black tree root that is used for cache storage.
+ * @rv: standard return code.
+ *
+ * Return:
+ * -ENOMEM: (No Memory)
+ * -EACCES: (A match occurred against a "action=DENY" rule)
+ */
+int ipe_process_event(const struct file *file, enum ipe_op op,
+		      enum ipe_hook hook);
+
+#endif /* IPE_ENGINE_H */
diff --git a/security/ipe/ipe-hooks.c b/security/ipe/ipe-hooks.c
new file mode 100644
index 000000000000..a5d37b87c0cd
--- /dev/null
+++ b/security/ipe/ipe-hooks.c
@@ -0,0 +1,151 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ipe-hooks.h"
+#include "ipe-engine.h"
+
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/binfmts.h>
+#include <linux/mount.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/security.h>
+
+#define HAS_EXEC(_p, _rp) (((_rp) & PROT_EXEC) || ((_p) & PROT_EXEC))
+
+/**
+ * ipe_on_exec: LSM hook called on the exec family of system calls.
+ * @bprm: A structure to hold arguments that are used when loading binaries,
+ *	  used to extract the file being executed.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - see ipe_process_event
+ */
+int ipe_on_exec(struct linux_binprm *bprm)
+{
+	return ipe_process_event(bprm->file, ipe_op_execute, ipe_hook_exec);
+}
+
+/**
+ * ipe_on_mmap: LSM hook called on the mmap system call.
+ * @file: File being mapped into memory.
+ * @reqprot: Usermode requested protections on the memory region.
+ * @prot: A protection mapping of the memory region, calculated based on
+ *	  @reqprot, and the system configuration.
+ * @flags: Unused.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - see ipe_process_event
+ */
+int ipe_on_mmap(struct file *file, unsigned long reqprot, unsigned long prot,
+		unsigned long flags)
+{
+	if (HAS_EXEC(reqprot, prot))
+		return ipe_process_event(file, ipe_op_execute, ipe_hook_mmap);
+
+	return 0;
+}
+
+/**
+ * ipe_on_mprotect: LSM hook called on the mprotect system call
+ * @vma: A structure representing the existing memory region.
+ * @reqprot: Usermode requested protections on the memory region.
+ * @prot: A protection mapping of the memory region, calculated based on
+ *	  @reqprot, and the system configuration.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - see ipe_process_event
+ */
+int ipe_on_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
+		    unsigned long prot)
+{
+	if (HAS_EXEC(reqprot, prot) && !(vma->vm_flags & VM_EXEC))
+		return ipe_process_event(vma->vm_file, ipe_op_execute,
+					 ipe_hook_mprotect);
+
+	return 0;
+}
+
+/**
+ * ipe_on_kernel_read: LSM hook called on kernel_read_file.
+ * @file: File being read by the hook kernel_read_file.
+ * @id: Enumeration indicating the type of file being read.
+ *
+ * For more information, see the LSM hook, kernel_read_file.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - see ipe_process_event
+ */
+int ipe_on_kernel_read(struct file *file, enum kernel_read_file_id id)
+{
+	switch (id) {
+	case READING_FIRMWARE:
+	case READING_FIRMWARE_PREALLOC_BUFFER:
+		return ipe_process_event(file, ipe_op_firmware,
+					 ipe_hook_kernel_read);
+	case READING_MODULE:
+		return ipe_process_event(file, ipe_op_kmodule,
+					 ipe_hook_kernel_read);
+	case READING_KEXEC_INITRAMFS:
+		return ipe_process_event(file, ipe_op_kexec_initramfs,
+					 ipe_hook_kernel_read);
+	case READING_KEXEC_IMAGE:
+		return ipe_process_event(file, ipe_op_kexec_image,
+					 ipe_hook_kernel_read);
+	case READING_POLICY:
+		return ipe_process_event(file, ipe_op_policy,
+					 ipe_hook_kernel_read);
+	case READING_X509_CERTIFICATE:
+		return ipe_process_event(file, ipe_op_x509,
+					 ipe_hook_kernel_read);
+	default:
+		return ipe_process_event(file, ipe_op_kernel_read,
+					 ipe_hook_kernel_read);
+	}
+}
+
+/**
+ * ipe_on_kernel_load_data: LSM hook called on kernel_load_data.
+ * @id: Enumeration indicating what type of data is being loaded.
+ *
+ * For more information, see the LSM hook, kernel_load_data.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - see ipe_process_event
+ */
+int ipe_on_kernel_load_data(enum kernel_load_data_id id)
+{
+	switch (id) {
+	case LOADING_FIRMWARE:
+	case LOADING_FIRMWARE_PREALLOC_BUFFER:
+		return ipe_process_event(NULL, ipe_op_firmware,
+					 ipe_hook_kernel_load);
+	case LOADING_MODULE:
+		return ipe_process_event(NULL, ipe_op_kmodule,
+					 ipe_hook_kernel_load);
+	case LOADING_KEXEC_INITRAMFS:
+		return ipe_process_event(NULL, ipe_op_kexec_initramfs,
+					 ipe_hook_kernel_load);
+	case LOADING_KEXEC_IMAGE:
+		return ipe_process_event(NULL, ipe_op_kexec_image,
+					 ipe_hook_kernel_load);
+	case LOADING_POLICY:
+		return ipe_process_event(NULL, ipe_op_policy,
+					 ipe_hook_kernel_load);
+	case LOADING_X509_CERTIFICATE:
+		return ipe_process_event(NULL, ipe_op_x509,
+					 ipe_hook_kernel_load);
+	default:
+		return ipe_process_event(NULL, ipe_op_kernel_read,
+					 ipe_hook_kernel_load);
+	}
+}
diff --git a/security/ipe/ipe-hooks.h b/security/ipe/ipe-hooks.h
new file mode 100644
index 000000000000..6af706a130ce
--- /dev/null
+++ b/security/ipe/ipe-hooks.h
@@ -0,0 +1,114 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <linux/types.h>
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/binfmts.h>
+#include <linux/mman.h>
+#include <linux/mm.h>
+#include <linux/security.h>
+
+#ifndef IPE_HOOK_H
+#define IPE_HOOK_H
+
+#define IPE_HOOK_EXEC		"EXEC"
+#define IPE_HOOK_MMAP		"MMAP"
+#define IPE_HOOK_MPROTECT	"MPROTECT"
+#define IPE_HOOK_KERNEL_READ	"KERNEL_READ"
+#define IPE_HOOK_KERNEL_LOAD	"KERNEL_LOAD"
+
+enum ipe_hook {
+	ipe_hook_exec = 0,
+	ipe_hook_mmap,
+	ipe_hook_mprotect,
+	ipe_hook_kernel_read,
+	ipe_hook_kernel_load,
+	ipe_hook_max
+};
+
+/*
+ * The sequence between ipe_op_firmware and ipe_op_kmodule
+ * must remain the same for ipe_op_kernel read to function
+ * appropriately.
+ */
+enum ipe_op {
+	ipe_op_execute = 0,
+	ipe_op_firmware,
+	ipe_op_kexec_image,
+	ipe_op_kexec_initramfs,
+	ipe_op_x509,
+	ipe_op_policy,
+	ipe_op_kmodule,
+	ipe_op_kernel_read,
+	ipe_op_max
+};
+
+/**
+ * ipe_on_exec: LSM hook called on the exec family of system calls.
+ * @bprm: A structure to hold arguments that are used when loading binaries,
+ *	  used to extract the file being executed.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - see ipe_process_event
+ */
+int ipe_on_exec(struct linux_binprm *bprm);
+
+/**
+ * ipe_on_mmap: LSM hook called on the mmap system call
+ * @file: File being mapped into memory.
+ * @reqprot: Usermode requested protections on the memory region.
+ * @prot: A protection mapping of the memory region, calculated based on
+ *	  @reqprot, and the system configuration.
+ * @flags: unused.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - see ipe_process_event
+ */
+int ipe_on_mmap(struct file *file, unsigned long reqprot, unsigned long prot,
+		unsigned long flags);
+
+/**
+ * ipe_on_mprotect: LSM hook called on the mprotect system call
+ * @vma: A structure representing the existing memory region.
+ * @reqprot: Usermode requested protections on the memory region.
+ * @prot: A protection mapping of the memory region, calculated based on
+ *	  @reqprot, and the system configuration.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - see ipe_process_event
+ */
+int ipe_on_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
+		    unsigned long prot);
+
+/**
+ * ipe_on_kernel_read: LSM hook called on kernel_read_file.
+ * @file: File being read by the hook kernel_read_file.
+ * @id: Enumeration indicating the type of file being read.
+ *
+ * For more information, see the LSM hook, kernel_read_file.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - see ipe_process_event
+ */
+int ipe_on_kernel_read(struct file *file, enum kernel_read_file_id id);
+
+/**
+ * ipe_on_kernel_load_data: LSM hook called on kernel_load_data.
+ * @id: Enumeration indicating what type of data is being loaded.
+ *
+ * For more information, see the LSM hook, kernel_load_data.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - see ipe_process_event
+ */
+int ipe_on_kernel_load_data(enum kernel_load_data_id id);
+
+#endif /* IPE_HOOK_H */
diff --git a/security/ipe/ipe-parse.c b/security/ipe/ipe-parse.c
new file mode 100644
index 000000000000..c5e0111b9c8b
--- /dev/null
+++ b/security/ipe/ipe-parse.c
@@ -0,0 +1,898 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ipe-prop-internal.h"
+#include "ipe-hooks.h"
+#include "ipe-parse.h"
+#include "ipe-property.h"
+#include "ipe-audit.h"
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/list_sort.h>
+#include <linux/slab.h>
+#include <linux/ctype.h>
+#include <linux/parser.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+
+#define ALLOW_ACTION	"ALLOW"
+#define DENY_ACTION	"DENY"
+#define COMMENT_CHAR	'#'
+#define VER_FSTR	"%hu.%hu.%hu"
+
+/* Internal Type Definitions */
+enum property_priority {
+	other = 0,
+	action = 1,
+	op = 2,
+	default_action = 3,
+	policy_ver = 4,
+	policy_name = 5,
+};
+
+struct token {
+	struct list_head	next_tok;
+	const char		*key;
+	enum property_priority	key_priority;
+	const char		*val;
+};
+
+/* Utility Functions */
+static inline bool is_quote(char c)
+{
+	return c == '"' || c == '\'';
+}
+
+static inline bool valid_token(char *s)
+{
+	return !s || !strpbrk(s, "\"\'");
+}
+
+static inline bool is_default(const struct token *t)
+{
+	return !t->val &&  t->key_priority == default_action;
+}
+
+static inline bool is_operation(const struct token *t)
+{
+	return t->val && t->key_priority == op;
+}
+
+static inline bool is_action(const struct token *t)
+{
+	return t->val && t->key_priority == action;
+}
+
+static inline bool is_name(const struct token *t)
+{
+	return t->val && t->key_priority == policy_name;
+}
+
+static inline bool is_ver(const struct token *t)
+{
+	return t->val && t->key_priority == policy_ver;
+}
+
+static int cmp_pri(void *priv, struct list_head *a, struct list_head *b)
+{
+	struct token *t_a = container_of(a, struct token, next_tok);
+	struct token *t_b = container_of(b, struct token, next_tok);
+
+	return t_b->key_priority - t_a->key_priority;
+}
+
+static char *trim_quotes(char *str)
+{
+	char s;
+	size_t len;
+
+	if (!str)
+		return str;
+
+	s = *str;
+
+	if (is_quote(s)) {
+		len = strlen(str) - 1;
+
+		if (str[len] != s)
+			return NULL;
+
+		str[len] = '\0';
+		++str;
+	}
+
+	return str;
+}
+
+/**
+ * ipe_set_action: Set an action with error checking.
+ * @src: Valid pointer to the source location to set wih the result
+ * @set: Value to apply to @src, if valid
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - Attempting to set something that is already set
+ */
+static int ipe_set_action(enum ipe_action *src, enum ipe_action set)
+{
+	if (*src != ipe_action_unset)
+		return -EBADMSG;
+
+	*src = set;
+
+	return 0;
+}
+
+/**
+ * ipe_insert_token: Allocate and append the key=value pair indicated by @val,
+ *		     to the list represented by @head.
+ * @val: Token to parse, of form "key=val".
+ * @head: Head of the list to insert the token structure into.
+ *
+ * If "=val" is omitted, this function will succeed, and the value set will be
+ * NULL.
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - Invalid policy syntax
+ * -ENOMEM - No Memory
+ */
+static int ipe_insert_token(char *val, struct list_head *head)
+{
+	char *key;
+	substring_t match[MAX_OPT_ARGS];
+	struct token *tok;
+	const match_table_t prop_priorities = {
+		{ policy_name,		IPE_HEADER_POLICY_NAME },
+		{ policy_ver,		IPE_HEADER_POLICY_VERSION},
+		{ op,			IPE_PROPERTY_OPERATION },
+		{ default_action,	IPE_PROPERTY_DEFAULT },
+		{ action,		IPE_PROPERTY_ACTION },
+		{ other, NULL },
+	};
+
+	key = strsep(&val, "=");
+	if (!key)
+		return -EBADMSG;
+
+	tok = kzalloc(sizeof(*tok), GFP_KERNEL);
+	if (!tok)
+		return -ENOMEM;
+
+	tok->key = key;
+	tok->val = trim_quotes(val);
+	tok->key_priority = match_token(key, prop_priorities, match);
+	INIT_LIST_HEAD(&tok->next_tok);
+
+	list_add_tail(&tok->next_tok, head);
+
+	return 0;
+}
+
+/**
+ * ipe_tokenize_line: Parse a line of text into a list of token structures.
+ * @line: Line to parse.
+ * @list: Head of the list to insert the token structure into.
+ *
+ * The final result will be sorted in the priority order definted by
+ * enum property_priorities to enforce policy structure.
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - Invalid policy syntax
+ * -ENOMEM - No Memory
+ * -ENOENT - No tokens were parsed
+ */
+static int ipe_tokenize_line(char *line, struct list_head *list)
+{
+	int rc = 0;
+	size_t i = 0;
+	size_t len = 0;
+	char *tok = NULL;
+	char quote = '\0';
+
+	len = strlen(line);
+
+	for (i = 0; i < len; ++i) {
+		if (quote == '\0' && is_quote(line[i])) {
+			quote = line[i];
+			continue;
+		}
+
+		if (quote != '\0' && line[i] == quote) {
+			quote = '\0';
+			continue;
+		}
+
+		if (quote == '\0' && line[i] == COMMENT_CHAR) {
+			tok = NULL;
+			break;
+		}
+
+		if (isgraph(line[i]) && !tok)
+			tok = &line[i];
+
+		if (quote == '\0' && isspace(line[i])) {
+			line[i] = '\0';
+
+			if (!tok)
+				continue;
+
+			rc = ipe_insert_token(tok, list);
+			if (rc != 0)
+				return rc;
+
+			tok = NULL;
+		}
+	}
+
+	if (quote != '\0')
+		return -EBADMSG;
+
+	if (tok)
+		ipe_insert_token(tok, list);
+
+	if (list_empty(list))
+		return -ENOENT;
+
+	list_sort(NULL, list, cmp_pri);
+
+	return 0;
+}
+
+static inline int ipe_parse_version(const char *val, struct ipe_pol_ver *ver)
+{
+	if (sscanf(val, VER_FSTR, &ver->major, &ver->minor, &ver->rev) != 3)
+		return -EBADMSG;
+
+	return 0;
+}
+
+/**
+ * ipe_parse_action: Given a token, parse the value as if it were an 'action'
+ *		     token.
+ * @action: Token to parse to determine the action.
+ *
+ * Action tokens are of the form: action=(ALLOW|DENY) for more information
+ * about IPE policy, please see the documentation.
+ *
+ * Return:
+ * ipe_action_allow - OK
+ * ipe_action_deny - OK
+ * ipe_action_unset - ERR
+ */
+static enum ipe_action ipe_parse_action(struct token *action)
+{
+	if (!action->val)
+		return ipe_action_unset;
+	else if (!strcmp(action->val, ALLOW_ACTION))
+		return ipe_action_allow;
+	else if (!strcmp(action->val, DENY_ACTION))
+		return ipe_action_deny;
+
+	return ipe_action_unset;
+}
+
+/**
+ * ipe_parse_op: Given a token, parse the value as if it were an 'op' token.
+ * @op: Token to parse to determine the operation.
+ *
+ * "op" tokens are of the form: op=(EXECUTE|FIRMWARE|KEXEC_IMAGE|...)
+ * for more information about IPE policy, please see the documentation.
+ *
+ * Return:
+ * ipe_op_max - ERR
+ * otherwise - OK
+ */
+static enum ipe_op ipe_parse_op(struct token *op)
+{
+	substring_t match[MAX_OPT_ARGS];
+	const match_table_t ops = {
+		{ ipe_op_execute,		IPE_OP_EXECUTE },
+		{ ipe_op_firmware,		IPE_OP_FIRMWARE },
+		{ ipe_op_kexec_image,		IPE_OP_KEXEC_IMAGE },
+		{ ipe_op_kexec_initramfs,	IPE_OP_KEXEC_INITRAMFS },
+		{ ipe_op_x509,			IPE_OP_X509_CERTIFICATE },
+		{ ipe_op_policy,		IPE_OP_POLICY },
+		{ ipe_op_kmodule,		IPE_OP_KMODULE },
+		{ ipe_op_kernel_read,		IPE_OP_KERNEL_READ },
+		{ ipe_op_max,			NULL },
+	};
+
+	return match_token((char *)op->val, ops, match);
+}
+
+/**
+ * ipe_set_default: Set the default of the policy, at various scope levels
+ *		    depending on the value of op.
+ * @op: Operation that was parsed.
+ * @pol: Policy to modify with the newly-parsed default action.
+ * @a: Action token (see parse_action) to parse to determine
+ *     the default.
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - Invalid policy format
+ */
+static int ipe_set_default(enum ipe_op op, struct ipe_policy *pol,
+			   struct token *a)
+{
+	int rc = 0;
+	size_t i = 0;
+	enum ipe_action act = ipe_parse_action(a);
+
+	if (act == ipe_action_unset)
+		return -EBADMSG;
+
+	if (op == ipe_op_max)
+		return ipe_set_action(&pol->def, act);
+
+	if (op == ipe_op_kernel_read) {
+		for (i = ipe_op_firmware; i <= ipe_op_kmodule; ++i) {
+			rc = ipe_set_action(&pol->ops[i].def, act);
+			if (rc != 0)
+				return rc;
+		}
+		return 0;
+	}
+
+	return ipe_set_action(&pol->ops[op].def, act);
+}
+
+/**
+ * ipe_parse_default: Parse a default statement of an IPE policy modify @pol
+ *		      with the proper changes
+ * @tokens: List of tokens parsed from the line
+ * @pol: Policy to modify with the newly-parsed default action
+ *
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - Invalid policy format
+ * -ENOENT - Unknown policy structure
+ */
+static int ipe_parse_default(struct list_head *tokens,
+			     struct ipe_policy *pol)
+{
+	struct token *f = NULL;
+	struct token *s = NULL;
+	struct token *t = NULL;
+	enum ipe_op i = ipe_op_max;
+
+	f = list_first_entry(tokens, struct token, next_tok);
+	s = list_next_entry(f, next_tok);
+	if (is_action(s))
+		return ipe_set_default(ipe_op_max, pol, s);
+
+	i = ipe_parse_op(s);
+	if (i == ipe_op_max)
+		return -ENOENT;
+
+	t = list_next_entry(s, next_tok);
+	if (is_action(t)) {
+		t = list_next_entry(s, next_tok);
+		return ipe_set_default(i, pol, t);
+	}
+
+	return -ENOENT;
+}
+
+/**
+ * ipe_free_token_list - Free a list of tokens, and then reinitialize @list
+ *			 dropping all tokens.
+ * @list: List to be freed.
+ */
+static void ipe_free_token_list(struct list_head *list)
+{
+	struct token *ptr, *next;
+
+	list_for_each_entry_safe(ptr, next, list, next_tok)
+		kfree(ptr);
+
+	INIT_LIST_HEAD(list);
+}
+
+/**
+ * ipe_free_prop - Deallocator for an ipe_prop_container structure.
+ * @cont: Object to free.
+ */
+static void ipe_free_prop(struct ipe_prop_container *cont)
+{
+	if (IS_ERR_OR_NULL(cont))
+		return;
+
+	if (cont->prop->free_val)
+		cont->prop->free_val(&cont->value);
+	kfree(cont);
+}
+
+/**
+ * ipe_alloc_prop: Allocator for a ipe_prop_container structure.
+ * @tok: Token structure representing the "key=value" pair of the property.
+ *
+ * Return:
+ * Pointer to ipe_rule - OK
+ * ERR_PTR(-ENOMEM) - Allocation failed
+ */
+static struct ipe_prop_container *ipe_alloc_prop(const struct token *tok)
+{
+	int rc = 0;
+	const struct ipe_property *prop = NULL;
+	struct ipe_prop_container *cont = NULL;
+
+	prop = ipe_lookup_prop(tok->key);
+	if (!prop) {
+		rc = -ENOENT;
+		goto err;
+	}
+
+	cont = kzalloc(sizeof(*cont), GFP_KERNEL);
+	if (!cont) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	INIT_LIST_HEAD(&cont->next);
+
+	rc = prop->parse(tok->val, &cont->value);
+	if (rc != 0)
+		goto err;
+
+	cont->prop = prop;
+
+	return cont;
+err:
+	ipe_free_prop(cont);
+	return ERR_PTR(rc);
+}
+
+/**
+ * ipe_free_rule: Deallocator for an ipe_rule structure.
+ * @rule: Object to free.
+ */
+static void ipe_free_rule(struct ipe_rule *rule)
+{
+	struct ipe_prop_container *ptr;
+	struct list_head *l_ptr, *l_next;
+
+	if (IS_ERR_OR_NULL(rule))
+		return;
+
+	list_for_each_safe(l_ptr, l_next, &rule->props) {
+		ptr = container_of(l_ptr, struct ipe_prop_container, next);
+		list_del(l_ptr);
+		ipe_free_prop(ptr);
+	}
+
+	kfree(rule);
+}
+
+/**
+ * ipe_alloc_rule: Allocate a ipe_rule structure, for operation @op, parsed
+ *		   from the first token in list @head.
+ * @op: Operation parsed from the first token in @head.
+ * @t: The first token in @head that was parsed.
+ * @head: List of remaining tokens to parse.
+ *
+ * Return:
+ * Valid ipe_rule pointer - OK
+ * ERR_PTR(-EBADMSG) - Invalid syntax
+ * ERR_PTR(-ENOMEM) - Out of memory
+ */
+static struct ipe_rule *ipe_alloc_rule(enum ipe_op op, struct token *t,
+				       struct list_head *head)
+{
+	int rc = 0;
+	struct token *ptr;
+	enum ipe_action act;
+	struct ipe_rule *rule = NULL;
+	struct ipe_prop_container *prop = NULL;
+
+	ptr = list_next_entry(t, next_tok);
+	if (!is_action(ptr)) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	act = ipe_parse_action(ptr);
+	if (act == ipe_action_unset) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	INIT_LIST_HEAD(&rule->props);
+	INIT_LIST_HEAD(&rule->next);
+	rule->action = act;
+	rule->op = op;
+
+	list_for_each_entry_continue(ptr, head, next_tok) {
+		prop = ipe_alloc_prop(ptr);
+
+		if (IS_ERR(prop)) {
+			rc = PTR_ERR(prop);
+			goto err;
+		}
+
+		list_add_tail(&prop->next, &rule->props);
+	}
+
+	return rule;
+err:
+	ipe_free_prop(prop);
+	ipe_free_rule(rule);
+	return ERR_PTR(rc);
+}
+
+/**
+ * ipe_dup_prop: Duplicate an ipe_prop_container structure
+ * @p: Container to duplicate.
+ *
+ * This function is used to duplicate individual properties within a rule.
+ * It should only be called in operations that actually map to one or more
+ * operations.
+ *
+ * Return:
+ * Valid ipe_prop_container - OK
+ * ERR_PTR(-ENOMEM) - Out of memory
+ * Other Errors - see various property duplicator functions
+ */
+static
+struct ipe_prop_container *ipe_dup_prop(const struct ipe_prop_container *p)
+{
+	int rc = 0;
+	struct ipe_prop_container *dup;
+
+	dup = kzalloc(sizeof(*dup), GFP_KERNEL);
+	if (!dup) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	dup->prop = p->prop;
+	INIT_LIST_HEAD(&dup->next);
+
+	rc = p->prop->dup(p->value, &dup->value);
+	if (rc != 0)
+		goto err;
+
+	return dup;
+err:
+	ipe_free_prop(dup);
+	return ERR_PTR(rc);
+}
+
+/**
+ * ipe_dup_rule: Duplicate a policy rule, used for pseudo hooks like
+ *		 KERNEL_READ to map a policy rule across all hooks.
+ * @r: Rule to duplicate.
+ *
+ * Return:
+ * valid ipe_rule - OK
+ * ERR_PTR(-ENOMEM) - Out of memory
+ * Other Errors - See ipe_dup_prop
+ */
+static struct ipe_rule *ipe_dup_rule(const struct ipe_rule *r)
+{
+	int rc = 0;
+	struct ipe_rule *dup;
+	struct ipe_prop_container *ptr;
+
+	dup = kzalloc(sizeof(*dup), GFP_KERNEL);
+	if (!dup) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	dup->op = r->op;
+	dup->action = r->action;
+	INIT_LIST_HEAD(&dup->props);
+	INIT_LIST_HEAD(&dup->next);
+
+	list_for_each_entry(ptr, &r->props, next) {
+		struct ipe_prop_container *prop2;
+
+		prop2 = ipe_dup_prop(ptr);
+		if (IS_ERR(prop2)) {
+			rc = PTR_ERR(prop2);
+			goto err;
+		}
+
+		list_add_tail(&prop2->next, &dup->props);
+	}
+
+	return dup;
+err:
+	ipe_free_rule(dup);
+	return ERR_PTR(rc);
+}
+
+/**
+ * ipe_free_policy: Deallocate an ipe_policy structure.
+ * @pol: Policy to free.
+ */
+void ipe_free_policy(struct ipe_policy *pol)
+{
+	size_t i;
+	struct ipe_rule *ptr;
+	struct ipe_rule_table *op;
+	struct list_head *l_ptr, *l_next;
+
+	if (IS_ERR_OR_NULL(pol))
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(pol->ops); ++i) {
+		op = &pol->ops[i];
+
+		list_for_each_safe(l_ptr, l_next, &op->rules) {
+			ptr = list_entry(l_ptr, struct ipe_rule, next);
+			list_del(l_ptr);
+			ipe_free_rule(ptr);
+		}
+	}
+
+	kfree(pol->policy_name);
+	kfree(pol);
+	pol = NULL;
+}
+
+/**
+ * ipe_alloc_policy: Give a list of tokens representing the first line of the
+ *		     token, attempt to parse it as an IPE policy header, and
+ *		     allocate a policy structure based on those values.
+ * @tokens: List of tokens parsed from the first line of the policy
+ *
+ * Return:
+ * Valid ipe_policy pointer - OK
+ * ERR_PTR(-ENOMEM) - Out of memory
+ * ERR_PTR(-EBADMSG) - Invalid policy syntax
+ */
+static struct ipe_policy *ipe_alloc_policy(struct list_head *tokens)
+{
+	size_t i;
+	int rc = 0;
+	struct token *name = NULL;
+	struct token *ver = NULL;
+	struct ipe_policy *lp = NULL;
+
+	name = list_first_entry(tokens, struct token, next_tok);
+	if (!is_name(name)) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	if (list_is_singular(tokens)) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	ver = list_next_entry(name, next_tok);
+	if (!is_ver(ver)) {
+		rc = -EBADMSG;
+		goto err;
+	}
+
+	lp = kzalloc(sizeof(*lp), GFP_KERNEL);
+	if (!lp) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	lp->policy_name = kstrdup(name->val, GFP_KERNEL);
+	if (!lp->policy_name) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	rc = ipe_parse_version(ver->val, &lp->policy_version);
+	if (rc != 0)
+		goto err;
+
+	for (i = 0; i < ARRAY_SIZE(lp->ops); ++i) {
+		lp->ops[i].def = ipe_action_unset;
+		INIT_LIST_HEAD(&lp->ops[i].rules);
+	}
+
+	lp->def = ipe_action_unset;
+
+	return lp;
+err:
+	ipe_free_policy(lp);
+	return ERR_PTR(rc);
+}
+
+/**
+ * ipe_add_rule_for_range: Given a ipe_rule @r, duplicate @r and add the rule
+ *			   to @pol for the operation range @start to @end.
+ * @start: The starting point of the range to add the rule to.
+ * @end: The ending point of the range to add the rule to.
+ * @r: The rule to copy.
+ * @pol: Policy structure to modify with the result.
+ *
+ * This is @start to @end, inclusive. @r is still valid after this function,
+ * and should be freed if appropriate.
+ *
+ * Return:
+ * 0 - OK
+ * Other Errors - See ipe_dup_prop
+ */
+static int ipe_add_rule_for_range(enum ipe_op start, enum ipe_op end,
+				  struct ipe_rule *r, struct ipe_policy *pol)
+{
+	enum ipe_op i;
+	struct ipe_rule *cpy = NULL;
+
+	for (i = start; i <= end; ++i) {
+		cpy = ipe_dup_rule(r);
+		if (IS_ERR(cpy))
+			return PTR_ERR(cpy);
+
+		list_add_tail(&cpy->next, &pol->ops[i].rules);
+	}
+
+	return 0;
+}
+
+/**
+ * ipe_parse_line: Given a list of tokens, attempt to parse it into a rule
+ *		   structure, and add it to the passed-in ipe_policy structure.
+ * @tokens: List of tokens that were parsed.
+ * @pol: Policy structure to modify with the result.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOENT - Unrecognized property
+ * -ENOMEM - Out of memory
+ * Other Errors - See ipe_dup_prop
+ */
+static int ipe_parse_line(struct list_head *tokens,
+			  struct ipe_policy *pol)
+{
+	int rc = 0;
+	struct token *f;
+	enum ipe_op i = ipe_op_max;
+	struct ipe_rule *rule = NULL;
+
+	f = list_first_entry(tokens, struct token, next_tok);
+
+	switch (f->key_priority) {
+	case default_action:
+		rc = ipe_parse_default(tokens, pol);
+		break;
+	case op:
+		i = ipe_parse_op(f);
+		if (i == ipe_op_max)
+			return -ENOENT;
+
+		if (list_is_singular(tokens))
+			return -EBADMSG;
+
+		rule = ipe_alloc_rule(i, f, tokens);
+		if (IS_ERR(rule)) {
+			rc = PTR_ERR(rule);
+			goto cleanup;
+		}
+
+		if (i == ipe_op_kernel_read) {
+			rc = ipe_add_rule_for_range(ipe_op_firmware,
+						    ipe_op_kmodule, rule, pol);
+			if (rc != 0)
+				goto cleanup;
+		} else {
+			list_add_tail(&rule->next, &pol->ops[i].rules);
+			rule = NULL;
+		}
+		break;
+	default:
+		return -ENOENT;
+	}
+
+cleanup:
+	ipe_free_rule(rule);
+	return rc;
+}
+
+/**
+ * ipe_remap_policy_defaults: Remap all defaults not specified by policy to
+ *			      'allow' to preserve compatibility.
+ * @p: Policy to modify.
+ *
+ * This function's behavior changes when strict_parse is set. When the strict
+ * parser is enabled, this function will break backwards policy compatibility,
+ * erroring on an unset default.
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - (Only with strict parse) A default was left unset.
+ */
+static int ipe_remap_policy_defaults(struct ipe_policy *p)
+{
+	size_t i;
+
+	if (p->def == ipe_action_unset) {
+		for (i = 0; i < ARRAY_SIZE(p->ops); ++i) {
+			if (p->ops[i].def == ipe_action_unset) {
+				ipe_audit_unset_remap((enum ipe_op)i);
+				if (strict_parse)
+					return -EBADMSG;
+				p->ops[i].def = ipe_action_allow;
+			}
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ipe_parse_policy: Given a string, parse the string into an IPE policy
+ *		     structure.
+ * @policy: NULL terminated string to parse.
+ *
+ * This function's behavior changes when strict_parse is set. When the strict
+ * parser is enabled, this function will break backwards policy compatibility,
+ * erroring on unknown syntax. This function will modify @policy.
+ *
+ * Return:
+ * Valid ipe_policy structure - OK
+ * ERR_PTR(-EBADMSG) - Invalid Policy Syntax (Unrecoverable)
+ * ERR_PTR(-ENOMEM) - Out of Memory
+ */
+struct ipe_policy *ipe_parse_policy(char *policy)
+{
+	int rc = 0;
+	size_t i = 1;
+	char *p = NULL;
+	LIST_HEAD(t_list);
+	struct ipe_policy *local_p = NULL;
+
+	while ((p = strsep(&policy, "\n\0")) != NULL) {
+		rc = ipe_tokenize_line(p, &t_list);
+		if (rc == -ENOENT) {
+			++i;
+			continue;
+		}
+		if (rc != 0)
+			goto err;
+
+		if (!local_p) {
+			local_p = ipe_alloc_policy(&t_list);
+			if (IS_ERR(local_p)) {
+				rc = PTR_ERR(local_p);
+				goto err;
+			}
+		} else {
+			rc = ipe_parse_line(&t_list, local_p);
+			if (rc == -ENOENT) {
+				ipe_audit_ignore_line(i);
+				if (strict_parse) {
+					rc = -EBADMSG;
+					goto err;
+				}
+			} else if (rc != 0) {
+				goto err;
+			}
+		}
+
+		ipe_free_token_list(&t_list);
+		++i;
+	}
+
+	rc = ipe_remap_policy_defaults(local_p);
+	if (rc != 0)
+		goto err;
+
+	return local_p;
+err:
+	ipe_free_token_list(&t_list);
+	ipe_free_policy(local_p);
+	return ERR_PTR(rc);
+}
diff --git a/security/ipe/ipe-parse.h b/security/ipe/ipe-parse.h
new file mode 100644
index 000000000000..99310b5c3e00
--- /dev/null
+++ b/security/ipe/ipe-parse.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe-policy.h"
+
+#include <linux/types.h>
+
+#ifndef IPE_PARSE_H
+#define IPE_PARSE_H
+
+/**
+ * ipe_parse_policy: Given a string, parse the string into an IPE policy
+ *		     structure.
+ * @policy: NULL terminated string to parse.
+ *
+ * This function's behavior changes when strict_parse is set. When the strict
+ * parser is enabled, this function will break backwards policy compatibility,
+ * erroring on unknown syntax. This function will modify @policy.
+ *
+ * Return:
+ * Valid ipe_policy structure - OK
+ * ERR_PTR(-EBADMSG) - Invalid Policy Syntax (Unrecoverable)
+ * ERR_PTR(-ENOMEM) - Out of Memory
+ */
+struct ipe_policy *ipe_parse_policy(char *policy);
+
+/**
+ * ipe_free_policy: Deallocate an ipe_policy structure.
+ * @pol: Policy to free.
+ */
+void ipe_free_policy(struct ipe_policy *pol);
+
+#endif /* IPE_AUDIT_H */
diff --git a/security/ipe/ipe-policy.c b/security/ipe/ipe-policy.c
new file mode 100644
index 000000000000..45546ae75582
--- /dev/null
+++ b/security/ipe/ipe-policy.c
@@ -0,0 +1,181 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ipe-secfs.h"
+#include "ipe-policy.h"
+#include "ipe-parse.h"
+#include "ipe-audit.h"
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/lockdep.h>
+#include <linux/fs.h>
+#include <linux/security.h>
+#include <linux/rcupdate.h>
+
+const struct ipe_policy *ipe_active_policy;
+static DEFINE_MUTEX(policy_lock);
+
+#define VER_TO_UINT64(_major, _minor, _rev) \
+	((((((u64)(_major)) << 16) | ((u64)(_minor))) << 16) | ((u64)(_rev)))
+
+/**
+ * ipe_is_version_allowed: Determine if @new has a greater or equal
+ *			   policy version than @old.
+ * @old: The policy to compare against.
+ * @new: The policy staged to replace @old.
+ *
+ * Return:
+ * true - @new has a policy version >= than @old
+ * false - @new does not have a policy version >= than @old
+ */
+static bool ipe_is_version_allowed(const struct ipe_pol_ver *old,
+				   const struct ipe_pol_ver *new)
+{
+	u64 old_ver = VER_TO_UINT64(old->major, old->minor, old->rev);
+	u64 new_ver = VER_TO_UINT64(new->major, new->minor, new->rev);
+
+	return new_ver >= old_ver;
+}
+
+/**
+ * ipe_is_valid_policy: determine if @old is allowed to replace @new.
+ * @old: policy that the @new is supposed to replace. Can be NULL.
+ * @new: the policy that is supposed to replace @new.
+ *
+ * Return:
+ * true - @new can replace @old
+ * false - @new cannot replace @old
+ */
+bool ipe_is_valid_policy(const struct ipe_policy *old,
+			 const struct ipe_policy *new)
+{
+	if (old)
+		return ipe_is_version_allowed(&old->policy_version,
+					      &new->policy_version);
+	return true;
+}
+
+/**
+ * ipe_is_active_policy: Determine if @policy is the currently active policy.
+ * @policy: Policy to check if it's the active policy.
+ *
+ * NOTE: If this attribute is needed to be consistent over a critical section,
+ *       do not use this function, as it does not hold the read lock over the
+ *       entirety of the critical section.
+ *
+ * Return:
+ * true - @policy is the active policy
+ * false - @policy is not the active policy
+ */
+bool ipe_is_active_policy(const struct ipe_policy *policy)
+{
+	bool result;
+
+	rcu_read_lock();
+
+	result = rcu_dereference(ipe_active_policy) == policy;
+
+	rcu_read_unlock();
+
+	return result;
+}
+
+/**
+ * ipe_update_active_policy: Determine if @old is the active policy, and update
+ *			     the active policy if necessary.
+ * @old: The previous policy that the update is trying to replace.
+ * @new: The new policy attempting to replace @old.
+ *
+ * If @old is not the active policy, nothing will be done.
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - Invalid Policy
+ */
+int ipe_update_active_policy(const struct ipe_policy *old,
+			     const struct ipe_policy *new)
+{
+	int rc = 0;
+	const struct ipe_policy *curr_policy = NULL;
+
+	/* no active policy, safe to update */
+	if (!ipe_active_policy)
+		return 0;
+
+	mutex_lock(&policy_lock);
+
+	curr_policy = rcu_dereference_protected(ipe_active_policy,
+						lockdep_is_held(&policy_lock));
+
+	if (curr_policy == old) {
+		if (!ipe_is_valid_policy(curr_policy, new)) {
+			rc = -EBADMSG;
+			goto cleanup;
+		}
+
+		ipe_audit_policy_activation(new);
+
+		(void)rcu_replace_pointer(ipe_active_policy, new,
+					  lockdep_is_held(&policy_lock));
+	}
+
+	mutex_unlock(&policy_lock);
+	synchronize_rcu();
+
+	return rc;
+cleanup:
+	mutex_unlock(&policy_lock);
+	return rc;
+}
+
+/**
+ * ipe_activate_policy: Set a specific policy as the active policy.
+ * @pol: The policy to set as the active policy.
+ *
+ * This is only called by the sysctl "ipe.active_policy".
+ *
+ * Return:
+ * 0 - OK
+ * -EINVAL - Policy that is being activated is lower in version than
+ *	     currently running policy.
+ */
+int ipe_activate_policy(const struct ipe_policy *pol)
+{
+	int rc = 0;
+	const struct ipe_policy *curr_policy = NULL;
+
+	mutex_lock(&policy_lock);
+
+	curr_policy = rcu_dereference_protected(ipe_active_policy,
+						lockdep_is_held(&policy_lock));
+
+	/*
+	 * User-set policies must be >= to current running policy.
+	 */
+	if (!ipe_is_valid_policy(curr_policy, pol)) {
+		rc = -EINVAL;
+		goto cleanup;
+	}
+
+	ipe_audit_policy_activation(pol);
+
+	/* cleanup of this pointer is handled by the secfs removal */
+	(void)rcu_replace_pointer(ipe_active_policy, pol,
+				  lockdep_is_held(&policy_lock));
+
+	mutex_unlock(&policy_lock);
+	synchronize_rcu();
+
+	return 0;
+cleanup:
+	mutex_unlock(&policy_lock);
+	return rc;
+}
diff --git a/security/ipe/ipe-policy.h b/security/ipe/ipe-policy.h
new file mode 100644
index 000000000000..c9da982ef2d4
--- /dev/null
+++ b/security/ipe/ipe-policy.h
@@ -0,0 +1,116 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe-hooks.h"
+#include "ipe-property.h"
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+
+#ifndef IPE_POLICY_H
+#define IPE_POLICY_H
+
+#define IPE_HEADER_POLICY_NAME		"policy_name"
+#define IPE_HEADER_POLICY_VERSION	"policy_version"
+
+extern const char *const ipe_boot_policy;
+extern const struct ipe_policy *ipe_active_policy;
+
+enum ipe_action {
+	ipe_action_unset = 0,
+	ipe_action_allow,
+	ipe_action_deny
+};
+
+struct ipe_prop_container {
+	struct list_head next;
+	void *value;
+	const struct ipe_property *prop;
+};
+
+struct ipe_rule {
+	struct list_head props;
+	struct list_head next;
+	enum ipe_action action;
+	enum ipe_op op;
+};
+
+struct ipe_rule_table {
+	struct list_head rules;
+	enum ipe_action def;
+};
+
+struct ipe_pol_ver {
+	u16 major;
+	u16 minor;
+	u16 rev;
+};
+
+struct ipe_policy {
+	char *policy_name;
+	struct ipe_pol_ver policy_version;
+	enum ipe_action def;
+
+	/* KERNEL_READ stores no data itself */
+	struct ipe_rule_table ops[ipe_op_max - 1];
+};
+
+/**
+ * ipe_is_valid_policy: determine if @old is allowed to replace @new.
+ * @old: policy that the @new is supposed to replace. Can be NULL.
+ * @new: the policy that is supposed to replace @new.
+ *
+ * Return:
+ * true - @new can replace @old
+ * false - @new cannot replace @old
+ */
+bool ipe_is_valid_policy(const struct ipe_policy *old,
+			 const struct ipe_policy *new);
+
+/**
+ * ipe_is_active_policy: Determine if @policy is the currently active policy.
+ * @policy: Policy to check if it's the active policy.
+ *
+ * NOTE: If this attribute is needed to be consistent over a critical section,
+ *       do not use this function, as it does not hold the read lock over the
+ *       entirety of the critical section.
+ *
+ * Return:
+ * true - @policy is the active policy
+ * false - @policy is not the active policy
+ */
+bool ipe_is_active_policy(const struct ipe_policy *policy);
+
+/**
+ * ipe_update_active_policy: Determine if @old is the active policy, and update
+ *			     the active policy if necessary.
+ * @old: The previous policy that the update is trying to replace.
+ * @new: The new policy attempting to replace @old.
+ *
+ * If @old is not the active policy, nothing will be done.
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - Invalid Policy
+ */
+int ipe_update_active_policy(const struct ipe_policy *old,
+			     const struct ipe_policy *new);
+
+/**
+ * ipe_activate_policy: Set a specific policy as the active policy.
+ * @pol: The policy to set as the active policy.
+ *
+ * This is only called by the sysctl "ipe.active_policy".
+ *
+ * Return:
+ * 0 - OK
+ * -EINVAL - Policy that is being activated is lower in version than
+ *	     currently running policy.
+ */
+int ipe_activate_policy(const struct ipe_policy *policy);
+
+#endif /* IPE_POLICY_H */
diff --git a/security/ipe/ipe-prop-internal.h b/security/ipe/ipe-prop-internal.h
new file mode 100644
index 000000000000..238d31a40169
--- /dev/null
+++ b/security/ipe/ipe-prop-internal.h
@@ -0,0 +1,43 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe-property.h"
+
+#include <linux/types.h>
+
+#ifndef IPE_PROPERTY_INTERNAL_H
+#define IPE_PROPERTY_INTERNAL_H
+
+#define IPE_PROPERTY_OPERATION	"op"
+#define IPE_PROPERTY_DEFAULT	"DEFAULT"
+#define IPE_PROPERTY_ACTION	"action"
+
+#define IPE_OP_EXECUTE		"EXECUTE"
+#define IPE_OP_FIRMWARE		"FIRMWARE"
+#define IPE_OP_KEXEC_IMAGE	"KEXEC_IMAGE"
+#define IPE_OP_KEXEC_INITRAMFS	"KEXEC_INITRAMFS"
+#define IPE_OP_X509_CERTIFICATE	"X509_CERT"
+#define IPE_OP_POLICY		"POLICY"
+#define IPE_OP_KMODULE		"KMODULE"
+#define IPE_OP_KERNEL_READ	"KERNEL_READ"
+
+struct ipe_prop_reg {
+	struct rb_node node;
+	const struct ipe_property *prop;
+};
+
+extern struct rb_root ipe_registry_root;
+
+/**
+ * ipe_lookup_prop: Attempt to find a ipe_property structure by name @key.
+ * @key: The property_name to look for in the tree.
+ *
+ * Return:
+ * ipe_property structure - OK
+ * NULL - No property exists under @key
+ */
+const struct ipe_property *ipe_lookup_prop(const char *key);
+
+#endif /* IPE_PROPERTY_INTERNAL_H */
diff --git a/security/ipe/ipe-property.c b/security/ipe/ipe-property.c
new file mode 100644
index 000000000000..675265a70327
--- /dev/null
+++ b/security/ipe/ipe-property.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ipe-prop-internal.h"
+#include "ipe-property.h"
+
+#include <linux/types.h>
+#include <linux/rbtree.h>
+#include <linux/slab.h>
+
+/* global root containing all registered properties */
+struct rb_root ipe_registry_root = RB_ROOT;
+
+/**
+ * reg_lookup: Attempt to find a `prop_reg` structure with property_name @key.
+ * @key: The property_name to look for in the tree.
+ *
+ * Return:
+ * ipe_prop_reg structure - OK
+ * NULL - No such property exists
+ */
+static struct ipe_prop_reg *reg_lookup(const char *key)
+{
+	struct rb_node *n = ipe_registry_root.rb_node;
+
+	while (n) {
+		int r;
+		struct ipe_prop_reg *reg =
+			container_of(n, struct ipe_prop_reg, node);
+
+		r = strcmp(reg->prop->property_name, key);
+		if (r == 0)
+			return reg;
+		else if (r > 0)
+			n = n->rb_right;
+		else
+			n = n->rb_left;
+	}
+
+	return NULL;
+}
+
+/**
+ * ipe_lookup_prop: Attempt to find a ipe_property structure by name @key.
+ * @key: The property_name to look for in the tree.
+ *
+ * Return:
+ * ipe_property structure - OK
+ * NULL - No property exists under @key
+ */
+const struct ipe_property *ipe_lookup_prop(const char *key)
+{
+	struct ipe_prop_reg *reg = reg_lookup(key);
+
+	if (!reg)
+		return NULL;
+
+	return reg->prop;
+}
+
+/**
+ * ipe_register_property: Insert a property into the registration system.
+ * @prop: Read-only property structure containing the property_name, as well
+ *	  as the necessary function pointers for a property.
+ *
+ * The caller needs to maintain the lifetime of @prop throughout the life of
+ * the system, after calling ipe_register_property.
+ *
+ * All necessary properties need to be loaded via this method before
+ * loading a policy, otherwise the properties will be ignored as unknown.
+ *
+ * Return:
+ * 0 - OK
+ * -EEXIST - A key exists with the name @prop->property_name
+ * -ENOMEM - Out of Memory
+ */
+int ipe_register_property(const struct ipe_property *prop)
+{
+	struct rb_node *parent = NULL;
+	struct ipe_prop_reg *new_data = NULL;
+	struct rb_node **new = &ipe_registry_root.rb_node;
+
+	while (*new) {
+		int r;
+		struct ipe_prop_reg *reg =
+			container_of(*new, struct ipe_prop_reg, node);
+
+		parent = *new;
+
+		r = strcmp(reg->prop->property_name, prop->property_name);
+		if (r == 0)
+			return -EEXIST;
+		else if (r > 0)
+			new = &((*new)->rb_right);
+		else
+			new = &((*new)->rb_left);
+	}
+
+	new_data = kzalloc(sizeof(*new_data), GFP_KERNEL);
+	if (!new_data)
+		return -ENOMEM;
+
+	new_data->prop = prop;
+
+	rb_link_node(&new_data->node, parent, new);
+	rb_insert_color(&new_data->node, &ipe_registry_root);
+
+	return 0;
+}
diff --git a/security/ipe/ipe-property.h b/security/ipe/ipe-property.h
new file mode 100644
index 000000000000..c9462d219d43
--- /dev/null
+++ b/security/ipe/ipe-property.h
@@ -0,0 +1,159 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe-engine.h"
+
+#include <linux/types.h>
+#include <linux/lsm_audit.h>
+
+#ifndef IPE_PROPERTY_H
+#define IPE_PROPERTY_H
+
+/**
+ * ipe_property_alloc_storage: Function used to define cache allocations for
+ *			       individual properties.
+ * @ctx: Context structure of the engine for deriving potential information
+ *	 to be stored.
+ * @storage: Valid address to space for persistent storage for a
+ *	     distinct file structure. For the same file structure, this will
+ *	     be provided to ipe_property_evaluator, ipe_ctx_audit and
+ *	     ipe_free_storage.
+ *
+ * This is called prior to any evaluation of property, allowing
+ * individual properties to allocate a structure, and potentially
+ * populate a storage space to use during the evaluation.
+ *
+ * An potential example, would be storing the result of a hash or
+ * signature verification operation, such that it does not need to
+ * be done more than once.
+ *
+ * Optional, can be NULL - in which case, this will not be called.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - ERR, use Standard Return Codes
+ */
+typedef int (*ipe_property_alloc_storage)(const struct ipe_engine_ctx *ctx,
+					  void **storage);
+
+/**
+ * ipe_property_evaluator: Determines whether a file subject matches the
+ *			   property.
+ * @value: Value to compare against for a match
+ * @storage: Valid address to space for persistent storage for a
+ *	     distinct file object.
+ *
+ * NOTE: This is done in an rcu read critical section - sleeping
+ *	 allocations are prohibited. See ipe_property_alloc_storage
+ *	 if allocations are required.
+ *
+ * Return:
+ * true - The property matches evaluation
+ * false - The property does not match evaluation
+ */
+typedef bool (*ipe_property_evaluator)(const struct ipe_engine_ctx *ctx,
+				       const void *value, void **storage);
+
+/**
+ * ipe_property_audit: Transform a rule value into a string representation.
+ * @ab: Audit buffer to add the string representation of @value to.
+ * @value: Value to transform into a string representation.
+ *
+ * NOTE: This is done in an rcu read critical section - sleeping
+ *	 allocations are prohibited.
+ */
+typedef void (*ipe_property_audit)(struct audit_buffer *ab, const void *value);
+
+/**
+ * ipe_ctx_audit: Called by the auditing to provide the values
+ *	that were evaluated about the subject, @ctx->file, to determine how
+ *	a value was evaluated.
+ *
+ * NOTE: This is done in an rcu read critical section - sleeping
+ *	 allocations are prohibited.
+ *
+ * @ab: Audit buffer to add the string representation of @value to.
+ * @value: Value to transform into a string representation.
+ * @storage: Value that was placed in @storage of the evaluator.
+ *
+ */
+typedef void (*ipe_ctx_audit)(struct audit_buffer *ab,
+			     const struct ipe_engine_ctx *ctx,
+			     const void *storage);
+
+/**
+ * ipe_parse_value: Transform a string representation of a rule into an
+ *		    internal ipe data-structure, opaque to the engine.
+ * @val_str: String-value parsed by the policy parser.
+ * @value: Valid-pointer indicating address to store parsed value.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - ERR, use Standard Return Codes
+ */
+typedef int(*ipe_parse_value)(const char *val_str, void **value);
+
+/**
+ * ipe_dup_val: Called by the policy parser to make duplicate properties for
+ *		pseudo-properties like "KERNEL_READ".
+ * @src:  Value to copy.
+ * @dest: Pointer to the destination where the value should be copied.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - ERR, use Standard Return Codes
+ */
+typedef int (*ipe_dup_val)(const void *src, void **dest);
+
+/**
+ * ipe_free_value: Free a policy value, created by ipe_parse_value.
+ * @value: Valid-pointer to the value to be interpreted and
+ *	   freed by the property.
+ *
+ * Optional, can be NULL - in which case, this will not be called.
+ */
+typedef void (*ipe_free_value)(void **value);
+
+/**
+ * ipe_free_storage: Free the storage allocated by
+ *		     ipe_property_prealloc_storage
+ * @storage: Valid-pointer to the value to be interpreted and
+ *	freed by the property.
+ *
+ * Optional, can be NULL - in which case, this will not be called.
+ */
+typedef void (*ipe_free_storage)(void **storage);
+
+struct ipe_property {
+	const char			*const property_name;
+	ipe_property_alloc_storage	prealloc;
+	ipe_property_evaluator		eval;
+	ipe_property_audit		rule_audit;
+	ipe_ctx_audit			ctx_audit;
+	ipe_parse_value			parse;
+	ipe_dup_val			dup;
+	ipe_free_value			free_val;
+	ipe_free_storage		free_storage;
+};
+
+/**
+ * ipe_register_property: Insert a property into the registration system.
+ * @prop: Read-only property structure containing the property_name, as well
+ *	  as the necessary function pointers for a property.
+ *
+ * The caller needs to maintain the lifetime of @prop throughout the life of
+ * the system, after calling ipe_register_property.
+ *
+ * All necessary properties need to be loaded via this method before
+ * loading a policy, otherwise the properties will be ignored as unknown.
+ *
+ * Return:
+ * 0 - OK
+ * -EEXIST - A key exists with the name @prop->property_name
+ * -ENOMEM - Out of memory
+ */
+int ipe_register_property(const struct ipe_property *prop);
+
+#endif /* IPE_PROPERTY_H */
diff --git a/security/ipe/ipe-secfs.c b/security/ipe/ipe-secfs.c
new file mode 100644
index 000000000000..1c9c41e143ab
--- /dev/null
+++ b/security/ipe/ipe-secfs.c
@@ -0,0 +1,814 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ipe-parse.h"
+#include "ipe-secfs.h"
+#include "ipe-policy.h"
+#include "ipe-audit.h"
+
+#include <linux/types.h>
+#include <linux/security.h>
+#include <linux/fs.h>
+#include <linux/rcupdate.h>
+#include <linux/mutex.h>
+#include <linux/init.h>
+#include <linux/dcache.h>
+#include <linux/namei.h>
+#include <linux/verification.h>
+#include <linux/capability.h>
+
+#define IPE_ROOT "ipe"
+#define IPE_FULL_CONTENT "raw"
+#define IPE_INNER_CONTENT "content"
+#define IPE_POLICIES "policies"
+#define IPE_NEW_POLICY "new_policy"
+#define IPE_DELETE_POLICY "del_policy"
+
+struct ipe_policy_node {
+	u8		*data;
+	size_t		data_len;
+	const u8	*content;
+	size_t		content_size;
+
+	struct ipe_policy *parsed;
+};
+
+/* root directory */
+static struct dentry *ipe_secfs_root __ro_after_init;
+
+/* subdirectory containing policies */
+static struct dentry *ipe_policies_root __ro_after_init;
+
+/* boot policy */
+static struct dentry *boot_policy_node __ro_after_init;
+
+/* top-level policy commands */
+static struct dentry *ipe_new_policy __ro_after_init;
+static struct dentry *ipe_del_policy __ro_after_init;
+
+static ssize_t ipe_secfs_new_policy(struct file *f, const char __user *data,
+				    size_t len, loff_t *offset);
+
+static ssize_t ipe_secfs_del_policy(struct file *f, const char __user *data,
+				    size_t len, loff_t *offset);
+
+static ssize_t ipe_secfs_rd_policy(struct file *f, char __user *data,
+				   size_t len, loff_t *offset);
+
+static ssize_t ipe_secfs_ud_policy(struct file *f, const char __user *data,
+				   size_t len, loff_t *offset);
+
+static ssize_t ipe_secfs_rd_content(struct file *f, char __user *data,
+				    size_t len, loff_t *offset);
+
+const static struct file_operations new_policy_ops = {
+	.write = ipe_secfs_new_policy
+};
+
+const static struct file_operations del_policy_ops = {
+	.write = ipe_secfs_del_policy
+};
+
+const static struct file_operations policy_raw_ops = {
+	.read = ipe_secfs_rd_policy,
+	.write = ipe_secfs_ud_policy
+};
+
+const static struct file_operations policy_content_ops = {
+	.read = ipe_secfs_rd_content
+};
+
+/**
+ * ipe_free_policy_node: Free an ipe_policy_node structure allocated by
+ *			 ipe_alloc_policy_node.
+ * @n: Ipe_policy_node to free
+ */
+static void ipe_free_policy_node(struct ipe_policy_node *n)
+{
+	if (IS_ERR_OR_NULL(n))
+		return;
+
+	ipe_free_policy(n->parsed);
+	kfree(n->data);
+
+	kfree(n);
+}
+
+/**
+ * alloc_callback: Callback given to verify_pkcs7_signature function to set
+ *		   the inner content reference and parse the policy.
+ * @ctx: "ipe_policy_node" to set inner content, size and parsed policy of.
+ * @data: Start of PKCS#7 inner content.
+ * @len: Length of @data.
+ * @asn1hdrlen: Unused.
+ *
+ * Return:
+ * 0 - OK
+ * ERR_PTR(-EBADMSG) - Invalid policy syntax
+ * ERR_PTR(-ENOMEM) - Out of memory
+ */
+static int alloc_callback(void *ctx, const void *data, size_t len,
+			  size_t asn1hdrlen)
+{
+	char *cpy = NULL;
+	struct ipe_policy *pol = NULL;
+	struct ipe_policy_node *n = (struct ipe_policy_node *)ctx;
+
+	n->content = (const u8 *)data;
+	n->content_size = len;
+
+	if (len == 0)
+		return -EBADMSG;
+
+	cpy = kzalloc(len + 1, GFP_KERNEL);
+	if (!cpy)
+		return -ENOMEM;
+
+	(void)strncpy(cpy, data, len);
+
+	pol = ipe_parse_policy(cpy);
+	if (IS_ERR(pol)) {
+		kfree(cpy);
+		return PTR_ERR(pol);
+	}
+
+	n->parsed = pol;
+	kfree(cpy);
+	return 0;
+}
+
+/**
+ * ipe_alloc_policy_node: Allocate a new ipe_policy_node structure.
+ * @data: Raw enveloped PKCS#7 data that represents the policy.
+ * @len: Length of @data.
+ *
+ * Return:
+ * valid ipe_policy_node - OK
+ * ERR_PTR(-EBADMSG) - Invalid policy syntax
+ * ERR_PTR(-ENOMEM) - Out of memory
+ */
+static struct ipe_policy_node *ipe_alloc_policy_node(const u8 *data,
+						     size_t len)
+{
+	int rc = 0;
+	struct ipe_policy_node *node = NULL;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	node->data_len = len;
+	node->data = kmemdup(data, len, GFP_KERNEL);
+	if (!node->data) {
+		rc = -ENOMEM;
+		goto out2;
+	}
+
+	rc = verify_pkcs7_signature(node->content, node->content_size,
+				    node->data, node->data_len, NULL,
+				    VERIFYING_UNSPECIFIED_SIGNATURE,
+				    alloc_callback, node);
+	if (rc != 0)
+		goto out2;
+
+	return node;
+out2:
+	ipe_free_policy_node(node);
+out:
+	return ERR_PTR(rc);
+}
+
+/**
+ * ipe_build_policy_secfs_node: Build a new securityfs node for IPE policies.
+ * @data: Raw enveloped PKCS#7 data that represents the policy.
+ * @len: Length of @data.
+ *
+ * Return:
+ * 0 - OK
+ * -EEXIST - Policy already exists
+ * -EBADMSG - Invalid policy syntax
+ * -ENOMEM - Out of memory
+ */
+int ipe_build_policy_secfs_node(const u8 *data, size_t len)
+{
+	int rc = 0;
+	struct dentry *raw = NULL;
+	struct dentry *root = NULL;
+	struct inode *root_i = NULL;
+	struct dentry *content = NULL;
+	struct crypto_shash *tfm = NULL;
+	struct ipe_policy_node *node = NULL;
+
+	tfm = crypto_alloc_shash("sha1", 0, 0);
+	if (IS_ERR(tfm))
+		goto out;
+
+	node = ipe_alloc_policy_node(data, len);
+	if (IS_ERR(node)) {
+		rc = PTR_ERR(node);
+		goto out2;
+	}
+
+	root = securityfs_create_dir(node->parsed->policy_name,
+				     ipe_policies_root);
+	if (IS_ERR(root)) {
+		rc = PTR_ERR(root);
+		goto out3;
+	}
+
+	root_i = d_inode(root);
+
+	inode_lock(root_i);
+	root_i->i_private = node;
+	ipe_audit_policy_load(node->parsed, node->data, node->data_len, tfm);
+	inode_unlock(root_i);
+
+	raw = securityfs_create_file(IPE_FULL_CONTENT, 0644, root, NULL,
+				     &policy_raw_ops);
+	if (IS_ERR(raw)) {
+		rc = PTR_ERR(raw);
+		goto out4;
+	}
+
+	content = securityfs_create_file(IPE_INNER_CONTENT, 0444, root,
+					 NULL, &policy_content_ops);
+	if (IS_ERR(raw)) {
+		rc = PTR_ERR(raw);
+		goto out5;
+	}
+
+	crypto_free_shash(tfm);
+	return rc;
+out5:
+	securityfs_remove(raw);
+out4:
+	securityfs_remove(root);
+out3:
+	ipe_free_policy_node(node);
+out2:
+	crypto_free_shash(tfm);
+out:
+	return rc;
+}
+
+/**
+ * ipe_secfs_new_policy: Entry point of the securityfs node, "ipe/new_policy".
+ * @f: Unused
+ * @data: Raw enveloped PKCS#7 data that represents the policy.
+ * @len: Length of @data.
+ * @offset: Offset for @data.
+ *
+ * Return:
+ * > 0 - OK
+ * -EEXIST - Policy already exists
+ * -EBADMSG - Invalid policy syntax
+ * -ENOMEM - Out of memory
+ * -EPERM - if a MAC subsystem is enabled, missing CAP_MAC_ADMIN
+ */
+static ssize_t ipe_secfs_new_policy(struct file *f, const char __user *data,
+				    size_t len, loff_t *offset)
+{
+	ssize_t rc = 0;
+	u8 *cpy = NULL;
+	ssize_t written = 0;
+
+	if (!ns_capable(current_user_ns(), CAP_MAC_ADMIN))
+		return -EPERM;
+
+	cpy = kzalloc(len, GFP_KERNEL);
+	if (!cpy) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	written = simple_write_to_buffer(cpy, len, offset, data, len);
+	if (written < 0) {
+		rc = written;
+		goto err;
+	}
+
+	rc = ipe_build_policy_secfs_node(cpy, written);
+err:
+	kfree(cpy);
+	return rc < 0 ? rc : written;
+}
+
+/**
+ * retrieve_backed_dentry: Retrieve a dentry with a backing inode, identified
+ *			   by @name, under @parent.
+ * @name: Name of the dentry under @parent.
+ * @parent: The parent dentry to search under for @name.
+ * @size: Length of @name.
+ *
+ * This takes a reference to the returned dentry. Caller needs to call dput
+ * to drop the reference.
+ *
+ * Return:
+ * valid dentry - OK
+ * ERR_PTR - Error, see lookup_one_len_unlocked
+ * NULL - No backing inode was found
+ */
+static struct dentry *retrieve_backed_dentry(const char *name,
+					     struct dentry *parent,
+					     size_t size)
+{
+	int rc = 0;
+	struct dentry *tmp = NULL;
+
+	tmp = lookup_one_len_unlocked(name, parent, size);
+	if (IS_ERR(tmp)) {
+		rc = PTR_ERR(tmp);
+		goto out;
+	}
+
+	if (!d_really_is_positive(tmp))
+		goto out1;
+
+	return tmp;
+out1:
+	tmp = NULL;
+out:
+	return rc == 0 ? NULL : ERR_PTR(rc);
+}
+
+/**
+ * ipe_secfs_del_policy: Delete a policy indicated by the name provided by
+ *			 @data
+ * @f: Unused.
+ * @data: Buffer containing the policy id to delete.
+ * @len: Length of @data.
+ * @offset: Offset into @data.
+ *
+ * NOTE: Newlines are treated as part of the name, if using echo to test,
+ * use -n to prohibit the silent addition of a newline.
+ *
+ * Return:
+ * > 0 - OK
+ * -ENOMEM - Out of memory
+ * -EPERM - Policy is active
+ * -ENOENT - Policy does not exist
+ * -EPERM - if a MAC subsystem is enabled, missing CAP_MAC_ADMIN
+ * Other - See retrieve_backed_dentry
+ */
+static ssize_t ipe_secfs_del_policy(struct file *f, const char __user *data,
+				    size_t len, loff_t *offset)
+{
+	ssize_t rc = 0;
+	char *id = NULL;
+	ssize_t written = 0;
+	struct dentry *raw = NULL;
+	struct dentry *content = NULL;
+	struct inode *policy_i = NULL;
+	struct dentry *policy_root = NULL;
+	struct inode *policies_root = NULL;
+	const struct ipe_policy *target = NULL;
+
+	if (!ns_capable(current_user_ns(), CAP_MAC_ADMIN))
+		return -EPERM;
+
+	id = kzalloc(len, GFP_KERNEL);
+	if (!id) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	written = simple_write_to_buffer(id, len, offset, data, len);
+	if (written < 0) {
+		rc = written;
+		goto out;
+	}
+
+	policies_root = d_inode(ipe_policies_root);
+
+	policy_root = retrieve_backed_dentry(id, ipe_policies_root, written);
+	if (IS_ERR_OR_NULL(policy_root)) {
+		rc = IS_ERR(policy_root) ? PTR_ERR(policy_root) : -ENOENT;
+		goto out;
+	}
+
+	policy_i = d_inode(policy_root);
+
+	/* if the found dentry matches boot policy, fail */
+	if (boot_policy_node == policy_root) {
+		rc = -EACCES;
+		goto out1;
+	}
+
+	target = ((struct ipe_policy_node *)policy_i->i_private)->parsed;
+
+	/* fail if it's the active policy */
+	if (ipe_is_active_policy(target)) {
+		rc = -EPERM;
+		goto out1;
+	}
+
+	raw = retrieve_backed_dentry(IPE_FULL_CONTENT, policy_root,
+				     strlen(IPE_FULL_CONTENT));
+	if (IS_ERR_OR_NULL(raw)) {
+		rc = IS_ERR(raw) ? PTR_ERR(raw) : -ENOENT;
+		goto out1;
+	}
+
+	content = retrieve_backed_dentry(IPE_INNER_CONTENT, policy_root,
+					 strlen(IPE_INNER_CONTENT));
+	if (IS_ERR_OR_NULL(content)) {
+		rc = IS_ERR(content) ? PTR_ERR(content) : -ENOENT;
+		goto out2;
+	}
+
+	inode_lock(policies_root);
+	ipe_free_policy_node(policy_i->i_private);
+	policy_i->i_private = NULL;
+	inode_unlock(policies_root);
+
+	dput(raw);
+	dput(content);
+	dput(policy_root);
+	securityfs_remove(raw);
+	securityfs_remove(content);
+	securityfs_remove(policy_root);
+
+	kfree(id);
+	return written;
+out2:
+	dput(raw);
+out1:
+	dput(policy_root);
+out:
+	kfree(id);
+	return rc;
+}
+
+/**
+ * ipe_secfs_rd_policy: Read the raw content (full enveloped PKCS7) data of
+ *			the policy stored within the file's parent inode.
+ * @f: File representing the securityfs entry.
+ * @data: User mode buffer to place the raw pkcs7.
+ * @len: Length of @data.
+ * @offset: Offset into @data.
+ *
+ * Return:
+ * > 0 - OK
+ * -ENOMEM - Out of memory
+ */
+static ssize_t ipe_secfs_rd_policy(struct file *f, char __user *data,
+				   size_t size, loff_t *offset)
+{
+	ssize_t rc = 0;
+	size_t avail = 0;
+	u8 *buffer = NULL;
+	struct inode *root = NULL;
+	const struct ipe_policy_node *node = NULL;
+
+	root = d_inode(f->f_path.dentry->d_parent);
+
+	inode_lock_shared(root);
+	node = (const struct ipe_policy_node *)root->i_private;
+
+	avail = node->data_len;
+	buffer = kmemdup(node->data, avail, GFP_KERNEL);
+	if (!buffer) {
+		rc = -ENOMEM;
+		goto cleanup;
+	}
+
+	rc = simple_read_from_buffer(data, size, offset, buffer, avail);
+cleanup:
+	inode_unlock_shared(root);
+
+	return rc;
+}
+
+/**
+ * ipe_secfs_ud_policy: Update a policy in place with a new PKCS7 policy.
+ * @f: File representing the securityfs entry.
+ * @data: Buffer user mode to place the raw pkcs7.
+ * @len: Length of @data.
+ * @offset: Offset into @data.
+ *
+ * Return:
+ * 0 - OK
+ * -EBADMSG - Invalid policy format
+ * -ENOMEM - Out of memory
+ * -EPERM - if a MAC subsystem is enabled, missing CAP_MAC_ADMIN
+ * -EINVAL - Incorrect policy name for this node, or version is < current
+ */
+static ssize_t ipe_secfs_ud_policy(struct file *f, const char __user *data,
+				   size_t len, loff_t *offset)
+{
+	ssize_t rc = 0;
+	u8 *cpy = NULL;
+	ssize_t written = 0;
+	struct inode *root = NULL;
+	struct crypto_shash *tfm = NULL;
+	struct ipe_policy_node *new = NULL;
+	struct ipe_policy_node *old = NULL;
+
+	if (!ns_capable(current_user_ns(), CAP_MAC_ADMIN))
+		return -EPERM;
+
+	cpy = kzalloc(len, GFP_KERNEL);
+	if (!cpy) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	written = simple_write_to_buffer(cpy, len, offset, data, len);
+	if (written < 0) {
+		rc = written;
+		goto out;
+	}
+
+	new = ipe_alloc_policy_node(cpy, len);
+	if (IS_ERR(new)) {
+		rc = PTR_ERR(new);
+		goto out;
+	}
+
+	tfm = crypto_alloc_shash("sha1", 0, 0);
+	if (IS_ERR(tfm))
+		goto out2;
+
+	root = d_inode(f->f_path.dentry->d_parent);
+	inode_lock(root);
+
+	old = (struct ipe_policy_node *)root->i_private;
+
+	if (strcmp(old->parsed->policy_name, new->parsed->policy_name)) {
+		rc = -EINVAL;
+		goto out3;
+	}
+
+	if (!ipe_is_valid_policy(old->parsed, new->parsed)) {
+		rc = -EINVAL;
+		goto out3;
+	}
+
+	rc = ipe_update_active_policy(old->parsed, new->parsed);
+	if (rc != 0)
+		goto out3;
+
+	ipe_audit_policy_load(new->parsed, new->data, new->data_len, tfm);
+	swap(root->i_private, new);
+
+	inode_unlock(root);
+	kfree(cpy);
+	ipe_free_policy_node(new);
+	crypto_free_shash(tfm);
+
+	return written;
+out3:
+	inode_unlock(root);
+	ipe_free_policy_node(new);
+out2:
+	crypto_free_shash(tfm);
+out:
+	kfree(cpy);
+	return rc;
+}
+
+/**
+ * ipe_secfs_rd_content: Read the inner content of the enveloped PKCS7 data,
+ *			 representing the IPE policy.
+ * @f: File representing the securityfs entry.
+ * @data: User mode buffer to place the inner content of the pkcs7 data.
+ * @len: Length of @data.
+ * @offset: Offset into @data.
+ *
+ * Return:
+ * > 0 - OK
+ * -ENOMEM - Out of memory
+ */
+static ssize_t ipe_secfs_rd_content(struct file *f, char __user *data,
+				    size_t size, loff_t *offset)
+{
+	ssize_t rc = 0;
+	size_t avail = 0;
+	u8 *buffer = NULL;
+	struct inode *root = NULL;
+	const struct ipe_policy_node *node = NULL;
+
+	root = d_inode(f->f_path.dentry->d_parent);
+
+	inode_lock(root);
+	node = (const struct ipe_policy_node *)root->i_private;
+
+	avail = node->content_size;
+	buffer = kmemdup(node->content, avail, GFP_KERNEL);
+	if (!buffer) {
+		rc = -ENOMEM;
+		goto cleanup;
+	}
+
+	rc = simple_read_from_buffer(data, size, offset, buffer, avail);
+cleanup:
+	inode_unlock(root);
+
+	return rc;
+}
+
+/**
+ * ipe_build_secfs_root: Build the root of securityfs for IPE.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - See securityfs_create_dir and securityfs_create_file
+ */
+int __init ipe_build_secfs_root(void)
+{
+	int rc = 0;
+	struct dentry *new = NULL;
+	struct dentry *del = NULL;
+	struct dentry *root = NULL;
+	struct dentry *policies = NULL;
+
+	root = securityfs_create_dir(IPE_ROOT, NULL);
+	if (IS_ERR(root)) {
+		rc = PTR_ERR(root);
+		goto out;
+	}
+
+	new = securityfs_create_file(IPE_NEW_POLICY, 0644, root, NULL,
+				     &new_policy_ops);
+	if (IS_ERR(new)) {
+		rc = PTR_ERR(new);
+		goto out1;
+	}
+
+	del = securityfs_create_file(IPE_DELETE_POLICY, 0644, root, NULL,
+				     &del_policy_ops);
+	if (IS_ERR(del)) {
+		rc = PTR_ERR(del);
+		goto out2;
+	}
+
+	policies = securityfs_create_dir(IPE_POLICIES, root);
+	if (IS_ERR(policies)) {
+		rc = PTR_ERR(policies);
+		goto out3;
+	}
+
+	ipe_secfs_root = root;
+	ipe_new_policy = new;
+	ipe_del_policy = del;
+	ipe_policies_root = policies;
+
+	return rc;
+
+out3:
+	securityfs_remove(del);
+out2:
+	securityfs_remove(new);
+out1:
+	securityfs_remove(root);
+out:
+	return rc;
+}
+
+/**
+ * ipe_build_secfs_boot_node: Build a policy node for IPE's boot policy.
+ *
+ * This differs from the normal policy nodes, as the IPE boot policy is
+ * read only.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - See securityfs_create_dir and securityfs_create_file
+ */
+static int __init ipe_build_secfs_boot_node(void)
+{
+	int rc = 0;
+	char *cpy = NULL;
+	struct dentry *raw = NULL;
+	struct inode *raw_i = NULL;
+	struct dentry *root = NULL;
+	struct dentry *content = NULL;
+	struct ipe_policy *parsed = NULL;
+	struct ipe_policy_node *node = NULL;
+
+	if (!ipe_boot_policy)
+		return 0;
+
+	node = kzalloc(sizeof(*node), GFP_KERNEL);
+	if (!node) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	cpy = kstrdup(ipe_boot_policy, GFP_KERNEL);
+	if (!cpy) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	parsed = ipe_parse_policy(cpy);
+	if (IS_ERR(parsed)) {
+		rc = PTR_ERR(parsed);
+		goto out2;
+	}
+
+	node->content = ipe_boot_policy;
+	node->content_size = strlen(cpy);
+	node->parsed = parsed;
+
+	root = securityfs_create_dir(node->parsed->policy_name,
+				     ipe_policies_root);
+	if (IS_ERR(root)) {
+		rc = PTR_ERR(root);
+		goto out2;
+	}
+
+	raw_i = d_inode(root);
+
+	inode_lock(raw_i);
+	raw_i->i_private = node;
+	inode_unlock(raw_i);
+
+	content = securityfs_create_file(IPE_INNER_CONTENT, 0444, root, NULL,
+					 &policy_content_ops);
+	if (IS_ERR(raw)) {
+		rc = PTR_ERR(raw);
+		goto out3;
+	}
+
+	boot_policy_node = root;
+	rc = ipe_activate_policy(node->parsed);
+	return rc;
+
+out3:
+	securityfs_remove(root);
+out2:
+	ipe_free_policy(parsed);
+out:
+	kfree(cpy);
+	kfree(node);
+	return rc;
+}
+
+/**
+ * ipe_set_active_policy: Set the policy identified by @id as the active
+ *			  policy.
+ * @id: Policy id represnting the policy to activate.
+ * @id_len: Length of @id.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOENT - Policy identified by @id does not exist
+ * -EINVAL - Policy that is being activated is lower in version than
+ *	     currently running policy.
+ * Other - See retrieve_backed_dentry
+ */
+int ipe_set_active_policy(const char *id, size_t id_len)
+{
+	int rc = 0;
+	struct dentry *policy_root = NULL;
+	const struct ipe_policy_node *ref = NULL;
+
+	policy_root = retrieve_backed_dentry(id, ipe_policies_root, id_len);
+	if (IS_ERR_OR_NULL(policy_root))
+		return IS_ERR(policy_root) ? PTR_ERR(policy_root) : -ENOENT;
+
+	inode_lock_shared(d_inode(policy_root));
+
+	ref = (const struct ipe_policy_node *)d_inode(policy_root)->i_private;
+	rc = ipe_activate_policy(ref->parsed);
+
+	inode_unlock_shared(d_inode(policy_root));
+	dput(policy_root);
+
+	return rc;
+}
+
+/**
+ * ipe_securityfs_init: Initialize IPE's securityfs entries.
+ *
+ * This is called after the lsm initialization.
+ *
+ * Return:
+ * 0 - OK
+ * !0 - Error
+ */
+int __init ipe_securityfs_init(void)
+{
+	int rc = 0;
+
+	rc = ipe_build_secfs_root();
+	if (rc != 0)
+		goto err;
+
+	rc = ipe_build_secfs_boot_node();
+	if (rc != 0)
+		panic("IPE failed to initialize the boot policy: %d", rc);
+
+	return rc;
+err:
+	pr_err("failed to initialize secfs: %d", -rc);
+	return rc;
+}
+
+core_initcall(ipe_securityfs_init);
diff --git a/security/ipe/ipe-secfs.h b/security/ipe/ipe-secfs.h
new file mode 100644
index 000000000000..714ae70a4c8e
--- /dev/null
+++ b/security/ipe/ipe-secfs.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#include <linux/types.h>
+
+#include "ipe-policy.h"
+
+#ifndef IPE_SECFS_H
+#define IPE_SECFS_H
+
+/**
+ * ipe_set_active_policy: Set the policy identified by @id as the active
+ *			  policy.
+ * @id: Policy id represnting the policy to activate.
+ * @id_len: Length of @id.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOENT - Policy identified by @id does not exist
+ * Other - See retrieve_backed_dentry
+ */
+int ipe_set_active_policy(const char *id, size_t id_len);
+
+#endif /* IPE_SECFS_H */
diff --git a/security/ipe/ipe-sysfs.c b/security/ipe/ipe-sysfs.c
new file mode 100644
index 000000000000..a3b17d6d2db4
--- /dev/null
+++ b/security/ipe/ipe-sysfs.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ipe-audit.h"
+#include "ipe-secfs.h"
+
+#include <linux/sysctl.h>
+#include <linux/fs.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#ifdef CONFIG_SYSCTL
+
+#ifdef CONFIG_SECURITY_IPE_PERMISSIVE_SWITCH
+
+/**
+ * ipe_switch_mode: Handler to switch IPE's modes between permissive
+ *		    and enforce.
+ * @table: Sysctl table entry from the variable, sysctl_table.
+ * @write: Integer indicating whether this is a write or a read.
+ * @buffer: Data passed to sysctl, this should be 1 or 0 for this function.
+ * @lenp: Pointer to the size of @buffer.
+ * @ppos: Offset into @buffer.
+ *
+ * This wraps proc_dointvec_minmax, and if there's a change, emits an
+ * audit event.
+ *
+ * Return:
+ * 0 - OK
+ * -EPERM - if a MAC subsystem is enabled, missing CAP_MAC_ADMIN
+ * Other - See proc_dointvec_minmax
+ */
+static int ipe_switch_mode(struct ctl_table *table, int write,
+			   void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	int old = enforce;
+	int ret = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+
+	if (ret == 0 && old != enforce)
+		ipe_audit_mode();
+
+	return ret;
+}
+
+#endif /* CONFIG_SECURITY_IPE_PERMISSIVE_SWITCH */
+
+#ifdef CONFIG_SECURITYFS
+
+/**
+ * ipe_switch_active_policy: Handler to switch the policy IPE is enforcing.
+ * @table: Sysctl table entry from the variable, sysctl_table.
+ * @write: Integer indicating whether this is a write or a read.
+ * @buffer: Data passed to sysctl. This is the policy id to activate,
+ *	    for this function.
+ * @lenp: Pointer to the size of @buffer.
+ * @ppos: Offset into @buffer.
+ *
+ * This wraps proc_dointvec_minmax, and if there's a change, emits an
+ * audit event.
+ *
+ * Return:
+ * 0 - OK
+ * -EPERM - if a MAC subsystem is enabled, missing CAP_MAC_ADMIN
+ * -ENOMEM - Out of memory
+ * -ENOENT - Policy identified by @id does not exist
+ * Other - See proc_dostring and retrieve_backed_dentry
+ */
+static int ipe_switch_active_policy(struct ctl_table *table, int write,
+				    void __user *buffer, size_t *lenp,
+				    loff_t *ppos)
+{
+	int rc = 0;
+	char *id = NULL;
+	size_t size = 0;
+
+	if (write) {
+		id = kzalloc((*lenp) + 1, GFP_KERNEL);
+		if (!id)
+			return -ENOMEM;
+
+		table->data = id;
+		table->maxlen = (*lenp) + 1;
+
+		rc = proc_dostring(table, write, buffer, lenp, ppos);
+		if (rc != 0)
+			goto out;
+
+		rc = ipe_set_active_policy(id, strlen(id));
+	} else {
+		rcu_read_lock();
+		size = strlen(rcu_dereference(ipe_active_policy)->policy_name);
+		rcu_read_unlock();
+
+		id = kzalloc(size + 1, GFP_KERNEL);
+		if (!id)
+			return -ENOMEM;
+
+		rcu_read_lock();
+		strncpy(id, rcu_dereference(ipe_active_policy)->policy_name,
+			size);
+		rcu_read_unlock();
+
+		table->data = id;
+		table->maxlen = size;
+
+		rc = proc_dostring(table, write, buffer, lenp, ppos);
+	}
+out:
+	kfree(id);
+	return rc;
+}
+
+#endif /* CONFIG_SECURITYFS */
+
+static struct ctl_table_header *sysctl_header;
+
+static const struct ctl_path sysctl_path[] = {
+	{
+		.procname = "ipe",
+	},
+	{}
+};
+
+static struct ctl_table sysctl_table[] = {
+#ifdef CONFIG_SECURITY_IPE_PERMISSIVE_SWITCH
+	{
+		.procname = "enforce",
+		.data = &enforce,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = ipe_switch_mode,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	},
+#endif /* CONFIG_SECURITY_IPE_PERMISSIVE_SWITCH */
+	{
+		.procname = "success_audit",
+		.data = &success_audit,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = proc_dointvec_minmax,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	},
+#ifdef CONFIG_SECURITYFS
+	{
+		.procname = "strict_parse",
+		.data = &strict_parse,
+		.maxlen = sizeof(int),
+		.mode = 0644,
+		.proc_handler = proc_dointvec_minmax,
+		.extra1 = SYSCTL_ZERO,
+		.extra2 = SYSCTL_ONE,
+	},
+	{
+		.procname = "active_policy",
+		.data = NULL,
+		.maxlen = 0,
+		.mode = 0644,
+		.proc_handler = ipe_switch_active_policy,
+	},
+#endif /* CONFIG_SECURITYFS */
+	{}
+	/* TODO: Active Policy Selector */
+};
+
+/**
+ * ipe_sysctl_init: Initialize IPE's sysfs entries.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM - Sysctl registration failed
+ */
+int __init ipe_sysctl_init(void)
+{
+	sysctl_header = register_sysctl_paths(sysctl_path, sysctl_table);
+
+	if (!sysctl_header) {
+		pr_err("sysctl registration failed");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+#else /* !CONFIG_SYSCTL */
+
+/**
+ * ipe_sysctl_init: Initialize IPE's sysfs entries.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM - Sysctl registration failed
+ */
+inline int __init ipe_sysctl_init(void)
+{
+	return 0;
+}
+
+#endif /* !CONFIG_SYSCTL */
diff --git a/security/ipe/ipe-sysfs.h b/security/ipe/ipe-sysfs.h
new file mode 100644
index 000000000000..7afd92e8220d
--- /dev/null
+++ b/security/ipe/ipe-sysfs.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#include <linux/types.h>
+
+#include "ipe.h"
+
+#ifndef IPE_SYSFS_H
+#define IPE_SYSFS_H
+
+/**
+ * ipe_sysctl_init: Initialize IPE's sysfs entries.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM - Sysctl registration failed
+ */
+int __init ipe_sysctl_init(void);
+
+#endif /* IPE_SYSFS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
new file mode 100644
index 000000000000..4642a0da57e5
--- /dev/null
+++ b/security/ipe/ipe.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ipe-policy.h"
+#include "ipe-hooks.h"
+#include "ipe-secfs.h"
+#include "ipe-sysfs.h"
+
+#include <linux/module.h>
+#include <linux/lsm_hooks.h>
+#include <linux/sysctl.h>
+#include <linux/rcupdate.h>
+#include <linux/fs.h>
+#include <linux/kernel.h>
+#include <linux/security.h>
+
+static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(bprm_check_security, ipe_on_exec),
+	LSM_HOOK_INIT(mmap_file, ipe_on_mmap),
+	LSM_HOOK_INIT(kernel_read_file, ipe_on_kernel_read),
+	LSM_HOOK_INIT(kernel_load_data, ipe_on_kernel_load_data),
+	LSM_HOOK_INIT(file_mprotect, ipe_on_mprotect),
+};
+
+/**
+ * ipe_load_properties: Call the property entry points for all the IPE modules
+ *			that were selected at kernel build-time.
+ *
+ * Return:
+ * 0 - OK
+ */
+static int __init ipe_load_properties(void)
+{
+	return 0;
+}
+
+/**
+ * ipe_init: Entry point of IPE.
+ *
+ * This is called at LSM init, which happens occurs early during kernel
+ * start up. During this phase, IPE initializes the sysctls, loads the
+ * properties compiled into the kernel, and register's IPE's hooks.
+ * The boot policy is loaded later, during securityfs init, at which point
+ * IPE will start enforcing its policy.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM - sysctl registration failed.
+ */
+static int __init ipe_init(void)
+{
+	int rc = 0;
+
+	rc = ipe_sysctl_init();
+	if (rc != 0)
+		pr_err("failed to configure sysctl: %d", -rc);
+
+	pr_info("mode=%s", (enforce == 1) ? IPE_MODE_ENFORCE :
+					    IPE_MODE_PERMISSIVE);
+
+	RCU_INIT_POINTER(ipe_active_policy, NULL);
+
+	security_add_hooks(ipe_hooks, ARRAY_SIZE(ipe_hooks), "IPE");
+
+	return rc;
+}
+
+DEFINE_LSM(ipe) = {
+	.name = "ipe",
+	.init = ipe_init,
+};
+
+int enforce = 1;
+
+#ifdef CONFIG_SECURITY_IPE_PERMISSIVE_SWITCH
+
+/**
+ * enforce: Kernel command line parameter to set the permissive mode for IPE
+ *	    at system startup. By default, this will always be in enforce mode.
+ *
+ * This is also controlled by the sysctl, "ipe.enforce".
+ */
+module_param(enforce, int, 0644);
+MODULE_PARM_DESC(enforce, "enforce/permissive mode switch");
+
+#endif /* CONFIG_SECURITY_IPE_PERMISSIVE_SWITCH */
+
+/**
+ * success_audit: Kernel command line parameter to enable success auditing
+ *		  (emit an audit event when a file is allowed) at system
+ *		  startup. By default, this will be off.
+ *
+ * This is also controlled by the sysctl, "ipe.success_audit".
+ */
+int success_audit;
+module_param(success_audit, int, 0644);
+MODULE_PARM_DESC(success_audit, "audit message on allow");
+
+/**
+ * strict_parse: Kernel command line parameter to enable strict parsing of
+ *		 IPE policies - causing unrecognized properties to fail
+ *		 parsing. This breaks backwards compatibility of IPE policies,
+ *		 when enabled.
+ *
+ * This is also controlled by the sysctl, "ipe.strict_parse".
+ */
+int strict_parse;
+module_param(strict_parse, int, 0644);
+MODULE_PARM_DESC(strict_parse, "parse using strict semantics");
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
new file mode 100644
index 000000000000..c016b57aa70b
--- /dev/null
+++ b/security/ipe/ipe.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef IPE_H
+#define IPE_H
+
+#define pr_fmt(fmt) "IPE " fmt
+
+#include <linux/types.h>
+#include <linux/fs.h>
+
+#define IPE_MODE_ENFORCE	"enforce"
+#define IPE_MODE_PERMISSIVE	"permissive"
+
+extern int enforce;
+extern int success_audit;
+extern int strict_parse;
+
+#endif /* IPE_H */
-- 
2.26.0
