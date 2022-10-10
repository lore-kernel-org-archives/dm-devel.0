Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3FDAC433F5
	for <dm-devel@archiver.kernel.org>; Mon, 10 Oct 2022 12:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1665405419;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=iXSquf4U08uclJUdYUNtmbMNRbXlNq7MhtivTTD4tYg=;
	b=hzXPX4x/QPpErD4Jw2lJYD68j4me/I92+jC66nifBysVQYrh8PMD1h+wQepHRsXaZVC6YE
	ChgtS89q6BQfGkacWI+ifE22aG6lJZ7XT9R+UANjZbh1YdpktefgcmTgUHv5BBgbrjLB2U
	7u7Zfm8aOSqkXFxTUQOmtFZW4/hN840=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-298-NfufSVisP2yJG4EqoF4boA-1; Mon, 10 Oct 2022 08:36:58 -0400
X-MC-Unique: NfufSVisP2yJG4EqoF4boA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 38874101A528;
	Mon, 10 Oct 2022 12:36:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2784D145D82C;
	Mon, 10 Oct 2022 12:36:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 091D719465A0;
	Mon, 10 Oct 2022 12:36:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 222111946597
 for <dm-devel@listman.corp.redhat.com>; Mon, 10 Oct 2022 12:36:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 143382157F44; Mon, 10 Oct 2022 12:36:55 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 03A282157F30;
 Mon, 10 Oct 2022 12:36:54 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 29ACasRC026719; Mon, 10 Oct 2022 08:36:54 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 29ACas5x026716; Mon, 10 Oct 2022 08:36:54 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Mon, 10 Oct 2022 08:36:54 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Joe Thornber <thornber@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
 Heinz Mauelshagen <heinzm@redhat.com>
In-Reply-To: <alpine.LRH.2.02.2210100811400.25650@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.2210100836190.25650@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2210100811400.25650@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 3/4] persistent-data: simplify struct ro_spine
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The struct ro_spine holds pointers to two last blocks when doing read-only
btree walk. The second block is never accessed (note that the function
ro_pop is never called), so we can simplify the code so that it holds
pointer to just one block.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/persistent-data/dm-btree-internal.h |    4 --
 drivers/md/persistent-data/dm-btree-spine.c    |   41 +++++--------------------
 2 files changed, 10 insertions(+), 35 deletions(-)

Index: linux-2.6/drivers/md/persistent-data/dm-btree-internal.h
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree-internal.h	2022-10-10 11:20:17.000000000 +0200
+++ linux-2.6/drivers/md/persistent-data/dm-btree-internal.h	2022-10-10 11:20:55.000000000 +0200
@@ -63,14 +63,12 @@ void unlock_block(struct dm_btree_info *
 struct ro_spine {
 	struct dm_btree_info *info;
 
-	int count;
-	struct dm_block *nodes[2];
+	struct dm_block *node;
 };
 
 void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info);
 void exit_ro_spine(struct ro_spine *s);
 int ro_step(struct ro_spine *s, dm_block_t new_child);
-void ro_pop(struct ro_spine *s);
 struct btree_node *ro_node(struct ro_spine *s);
 
 struct shadow_spine {
Index: linux-2.6/drivers/md/persistent-data/dm-btree-spine.c
===================================================================
--- linux-2.6.orig/drivers/md/persistent-data/dm-btree-spine.c	2022-10-10 11:20:17.000000000 +0200
+++ linux-2.6/drivers/md/persistent-data/dm-btree-spine.c	2022-10-10 11:20:42.000000000 +0200
@@ -123,52 +123,29 @@ void unlock_block(struct dm_btree_info *
 void init_ro_spine(struct ro_spine *s, struct dm_btree_info *info)
 {
 	s->info = info;
-	s->count = 0;
-	s->nodes[0] = NULL;
-	s->nodes[1] = NULL;
+	s->node = NULL;
 }
 
 void exit_ro_spine(struct ro_spine *s)
 {
-	int i;
-
-	for (i = 0; i < s->count; i++) {
-		unlock_block(s->info, s->nodes[i]);
-	}
+	if (s->node)
+		unlock_block(s->info, s->node);
 }
 
 int ro_step(struct ro_spine *s, dm_block_t new_child)
 {
-	int r;
-
-	if (s->count == 2) {
-		unlock_block(s->info, s->nodes[0]);
-		s->nodes[0] = s->nodes[1];
-		s->count--;
+	if (s->node) {
+		unlock_block(s->info, s->node);
+		s->node = NULL;
 	}
 
-	r = bn_read_lock(s->info, new_child, s->nodes + s->count);
-	if (!r)
-		s->count++;
-
-	return r;
-}
-
-void ro_pop(struct ro_spine *s)
-{
-	BUG_ON(!s->count);
-	--s->count;
-	unlock_block(s->info, s->nodes[s->count]);
+	return bn_read_lock(s->info, new_child, &s->node);
 }
 
 struct btree_node *ro_node(struct ro_spine *s)
 {
-	struct dm_block *block;
-
-	BUG_ON(!s->count);
-	block = s->nodes[s->count - 1];
-
-	return dm_block_data(block);
+	BUG_ON(!s->node);
+	return dm_block_data(s->node);
 }
 
 /*----------------------------------------------------------------*/

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

