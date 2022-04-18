Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC856C4332F
	for <dm-devel@archiver.kernel.org>; Mon, 18 Apr 2022 02:28:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-yFo7xnEjMT2yHSO23Mi7Ag-1; Sun, 17 Apr 2022 22:28:05 -0400
X-MC-Unique: yFo7xnEjMT2yHSO23Mi7Ag-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B587811E7A;
	Mon, 18 Apr 2022 02:28:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A9A7C44CC2;
	Mon, 18 Apr 2022 02:28:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id E213A19451F1;
	Mon, 18 Apr 2022 02:28:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E1A2F19466DF
 for <dm-devel@listman.corp.redhat.com>; Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D14532029F8F; Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CCBAC200D8FC
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B314A1014A6C
 for <dm-devel@redhat.com>; Mon, 18 Apr 2022 02:28:00 +0000 (UTC)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com
 [209.85.219.46]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-471-oHswBzvMNB2_IS_qZoFQ0A-1; Sun, 17 Apr 2022 22:27:59 -0400
X-MC-Unique: oHswBzvMNB2_IS_qZoFQ0A-1
Received: by mail-qv1-f46.google.com with SMTP id hu11so10129526qvb.7
 for <dm-devel@redhat.com>; Sun, 17 Apr 2022 19:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=rW/RKjSRN252kEm+ZBoiR7dmJQ5iT4G3RMI5g2+VLGw=;
 b=UExUdflao6HGr9IneKDIXcxahmchYBGW5uBPYDwrdG9jdMm2eL7yn/kvlsKfsKvP83
 VXJ4hWtxIblgPOxEb5tfdGIMx4QNJ79ZoxOCcC3qgUXp1GGArP9ZzebWUyUcM1OrKv3q
 yLlWs+gz2a+gvZNj40SqvDM0bVXgmWF7V80o7GB5lFu6sOyiIwIUJFEmM/fZ9W+VKnfW
 RSy5qZK8u7ZnbD5NH49BS8aFvxMu4D8rdDPQTiLoKR15k+2pnqlmNuAlJJGgqL7k98BZ
 9uEih/DcxSAO4qtbL88L1BsPS+ZAIW7FG2G5Ct+UokcnlPf8xNnHa5DL1xpQEEXeJLiO
 QWZg==
X-Gm-Message-State: AOAM530K4x2ASiQvQDs1NfY34yURQxLL9QUe/Xrp9B67fgafL9RH62TY
 LowpCfztTH46o287mw57S+nT9V8LvjiFuZrHLhVPFd6bCQ/vmXydDvdjgp7PtEJ++JSrUBAtW2b
 TtVdr7rOh6aSUU5jUtqxpEL1RtCrOJXYXTtZEOJSv86vvlF+IiWRpFrmK2lVB/6zLVMg=
X-Google-Smtp-Source: ABdhPJzvkwil0ZxfKvwiYwVBi5AQViI3Mo3cRCphyDKkTdGO00A/ooppIfK88mIKEusGaqWdZuBtYA==
X-Received: by 2002:a05:6214:d48:b0:446:3a33:2dba with SMTP id
 8-20020a0562140d4800b004463a332dbamr6499931qvr.78.1650248878094; 
 Sun, 17 Apr 2022 19:27:58 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 i136-20020a379f8e000000b0069c7f8b69b8sm5414923qke.82.2022.04.17.19.27.57
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Sun, 17 Apr 2022 19:27:57 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Sun, 17 Apr 2022 22:27:31 -0400
Message-Id: <20220418022733.56168-20-snitzer@kernel.org>
In-Reply-To: <20220418022733.56168-1-snitzer@kernel.org>
References: <20220418022733.56168-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Subject: [dm-devel] [dm-5.19 PATCH 19/21] dm: put all polled dm_io instances
 into a single list
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
Cc: axboe@kernel.dk, hch@lst.de, ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="===============2179410130108015795=="

--===============2179410130108015795==
Content-Type: application/octet-stream; x-default=true

From: Ming Lei <ming.lei@redhat.com>

Now that bio_split() isn't used by DM's bio splitting, it is a bit
overkill to link dm_io into an hlist given there is only single dm_io
in the list.

Convert to using a single list for holding all dm_io instances
associated with this bio.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-core.h |  2 +-
 drivers/md/dm.c      | 52 +++++++++++++++++++++++++++-------------------------
 2 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index d2d188c9b632..f3cfc7affd12 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -259,7 +259,7 @@ struct dm_io {
 	spinlock_t lock;
 	unsigned long start_time;
 	void *data;
-	struct hlist_node node;
+	struct dm_io *next;
 	struct task_struct *map_task;
 	struct dm_stats_aux stats_aux;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9b5cdd4b734d..c5a79712de1d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1560,7 +1560,7 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
 }
 
 /*
- * Reuse ->bi_private as hlist head for storing all dm_io instances
+ * Reuse ->bi_private as dm_io list head for storing all dm_io instances
  * associated with this bio, and this bio's bi_private needs to be
  * stored in dm_io->data before the reuse.
  *
@@ -1568,36 +1568,37 @@ static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
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
 		/*
 		 * Save .bi_private into dm_io, so that we can reuse
-		 * .bi_private as hlist head for storing dm_io list
+		 * .bi_private as dm_io list head for storing dm_io list
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
@@ -1686,8 +1687,8 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	 * Drop the extra reference count for non-POLLED bio, and hold one
 	 * reference for POLLED bio, which will be released in dm_poll_bio
 	 *
-	 * Add every dm_io instance into the hlist_head which is stored in
-	 * bio->bi_private, so that dm_poll_bio can poll them all.
+	 * Add every dm_io instance into the dm_io list head which is stored
+	 * in bio->bi_private, so that dm_poll_bio can poll them all.
 	 */
 	if (error || !ci.submit_as_polled) {
 		/*
@@ -1749,18 +1750,16 @@ static bool dm_poll_dm_io(struct dm_io *io, struct io_comp_batch *iob,
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
@@ -1771,24 +1770,27 @@ static int dm_poll_bio(struct bio *bio, struct io_comp_batch *iob,
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
 			 * clone_endio() has already occurred, so no
 			 * error handling is needed here.
 			 */
-			__dm_io_dec_pending(io);
+			__dm_io_dec_pending(curr);
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
2.15.0


--===============2179410130108015795==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

--===============2179410130108015795==--

