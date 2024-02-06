Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD525676F
	for <dm-devel@lists.linux.dev>; Tue,  6 Feb 2024 02:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707185067; cv=none; b=aaxCynLhHHGpW0HnlHy73P5mMtJpira2OuN1r6ATJgx286vKgwiKwpEnl1PNcIx2S+JsueQXPDVSY64DxgXQPCSdkMCYyxjhpPehbcx77UqUetWGmFyVzDoen+Snclwg/gaLy3FNMNSycyReVRVvm9gUDDW7MkHoZ5wwoPiabO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707185067; c=relaxed/simple;
	bh=9lxeS38XCTby4oJyeVz6gQP9cWYCtulttXM+6kSXcIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e8o4kcFgjxtJwW5D9GXYuVVvs+vPKoWFwk6dYGdlLxDCw+9Y1OGtRkt65GlMNTUj1FUd/MekUd8VpMcE0Q8Yrj7H/NwI/Z2kO140sT6xJVIafvwizHpvGjtBrC8BjEbKr8CCO95k6W8pscsqIH1ZMX2pYfuJ8aULdOyFno+QeaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DaKpyksl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DaKpyksl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707185064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7WnUIAtQDifd54KL6mFjc90R3SFnvGSNMhvNMhBfIlU=;
	b=DaKpykslWyt4vAQrA9MOVGAT4Iz3DMK7th/ZMLmle+Xu8GYnPZEJfovREactqkdSJj1cNo
	1EgbeniHGxxFMeImoxMRqDMcA0mK0JbMzEr3/AmHQq/epyrOMXgMRR/p/c0IJY8QnJXUzM
	7Yg3eawuSqDWbsUeW7bTjsuEiqxbARs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-b3DQYp_dMcalH_3lGPSTvQ-1; Mon, 05 Feb 2024 21:04:23 -0500
X-MC-Unique: b3DQYp_dMcalH_3lGPSTvQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B180187B2A1;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ABEA2492BF0;
	Tue,  6 Feb 2024 02:04:22 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id A92DF56A02; Mon,  5 Feb 2024 21:04:22 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 6/7] dm vdo recovery-journal: fix sparse 'mixed bitwiseness' warning
Date: Mon,  5 Feb 2024 21:04:21 -0500
Message-ID: <e7b0a9757bfa7f87d65292463d626815c7ce1c57.1707184413.git.msakai@redhat.com>
In-Reply-To: <cover.1707184413.git.msakai@redhat.com>
References: <cover.1707184413.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Only one user of WRITE_FLAGS so no need to factor it out in an enum
(which causes sparse's 'mixed bitwiseness' warning).  Just use the
flags in the only consumer.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/recovery-journal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/recovery-journal.c b/drivers/md/dm-vdo/recovery-journal.c
index a6981e5dd017..1e15bfe42cfc 100644
--- a/drivers/md/dm-vdo/recovery-journal.c
+++ b/drivers/md/dm-vdo/recovery-journal.c
@@ -34,7 +34,6 @@ enum {
 	 */
 	RECOVERY_JOURNAL_RESERVED_BLOCKS =
 		(MAXIMUM_VDO_USER_VIOS / RECOVERY_JOURNAL_ENTRIES_PER_BLOCK) + 2,
-	WRITE_FLAGS = REQ_OP_WRITE | REQ_PRIO | REQ_PREFLUSH | REQ_SYNC | REQ_FUA,
 };
 
 /**
@@ -1398,7 +1397,8 @@ static void write_block(struct vdo_waiter *waiter, void *context __always_unused
 	 * block itself is stable before allowing overwrites of the lbn's previous data.
 	 */
 	vdo_submit_metadata_vio(&block->vio, journal->origin + block->block_number,
-				complete_write_endio, handle_write_error, WRITE_FLAGS);
+				complete_write_endio, handle_write_error,
+				REQ_OP_WRITE | REQ_PRIO | REQ_PREFLUSH | REQ_SYNC | REQ_FUA);
 }
 
 
-- 
2.42.0

