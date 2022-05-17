Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB200C43217
	for <dm-devel@archiver.kernel.org>; Tue, 17 May 2022 23:35:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-M-uYo7z9Ny-6RCxym1UGsw-1; Tue, 17 May 2022 19:35:11 -0400
X-MC-Unique: M-uYo7z9Ny-6RCxym1UGsw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E08DA80B71A;
	Tue, 17 May 2022 23:35:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE04BC15D7D;
	Tue, 17 May 2022 23:35:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B5EB219259D2;
	Tue, 17 May 2022 23:35:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 889AF1949759
 for <dm-devel@listman.corp.redhat.com>; Tue, 17 May 2022 23:35:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 714B1492CA3; Tue, 17 May 2022 23:35:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6CD25492CA2
 for <dm-devel@redhat.com>; Tue, 17 May 2022 23:35:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5202485A5A8
 for <dm-devel@redhat.com>; Tue, 17 May 2022 23:35:06 +0000 (UTC)
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com
 [209.85.210.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-6kbPezGfO_2vCZWhNdMPJA-1; Tue, 17 May 2022 19:35:04 -0400
X-MC-Unique: 6kbPezGfO_2vCZWhNdMPJA-1
Received: by mail-pf1-f179.google.com with SMTP id y199so508789pfb.9
 for <dm-devel@redhat.com>; Tue, 17 May 2022 16:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=GNlOjZL47Vz4isvM0//7r28xwox/zDps46iBoN3MInI=;
 b=qwUIEYPkuZV6B4Tyx3bs48xutK9e9JLpTewfIAzuAigAoOwBtEdB8rspdaCiTj3Zk+
 ZGzWSi/ZXNYSd6g5ivX77b5jDD1FD9AoEZY+qI/AoSUfKOBl0H7d/l7pOxmxZFCRSRh1
 M5UmQgKWqy8h59TReCtxc3lnsUD04DVBUnQDPc0hd2r/cvWFyiWqhrsykRH0rlpcVHX/
 iHcsfztnwCHG5MMuCoDGt8PMGWYBd4NapzkUkyEa3/xyWl9TdJ23ePz/lx4xvcylqi5Z
 uib4ktE9yR/CCKbRldN6WX6C3DIB6+T2q+yILLxS9xYtUBKObhMUmv4h2RPnMRCcNend
 lUeQ==
X-Gm-Message-State: AOAM532dIzz96mnrl+eWsODdTjOmeaXH4UhH4KPDfsg2Y2GarjHn2DBQ
 Rkst7uD6DQpu8o7Ers1hnNFwLw==
X-Google-Smtp-Source: ABdhPJwCoEpgwLkG3PBp3ELF3xXrzA2gpr5Pp6MElD+Fuxs/NTLQ5TDQ+eoDtGIE1K8WrB1xjIf98A==
X-Received: by 2002:a65:6c12:0:b0:3db:8148:308b with SMTP id
 y18-20020a656c12000000b003db8148308bmr21771531pgu.103.1652830503409; 
 Tue, 17 May 2022 16:35:03 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:a14:3166:4b67:b688])
 by smtp.gmail.com with UTF8SMTPSA id
 a4-20020aa794a4000000b0050dc76281a7sm281255pfl.129.2022.05.17.16.35.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 17 May 2022 16:35:03 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Tue, 17 May 2022 16:34:56 -0700
Message-Id: <20220517163437.v4.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
In-Reply-To: <20220517233457.1123309-1-mka@chromium.org>
References: <20220517233457.1123309-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Subject: [dm-devel] [PATCH v4 2/3] LoadPin: Enable loading from trusted
 dm-verity devices
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
Cc: dm-devel@redhat.com, Douglas Anderson <dianders@chromium.org>,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Matthias Kaehlcke <mka@chromium.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Extend LoadPin to allow loading of kernel files from trusted dm-verity [1]
devices.

