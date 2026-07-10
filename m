Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABF33672BF
	for <dm-devel@lists.linux.dev>; Fri, 10 Jul 2026 16:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783701360; cv=none; b=aC8VVz4J3oH9FcQdbiz/Tfj9CkMDSPGSmn5McJADso68DQ2u3PQgBqFG8Ue4LDAPmFTgW5Wi5AngUfyUsjpL6ByWxkUzPBGMdiDzwz5asUkptpU8JqEfdvrFOul1Q1Q+juKiROXEn85MYhNYheeLm9X3nxu6G5WLLNq3bamtMwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783701360; c=relaxed/simple;
	bh=DippigUutNwtnMPgQvp5z5xl5AHR1LMLUYVITFE+iVo=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=dSqrRSXb8+yJByRmrOrJgN09FNNukoMOVzhmc9gCxhG0L17RFF+JfVegZ8uPjl/cj+z3NMIOyH0K+XdINOw99fNhO64lcBCObi2YYd/C7DLcnDDAhguL0iUPE6QuylSBes2DHUXKWidVn2wAxk3glmtwNW+KIXQ4KxDG2UfC6iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q4kBaVfu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q4kBaVfu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783701358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=WpBRD9EXdiS+jyaaNFbGchLEhN+qyneqQUgbMqLBo2Q=;
	b=Q4kBaVfuA7o6kcjC74d9Qa+2TEYJJNSZJG7wsEQVHESsFpaAqx2ojcBXKwCCd4q41iLzgJ
	EiAS/U83PILU0d+u9m7Bp4FcYgjT/unotnE/msLCJbEFXBLxgJi+tVuOUa44hXbxr1k8s+
	qX9fmMG9nbDWeeBPb3K6CWmU0N+J6SI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-Jv_UaTWDNl2FVxx9q9-0OA-1; Fri,
 10 Jul 2026 12:35:55 -0400
X-MC-Unique: Jv_UaTWDNl2FVxx9q9-0OA-1
X-Mimecast-MFC-AGG-ID: Jv_UaTWDNl2FVxx9q9-0OA_1783701354
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1823D1955D84;
	Fri, 10 Jul 2026 16:35:54 +0000 (UTC)
Received: from [10.44.32.225] (unknown [10.44.32.225])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EE2DE180057F;
	Fri, 10 Jul 2026 16:35:51 +0000 (UTC)
Date: Fri, 10 Jul 2026 18:35:49 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-stats: fix merge accounting
Message-ID: <891f904b-de0a-69e4-b3f1-387e79b67acf@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gQQXz1gf8hVVaGPIjaw3Thloxuo6dFIW3BvBDpyqHQU_1783701354
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There were wrong parentheses when setting stats_aux->merged, so that
merging was never properly accounted. This commit fixes it.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org

---
 drivers/md/dm-stats.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-stats.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stats.c	2026-02-23 19:31:52.000000000 +0100
+++ linux-2.6/drivers/md/dm-stats.c	2026-07-10 15:38:59.000000000 +0200
@@ -692,10 +692,8 @@ void dm_stats_account_io(struct dm_stats
 		 */
 		last = raw_cpu_ptr(stats->last);
 		stats_aux->merged =
-			(bi_sector == (READ_ONCE(last->last_sector) &&
-				       ((bi_rw == WRITE) ==
-					(READ_ONCE(last->last_rw) == WRITE))
-				       ));
+			bi_sector == READ_ONCE(last->last_sector) &&
+				(bi_rw == WRITE) == (READ_ONCE(last->last_rw) == WRITE);
 		WRITE_ONCE(last->last_sector, end_sector);
 		WRITE_ONCE(last->last_rw, bi_rw);
 	} else

