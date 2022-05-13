Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E1BEC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 13 May 2022 22:16:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-175-kZDVJObNMLKvH8thrkmbhg-1; Fri, 13 May 2022 18:16:08 -0400
X-MC-Unique: kZDVJObNMLKvH8thrkmbhg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E71C5185A794;
	Fri, 13 May 2022 22:16:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9699141047E9;
	Fri, 13 May 2022 22:16:06 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 352871932238;
	Fri, 13 May 2022 22:16:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6E576194975B
 for <dm-devel@listman.corp.redhat.com>; Fri, 13 May 2022 22:16:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 260F3111F3C1; Fri, 13 May 2022 22:16:05 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 21577111F3B6
 for <dm-devel@redhat.com>; Fri, 13 May 2022 22:15:59 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A4C833C19025
 for <dm-devel@redhat.com>; Fri, 13 May 2022 22:15:59 +0000 (UTC)
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com
 [209.85.216.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-KbvKkhFIMpO72LBEU8qIyg-1; Fri, 13 May 2022 18:15:58 -0400
X-MC-Unique: KbvKkhFIMpO72LBEU8qIyg-1
Received: by mail-pj1-f46.google.com with SMTP id
 l20-20020a17090a409400b001dd2a9d555bso9021077pjg.0
 for <dm-devel@redhat.com>; Fri, 13 May 2022 15:15:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
 :references:message-id:mime-version:content-transfer-encoding;
 bh=8evsmsRgEXU9i1Zu7hcfNtENF1tNp6TzzC6MYoPKnsk=;
 b=EJN9QqjcKtFJPjQupyhtXplalGWlR5mpkyysFr5UiGTWXKkKcxvA2BgREKJl0MNSVo
 j8rqmvIIp1yJ99g6GBV2Ajf1EbiuKph9fwynL7zcc8AvX260S25dBdZZ9aMTxLp3O34h
 2Xm382RjycdgSX7XZRjuJaPRfx7RQVABPUBWYuwcgKeWHEnf9h8qndvYsRAjLmcCLx0F
 sQYSqMk33lo9+pzT5JmSUcZ/8Q1CHa3BSUYUlO4zZ20iSl4hdCo2yGTUj4/c3DNzsRz+
 zszHKEbB1wF3Y6OpQOtHdj3jQ6dFktyzp+0WaGF5yYcOBrWUaDCwKzRP6I7epSy9Lxgq
 3nIQ==
X-Gm-Message-State: AOAM531jePropN+azJHS0ajpl7DZJdOsDyOaV1+e/LNsLD1sVDijKyDC
 dxizaBFzImCzeo6H0XqfR3svoQ==
X-Google-Smtp-Source: ABdhPJzSxU8Q1LxQ0CmSrYrip2cEiTE+YGFGKC8YEWo6YSG9RKpU6dCkHklOK9FqXRrmHa5BpMjYhA==
X-Received: by 2002:a17:90a:b78d:b0:1d9:4f4f:bc2a with SMTP id
 m13-20020a17090ab78d00b001d94f4fbc2amr18247100pjr.155.1652480156857; 
 Fri, 13 May 2022 15:15:56 -0700 (PDT)
Received: from ?IPv6:::1? ([2607:fb90:3322:7d68:6474:9b3c:2c42:56f1])
 by smtp.gmail.com with ESMTPSA id
 o12-20020a170902d4cc00b0015ebb3bf277sm2375659plg.238.2022.05.13.15.15.56
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 13 May 2022 15:15:56 -0700 (PDT)
Date: Fri, 13 May 2022 15:15:53 -0700
From: Kees Cook <keescook@chromium.org>
To: Matthias Kaehlcke <mka@chromium.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
Message-ID: <02028CEA-5704-4A51-8CAD-BEE53CEF7CCA@chromium.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH v3 1/3] dm: Add verity helpers for LoadPin
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



