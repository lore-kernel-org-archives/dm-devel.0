Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE34E936EC
	for <dm-devel@archiver.kernel.org>; Wed,  4 Oct 2023 22:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1696457726;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EZxpgRS/K9LbT/y9gXjNez4cU14dLvCCHNOIwZSyQpY=;
	b=N0HM4o2LfwtMY3UYnTeNTFLJfsENgxc+Y6XKs78JmTLLLihX2gwY6I7PZZrfInlOe0cFA9
	Sc4XP605/wqJj0k4zBq/gQBMBoGmdbE9MYW93Hk3fQsAKXpRwB0bo1m7W7R19H6aVa47Cb
	cvP9c35FTnR6mWIAaQYSk6a2YBvSGhI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-s_AvfWJLMUiiUOowofGPow-1; Wed, 04 Oct 2023 18:15:16 -0400
X-MC-Unique: s_AvfWJLMUiiUOowofGPow-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50453101B048;
	Wed,  4 Oct 2023 22:15:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3B74D40C2015;
	Wed,  4 Oct 2023 22:15:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EBF9F19465BD;
	Wed,  4 Oct 2023 22:15:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 328AB19465A2
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 Oct 2023 22:15:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2069947AD4A; Wed,  4 Oct 2023 22:15:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1609A43532A
 for <dm-devel@redhat.com>; Wed,  4 Oct 2023 22:15:13 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E71FC1C05AA7
 for <dm-devel@redhat.com>; Wed,  4 Oct 2023 22:15:12 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182]) by
 relay.mimecast.com with ESMTP id us-mta-443-2cDTKRe_ONeSH-do0px-PA-1; Wed,
 04 Oct 2023 18:15:09 -0400
X-MC-Unique: 2cDTKRe_ONeSH-do0px-PA-1
Received: by linux.microsoft.com (Postfix, from userid 1052)
 id 2889120B74E1; Wed,  4 Oct 2023 15:09:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2889120B74E1
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com
Date: Wed,  4 Oct 2023 15:09:44 -0700
Message-Id: <1696457386-3010-18-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [RFC PATCH v11 17/19] scripts: add boot policy
 generation program
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>, roberto.sassu@huawei.com,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, audit@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>,
 linux-integrity@vger.kernel.org
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: linux.microsoft.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Deven Bowers <deven.desai@linux.microsoft.com>

Enables an IPE policy to be enforced from kernel start, enabling access
control based on trust from kernel startup. This is accomplished by
transforming an IPE policy indicated by CONFIG_IPE_BOOT_POLICY into a
c-string literal that is parsed at kernel startup as an unsigned policy.

Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
---
v2:
  + No Changes

v3:
  + No Changes

v4:
  + No Changes

v5:
  + No Changes

v6:
  + No Changes

v7:
  + Move from 01/11 to 14/16
  + Don't return errno directly.
  + Make output of script more user-friendly
  + Add escaping for tab and '?'
  + Mark argv pointer const
  + Invert return code check in the boot policy parsing code path.

v8:
  + No significant changes.

v9:
  + No changes

v10:
  + Update the init part code for rcu changes in the eval loop patch

v11:
  + Fix code style issues
---
 MAINTAINERS                   |   1 +
 scripts/Makefile              |   1 +
 scripts/ipe/Makefile          |   2 +
 scripts/ipe/polgen/.gitignore |   1 +
 scripts/ipe/polgen/Makefile   |   6 ++
 scripts/ipe/polgen/polgen.c   | 145 ++++++++++++++++++++++++++++++++++
 security/ipe/.gitignore       |   1 +
 security/ipe/Kconfig          |  10 +++
 security/ipe/Makefile         |  11 +++
 security/ipe/fs.c             |   8 ++
 security/ipe/ipe.c            |  12 +++
 11 files changed, 198 insertions(+)
 create mode 100644 scripts/ipe/Makefile
 create mode 100644 scripts/ipe/polgen/.gitignore
 create mode 100644 scripts/ipe/polgen/Makefile
 create mode 100644 scripts/ipe/polgen/polgen.c
 create mode 100644 security/ipe/.gitignore

diff --git a/MAINTAINERS b/MAINTAINERS
index b898f2f8f9c4..18b1aeea6306 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10394,6 +10394,7 @@ M:	Fan Wu <wufan@linux.microsoft.com>
 L:	linux-security-module@vger.kernel.org
 S:	Supported
 T:	git https://github.com/microsoft/ipe.git
+F:	scripts/ipe/
 F:	security/ipe/
 
 INTEL 810/815 FRAMEBUFFER DRIVER
