Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8F4CC77B61
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948026;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+1Hsrztrs4GMdaYIKIj2ULkxaaI+CTD+Qh86Q7AfnVQ=;
	b=Fl+02pto18xNx9zRUt5PJS/GgIabqmO+hqZmiL2DgeSdFmeCtSndL1J7Mevo0A0guczFyF
	VBY1XsFTRKvrUyB6+Wq2Rjaswcui4YsGSUCR82CBwzwBKwioSla3lWPLImRdyApJtRy8PU
	Kda170FFdbfE5VvPozANDaTlbKlgv5g=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-f0-W3dFmMx671p2hNI55Xw-1; Mon, 27 Mar 2023 16:13:43 -0400
X-MC-Unique: f0-W3dFmMx671p2hNI55Xw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5A5D2812958;
	Mon, 27 Mar 2023 20:13:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A47AEC15BB8;
	Mon, 27 Mar 2023 20:13:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 62AB919465B2;
	Mon, 27 Mar 2023 20:13:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B867519465A4
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:25 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9DC6F4020C83; Mon, 27 Mar 2023 20:13:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 96B434020C82
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7CEB4100DEB1
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:25 +0000 (UTC)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com
 [209.85.160.182]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-628-Ac9qx-WFO7Cy_pJCMeh0Ag-3; Mon, 27 Mar 2023 16:13:24 -0400
X-MC-Unique: Ac9qx-WFO7Cy_pJCMeh0Ag-3
Received: by mail-qt1-f182.google.com with SMTP id ga7so9828563qtb.2
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948003;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=W8N6ipnCV5hoHhg/CORvER6nf9MSwcb0kouKMhOxJx4=;
 b=caD7cQJ42aUijsCXjwbxDRVpx8jl8eXNZCGipNlZOqsg3vPw1Wl4ZwVLOjpOPUgoI4
 QpgMcQTpQFdTUol5Svy3NziTTt4go4Zj2Vl8ShlRippiJ/iGrD/r5BQ6YcgmwCt270ZN
 Ur2rfXqGXaIfD2TsL5R9bkyLgsUs6q37IKPq35huPCHBuYtMZEIAG3pe2ob17gMWdLB2
 vjtRmyurK5q5PGjQqhn54zBcUK7+vSkSDoGtlZ8PhJe6h6U5Rax/aK4o+GzG0gd3fntr
 YHRzoX7BKhEMzysz4o4TtcU2zmCec80ftVb5OWtR1U9Vf42lQUWpOIu0DaztNiYRWO9k
 R1vA==
X-Gm-Message-State: AO0yUKUa8yOEzyKY2nknDvqXsQw+1rJook1gJhHXCbEVfzIixuYQGjkB
 O+ZvDCC0V7nadOyFXaelC6hDbbeY26pCYZf90s49YBQH8lp/MD+vBzS7Zy1OuE4kUxkwtPAlcp8
 +ZKByXJkj1qOXdNOxEDM86REsYIfRBgnGV1Y0ZsyOWYBMTajyPKwzBiFRy2Hh1G8gz8lz/IejAD
 g=
X-Google-Smtp-Source: AK7set9+sfwAJb0hRAS53hihYhDVSWnGpR49MCgCFLmIkZazfZgDsImOqvtZXurStI3emQaDQ0Dvkw==
X-Received: by 2002:a05:622a:1315:b0:3d5:500a:4819 with SMTP id
 v21-20020a05622a131500b003d5500a4819mr22550964qtk.23.1679948003245; 
 Mon, 27 Mar 2023 13:13:23 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 y126-20020a376484000000b007468765b411sm11876942qkb.45.2023.03.27.13.13.22
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:22 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:33 -0400
Message-Id: <20230327201143.51026-11-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [dm-6.4 PATCH v3 10/20] dm bufio: use waitqueue_active
 in __free_buffer_wake
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

From: Mikulas Patocka <mpatocka@redhat.com>

Save one spinlock by using waitqueue_active. We hold the bufio lock at
this place, so no one can add entries to the waitqueue at this point.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index e5459741335d..cca43ed13fd1 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1665,7 +1665,12 @@ static void __free_buffer_wake(struct dm_buffer *b)
 		c->need_reserved_buffers--;
 	}
 
-	wake_up(&c->free_buffer_wait);
+	/*
+	 * We hold the bufio lock here, so no one can add entries to the
+	 * wait queue anyway.
+	 */
+	if (unlikely(waitqueue_active(&c->free_buffer_wait)))
+		wake_up(&c->free_buffer_wait);
 }
 
 static enum evict_result cleaned(struct dm_buffer *b, void *context)
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