On May 4, 2022 12:54:17 PM PDT, Matthias Kaehlcke <mka@chromium.org> wrote:
>LoadPin limits loading of kernel modules, firmware and certain
>other files to a 'pinned' file system (typically a read-only
>rootfs). To provide more flexibility LoadPin is being extended
>to also allow loading these files from trusted dm-verity
>devices. For that purpose LoadPin can be provided with a list
>of verity root digests that it should consider as trusted.
>
>Add a bunch of helpers to allow LoadPin to check whether a DM
>device is a trusted verity device. The new functions broadly
>fall in two categories: those that need access to verity
>internals (like the root digest), and the 'glue' between
>LoadPin and verity. The new file dm-verity-loadpin.c contains
>the glue functions.
>
>Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> [...]
>diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
>new file mode 100644
>index 000000000000..972ca93a2231
>--- /dev/null
>+++ b/drivers/md/dm-verity-loadpin.c
>@@ -0,0 +1,80 @@
>+// SPDX-License-Identifier: GPL-2.0-only
>+
>+#include <linux/list.h>
>+#include <linux/kernel.h>
>+#include <linux/dm-verity-loadpin.h>
>+
>+#include "dm.h"
>+#include "dm-verity.h"
>+
>+static struct list_head *trusted_root_digests;

Does this need to exist in two places? (i.e. why can't dm and loadpin share this instead of needing dm_verity_loadpin_set_trusted_digests()?)

>+
>+/*
>+ * Sets the root digests of verity devices which LoadPin considers as trusted.
>+ *
>+ * This function must only be called once.
>+ */
>+void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests)
>+{
>+	if (!trusted_root_digests)
>+		trusted_root_digests = digests;
>+	else
>+		pr_warn("verity root digests trusted by LoadPin are already set!!!\n");
>+}
>+
>+static bool is_trusted_verity_target(struct dm_target *ti)
>+{
>+	u8 *root_digest;
>+	unsigned int digest_size;
>+	struct trusted_root_digest *trd;
>+	bool trusted = false;
>+
>+	if (!dm_is_verity_target(ti))
>+		return false;
>+
>+	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
>+		return false;
>+
>+	list_for_each_entry(trd, trusted_root_digests, node) {
>+		if ((trd->len == digest_size) &&
>+		    !memcmp(trd->data, root_digest, digest_size)) {
>+			trusted = true;
>+			break;
>+		}
>+	}
>+
>+	kfree(root_digest);
>+
>+	return trusted;
>+}
>+
>+/*
>+ * Determines whether a mapped device is a verity device that is trusted
>+ * by LoadPin.
>+ */
>+bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md)
>+{
>+	int srcu_idx;
>+	struct dm_table *table;
>+	unsigned int num_targets;
>+	bool trusted = false;
>+	int i;
>+
>+	if (!trusted_root_digests || list_empty(trusted_root_digests))
>+		return false;
>+
>+	table = dm_get_live_table(md, &srcu_idx);
>+	num_targets = dm_table_get_num_targets(table);
>+	for (i = 0; i < num_targets; i++) {
>+		struct dm_target *ti = dm_table_get_target(table, i);
>+
>+		if (is_trusted_verity_target(ti)) {
>+			trusted = true;
>+			break;
>+		}
>+	}

Pardon my lack of dm vocabulary, but what is "target" vs "table" here? I was only thinking of "whole device", so I must not understand what this is examining.

> [...]
>diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
>new file mode 100644
>index 000000000000..12a86911d05a
>--- /dev/null
>+++ b/include/linux/dm-verity-loadpin.h
>@@ -0,0 +1,27 @@
>+/* SPDX-License-Identifier: GPL-2.0 */
>+
>+#ifndef __LINUX_DM_VERITY_LOADPIN_H
>+#define __LINUX_DM_VERITY_LOADPIN_H
>+
>+#include <linux/list.h>
>+
>+struct mapped_device;
>+
>+struct trusted_root_digest {
>+	u8 *data;
>+	unsigned int len;
>+	struct list_head node;
>+};

To avoid the double-alloc in patch 2 (and save 1 pointer size of memory), this could just be:

struct trusted_root_digest {
	struct list_head node;
	unsigned int len;
	u8 data[];
};

Otherwise, looks good to me!

-- 
Kees Cook

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

