Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E421C233E
	for <dm-devel@lists.linux.dev>; Thu, 12 Sep 2024 21:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726177799; cv=none; b=fJzm6koxWSC51W4fybvZu9hhPJjcaRxg49KjKWHSdW+URmS/qNAMQmbWdw8niLngUiAGbxr8F4xXhvqVHszmypQ/j4Gs93DT0bGjDrRHz+n77V7Rv9M8R2a800X2F8gH9j1bXGqeMNppjRd6D/xAFpgjOnCB+61HFxQbeZBnJZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726177799; c=relaxed/simple;
	bh=nBAbawU13rHbn0wEyOtko4v85E22fr8wXL99qhRkffA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kRddQdygAaGf9yvUvmBV84cOupLx8qvh+6w0WNe18I27e5RgiAFKabAKlcS0FIQKvMzVGiJ+9ejy+8ulYt9/xYeXnJxwFBXs3OzX+y3KAezIiULeZSzsX8Z8ktI76cnFN2xsp3uEdmR2WfpAvWvaKKkR6smwdPoPwsgDVKwfr9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HI06eQPX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HI06eQPX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726177796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6QypsCPFPC6HaEOH3iL+JGWsgJ69mI4wi8sgy5TpmlI=;
	b=HI06eQPXebzaa1oP4DhkIeOHDLEl0XnhD/qqqjNwL7M4s5myvTPw5N6i0YGugfW0ShCy4O
	OFEZmklf/WfQrODTxQoCkJvBSKl6/xiS8nC/dNkPABucIAVjfuWKbM7X4DX/79zoL7M1A6
	loP2jfaKUYcyyJMQOYUcibezOlX3ndU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-544-rSjbzSXfNri9jLQjATxC0w-1; Thu,
 12 Sep 2024 17:49:53 -0400
X-MC-Unique: rSjbzSXfNri9jLQjATxC0w-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B162F1955F41;
	Thu, 12 Sep 2024 21:49:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4F86F19560B7;
	Thu, 12 Sep 2024 21:49:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 48CLnoSt783910
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 12 Sep 2024 17:49:50 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 48CLnoL4783909;
	Thu, 12 Sep 2024 17:49:50 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@lists.linux.dev>,
        Martin Wilck <Martin.Wilck@suse.com>
Subject: [PATCH v2 15/22] multipathd: simplify checking for followover_should_failback
Date: Thu, 12 Sep 2024 17:49:40 -0400
Message-ID: <20240912214947.783819-16-bmarzins@redhat.com>
In-Reply-To: <20240912214947.783819-1-bmarzins@redhat.com>
References: <20240912214947.783819-1-bmarzins@redhat.com>
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

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 multipathd/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/multipathd/main.c b/multipathd/main.c
index 3cda3c18..75bc0620 100644
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

