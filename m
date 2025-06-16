Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1049C8EB
	for <dm-devel@lists.linux.dev>; Mon, 16 Jun 2025 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750085417; cv=none; b=eUO+d6JvxnlsuMGOFkJP7Eb6msK+Fe5CBXJk9Pi2PnxmJNwhyv6Sj9CRj7RimcUAAYpUtFLVlG8eWbE46gYS8D1EnmSsk4MXAhLgxwFYSfArftbLClC6qmfxI20zgquGgRzwHVJWf95bKgoMFGzgLo8+03D9VKjgGSgP+ZaceOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750085417; c=relaxed/simple;
	bh=PvIHeguMqYY4lWn+cjhIifQLS4CW9KKjvP6Lo91SxcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=MWLrhLcQu0fY08VhMtNBwGMOXU7rwp4gtOkF3OO3ePxmC7EU3PA9FIhqvzd8/1ycDiuW8ljm7bkpJ9+KQUn1syNMJ+P+a/UOK+oniOY6m+kEAsBC7IzeTPWXLkBoqcPRxRdkkuLmwwAEGg0qtArukS5aNQwGv484vq0P1sI/pDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iyqqI8CY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iyqqI8CY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750085413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=J/PxVmxkmFmzqe5Z56Mw4oSUB9aJtDm5+i/aDUpcoms=;
	b=iyqqI8CYiMiOw/ZeOLJLXdSCBvJipaFaU1HXPc1ZkuouXsgdk1ETR56QN34c8NHqETzBDF
	p9dmcgRdkmjhSKq5KLrFpmj9fMvb6BDe7sJeVH/lBIv2Qm4UALeo7G0l4xXn0qABUqCAA8
	sxGHhNOuLG8meW35CijvVlETwvYHPMQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-12-RPVvvS_5MHWiLOBVcGGKmg-1; Mon,
 16 Jun 2025 10:50:10 -0400
X-MC-Unique: RPVvvS_5MHWiLOBVcGGKmg-1
X-Mimecast-MFC-AGG-ID: RPVvvS_5MHWiLOBVcGGKmg_1750085409
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B7BF19560BA
	for <dm-devel@lists.linux.dev>; Mon, 16 Jun 2025 14:50:09 +0000 (UTC)
Received: from o.redhat.com (unknown [10.45.226.210])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D6E5D19560A3;
	Mon, 16 Jun 2025 14:50:07 +0000 (UTC)
From: heinzm@redhat.com
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com
Subject: [PATCH] dm raid: add support for resync w/o metadata devices
Date: Mon, 16 Jun 2025 16:50:05 +0200
Message-ID: <1609b0317c5776b4228fc65d06700ec9bcc547ce.1750078622.git.heinzm@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TZGfja-oWhc2qFpgeGYAOSIt_WOLDC8tUIWMmeqwNdY_1750085409
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Heinz Mauelshagen <heinzm@redhat.com>

Target does not honour the "sync" argument when activated w/o metadata
devices, e.g. with table line:
"0 $(blockdev --getsz $data1) raid raid1 2 0 sync 2 - $data1 - $data2".

Fix this to support temporary, transient raid devices useful
for data duplication.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 99e15a005bfb..435b366224f0 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2532,6 +2532,10 @@ static int analyse_superblocks(struct dm_target *ti, struct raid_set *rs)
 	struct md_rdev *rdev, *freshest;
 	struct mddev *mddev = &rs->md;
 
+	/* Respect resynchronization requested with "sync" argument. */
+	if (test_bit(__CTR_FLAG_SYNC, &rs->ctr_flags))
+		set_bit(MD_ARRAY_FIRST_USE, &mddev->flags);
+
 	freshest = NULL;
 	rdev_for_each(rdev, mddev) {
 		if (test_bit(Journal, &rdev->flags))
-- 
2.49.0

