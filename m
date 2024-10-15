Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C7C170A29
	for <dm-devel@lists.linux.dev>; Tue, 15 Oct 2024 03:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728962926; cv=none; b=aKwiGioBe7DvprUu/dGJsh6MVkrgMEZ1HqT0IggG6pS0w9u8860ZT2nmmM7O03XfD8OKzqk6TEBbTrBhVW4/6OT4oez2KhoPw1FHjIyTmNxdQlC75MnIcfeWiUuYeY3N3WV6G4KOmJJjJY/o2gMHxzaMwleP0QcCCKG2fdR5JCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728962926; c=relaxed/simple;
	bh=TVueBc3knMc5YbTSIAYV3r+I9/3bai/9AUTG9nnnTEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BTRgJMIuyvy30Q+jD+Fa2NhBAtWisseAK+g6BlJeGbWtRFP1CZRi9JzyRdh4sHUrXG4MD94xdfRhpNJH4BYtjKA1+tR7LxnX+LHfb4bJHR1JikKKd2aXvIpN5zHqMmfbYiPo68KAdAdgK0P1gCFsp/t+3rHdVOnd1wJ7Dps12cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hbudSlWx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hbudSlWx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728962923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GRzj54dB3uT+CxggsXo/PP5NtZgRtoGn5Aag07Cnl9A=;
	b=hbudSlWxPu/bqE2O/mEtxnzqOvH0JXmJMxTfrfK+KDXWB4eh8Dq+UO3HkLQJNl+G3wR98G
	1n/FsRaPt6gjtfyEatLX8ThY9HDXSSldVgQ/I+chVx7gfrHAkxgksyh1Bs35IO0qfi98+5
	Z+qT5WhWUXXL+FHT2N4d3cf5e6nQwrU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-uGhWESlDO6uHrR5S4Pb73w-1; Mon,
 14 Oct 2024 23:28:40 -0400
X-MC-Unique: uGhWESlDO6uHrR5S4Pb73w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5619B195608C;
	Tue, 15 Oct 2024 03:28:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2110719560A2;
	Tue, 15 Oct 2024 03:28:39 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 49F3Sbwc2693339
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Oct 2024 23:28:37 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 49F3SbjX2693338;
	Mon, 14 Oct 2024 23:28:37 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>, Martin Wilck <mwilck@suse.com>
Subject: [PATCH v5 15/23] multipathd: simplify checking for followover_should_failback
Date: Mon, 14 Oct 2024 23:28:27 -0400
Message-ID: <20241015032835.2693247-16-bmarzins@redhat.com>
In-Reply-To: <20241015032835.2693247-1-bmarzins@redhat.com>
References: <20241015032835.2693247-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

The code needs to check that pp->pgindex equals pp->mpp->bestpg and that
they aren't both 0 (which is an invalid pathgroup id). Since we're
already checking that they are equal, we only need to check one of them
to see if it's non-zero. Instead of checking if pp->pgindex is non-zero
for every path, just check mpp->bestpg once for the multipath device and
return immediately if it's zero.

Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index f48dbe25..ea4adac8 100644
--- a/multipathd/main.c
+++ b/multipathd/main.c
@@ -2002,7 +2002,7 @@ do_followover_should_failback(struct path * pp)
 	struct path *pp1;
 	int i;
 
-	if (!pp->pgindex || pp->pgindex != pp->mpp->bestpg)
+	if (pp->pgindex != pp->mpp->bestpg)
 		return 0;
 
 	pgp = VECTOR_SLOT(pp->mpp->pg, pp->pgindex - 1);
@@ -2022,7 +2022,7 @@ followover_should_failback(struct multipath *mpp)
 	struct pathgroup * pgp;
 	int i, j;
 
-	if (mpp->pgfailback != -FAILBACK_FOLLOWOVER || !mpp->pg)
+	if (mpp->pgfailback != -FAILBACK_FOLLOWOVER || !mpp->pg || !mpp->bestpg)
 		return 0;
 
 	vector_foreach_slot (mpp->pg, pgp, i) {
-- 
2.45.0

