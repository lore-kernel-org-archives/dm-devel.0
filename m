Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D95AAC636CC
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319286;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=JF/oevHl5yNEzncKsAdZtucr75S7nAwp+Hkh5ez6US8=;
	b=RVF+4WUZVgFIkCZxr2KwWj0mlPu93ymTH/wQFvlTCtOifNR4vhgq/Xsiu6FDrCzyc6jQww
	lwxOGt9m75XeNXXptBNSPJLw1Ex4PGHdWNOjMuaV23+V16RYiBd4Ap7+AMbHuduUT91pZh
	qBns7UNaVWAPVxThwGnsjw5LXnqRwvg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-La_ozadIPBuTFMocntd17g-1; Mon, 13 Feb 2023 15:14:42 -0500
X-MC-Unique: La_ozadIPBuTFMocntd17g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB0F61C04334;
	Mon, 13 Feb 2023 20:14:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BA394492B03;
	Mon, 13 Feb 2023 20:14:40 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AB4221946588;
	Mon, 13 Feb 2023 20:14:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 991BA1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7D6B12166B29; Mon, 13 Feb 2023 20:14:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 76D652166B26
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 580AA101A52E
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:39 +0000 (UTC)
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com
 [209.85.219.43]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-665-rsLry4HcP4Gp-7WKKU5ZUQ-1; Mon, 13 Feb 2023 15:14:37 -0500
X-MC-Unique: rsLry4HcP4Gp-7WKKU5ZUQ-1
Received: by mail-qv1-f43.google.com with SMTP id y2so3527880qvo.4
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=jKakQIrUjTz+9bul3wsVtqiRTzfNhbILLQuDj9ooD8U=;
 b=EXegUcWlb87jyZcItQPIVTM5UbJ3rrrkPgdl99YP3xHH9k9OD/EVOKhllRcpWtHVk0
 1JFKaHuV0O9Lw4J7x2hye98n8BuHAFT/u3E1pq46EzT3y5wqYL85d1B1oNV2+qdmDfPl
 +kZoibifgbt7IUukkWCCfZ90UnvbtO2CfuKthWRZ29HIAqc2itjdNbCJSg5ZQ+E8o1tq
 k8/p2iXVQlLSV0NgTic2wPm3VYOsq5Qrgzg24VEyClDa+1Z0km0Vq6t7v6YLcUBzLCwP
 7/Aji1/TSWsor9Q8yhJYlcfL4S1RvmM5jJIRN10Gm29K322ahDaZEAq2UAtXwIVhSBUh
 crtg==
X-Gm-Message-State: AO0yUKWW9hcv5AEBNZcYyzesycN3u1KZquKatdK2DA7UTHkQ6XvqgTpe
 xG6UJP1Azth9cnMBV2BwuCdGNDrC/cYYleNbj121ObZblTpFRgVzVbsXgr2LNkwKw2DkCvKRp0F
 Kg44bCP2DwWdQHgDyGUsdxGYpISmUK7lpJxns8+PXLWsnxrXTn0hNsZgRqn8KLfcN5YXwKQ==
X-Google-Smtp-Source: AK7set8SQzCQBJXxXhrEo83Oc3xGMQw9N+0sdJgQy+t+NTmsHgY1sD5tSLcd2nBdPNboaDXA6cAcHg==
X-Received: by 2002:a05:6214:2244:b0:56e:a290:aa92 with SMTP id
 c4-20020a056214224400b0056ea290aa92mr489442qvc.9.1676319277034; 
 Mon, 13 Feb 2023 12:14:37 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 s184-20020ae9dec1000000b0073b38652b9csm3417854qkf.122.2023.02.13.12.14.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:36 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:28 -0500
Message-Id: <20230213201401.45973-7-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 06/39] dm: enclose complex macros into
 parentheses where possible
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-log.c           | 6 ++++--
 include/linux/device-mapper.h | 3 +--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 955767de369b..3cd166d3a7a8 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -773,8 +773,10 @@ static region_t core_get_sync_count(struct dm_dirty_log *log)
 }
 
 #define	DMEMIT_SYNC \
-	if (lc->sync != DEFAULTSYNC) \
-		DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : "")
+	do { \
+		if (lc->sync != DEFAULTSYNC) \
+			DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : ""); \
+	} while (0);
 
 static int core_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 4dab671922e5..f43b372e27a0 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -613,8 +613,7 @@ void dm_destroy_crypto_profile(struct blk_crypto_profile *profile);
 #define DMDEBUG(fmt, ...) pr_debug(DM_FMT(fmt), ##__VA_ARGS__)
 #define DMDEBUG_LIMIT(fmt, ...) pr_debug_ratelimited(DM_FMT(fmt), ##__VA_ARGS__)
 
-#define DMEMIT(x...) sz += ((sz >= maxlen) ? \
-			  0 : scnprintf(result + sz, maxlen - sz, x))
+#define DMEMIT(x...) (sz += ((sz >= maxlen) ? 0 : scnprintf(result + sz, maxlen - sz, x)))
 
 #define DMEMIT_TARGET_NAME_VERSION(y) \
 		DMEMIT("target_name=%s,target_version=%u.%u.%u", \
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

