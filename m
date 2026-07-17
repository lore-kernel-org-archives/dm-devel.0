Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A92C314D35
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 16:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784304077; cv=none; b=ZjOoHvPBs1pvo2Xt/nE2VMO7wv0+3fVL4Xd6uN9dEL4MvtvzRDnh2TmdfcYmaIvfv3OQyXKSJnyMkNG1KWn38wD104TSWk9YZJBPgUlHHxzRgcREkm7l+/drpMaSlMVk+l1WMBcSPXnJwPwNHABkI2+unZ509HvWuQsTBiK5g9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784304077; c=relaxed/simple;
	bh=CV+b1mGM4CL0QbFuui7pfIxlQYePQ5TQCCbzuMQZd8U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=uqDsFPfTNas9tviddsnQ7D35MO92/6vIcHa8J8+n/hFHB4sahH10vzNdlhbHlfNBhJswb6BZREc4u++q0nnYGXUW5ViTMMFPRC2wAxzgS9GiyBNkaAZMWMU3LaBuy4z+00KFBzSpeAapIBg6Ztm1GG3VG6X+108kKSemT0EUzJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DomusJMK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DomusJMK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784304075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aOFouLRnJiIAp3snfrtYeUt+ZFUNanSxfffcJ9k3RRk=;
	b=DomusJMKRPWFKJMYkhz3XVAMFAtszbSEzLEArm24dvl6L5eEWxfqBDVomVj5X3z9ZHtcVZ
	8XS9uQpXcOX+MQYIdCR6/kgqI6+OtUCPZIMnYwV4EBtUDUlDkY8BZVvXUvL82VA+FANs/I
	1g9kogHQr9W0USX4L2iem+5e5vG0mig=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-468-vxyUSeWGOK6tSxWIm5tQYQ-1; Fri,
 17 Jul 2026 12:01:12 -0400
X-MC-Unique: vxyUSeWGOK6tSxWIm5tQYQ-1
X-Mimecast-MFC-AGG-ID: vxyUSeWGOK6tSxWIm5tQYQ_1784304072
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCB3C1954B27
	for <dm-devel@lists.linux.dev>; Fri, 17 Jul 2026 16:01:11 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (ci-vm-10-0-103-170.hosted.upshift.rdu2.redhat.com [10.0.103.170])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B17A5180025F;
	Fri, 17 Jul 2026 16:01:11 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 3D3CB20BF2; Fri, 17 Jul 2026 12:01:11 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: don't read repair field in loop condition
Date: Fri, 17 Jul 2026 12:01:11 -0400
Message-ID: <db6850416670928dece4ac4eec7bc3af2e543b0d.1784303851.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: suTKO7TOUD38-SRFU-BINLhQkIMGokXGg3G1asVEkgE_1784304072
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Respell the vio launch loop to use the existing vio_count
value. The repair completion is not guaranteed to persist
after all of the metadata_vios are launched. This can not
currently cause problems due to the way vio callbacks are
handled, but it is technically not safe to access those
fields.

Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/repair.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-vdo/repair.c b/drivers/md/dm-vdo/repair.c
index bfed62260280..e5263a5716f6 100644
--- a/drivers/md/dm-vdo/repair.c
+++ b/drivers/md/dm-vdo/repair.c
@@ -1696,6 +1696,7 @@ void vdo_repair(struct vdo_completion *parent)
 	struct vdo *vdo = parent->vdo;
 	struct recovery_journal *journal = vdo->recovery_journal;
 	physical_block_number_t pbn = journal->origin;
+	block_count_t i;
 	block_count_t remaining = journal->size;
 	block_count_t vio_count = DIV_ROUND_UP(remaining, MAX_BLOCKS_PER_VIO);
 	page_count_t page_count = min_t(page_count_t,
@@ -1749,9 +1750,8 @@ void vdo_repair(struct vdo_completion *parent)
 		remaining -= blocks;
 	}
 
-	for (vio_count = 0; vio_count < repair->vio_count;
-	     vio_count++, pbn += MAX_BLOCKS_PER_VIO) {
-		vdo_submit_metadata_vio(&repair->vios[vio_count], pbn, read_journal_endio,
+	for (i = 0; i < vio_count; i++, pbn += MAX_BLOCKS_PER_VIO) {
+		vdo_submit_metadata_vio(&repair->vios[i], pbn, read_journal_endio,
 					handle_journal_load_error, REQ_OP_READ);
 	}
 }
-- 
2.53.0

