Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3521825E814
	for <dm-devel@lists.linux.dev>; Mon, 14 Jul 2025 16:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752510479; cv=none; b=cFKodSdYTCu8rLBioTUvZR7tfMHhv0+EgkYh072odPIK8GgcR/obyEBzl1PcKw6Z3lBRpYV2A5Nja7Hz/RdypA/VKyjaMHdUjvRiVexC3LE9f/FKhawPyZC7e3ARVBHTvZbcpdEUqTAbvSlBsliyJucTLkJlJs7POsJaDDM2B+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752510479; c=relaxed/simple;
	bh=wr9dM9/6+JRMcS0hz9CUkji6gHtekB/8FQdgCo8gUCc=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=lHiVFMF+Tnx7wHdhELGyi2U04C85rNz6PpaP/KsSvBdPe3LKDZyqxzrxu53vLdK9Hi++wQBfmCWnZqW3ZLOLYevh+Ypt5R+Z2ugBtmpP5B/DfZUP0dp+IVJydSjPrS8YK7wjvmTjeAEgpkVw9Ia6Z7H6r7TzCQBld9gwd/5Ea7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DJuqBRpR; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DJuqBRpR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752510476;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=mRH5VuSOb4gXfnpoDpxSa7GzbBV3BKVrIjvTJmLjC/Q=;
	b=DJuqBRpRQup69vanOhXRp0vx4AVCAR+y8mk25YQ3aeIzmzQaCXSU8KsyIAiM0GKBnSmY/+
	GajRBDWVx2KTRF1Q4lElWY53nglncmUgsadGGWwR18Tqu3ybaowbeN5qV1SZbw9dfKHm/y
	+YlnNRHUAbJ4yRJSIlwpHrGiRRn8lNs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-161-WrudLwcaMaaTEfzSvfy58A-1; Mon,
 14 Jul 2025 12:27:52 -0400
X-MC-Unique: WrudLwcaMaaTEfzSvfy58A-1
X-Mimecast-MFC-AGG-ID: WrudLwcaMaaTEfzSvfy58A_1752510472
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0165F18002ED;
	Mon, 14 Jul 2025 16:27:52 +0000 (UTC)
Received: from [10.22.80.10] (unknown [10.22.80.10])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9A55618002B5;
	Mon, 14 Jul 2025 16:27:50 +0000 (UTC)
Date: Mon, 14 Jul 2025 18:27:46 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Matthew Sakai <msakai@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] vdo: omit need_resched() before cond_resched()
Message-ID: <a9f43714-17a3-041d-fae4-bdbb79311f3b@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: kOC6BbtKXd7Pq_hxCtsvbv37hFgc8paaG00JLi29s5k_1752510472
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There's no need to call need_resched() because cond_resched() will do
nothing if need_resched() returns false.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-vdo/funnel-workqueue.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-vdo/funnel-workqueue.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-vdo/funnel-workqueue.c	2024-03-30 20:07:03.000000000 +0100
+++ linux-2.6/drivers/md/dm-vdo/funnel-workqueue.c	2025-07-14 18:17:59.000000000 +0200
@@ -252,8 +252,7 @@ static void service_work_queue(struct si
 		 * This speeds up some performance tests; that "other work" might include other VDO
 		 * threads.
 		 */
-		if (need_resched())
-			cond_resched();
+		cond_resched();
 	}
 
 	run_finish_hook(queue);

