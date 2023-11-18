Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B1B36D
	for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 00:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CQmTfnoT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700267648;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uCCMFgx+oRgPp8uwVqq0OccXAJjkCl58BI1mYdsrCmw=;
	b=CQmTfnoT4/Q78lEbx9hiswe+PAhg7Dfj+JtYBMe7aZN/oGlmpkVOCCUNXYS6iLm3A7fT/S
	h2NJktDldknwq1ZxtO0j/Vv1B+SL2rFuglC/euVapOAk9N1/rSZi+zs5pvmqn4K6ILmT8q
	AvtEN2tzH/dQukXZuDRDzWWWtZpr3Gg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-GbkG9w4UO_6t-l0UCAu2Cw-1; Fri, 17 Nov 2023 19:34:06 -0500
X-MC-Unique: GbkG9w4UO_6t-l0UCAu2Cw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EEF380F82E;
	Sat, 18 Nov 2023 00:34:06 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 25A8040C6EBB;
	Sat, 18 Nov 2023 00:34:06 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id DA7DB3003E; Fri, 17 Nov 2023 19:34:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/5] dm vdo io-submitter: rename to vdo_submit_flush_vio
Date: Fri, 17 Nov 2023 19:34:03 -0500
Message-Id: <80ffbddd57f3e95372f10a954c42e00bcb2d0828.1700266895.git.msakai@redhat.com>
In-Reply-To: <cover.1700266895.git.msakai@redhat.com>
References: <cover.1700266895.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Rename submit_flush_vio() to vdo_submit_flush_vio().

Reviewed-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c        | 2 +-
 drivers/md/dm-vdo/io-submitter.h     | 4 ++--
 drivers/md/dm-vdo/recovery-journal.c | 2 +-
 drivers/md/dm-vdo/slab-depot.c       | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 0df1517294e1..1edb3b2a80eb 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -835,7 +835,7 @@ static void save_pages(struct vdo_page_cache *cache)
 	 * successfully persisted, and thus must issue a flush before each batch of pages is
 	 * written to ensure this.
 	 */
-	submit_flush_vio(vio, flush_endio, handle_flush_error);
+	vdo_submit_flush_vio(vio, flush_endio, handle_flush_error);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/io-submitter.h b/drivers/md/dm-vdo/io-submitter.h
index 9e97cfc91bee..77b8df6d559e 100644
--- a/drivers/md/dm-vdo/io-submitter.h
+++ b/drivers/md/dm-vdo/io-submitter.h
@@ -36,8 +36,8 @@ static inline void vdo_submit_metadata_vio(struct vio *vio, physical_block_numbe
 			      operation, vio->data);
 }
 
-static inline void submit_flush_vio(struct vio *vio, bio_end_io_t callback,
-				    vdo_action_fn error_handler)
+static inline void vdo_submit_flush_vio(struct vio *vio, bio_end_io_t callback,
+					vdo_action_fn error_handler)
 {
 	/* FIXME: Can we just use REQ_OP_FLUSH? */
 	__submit_metadata_vio(vio, 0, callback, error_handler,
diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index 55411eff5bd7..2dfc39deef94 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -1541,7 +1541,7 @@ static void reap_recovery_journal(struct recovery_journal *journal)
 	 * summary update covering the slab journal that just released some lock.
 	 */
 	journal->reaping = true;
-	submit_flush_vio(journal->flush_vio, flush_endio, handle_flush_error);
+	vdo_submit_flush_vio(journal->flush_vio, flush_endio, handle_flush_error);
 }
 
 /**
diff --git a/drivers/md/dm-vdo/slab-depot.c b/drivers/md/dm-vdo/slab-depot.c
index 5fc4a1cdfafc..670a464ddbb0 100644
--- a/drivers/md/dm-vdo/slab-depot.c
+++ b/drivers/md/dm-vdo/slab-depot.c
@@ -449,7 +449,7 @@ static void flush_for_reaping(struct waiter *waiter, void *context)
 	struct vio *vio = &pooled->vio;
 
 	vio->completion.parent = journal;
-	submit_flush_vio(vio, flush_endio, handle_flush_error);
+	vdo_submit_flush_vio(vio, flush_endio, handle_flush_error);
 }
 
 /**
-- 
2.40.0

