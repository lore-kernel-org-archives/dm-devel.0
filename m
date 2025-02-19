Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4202D25B691
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 22:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740005770; cv=none; b=HRvVQEKQipryG7Nu058/ikU7C+Ctcdo0gYDEOmp8IYZKT0fMOrEZL0DbGQi3B9J3gHgDM5oeekgZWS96K3kvP4OSFjT7kI0hOicmqDNJEJnHtXdjEjXHPpeGbHD9Yi3FEnnM8LfmMADN6WQ7mrmznuZzGwP1LeOErvmsdmHI+6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740005770; c=relaxed/simple;
	bh=I1HORS5H9+LFVll1wNddt00dD3Oq9J1Su2N7de2FAkU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=o9pRLQt64sbpAbWZ+OItp/FPaflOmo0FzLW+afoT3vcB9Pu6E5/9YsK6yHY6+R4BWIW6U5vHTNttXLKjPhzVwSzz028Sw8DToOmdJSqKE7Q6/Pg3ttw0McCLUvu8gSxPqtF6wzB6OYoBjLvBOKWGdkIqAOUJGxs1SLe/fYCVw1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GpHiXxBz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GpHiXxBz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740005764;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=gtonkgZBlUATNdGRZqwji/PIR+krVqIJ1U9VRjfL9bs=;
	b=GpHiXxBz7zyDNoB5uUJGd2stKrUwvMc5iV2s9ZWpr2pq55Qu5rocg7poif68KA/vMwJWoQ
	Eej1r2d+rOyubMNQehumJ2qqKB/MchBlSfMVM2K2nSAWdhWpMoU4pAlwsoZuf0frL0pIEs
	3EQUFBza1LPBVNfErrUXdcp7Trq5Iz4=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-219-xOovmUS_ONGhhYlsWHSDwA-1; Wed,
 19 Feb 2025 17:56:02 -0500
X-MC-Unique: xOovmUS_ONGhhYlsWHSDwA-1
X-Mimecast-MFC-AGG-ID: xOovmUS_ONGhhYlsWHSDwA_1740005762
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C9AAD196E078
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 22:56:01 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (unknown [10.0.103.170])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 28B6B30001A6;
	Wed, 19 Feb 2025 22:56:01 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 6203C60395; Wed, 19 Feb 2025 17:56:00 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH] dm vdo: add missing spin_lock_init
Date: Wed, 19 Feb 2025 17:56:00 -0500
Message-ID: <20250219225600.1335953-1-msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: U-FlM_QE1diDji355WuJwDWzG5pgrNxfjP4_FoMLxzA_1740005762
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

From: Ken Raeburn <raeburn@redhat.com>

Signed-off-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/dedupe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-vdo/dedupe.c b/drivers/md/dm-vdo/dedupe.c
index 00fff21b8058..5c49d49e023c 100644
--- a/drivers/md/dm-vdo/dedupe.c
+++ b/drivers/md/dm-vdo/dedupe.c
@@ -2178,6 +2178,7 @@ static int initialize_index(struct vdo *vdo, struct hash_zones *zones)
 
 	vdo_set_dedupe_index_timeout_interval(vdo_dedupe_index_timeout_interval);
 	vdo_set_dedupe_index_min_timer_interval(vdo_dedupe_index_min_timer_interval);
+	spin_lock_init(&zones->lock);
 
 	/*
 	 * Since we will save up the timeouts that would have been reported but were ratelimited,
-- 
2.45.2

