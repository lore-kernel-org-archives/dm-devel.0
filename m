Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46B223815B
	for <dm-devel@lists.linux.dev>; Fri,  3 Jul 2026 01:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783043026; cv=none; b=WV+PZTc2aQ5VUsL0VLs9ygoDpOLc6yrJ2fhcCSRB6BvpuGXCf1a0pjUOxJzKOxTtiXk6MG+lYA4nxHjG6PZYi8skKSEk1ujutmb3Ebew8NKpCvjS3B7VphNi6O/IhURf6h3OEC7Bg/OS1puz5jZEeJFpSH1PVuzhSnpEVn7CnK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783043026; c=relaxed/simple;
	bh=QP13FBwP9Nbr47wqD2WPlJh9kuzsfpqpB9CJ14gctOI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=tmXTKSNxA0crOW8Wkc29oSJZPix3w3S23m3Rk0/GGEy64h5q4PbvyLN4Gkso0CfRZWP2bOfECXbYgWCNuBS46QDBStfYPrYoshAXBlvf4blAvLHyrJMU7011pasOj3w46Jwn2ieUlNUl83r8QVX8fwFlUQr2pQI8H9DETlvya3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LWsT34n7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LWsT34n7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783043023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=L1Qgd/wPYEY9R3l1afM4PPuoSad7v3O6P2mJWPytJ2A=;
	b=LWsT34n7zAG8JU+3TWhAI95whv4wll++mhfZz3xeILHrYAPZ0rxDgCoMakLo7LLTlmdxeQ
	Bdzsb1QOY3/nfzyJ6V2HSOaiNHgxByerX8b50pwEO99eJkstE5EAQY0fCJRTGC3vsas6OL
	ps6YJYDs8t+yMPs5HRCsqYKqQXDxwkw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-442-Gafv5yJ8N6Cma0oteTbnzA-1; Thu,
 02 Jul 2026 21:43:42 -0400
X-MC-Unique: Gafv5yJ8N6Cma0oteTbnzA-1
X-Mimecast-MFC-AGG-ID: Gafv5yJ8N6Cma0oteTbnzA_1783043021
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13BC319560B7;
	Fri,  3 Jul 2026 01:43:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A6DF630030D1;
	Fri,  3 Jul 2026 01:43:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 6631hdGb1815547
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 2 Jul 2026 21:43:39 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 6631hdKm1815546;
	Thu, 2 Jul 2026 21:43:39 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, Junrui Luo <moonafterrain@outlook.com>
Subject: [PATCH] dm-log: fix a bitset_size overflow on 32bit machines
Date: Thu,  2 Jul 2026 21:43:39 -0400
Message-ID: <20260703014339.1815538-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BDCKLibWNlOW7Ym0w1grE0DpZ1x0HH0k9IQJnecf8dw_1783043021
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Commit c20e36b7631d ("dm log: fix out-of-bounds write due to
region_count overflow") made sure that region_count could fit in an
unsigned int. But the bitmap memory isn't allocated based on
region_count. It uses bitset_size (a size_t variable). The first step of
calculating bitset_size is to set it to region_count, rounded up to a
multiple of BITS_PER_LONG. If region_size is less than BITS_PER_LONG
smaller than UINT_MAX, it will get rounded up to 2^32. On a 32bit
architecture, this will make bitset_size wrap around to 0 and fail,
despite region_count being valid.

Since bitset_size gets divided by 8, it can hold any valid region_count.
It just needs a special case to handle the rollover. If it is 0, the
value rolled over, and bitset size should be set to the number of bytes
needed to hold 2^32 bits.

Fixes: c20e36b7631d ("dm log: fix out-of-bounds write due to region_count overflow")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-log.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index d316757a328b..77a0ee186aab 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -425,6 +425,9 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 	 */
 	bitset_size = dm_round_up(region_count, BITS_PER_LONG);
 	bitset_size >>= BYTE_SHIFT;
+	/* Handle dm_round_up rollover on 32-bit systems */
+	if (!bitset_size)
+		bitset_size = 1 << (BITS_PER_LONG - BYTE_SHIFT);
 
 	lc->bitset_uint32_count = bitset_size / sizeof(*lc->clean_bits);
 
-- 
2.53.0

