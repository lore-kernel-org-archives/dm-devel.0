Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C3AFC433FE
	for <dm-devel@archiver.kernel.org>; Wed,  4 May 2022 21:23:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-y2YQ3js1O5yzRbOtlb0LCg-1; Wed, 04 May 2022 17:23:33 -0400
X-MC-Unique: y2YQ3js1O5yzRbOtlb0LCg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 956911857F19;
	Wed,  4 May 2022 21:23:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8081AC28112;
	Wed,  4 May 2022 21:23:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0FB1E194707A;
	Wed,  4 May 2022 21:23:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F1A791947046
 for <dm-devel@listman.corp.redhat.com>; Wed,  4 May 2022 19:54:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E4382415F5E; Wed,  4 May 2022 19:54:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E058A403373
 for <dm-devel@redhat.com>; Wed,  4 May 2022 19:54:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C84E129ABA06
 for <dm-devel@redhat.com>; Wed,  4 May 2022 19:54:30 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-522-kKBw_RUlMX6sn20DoOzeHw-1; Wed, 04 May 2022 15:54:26 -0400
X-MC-Unique: kKBw_RUlMX6sn20DoOzeHw-1
Received: by mail-pj1-f46.google.com with SMTP id
 cq17-20020a17090af99100b001dc0386cd8fso2136873pjb.5
 for <dm-devel@redhat.com>; Wed, 04 May 2022 12:54:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=5CetlpCftC8fa22AwQ7f9noDAbp04u3fxXYOBJDWXdo=;
 b=1KhhHlVfY880t0iGfn95vEtnbj30KxeIYPhzYYDlESoRDB+y+XNE4UFHh6qIqVX88I
 lF8dgABsBqc2kiR1btoG5wMYsgjz+0HPaVZmzT2wjfhcrKvwkYS/dGta8wEtCR+JRips
 hzIBUwxcjF8V6zouvLIbekF45E4BPkuw4JaAOMBlWDDIFDYsQLqQrkpIjzvjqL3Hq/ow
 0MCJNiD02ITXaG9YpQGBNT/dSY5BLXVp5jqRhC0KVL3Cy+xhQN+y+iBLDDFQisQeNGWE
 nX2WweMX6NFrG8UVLzaAbzNdpIcBBIunl3B9Il/h+1bkf+BpHup/t6a2+f5UXupa2V29
 iCWg==
X-Gm-Message-State: AOAM533ZzRKkeSK0nimF6BI3m7Xe2uZom55IYWjPcsPyVtJzPlXE2TIp
 GH7W3IDAFjD7kJWH9qQA4ht1X9LybOXTyQ==
X-Google-Smtp-Source: ABdhPJzmCKD4KIjLDv8vNDJK4ppeaWC2YAVRNAFyqVpurA+XTRKpw2HAvCD1vyC3w23XbEThwD8IPQ==
X-Received: by 2002:a17:902:ecc8:b0:15e:9e46:cb7e with SMTP id
 a8-20020a170902ecc800b0015e9e46cb7emr18203039plh.111.1651694065547; 
 Wed, 04 May 2022 12:54:25 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:35b6:c77b:be04:3bd5])
 by smtp.gmail.com with UTF8SMTPSA id
 n5-20020aa79045000000b0050dc7628143sm8586582pfo.29.2022.05.04.12.54.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 04 May 2022 12:54:25 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Wed,  4 May 2022 12:54:17 -0700
Message-Id: <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
In-Reply-To: <20220504195419.1143099-1-mka@chromium.org>
References: <20220504195419.1143099-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Mailman-Approved-At: Wed, 04 May 2022 21:23:25 +0000
Subject: [dm-devel] [PATCH v3 1/3] dm: Add verity helpers for LoadPin
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
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
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

LoadPin limits loading of kernel modules, firmware and certain
other files to a 'pinned' file system (typically a read-only
rootfs). To provide more flexibility LoadPin is being extended
to also allow loading these files from trusted dm-verity
devices. For that purpose LoadPin can be provided with a list
of verity root digests that it should consider as trusted.

Add a bunch of helpers to allow LoadPin to check whether a DM
device is a trusted verity device. The new functions broadly
fall in two categories: those that need access to verity
internals (like the root digest), and the 'glue' between
LoadPin and verity. The new file dm-verity-loadpin.c contains
the glue functions.

Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---

Changes in v3:
- none

Changes in v2:
- none

 drivers/md/Makefile               |  6 +++
 drivers/md/dm-verity-loadpin.c    | 80 +++++++++++++++++++++++++++++++
 drivers/md/dm-verity-target.c     | 33 +++++++++++++
 drivers/md/dm-verity.h            |  4 ++
 include/linux/dm-verity-loadpin.h | 27 +++++++++++
 5 files changed, 150 insertions(+)
 create mode 100644 drivers/md/dm-verity-loadpin.c
 create mode 100644 include/linux/dm-verity-loadpin.h

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 0454b0885b01..e12cd004d375 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -100,6 +100,12 @@ ifeq ($(CONFIG_IMA),y)
 dm-mod-objs			+= dm-ima.o
 endif
 
