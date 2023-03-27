Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE4FAC76195
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948063;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RnW4yMGw8sW4/Lp8VW6SGPGhyjX8Ev3H+VB0V7MwpV0=;
	b=HdJHfHl0hsvPp16ppPSuKr6k9bTNBDR048XhMxANnBRM3dgU+OQa2rcrIqX/hFD+ZmO2RG
	sdlhA5ushyeoP8g4Z1MDXGc7iEjJABWN7JuAtkG36jVynRcsueuK2Vwo7c0Iqv2YXNApM7
	kTAmbteSKC/BOsjoR2Yyjr6uFVGFgJw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-duaa1k-sPzSJSlgDwJfboA-1; Mon, 27 Mar 2023 16:14:19 -0400
X-MC-Unique: duaa1k-sPzSJSlgDwJfboA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D195B802D32;
	Mon, 27 Mar 2023 20:14:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C05A94020C82;
	Mon, 27 Mar 2023 20:14:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 34C6419472D9;
	Mon, 27 Mar 2023 20:13:56 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 343AC19465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1AF32492B0B; Mon, 27 Mar 2023 20:13:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1322B492B0A
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA187801779
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:38 +0000 (UTC)
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com
 [209.85.160.179]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-304-Y1vkodrEM3udqoCnSA8-Ug-6; Mon, 27 Mar 2023 16:13:37 -0400
X-MC-Unique: Y1vkodrEM3udqoCnSA8-Ug-6
Received: by mail-qt1-f179.google.com with SMTP id hf2so9812071qtb.3
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948017;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=PwFipSc82OIEFDU8Id4luDtLttcFOJWrHTnvxSKayKA=;
 b=lfPjobkaeanbc+RQlePNusm+q44f0e3qZhvcW1NkZawvAzJ1taE/1oC/nuL2vxhBhx
 SiU4VkrFOo+P9I68VjvyQX2FnJc0QRI/Rm831gSXbfWIV6a7I5U2n9rQHfjwEkgWIOEM
 dbk2SR6bU7dKdn5sz2gdwJ8pDAt3uye2Unrn559/+sibMUFyBBTmLBlSEAuDnMGrsHVn
 Yp2mgk8X5S2gpP8W78Ke/nlqIICPz7tH4fK2UjQ9thvgNgN7pPc+Xgxg4wBZFkxtAg1j
 5Jyrcwr17M7xEkQ5Teccn3nX4Oe6gTX9cNRM2l0+yG6xtMDcQumVpyRsmAgoDWbW3atS
 mVzA==
X-Gm-Message-State: AO0yUKWWWTOCEXE11o6SetIONEEkeb7iLXlAU6bgsbjyxYDzeWg2/7Dj
 GW16hnF0Z7ravp3jJ7T2lKMRyvS+TRvOkQhg9PFb1FrEMUBuqBJ8Wljh2G+bjfDPGjlBVE6r4c6
 P10BVV7tlFJA2qkuOSsrhicojVH1r/bmkiUR/UddBJaVY5JQTvfKQGRH7pLaGNrl/A2FglmzTfG
 I=
X-Google-Smtp-Source: AK7set/FmDxDs4w1j0e5PA+jX3MwJRj6+AOGAADIBIksQBRZljk9BW4Q1CQMIOVrgNxvcG4up41zZQ==
X-Received: by 2002:a05:622a:c6:b0:3b6:2c3b:8c00 with SMTP id
 p6-20020a05622a00c600b003b62c3b8c00mr23270455qtw.66.1679948016921; 
 Mon, 27 Mar 2023 13:13:36 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 f8-20020a05620a280800b0074269db4699sm10226828qkp.46.2023.03.27.13.13.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:36 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:41 -0400
Message-Id: <20230327201143.51026-19-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [dm-6.4 PATCH v3 18/20] dm bufio: intelligently size
 dm_buffer_cache's buffer_trees
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
Cc: axboe@kernel.dk, ebiggers@kernel.org, keescook@chromium.org,
 heinzm@redhat.com, Mike Snitzer <snitzer@kernel.org>, nhuck@google.com,
 linux-block@vger.kernel.org, ejt@redhat.com, mpatocka@redhat.com,
 luomeng12@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Size the dm_buffer_cache's number of buffer_tree structs using
dm_num_sharded_locks().

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 2250799a70e4..7dc53f3d0739 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -21,6 +21,8 @@
 #include <linux/stacktrace.h>
 #include <linux/jump_label.h>
 
+#include "dm.h"
+
 #define DM_MSG_PREFIX "bufio"
 
 /*
@@ -379,8 +381,6 @@ struct dm_buffer {
  * only enough to ensure get/put are threadsafe.
  */
 
-#define NR_LOCKS 64
-
 struct buffer_tree {
 	struct rw_semaphore lock;
 	struct rb_root root;
@@ -393,7 +393,7 @@ struct dm_buffer_cache {
 	 * on the locks.
 	 */
 	unsigned int num_locks;
-	struct buffer_tree trees[NR_LOCKS];
+	struct buffer_tree trees[];
 };
 
 static inline unsigned int cache_index(sector_t block, unsigned int num_locks)
@@ -976,7 +976,7 @@ struct dm_bufio_client {
 	 */
 	unsigned long oldest_buffer;
 
-	struct dm_buffer_cache cache;
+	struct dm_buffer_cache cache; /* must be last member */
 };
 
 static DEFINE_STATIC_KEY_FALSE(no_sleep_enabled);
@@ -2422,6 +2422,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 					       unsigned int flags)
 {
 	int r;
+	unsigned int num_locks;
 	struct dm_bufio_client *c;
 	char slab_name[27];
 
@@ -2431,12 +2432,13 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 		goto bad_client;
 	}
 
-	c = kzalloc(sizeof(*c), GFP_KERNEL);
+	num_locks = dm_num_sharded_locks();
+	c = kzalloc(sizeof(*c) + (num_locks * sizeof(struct buffer_tree)), GFP_KERNEL);
 	if (!c) {
 		r = -ENOMEM;
 		goto bad_client;
 	}
-	cache_init(&c->cache, NR_LOCKS);
+	cache_init(&c->cache, num_locks);
 
 	c->bdev = bdev;
 	c->block_size = block_size;
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

