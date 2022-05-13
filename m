Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F596C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 13 May 2022 22:36:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-oQ6zAsrvODSNghhLPyuOvQ-1; Fri, 13 May 2022 18:36:48 -0400
X-MC-Unique: oQ6zAsrvODSNghhLPyuOvQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 51EA5805B25;
	Fri, 13 May 2022 22:36:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B417B40D2820;
	Fri, 13 May 2022 22:36:45 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6CBEA1932238;
	Fri, 13 May 2022 22:36:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DE67C194975B
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 May 2022 22:36:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 88B0F7C55; Fri, 13 May 2022 22:36:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 83D6E7C52
 for <dm-devel@redhat.com>; Fri, 13 May 2022 22:36:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F3A511C05129
 for <dm-devel@redhat.com>; Fri, 13 May 2022 22:36:31 +0000 (UTC)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-anKIbFMcNlyetn3mrdJl6g-1; Fri, 13 May 2022 18:36:30 -0400
X-MC-Unique: anKIbFMcNlyetn3mrdJl6g-1
Received: by mail-pg1-f178.google.com with SMTP id r71so8398761pgr.0
 for <dm-devel@redhat.com>; Fri, 13 May 2022 15:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
 :references:message-id:mime-version:content-transfer-encoding;
 bh=5gA/z5w3iSZBhMGL4NGMxYvM+06CCYMA733n8qghoV8=;
 b=Mg2a2lYLAoCWIk/ZXE9T4FRCEDcBr8swnpmBw6VgZMwGEf+QpPs3gct4Xfnz5gfTWp
 9mXOEcrCNFeV0o3rR+CczKY6Ba8M7nkN9gVvkYSpXnNyuVKOz0ogFvMQc1ukUPu1k73B
 JIFfkTmaGqnYxVlTfBE2Tyy7WKCI1uPkFhuE17hvZBJSNFzDps0/hVUt77j49T2PDG2T
 xnK2YXXM28qhObvp1/lvDu0jtq+MyqChY9rfaKcidkHlTEzHXuQ0XKS5vm7ZznY+uPJG
 LTaRYppMSccRrXTexu0WzKcdGYxhqID9k5h3JZja+R+kT2BwazFPWNbIKanBzH8QNFB+
 WulA==
X-Gm-Message-State: AOAM5336VVtOyNz4osBSol2NoRCW9pqG92r1J5UmcvkMkYh++nh1cUT8
 04WRRwt1vUznXPmn+PopZVB0iQ==
X-Google-Smtp-Source: ABdhPJxBG6e3E9oNiJFfeBHLppZK7vFJX4UY0lZeJxSrEESj5nfl/PMVKHRcA3ds9aAvC7+znYeatA==
X-Received: by 2002:a05:6a00:10cc:b0:4fe:3f1c:2d1 with SMTP id
 d12-20020a056a0010cc00b004fe3f1c02d1mr6472165pfu.0.1652481388955; 
 Fri, 13 May 2022 15:36:28 -0700 (PDT)
Received: from ?IPv6:::1? ([2607:fb90:3322:7d68:6474:9b3c:2c42:56f1])
 by smtp.gmail.com with ESMTPSA id
 r15-20020a17090a940f00b001cd8e9ea22asm4025665pjo.52.2022.05.13.15.36.28
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 13 May 2022 15:36:28 -0700 (PDT)
Date: Fri, 13 May 2022 15:36:26 -0700
From: Kees Cook <keescook@chromium.org>
To: Matthias Kaehlcke <mka@chromium.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20220504125404.v3.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
Message-ID: <B7FB2BE6-DF1C-414A-B4C2-0C15FD1CBF75@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH v3 2/3] LoadPin: Enable loading from trusted
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
Cc: Douglas Anderson <dianders@chromium.org>,
 linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit



On May 4, 2022 12:54:18 PM PDT, Matthias Kaehlcke <mka@chromium.org> wrote:
>Extend LoadPin to allow loading of kernel files from trusted dm-verity [1]
>devices.
>
>This change adds the concept of trusted verity devices to LoadPin. LoadPin
>maintains a list of root digests of verity devices it considers trusted.
>Userspace can populate this list through an ioctl on the new LoadPin
>securityfs entry 'dm-verity'. The ioctl receives a file descriptor of
>a file with verity digests as parameter. Verity reads the digests from
>this file after confirming that the file is located on the pinned root.
>The list of trusted digests can only be set up once, which is typically
>done at boot time.
>
>When a kernel file is read LoadPin first checks (as usual) whether the file
>is located on the pinned root, if so the file can be loaded. Otherwise, if
>the verity extension is enabled, LoadPin determines whether the file is
>located on a verity backed device and whether the root digest of that

