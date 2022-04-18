Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5885C433F5
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:38 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-280-L4t7yW_TNJqyQp9yCHltLA-1; Tue, 19 Apr 2022 02:10:34 -0400
X-MC-Unique: L4t7yW_TNJqyQp9yCHltLA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EC90786B8AB;
	Tue, 19 Apr 2022 06:10:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D815FC52D95;
	Tue, 19 Apr 2022 06:10:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C8D8A1940371;
	Tue, 19 Apr 2022 06:10:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 082EA1947BBD
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 21:16:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D902C454D64; Mon, 18 Apr 2022 21:16:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D4AB5440ABF
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:16:12 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8BD2299E76E
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:16:12 +0000 (UTC)
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com
 [209.85.215.181]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-_dUK8ILmPJa0HaT1E-G8yw-1; Mon, 18 Apr 2022 17:16:10 -0400
X-MC-Unique: _dUK8ILmPJa0HaT1E-G8yw-1
Received: by mail-pg1-f181.google.com with SMTP id t13so21095310pgn.8
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 14:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=z7MNQdhfJevonqU1gbIMWRC7hAVlhGusKX2oocNDGwg=;
 b=lg0WLf32sT2QgqnCa6O1IqF0j/5KVBeghQ1zOi90u0rGsr79NwEqkK+Em2XhYkUcPD
 CVnjfYNWrzY91AQS5cfzT6cetBOWGnZtt7jdJqVX04NZ+5qmf0maqN4vxJI/a2mNWKKi
 kidqvNHjMWULQpUO4sdcfH8oeR/h6GMp3Z3tJeOgV8IINvVJdAqYnqUS0iPVlhwpZF94
 cH4nkFbdLw3WvOWuAlwCtlAGghDRVUiSppcGTS5QLHYN/kn7PXDiHnX1+qQh0b3WaVLv
 T/TkMCoPk4lLjH1e3TyhnRx+HPbKDNlV/z45ThTz0Gp8lcsYxNaESOik18n+jefNeOIW
 SO1Q==
X-Gm-Message-State: AOAM532SRmzOMOpJRnBWdHZkEri6zSSXf9lgJw9/tMS/5GWxtH9dJj1s
 M/fk7pYvZAdppz2J+wYpjLqUCkCwpNeO7w==
X-Google-Smtp-Source: ABdhPJx4kToyubC6lCeN87zCNmuEOzpd1tCZwNVPjLaJyswe8LBMciizDAJKihUrNCpdY9/hLsvQhQ==
X-Received: by 2002:a05:6a00:a26:b0:4fd:f9dd:549c with SMTP id
 p38-20020a056a000a2600b004fdf9dd549cmr14275958pfh.42.1650316569446; 
 Mon, 18 Apr 2022 14:16:09 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:6b32:a0a5:ec32:c287])
 by smtp.gmail.com with UTF8SMTPSA id
 n24-20020aa79058000000b0050612d0fe01sm13406325pfo.2.2022.04.18.14.16.08
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 18 Apr 2022 14:16:08 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Mon, 18 Apr 2022 14:15:58 -0700
Message-Id: <20220418141545.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
In-Reply-To: <20220418211559.3832724-1-mka@chromium.org>
References: <20220418211559.3832724-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mailman-Approved-At: Tue, 19 Apr 2022 06:10:27 +0000
Subject: [dm-devel] [PATCH 2/3] LoadPin: Enable loading from trusted
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
'loadpin/trusted_verity_root_digests' to provide LoadPin
with a list of root digests from dm-verity devices that
LoadPin should consider as trusted. When a kernel file is
read LoadPin first checks (as usual) whether the file is
located on the pinned root, if so the file can be loaded.
Otherwise, if the verity extension is enabled, LoadPin
determines whether the file is located on a verity backed
device and whether the root digest of that device is in
the list of trusted digests. The file can be loaded if
the verity device has a trusted root digest.

The list of trusted root digests can only be written once
(typically at boot time), to limit the possiblity of
attackers setting up rogue verity devices and marking them
as trusted.

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

 security/loadpin/Kconfig   |  11 +++
 security/loadpin/loadpin.c | 168 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 178 insertions(+), 1 deletion(-)

diff --git a/security/loadpin/Kconfig b/security/loadpin/Kconfig
index 91be65dec2ab..cf3e6431e02d 100644
--- a/security/loadpin/Kconfig
+++ b/security/loadpin/Kconfig
@@ -18,3 +18,14 @@ config SECURITY_LOADPIN_ENFORCE
 	  If selected, LoadPin will enforce pinning at boot. If not
 	  selected, it can be enabled at boot with the kernel parameter
 	  "loadpin.enforce=1".
+
+config SECURITY_LOADPIN_VERITY
+	bool "Allow reading files from certain other filesystems that use dm-verity"
+	depends on DM_VERITY=y
+	help
+	  If selected LoadPin can allow reading files from filesystems
+	  that use dm-verity. A verity filesystem can be configured as
+	  being trusted by LoadPin by writing its root digest to the
+	  sysctl file 'trusted_verity_root_digests'. The sysctl file
+	  can only be written once (typically at boot) and accepts a
+	  list of comma separated digests.
diff --git a/security/loadpin/loadpin.c b/security/loadpin/loadpin.c
index b12f7d986b1e..b9c174f8687d 100644
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
+static bool verity_digests_set;
+static LIST_HEAD(trusted_verity_root_digests);
+#endif
 
 #ifdef CONFIG_SYSCTL
 
