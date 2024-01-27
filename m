Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4348DB666
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706323535; cv=none; b=P01MNgo2HtjFVZEAYvtienuqwLmSN589TkmuR9Be8kB9nHC/GCOUU9r96HIHmp/XlQDVT4ydMt7bI8QTztr4ek053uHh/yMlPfbhTZlkuYi3Pt+A5jut7XcFWuChSGjPqp9oFwZvopfmEf1ZeBv29+wINAAzMKsHyv5H/Vi9z0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706323535; c=relaxed/simple;
	bh=LeBZT+yV4nUbv7YPpIj0XnZnjyCFPZ+6sk+ek+NxDpM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hfWA1dI437OuGPlo15+uirfnFQc5jHpJz/XvZihewkV4M5BuCvWWTaVCKzoV5rDO5M1xN3CgIMaVD++9O/CMRzI4njdPqmpnZxIOFPCYDsMzbFBVm73ELImc8tH8Siyt0gbfAsaPjP6U6cSwMvSsjf3M+Z0SEf4iB0T8taLE5nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZFjf/Pgw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFjf/Pgw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706323533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+4RIuHgGZM3ANO+jHLBkTiDmQM7G/60iR96SW7Y2ZAE=;
	b=ZFjf/PgwaWTeIe0ZSmxa2SFXZAWBRMS5+MpEHfV5qseGCBD7wUhEex5clqlFMwhVblOUOr
	wa+Ix7qPhw3TcRKhkjKQQiU6DiHYQ9bV/L79TL1Z+r5azGSLpP1kqlspBwAckwWfpvRcsB
	fpGFqzreYo5d1ioIJvZr5/kENlHm8j8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-2LMTz2GJNTamKocfdkN1MA-1; Fri, 26 Jan 2024 21:45:31 -0500
X-MC-Unique: 2LMTz2GJNTamKocfdkN1MA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 440F583722B;
	Sat, 27 Jan 2024 02:45:31 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3D83E1C060AF;
	Sat, 27 Jan 2024 02:45:31 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 34965560DB; Fri, 26 Jan 2024 21:45:31 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo data-vio: rename is_trim flag to is_discard
Date: Fri, 26 Jan 2024 21:45:31 -0500
Message-ID: <b5dd81fcb9c4b19e471d2dd76deb20c80286a08c.1706323456.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Eliminate use of "trim" in favor of "discard" since it reflects the
top-level Linux discard primative rather than the ATA specific ditto.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c |  4 ++--
 drivers/md/dm-vdo/data-vio.c  | 16 ++++++++--------
 drivers/md/dm-vdo/data-vio.h  |  2 +-
 drivers/md/dm-vdo/types.h     |  2 +-
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 50dda7ae7074..54ad6939cab7 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -2194,8 +2194,8 @@ static void allocate_block_map_page(struct block_map_zone *zone,
 {
 	int result;
 
-	if (!data_vio->write || data_vio->is_trim) {
-		/* This is a pure read or a trim, so there's nothing left to do here. */
+	if (!data_vio->write || data_vio->is_discard) {
+		/* This is a pure read or a discard, so there's nothing left to do here. */
 		finish_lookup(data_vio, VDO_SUCCESS);
 		return;
 	}
diff --git a/drivers/md/dm-vdo/data-vio.c b/drivers/md/dm-vdo/data-vio.c
index 7d8100f29e13..328b645dee16 100644
--- a/drivers/md/dm-vdo/data-vio.c
+++ b/drivers/md/dm-vdo/data-vio.c
@@ -553,7 +553,7 @@ static void launch_bio(struct vdo *vdo, struct data_vio *data_vio, struct bio *b
 	if (bio_op(bio) == REQ_OP_DISCARD) {
 		data_vio->remaining_discard = bio->bi_iter.bi_size;
 		data_vio->write = true;
-		data_vio->is_trim = true;
+		data_vio->is_discard = true;
 		if (data_vio->is_partial) {
 			vdo_count_bios(&vdo->stats.bios_in_partial, bio);
 			data_vio->read = true;
@@ -1990,10 +1990,10 @@ static void handle_allocation_error(struct vdo_completion *completion)
 	handle_data_vio_error(completion);
 }
 
-static int assert_is_trim(struct data_vio *data_vio)
+static int assert_is_discard(struct data_vio *data_vio)
 {
-	int result = ASSERT(data_vio->is_trim,
-			    "data_vio with no block map page is a trim");
+	int result = ASSERT(data_vio->is_discard,
+			    "data_vio with no block map page is a discard");
 
 	return ((result == VDO_SUCCESS) ? result : VDO_READ_ONLY);
 }
@@ -2019,19 +2019,19 @@ void continue_data_vio_with_block_map_slot(struct vdo_completion *completion)
 
 	if (data_vio->tree_lock.tree_slots[0].block_map_slot.pbn == VDO_ZERO_BLOCK) {
 		/*
-		 * This is a trim for a block on a block map page which has not been allocated, so
+		 * This is a discard for a block on a block map page which has not been allocated, so
 		 * there's nothing more we need to do.
 		 */
 		completion->callback = complete_data_vio;
-		continue_data_vio_with_error(data_vio, assert_is_trim(data_vio));
+		continue_data_vio_with_error(data_vio, assert_is_discard(data_vio));
 		return;
 	}
 
 	/*
-	 * We need an allocation if this is neither a full-block trim nor a
+	 * We need an allocation if this is neither a full-block discard nor a
 	 * full-block zero write.
 	 */
-	if (!data_vio->is_zero && (!data_vio->is_trim || data_vio->is_partial)) {
+	if (!data_vio->is_zero && (!data_vio->is_discard || data_vio->is_partial)) {
 		data_vio_allocate_data_block(data_vio, VIO_WRITE_LOCK, allocate_block,
 					     handle_allocation_error);
 		return;
diff --git a/drivers/md/dm-vdo/data-vio.h b/drivers/md/dm-vdo/data-vio.h
index f5a683968d1c..78744d064e96 100644
--- a/drivers/md/dm-vdo/data-vio.h
+++ b/drivers/md/dm-vdo/data-vio.h
@@ -199,7 +199,7 @@ struct data_vio {
 	u16 write : 1;
 	u16 fua : 1;
 	u16 is_zero : 1;
-	u16 is_trim : 1;
+	u16 is_discard : 1;
 	u16 is_partial : 1;
 	u16 is_duplicate : 1;
 	u16 first_reference_operation_complete : 1;
diff --git a/drivers/md/dm-vdo/types.h b/drivers/md/dm-vdo/types.h
index abc6d36f6522..dbe892b10f26 100644
--- a/drivers/md/dm-vdo/types.h
+++ b/drivers/md/dm-vdo/types.h
@@ -144,7 +144,7 @@ struct block_map_slot {
 
 /*
  * Four bits of each five-byte block map entry contain a mapping state value used to distinguish
- * unmapped or trimmed logical blocks (which are treated as mapped to the zero block) from entries
+ * unmapped or discarded logical blocks (which are treated as mapped to the zero block) from entries
  * that have been mapped to a physical block, including the zero block.
  *
  * FIXME: these should maybe be defines.
-- 
2.42.0