This change adds the concept of trusted verity devices to LoadPin. LoadPin
maintains a list of root digests of verity devices it considers trusted.
Userspace can populate this list through an ioctl on the new LoadPin
securityfs entry 'dm-verity'. The ioctl receives a file descriptor of
a file with verity digests as parameter. Verity reads the digests from
this file after confirming that the file is located on the pinned root.
The digest file must contain one digest per line. The list of trusted
digests can only be set up once, which is typically done at boot time.

When a kernel file is read LoadPin first checks (as usual) whether the file
is located on the pinned root, if so the file can be loaded. Otherwise, if
the verity extension is enabled, LoadPin determines whether the file is
located on a verity backed device and whether the root digest of that
device is in the list of trusted digests. The file can be loaded if the
verity device has a trusted root digest.

Background:

As of now LoadPin restricts loading of kernel files to a single pinned
filesystem, typically the rootfs. This works for many systems, however it
can result in a bloated rootfs (and OTA updates) on platforms where
multiple boards with different hardware configurations use the same rootfs
image. Especially when 'optional' files are large it may be preferable to
download/install them only when they are actually needed by a given board.
Chrome OS uses Downloadable Content (DLC) [2] to deploy certain 'packages'
at runtime. As an example a DLC package could contain firmware for a
peripheral that is not present on all boards. DLCs use dm-verity to verify
the integrity of the DLC content.

[1] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html
[2] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---

Changes in v4:
- use newline as separator in digest file instead of comma
- after reading an invalid/corrupt digest file deny further attempts
  of setting up the list of digests
- added comment to read_trusted_verity_root_digests() explaining that
  an invalid digests entry invalidates the entire list of digests
- refactored read_trusted_verity_root_digests() to avoid cast of 'data' at
  assignment
- add the format of the digest file and the path of the securityfs
  attribute to the ioctl comment.
- adapted to struct trusted_root_digest with unsized array 'data'
- call dm_verity_loadpin_is_sb_trusted() instead of
  loadpin_is_fs_trusted()
- deleted loadpin_is_fs_trusted()
- use '%ld' in format string for PTR_ERR()
- added note about digest file format to the commit message

Changes in v3:
- added securityfs for LoadPin (currently only populated when
  CONFIG_SECURITY_LOADPIN_VERITY=y)
- added uapi include for LoadPin
- changed the interface for setting up the list of trusted
  digests from sysctl to ioctl on securityfs entry
- added stub for loadpin_is_fs_trusted() to be used
  CONFIG_SECURITY_LOADPIN_VERITY is not select
- depend on CONFIG_SECURITYFS instead of CONFIG_SYSTCL
- updated Kconfig help
- minor changes in read_trusted_verity_root_digests()
- updated commit message

Changes in v2:
- userspace now passes the path of the file with the verity digests
  via systcl, instead of the digests themselves
- renamed sysctl file to 'trusted_verity_root_digests_path'
- have CONFIG_SECURITY_LOADPIN_VERITY depend on CONFIG_SYSCTL
- updated Kconfig doc
- updated commit message

 include/uapi/linux/loadpin.h |  22 +++++
 security/loadpin/Kconfig     |  16 ++++
 security/loadpin/loadpin.c   | 167 ++++++++++++++++++++++++++++++++++-
 3 files changed, 204 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/loadpin.h

diff --git a/include/uapi/linux/loadpin.h b/include/uapi/linux/loadpin.h
new file mode 100644
index 000000000000..daa6dbb8bb02
--- /dev/null
+++ b/include/uapi/linux/loadpin.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (c) 2022, Google LLC
+ */
+
+#ifndef _UAPI_LINUX_LOOP_LOADPIN_H
+#define _UAPI_LINUX_LOOP_LOADPIN_H
+
+#define LOADPIN_IOC_MAGIC	'L'
+
+/**
+ * LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS - Set up the root digests of verity devices
+ *                                          that loadpin should trust.
+ *
+ * Takes a file descriptor from which to read the root digests of trusted verity devices. The file
+ * is expected to contain a list of digests in ASCII format, with one line per digest. The ioctl
+ * must be issued on the securityfs attribute 'loadpin/dm-verity' (which can be typically found
+ * under /sys/kernel/security/loadpin/dm-verity).
+ */
+#define LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS _IOW(LOADPIN_IOC_MAGIC, 0x00, unsigned int)
+
+#endif /* _UAPI_LINUX_LOOP_LOADPIN_H */
diff --git a/security/loadpin/Kconfig b/security/loadpin/Kconfig
index 91be65dec2ab..e319ca8e3f3d 100644
--- a/security/loadpin/Kconfig
+++ b/security/loadpin/Kconfig
@@ -18,3 +18,19 @@ config SECURITY_LOADPIN_ENFORCE
 	  If selected, LoadPin will enforce pinning at boot. If not
 	  selected, it can be enabled at boot with the kernel parameter
 	  "loadpin.enforce=1".
