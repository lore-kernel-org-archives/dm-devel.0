Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFFE2C6FD1D
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948019;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sPcaQg8F3elM/1El78HJT+eq7P4p99wIV/kYQ9Aef/0=;
	b=d1BcgjuUAn2B4TwjyGjX212lojh+8JKoUnLlzvvHporvsGy18iucwNNyZ+P9xDUfqp/Ant
	RviJsobDoyuA7Ua/Jxw/ZrlhJOPEim/gWs43B8t4ocKXqCsd35FCuD2YX2tZdmyKzTAVAb
	ulRu1dHvSyj6jaBPgpPRQWxxh/GZqJQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-303-bMeGmFCdOIqG7bBqrZ-RJQ-1; Mon, 27 Mar 2023 16:13:38 -0400
X-MC-Unique: bMeGmFCdOIqG7bBqrZ-RJQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C50078828C3;
	Mon, 27 Mar 2023 20:13:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B2CDF202701E;
	Mon, 27 Mar 2023 20:13:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8F2C81946A5A;
	Mon, 27 Mar 2023 20:13:22 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C0EEA194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A535C492B01; Mon, 27 Mar 2023 20:13:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DEAE492B03
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 83CD81C05EBF
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:15 +0000 (UTC)
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com
 [209.85.219.42]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-a4NpGVsUNfOr0iZTT4Rzbg-1; Mon, 27 Mar 2023 16:13:12 -0400
X-MC-Unique: a4NpGVsUNfOr0iZTT4Rzbg-1
Received: by mail-qv1-f42.google.com with SMTP id x8so7617869qvr.9
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679947991;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=38Sgxe5/q+hJ0JKVFdOX1S2/H0qUacEb3wrSiTwviHY=;
 b=A00nOqtpRbgmE2GWQgS6FX0rUpbjjcDT/sxtksuJRs1ALJrq/ZCLbslBVYVOmU/Q62
 IV9HlCZjEMkFNVef6ZlT6mNq7lJgAWsKevL6Di5FSTi9v1O5IAKNv1N2eIXA1jiafUlq
 2hdr1Lcw7MPVheMxZC7fUQhg8QGrdzJvgOI+xlISwOQvZiylbpq6y7azsxFCg3xu3hu1
 uixtBbNh6KodUjAo7rUXoNf5Nz6m23h0AlcIX1VpyajHXrCu3YbaXmutPXJQVl5rhV9c
 sWGTr3WKOy5OboGRnsQMd/O/0SL2F2gWxLhCF86UHvh8/q2CjozSGNIheK6fYa6562LL
 +1FQ==
X-Gm-Message-State: AAQBX9c6zimYCmc7X+kTskiGloR8lPz1gjq6Gg6BYYRKx4MLYGgFKD1G
 jZDQm7Vr255HAA9o8LHPWGEjRlISsSaVw1sgCEU33JnO0zUhSWcr9wmJivoJlMGUD1ccLxPL+do
 uyrRoTlGLy7C8uTu0GZbTOfzyopAaLbEWK/cqqr19lpGsDgVGbEuXOYBcwqplP5sxujdRNP9nid
 4=
X-Google-Smtp-Source: AKy350Z/SX3NEFg9tn3FY6AM6zZMl6uXUeBw6GhmbRlqi/g3goSm+tkfNNjvAC/CMiQFi0MxHMsbFw==
X-Received: by 2002:ad4:5d69:0:b0:5db:e06f:e0f9 with SMTP id
 fn9-20020ad45d69000000b005dbe06fe0f9mr19745867qvb.13.1679947991288; 
 Mon, 27 Mar 2023 13:13:11 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 a200-20020ae9e8d1000000b00747d211536dsm3327118qkg.107.2023.03.27.13.13.10
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:10 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:26 -0400
Message-Id: <20230327201143.51026-4-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [dm-6.4 PATCH v3 03/20] dm bufio: never crash if
 dm_bufio_in_request()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

All these instances are entirely avoidable given that they speak to
coding mistakes that result in inappropriate use. Proper testing during
development will catch any such coding bug so its best to relax all of
these from BUG_ON to WARN_ON_ONCE.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index dac9f1f84c34..d63f94ab1d9f 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1152,7 +1152,8 @@ EXPORT_SYMBOL_GPL(dm_bufio_get);
 void *dm_bufio_read(struct dm_bufio_client *c, sector_t block,
 		    struct dm_buffer **bp)
 {
-	BUG_ON(dm_bufio_in_request());
+	if (WARN_ON_ONCE(dm_bufio_in_request()))
+		return ERR_PTR(-EINVAL);
 
 	return new_read(c, block, NF_READ, bp);
 }
@@ -1161,7 +1162,8 @@ EXPORT_SYMBOL_GPL(dm_bufio_read);
 void *dm_bufio_new(struct dm_bufio_client *c, sector_t block,
 		   struct dm_buffer **bp)
 {
-	BUG_ON(dm_bufio_in_request());
+	if (WARN_ON_ONCE(dm_bufio_in_request()))
+		return ERR_PTR(-EINVAL);
 
 	return new_read(c, block, NF_FRESH, bp);
 }
@@ -1174,7 +1176,8 @@ void dm_bufio_prefetch(struct dm_bufio_client *c,
 
 	LIST_HEAD(write_list);
 
-	BUG_ON(dm_bufio_in_request());
+	if (WARN_ON_ONCE(dm_bufio_in_request()))
+		return; /* should never happen */
 
 	blk_start_plug(&plug);
 	dm_bufio_lock(c);
@@ -1281,7 +1284,8 @@ void dm_bufio_write_dirty_buffers_async(struct dm_bufio_client *c)
 {
 	LIST_HEAD(write_list);
 
-	BUG_ON(dm_bufio_in_request());
+	if (WARN_ON_ONCE(dm_bufio_in_request()))
+		return; /* should never happen */
 
 	dm_bufio_lock(c);
 	__write_dirty_buffers_async(c, 0, &write_list);
@@ -1386,7 +1390,8 @@ int dm_bufio_issue_flush(struct dm_bufio_client *c)
 		.count = 0,
 	};
 
-	BUG_ON(dm_bufio_in_request());
+	if (WARN_ON_ONCE(dm_bufio_in_request()))
+		return -EINVAL;
 
 	return dm_io(&io_req, 1, &io_reg, NULL);
 }
@@ -1409,7 +1414,8 @@ int dm_bufio_issue_discard(struct dm_bufio_client *c, sector_t block, sector_t c
 		.count = block_to_sector(c, count),
 	};
 
-	BUG_ON(dm_bufio_in_request());
+	if (WARN_ON_ONCE(dm_bufio_in_request()))
+		return -EINVAL; /* discards are optional */
 
 	return dm_io(&io_req, 1, &io_reg, NULL);
 }
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