@@ -65,6 +71,144 @@ static struct ctl_table loadpin_sysctl_table[] = {
 	{ }
 };
 
+#ifdef CONFIG_SECURITY_LOADPIN_VERITY
+
+static int proc_verity_root_digests(struct ctl_table *table, int write,
+				    void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct trusted_root_digest *trd;
+	char *buf;
+	int rc;
+
+	if (write) {
+		struct ctl_table tbl = *table;
+		char *p, *d;
+
+		if (*ppos)
+			return -EINVAL;
+
+		if (verity_digests_set)
+			return -EPERM;
+
+		buf = kzalloc(tbl.maxlen, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		tbl.data = buf;
+
+		rc = proc_dostring(&tbl, write, buffer, lenp, ppos);
+		if (rc) {
+			kfree(buf);
+			return rc;
+		}
+
+		if (strlen(buf) == 0) {
+			verity_digests_set = true;
+			return false;
+		}
+
+		p = buf;
+		while ((d = strsep(&p, ",")) != NULL) {
+			int len = strlen(d);
+
+			if (len % 2) {
+				rc = -EINVAL;
+				goto err;
+			}
+
+			len /= 2;
+
+			trd = kzalloc(sizeof(*trd), GFP_KERNEL);
+			if (!trd) {
+				rc = -ENOMEM;
+				goto err;
+			}
+
+			list_add_tail(&trd->node, &trusted_verity_root_digests);
+
+			trd->data = kzalloc(len, GFP_KERNEL);
+			if (!trd->data) {
+				rc = -ENOMEM;
+				goto err;
+			}
+
+			if (hex2bin(trd->data, d, len)) {
+				rc = -EINVAL;
+				goto err;
+			}
+
+			trd->len = len;
+		}
+
+		kfree(buf);
+
+		if (!list_empty(&trusted_verity_root_digests)) {
+			dm_verity_loadpin_set_trusted_root_digests(&trusted_verity_root_digests);
+			verity_digests_set = true;
+		}
+	} else {
+		struct ctl_table tbl = { .maxlen = 0 };
+		size_t off = 0;
+
+		list_for_each_entry(trd, &trusted_verity_root_digests, node) {
+			/* two ASCII characters per byte and a comma / '\0' */
+			tbl.maxlen += (trd->len * 2) + 1;
+		}
+
+		tbl.data = kzalloc(tbl.maxlen, GFP_KERNEL);
+
+		list_for_each_entry(trd, &trusted_verity_root_digests, node) {
+			int i;
+
+			if (off > 0) {
+				snprintf(tbl.data + off, tbl.maxlen - off, ",");
+				off++;
+			}
+
+			for (i = 0; i < trd->len; i++) {
+				snprintf(tbl.data + off, tbl.maxlen - off, "%02x", trd->data[i]);
+				off += 2;
+			}
+		}
+
+		proc_dostring(&tbl, write, buffer, lenp, ppos);
+		kfree(tbl.data);
+	}
+
+	return 0;
+
+err:
+	kfree(buf);
+
+	{
+		struct trusted_root_digest *tmp;
+
+		list_for_each_entry_safe(trd, tmp, &trusted_verity_root_digests, node) {
+			kfree(trd->data);
+			list_del(&trd->node);
+			kfree(trd);
+		}
+	}
+
+	return rc;
+}
+
+static struct ctl_table loadpin_sysctl_table_verity[] = {
+	{
+		.procname       = "trusted_verity_root_digests",
+		.maxlen         = SZ_4K,
+		.mode           = 0644,
+		.proc_handler   = proc_verity_root_digests,
+	},
+
+	{ }
+};
+#else
+
+static struct ctl_table loadpin_sysctl_table_verity[] = {};
+
+#endif /* CONFIG_SECURITY_LOADPIN_VERITY */
+
 /*
  * This must be called after early kernel init, since then the rootdev
  * is available.
@@ -118,6 +262,20 @@ static void loadpin_sb_free_security(struct super_block *mnt_sb)
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
@@ -174,7 +332,8 @@ static int loadpin_read_file(struct file *file, enum kernel_read_file_id id,
 		spin_unlock(&pinned_root_spinlock);
 	}
 
-	if (IS_ERR_OR_NULL(pinned_root) || load_root != pinned_root) {
+	if (IS_ERR_OR_NULL(pinned_root) ||
+	    ((load_root != pinned_root) && !loadpin_is_fs_trusted(load_root))) {
 		if (unlikely(!enforce)) {
 			report_load(origin, file, "pinning-ignored");
 			return 0;
@@ -240,6 +399,13 @@ static int __init loadpin_init(void)
 		enforce ? "" : "not ");
 	parse_exclude();
 	security_add_hooks(loadpin_hooks, ARRAY_SIZE(loadpin_hooks), "loadpin");
+
+	if (IS_ENABLED(CONFIG_SECURITY_LOADPIN_VERITY)) {
+		if (!register_sysctl_paths(loadpin_sysctl_path,
+					   loadpin_sysctl_table_verity))
+			pr_notice("sysctl registration failed!\n");
+	}
+
 	return 0;
 }
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

