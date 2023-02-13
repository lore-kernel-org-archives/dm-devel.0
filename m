Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB45AC64ED8
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319344;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=BFRwaGR2rEc0ADeF3VljrlKvbwrobQVxTFTGAO3PnaI=;
	b=KHU5yDrOsllCEqQOhaexiX/ioxiePisxJI1YIqXU9nDEdkVmMjKSsfmF+Ja2YesRwZyub5
	HF87/zshSfm22PxldC7j344eZ47lmcKHLJ4nPcVZL7KQSHYUNQBEHdT4aeXhDyf7ZnZ62s
	C5VJIftDe9SlHBQ3R5KrayXkDVfkYG0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-K_AkeduXPVuOSHw8wCwaog-1; Mon, 13 Feb 2023 15:15:41 -0500
X-MC-Unique: K_AkeduXPVuOSHw8wCwaog-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6340938149AD;
	Mon, 13 Feb 2023 20:15:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 53D0C492B15;
	Mon, 13 Feb 2023 20:15:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39458194658C;
	Mon, 13 Feb 2023 20:15:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B58B31946588
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:34 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9967D403D0C5; Mon, 13 Feb 2023 20:15:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9211E403D0C1
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:34 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 754AD857D07
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:34 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-498-eIOfiJqVOK6Hu8ldajFFyw-5; Mon, 13 Feb 2023 15:15:31 -0500
X-MC-Unique: eIOfiJqVOK6Hu8ldajFFyw-5
Received: by mail-qt1-f180.google.com with SMTP id m12so15200911qth.4
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=Bs9C5lK2AqLKRLIoJZiRnKWcFYtAjkL/pIAkehX9iWI=;
 b=4wp16pXKGSHAkBdBxWeVXO5vTY9eHmgvj8kPhbQpWP44YZyvDZLdfOe58RQ35QVjmI
 zfMSm2MQJqM37auUD44cy847wenFeFsFlPrEO4DYYKbsowTrsHZRU1lmp8LukVXRD5SV
 FZAbRX6HdzVBfUdVAhfKxvyT5xowpNO0PTOfEkrUa6w4m+FCep71szNgyVhxc5cYfV7H
 oJ7V0pm/pw9Xs9qvNRdN/8tAHLNe54X/52Dy74LJu+yTv5j9l42rKSEhizJz5u2ORqWz
 8HJ39QwWGSD0mvfMwcqpTJYcr978bb4yOGl8AZdQLEB6aY30j3EED/75xN9+bqakBTOO
 WycA==
X-Gm-Message-State: AO0yUKUEu9Ds05+9R13cGf87mDpJW8owUt1wsuFRpWg14tDc2qMgzV6t
 XOERH3XFrGYOuntjKOqdbcRHF/PboquWyDFE8Tpew1sQ8FDW0k5kXztLirRH/kU9TOkQMW7Wkda
 UUVz7D7Z9xJW3Ua4PLsfm4ZrdbQtlf33alSxuxsLV2/n+OX9udjxBktDp8Cm4JIppR78zsA==
X-Google-Smtp-Source: AK7set+Zac/kMdf01A2IvXIm+zYIdUOiGoPvrg5vAVZ0I1e+fwqPUd2Ej+Kqp42XobB85acfPoRSIw==
X-Received: by 2002:a05:622a:1911:b0:3b9:a3e3:4d33 with SMTP id
 w17-20020a05622a191100b003b9a3e34d33mr38060514qtc.12.1676319330432; 
 Mon, 13 Feb 2023 12:15:30 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 i25-20020ac871d9000000b003a527d29a41sm9622857qtp.75.2023.02.13.12.15.29
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:29 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:14:00 -0500
Message-Id: <20230213201401.45973-39-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 38/39] dm: declare variables static when sensible
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-cache-target.c | 2 +-
 drivers/md/dm-thin.c         | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 74ad5f27a257..0f16c922c440 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -859,7 +859,7 @@ static const char *cache_device_name(struct cache *cache)
 
 static void notify_mode_switch(struct cache *cache, enum cache_metadata_mode mode)
 {
-	const char *descs[] = {
+	static const char *descs[] = {
 		"write",
 		"read-only",
 		"fail"
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c8d3b20401f4..7fe05ee39ba3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -294,7 +294,7 @@ static enum pool_mode get_pool_mode(struct pool *pool)
 
 static void notify_of_pool_mode_change(struct pool *pool)
 {
-	const char *descs[] = {
+	static const char *descs[] = {
 		"write",
 		"out-of-data-space",
 		"read-only",
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

