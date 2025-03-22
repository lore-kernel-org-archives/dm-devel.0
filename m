Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3FD28399
	for <dm-devel@lists.linux.dev>; Sat, 22 Mar 2025 01:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742606823; cv=none; b=G612G5gFflU+MwfFgarkVQnE0mh7bCcKtrI1cW3iqumuiJDHP34oViYDUy4ifB71AKxaQ+Wi9UEpVZgBfTCrpMv8rRliSc5EYzwy+ge7bMEqfHgXxCkjjN6VQqN2uJ7x/MblqEmxQeSEYCV/kgVkfjje0BWQjpc2gS4Rsi4DwL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742606823; c=relaxed/simple;
	bh=yviK+aS42v6UyKRW/66m9FeY2W0+i88S4CfqyMxE22E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hl3JmvbSFvKd3Xr+h6HKAYOV0fb3KJGNlgWjYrKbtrTdBhGsCv94f2MEGNaN1IG+JjbawIvasx2VmRWCuFnoJR4QlZzgdZHSyiPlTRoQHkTpSzMzFOX/ndVFwPg5DZAYdsNHvks5GR3MbrTKDcQsLzzfG1QsuzdYS5I+9FYW6fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZBbXPjVg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZBbXPjVg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742606818;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VJLTL3U2JgfRrp6bRWSk0rx4EAlBpAq5p4h/hpiHBPg=;
	b=ZBbXPjVgZNPc5z+Kx9Sb6CNG9GDCFqd19AnAxaQ4tO39j2KOf2muFIGvQCCk+JtuQpacKb
	N7iYxt4jpH6Wro38q/oNge0ktIXCMzPX3vPHwB6GDuFvJ82Lea4i4DzMX73iiNgywFDWkL
	W3aGWkN+0VWWxxddeaYwuT9W/XtOvHQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-7-2cNij-bGNIWore8l9jEnTg-1; Fri,
 21 Mar 2025 21:26:50 -0400
X-MC-Unique: 2cNij-bGNIWore8l9jEnTg-1
X-Mimecast-MFC-AGG-ID: 2cNij-bGNIWore8l9jEnTg_1742606806
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8350C196D2CC;
	Sat, 22 Mar 2025 01:26:46 +0000 (UTC)
Received: from localhost (unknown [10.72.120.2])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id ECC23195609D;
	Sat, 22 Mar 2025 01:26:44 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Jooyung Han <jooyung@google.com>,
	Mike Snitzer <snitzer@kernel.org>,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 3/5] loop: move command blkcg/memcg initialization into loop_queue_work
Date: Sat, 22 Mar 2025 09:26:12 +0800
Message-ID: <20250322012617.354222-4-ming.lei@redhat.com>
In-Reply-To: <20250322012617.354222-1-ming.lei@redhat.com>
References: <20250322012617.354222-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Move loop command blkcg/memcg initialization into loop_queue_work,
and prepare for supporting to handle loop io command by IOCB_NOWAIT.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/loop.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 419ca675342a..c14da87efb07 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -877,11 +877,28 @@ static inline int queue_on_root_worker(struct cgroup_subsys_state *css)
 
 static void loop_queue_work(struct loop_device *lo, struct loop_cmd *cmd)
 {
+	struct request __maybe_unused *rq = blk_mq_rq_from_pdu(cmd);
 	struct rb_node **node, *parent = NULL;
 	struct loop_worker *cur_worker, *worker = NULL;
 	struct work_struct *work;
 	struct list_head *cmd_list;
 
+	/* always use the first bio's css */
+	cmd->blkcg_css = NULL;
+	cmd->memcg_css = NULL;
+#ifdef CONFIG_BLK_CGROUP
+	if (rq->bio) {
+		cmd->blkcg_css = bio_blkcg_css(rq->bio);
+#ifdef CONFIG_MEMCG
+		if (cmd->blkcg_css) {
+			cmd->memcg_css =
+				cgroup_get_e_css(cmd->blkcg_css->cgroup,
+						&memory_cgrp_subsys);
+		}
+#endif
+	}
+#endif
+
 	spin_lock_irq(&lo->lo_work_lock);
 
 	if (queue_on_root_worker(cmd->blkcg_css))
@@ -1926,21 +1943,6 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		break;
 	}
 
-	/* always use the first bio's css */
-	cmd->blkcg_css = NULL;
-	cmd->memcg_css = NULL;
-#ifdef CONFIG_BLK_CGROUP
-	if (rq->bio) {
-		cmd->blkcg_css = bio_blkcg_css(rq->bio);
-#ifdef CONFIG_MEMCG
-		if (cmd->blkcg_css) {
-			cmd->memcg_css =
-				cgroup_get_e_css(cmd->blkcg_css->cgroup,
-						&memory_cgrp_subsys);
-		}
-#endif
-	}
-#endif
 	loop_queue_work(lo, cmd);
 
 	return BLK_STS_OK;
-- 
2.47.0

