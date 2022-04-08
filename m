Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F725C433F5
	for <dm-devel@archiver.kernel.org>; Fri,  8 Apr 2022 17:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649438031;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=67Knx1vnsJNQxwwpY+q0AxzAxjcO4XuMZU4Itu/m2Mw=;
	b=gTLqwrhOTxR5ddt+WFi7yuZyu9DpVS80Huib5Gvse5gvVqhmxECb7/7Ij202UEp6QW85EK
	meKfT+sMYhMai8Q1bIp+A+OCGJtcO3L8nNk6EOYWkjLEPMRYgKfnCsfqwWqAUNUXsPgnhd
	xSNHbWX565bqx1HhQWHtyOFWkFmSKZU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-ZZN7xozhOcWYpUSQGURULw-1; Fri, 08 Apr 2022 13:13:48 -0400
X-MC-Unique: ZZN7xozhOcWYpUSQGURULw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60CC1282B7EB;
	Fri,  8 Apr 2022 17:13:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4FCC91121314;
	Fri,  8 Apr 2022 17:13:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0ED421940344;
	Fri,  8 Apr 2022 17:13:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 68ACD1940341
 for <dm-devel@listman.corp.redhat.com>; Fri,  8 Apr 2022 17:13:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 59052C33AE8; Fri,  8 Apr 2022 17:13:44 +0000 (UTC)
Received: from localhost (ovpn-8-29.pek2.redhat.com [10.72.8.29])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 87116C30C0A;
 Fri,  8 Apr 2022 17:13:43 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Date: Sat,  9 Apr 2022 01:12:54 +0800
Message-Id: <20220408171254.935171-4-ming.lei@redhat.com>
In-Reply-To: <20220408171254.935171-1-ming.lei@redhat.com>
References: <20220408171254.935171-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 3/3] dm: put all polled io into one single list
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
Cc: dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

If bio_split() isn't involved, it is a bit overkill to link dm_io into hlist,
given there is only single dm_io in the list, so convert to single list
for holding all dm_io instances associated with this bio.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-core.h |  2 +-
 drivers/md/dm.c      | 46 +++++++++++++++++++++++---------------------
 2 files changed, 25 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 13136bd47cb3..e28f7d54d2b7 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -252,7 +252,7 @@ struct dm_io {
 	spinlock_t lock;
 	unsigned long start_time;
 	void *data;
-	struct hlist_node node;
+	struct dm_io *next;
 	struct task_struct *map_task;
 	struct dm_stats_aux stats_aux;
 	/* last member of dm_target_io is 'struct bio' */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 528559ca2f91..84cb73462fcd 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1486,7 +1486,7 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 }
 
 /*
- * Reuse ->bi_private as hlist head for storing all dm_io instances
+ * Reuse ->bi_private as dm_io list head for storing all dm_io instances
  * associated with this bio, and this bio's bi_private needs to be
  * stored in dm_io->data before the reuse.
  *
@@ -1494,14 +1494,14 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
  * touch it after splitting. Meantime it won't be changed by anyone after
  * bio is submitted. So this reuse is safe.
  */
-static inline struct hlist_head *dm_get_bio_hlist_head(struct bio *bio)
+static inline struct dm_io **dm_poll_list_head(struct bio *bio)
 {
-	return (struct hlist_head *)&bio->bi_private;
+	return (struct dm_io **)&bio->bi_private;
 }
 
 static void dm_queue_poll_io(struct bio *bio, struct dm_io *io)
 {
-	struct hlist_head *head = dm_get_bio_hlist_head(bio);
+	struct dm_io **head = dm_poll_list_head(bio);
 
 	if (!(bio->bi_opf & REQ_DM_POLL_LIST)) {
 		bio->bi_opf |= REQ_DM_POLL_LIST;
@@ -1511,19 +1511,20 @@ static void dm_queue_poll_io(struct bio *bio, struct dm_io *io)
 		 */
 		io->data = bio->bi_private;
 
-		INIT_HLIST_HEAD(head);
-
 		/* tell block layer to poll for completion */
 		bio->bi_cookie = ~BLK_QC_T_NONE;
+
+		io->next = NULL;
 	} else {
 		/*
 		 * bio recursed due to split, reuse original poll list,
 		 * and save bio->bi_private too.
 		 */
-		io->data = hlist_entry(head->first, struct dm_io, node)->data;
+		io->data = (*head)->data;
+		io->next = *head;
 	}
 
-	hlist_add_head(&io->node, head);
+	*head = io;
 }
 
 /*
@@ -1677,18 +1678,16 @@ static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
 static int dm_poll_bio(struct bio *bio, struct io_comp_batch *iob,
 		       unsigned int flags)
 {
-	struct hlist_head *head = dm_get_bio_hlist_head(bio);
-	struct hlist_head tmp = HLIST_HEAD_INIT;
-	struct hlist_node *next;
-	struct dm_io *io;
+	struct dm_io **head = dm_poll_list_head(bio);
+	struct dm_io *list = *head;
+	struct dm_io *tmp = NULL;
+	struct dm_io *curr, *next;
 
 	/* Only poll normal bio which was marked as REQ_DM_POLL_LIST */
 	if (!(bio->bi_opf & REQ_DM_POLL_LIST))
 		return 0;
 
-	WARN_ON_ONCE(hlist_empty(head));
-
-	hlist_move_list(head, &tmp);
+	WARN_ON_ONCE(!list);
 
 	/*
 	 * Restore .bi_private before possibly completing dm_io.
@@ -1699,24 +1698,27 @@ static int dm_poll_bio(struct bio *bio, struct io_comp_batch *iob,
 	 * clearing REQ_DM_POLL_LIST here.
 	 */
 	bio->bi_opf &= ~REQ_DM_POLL_LIST;
-	bio->bi_private = hlist_entry(tmp.first, struct dm_io, node)->data;
+	bio->bi_private = list->data;
 
-	hlist_for_each_entry_safe(io, next, &tmp, node) {
-		if (dm_poll_dm_io(io, iob, flags)) {
-			hlist_del_init(&io->node);
+	for (curr = list, next = curr->next; curr; curr = next, next =
+			curr ? curr->next : NULL) {
+		if (dm_poll_dm_io(curr, iob, flags)) {
 			/*
 			 * clone_endio() has already occurred, so passing
 			 * error as 0 here doesn't override io->status
 			 */
-			dm_io_dec_pending(io, 0);
+			dm_io_dec_pending(curr, 0);
+		} else {
+			curr->next = tmp;
+			tmp = curr;
 		}
 	}
 
 	/* Not done? */
-	if (!hlist_empty(&tmp)) {
+	if (tmp) {
 		bio->bi_opf |= REQ_DM_POLL_LIST;
 		/* Reset bio->bi_private to dm_io list head */
-		hlist_move_list(&tmp, head);
+		*head = tmp;
 		return 0;
 	}
 	return 1;
-- 
2.31.1

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