diff --git a/scripts/Makefile b/scripts/Makefile
index 576cf64be667..1dbaf3a49aef 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -50,6 +50,7 @@ targets += module.lds
 subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
 subdir-$(CONFIG_MODVERSIONS) += genksyms
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
+subdir-$(CONFIG_SECURITY_IPE) += ipe
 
 # Let clean descend into subdirs
 subdir-	+= basic dtc gdb kconfig mod
diff --git a/scripts/ipe/Makefile b/scripts/ipe/Makefile
new file mode 100644
index 000000000000..e87553fbb8d6
--- /dev/null
+++ b/scripts/ipe/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+subdir-y := polgen
diff --git a/scripts/ipe/polgen/.gitignore b/scripts/ipe/polgen/.gitignore
new file mode 100644
index 000000000000..80f32f25d200
--- /dev/null
+++ b/scripts/ipe/polgen/.gitignore
@@ -0,0 +1 @@
+polgen
diff --git a/scripts/ipe/polgen/Makefile b/scripts/ipe/polgen/Makefile
new file mode 100644
index 000000000000..066060c22b4a
--- /dev/null
+++ b/scripts/ipe/polgen/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+hostprogs-always-y	:= polgen
+HOST_EXTRACFLAGS += \
+	-I$(srctree)/include \
+	-I$(srctree)/include/uapi \
+
diff --git a/scripts/ipe/polgen/polgen.c b/scripts/ipe/polgen/polgen.c
new file mode 100644
index 000000000000..40b6fe07f47b
--- /dev/null
+++ b/scripts/ipe/polgen/polgen.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) Microsoft Corporation. All rights reserved.
+ */
+
+#include <stdlib.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <errno.h>
+
+static void usage(const char *const name)
+{
+	printf("Usage: %s OutputFile (PolicyFile)\n", name);
+	exit(EINVAL);
+}
+
+static int policy_to_buffer(const char *pathname, char **buffer, size_t *size)
+{
+	int rc = 0;
+	FILE *fd;
+	char *lbuf;
+	size_t fsize;
+	size_t read;
+
+	fd = fopen(pathname, "r");
+	if (!fd) {
+		rc = errno;
+		goto out;
+	}
+
+	fseek(fd, 0, SEEK_END);
+	fsize = ftell(fd);
+	rewind(fd);
+
+	lbuf = malloc(fsize);
+	if (!lbuf) {
+		rc = ENOMEM;
+		goto out_close;
+	}
+
+	read = fread((void *)lbuf, sizeof(*lbuf), fsize, fd);
+	if (read != fsize) {
+		rc = -1;
+		goto out_free;
+	}
+
+	*buffer = lbuf;
+	*size = fsize;
+	fclose(fd);
+
+	return rc;
+
+out_free:
+	free(lbuf);
+out_close:
+	fclose(fd);
+out:
+	return rc;
+}
+
+static int write_boot_policy(const char *pathname, const char *buf, size_t size)
+{
+	int rc = 0;
+	FILE *fd;
+	size_t i;
+
+	fd = fopen(pathname, "w");
+	if (!fd) {
+		rc = errno;
+		goto err;
+	}
+
+	fprintf(fd, "/* This file is automatically generated.");
+	fprintf(fd, " Do not edit. */\n");
+	fprintf(fd, "#include <linux/stddef.h>\n");
+	fprintf(fd, "\nextern const char *const ipe_boot_policy;\n\n");
+	fprintf(fd, "const char *const ipe_boot_policy =\n");
+
+	if (!buf || size == 0) {
+		fprintf(fd, "\tNULL;\n");
+		fclose(fd);
+		return 0;
+	}
+
+	fprintf(fd, "\t\"");
+
+	for (i = 0; i < size; ++i) {
+		switch (buf[i]) {
+		case '"':
+			fprintf(fd, "\\\"");
+			break;
+		case '\'':
+			fprintf(fd, "'");
+			break;
+		case '\n':
+			fprintf(fd, "\\n\"\n\t\"");
+			break;
+		case '\\':
+			fprintf(fd, "\\\\");
+			break;
+		case '\t':
+			fprintf(fd, "\\t");
+			break;
+		case '\?':
+			fprintf(fd, "\\?");
+			break;
+		default:
+			fprintf(fd, "%c", buf[i]);
+		}
+	}
+	fprintf(fd, "\";\n");
+	fclose(fd);
+
+	return 0;
+
+err:
+	if (fd)
+		fclose(fd);
+	return rc;
+}
+
+int main(int argc, const char *const argv[])
+{
+	int rc = 0;
+	size_t len = 0;
+	char *policy = NULL;
+
+	if (argc < 2)
+		usage(argv[0]);
+
+	if (argc > 2) {
+		rc = policy_to_buffer(argv[2], &policy, &len);
+		if (rc != 0)
+			goto cleanup;
+	}
+
+	rc = write_boot_policy(argv[1], policy, len);
+cleanup:
+	if (policy)
+		free(policy);
+	if (rc != 0)
+		perror("An error occurred during policy conversion: ");
+	return rc;
+}
diff --git a/security/ipe/.gitignore b/security/ipe/.gitignore
new file mode 100644
index 000000000000..eca22ad5ed22
--- /dev/null
+++ b/security/ipe/.gitignore
@@ -0,0 +1 @@
+boot-policy.c
\ No newline at end of file
diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
index 9dd5c4769d79..a6c5d48dd0a3 100644
--- a/security/ipe/Kconfig
+++ b/security/ipe/Kconfig
@@ -18,6 +18,16 @@ menuconfig SECURITY_IPE
 	  If unsure, answer N.
 
 if SECURITY_IPE
