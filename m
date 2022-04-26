Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF45C433FE
	for <dm-devel@archiver.kernel.org>; Wed, 27 Apr 2022 12:15:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-ctA84d_DOoqTpFpdfuuZGA-1; Wed, 27 Apr 2022 08:15:19 -0400
X-MC-Unique: ctA84d_DOoqTpFpdfuuZGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54525833970;
	Wed, 27 Apr 2022 12:15:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3E109111D7BE;
	Wed, 27 Apr 2022 12:15:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EEFBC194704E;
	Wed, 27 Apr 2022 12:15:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9896C19451F0
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Apr 2022 21:31:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6AB5E40D0161; Tue, 26 Apr 2022 21:31:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 65BD040D0160
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 21:31:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DFF33280859E
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 21:31:22 +0000 (UTC)
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com
 [209.85.210.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-264-KVJMPCFkNui3NVI1atd2yA-1; Tue, 26 Apr 2022 17:31:20 -0400
X-MC-Unique: KVJMPCFkNui3NVI1atd2yA-1
Received: by mail-pf1-f176.google.com with SMTP id j17so19115447pfi.9
 for <dm-devel@redhat.com>; Tue, 26 Apr 2022 14:31:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=yNE83scqZXxcJEDYMgDTyuvR1Ggrx94+lQMxMZ/IowU=;
 b=IHFU5NGpfe8oPtHnriNkDbBZYu4F6IMpgqENG4VzAGoNiY6K8lgio58MDeMQ9uK3D0
 jyKmbL+IDl1prGMWAyM5a9VfqQD+H7s46iAsThmdMZfFd75OcfMY7OWk+Cnw4vHgsS/T
 4uGD/ArgLpHuBwBL6wzOfJ3DN7t4+H/luPCiSJX7RSfGhFEDopD6LA3dFxpblDsY93w/
 7D+GbTOu/cFjuMoJyqVkaEzT+zVMBMhbc+Of31JBIe+DAnQozKj2lK/TRMXxNlWTQtr9
 zE1gOE/Vbab1LOMZsH1HD8yYs563qNT0RDheoogHHkebarY1vYI25JTyX1MCzr9BwJ+n
 JExQ==
X-Gm-Message-State: AOAM530iXftO8zU8++Jipv/y+6bvNVc+4RjaOq/AFXo7u0DECe7eBkw3
 uptbFwNpS8EzfG66e0eaE9xaAA==
X-Google-Smtp-Source: ABdhPJyMQWm4GBBd8xOq6MlO1DMwKqAq9qQ61DtlsZ0/uc1Wn8+/SKp/8D2U8jV/KOG4uEk/ZjmK/w==
X-Received: by 2002:a05:6a00:174a:b0:50d:44ca:4b with SMTP id
 j10-20020a056a00174a00b0050d44ca004bmr10662538pfc.0.1651008679684; 
 Tue, 26 Apr 2022 14:31:19 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:eb63:4211:eb5d:f6b])
 by smtp.gmail.com with UTF8SMTPSA id
 pb15-20020a17090b3c0f00b001cd4989ff4esm3587166pjb.21.2022.04.26.14.31.18
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 26 Apr 2022 14:31:19 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Tue, 26 Apr 2022 14:31:09 -0700
Message-Id: <20220426143059.v2.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
In-Reply-To: <20220426213110.3572568-1-mka@chromium.org>
References: <20220426213110.3572568-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Wed, 27 Apr 2022 12:14:17 +0000
Subject: [dm-devel] [PATCH v2 2/3] LoadPin: Enable loading from trusted
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
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>, linux-security-module@vger.kernel.org,
 Matthias Kaehlcke <mka@chromium.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Extend LoadPin to allow loading of kernel files from trusted
dm-verity [1] devices.

This change adds the concept of trusted verity devices to
LoadPin. Userspace can use the new systl file
'loadpin/trusted_verity_root_digests_path' to provide
LoadPin with the path of a file with a list of root digests
from dm-verity devices that LoadPin should consider as
trusted. This file must be located on the pinned root.

When a kernel file is read LoadPin first checks
(as usual) whether the file is located on the pinned root,
if so the file can be loaded. Otherwise, if the verity
extension is enabled, LoadPin determines whether the
file is located on a verity backed device and whether
the root digest of that device is in the list of trusted
digests. The file can be loaded if the verity device has
a trusted root digest.

The path of the file with the trusted root digests can
only be written once, which is typically done at boot time.

Background:

As of now LoadPin restricts loading of kernel files to a single
pinned filesystem, typically the rootfs. This works for many
systems, however it can result in a bloated rootfs (and OTA
updates) on platforms where multiple boards with different
hardware configurations use the same rootfs image. Especially
when 'optional' files are large it may be preferable to
download/install them only when they are actually needed by a
given board. Chrome OS uses Downloadable Content (DLC) [2] to
deploy certain 'packages' at runtime. As an example a DLC
package could contain firmware for a peripheral that is not
present on all boards. DLCs use dm-verity to verify the
integrity of the DLC content.