+
+config SECURITY_LOADPIN_VERITY
+	bool "Allow reading files from certain other filesystems that use dm-verity"
+	depends on DM_VERITY=y && SECURITYFS
+	help
+	  If selected LoadPin can allow reading files from filesystems
+	  that use dm-verity. LoadPin maintains a list of verity root
+	  digests it considers trusted. A verity backed filesystem is
+	  considered trusted if its root digest is found in the list
+	  of trusted digests.
+
+	  The list of trusted verity can be populated through an ioctl
+	  on the LoadPin securityfs entry 'dm-verity'. The ioctl
+	  expects a file descriptor of a file with verity digests as
+	  parameter. The file must be located on the pinned root and
+	  contain a comma separated list of digests.
diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
index b12f7d986b1e..67be496befaa 100644
--- a/security/loadpin/loadpin.c
+++ b/security/loadpin/loadpin.c
@@ -18,6 +18,8 @@
 #include <linux/path.h>
 #include <linux/sched.h>	/* current */
 #include <linux/string_helpers.h>
+#include <linux/dm-verity-loadpin.h>
+#include <uapi/linux/loadpin.h>
 
 static void report_load(const char *origin, struct file *file, char *operation)
 {
@@ -43,6 +45,9 @@ static char *exclude_read_files[READING_MAX_ID];
 static int ignore_read_file_id[READING_MAX_ID] __ro_after_init;
 static struct super_block *pinned_root;
 static DEFINE_SPINLOCK(pinned_root_spinlock);
+#ifdef CONFIG_SECURITY_LOADPIN_VERITY
+static bool deny_reading_verity_digests;
+#endif
 
 #ifdef CONFIG_SYSCTL
 
@@ -174,7 +179,8 @@ static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
 		spin_unlock(&pinned_root_spinlock);
 	}
 
