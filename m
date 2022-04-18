Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C65F9C43219
	for <dm-devel@archiver.kernel.org>; Tue, 19 Apr 2022 06:10:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-7pAjR57OPxOuUpc7gyP9_Q-1; Tue, 19 Apr 2022 02:10:44 -0400
X-MC-Unique: 7pAjR57OPxOuUpc7gyP9_Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC047949054;
	Tue, 19 Apr 2022 06:10:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B589B145F94C;
	Tue, 19 Apr 2022 06:10:39 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 14B1B194EBAB;
	Tue, 19 Apr 2022 06:10:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8DD321947BBD
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 21:16:10 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7CF79454D64; Mon, 18 Apr 2022 21:16:10 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 789C4440ABF
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:16:10 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5DF7385A5A8
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 21:16:10 +0000 (UTC)
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com
 [209.85.215.178]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-T52D2HJsNtCHCTMOJQW3Dg-1; Mon, 18 Apr 2022 17:16:08 -0400
X-MC-Unique: T52D2HJsNtCHCTMOJQW3Dg-1
Received: by mail-pg1-f178.google.com with SMTP id k29so21073717pgm.12
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 14:16:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=3NUaPl7T9VDjPF5pSPc597gsFG5v6iWsZQaLgLfeQww=;
 b=ADGqsuH+Is37HgjOY6EvyByFEE3lafCc38OzQMa199ysf3GR7eX7PwAxkB5e97Nr4r
 im4jsRq/Ph/Z11aflYCSKtz3TxEniH31QOukYk+JwFqpU8N/CQ3W7qHZOBnBFVBco4Dd
 fxdBnmn04mRxHAo5EqdlZUHo4XMDXniEgIbJDBf/9BU8BFjoNPJpPUn6QHInnD7oAOBP
 L+mI3cti2eJXF581gTPOUkvZX14yOlxyqH5FVb8l7wqBeT2KZJpYX6t4yVOhx8mLMUSY
 ksP2yBLCamvPIPS5zI1dCW9i3vFMLX3Iag4pZc3/4URmI/ZBNTuntVRaWtRMdOPXNred
 M5Ow==
X-Gm-Message-State: AOAM533/0ZQazmIQk9IskBH7dYW/Vws9cDYcOlzxG3Me1i0AdkVgoZtc
 4J/p7aOeaOSXZgeC1LrcqjJpOU/+rPIQrQ==
X-Google-Smtp-Source: ABdhPJyQQEFDCs5IVHAM/UnOWzfEHFGUzBQrHu06Pf6Bm6srYRBFZ5pue0X3KWczqh0V440cxpFgFA==
X-Received: by 2002:a05:6a00:1786:b0:50a:7f5a:e280 with SMTP id
 s6-20020a056a00178600b0050a7f5ae280mr4803956pfg.25.1650316567469; 
 Mon, 18 Apr 2022 14:16:07 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:6b32:a0a5:ec32:c287])
 by smtp.gmail.com with UTF8SMTPSA id
 w13-20020a17090a5e0d00b001c7d4099670sm13858457pjf.28.2022.04.18.14.16.05
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 18 Apr 2022 14:16:06 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Mon, 18 Apr 2022 14:15:57 -0700
Message-Id: <20220418141545.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
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
Subject: [dm-devel] [PATCH 1/3] dm: Add verity helpers for LoadPin
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
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

 drivers/md/Makefile               |  6 +++
 drivers/md/dm-verity-loadpin.c    | 80 +++++++++++++++++++++++++++++++
 drivers/md/dm-verity-target.c     | 34 +++++++++++++
 drivers/md/dm-verity.h            |  4 ++
 include/linux/dm-verity-loadpin.h | 27 +++++++++++
 5 files changed, 151 insertions(+)
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
index 80133aae0db3..6bea9692cd39 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -16,9 +16,11 @@
 #include "dm-verity.h"
 #include "dm-verity-fec.h"
 #include "dm-verity-verify-sig.h"
+#include <crypto/hash.h>
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/scatterlist.h>
+#include <linux/string.h>
 
 #define DM_MSG_PREFIX			"verity"
 
@@ -1310,6 +1312,38 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
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
+ * Returns a copy of the root digests, the caller is responsible for
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
2.36.0.rc0.470.gd361397f0d-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