[1] https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/verity.html
[2] https://chromium.googlesource.com/chromiumos/platform2/+/HEAD/dlcservice/docs/developer.md

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---
I'm still doubting what would be the best way to configure
the list of trusted digests. The approach in v2 of writing
a path through sysctl is flexible, but it also feels a bit
odd. I did some experiments with passing a file descriptor
through sysctl, but it's also odd and has its own issues.
Passing the list through a kernel parameter seems hacky.
A Kconfig string would work, but can be have issues when
the same config is used for different platforms, where
some may have trusted digests and others not.

Changes in v2:
- userspace now passes the path of the file with the verity digests
  via systcl, instead of the digests themselves
- renamed sysctl file to 'trusted_verity_root_digests_path'
- have CONFIG_SECURITY_LOADPIN_VERITY depend on CONFIG_SYSCTL
- updated Kconfig doc
- updated commit message

 security/loadpin/Kconfig   |  16 +++
 security/loadpin/loadpin.c | 200 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 215 insertions(+), 1 deletion(-)

diff --git a/security/loadpin/Kconfig b/security/loadpin/Kconfig
index 91be65dec2ab..20681dc4b8a5 100644
--- a/security/loadpin/Kconfig
+++ b/security/loadpin/Kconfig
@@ -18,3 +18,19 @@ config SECURITY_LOADPIN_ENFORCE
 	  If selected, LoadPin will enforce pinning at boot. If not
 	  selected, it can be enabled at boot with the kernel parameter
 	  "loadpin.enforce=1".
+
+config SECURITY_LOADPIN_VERITY
+	bool "Allow reading files from certain other filesystems that use dm-verity"
+	depends on DM_VERITY=y && SYSCTL
+	help
+	  If selected LoadPin can allow reading files from filesystems
+	  that use dm-verity. LoadPin maintains a list of verity root
+	  digests it considers trusted. A verity backed filesystem is
+	  considered trusted if its root digest is found in the list
+	  of trusted digests.
+
+	  Userspace can populate the list of trusted digests by writing
+	  the path of a file with the digests to the syctl file
+	  'trusted_verity_root_digests_path'. The file must be located
+	  on the pinned root and contain a comma separated list of
+	  digests.
diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
index b12f7d986b1e..db10b7ff6efd 100644
--- a/security/loadpin/loadpin.c
+++ b/security/loadpin/loadpin.c
@@ -18,6 +18,8 @@
 #include <linux/path.h>
 #include <linux/sched.h>	/* current */
 #include <linux/string_helpers.h>
