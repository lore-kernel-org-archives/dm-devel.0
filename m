Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4946EC04A68
	for <dm-devel@archiver.kernel.org>; Thu, 28 Jul 2022 15:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659023707;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=EoUjj5RymId2DLS2VTePP4lJ8+nzIG6AVw5j1+Yf9Ng=;
	b=Ihsk0JrKK9luL2HpHX74W35D9oS76WPkdOh2mUwl6oYnc5rh6MieDTwsDWkBaYllWr1O1I
	JR84EsN9n1sCQ+kpMRp7JiyJSzgojzXFmICoibHn4GSMGxfsJtDQ3oOcK1KVZi+ppw/Pdb
	nIaSxT/FO0e9tUd7QCTTXV7tBI/2N90=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-yxX-hzZLNFW3fRK9MDH3-A-1; Thu, 28 Jul 2022 11:55:03 -0400
X-MC-Unique: yxX-hzZLNFW3fRK9MDH3-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E85638173CD;
	Thu, 28 Jul 2022 15:55:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 03EAD90A04;
	Thu, 28 Jul 2022 15:54:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8107A1945DA7;
	Thu, 28 Jul 2022 15:54:51 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 55EE51945D85
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Jul 2022 15:54:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 32DB92026D64; Thu, 28 Jul 2022 15:54:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2ECB62026D07
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 15:54:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 11DF0800124
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 15:54:49 +0000 (UTC)
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com
 [209.85.215.169]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-08sBKJLBM46l4ddyUASIZg-1; Thu, 28 Jul 2022 11:54:47 -0400
X-MC-Unique: 08sBKJLBM46l4ddyUASIZg-1
Received: by mail-pg1-f169.google.com with SMTP id f11so1849849pgj.7
 for <dm-devel@redhat.com>; Thu, 28 Jul 2022 08:54:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=kU+1umJQF2o/NXaZ6DOn2fpiiayOd6S6bPdTx2dKd/k=;
 b=NSz7RuCDKHxwxzwJ2d6jaaXsJpUH8uM91CEVspr3UPEf5fEbaqg8vGLV91ds5lbHy4
 7ErWV5CG51dYswvmF0LePZa+6F7YJY75Tlpvs9LhJoCicfmQJ3+6gfRH0+rlirK/KilF
 MQGbVyex6ujlqMtwyupz8jKtYf1aX4767u+BRAa+38qGzmKuUYK599CksUTTOhreiK0C
 ZoGI7hJKFSvQ/q8yWio2S+eWWUj2NaBitI6gbds5wGYRWlFQFGFba8hNzG3aT43si3qR
 uIbCc9HVAZR3DrNVxMbgs2XGee1/oHA0c9ZoREHZGONt0eODeE4WA1SsjoTz5MyWL150
 kriA==
X-Gm-Message-State: AJIora/YebhZ82+FIqigZDcvVbpnHDwoapSxQEYdfyUGBQgWNqLCO2Vb
 D6ihAV/3A/BNTnSC8NPsIJ3/lQ==
X-Google-Smtp-Source: AGRyM1uEQZQL0BQQkR3RNvEAFIjhq7+7MXq8qU7ybWJ2B13O/5RNLqRZS5pTd/rmE0sG+MnN8+l1Xg==
X-Received: by 2002:a05:6a00:234c:b0:52b:7cb:ed9d with SMTP id
 j12-20020a056a00234c00b0052b07cbed9dmr27527599pfj.32.1659023686099; 
 Thu, 28 Jul 2022 08:54:46 -0700 (PDT)
Received: from localhost ([2620:15c:11a:202:bb10:e729:7f59:7cbc])
 by smtp.gmail.com with UTF8SMTPSA id
 i6-20020a626d06000000b0052c70770b24sm974115pfc.40.2022.07.28.08.54.45
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 28 Jul 2022 08:54:45 -0700 (PDT)
From: Matthias Kaehlcke <mka@chromium.org>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Kees Cook <keescook@chromium.org>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
Date: Thu, 28 Jul 2022 08:54:41 -0700
Message-Id: <20220728085412.1.I242d21b378410eb6f9897a3160efb56e5608c59d@changeid>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [PATCH] dm: verity-loadpin: Drop use of
 dm_table_get_num_targets()
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
 Stephen Rothwell <sfr@canb.auug.org.au>,
 Douglas Anderson <dianders@chromium.org>, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Matthias Kaehlcke <mka@chromium.org>, Milan Broz <gmazyland@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Commit 2aec377a2925 ("dm table: remove dm_table_get_num_targets()
wrapper") in linux-dm/for-next removed the function
dm_table_get_num_targets() which is used by verity-loadpin. Access
table->num_targets directly instead of using the defunct wrapper.

Fixes: b6c1c5745ccc ("dm: Add verity helpers for LoadPin")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
---

 drivers/md/dm-verity-loadpin.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-loadpin.c b/drivers/md/dm-verity-loadpin.c
index 10c18bc1652c..387ec43aef72 100644
--- a/drivers/md/dm-verity-loadpin.c
+++ b/drivers/md/dm-verity-loadpin.c
@@ -5,6 +5,7 @@
 #include <linux/dm-verity-loadpin.h>
 
 #include "dm.h"
+#include "dm-core.h"
 #include "dm-verity.h"
 
 #define DM_MSG_PREFIX	"verity-loadpin"
@@ -58,7 +59,7 @@ bool dm_verity_loadpin_is_bdev_trusted(struct block_device *bdev)
 
 	table = dm_get_live_table(md, &srcu_idx);
 
-	if (dm_table_get_num_targets(table) != 1)
+	if (table->num_targets != 1)
 		goto out;
 
 	ti = dm_table_get_target(table, 0);
-- 
2.37.1.455.g008518b4e5-goog

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

