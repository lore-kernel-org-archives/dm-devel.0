Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F401C6FD1C
	for <dm-devel@archiver.kernel.org>; Thu, 23 Mar 2023 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1679585126;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=ZwsLshBIUn3LxsS7CL9DkhqXNva3nryNk0dfNBTaKnE=;
	b=V4pAeYwgLP6RCLNkDEeFdixIaaRUgeAiYhiMXb+Z/5XguPliSFvWSvbR750jvYqhKOAQFd
	q8EJGivKT0e7g8cYLhhwYU02IJ8Y0Z4LC3e0jizGsVYNi1/6KnsCize1opUZxaW+T1mnb/
	TVKHY18I0ZZaOaM3/XN47DIC/TBfc4s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-262-QCFar7tuMma8pnwT00nWhg-1; Thu, 23 Mar 2023 11:25:24 -0400
X-MC-Unique: QCFar7tuMma8pnwT00nWhg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D173C885621;
	Thu, 23 Mar 2023 15:25:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 814EF492B04;
	Thu, 23 Mar 2023 15:25:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3509A19465B7;
	Thu, 23 Mar 2023 15:25:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1901719465BA
 for <dm-devel@listman.corp.redhat.com>; Thu, 23 Mar 2023 15:25:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F24D11410F1F; Thu, 23 Mar 2023 15:25:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E48291410DD7;
 Thu, 23 Mar 2023 15:25:15 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 32NFPFne004672; Thu, 23 Mar 2023 11:25:15 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 32NFPF88004668; Thu, 23 Mar 2023 11:25:15 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Thu, 23 Mar 2023 11:25:15 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joe Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.21.2303231111360.4019@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH] dm-bufio: fix integer casts
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
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Fix some cases where unsigned long is being cast to unsigned int.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c
+++ linux-2.6/drivers/md/dm-bufio.c
@@ -109,7 +109,7 @@ static void lru_destroy(struct lru *lru)
 	BUG_ON(!list_empty(&lru->iterators));
 }
 
-static inline unsigned int lru_count(struct lru *lru)
+static inline unsigned long lru_count(struct lru *lru)
 {
 	return lru->count;
 }
@@ -260,7 +260,7 @@ typedef enum evict_result (*le_predicate
 
 static struct lru_entry *lru_evict(struct lru *lru, le_predicate pred, void *context)
 {
-	unsigned int tested = 0;
+	unsigned long tested = 0;
 	struct list_head *h = lru->cursor;
 	struct lru_entry *le;
 
@@ -2647,11 +2647,11 @@ static enum evict_result select_for_evic
 	return older_than(b, params->age_hz) ? ER_EVICT : ER_STOP;
 }
 
-static unsigned int __evict_many(struct dm_bufio_client *c,
-				 struct evict_params *params,
-				 int list_mode, unsigned int max_count)
+static unsigned long __evict_many(struct dm_bufio_client *c,
+				  struct evict_params *params,
+				  int list_mode, unsigned long max_count)
 {
-	unsigned int count;
+	unsigned long count;
 	unsigned long last_accessed;
 	struct dm_buffer *b;
 
@@ -2758,9 +2758,9 @@ static void __insert_client(struct dm_bu
 	list_add_tail(&new_client->client_list, h);
 }
 
-static unsigned int __evict_a_few(unsigned int nr_buffers)
+static unsigned long __evict_a_few(unsigned long nr_buffers)
 {
-	unsigned int count;
+	unsigned long count;
 	struct dm_bufio_client *c;
 	struct evict_params params = {
 		.gfp = GFP_KERNEL,
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

