Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3063C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 16 May 2022 18:52:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-SSeboA1OPlK0miQG-r8f4w-1; Mon, 16 May 2022 14:52:04 -0400
X-MC-Unique: SSeboA1OPlK0miQG-r8f4w-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 320FB8C5A8E;
	Mon, 16 May 2022 18:52:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 25E32492C14;
	Mon, 16 May 2022 18:52:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 065FD1947059;
	Mon, 16 May 2022 18:52:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3C24E1947055
 for <dm-devel@listman.corp.redhat.com>; Mon, 16 May 2022 18:51:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 03861400DE5E; Mon, 16 May 2022 18:51:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F32F840CF8E2
 for <dm-devel@redhat.com>; Mon, 16 May 2022 18:51:58 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D907A85A5BC
 for <dm-devel@redhat.com>; Mon, 16 May 2022 18:51:58 +0000 (UTC)
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com
 [209.85.210.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-539-ezAFAQtOOveKOG69Ds0GrA-1; Mon, 16 May 2022 14:51:57 -0400
X-MC-Unique: ezAFAQtOOveKOG69Ds0GrA-1
Received: by mail-pf1-f169.google.com with SMTP id a11so14854151pff.1
 for <dm-devel@redhat.com>; Mon, 16 May 2022 11:51:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=w/vXrhHYz4hayxXTpvluCRqtSLwMXWsi89GFr9tS/YQ=;
 b=g/cgoJadjDtbhvhML29yYgC2BZ3pzOIfMvbCQ8hghjch78cBr7pb2xDuYe01qrnsoJ
 DUkQjZvsrl9+z4G3ZQnEM5E83UqCCVlrXrjN1DNdyTYIe7cY1NUbDTO8AgCLnPlSsR1B
 uV8eOmEymm9CD1KExAuwDBM97r5z7jFRcXTzMASLH0TRx10npd0/39NA2oOnxolf0ySY
 Lfpfa0S0qL+wnUW9jwk4AqSTuEc2hd81V49BNup9LlIEXMGk/4n+1Jefeb/LE/ueecgP
 clcIgCxOuMCzcfm9ik0jJ+0f6VwZO/xDNKszro0gfid/OZJNXwuMa6wjNaQMnlFPzxWD
 qavA==
X-Gm-Message-State: AOAM532d4u2ODblEEViTKs26X1wwXsL+vcp3xPI7h52gLsjlgSsV5592
 EUFQ7gUKUT4fOyOcFqNFZqUMI687IHgwIA==
X-Google-Smtp-Source: ABdhPJymcURqRMGcWWF5SnA9wwUQk3JoOR0K/mUC0Yv15khQOmO0SNCL+Q4Njsx+FkSULBV01/EO0w==
X-Received: by 2002:a63:4387:0:b0:3c6:9490:4e4b with SMTP id
 q129-20020a634387000000b003c694904e4bmr16157541pga.438.1652727116092; 
 Mon, 16 May 2022 11:51:56 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:4ee0:ca4c:63fd:81d2])
 by smtp.gmail.com with UTF8SMTPSA id
 b2-20020a170902650200b0015e8d4eb264sm7480975plk.174.2022.05.16.11.51.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 16 May 2022 11:51:55 -0700 (PDT)
Date: Mon, 16 May 2022 11:51:54 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Kees Cook <keescook@chromium.org>
Message-ID: <YoKdSrjVf/tHGoa5@google.com>
References: <20220504195419.1143099-1-mka@chromium.org>
 <20220504125404.v3.1.I3e928575a23481121e73286874c4c2bdb403355d@changeid>
 <02028CEA-5704-4A51-8CAD-BEE53CEF7CCA@chromium.org>
MIME-Version: 1.0
In-Reply-To: <02028CEA-5704-4A51-8CAD-BEE53CEF7CCA@chromium.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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
Cc: linux-security-module@vger.kernel.org,
 Douglas Anderson <dianders@chromium.org>, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, "Serge E . Hallyn" <serge@hallyn.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, May 13, 2022 at 03:15:53PM -0700, Kees Cook wrote:
