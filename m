Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A06C3C76195
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948048;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=oXvtm1dG6O+nFjZGE46hHa880ZJ1dRJ/rbBvqQDk0Jw=;
	b=T9+vSAhsOUAoE77ENt4aeu2WXuySS4IhqqmO641+r8UGnyoVJOy2kZlcWf4UaqNyu5GVVJ
	mYFq4nwH3zTIDLukIub4eK5dYnWpJH3vYo+ZPRTo1/Vi9fTzHoAFg7fL45Yiyv/4h1HISh
	50EYQeNcraGI9Uu0NpEgVqIld5eIot4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-509-kvQ64tKTOp2mjOccezuFpw-1; Mon, 27 Mar 2023 16:14:07 -0400
X-MC-Unique: kvQ64tKTOp2mjOccezuFpw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3BFBA858297;
	Mon, 27 Mar 2023 20:14:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2A86CC15BA0;
	Mon, 27 Mar 2023 20:14:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1FBF719472E8;
	Mon, 27 Mar 2023 20:13:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CAF619465B5
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 510994020C82; Mon, 27 Mar 2023 20:13:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 49F804020C84
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C723185A7B3
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:42 +0000 (UTC)
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com
 [209.85.219.54]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-259-p56DykNbP_aNb8eScZGr6w-3; Mon, 27 Mar 2023 16:13:40 -0400
X-MC-Unique: p56DykNbP_aNb8eScZGr6w-3
Received: by mail-qv1-f54.google.com with SMTP id jl13so7609672qvb.10
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948020;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=mQyYjWMmcas91qVtcY8jvp2wBSEYoGBjkcnNGzLUcAg=;
 b=j44ccb8/XYEZrMqO0nZGUbN/Ta2sAveMC45WS5keOFwdWLagh4Ht/hZp8+RJUKwt+o
 eudAgTexbU5HuDxivIDL4JPJ07zYUWPjAAUhFMV439AwV2GFaHL3P8rGsPv5JG1TgIPn
 i89J+4M+/6Qvo+JyUdZey0WZkJFhCYe7oPG8FF2H9t6+oH0+UrV4EnvWq9V+BzwqGK7k
 AM+ihoAfFSTVPZvfsp85KyY6wWkCuGlw2NwIuLkijV25F3Ly04ctJxKsfZE/LuJ8yD/m
 cKL+gvmsYzSmquyAnLUzygLTuyr2rDFHyvg6/dl1Z/diOTBI2cZDmyXAQgXkzjVEXDfk
 rfRw==
X-Gm-Message-State: AAQBX9dOuVguOnPowkMEmRrgXDbXqRSutlXk+nFTN4hG28SifnrLzz/w
 zpTZGfNMf8pcxqgFkV4N8yRcdohjP13TW7aRs3/LXyKlxiw2GZRvseCtObKxP0njdb+mSsQbw4w
 8sjGYrEXdxJu2jeH/DRNa5PKfim3wFbBRd0uiYbqhZC3JTZJ97OOwYFUCjlBxyBfqgSWanxvHBW
 U=
X-Google-Smtp-Source: AKy350aUOhS5a7pfiFoOC/vCDrOmXamVaEKNC4KXqyNQGje3o8Ci+KX+zebywjT0o5kNzZBKf3poOw==
X-Received: by 2002:a05:6214:2aa6:b0:56c:376:3191 with SMTP id
 js6-20020a0562142aa600b0056c03763191mr21114410qvb.44.1679948019857; 
 Mon, 27 Mar 2023 13:13:39 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 a8-20020a0ce908000000b005dd8b9345a3sm3224293qvo.59.2023.03.27.13.13.39
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:39 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:43 -0400
Message-Id: <20230327201143.51026-21-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [dm-6.4 PATCH v3 20/20] dm bio prison v1: intelligently
 size dm_bio_prison's prison_regions
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Size the dm_bio_prison's number of prison_region structs using
dm_num_sharded_locks().

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bio-prison-v1.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-bio-prison-v1.c b/drivers/md/dm-bio-prison-v1.c
index a7930ad1878b..1d560a83b144 100644
--- a/drivers/md/dm-bio-prison-v1.c
+++ b/drivers/md/dm-bio-prison-v1.c
@@ -16,7 +16,6 @@
 
 /*----------------------------------------------------------------*/
 
-#define NR_LOCKS 64
 #define MIN_CELLS 1024
 
 struct prison_region {
@@ -27,7 +26,7 @@ struct prison_region {
 struct dm_bio_prison {
 	mempool_t cell_pool;
 	unsigned int num_locks;
-	struct prison_region regions[NR_LOCKS];
+	struct prison_region regions[];
 };
 
 static struct kmem_cache *_cell_cache;
@@ -41,12 +40,14 @@ static struct kmem_cache *_cell_cache;
 struct dm_bio_prison *dm_bio_prison_create(void)
 {
 	int ret;
-	unsigned i;
-	struct dm_bio_prison *prison = kzalloc(sizeof(*prison), GFP_KERNEL);
+	unsigned int i, num_locks;
+	struct dm_bio_prison *prison;
 
+	num_locks = dm_num_sharded_locks();
+	prison = kzalloc(struct_size(prison, regions, num_locks), GFP_KERNEL);
 	if (!prison)
 		return NULL;
-	prison->num_locks = NR_LOCKS;
+	prison->num_locks = num_locks;
 
 	for (i = 0; i < prison->num_locks; i++) {
 		spin_lock_init(&prison->regions[i].lock);
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

