Return-Path: <SRS0=XhuN=PB=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DFAFC433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:17:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id E89D661163
	for <dm-devel@archiver.kernel.org>; Wed, 13 Oct 2021 19:17:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org E89D661163
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-eYs8ny7uPRqM5kVq8J2mzA-1; Wed, 13 Oct 2021 15:17:18 -0400
X-MC-Unique: eYs8ny7uPRqM5kVq8J2mzA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CAAE018B9F0A;
	Wed, 13 Oct 2021 19:17:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AA3DD5F4E2;
	Wed, 13 Oct 2021 19:17:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 7EA04180598A;
	Wed, 13 Oct 2021 19:17:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 19DJD3HD018763 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Oct 2021 15:13:03 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 913C610FFE74; Wed, 13 Oct 2021 19:13:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A1AD100205D
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:13:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7301B802A67
	for <dm-devel@redhat.com>; Wed, 13 Oct 2021 19:13:00 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
	relay.mimecast.com with ESMTP id us-mta-282-XPDkYOt5Pt2pAuW_mjLYdQ-1;
	Wed, 13 Oct 2021 15:12:56 -0400
X-MC-Unique: XPDkYOt5Pt2pAuW_mjLYdQ-1
Received: from
	linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
	(linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 5E16720B9CFD;
	Wed, 13 Oct 2021 12:06:39 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5E16720B9CFD
From: deven.desai@linux.microsoft.com
To: corbet@lwn.net, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com,
	ebiggers@kernel.org, tytso@mit.edu, paul@paul-moore.com,
	eparis@redhat.com, jmorris@namei.org, serge@hallyn.com
Date: Wed, 13 Oct 2021 12:06:20 -0700
Message-Id: <1634151995-16266-2-git-send-email-deven.desai@linux.microsoft.com>
In-Reply-To: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
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
Cc: linux-security-module@vger.kernel.org, linux-doc@vger.kernel.org,
	jannh@google.com, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	dm-devel@redhat.com, linux-audit@redhat.com
Subject: [dm-devel] [RFC PATCH v7 01/16] security: add ipe lsm & initial
	context creation
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Deven Bowers <deven.desai@linux.microsoft.com>

Integrity Policy Enforcement (IPE) is an LSM that provides an
complimentary approach to Mandatory Access Control than existing LSMs
today.

Existing LSMs have centered around the concept of access to a resource
should be controlled by the current user's credentials. IPE's approach,
is that access to a resource should be controlled by the system's trust
of a current resource.

The basis of this approach is that every process in the kernel is
associated with a context that determines the policy for what is
trusted by said process and its descendents, starting with 'init'.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
---

Relevant changes since v6:
  * Split up patch 02/11 into three parts:
      1. context creation (new) [this patch]
      2. parser (refactored)
      3. evaluation loop
  * Refactor series to:
      1. Support a context structure, enabling easier testing

---
 MAINTAINERS           |   6 ++
 security/Kconfig      |  11 +--
 security/Makefile     |   1 +
 security/ipe/Kconfig  |  19 +++++
 security/ipe/Makefile |  11 +++
 security/ipe/ctx.c    | 161 ++++++++++++++++++++++++++++++++++++++++++
 security/ipe/ctx.h    |  28 ++++++++
 security/ipe/hooks.c  |  58 +++++++++++++++
 security/ipe/hooks.h  |  16 +++++
 security/ipe/ipe.c    |  57 +++++++++++++++
 security/ipe/ipe.h    |  19 +++++
 11 files changed, 382 insertions(+), 5 deletions(-)
 create mode 100644 security/ipe/Kconfig
 create mode 100644 security/ipe/Makefile
 create mode 100644 security/ipe/ctx.c
 create mode 100644 security/ipe/ctx.h
 create mode 100644 security/ipe/hooks.c
 create mode 100644 security/ipe/hooks.h
 create mode 100644 security/ipe/ipe.c
 create mode 100644 security/ipe/ipe.h

diff --git a/MAINTAINERS b/MAINTAINERS
index e0bca0de0df7..f1e76f791d47 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9279,6 +9279,12 @@ S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity.git
 F:	security/integrity/ima/
 
+INTEGRITY POLICY ENFORCEMENT (IPE)
+M:	Deven Bowers <deven.desai@linux.microsoft.com>
+M:	Fan Wu <wufan@linux.microsoft.com>
+S:	Supported
+F:	security/ipe/
+
 INTEL 810/815 FRAMEBUFFER DRIVER
 M:	Antonino Daplas <adaplas@gmail.com>
 L:	linux-fbdev@vger.kernel.org
diff --git a/security/Kconfig b/security/Kconfig
index 0ced7fd33e4d..6ed9b3b5a75c 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -239,6 +239,7 @@ source "security/yama/Kconfig"
 source "security/safesetid/Kconfig"
 source "security/lockdown/Kconfig"
 source "security/landlock/Kconfig"
+source "security/ipe/Kconfig"
 
 source "security/integrity/Kconfig"
 
@@ -278,11 +279,11 @@ endchoice
 
 config LSM
 	string "Ordered list of enabled LSMs"
-	default "landlock,lockdown,yama,loadpin,safesetid,integrity,smack,selinux,tomoyo,apparmor,bpf" if DEFAULT_SECURITY_SMACK
-	default "landlock,lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
-	default "landlock,lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf" if DEFAULT_SECURITY_TOMOYO
-	default "landlock,lockdown,yama,loadpin,safesetid,integrity,bpf" if DEFAULT_SECURITY_DAC
-	default "landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf"
+	default "landlock,lockdown,yama,loadpin,safesetid,integrity,smack,selinux,tomoyo,apparmor,bpf,ipe" if DEFAULT_SECURITY_SMACK
+	default "landlock,lockdown,yama,loadpin,safesetid,integrity,apparmor,selinux,smack,tomoyo,bpf,ipe" if DEFAULT_SECURITY_APPARMOR
+	default "landlock,lockdown,yama,loadpin,safesetid,integrity,tomoyo,bpf,ipe" if DEFAULT_SECURITY_TOMOYO
+	default "landlock,lockdown,yama,loadpin,safesetid,integrity,bpf,ipe" if DEFAULT_SECURITY_DAC
+	default "landlock,lockdown,yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor,bpf,ipe"
 	help
 	  A comma-separated list of LSMs, in initialization order.
 	  Any LSMs left off this list will be ignored. This can be
diff --git a/security/Makefile b/security/Makefile
index 18121f8f85cd..527b1864d96c 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_SECURITY_LOCKDOWN_LSM)	+= lockdown/
 obj-$(CONFIG_CGROUPS)			+= device_cgroup.o
 obj-$(CONFIG_BPF_LSM)			+= bpf/
 obj-$(CONFIG_SECURITY_LANDLOCK)		+= landlock/
