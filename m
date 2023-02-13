Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64334C64ED6
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319288;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=QiHy2AmbLIJZEU17SaZA8IzsKMz/fTK1W/CKGEqW/LA=;
	b=UjNtCX4OA2BBhPVmFbxiTlUle7E6jb8Um5fMbhvPRGnIqhizi4T6yyyvkv0fdHXETCYS/H
	gBo4+mL7Nkmak5mwLwE+Nh5b89ExXOZsl1FSXbKkUUPP2ECglHQr+iqEPaqRvn4YCGdtIM
	+OFCtMvPz7lXNl50ZVumh64dcMSYDRc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-228-fhA14Xx5Om68uKz9WkG9yw-1; Mon, 13 Feb 2023 15:14:45 -0500
X-MC-Unique: fhA14Xx5Om68uKz9WkG9yw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F9E297108F;
	Mon, 13 Feb 2023 20:14:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E978492B04;
	Mon, 13 Feb 2023 20:14:43 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7C1B6194658F;
	Mon, 13 Feb 2023 20:14:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 09A261946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:14:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EDFE92026D68; Mon, 13 Feb 2023 20:14:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E5F9F2026D4B
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C69933815F61
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:14:41 +0000 (UTC)
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com
 [209.85.160.175]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-kAVNO0AzMTqYi-9Eto-9jQ-2; Mon, 13 Feb 2023 15:14:39 -0500
X-MC-Unique: kAVNO0AzMTqYi-9Eto-9jQ-2
Received: by mail-qt1-f175.google.com with SMTP id 5so15175679qtp.9
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:14:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=T7mG6EeiJlRN3ORTkIIeDEjHCTdjrUvx3WFaFx4kE8s=;
 b=U1RXDtE+uyur3zYEiUhhPdD6B71KmbWxhadW/crOuhV/sS46xqA3Z0hj9hcOf0oMgp
 A/TQYRTwYhbhR588MAez65YbhW938dyVDrPUmgyjFZgxvd94m+kvJf+RqcGTUCs28h/d
 z9aH5O13o3079cxim2e5G0B7MoUNNalWI7r8WNheHpFfEA+XoTB/N4tmsYwfOlZQU6nI
 KaVefJIhAcEF5XtJP1fPzOl63J7f9J4r4r5L8CRNDnOOlNJ+HkLgOu25uuOo6du5Xn19
 KQGzJF2G9P8LoAuncMKU0LFrtWv36zEqTnXVrjmfC8DkxN3EAVWhEiepLdOD4r2LezZY
 2OPQ==
X-Gm-Message-State: AO0yUKWBnj86D0mTKggD9UhTY7BcxpZvkJ+jcWShFq46ulVPnNFnHNjX
 GD9xOip54DuszwhPXHpmXnbSKEoOe/V2K++Ez1ggwFr9nf4lKa+VplzsnhXOTNE54vtKZG+tqJH
 wD+5gps/tOZMhskZrVwPYkIsNnxuGT2YnImEFfPBWCHNYLVziXNi6lr+SNR5LhQRo9uULDw==
X-Google-Smtp-Source: AK7set/0gM5zhCe1TvA+30UIJr22Vs/gJfCdYax54fzarU9TQOgiQE44dxn+cXakoWTUyhwF3Z7K/Q==
X-Received: by 2002:ac8:5913:0:b0:3b9:bd05:bde1 with SMTP id
 19-20020ac85913000000b003b9bd05bde1mr41607055qty.8.1676319278494; 
 Mon, 13 Feb 2023 12:14:38 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 e6-20020ac81306000000b003b8484fdfccsm9947367qtj.42.2023.02.13.12.14.37
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:38 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:29 -0500
Message-Id: <20230213201401.45973-8-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 07/39] dm: avoid initializing static variables
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
 drivers/md/dm-bufio.c | 2 +-
 drivers/md/dm-crypt.c | 2 +-
 drivers/md/dm-raid.c  | 2 +-
 drivers/md/dm.c       | 4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 6c5f551d8e44..7d5495a09611 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -216,7 +216,7 @@ static DEFINE_SPINLOCK(global_spinlock);
 
 static LIST_HEAD(global_queue);
 
-static unsigned long global_num = 0;
+static unsigned long global_num;
 
 /*
  * Buffers are freed after this timeout
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 98c788d1b305..d0ba9679c740 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -230,7 +230,7 @@ struct crypt_config {
 #define POOL_ENTRY_SIZE	512
 
 static DEFINE_SPINLOCK(dm_crypt_clients_lock);
-static unsigned int dm_crypt_clients_n = 0;
+static unsigned int dm_crypt_clients_n;
 static volatile unsigned long dm_crypt_pages_per_client;
 #define DM_CRYPT_MEMORY_PERCENT			2
 #define DM_CRYPT_MIN_PAGES_PER_CLIENT		(BIO_MAX_VECS * 16)
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index a9ebe95f716e..bf53777c7f85 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -30,7 +30,7 @@
  */
 #define	MIN_RAID456_JOURNAL_SPACE (4*2048)
 
-static bool devices_handle_discard_safely = false;
+static bool devices_handle_discard_safely;
 
 /*
  * The following flags are used by dm-raid.c to set up the array state.
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b18c696099da..6a557c79a0d2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -50,8 +50,8 @@
 
 static const char *_name = DM_NAME;
 
-static unsigned int major = 0;
-static unsigned int _major = 0;
+static unsigned int major;
+static unsigned int _major;
 
 static DEFINE_IDR(_minor_idr);
 
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

