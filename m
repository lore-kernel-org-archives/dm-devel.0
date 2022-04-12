Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D7A5C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 12 Apr 2022 08:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1649753856;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=hLtZIZI5eMXlkvCkHO6DuGZbHKPVT4ZiDlWBAUYfipc=;
	b=fYX54MiMO/rMEbAORZloc4aK+LtoDi6egP55Yk6G/MGwwUIZV06E1ITi0+Nn3ORYdD7S5j
	x7RCiWhvnIM2bN9SOh9398dDBAX5hNM0oetB8q2t/X/aneYsjPJD6Dsp23tLcABuimxIVw
	XgGEkaiMbHQcU2kJacc3zfry3irdsDk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-RhOL4a0qPkWPlnY4JOoKrg-1; Tue, 12 Apr 2022 04:57:35 -0400
X-MC-Unique: RhOL4a0qPkWPlnY4JOoKrg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D97E833966;
	Tue, 12 Apr 2022 08:57:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7C42AC44CC2;
	Tue, 12 Apr 2022 08:57:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 24AC81940365;
	Tue, 12 Apr 2022 08:57:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 121481949762
 for <dm-devel@listman.corp.redhat.com>; Tue, 12 Apr 2022 08:57:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E7D75C44CC2; Tue, 12 Apr 2022 08:57:31 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 206CBC44B1D;
 Tue, 12 Apr 2022 08:57:30 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@redhat.com>
Date: Tue, 12 Apr 2022 16:56:16 +0800
Message-Id: <20220412085616.1409626-9-ming.lei@redhat.com>
In-Reply-To: <20220412085616.1409626-1-ming.lei@redhat.com>
References: <20220412085616.1409626-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: [dm-devel] [PATCH 8/8] dm: put all polled io into one single list
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Ming Lei <ming.lei@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
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
index 811c0ccbc63d..7f51957913e8 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -257,7 +257,7 @@ struct dm_io {
 	spinlock_t lock;
 	unsigned long start_time;
 	void *data;
-	struct hlist_node node;
+	struct dm_io *next;
 	struct task_struct *map_task;
 	struct dm_stats_aux stats_aux;
 	/* last member of dm_target_io is 'struct bio' */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 2987f7cf7b47..db23efd6bbf6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1492,7 +1492,7 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 }
 
 /*
- * Reuse ->bi_private as hlist head for storing all dm_io instances
+ * Reuse ->bi_private as dm_io list head for storing all dm_io instances
  * associated with this bio, and this bio's bi_private needs to be
  * stored in dm_io->data before the reuse.
  *
@@ -1500,14 +1500,14 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
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
@@ -1517,19 +1517,20 @@ static void dm_queue_poll_io(struct bio *bio, struct dm_io *io)
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
@@ -1682,18 +1683,16 @@ static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
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
@@ -1704,24 +1703,27 @@ static int dm_poll_bio(struct bio *bio, struct io_comp_batch *iob,
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