+config IPE_BOOT_POLICY
+	string "Integrity policy to apply on system startup"
+	help
+	  This option specifies a filepath to a IPE policy that is compiled
+	  into the kernel. This policy will be enforced until a policy update
+	  is deployed via the $securityfs/ipe/policies/$policy_name/active
+	  interface.
+
+	  If unsure, leave blank.
+
 menu "IPE Trust Providers"
 
 config IPE_PROP_DM_VERITY
diff --git a/security/ipe/Makefile b/security/ipe/Makefile
index 66de53687d11..ce23101b66ba 100644
--- a/security/ipe/Makefile
+++ b/security/ipe/Makefile
@@ -5,7 +5,16 @@
 # Makefile for building the IPE module as part of the kernel tree.
 #
 
+quiet_cmd_polgen = IPE_POL $(2)
+      cmd_polgen = scripts/ipe/polgen/polgen security/ipe/boot-policy.c $(2)
+
+targets += boot-policy.c
+
+$(obj)/boot-policy.c: scripts/ipe/polgen/polgen $(CONFIG_IPE_BOOT_POLICY) FORCE
+	$(call if_changed,polgen,$(CONFIG_IPE_BOOT_POLICY))
+
 obj-$(CONFIG_SECURITY_IPE) += \
+	boot-policy.o \
 	digest.o \
 	eval.o \
 	hooks.o \
@@ -15,3 +24,5 @@ obj-$(CONFIG_SECURITY_IPE) += \
 	policy_fs.o \
 	policy_parser.o \
 	audit.o \
+
+clean-files := boot-policy.c \
diff --git a/security/ipe/fs.c b/security/ipe/fs.c
index 0a1838432bd0..58584c5f3ee4 100644
--- a/security/ipe/fs.c
+++ b/security/ipe/fs.c
@@ -190,6 +190,7 @@ static const struct file_operations enforce_fops = {
 static int __init ipe_init_securityfs(void)
 {
 	int rc = 0;
+	struct ipe_policy *ap;
 
 	if (!ipe_enabled)
 		return -EOPNOTSUPP;
@@ -220,6 +221,13 @@ static int __init ipe_init_securityfs(void)
 		goto err;
 	}
 
+	ap = rcu_access_pointer(ipe_active_policy);
+	if (ap) {
+		rc = ipe_new_policyfs_node(ap);
+		if (rc)
+			goto err;
+	}
+
 	np = securityfs_create_file("new_policy", 0200, root, NULL, &np_fops);
 	if (IS_ERR(np)) {
 		rc = PTR_ERR(np);
diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
index e789f1db6f66..3d672dd57b32 100644
--- a/security/ipe/ipe.c
+++ b/security/ipe/ipe.c
@@ -7,6 +7,7 @@
 #include "hooks.h"
 #include "eval.h"
 
+extern const char *const ipe_boot_policy;
 bool ipe_enabled;
 
 static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
@@ -60,9 +61,20 @@ static struct security_hook_list ipe_hooks[] __ro_after_init = {
  */
 static int __init ipe_init(void)
 {
+	struct ipe_policy *p = NULL;
+
 	security_add_hooks(ipe_hooks, ARRAY_SIZE(ipe_hooks), "ipe");
 	ipe_enabled = true;
 
+	if (ipe_boot_policy) {
+		p = ipe_new_policy(ipe_boot_policy, strlen(ipe_boot_policy),
+				   NULL, 0);
+		if (IS_ERR(p))
+			return PTR_ERR(p);
+
+		rcu_assign_pointer(ipe_active_policy, p);
+	}
+
 	return 0;
 }
 
-- 
2.25.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