+#include <linux/device-mapper.h>
+#include <linux/dm-verity-loadpin.h>
 
 static void report_load(const char *origin, struct file *file, char *operation)
 {
@@ -43,6 +45,10 @@ static char *exclude_read_files[READING_MAX_ID];
 static int ignore_read_file_id[READING_MAX_ID] __ro_after_init;
 static struct super_block *pinned_root;
 static DEFINE_SPINLOCK(pinned_root_spinlock);
+#ifdef CONFIG_SECURITY_LOADPIN_VERITY
+static LIST_HEAD(trusted_verity_root_digests);
+static const char *verity_digests_path;
+#endif
 
 #ifdef CONFIG_SYSCTL
 
@@ -65,6 +71,176 @@ static struct ctl_table loadpin_sysctl_table[] = {
 	{ }
 };
 
+#ifdef CONFIG_SECURITY_LOADPIN_VERITY
+
+static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
+			     bool contents);
+
+static int read_trusted_verity_root_digests(struct file *file)
+{
+	void *data;
+	char *p, *d;
+	int err, rc;
+
+	data = kzalloc(SZ_4K, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	rc = kernel_read_file(file, 0, &data, SZ_4K - 1, NULL, READING_POLICY);
+	if (rc < 0)
+		return rc;
+
+	((char *)data)[rc] = '\0';
+
+	p = strim(data);
+	while ((d = strsep(&p, ",")) != NULL) {
+		int len = strlen(d);
+		struct trusted_root_digest *trd;
+
+		if (len % 2) {
+			err = -EPROTO;
+			goto free_mem;
+		}
+
+		len /= 2;
+
+		trd = kzalloc(sizeof(*trd), GFP_KERNEL);
+		if (!trd) {
+			err = -ENOMEM;
+			goto free_mem;
+		}
+
+		trd->data = kzalloc(len, GFP_KERNEL);
+		if (!trd->data) {
+			kfree(trd);
+			err = -ENOMEM;
+			goto free_mem;
+		}
+
+		if (hex2bin(trd->data, d, len)) {
+			kfree(trd);
+			err = -EPROTO;
+			goto free_mem;
+		}
+
+		list_add_tail(&trd->node, &trusted_verity_root_digests);
+
+		trd->len = len;
+	}
+
+	kfree(data);
+
+	return 0;
+
+free_mem:
+	kfree(data);
+
+	{
+		struct trusted_root_digest *trd, *tmp;
+
+		list_for_each_entry_safe(trd, tmp, &trusted_verity_root_digests, node) {
+			kfree(trd->data);
+			list_del(&trd->node);
+			kfree(trd);
+		}
+	}
+
+	return err;
+}
+
+static int proc_verity_digests(struct ctl_table *table, int write,
+			       void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tbl = *table;
+
+	if (write) {
+		int rc;
+		char *digests_path;
+		struct file *file;
+
+		if (*ppos)
+			return -EINVAL;
+
+		if (verity_digests_path != NULL)
+			return -EPERM;
+
+		digests_path = kzalloc(tbl.maxlen, GFP_KERNEL);
+		if (!digests_path)
+			return -ENOMEM;
+
+		tbl.data = digests_path;
+
+		rc = proc_dostring(&tbl, write, buffer, lenp, ppos);
+		if (rc) {
+			kfree(digests_path);
+			return rc;
+		}
+
+		/* only absolute paths are allowed */
+		if (digests_path[0] != '/') {
+			kfree(digests_path);
+			return -EINVAL;
+		}
+
+		file = filp_open(digests_path, O_RDONLY, 0);
+		if (IS_ERR(file)) {
+			int err = PTR_ERR(file);
+
+			if (err == -ENOENT) {
+				kfree(digests_path);
+				return -EINVAL;
+			}
+
+			return err;
+		}
+
+		/* verify the root digests stem from a trusted file system */
+		if (loadpin_read_file(file, READING_POLICY, true)) {
+			fput(file);
+			kfree(digests_path);
+			return -EPERM;
+		}
+
+		rc = read_trusted_verity_root_digests(file);
+		fput(file);
+		if (rc) {
+			kfree(digests_path);
+			return rc;
+		}
+
+		verity_digests_path = digests_path;
+	} else {
+		if (verity_digests_path) {
+			tbl.data = kzalloc(strlen(verity_digests_path) + 1, GFP_KERNEL);
+			strcpy(tbl.data, verity_digests_path);
+		} else {
+			tbl.data = kzalloc(1, GFP_KERNEL);
+		}
+
+		proc_dostring(&tbl, write, buffer, lenp, ppos);
+		kfree(tbl.data);
+	}
+
+	return 0;
+}
+
+static struct ctl_table loadpin_sysctl_table_verity_digests[] = {
+	{
+		.procname       = "trusted_verity_root_digests_path",
+		.maxlen         = SZ_256,
+		.mode           = 0644,
+		.proc_handler   = proc_verity_digests,
+	},
+
+	{ }
+};
+
+#else
+
+static struct ctl_table loadpin_sysctl_table_verity_digests[] = {};
+
+#endif /* CONFIG_SECURITY_LOADPIN_VERITY */
+
 /*
  * This must be called after early kernel init, since then the rootdev
  * is available.
@@ -118,6 +294,20 @@ static void loadpin_sb_free_security(struct super_block *mnt_sb)
 	}
 }
 
+static bool loadpin_is_fs_trusted(struct super_block *sb)
+{
+	struct mapped_device *md = dm_get_md(sb->s_bdev->bd_dev);
+	bool trusted;
+
+	if (!md)
+		return false;
+
+	trusted = dm_verity_loadpin_is_md_trusted(md);
+	dm_put(md);
+
+	return trusted;
+}
+
 static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
 			     bool contents)
 {
@@ -174,7 +364,8 @@ static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
 		spin_unlock(&pinned_root_spinlock);
 	}
 
-	if (IS_ERR_OR_NULL(pinned_root) || load_root != pinned_root) {
+	if (IS_ERR_OR_NULL(pinned_root) ||
+	    ((load_root != pinned_root) && !loadpin_is_fs_trusted(load_root))) {
 		if (unlikely(!enforce)) {
 			report_load(origin, file, "pinning-ignored");
 			return 0;
@@ -240,6 +431,13 @@ static int __init loadpin_init(void)
 		enforce ? "" : "not ");
 	parse_exclude();
 	security_add_hooks(loadpin_hooks, ARRAY_SIZE(loadpin_hooks), "loadpin");
+
+	if (IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)) {
+		if (!register_sysctl_paths(loadpin_sysctl_path,
+					   loadpin_sysctl_table_verity_digests))
+			pr_notice("sysctl registration failed!\n");
+	}
+
 	return 0;
 }
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

