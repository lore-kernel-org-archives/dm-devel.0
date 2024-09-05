Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332621C2E
	for <dm-devel@lists.linux.dev>; Thu,  5 Sep 2024 18:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725560858; cv=none; b=q7tLRkaBcSJfJGIjgQZ46f3jsi68OQWKJ9yfzwFzrhnWS6l7cZldnKKPwZwqmd+sO2eUKjxYq9ms6bgHZ02J2onRX2DVnVCFbW7R+ph+NmPTPkLAjyTtiz8y8NYIwoJpKV1McqW1NyJP4hqX+a5dqEc0jy2pJNOyYciRjF/Bwfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725560858; c=relaxed/simple;
	bh=uNd/iGAt9jV52YpQsEIPrS0SyjdqfqxcMvqnMHBfGtA=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=LG5zy5qW6QXVGNNVud/FolIn2sFtgNW4I2fRSRDAWexBWtgd3bEXmDbF2dX7XHBU7vaadDQ39pHaYlZC9jVe796fLX6ogupdQ3xOwvPZKJ6SQvB9pIgyfMxM4Z+5V7I+vFv7nacKmTd2xHn/Nb15qENr1JOP+dpbhxD8Vbjo/4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cl4uh/Hj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cl4uh/Hj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725560856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=pBwTzRxpKr/e2BBe8urLQSQ//qz15pgHg8+4kLvxmRE=;
	b=Cl4uh/Hjd+BqDMFG3xet46n0MGZPA9zD5n3l33ZTrFQpm1wSr849/VleCbE9nQXd8AmGa1
	bFSsOfJZeQ/RYpSVeOI9Kr1aYMzxZsZ/LVrosRe/HBR4Wfo5ZLNBFkK+H5eUyKccMExknX
	v3XAA8zHQHz7HLF55eGNsA26Bu04vS0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-Gs-JyaW5Oq-Hus7l2XsekQ-1; Thu,
 05 Sep 2024 14:27:32 -0400
X-MC-Unique: Gs-JyaW5Oq-Hus7l2XsekQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E02471955F06;
	Thu,  5 Sep 2024 18:27:31 +0000 (UTC)
Received: from [10.45.224.222] (unknown [10.45.224.222])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FF681956048;
	Thu,  5 Sep 2024 18:27:30 +0000 (UTC)
Date: Thu, 5 Sep 2024 20:27:25 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-integrity: fix a race condition when accessing
 recalc_sector
Message-ID: <45abc60c-25dd-4416-48be-72eb41390588@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There's a race condition when accessing the variable
ic->sb->recalc_sector. The function integrity_recalc writes to this
variable when it makes some progress and the function
dm_integrity_map_continue may read this variable concurrently.

One problem is that on 32-bit architectures the 64-bit variable is not
read and written atomically - it may be possible to read garbage if read
races with write.

Another problem is that memory accesses to this variable are not guarded
with memory barriers.

This commit fixes the race - it moves reading ic->sb->recalc_sector to an
earlier place where we hold &ic->endio_wait.lock.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-integrity.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2024-09-04 20:42:25.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2024-09-04 22:32:01.000000000 +0200
@@ -2174,6 +2174,7 @@ static void dm_integrity_map_continue(st
 	struct bio *bio = dm_bio_from_per_bio_data(dio, sizeof(struct dm_integrity_io));
 	unsigned int journal_section, journal_entry;
 	unsigned int journal_read_pos;
+	sector_t recalc_sector;
 	struct completion read_comp;
 	bool discard_retried = false;
 	bool need_sync_io = ic->internal_hash && dio->op == REQ_OP_READ;
@@ -2314,6 +2315,7 @@ offload_to_thread:
 			goto lock_retry;
 		}
 	}
+	recalc_sector = le64_to_cpu(ic->sb->recalc_sector);
 	spin_unlock_irq(&ic->endio_wait.lock);
 
 	if (unlikely(journal_read_pos != NOT_FOUND)) {
@@ -2368,7 +2370,7 @@ offload_to_thread:
 	if (need_sync_io) {
 		wait_for_completion_io(&read_comp);
 		if (ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING) &&
-		    dio->range.logical_sector + dio->range.n_sectors > le64_to_cpu(ic->sb->recalc_sector))
+		    dio->range.logical_sector + dio->range.n_sectors > recalc_sector)
 			goto skip_check;
 		if (ic->mode == 'B') {
 			if (!block_bitmap_op(ic, ic->recalc_bitmap, dio->range.logical_sector,

