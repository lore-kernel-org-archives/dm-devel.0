Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 314F7C761A6
	for <dm-devel@archiver.kernel.org>; Mon, 27 Mar 2023 20:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679948040;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6XusNNgPye6YWNO8uR7HXXGvCeN2EUngVHyjX/W7QXA=;
	b=iLhfy+u/DOngXKN57wkFTSSrJ6y2mNyXFm1rwIYT0yolcl/hp4od0SsPBHItOAexnJfF33
	FAKE8TAejEsE0lyeE8OvHUZ57phtxefKvtZGvQgkDptXf5ux6LBFvFWnj7o13tiQpYBRjQ
	Kz+Dbu4LSxe81qZTVFAJSaNqwvHQK5Y=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-dqRQrk--MtaovBndaWL80A-1; Mon, 27 Mar 2023 16:13:58 -0400
X-MC-Unique: dqRQrk--MtaovBndaWL80A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 718942812951;
	Mon, 27 Mar 2023 20:13:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5F5CC492C3E;
	Mon, 27 Mar 2023 20:13:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1ED1619452CF;
	Mon, 27 Mar 2023 20:13:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3694619472D5
 for <dm-devel@listman.corp.redhat.com>; Mon, 27 Mar 2023 20:13:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 21A9C1121331; Mon, 27 Mar 2023 20:13:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A5761121330
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECC243C0ED4F
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 20:13:28 +0000 (UTC)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com
 [209.85.219.47]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-cQpnMlLhPwOgTOgilaooFg-2; Mon, 27 Mar 2023 16:13:27 -0400
X-MC-Unique: cQpnMlLhPwOgTOgilaooFg-2
Received: by mail-qv1-f47.google.com with SMTP id l7so7669605qvh.5
 for <dm-devel@redhat.com>; Mon, 27 Mar 2023 13:13:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112; t=1679948007;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=7GATmDpp2LqxaO3YBsTr83VB1ZcPRtnkKD4xtYp0nm8=;
 b=q3L0aP9jtX1FT3DRNXs1HPSVwoP+Z98mmzhaip58dzSnlJvbbnV+6zqRlb02n3jFji
 sbAxacvtdZ+H6f9/o4szq0KeUlEOsr6wPjcH2muFilWs0hJ0rrnl8CVochDDEsSDXh0q
 wAdO2ywValMtAFRGIzdBka0oPR/r4OgSvwQSYcscGx4wAgcf4c3yRWZSZhWUFRYH8H1j
 MOcuEcA2VEK5V5YrwIfkQ0voWLQLX1JFxfw6B+6MVwjHmAgEhOavhKM3klYWB9fNzr1d
 s50H6z00G7BlHKzqM8nihRchKOBGrbWNEEng3ZTa3DAxA4qMHjAJ4AeGuquJ/aT4UD13
 ozXw==
X-Gm-Message-State: AAQBX9fzhmZ9WJ5kfEIgSRy2tx4KYuiFO5znrn7B7CUPHX0e11ll5edq
 CLjMR0Q6f+8J+lCatOZ82efOY0k9l/Mji/+7191N5owOMIanYuNaNigsaEJnuitDZ/JQdvqIMFT
 O6qwHBEiLgWbzgqR4yLY3Cmvrpp+NunptBSpNA+ZQrg+BUPXzLo5f78Wmqlo8kQJchUdt+6D2Gr
 g=
X-Google-Smtp-Source: AKy350ZI9rUbEEtVYKNa1rqSBi0yYegoZt54hv+kbNekJScyZbdA+0A6vj49+yGatxgvJEDQcYubbw==
X-Received: by 2002:ad4:5bc7:0:b0:5b8:d0b5:9a46 with SMTP id
 t7-20020ad45bc7000000b005b8d0b59a46mr20840019qvt.37.1679948006778; 
 Mon, 27 Mar 2023 13:13:26 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 jy3-20020a0562142b4300b005dd8b934595sm3228566qvb.45.2023.03.27.13.13.26
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 27 Mar 2023 13:13:26 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 27 Mar 2023 16:11:35 -0400
Message-Id: <20230327201143.51026-13-snitzer@kernel.org>
In-Reply-To: <20230327201143.51026-1-snitzer@kernel.org>
References: <20230327201143.51026-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [dm-6.4 PATCH v3 12/20] dm thin: speed up
 cell_defer_no_holder()
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

From: Joe Thornber <ejt@redhat.com>

Reduce the time that a spinlock is held in cell_defer_no_holder().

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-thin.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 13d4677baafd..00323428919e 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -883,15 +883,17 @@ static void cell_defer_no_holder(struct thin_c *tc, struct dm_bio_prison_cell *c
 {
 	struct pool *pool = tc->pool;
 	unsigned long flags;
-	int has_work;
+	struct bio_list bios;
 
-	spin_lock_irqsave(&tc->lock, flags);
-	cell_release_no_holder(pool, cell, &tc->deferred_bio_list);
-	has_work = !bio_list_empty(&tc->deferred_bio_list);
-	spin_unlock_irqrestore(&tc->lock, flags);
+	bio_list_init(&bios);
+	cell_release_no_holder(pool, cell, &bios);
 
-	if (has_work)
+	if (!bio_list_empty(&bios)) {
+		spin_lock_irqsave(&tc->lock, flags);
+		bio_list_merge(&tc->deferred_bio_list, &bios);
+		spin_unlock_irqrestore(&tc->lock, flags);
 		wake_worker(pool);
+	}
 }
 
 static void thin_defer_bio(struct thin_c *tc, struct bio *bio);
-- 
2.40.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

