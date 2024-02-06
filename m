Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B275677B
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707185069; cv=none; b=dHJW0Kt3HoamhqqS+Mef24AREdEGfVt05A0NayDroZx70vvU6fyOxKVvpOYoc/eXkV0wAQAPQaqBBUiPcxn/74BOlyjKhyfs6lKlE0rG+hNHctshg5smzAWaxunDLVR1m/ritcS0QYJSVOvLpIbGP73cPLiOg5f4mjtqWtoCVZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707185069; c=relaxed/simple;
	bh=z06DROj/sqQ6Zum95kkdCP3FuvjNJXoMBbRSttq2uxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VaoNyML3TTHfSzBHqOyJiNAaJrYkWvuKTDaSIa+PdRdrIj3y6nAvlPAc6GSJEbyvlBOzIGeoxaeFO39xfWAhVn9mGm02CH7ZOqP27XhgT3qKBEcdlzNaPJ193yyih6+jx9Wf8GF5E+ux4mQOylD65NF2Hi4lwxW05NgleEo/xCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VFUNdS1a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VFUNdS1a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707185065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7bhjFQlp5QV+6QlxdbpIcfz5Te4XJ3oKkLmlwC4OaJU=;
	b=VFUNdS1aZjlQmsCBRCSoZTUaqdXR8yEXxKTNdsC92uTsC0sv/dx61pZgtx3eBCXpCSayWl
	hv8JTEzkSffgejh2CcfKhFf7jof5iW+82iTnCO+/ghUTk1ttD/m7hBELORQLah3P1q1san
	GY0bOd26l7FIrF/NQ3doeXlg3Ip4J4A=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-G3hLxbOwNb-nmtktxW3g7w-1; Mon, 05 Feb 2024 21:04:22 -0500
X-MC-Unique: G3hLxbOwNb-nmtktxW3g7w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A0D73835145;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B779492BC6;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 99010569FC; Mon,  5 Feb 2024 21:04:22 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/7] dm vdo: fix various blk_opf_t sparse warnings
Date: Mon,  5 Feb 2024 21:04:18 -0500
Message-ID: <4ebc72afc1322fb76e635d73cc9c9b36eaa98aed.1707184413.git.msakai@redhat.com>
In-Reply-To: <cover.1707184413.git.msakai@redhat.com>
References: <cover.1707184413.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Use proper blk_opf_t type rather than unsigned int.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c    | 2 +-
 drivers/md/dm-vdo/data-vio.c     | 4 ++--
 drivers/md/dm-vdo/io-submitter.c | 2 +-
 drivers/md/dm-vdo/io-submitter.h | 4 ++--
 drivers/md/dm-vdo/vio.c          | 4 ++--
 drivers/md/dm-vdo/vio.h          | 4 ++--
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 1278a5791160..cc87e1ac72b6 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -1620,7 +1620,7 @@ static void write_initialized_page(struct vdo_completion *completion)
 	struct block_map_zone *zone = pooled->context;
 	struct tree_page *tree_page = completion->parent;
 	struct block_map_page *page = (struct block_map_page *) vio->data;
-	unsigned int operation = REQ_OP_WRITE | REQ_PRIO;
+	blk_opf_t operation = REQ_OP_WRITE | REQ_PRIO;
 
 	/*
 	 * Now that we know the page has been written at least once, mark the copy we are writing
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 328b645dee16..e0f1574ae112 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -69,7 +69,7 @@
  *   ASAP to service heavy load, which is the only place where REQ_BACKGROUND might aid in load
  *   prioritization.
  */