I think this should be "... on an already trusted device ..."

>device is in the list of trusted digests. The file can be loaded if the
>verity device has a trusted root digest.
>
>Background:
>
>As of now LoadPin restricts loading of kernel files to a single pinned
>filesystem, typically the rootfs. This works for many systems, however it
>can result in a bloated rootfs (and OTA updates) on platforms where
>multiple boards with different hardware configurations use the same rootfs
>image. Especially when 'optional' files are large it may be preferable to
>download/install them only when they are actually needed by a given board.
>Chrome OS uses Downloadable Content (DLC) [2] to deploy certain 'packages'
>at runtime. As an example a DLC package could contain firmware for a
>peripheral that is not present on all boards. DLCs use dm-verity to verify
>the integrity of the DLC content.
>
>[1] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html
>[2] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md
>
>Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
>---
>
>Changes in v3:
>- added securityfs for LoadPin (currently only populated when
>  CONFIG_SECURITY_LOADPIN_VERITY=y)
>- added uapi include for LoadPin
>- changed the interface for setting up the list of trusted
>  digests from sysctl to ioctl on securityfs entry
>- added stub for loadpin_is_fs_trusted() to be used
>  CONFIG_SECURITY_LOADPIN_VERITY is not select
>- depend on CONFIG_SECURITYFS instead of CONFIG_SYSTCL
>- updated Kconfig help
>- minor changes in read_trusted_verity_root_digests()
>- updated commit message
>
>Changes in v2:
>- userspace now passes the path of the file with the verity digests
>  via systcl, instead of the digests themselves
>- renamed sysctl file to 'trusted_verity_root_digests_path'
>- have CONFIG_SECURITY_LOADPIN_VERITY depend on CONFIG_SYSCTL
>- updated Kconfig doc
>- updated commit message
>
> include/uapi/linux/loadpin.h |  19 ++++
> security/loadpin/Kconfig     |  16 +++
> security/loadpin/loadpin.c   | 184 ++++++++++++++++++++++++++++++++++-
> 3 files changed, 218 insertions(+), 1 deletion(-)
> create mode 100644 include/uapi/linux/loadpin.h
>
>diff --git a/include/uapi/linux/loadpin.h b/include/uapi/linux/loadpin.h
>new file mode 100644
>index 000000000000..d303a582209b
>--- /dev/null
>+++ b/include/uapi/linux/loadpin.h
>@@ -0,0 +1,19 @@
>+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>+/*
>+ * Copyright (c) 2022, Google LLC
>+ */
>+
>+#ifndef _UAPI_LINUX_LOOP_LOADPIN_H
>+#define _UAPI_LINUX_LOOP_LOADPIN_H
>+
>+#define LOADPIN_IOC_MAGIC	'L'
>+
>+/**
>+ * LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS - Set up the root digests of verity devices
>+ *                                          that loadpin should trust.
>+ *
>+ * Takes a file descriptor from which to read the root digests of trusted verity devices.

Maybe add to the comment the securityfs node path here as a helpful hint to the reader, and mention the format (comma separated?)

>+ */
>+#define LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS _IOW(LOADPIN_IOC_MAGIC, 0x00, unsigned int)
>+
>+#endif /* _UAPI_LINUX_LOOP_LOADPIN_H */
>diff --git a/security/loadpin/Kconfig b/security/loadpin/Kconfig
>index 91be65dec2ab..e319ca8e3f3d 100644
>--- a/security/loadpin/Kconfig
>+++ b/security/loadpin/Kconfig
>@@ -18,3 +18,19 @@ config SECURITY_LOADPIN_ENFORCE
> 	  If selected, LoadPin will enforce pinning at boot. If not
> 	  selected, it can be enabled at boot with the kernel parameter
> 	  "loadpin.enforce=1".
>+
>+config SECURITY_LOADPIN_VERITY
>+	bool "Allow reading files from certain other filesystems that use dm-verity"
>+	depends on DM_VERITY=y && SECURITYFS
>+	help
>+	  If selected LoadPin can allow reading files from filesystems
>+	  that use dm-verity. LoadPin maintains a list of verity root
>+	  digests it considers trusted. A verity backed filesystem is
>+	  considered trusted if its root digest is found in the list
>+	  of trusted digests.
>+
>+	  The list of trusted verity can be populated through an ioctl
>+	  on the LoadPin securityfs entry 'dm-verity'. The ioctl
>+	  expects a file descriptor of a file with verity digests as
>+	  parameter. The file must be located on the pinned root and
>+	  contain a comma separated list of digests.
>diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
>index b12f7d986b1e..c29ce562a366 100644
>--- a/security/loadpin/loadpin.c
>+++ b/security/loadpin/loadpin.c
>@@ -18,6 +18,9 @@
> #include <linux/path.h>
> #include <linux/sched.h>	/* current */
> #include <linux/string_helpers.h>
>+#include <linux/device-mapper.h>
>+#include <linux/dm-verity-loadpin.h>
>+#include <uapi/linux/loadpin.h>
> 
> static void report_load(const char *origin, struct file *file, char *operation)
> {
>@@ -43,6 +46,9 @@ static char *exclude_read_files[READING_MAX_ID];
> static int ignore_read_file_id[READING_MAX_ID] __ro_after_init;
> static struct super_block *pinned_root;
> static DEFINE_SPINLOCK(pinned_root_spinlock);
>+#ifdef CONFIG_SECURITY_LOADPIN_VERITY
>+static LIST_HEAD(trusted_verity_root_digests);
>+#endif
> 
> #ifdef CONFIG_SYSCTL
> 
>@@ -118,6 +124,24 @@ static void loadpin_sb_free_security(struct super_block *mnt_sb)
> 	}
> }
> 
>+#ifdef CONFIG_SECURITY_LOADPIN_VERITY
>+static bool loadpin_is_fs_trusted(struct super_block *sb)
>+{
>+	struct mapped_device *md = dm_get_md(sb->s_bdev->bd_dev);
>+	bool trusted;
>+
>+	if (!md)
>+		return false;
>+
>+	trusted = dm_verity_loadpin_is_md_trusted(md);
>+	dm_put(md);
>+
>+	return trusted;
>+}
>+#else
>+static inline bool loadpin_is_fs_trusted(struct super_block *sb) { return false; };
>+#endif
>+
> static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
> 			     bool contents)
> {
>@@ -174,7 +198,8 @@ static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
> 		spin_unlock(&pinned_root_spinlock);
> 	}
> 
>-	if (IS_ERR_OR_NULL(pinned_root) || load_root != pinned_root) {
>+	if (IS_ERR_OR_NULL(pinned_root) ||
>+	    ((load_root != pinned_root) && !loadpin_is_fs_trusted(load_root))) {
> 		if (unlikely(!enforce)) {
> 			report_load(origin, file, "pinning-ignored");
> 			return 0;
>@@ -240,6 +265,7 @@ static int __init loadpin_init(void)
> 		enforce ? "" : "not ");
> 	parse_exclude();
> 	security_add_hooks(loadpin_hooks, ARRAY_SIZE(loadpin_hooks), "loadpin");
>+
> 	return 0;
> }
> 
>@@ -248,6 +274,162 @@ DEFINE_LSM(loadpin) = {
> 	.init = loadpin_init,
> };
> 
>+#ifdef CONFIG_SECURITY_LOADPIN_VERITY
>+
>+enum loadpin_securityfs_interface_index {
>+	LOADPIN_DM_VERITY,
>+};
>+
>+static int read_trusted_verity_root_digests(unsigned int fd)
>+{
>+	struct fd f;
>+	void *data;

Probably easier if this is u8 *?

>+	int rc;
>+	char *p, *d;
>+
>+	/* The list of trusted root digests can only be set up once */
>+	if (!list_empty(&trusted_verity_root_digests))
>+		return -EPERM;
>+
>+	f = fdget(fd);
>+	if (!f.file)
>+		return -EINVAL;
>+
>+	data = kzalloc(SZ_4K, GFP_KERNEL);
>+	if (!data) {
>+		rc = -ENOMEM;
>+		goto err;
>+	}
>+
>+	rc = kernel_read_file(f.file, 0, &data, SZ_4K - 1, NULL, READING_POLICY);
>+	if (rc < 0)
>+		goto err;
>+
>+	((char *)data)[rc] = '\0';
>+
>+	p = strim(data);
>+	while ((d = strsep(&p, ",")) != NULL) {

Maybe be flexible and add newline as a separator too?

>+		int len = strlen(d);
>+		struct trusted_root_digest *trd;
>+
>+		if (len % 2) {
>+			rc = -EPROTO;
>+			goto err;
>+		}
>+
>+		len /= 2;
>+
>+		trd = kzalloc(sizeof(*trd), GFP_KERNEL);

With the struct change, this could be:

kzalloc(struct_size(trd, data, len), ...)

>+		if (!trd) {
>+			rc = -ENOMEM;
>+			goto err;
>+		}
>+
>+		trd->data = kzalloc(len, GFP_KERNEL);
>+		if (!trd->data) {
>+			kfree(trd);
>+			rc = -ENOMEM;
>+			goto err;
>+		}
>+
>+		if (hex2bin(trd->data, d, len)) {
>+			kfree(trd);
>+			kfree(trd->data);
>+			rc = -EPROTO;
>+			goto err;
>+		}
>+
>+		trd->len = len;
>+
>+		list_add_tail(&trd->node, &trusted_verity_root_digests);
>+	}
>+
>+	kfree(data);
>+	fdput(f);
>+
>+	if (!list_empty(&trusted_verity_root_digests))
>+		dm_verity_loadpin_set_trusted_root_digests(&trusted_verity_root_digests);
>+
>+	return 0;
>+
>+err:
>+	kfree(data);
>+

Maybe add a comment that any load failure will invalidate the entire list?

>+	{
>+		struct trusted_root_digest *trd, *tmp;
>+
>+		list_for_each_entry_safe(trd, tmp, &trusted_verity_root_digests, node) {
>+			kfree(trd->data);
>+			list_del(&trd->node);
>+			kfree(trd);
>+		}
>+	}
>+
>+	fdput(f);
>+
>+	return rc;
>+}
>+
>+/******************************** securityfs ********************************/
>+
>+static long dm_verity_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>+{
>+	void __user *uarg = (void __user *)arg;
>+	unsigned int fd;
>+	int rc;
>+
>+	switch (cmd) {
>+	case LOADPIN_IOC_SET_TRUSTED_VERITY_DIGESTS:
>+		rc = copy_from_user(&fd, uarg, sizeof(fd));
>+		if (rc)
>+			return rc;
>+
>+		return read_trusted_verity_root_digests(fd);
>+
>+	default:
>+		return -EINVAL;
>+	}
>+}
>+
>+static const struct file_operations loadpin_dm_verity_ops = {
>+	.unlocked_ioctl = dm_verity_ioctl,
>+	.compat_ioctl = compat_ptr_ioctl,
>+};
>+
>+/**
>+ * init_loadpin_securityfs - create the securityfs directory for LoadPin
>+ *
>+ * We can not put this method normally under the loadpin_init() code path since
>+ * the security subsystem gets initialized before the vfs caches.
>+ *
>+ * Returns 0 if the securityfs directory creation was successful.
>+ */
>+static int __init init_loadpin_securityfs(void)
>+{
>+	struct dentry *loadpin_dir, *dentry;
>+
>+	loadpin_dir = securityfs_create_dir("loadpin", NULL);
>+	if (IS_ERR(loadpin_dir)) {
>+		pr_err("LoadPin: could not create securityfs dir: %d\n",
>+		       PTR_ERR(loadpin_dir));
>+		return PTR_ERR(loadpin_dir);
>+	}
>+
>+	dentry = securityfs_create_file("dm-verity", 0600, loadpin_dir,
>+					(void *)LOADPIN_DM_VERITY, &loadpin_dm_verity_ops);
>+	if (IS_ERR(dentry)) {
>+		pr_err("LoadPin: could not create securityfs entry 'dm-verity': %d\n",
>+		       PTR_ERR(dentry));
>+		return PTR_ERR(dentry);
>+	}
>+
>+	return 0;
>+}
>+
>+fs_initcall(init_loadpin_securityfs);
>+
>+#endif /* CONFIG_SECURITY_LOADPIN_VERITY */
>+
> /* Should not be mutable after boot, so not listed in sysfs (perm == 0). */
> module_param(enforce, int, 0);
> MODULE_PARM_DESC(enforce, "Enforce module/firmware pinning");

Otherwise looks good! The only other thing I can think of is pondering more about more carefully failing closed. E.g. instead of just throwing away all the other hashes on a file load failure, maybe lock out future attempts to set it too? I'm not sure this is actually useful, though. :P it shouldn't be possible to corrupt the file, etc. But in the universe where things like DirtyCOW happens, I've gotten even more paranoid. ;)

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