-	if (IS_ERR_OR_NULL(pinned_root) || load_root != pinned_root) {
+	if (IS_ERR_OR_NULL(pinned_root) ||
+	    ((load_root != pinned_root) && !dm_verity_loadpin_is_sb_trusted(load_root))) {
 		if (unlikely(!enforce)) {
 			report_load(origin, file, "pinning-ignored");
 			return 0;
@@ -240,6 +246,7 @@ static int __init loadpin_init(void)
 		enforce ? "" : "not ");
 	parse_exclude();
 	security_add_hooks(loadpin_hooks, ARRAY_SIZE(loadpin_hooks), "loadpin");
+
 	return 0;
 }
 
@@ -248,6 +255,164 @@ DEFINE_LSM(loadpin) = {
 	.init = loadpin_init,
 };
 
+#ifdef CONFIG_SECURITY_LOADPIN_VERITY
+
+enum loadpin_securityfs_interface_index {
+	LOADPIN_DM_VERITY,
+};
+
+static int read_trusted_verity_root_digests(unsigned int fd)
+{
+	struct fd f;
+	void *data;
+	int rc;
+	char *p, *d;
+
+	if (deny_reading_verity_digests)
+		return -EPERM;
+
+	/* The list of trusted root digests can only be set up once */
+	if (!list_empty(&loadpin_trusted_verity_root_digests))
+		return -EPERM;
+
+	f = fdget(fd);
+	if (!f.file)
+		return -EINVAL;
+
+	data = kzalloc(SZ_4K, GFP_KERNEL);
+	if (!data) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	rc = kernel_read_file(f.file, 0, (void **)&data, SZ_4K - 1, NULL, READING_POLICY);
+	if (rc < 0)
+		goto err;
+
+	p = data;
+	p[rc] = '\0';
+	p = strim(p);
+
+	p = strim(data);
+	while ((d = strsep(&p, "\n")) != NULL) {
+		int len = strlen(d);
+		struct trusted_root_digest *trd;
+
+		if (len % 2) {
+			rc = -EPROTO;
+			goto err;
+		}
+
+		len /= 2;
+
+		trd = kzalloc(struct_size(trd, data, len), GFP_KERNEL);
+		if (!trd) {
+			rc = -ENOMEM;
+			goto err;
+		}
+
+		if (hex2bin(trd->data, d, len)) {
+			kfree(trd);
+			rc = -EPROTO;
+			goto err;
+		}
+
+		trd->len = len;
+
+		list_add_tail(&trd->node, &loadpin_trusted_verity_root_digests);
+	}
+
+	if (list_empty(&loadpin_trusted_verity_root_digests)) {
+		rc = -EPROTO;
+		goto err;
+	}
+
+	kfree(data);
+	fdput(f);
+
+	return 0;
+
+err:
+	kfree(data);
+
+	/* any failure in loading/parsing invalidates the entire list */
+	{
+		struct trusted_root_digest *trd, *tmp;
+
+		list_for_each_entry_safe(trd, tmp, &loadpin_trusted_verity_root_digests, node) {
+			list_del(&trd->node);
+			kfree(trd);
+		}
+	}
+
+	/* disallow further attempts after reading a corrupt/invalid file */
+	deny_reading_verity_digests = true;
+
+	fdput(f);
+
+	return rc;
+}
+
+/******************************** securityfs ********************************/
+
+static long dm_verity_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	void __user *uarg = (void __user *)arg;
+	unsigned int fd;
+	int rc;
+
+	switch (cmd) {
+	case LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS:
+		rc = copy_from_user(&fd, uarg, sizeof(fd));
+		if (rc)
+			return rc;
+
+		return read_trusted_verity_root_digests(fd);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static const struct file_operations loadpin_dm_verity_ops = {
+	.unlocked_ioctl = dm_verity_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
+};
+
+/**
+ * init_loadpin_securityfs - create the securityfs directory for LoadPin
+ *
+ * We can not put this method normally under the loadpin_init() code path since
+ * the security subsystem gets initialized before the vfs caches.
+ *
+ * Returns 0 if the securityfs directory creation was successful.
+ */
+static int __init init_loadpin_securityfs(void)
+{
+	struct dentry *loadpin_dir, *dentry;
+
+	loadpin_dir = securityfs_create_dir("loadpin", NULL);
+	if (IS_ERR(loadpin_dir)) {
+		pr_err("LoadPin: could not create securityfs dir: %ld\n",
+		       PTR_ERR(loadpin_dir));
+		return PTR_ERR(loadpin_dir);
+	}
+
+	dentry = securityfs_create_file("dm-verity", 0600, loadpin_dir,
+					(void *)LOADPIN_DM_VERITY, &loadpin_dm_verity_ops);
+	if (IS_ERR(dentry)) {
+		pr_err("LoadPin: could not create securityfs entry 'dm-verity': %ld\n",
+		       PTR_ERR(dentry));
+		return PTR_ERR(dentry);
+	}
+
+	return 0;
+}
+
+fs_initcall(init_loadpin_securityfs);
+
+#endif /* CONFIG_SECURITY_LOADPIN_VERITY */
+
 /* Should not be mutable after boot, so not listed in sysfs (perm == 0). */
 module_param(enforce, int, 0);
 MODULE_PARM_DESC(enforce, "Enforce module/firmware pinning");
-- 
2.36.0.550.gb090851708-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

