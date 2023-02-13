Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 182D6C6FA9D
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319338;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+s7WEhPUKOU8KpOs9ss+twol5xOA9pEInhaLymnj2cc=;
	b=H2ZIslUh3a79+iaHHtG3vRHO+4ZIcFkvykRJY0J8d08+vPPRIkxb5FPVfS8iS3YPdi8GZI
	wQeFieMBjjt4LnWJcKKQ7+QEI1nBictXi4BHKIupuM20vKNKRooqN0oOOIvSOf0sGmTn1M
	GNqn52Uj5Rh8mpDkKeM31ftutWyQHyU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-q2sjFDmlNBK3mJ-YCvloUQ-1; Mon, 13 Feb 2023 15:15:32 -0500
X-MC-Unique: q2sjFDmlNBK3mJ-YCvloUQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7EDB388B7C9;
	Mon, 13 Feb 2023 20:15:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6E14018EC7;
	Mon, 13 Feb 2023 20:15:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 54A611946588;
	Mon, 13 Feb 2023 20:15:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F33E21946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E74772026D68; Mon, 13 Feb 2023 20:15:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DDFFF2026D2B
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2ABC6280049F
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:09 +0000 (UTC)
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com
 [209.85.160.180]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-498-qs8-DROoPE-SMxEEpQ2nAQ-4; Mon, 13 Feb 2023 15:15:02 -0500
X-MC-Unique: qs8-DROoPE-SMxEEpQ2nAQ-4
Received: by mail-qt1-f180.google.com with SMTP id m12so15199169qth.4
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=jgy5xmSWrHhNyz5sB+K5yknnC9/SpSZZVr80tXTSr4k=;
 b=Q+3Jto8SjGqz/e/X6ZwGcOUYTChFo3jFkZ3cGIuQjp5BbMBwlNEMywmz7nPawjAhj7
 w+sNvDQS83xXeLss8lD7R69H1x1qbL0WzS805gwh38K4qR8yQPatRTGsodvgU1EPybH9
 UZZ1kAr3CJcYvUfCOKu/lV2z600Q1YV1cPr9pXiWsJnLIMMTM7U2TyFowkyDss363pH5
 5Ukcf0FvRZ3U9OAnK7HAWrHjuz6xkupcua5AwBY3VerW7xJ6ENq+aW4e2zEwyeRkkioF
 QdGfdf/SfVSO4HmrMIGf9i+ZC92RFm1gaYRrRnGGoOhOclCyxBjjeZLOp6R320LzkHXD
 JBQw==
X-Gm-Message-State: AO0yUKW9RNTwOA4KzlFjthvoR8w+aab2xXIYc/JnuItNZwdVtNJpJDSu
 snk7Mj9vPTfsuvTPotcq0exk8ijWEnc/ElieJaRnc1pvZOuDshEpA4/uoxw/4Q6AIBaW9dw/SvT
 7NxmsulHzW9HsgpiWK1H54bL8wQfqFT5EWeXHpQqfcsX4SrfrF8drdfTkqE9QwIk40OyvXw==
X-Google-Smtp-Source: AK7set9MPjOb49UuLRLpA7iRmHhnllTOQPMdVzkA9/yOsuN6lUkwG9LB0itY4WrVr6BtOjrgXB33Tw==
X-Received: by 2002:ac8:5a54:0:b0:3b8:6075:5d12 with SMTP id
 o20-20020ac85a54000000b003b860755d12mr47607163qta.54.1676319301229; 
 Mon, 13 Feb 2023 12:15:01 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 a191-20020ae9e8c8000000b0072396cb73cdsm10331717qkg.13.2023.02.13.12.15.00
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:15:00 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:42 -0500
Message-Id: <20230213201401.45973-21-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 20/39] dm: adjust EXPORT_SYMBOL() to follow
 functions immediately
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-builtin.c               | 1 -
 drivers/md/dm-path-selector.c         | 3 +--
 drivers/md/dm-target.c                | 5 ++---
 drivers/md/persistent-data/dm-btree.c | 1 -
 4 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-builtin.c b/drivers/md/dm-builtin.c
index 8eb52e425141..d6aab32a8391 100644
--- a/drivers/md/dm-builtin.c
+++ b/drivers/md/dm-builtin.c
@@ -45,5 +45,4 @@ void dm_kobject_release(struct kobject *kobj)
 {
 	complete(dm_get_completion_from_kobject(kobj));
 }
-
 EXPORT_SYMBOL(dm_kobject_release);
diff --git a/drivers/md/dm-path-selector.c b/drivers/md/dm-path-selector.c
index 5863f286cff4..fd4a8c448762 100644
--- a/drivers/md/dm-path-selector.c
+++ b/drivers/md/dm-path-selector.c
@@ -115,6 +115,7 @@ int dm_register_path_selector(struct path_selector_type *pst)
 
 	return r;
 }
+EXPORT_SYMBOL_GPL(dm_register_path_selector);
 
 int dm_unregister_path_selector(struct path_selector_type *pst)
 {
@@ -136,6 +137,4 @@ int dm_unregister_path_selector(struct path_selector_type *pst)
 
 	return 0;
 }
-
-EXPORT_SYMBOL_GPL(dm_register_path_selector);
 EXPORT_SYMBOL_GPL(dm_unregister_path_selector);
diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index ef11379584b2..2ed9bd03b7c1 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -93,6 +93,7 @@ int dm_register_target(struct target_type *tt)
 	up_write(&_lock);
 	return rv;
 }
+EXPORT_SYMBOL(dm_register_target);
 
 void dm_unregister_target(struct target_type *tt)
 {
@@ -106,6 +107,7 @@ void dm_unregister_target(struct target_type *tt)
 
 	up_write(&_lock);
 }
+EXPORT_SYMBOL(dm_unregister_target);
 
 /*
  * io-err: always fails an io, useful for bringing
@@ -171,6 +173,3 @@ void dm_target_exit(void)
 {
 	dm_unregister_target(&error_target);
 }
-
-EXPORT_SYMBOL(dm_register_target);
-EXPORT_SYMBOL(dm_unregister_target);
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index a83b45a648d7..d646d792ce51 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -496,7 +496,6 @@ int dm_btree_lookup_next(struct dm_btree_info *info, dm_block_t root,
 	exit_ro_spine(&spine);
 	return r;
 }
-
 EXPORT_SYMBOL_GPL(dm_btree_lookup_next);
 
 /*----------------------------------------------------------------*/
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

