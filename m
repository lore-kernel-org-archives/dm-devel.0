Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 333F7C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 23 May 2022 21:14:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-Yc1FY02mM4qbVwwaTZyIHA-1; Mon, 23 May 2022 17:14:11 -0400
X-MC-Unique: Yc1FY02mM4qbVwwaTZyIHA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2D691299E752;
	Mon, 23 May 2022 21:14:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D18AD41136E1;
	Mon, 23 May 2022 21:14:09 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9911C1947B84;
	Mon, 23 May 2022 21:14:09 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E4CB1947B83
 for <dm-devel@listman.corp.redhat.com>; Mon, 23 May 2022 21:14:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1DFB02026D2F; Mon, 23 May 2022 21:14:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1945D2026D6A
 for <dm-devel@redhat.com>; Mon, 23 May 2022 21:14:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDD6E85A5B5
 for <dm-devel@redhat.com>; Mon, 23 May 2022 21:14:07 +0000 (UTC)
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com
 [209.85.215.173]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-2-weI3GuVdOzSKuF8_AlSd5w-1; Mon, 23 May 2022 17:14:06 -0400
X-MC-Unique: weI3GuVdOzSKuF8_AlSd5w-1
Received: by mail-pg1-f173.google.com with SMTP id j21so14494230pga.13
 for <dm-devel@redhat.com>; Mon, 23 May 2022 14:14:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references:mime-version:content-transfer-encoding;
 bh=nFCWx+ylAY8dgCt25JkKf17aOAoMoBf41nquHMuShDE=;
 b=iUZguSJzdwSxQ8c3bHEQDmLcfBO4rIm126gMhmy3DDy3g5fPQh3+Kn+qNl98324sRW
 6ezphhfGtNSNrvQ4asuSmLQO2FQvx5JhJc9NpHI8oaTDOiZwBS5H7t2sQabQytFXqD7B
 FisXxtGUmBdTojUNXMtXKiqfb4pLo3zCPZ/WEiOrOCqtCyBl1JPpXdaII6c8zp+qp18+
 3lgzPgsxrQpn3Kc1m3sSDqhsNR0vhdT50Kf1KRVFuPSh2ZwwtU/EVVNbKn5ul3tXhafy
 pqMYvriB+UaEv9+k0b90CYS2+JQHLvKtC1Ki+O6V4qEr6AySlpVxjwtUZepUpdoIER0j
 /nSA==
X-Gm-Message-State: AOAM533DQaW9elsqNW1SXQsaXPCu5aiu7yJdpSg2HjHu3mUfyO5F9rnV
 GcRux0YSvPtPIbZZ7HF6k38vYw==
X-Google-Smtp-Source: ABdhPJzFBI8sZMoLwz+YBgyqx5St60xio7LcpPb0/AquoAtcXVQBdrULJtODVLNJRd6PnonV4Oef3Q==
X-Received: by 2002:a63:8bc9:0:b0:3f8:4817:880b with SMTP id
 j192-20020a638bc9000000b003f84817880bmr15353756pge.87.1653340444919; 
 Mon, 23 May 2022 14:14:04 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:d9e2:8472:9ac:8532])
 by smtp.gmail.com with UTF8SMTPSA id
 v17-20020a17090ad59100b001deb92de665sm118439pju.46.2022.05.23.14.14.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 23 May 2022 14:14:04 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Mon, 23 May 2022 14:13:58 -0700
Message-Id: <20220523141325.v6.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
In-Reply-To: <20220523211400.290537-1-mka@chromium.org>
References: <20220523211400.290537-1-mka@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH v6 1/3] dm: Add verity helpers for LoadPin
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Matthias Kaehlcke <mka@chromium.org>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
Acked-by: Kees Cook <keescook@chromium.org>
---

Changes in v6:
- s/loadpin_trusted_verity_root_digests/dm_verity_loadpin_trusted_root_digests/
- s/trusted_root_digest/dm_verity_loadpin_trusted_root_digest/
- removed unnecessary symbol exports

Changes in v5:
- changed dm_verity_loadpin_is_sb_trusted() to
  dm_verity_loadpin_is_bdev_trusted()
- bumped version number to 1.8.1
- deleted bad semicolon in declaration of stub for
  dm_verity_loadpin_is_bdev_trusted()
- added 'Acked-by' tag from Kees

Changes in v4:
- a trusted verity device must have a single target of
  type 'verity'
- share list of verity digests with loadpin, deleted
  dm_verity_loadpin_set_trusted_root_digests()