+obj-$(CONFIG_SECURITY_IPE)		+= ipe/
 
 # Object integrity file lists
 obj-$(CONFIG_INTEGRITY)			+= integrity/
diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
new file mode 100644
index 000000000000..c4503083e92d
--- /dev/null
+++ b/security/ipe/Kconfig
@@ -0,0 +1,19 @@
+# SPDX-License-Identifier: GPL-2.0-only
+#
+# Integrity Policy Enforcement (IPE) configuration
+#
+
+menuconfig SECURITY_IPE
+	bool "Integrity Policy Enforcement (IPE)"
+	depends on SECURITY && SECURITYFS
+	select PKCS7_MESSAGE_PARSER
+	select SYSTEM_DATA_VERIFICATION
+	help
+	  This option enables the Integrity Policy Enforcement subsystem
+	  allowing systems to enforce integrity having no dependencies
+	  on filesystem metadata, making its decisions based off of kernel-
+	  resident features and data structures. A key feature of IPE is a
+	  customizable policy to allow admins to reconfigure integrity
+	  requirements on the fly.
+
+	  If unsure, answer N.
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
new file mode 100644
index 000000000000..ba3df729e252
--- /dev/null
+++ b/security/ipe/Makefile
@@ -0,0 +1,11 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Copyright (C) Microsoft Corporation. All rights reserved.
+#
+# Makefile for building the IPE module as part of the kernel tree.
+#
+
+obj-$(CONFIG_SECURITY_IPE) += \
+	ctx.o \
+	hooks.o \
+	ipe.o \
diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
new file mode 100644
index 000000000000..c24f5d1d41bd
--- /dev/null
+++ b/security/ipe/ctx.c
@@ -0,0 +1,161 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ctx.h"
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/parser.h>
+#include <linux/refcount.h>
+#include <linux/spinlock.h>
+
+/**
+ * ipe_current_ctx: Helper to retrieve the ipe_context for the current task.
+ *
+ * Return:
+ *	See ipe_get_ctx_rcu
+ */
+struct ipe_context *ipe_current_ctx(void)
+{
+	return ipe_get_ctx_rcu(*ipe_tsk_ctx(current));
+}
+
+/**
+ * ipe_tsk_ctx: Retrieve the RCU-protected address of the task
+ *		that contains the ipe_context.
+ * @tsk: Task to retrieve the address from.
+ *
+ * Callers need to use the rcu* family functions to interact with
+ * the ipe_context, or ipe_get_ctx_rcu.
+ *
+ * Return:
+ *	Valid Address to a location containing an RCU-protected ipe_context.
+ */
+struct ipe_context __rcu **ipe_tsk_ctx(struct task_struct *tsk)
+{
+	return tsk->security + ipe_blobs.lbs_task;
+}
+
+/**
+ * ipe_get_ctx_rcu: Retrieve the underlying ipe_context in an rcu protected
+ *		    address space.
+ * @ctx: Context to dereference.
+ *
+ * This function will increment the reference count of the dereferenced
+ * ctx, ensuring that it is valid outside of the rcu_read_lock.
+ *
+ * However, if a context has a reference count of 0 (and thus being)
+ * freed, this API will return NULL.
+ *
+ * Return:
+ *	!NULL - Valid context
+ *	NULL - the dereferenced context will not exist outside after the
+ *	       next grace period.
+ */
+struct ipe_context *ipe_get_ctx_rcu(struct ipe_context __rcu *ctx)
+{
+	struct ipe_context *rv = NULL;
+
+	rcu_read_lock();
+
+	rv = rcu_dereference(ctx);
+	if (!rv || !refcount_inc_not_zero(&rv->refcount))
+		rv = NULL;
+
+	rcu_read_unlock();
+
+	return rv;
+}
+
+/**
+ * free_ctx_work: Worker function to deallocate a context structure.
+ * @work: work_struct passed to schedule_work
+ */
+static void free_ctx_work(struct work_struct *const work)
+{
+	struct ipe_context *ctx = NULL;
+
+	ctx = container_of(work, struct ipe_context, free_work);
+
+	kfree(ctx);
+}
+
+/**
+ * create_ctx: Allocate a context structure.
+ *
+ * The reference count at this point will be set to 1.
+ *
+ * Return:
+ * !IS_ERR - OK
+ * ERR_PTR(-ENOMEM) - Lack of memory.
+ */
+static struct ipe_context *create_ctx(void)
+{
+	int rc = 0;
+	struct ipe_context *ctx = NULL;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	INIT_WORK(&ctx->free_work, free_ctx_work);
+	refcount_set(&ctx->refcount, 1);
+	spin_lock_init(&ctx->lock);
+
+	return ctx;
+
+err:
+	ipe_put_ctx(ctx);
+	return ERR_PTR(rc);
+}
+
+/**
+ * ipe_put_ns: Decrement the reference of an ipe_context structure,
+ *	       scheduling a free as necessary.s
+ * @ctx: Structure to free
+ *
+ * This function no-ops on error and null values for @ctx, and the
+ * deallocation will only occur if the refcount is 0.
+ */
+void ipe_put_ctx(struct ipe_context *ctx)
+{
+	if (IS_ERR_OR_NULL(ctx) || !refcount_dec_and_test(&ctx->refcount))
+		return;
+
+	schedule_work(&ctx->free_work);
+}
+
+/**
+ * ipe_init_ctx: Initialize the init context.
+ *
+ * This is called at LSM init, and marks the kernel init process
+ * with a context. All processes descendent from kernel
+ * init will inherit this context.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM: Not enough memory to allocate the init context.
+ */
+int __init ipe_init_ctx(void)
+{
+	int rc = 0;
+	struct ipe_context *lns = NULL;
+
+	lns = create_ctx();
+	if (IS_ERR(lns)) {
+		rc = PTR_ERR(lns);
+		goto err;
+	}
+
+	rcu_assign_pointer(*ipe_tsk_ctx(current), lns);
+
+	return 0;
+err:
+	ipe_put_ctx(lns);
+	return rc;
+}
diff --git a/security/ipe/ctx.h b/security/ipe/ctx.h
new file mode 100644
index 000000000000..69a2c92c0a8c
--- /dev/null
+++ b/security/ipe/ctx.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef IPE_CONTEXT_H
+#define IPE_CONTEXT_H
+
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/refcount.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+
+struct ipe_context {
+	refcount_t refcount;
+	/* Protects concurrent writers */
+	spinlock_t lock;
+
+	struct work_struct free_work;
+};
+
+int __init ipe_init_ctx(void);
+struct ipe_context __rcu **ipe_tsk_ctx(struct task_struct *tsk);
+struct ipe_context *ipe_current_ctx(void);
+struct ipe_context *ipe_get_ctx_rcu(struct ipe_context __rcu *ctx);
+void ipe_put_ctx(struct ipe_context *ctx);
+
+#endif /* IPE_CONTEXT_H */
diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
new file mode 100644
index 000000000000..ed0c886eaa5a
--- /dev/null
+++ b/security/ipe/hooks.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ctx.h"
+#include "hooks.h"
+
+#include <linux/sched.h>
+#include <linux/types.h>
+#include <linux/refcount.h>
+#include <linux/rcupdate.h>
+
+/**
+ * ipe_task_alloc: Assign a new context for an associated task structure.
+ * @task: Supplies the task structure to assign a context to.
+ * @clone_flags: unused.
+ *
+ * The context assigned is always the context of the current task.
+ * Reference counts are dropped by ipe_task_free
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM - Out of Memory
+ */
+int ipe_task_alloc(struct task_struct *task, unsigned long clone_flags)
+{
+	struct ipe_context __rcu **ctx = NULL;
+	struct ipe_context *current_ctx = NULL;
+
+	current_ctx = ipe_current_ctx();
+	ctx = ipe_tsk_ctx(task);
+	rcu_assign_pointer(*ctx, current_ctx);
+	refcount_inc(&current_ctx->refcount);
+
+	ipe_put_ctx(current_ctx);
+	return 0;
+}
+
+/**
+ * ipe_task_free: Drop a reference to an ipe_context associated with @task.
+ *		  If there are no tasks remaining, the context is freed.
+ * @task: Supplies the task to drop an ipe_context reference to.
+ */
+void ipe_task_free(struct task_struct *task)
+{
+	struct ipe_context *ctx;
+
+	/*
+	 * This reference was the initial creation, no need to increment
+	 * refcount
+	 */
+	rcu_read_lock();
+	ctx = rcu_dereference(*ipe_tsk_ctx(task));
+	ipe_put_ctx(ctx);
+	rcu_read_unlock();
+}
diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
new file mode 100644
index 000000000000..e0ae3c7dfb5b
--- /dev/null
+++ b/security/ipe/hooks.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+#ifndef IPE_HOOKS_H
+#define IPE_HOOKS_H
+
+#include <linux/types.h>
+#include <linux/sched.h>
+
+int ipe_task_alloc(struct task_struct *task,
+		   unsigned long clone_flags);
+
+void ipe_task_free(struct task_struct *task);
+
+#endif /* IPE_HOOKS_H */
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
new file mode 100644
index 000000000000..d600346702e5
--- /dev/null
+++ b/security/ipe/ipe.c
@@ -0,0 +1,57 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include "ipe.h"
+#include "ctx.h"
+#include "hooks.h"
+
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/security.h>
+#include <linux/rcupdate.h>
+#include <linux/lsm_hooks.h>
+
+struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
+	.lbs_task = sizeof(struct ipe_context __rcu *),
+};
+
+static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(task_alloc, ipe_task_alloc),
+	LSM_HOOK_INIT(task_free, ipe_task_free),
+};
+
+/**
+ * ipe_init: Entry point of IPE.
+ *
+ * This is called at LSM init, which happens occurs early during kernel
+ * start up. During this phase, IPE loads the properties compiled into
+ * the kernel, and register's IPE's hooks. The boot policy is loaded
+ * later, during securityfs init, at which point IPE will start
+ * enforcing its policy.
+ *
+ * Return:
+ * 0 - OK
+ * -ENOMEM - Context creation failed.
+ */
+static int __init ipe_init(void)
+{
+	int rc = 0;
+
+	rc = ipe_init_ctx();
+	if (rc)
+		return rc;
+
+	security_add_hooks(ipe_hooks, ARRAY_SIZE(ipe_hooks), "ipe");
+
+	return rc;
+}
+
+DEFINE_LSM(ipe) = {
+	.name = "ipe",
+	.init = ipe_init,
+	.blobs = &ipe_blobs,
+};
diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
new file mode 100644
index 000000000000..09c492b8fd03
--- /dev/null
+++ b/security/ipe/ipe.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#ifndef IPE_H
+#define IPE_H
+
+#define pr_fmt(fmt) "IPE " fmt "\n"
+
+#include "ctx.h"
+
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/lsm_hooks.h>
+
+extern struct lsm_blob_sizes ipe_blobs;
+
+#endif /* IPE_H */
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

