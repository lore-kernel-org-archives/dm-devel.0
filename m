Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4DD22D782
	for <dm-devel@lists.linux.dev>; Fri, 30 May 2025 14:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748616640; cv=none; b=oOV7N0hw0Ptu9iPICTxWyLqzQzUDr+Bh7j7CSu4ljcVIQ8aw/SDJa/gFpfH5XJm5O1gP765GjrK0jMrOGpgtzT6qqTputXKmmw6pAhVWl4x0WfPC3KbuNOdt/F0kRMU50KC7w3miqTJiK24OD4v+FhE5usNMzgEOKL2xrF0SFDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748616640; c=relaxed/simple;
	bh=59Ik02KL1xyog1VQArbr6Mkzs3CwdYDyLbdarXcs4Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=bwDiUsYMUjq52/jEx0RGW58C1LgsUGlRYWxzLg3ft5g5SVh6UIyhEO98gVqth5X0wZV2p/Ap0JLb42EksExEhiukfg9tPhxjh1bwk/E2tXb0uod6X1pSGOV1kvR1qeQsNej5TRZw+AFKHyOFb7SJKwQO1xGPR8tuzCt25+ZjyDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RYWJTkzQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RYWJTkzQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748616637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/SdgpoUFCu3i23eteKKdFA+wWoBMT2js4G6tLpbDH0U=;
	b=RYWJTkzQAVZqTP1rK38hA5lLV/KtY4hzUtOtMYEbru7BFLIt4h68sKaN+J5uQGNGwUlxe5
	CuwC2LUxYUe3NYVhnqn3uREtLTfrIHrTHHu/T4rrqkabpgdINMkabj0TbOljFyFmJQfHHe
	rMGr3UR8Jq2QVkwnp+dGu/7/8dy2kYc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-GjgMC-8bM0mTrQu--6qIjQ-1; Fri,
 30 May 2025 10:50:36 -0400
X-MC-Unique: GjgMC-8bM0mTrQu--6qIjQ-1
X-Mimecast-MFC-AGG-ID: GjgMC-8bM0mTrQu--6qIjQ_1748616635
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F55419560A0;
	Fri, 30 May 2025 14:50:35 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5858180049D;
	Fri, 30 May 2025 14:50:34 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54UEoXZu1491286
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 30 May 2025 10:50:33 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54UEoWLl1491285;
	Fri, 30 May 2025 10:50:32 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, John Garry <john.g.garry@oracle.com>
Subject: [PATCH] dm-table: check BLK_FEAT_ATOMIC_WRITES inside limits_lock
Date: Fri, 30 May 2025 10:50:32 -0400
Message-ID: <20250530145032.1491277-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Q-cvf0Zaq0XpYkUMp6lvmc5OKd6RoZyo5ZfriE_6OQE_1748616635
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm_set_device_limits() should check q->limits.features for
BLK_FEAT_ATOMIC_WRITES while holding q->limits_lock, like it does for
the rest of the queue limits.

Fixes: b7c18b17a173 ("dm-table: Set BLK_FEAT_ATOMIC_WRITES for target queue limits")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 57573e8b5aa9..9f95f77687ef 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -430,13 +430,13 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 	}
 
+	mutex_lock(&q->limits_lock);
 	/*
 	 * BLK_FEAT_ATOMIC_WRITES is not inherited from the bottom device in
 	 * blk_stack_limits(), so do it manually.
 	 */
 	limits->features |= (q->limits.features & BLK_FEAT_ATOMIC_WRITES);
 
-	mutex_lock(&q->limits_lock);
 	if (blk_stack_limits(limits, &q->limits,
 			get_start_sect(bdev) + start) < 0)
 		DMWARN("%s: adding target device %pg caused an alignment inconsistency: "
-- 
2.48.1