+ifeq ($(CONFIG_DM_VERITY),y)
+ifeq ($(CONFIG_SECURITY_LOADPIN),y)
+dm-mod-objs			+= dm-verity-loadpin.o
+endif
+endif
+
 ifeq ($(CONFIG_DM_VERITY_FEC),y)
 dm-verity-objs			+= dm-verity-fec.o
 endif
diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
new file mode 100644
index 000000000000..972ca93a2231
--- /dev/null
+++ b/drivers/md/dm-verity-loadpin.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/dm-verity-loadpin.h>
+
+#include "dm.h"
+#include "dm-verity.h"
+
+static struct list_head *trusted_root_digests;
+
+/*
+ * Sets the root digests of verity devices which LoadPin considers as trusted.
+ *
+ * This function must only be called once.
+ */
+void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests)
+{
+	if (!trusted_root_digests)
+		trusted_root_digests = digests;
+	else
+		pr_warn("verity root digests trusted by LoadPin are already set!!!\n");
+}
+
+static bool is_trusted_verity_target(struct dm_target *ti)
+{
+	u8 *root_digest;
+	unsigned int digest_size;
+	struct trusted_root_digest *trd;
+	bool trusted = false;
+
+	if (!dm_is_verity_target(ti))
+		return false;
+
+	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
+		return false;
+
+	list_for_each_entry(trd, trusted_root_digests, node) {
+		if ((trd->len == digest_size) &&
+		    !memcmp(trd->data, root_digest, digest_size)) {
+			trusted = true;
+			break;
+		}
+	}
+
+	kfree(root_digest);
+
+	return trusted;
+}
+
+/*
+ * Determines whether a mapped device is a verity device that is trusted
+ * by LoadPin.
+ */
+bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md)
+{
+	int srcu_idx;
+	struct dm_table *table;
+	unsigned int num_targets;
+	bool trusted = false;
+	int i;
+
+	if (!trusted_root_digests || list_empty(trusted_root_digests))
+		return false;
+
+	table = dm_get_live_table(md, &srcu_idx);
+	num_targets = dm_table_get_num_targets(table);
+	for (i = 0; i < num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(table, i);
+
+		if (is_trusted_verity_target(ti)) {
+			trusted = true;
+			break;
+		}
+	}
+
+	dm_put_live_table(md, srcu_idx);
+
+	return trusted;
+}
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 80133aae0db3..6f07b849fcb2 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/scatterlist.h>
+#include <linux/string.h>
 
 #define DM_MSG_PREFIX			"verity"
 
@@ -1310,6 +1311,38 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	return r;
 }
 
+/*
+ * Check whether a DM target is a verity target.
+ */
+bool dm_is_verity_target(struct dm_target *ti)
+{
+	return ti->type->module == THIS_MODULE;
+}
+EXPORT_SYMBOL_GPL(dm_is_verity_target);
+
+/*
+ * Get the root digest of a verity target.
+ *
+ * Returns a copy of the root digest, the caller is responsible for
+ * freeing the memory of the digest.
+ */
+int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned int *digest_size)
+{
+	struct dm_verity *v = ti->private;
+
+	if (!dm_is_verity_target(ti))
+		return -EINVAL;
+
+	*root_digest = kmemdup(v->root_digest, v->digest_size, GFP_KERNEL);
+	if (*root_digest == NULL)
+		return -ENOMEM;
+
+	*digest_size = v->digest_size;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_verity_get_root_digest);
+
 static struct target_type verity_target = {
 	.name		= "verity",
 	.version	= {1, 8, 0},
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index 4e769d13473a..c832cc3e3d24 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -129,4 +129,8 @@ extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
 extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
 				 sector_t block, u8 *digest, bool *is_zero);
 
+extern bool dm_is_verity_target(struct dm_target *ti);
+extern int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest,
+				     unsigned int *digest_size);
+
 #endif /* DM_VERITY_H */
diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
new file mode 100644
index 000000000000..12a86911d05a
--- /dev/null
+++ b/include/linux/dm-verity-loadpin.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __LINUX_DM_VERITY_LOADPIN_H
+#define __LINUX_DM_VERITY_LOADPIN_H
+
+#include <linux/list.h>
+
+struct mapped_device;
+
+struct trusted_root_digest {
+	u8 *data;
+	unsigned int len;
+	struct list_head node;
+};
+
+#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
+void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests);
+bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md);
+#else
+static inline void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests) {}
+static inline bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md)
+{
+	return false;
+}
+#endif
+
+#endif /* __LINUX_DM_LOADPIN_H */
-- 
2.36.0.464.gb9c8b46e94-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

