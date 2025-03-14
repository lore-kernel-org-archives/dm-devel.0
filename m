Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A16F282F0
	for <dm-devel@lists.linux.dev>; Fri, 14 Mar 2025 02:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741918339; cv=none; b=LbyFMLbhKS7zxNzlZSb70MI8DFRTA1g4dyQArZC3WaPde4FcbzQhxZF12fuu744ii3Vsnh4fIPQ08ITQpMTHtfZCbfVoVV3GVQEh8Q/9RhtB5SyFAjLU6ZK0BBeM5XZzbOq55LrLHq7qJTzx8zU+wgwTSYov2giP/OPyqS3cmdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741918339; c=relaxed/simple;
	bh=8WMy0x/Qcscwy3LSRbN3fJBynt3EOpafTNWPsiBQF80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dEEhGPBi/+JvyT+JMQ/1PR+EAGoqpzU1cMmDqwfzZ2NNlzpGLqZiluB/goqTXT8Xeup83tIGg4rnJRjHebuGmmzX2P4r1di2fV4CtlPMy0VY99sWVYZz8zuQ1bHe+GOBL9s4k+XkLZOGdh6qYPG4OsvnDkl+zWFWaCtk+wdw8ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cUJPo/mt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cUJPo/mt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741918337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R38aCB8X9sUjKnKzkBvPR6oMsrsyCkjm3yYm+OCxTo0=;
	b=cUJPo/mtfbXKCBg0QFEbNYwXgsGAS+5dUMr7AEAgbjtXtdWmd5/pfNd9ChEci/tpf0tV5M
	J+fu42Pspxf4tq14ZVQo8DWTpjftWbYk6rJdCpKij8j03cWLhghtvMesAe6ZJWtSFbV2XQ
	7M6KWBNkRyP/MiDnu/EqFbkS+Bky+yU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-OdVHmkqlMnWHInv3HRuZPg-1; Thu,
 13 Mar 2025 22:12:13 -0400
X-MC-Unique: OdVHmkqlMnWHInv3HRuZPg-1
X-Mimecast-MFC-AGG-ID: OdVHmkqlMnWHInv3HRuZPg_1741918332
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B52281800257;
	Fri, 14 Mar 2025 02:12:12 +0000 (UTC)
Received: from localhost (unknown [10.72.120.27])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4CA7719373D7;
	Fri, 14 Mar 2025 02:12:10 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	Jooyung Han <jooyung@google.com>,
	Mike Snitzer <snitzer@kernel.org>,
	zkabelac@redhat.com,
	dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 3/5] loop: move command blkcg/memcg initialization into loop_queue_work
Date: Fri, 14 Mar 2025 10:11:43 +0800
Message-ID: <20250314021148.3081954-4-ming.lei@redhat.com>
In-Reply-To: <20250314021148.3081954-1-ming.lei@redhat.com>
References: <20250314021148.3081954-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Move loop command blkcg/memcg initialization into loop_queue_work,
and prepare for supporting to handle loop io command by IOCB_NOWAIT.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/loop.c | 32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 3f921d9d6de6..81f6ba9bc911 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -878,11 +878,28 @@ static inline int queue_on_root_worker(struct cgroup_subsys_state *css)
 
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
@@ -1920,21 +1937,6 @@ static blk_status_t loop_queue_rq(struct blk_mq_hw_ctx *hctx,
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

