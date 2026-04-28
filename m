Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EF9800
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 18:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777401577; cv=none; b=tKOy6IsaoreSxouTUZfHmrxtkfxfEg0sQ48L+kBcSLDmSxdldrDJ/8zxgiJDxCnTI0/UTtZbjSAMXV9/NPkNS+JhseLKj4zTSPNrvfkL08S4GmSHGsKQnbWbhHvkzqABwJ+WyXT0++dbDOIDBg4++7mu+LEXcfIdkliQgeZp97Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777401577; c=relaxed/simple;
	bh=LLSX6weWp+HttbybJNgB4XWOZlBLMZztrcLKftSW5GE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=j4yUHuLr7+7fn41TuFsp1ynMkN0jwoeQmXbDqMnOh/apeTLPVH+dHVs6B7CZh/oLYCf1FMyYdCoLPzcUObgTURXA7P4sK56QZFoyEG/r78CcwUDTsWJuCFH/iHRKIS2HgtcxoOxsh47N/o8E1i977mPpvT0Hpolf/MgPgyrBTFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jKLG1ClI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jKLG1ClI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777401575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eJ9rBoV4g9eqGEvAY4WQ/YQ7TAnqvfhT1b6VKAGkIQg=;
	b=jKLG1ClIHBWjBZWbsWpJdQyZtvkC8esL88FKThgu8jiYQXpHR/ShU1qmiazNCyBKqMkfh9
	OvediAfvqGtBDctHdP/KyxJQpnCnOsawU92C8yH4CJmeM7mGYhbjpSeJzODVoflUKTMqql
	t37NEkK5Ik8tPP8UHGicNK0BlN+oDjE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-412-ciPRuqoZOMGxE19oe8J1Ow-1; Tue,
 28 Apr 2026 14:39:33 -0400
X-MC-Unique: ciPRuqoZOMGxE19oe8J1Ow-1
X-Mimecast-MFC-AGG-ID: ciPRuqoZOMGxE19oe8J1Ow_1777401572
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 975B019560AB
	for <dm-devel@lists.linux.dev>; Tue, 28 Apr 2026 18:39:32 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (ci-vm-10-0-103-170.hosted.upshift.rdu2.redhat.com [10.0.103.170])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4A195180047F;
	Tue, 28 Apr 2026 18:39:32 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id BB1C2F3F1; Tue, 28 Apr 2026 14:39:31 -0400 (EDT)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Bruce Johnston <bjohnsto@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: use GFP_NOIO for blkdev_issue_zeroout on format path
Date: Tue, 28 Apr 2026 14:39:31 -0400
Message-ID: <c35a7057358503e4bbdf9514b0a1b2aef264179c.1777401374.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: bXZxOFqRQvcnqRa8jk7Vkx8UF_lKmC5yLACoq39u1V0_1777401572
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Bruce Johnston <bjohnsto@redhat.com>

GFP_NOWAIT is inappropriate when blkdev_issue_zeroout may sleep and
bio_alloc can fail under pressure; use GFP_NOIO for clear_partition and
vdo_clear_layout zeroout calls.

Signed-off-by: Bruce Johnston <bjohnsto@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/vdo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-vdo/vdo.c b/drivers/md/dm-vdo/vdo.c
index 7bec2418c121..d0d4e0262be2 100644
--- a/drivers/md/dm-vdo/vdo.c
+++ b/drivers/md/dm-vdo/vdo.c
@@ -965,7 +965,7 @@ static int __must_check clear_partition(struct vdo *vdo, enum partition_id id)
 	return blkdev_issue_zeroout(vdo_get_backing_device(vdo),
 				    partition->offset * VDO_SECTORS_PER_BLOCK,
 				    partition->count * VDO_SECTORS_PER_BLOCK,
-				    GFP_NOWAIT, 0);
+				    GFP_NOIO, 0);
 }
 
 int vdo_clear_layout(struct vdo *vdo)
@@ -976,7 +976,7 @@ int vdo_clear_layout(struct vdo *vdo)
 	result = blkdev_issue_zeroout(vdo_get_backing_device(vdo),
 				      VDO_SECTORS_PER_BLOCK,
 				      VDO_SECTORS_PER_BLOCK,
-				      GFP_NOWAIT, 0);
+				      GFP_NOIO, 0);
 	if (result != VDO_SUCCESS)
 		return result;
 
-- 
2.53.0