> 
> 
> On May 4, 2022 12:54:17 PM PDT, Matthias Kaehlcke <mka@chromium.org> wrote:
> >LoadPin limits loading of kernel modules, firmware and certain
> >other files to a 'pinned' file system (typically a read-only
> >rootfs). To provide more flexibility LoadPin is being extended
> >to also allow loading these files from trusted dm-verity
> >devices. For that purpose LoadPin can be provided with a list
> >of verity root digests that it should consider as trusted.
> >
> >Add a bunch of helpers to allow LoadPin to check whether a DM
> >device is a trusted verity device. The new functions broadly
> >fall in two categories: those that need access to verity
> >internals (like the root digest), and the 'glue' between
> >LoadPin and verity. The new file dm-verity-loadpin.c contains
> >the glue functions.
> >
> >Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > [...]
> >diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
> >new file mode 100644
> >index 000000000000..972ca93a2231
> >--- /dev/null
> >+++ b/drivers/md/dm-verity-loadpin.c
> >@@ -0,0 +1,80 @@
> >+// SPDX-License-Identifier: GPL-2.0-only
> >+
> >+#include <linux/list.h>
> >+#include <linux/kernel.h>
> >+#include <linux/dm-verity-loadpin.h>
> >+
> >+#include "dm.h"
> >+#include "dm-verity.h"
> >+
> >+static struct list_head *trusted_root_digests;
> 
> Does this need to exist in two places? (i.e. why can't dm and loadpin share
> this instead of needing dm_verity_loadpin_set_trusted_digests()?)

We could share it. Probably it should then be defined here, since this is
the first patch of the series, we could add an extern declaration to
dm-verity-loadpin.h.

> >+
> >+/*
> >+ * Sets the root digests of verity devices which LoadPin considers as trusted.
> >+ *
> >+ * This function must only be called once.
> >+ */
> >+void dm_verity_loadpin_set_trusted_root_digests(struct list_head *digests)
> >+{
> >+	if (!trusted_root_digests)
> >+		trusted_root_digests = digests;
> >+	else
> >+		pr_warn("verity root digests trusted by LoadPin are already set!!!\n");
> >+}
> >+
> >+static bool is_trusted_verity_target(struct dm_target *ti)
> >+{
> >+	u8 *root_digest;
> >+	unsigned int digest_size;
> >+	struct trusted_root_digest *trd;
> >+	bool trusted = false;
> >+
> >+	if (!dm_is_verity_target(ti))
> >+		return false;
> >+
> >+	if (dm_verity_get_root_digest(ti, &root_digest, &digest_size))
> >+		return false;
> >+
> >+	list_for_each_entry(trd, trusted_root_digests, node) {
> >+		if ((trd->len == digest_size) &&
> >+		    !memcmp(trd->data, root_digest, digest_size)) {
> >+			trusted = true;
> >+			break;
> >+		}
> >+	}
> >+
> >+	kfree(root_digest);
> >+
> >+	return trusted;
> >+}
> >+
> >+/*
> >+ * Determines whether a mapped device is a verity device that is trusted
> >+ * by LoadPin.
> >+ */
> >+bool dm_verity_loadpin_is_md_trusted(struct mapped_device *md)
> >+{
> >+	int srcu_idx;
> >+	struct dm_table *table;
> >+	unsigned int num_targets;
> >+	bool trusted = false;
> >+	int i;
> >+
> >+	if (!trusted_root_digests || list_empty(trusted_root_digests))
> >+		return false;
> >+
> >+	table = dm_get_live_table(md, &srcu_idx);
> >+	num_targets = dm_table_get_num_targets(table);
> >+	for (i = 0; i < num_targets; i++) {
> >+		struct dm_target *ti = dm_table_get_target(table, i);
> >+
> >+		if (is_trusted_verity_target(ti)) {
> >+			trusted = true;
> >+			break;
> >+		}
> >+	}
> 
> Pardon my lack of dm vocabulary, but what is "target" vs "table" here?
> I was only thinking of "whole device", so I must not understand what this is
> examining.

'targets' are different types of DM mappings like 'linear' or 'verity'. A
device mapper table contains has one or more targets that define the mapping
of the blocks of the mapped device.

Having spelled that out I realize that the above check is wrong. It would
consider a device like this trusted:

0 10000000 linear 8:1
10000000 10001000 verity <params>

In the above case only a small part of the DM device would be backed by verity.

I think we want a table with a single entry that is a verity target.

> > [...]
> >diff --git a/include/linux/dm-verity-loadpin.h b/include/linux/dm-verity-loadpin.h
> >new file mode 100644
> >index 000000000000..12a86911d05a
> >--- /dev/null
> >+++ b/include/linux/dm-verity-loadpin.h
> >@@ -0,0 +1,27 @@
> >+/* SPDX-License-Identifier: GPL-2.0 */
> >+
> >+#ifndef __LINUX_DM_VERITY_LOADPIN_H
> >+#define __LINUX_DM_VERITY_LOADPIN_H
> >+
> >+#include <linux/list.h>
> >+
> >+struct mapped_device;
> >+
> >+struct trusted_root_digest {
> >+	u8 *data;
> >+	unsigned int len;
> >+	struct list_head node;
> >+};
> 
> To avoid the double-alloc in patch 2 (and save 1 pointer size of memory), this could just be:
> 
> struct trusted_root_digest {
> 	struct list_head node;
> 	unsigned int len;
> 	u8 data[];
> };

Looks good to me, will change

> Otherwise, looks good to me!

Excellent, thanks for the review!

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

