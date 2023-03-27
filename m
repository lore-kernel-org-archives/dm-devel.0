Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42E91C76195
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948009;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Vo2n6IYkcNWod7UIv1TMZL+ybABjNugsy8vVkb1XQSc=;
	b=QnDDL05+7vOOQEXlfWbeUG1zBjoOE9nd5QlA1WlKLAje4FU86GgKXVamN6dtG5p87YmLvC
	bWSVQpPN63raRFM1MR/prrv/rtXTp0q+eZRy0bHSVus8HhI7SqblBgkY0S7Djay1RlMghn
	3oPMSYjITuBy8vBhkG9L0YbLqpc0IP8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-491-DQ1owt3MNT-RstgrByxKBg-1; Mon, 27 Mar 2023 16:13:26 -0400
X-MC-Unique: DQ1owt3MNT-RstgrByxKBg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87BE5857A89;
	Mon, 27 Mar 2023 20:13:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 763E5492C3E;
	Mon, 27 Mar 2023 20:13:23 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 60CAC1946A7D;
	Mon, 27 Mar 2023 20:13:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1D6B519465A2
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 18E7C2027045; Mon, 27 Mar 2023 20:13:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1100C2027044
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E66961C05EC6
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:13 +0000 (UTC)
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com
 [209.85.219.48]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-86-d_IvLALbMTC40SUY2m_tgw-1; Mon, 27 Mar 2023 16:13:11 -0400
X-MC-Unique: d_IvLALbMTC40SUY2m_tgw-1
Received: by mail-qv1-f48.google.com with SMTP id oe8so7649283qvb.6
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679947990;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=K6rad/3rQ5uNwjgAbrRZn8viSEaiHhaJsk57wekX4Yc=;
 b=QZyYFFwiIZT38Z79owdgWVAQF8OMGsSjNNBvDoAEfkQ+QP+LJQb97LAKovUYfMLsVQ
 bVE7xtCMPHI3AWgnWUJnYZJmFyecbIxkRWMs8sVG4JwpDdVnlY/Avh3xBr04ruwPSQv1
 6k7funwi4hNURcs9F2qq/3PFX+hxcjpP2cqGqIwOvEdHf3S/UFKKVIJcNe7IbhECXCLL
 25pUaW94FEsnalaFC34WYvcjLAlA6YCjkhNIA4MHuuteJDFKs8AhNxf5lRKv+6CltZrs
 r//DZ6rJbVXpnaGqTBfb1hAsg/TYMk8jcbMzO1/EA5n8xm+YTMJ0SofXGfEy/8kRftEz
 PtEw==
X-Gm-Message-State: AAQBX9fPII6a5T+xUZt5fBnLvZ+2M3G5qv2aBfh2QcSY4m+OKU4xhU1v
 UbXpK/2PwuFmqul9S6NrJLPFRdAMNJuyEK+Er4YzgxWmu15FZh1wGpeE+Cd7bBPMG/7RV0zX/ig
 VtUM/XR3sA1tuN07//KomZQYEnrKCVjVSqzVgRXAeuyAToZr/mcsEgYvhUpkeqTp8VNZJc2Nlpb
 A=
X-Google-Smtp-Source: AKy350aGPv+m7+Nvtksg720HQ297PPqoxtEn/b3IGQEXHEExxXsRvNIRRAb6T0t3WIyj8iHk9azUFg==
X-Received: by 2002:a05:6214:b64:b0:5b8:1f61:a20 with SMTP id
 ey4-20020a0562140b6400b005b81f610a20mr25404563qvb.35.1679947989792; 
 Mon, 27 Mar 2023 13:13:09 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 f16-20020ac86ed0000000b003e390b48958sm4723408qtv.55.2023.03.27.13.13.09
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:09 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:25 -0400
Message-Id: <20230327201143.51026-3-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [dm-6.4 PATCH v3 02/20] dm bufio: use WARN_ON in
 dm_bufio_client_destroy and dm_bufio_exit
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Using BUG_ON when tearing down is excessive. Relax these to WARN_ONs.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-bufio.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 79434b38f368..dac9f1f84c34 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -1828,8 +1828,8 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 
 	mutex_unlock(&dm_bufio_clients_lock);
 
-	BUG_ON(!RB_EMPTY_ROOT(&c->buffer_tree));
-	BUG_ON(c->need_reserved_buffers);
+	WARN_ON(!RB_EMPTY_ROOT(&c->buffer_tree));
+	WARN_ON(c->need_reserved_buffers);
 
 	while (!list_empty(&c->reserved_buffers)) {
 		struct dm_buffer *b = list_entry(c->reserved_buffers.next,
@@ -1843,7 +1843,7 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 			DMERR("leaked buffer count %d: %ld", i, c->n_buffers[i]);
 
 	for (i = 0; i < LIST_SIZE; i++)
-		BUG_ON(c->n_buffers[i]);
+		WARN_ON(c->n_buffers[i]);
 
 	kmem_cache_destroy(c->slab_cache);
 	kmem_cache_destroy(c->slab_buffer);
@@ -2082,7 +2082,7 @@ static void __exit dm_bufio_exit(void)
 		bug = 1;
 	}
 
-	BUG_ON(bug);
+	WARN_ON(bug); /* leaks are not worth crashing the system */
 }
 
 module_init(dm_bufio_init)
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