- dm_verity_loadpin_is_md_trusted() is now dm_verity_loadpin_is_sb_trusted(),
  it receives a super_block instead of mapped_device. Updated kernel doc.
- changed struct trusted_root_digest to have an unsized
  u8 array instead of a pointer
- extend 'dm-verity-objs' instead of 'dm-mod-objs'

Changes in v3:
- none

Changes in v2:
- none

 drivers/md/Makefile               |  6 +++
 drivers/md/dm-verity-loadpin.c    | 74 +++++++++++++++++++++++++++++++
 drivers/md/dm-verity-target.c     | 33 +++++++++++++-
 drivers/md/dm-verity.h            |  4 ++
 include/linux/dm-verity-loadpin.h | 27 +++++++++++
 5 files changed, 143 insertions(+), 1 deletion(-)
 create mode 100644 drivers/md/dm-verity-loadpin.c
 create mode 100644 include/linux/dm-verity-loadpin.h

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 0454b0885b01..71771901c823 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -108,6 +108,12 @@ ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
 dm-verity-objs			+= dm-verity-verify-sig.o
 endif
 
+ifeq ($(CONFIG_DM_VERITY),y)
+ifeq ($(CONFIG_SECURITY_LOADPIN),y)
+dm-verity-objs			+= dm-verity-loadpin.o
+endif
+endif
+
 ifeq ($(CONFIG_DM_AUDIT),y)
 dm-mod-objs			+= dm-audit.o
 endif
diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
new file mode 100644
index 000000000000..10c18bc1652c
--- /dev/null
+++ b/drivers/md/dm-verity-loadpin.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/dm-verity-loadpin.h>
+
+#include "dm.h"
+#include "dm-verity.h"
+
+#define DM_MSG_PREFIX	"verity-loadpin"
+
+LIST_HEAD(dm_verity_loadpin_trusted_root_digests);
+
+static bool is_trusted_verity_target(struct dm_target *ti)
+{
+	u8 *root_digest;
+	unsigned int digest_size;
+	struct dm_verity_loadpin_trusted_root_digest *trd;
+	bool trusted = false;
+
+	if (!dm_is_verity_target(ti))
+		return false;
+
+	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
+		return false;
+
+	list_for_each_entry(trd, &dm_verity_loadpin_trusted_root_digests, node) {
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
+ * Determines whether the file system of a superblock is located on
+ * a verity device that is trusted by LoadPin.
+ */
+bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
+{
+	struct mapped_device *md;
+	struct dm_table *table;
+	struct dm_target *ti;
+	int srcu_idx;
+	bool trusted = false;
+
+	if (list_empty(&dm_verity_loadpin_trusted_root_digests))
+		return false;
+
+	md = dm_get_md(bdev->bd_dev);
+	if (!md)
+		return false;
+
+	table = dm_get_live_table(md, &srcu_idx);
+
+	if (dm_table_get_num_targets(table) != 1)
+		goto out;
+
+	ti = dm_table_get_target(table, 0);
+
+	if (is_trusted_verity_target(ti))
+		trusted = true;
+
+out:
+	dm_put_live_table(md, srcu_idx);
+	dm_put(md);
+
+	return trusted;
+}
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 80133aae0db3..c5395e93525a 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/scatterlist.h>
+#include <linux/string.h>
 
 #define DM_MSG_PREFIX			"verity"
 
@@ -1310,9 +1311,39 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	return r;
 }
 
+/*
+ * Check whether a DM target is a verity target.
+ */
+bool dm_is_verity_target(struct dm_target *ti)
+{
+	return ti->type->module == THIS_MODULE;
+}
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
+
 static struct target_type verity_target = {
 	.name		= "verity",
-	.version	= {1, 8, 0},
+	.version	= {1, 8, 1},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
 	.dtr		= verity_dtr,
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
index 000000000000..fb695ecaa5d5
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
+struct block_device;
+
+extern struct list_head dm_verity_loadpin_trusted_root_digests;
+
+struct dm_verity_loadpin_trusted_root_digest {
+	struct list_head node;
+	unsigned int len;
+	u8 data[];
+};
+
+#if IS_ENABLED(CONFIG_SECURITY_LOADPIN) && IS_BUILTIN(CONFIG_DM_VERITY)
+bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev);
+#else
+static inline bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
+{
+	return false;
+}
+#endif
+
+#endif /* __LINUX_DM_VERITY_LOADPIN_H */
-- 
2.36.1.124.g0e6072fb45-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

