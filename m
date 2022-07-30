Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1B4BC04A68
	for <dm-devel@archiver.kernel.org>; Sat, 30 Jul 2022 05:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1659158012;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=frpoqDa3ztTK3fcKCsJgPmOp6aMxQa9NXQdIDOgboao=;
	b=RVTuIM4JHbW7TrAFlthLIMitzWQyPlWMD9cZfVEEZhRfmzgme5nbOvfVcSlRlmi9fqCHvJ
	mfdcFLHgcEBp0RY6n2sJ1ft988KuGb55H1WfTkJZGaTURkWuDOFqxHi+54eJrGjqLuYDo6
	dTd0GUPhWNJkgAW4518sKHLggyLF+qE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-gC6SwB_8MfmkhH7NlJyw5A-1; Sat, 30 Jul 2022 01:13:29 -0400
X-MC-Unique: gC6SwB_8MfmkhH7NlJyw5A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1FCAF185A7BA;
	Sat, 30 Jul 2022 05:13:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0EE6B1121314;
	Sat, 30 Jul 2022 05:13:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 88DE31964189;
	Sat, 30 Jul 2022 05:13:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A87B3194FFF9
 for <dm-devel@listman.corp.redhat.com>; Sat, 30 Jul 2022 05:13:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 98E58403D0E0; Sat, 30 Jul 2022 05:13:06 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 990964047D22;
 Sat, 30 Jul 2022 05:13:05 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
 by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 26U5D4LS024127;
 Sat, 30 Jul 2022 00:13:04 -0500
Received: (from bmarzins@localhost)
 by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 26U5D32R024126;
 Sat, 30 Jul 2022 00:13:03 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Date: Sat, 30 Jul 2022 00:12:56 -0500
Message-Id: <1659157980-24079-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1659157980-24079-1-git-send-email-bmarzins@redhat.com>
References: <1659157980-24079-1-git-send-email-bmarzins@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH 2/6] multipathd: track waiters for mutex_lock
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
Cc: Wu Guanghao <wuguanghao3@huawei.com>,
 device-mapper development <dm-devel@redhat.com>,
 Martin Wilck <Martin.Wilck@suse.com>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

use the uatomic operations to track how many threads are waiting in
lock() for mutex_locks. This will be used by a later patch.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/lock.h | 16 ++++++++++++++++
 multipathd/main.c   |  2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/libmultipath/lock.h b/libmultipath/lock.h
index d7b779e7..20ca77e6 100644
--- a/libmultipath/lock.h
+++ b/libmultipath/lock.h
@@ -2,17 +2,28 @@
 #define _LOCK_H
 
 #include <pthread.h>
+#include <urcu/uatomic.h>
+#include <stdbool.h>
 
 typedef void (wakeup_fn)(void);
 
 struct mutex_lock {
 	pthread_mutex_t mutex;
 	wakeup_fn *wakeup;
+	int waiters; /* uatomic access only */
 };
 
+static inline void init_lock(struct mutex_lock *a)
+{
+	pthread_mutex_init(&a->mutex, NULL);
+	uatomic_set(&a->waiters, 0);
+}
+
 static inline void lock(struct mutex_lock *a)
 {
+	uatomic_inc(&a->waiters);
 	pthread_mutex_lock(&a->mutex);
+	uatomic_dec(&a->waiters);
 }
 
 static inline int trylock(struct mutex_lock *a)
@@ -30,6 +41,11 @@ static inline void __unlock(struct mutex_lock *a)
 	pthread_mutex_unlock(&a->mutex);
 }
 
+static inline bool lock_has_waiters(struct mutex_lock *a)
+{
+	return (uatomic_read(&a->waiters) > 0);
+}
+
 #define lock_cleanup_pop(a) pthread_cleanup_pop(1)
 
 void cleanup_lock (void * data);
diff --git a/multipathd/main.c b/multipathd/main.c
index 2f2b9d4c..71079113 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2940,7 +2940,7 @@ init_vecs (void)
 	if (!vecs)
 		return NULL;
 
-	pthread_mutex_init(&vecs->lock.mutex, NULL);
+	init_lock(&vecs->lock);
 
 	return vecs;
 }
-- 
2.17.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