-static unsigned int PASSTHROUGH_FLAGS = (REQ_PRIO | REQ_META | REQ_SYNC | REQ_RAHEAD);
+static blk_opf_t PASSTHROUGH_FLAGS = (REQ_PRIO | REQ_META | REQ_SYNC | REQ_RAHEAD);
 
 /**
  * DOC:
@@ -1570,7 +1570,7 @@ static void read_block(struct vdo_completion *completion)
 		result = vio_reset_bio(vio, (char *) data_vio->compression.block,
 				       read_endio, REQ_OP_READ, data_vio->mapped.pbn);
 	} else {
-		int opf = ((data_vio->user_bio->bi_opf & PASSTHROUGH_FLAGS) | REQ_OP_READ);
+		blk_opf_t opf = ((data_vio->user_bio->bi_opf & PASSTHROUGH_FLAGS) | REQ_OP_READ);
 
 		if (data_vio->is_partial) {
 			result = vio_reset_bio(vio, vio->data, read_endio, opf,
diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index 74f33a3ddce5..6c050f2b3b44 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -338,7 +338,7 @@ void vdo_submit_data_vio(struct data_vio *data_vio)
  */
 void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 			   bio_end_io_t callback, vdo_action_fn error_handler,
-			   unsigned int operation, char *data)
+			   blk_opf_t operation, char *data)
 {
 	int result;
 	struct vdo_completion *completion = &vio->completion;
diff --git a/drivers/md/dm-vdo/io-submitter.h b/drivers/md/dm-vdo/io-submitter.h
index ddd5f4b391b6..80748699496f 100644
--- a/drivers/md/dm-vdo/io-submitter.h
+++ b/drivers/md/dm-vdo/io-submitter.h
@@ -26,11 +26,11 @@ void vdo_submit_data_vio(struct data_vio *data_vio);
 
 void __submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 			   bio_end_io_t callback, vdo_action_fn error_handler,
-			   unsigned int operation, char *data);
+			   blk_opf_t operation, char *data);
 
 static inline void vdo_submit_metadata_vio(struct vio *vio, physical_block_number_t physical,
 					   bio_end_io_t callback, vdo_action_fn error_handler,
-					   unsigned int operation)
+					   blk_opf_t operation)
 {
 	__submit_metadata_vio(vio, physical, callback, error_handler,
 			      operation, vio->data);
diff --git a/drivers/md/dm-vdo/vio.c b/drivers/md/dm-vdo/vio.c
index 6acaba149c75..f9c54ec56176 100644
--- a/drivers/md/dm-vdo/vio.c
+++ b/drivers/md/dm-vdo/vio.c
@@ -172,7 +172,7 @@ void free_vio(struct vio *vio)
 
 /* Set bio properties for a VDO read or write. */
 void vdo_set_bio_properties(struct bio *bio, struct vio *vio, bio_end_io_t callback,
-			    unsigned int bi_opf, physical_block_number_t pbn)
+			    blk_opf_t bi_opf, physical_block_number_t pbn)
 {
 	struct vdo *vdo = vio->completion.vdo;
 	struct device_config *config = vdo->device_config;
@@ -193,7 +193,7 @@ void vdo_set_bio_properties(struct bio *bio, struct vio *vio, bio_end_io_t callb
  * vio associated with the bio.
  */
 int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
-		  unsigned int bi_opf, physical_block_number_t pbn)
+		  blk_opf_t bi_opf, physical_block_number_t pbn)
 {
 	int bvec_count, offset, len, i;
 	struct bio *bio = vio->bio;
diff --git a/drivers/md/dm-vdo/vio.h b/drivers/md/dm-vdo/vio.h
index 71585424f85b..fbfee5e3415d 100644
--- a/drivers/md/dm-vdo/vio.h
+++ b/drivers/md/dm-vdo/vio.h
@@ -119,10 +119,10 @@ static inline void initialize_vio(struct vio *vio, struct bio *bio,
 }
 
 void vdo_set_bio_properties(struct bio *bio, struct vio *vio, bio_end_io_t callback,
-			    unsigned int bi_opf, physical_block_number_t pbn);
+			    blk_opf_t bi_opf, physical_block_number_t pbn);
 
 int vio_reset_bio(struct vio *vio, char *data, bio_end_io_t callback,
-		  unsigned int bi_opf, physical_block_number_t pbn);
+		  blk_opf_t bi_opf, physical_block_number_t pbn);
 
 void update_vio_error_stats(struct vio *vio, const char *format, ...)
 	__printf(2, 3);
-- 
2.42.0

