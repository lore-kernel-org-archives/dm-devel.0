Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 590CDC677F1
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319339;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eu+jxrIHRaLtTesyTUtUA/fE/YawEDefQFA75NMJmtA=;
	b=VLLtpBpzB+ffGNmd42s+zG5UIoFK8eaLCJwf8bi9tW6qnL1HmaCrUrASlXGqUjqy6GEBvF
	USZAXZqYzGwN09pjshGiR9egv4nE9k6qYCTpILXggbZZRPd3lAdQN7dQgNeE8oYkczT5FF
	WuxqjunqFg7vc8zQt0IdzA3Qw1zCTdI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-15-wmPOpibXO0yRw3-kzhzZnQ-1; Mon, 13 Feb 2023 15:15:36 -0500
X-MC-Unique: wmPOpibXO0yRw3-kzhzZnQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32FBF882824;
	Mon, 13 Feb 2023 20:15:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 22946403D0C1;
	Mon, 13 Feb 2023 20:15:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id DB502194658F;
	Mon, 13 Feb 2023 20:15:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E22EE194658F
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D7BE7403D0C5; Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF6A1403D0C1
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B5A43971080
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:29 +0000 (UTC)
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com
 [209.85.219.50]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-418-8C4K0gwwOe-pAj-fzsXkyg-4; Mon, 13 Feb 2023 15:15:26 -0500
X-MC-Unique: 8C4K0gwwOe-pAj-fzsXkyg-4
Received: by mail-qv1-f50.google.com with SMTP id d13so9096035qvj.8
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=NFxag3SEefvUhMFuBzoUHG5D8fHhva8pt1Y0JcXJaj4=;
 b=YhMvFfu5fXFQzc7McJBTXkKbxopi4uOkqevmbb7I9K0gSvfDggR9u/iXAaggXlMOye
 DtuXoSjWce8BIs6G7qOgg/DLJWhD+5RX5a3Ot94qfjUlieueefmID8v3j9uHOVNcPeOq
 ONwRDPa3HhxNGPq93WBNyjU0Ia0tsQOrJ+Eogj6PXhPP33SOfz24/nEfKZb1rjJtOVlt
 LW/dOiWYKnrmiDbS2wfDkeFjxwhg4b7w6YuP0F5e1KjpZ3Wz5DulZGwSBA8mMMk3nhUi
 5N8vluZ5RU3Y6s3BsWHUUcOrsqWlvwDWQuXSm+MjpYtA0oHnSKCMBjGY6TVCJDbcfjfW
 xuFA==
X-Gm-Message-State: AO0yUKXGBxdO5EJz+MvPMwlPczCSB8Q2OkKrXI4G8dc9rItvEJguzv0B
 m4XkyfORxb+HP45KnygtouIPyg/huX3kPeELld7QfOqdPpDuTNBsKJ/nM6Zb+0x7qaF8XuGiU4N
 TUJgERduvRXsmc8TpQO/hoczgGGfZ2oBPVrVRzFSdHbhQHZme1YUH64oNKH6NsiIp9X1v/g==
X-Google-Smtp-Source: AK7set9VNO5tGxVkjKGcpkUT6BO7m5Hrprgzay0AAwZWF6OshCbLjuDiAh8SKtI694PrFvA5+2XBGQ==
X-Received: by 2002:ad4:5dc6:0:b0:56c:27b0:ed05 with SMTP id
 m6-20020ad45dc6000000b0056c27b0ed05mr214921qvh.45.1676319325532; 
 Mon, 13 Feb 2023 12:15:25 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 23-20020a370417000000b006ef1a8f1b81sm10407525qke.5.2023.02.13.12.15.24
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:25 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:57 -0500
Message-Id: <20230213201401.45973-36-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH 35/39] dm: avoid void function return statements
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-io-rewind.c          | 2 --
 drivers/md/dm-log-userspace-base.c | 8 --------
 drivers/md/dm-zoned-target.c       | 1 -
 3 files changed, 11 deletions(-)

diff --git a/drivers/md/dm-io-rewind.c b/drivers/md/dm-io-rewind.c
index efd76412262a..7766a1c94762 100644
--- a/drivers/md/dm-io-rewind.c
+++ b/drivers/md/dm-io-rewind.c
@@ -68,7 +68,6 @@ static void dm_bio_integrity_rewind(struct bio *bio, unsigned int bytes_done)
 static inline void dm_bio_integrity_rewind(struct bio *bio,
 					   unsigned int bytes_done)
 {
-	return;
 }
 
 #endif
@@ -104,7 +103,6 @@ static void dm_bio_crypt_rewind(struct bio *bio, unsigned int bytes)
 
 static inline void dm_bio_crypt_rewind(struct bio *bio, unsigned int bytes)
 {
-	return;
 }
 
 #endif
diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index d96a9651a462..5551bbc23cdb 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -346,8 +346,6 @@ static void userspace_dtr(struct dm_dirty_log *log)
 
 	kfree(lc->usr_argv_str);
 	kfree(lc);
-
-	return;
 }
 
 static int userspace_presuspend(struct dm_dirty_log *log)
@@ -661,8 +659,6 @@ static void userspace_mark_region(struct dm_dirty_log *log, region_t region)
 	fe->region = region;
 	list_add(&fe->list, &lc->mark_list);
 	spin_unlock_irqrestore(&lc->flush_lock, flags);
-
-	return;
 }
 
 /*
@@ -698,8 +694,6 @@ static void userspace_clear_region(struct dm_dirty_log *log, region_t region)
 	fe->region = region;
 	list_add(&fe->list, &lc->clear_list);
 	spin_unlock_irqrestore(&lc->flush_lock, flags);
-
-	return;
 }
 
 /*
@@ -756,7 +750,6 @@ static void userspace_set_region_sync(struct dm_dirty_log *log,
 	 * It would be nice to be able to report failures.
 	 * However, it is easy enough to detect and resolve.
 	 */
-	return;
 }
 
 /*
@@ -927,7 +920,6 @@ static void __exit userspace_dirty_log_exit(void)
 	kmem_cache_destroy(_flush_entry_cache);
 
 	DMINFO("version " DM_LOG_USERSPACE_VSN " unloaded");
-	return;
 }
 
 module_init(userspace_dirty_log_init);
diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
index 95b132b52f33..ad4764dcd013 100644
--- a/drivers/md/dm-zoned-target.c
+++ b/drivers/md/dm-zoned-target.c
@@ -1119,7 +1119,6 @@ static void dmz_status(struct dm_target *ti, status_type_t type,
 		*result = '\0';
 		break;
 	}
-	return;
 }
 
 static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

