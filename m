Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525A12DFA51
	for <dm-devel@lists.linux.dev>; Tue, 15 Apr 2025 04:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744690645; cv=none; b=fZ7qBUwJLZcNY2nNj+xwB75+R4/gENY7K+3VbC8io6NJ6fFzw1Wd6T7QhhRLiqgbeF2ifVlI6qAdvvyAltV/n1Dph2y/1FwYThEMMEE8PmLUNSq819qo6OQffD722Ci3FNK3LUiINMQJjCA6kNPog5g8ypYv90Xa83m+3I7SBQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744690645; c=relaxed/simple;
	bh=9hA0V/DsZSiXOJJYJHTZ1IqgYghcVyiXq2YYWgjJkUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=MSGGUO0X2OEsfZGj9+p5wLGSn/Zv4Paz7Sx5QByuFGO/L9nDwRgwUUBOgZJQSlSXwV+lhdlLPt6bU5CXSdN/RZ9yesiXbHpMMVQH5M+W/ID5GzR5JP9iQ8s2frsdhWm/O1NWCNC25Z+FJzCN8pu30EBtPXMJ2xxnw5csNeNFi3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I8a4yidF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I8a4yidF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744690641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1xa8Y7qxBaMO++3ahJv6Ukul316M0IYNo4Gh7IDiQYg=;
	b=I8a4yidF+YhS45cDCoUjA/AyJ0mQ2GWjRUN0ujHWIrrkJ03VbB4Nl5XDRE/U9vkBF6RfBD
	PL2udJ/bqtxjyeEzOyPSut+Tl+5bA6CHbvtmiWRcD+w8cSwodwmvz5rrTOAnYXFi3APHe5
	Mwtza/leTeCchMvBzCNKm7kciB07YRo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-4KbYJfBrOraVvMlaSZqBqw-1; Tue,
 15 Apr 2025 00:17:20 -0400
X-MC-Unique: 4KbYJfBrOraVvMlaSZqBqw-1
X-Mimecast-MFC-AGG-ID: 4KbYJfBrOraVvMlaSZqBqw_1744690639
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C2CFF1956089
	for <dm-devel@lists.linux.dev>; Tue, 15 Apr 2025 04:17:19 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBE37180B488;
	Tue, 15 Apr 2025 04:17:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53F4HHfK657023
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 00:17:17 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53F4HHqF657022;
	Tue, 15 Apr 2025 00:17:17 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/2] dm: remove unneeded kvfree from alloc_targets
Date: Tue, 15 Apr 2025 00:17:15 -0400
Message-ID: <20250415041716.657008-2-bmarzins@redhat.com>
In-Reply-To: <20250415041716.657008-1-bmarzins@redhat.com>
References: <20250415041716.657008-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kyuwjBTPH6dlr1bRgfmXzj218dCXATzy87nIuiSF_nU_1744690639
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

alloc_targets() is always called with a newly initialized table where
t->highs == NULL.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 69d4a0e0e613..31e2f9071ca8 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -117,7 +117,6 @@ static int alloc_targets(struct dm_table *t, unsigned int num)
 	n_targets = (struct dm_target *) (n_highs + num);
 
 	memset(n_highs, -1, sizeof(*n_highs) * num);
-	kvfree(t->highs);
 
 	t->num_allocated = num;
 	t->highs = n_highs;
-- 
2.48.1

