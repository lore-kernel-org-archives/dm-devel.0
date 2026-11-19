Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.234
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795067144;
	b=EmwgX0buOmKbyvtGvDrM4fGzRjFPa91PszVjXuqoZUvuy4Rcv31tPKM2yHaV1KT+tjIV
	 RAlHXDiFLSw4SFRaWZZQW5Nu55mt9VoW1fANlLFmdjlDLRyOVQWsIRMObJpIDFBDReDut
	 zFW3p05brnGobJTLoxESH+pDD3a7WpMuTkiENQiFSC/8LGmrPLam4c8zHTPE42+m4qVke
	 /FWXuR59rwMlRtDodepoYB7GFdV/UUWpR/ck90JhexeMksICoellhTxYaY3ZkEcnxVw6/
	 VfNANK8rJnT9bIrkDn9FNpHDEDZHhGCgNwSj9OTIA1ciwDtJ/1VFiYtYnQ0q1f7fdBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795067144;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=G9E3ZlvCNN3za7iFE86FRPDY3ASAW1F+dUJPgk3tYvI=;
	b=2JOnGbGTGv4tKo7RkkWVn4S6HMeLjjPqSSAgFEiFLcss2txglkab7sFNHy8i3DxYZz//
	 fXyxzVpmSVe4yPgfIYG0odW6kPnD3y79y7vahYrYFTjT6QLYzXUV7mZuPbNoCkuLuqD5J
	 lYFslfjCsf7d1jEVjuYH/slcCgWCKozDjuIq8wz4ibRriKAvJ3z9zD0Xee2r9DIeMyjj8
	 YdvMhy5q1TGX8+bimc9Bs2+dUxCX4b9STFz8RxDKcgVWsh9c9K3FCDqYLHROTI3xDongB
	 aoS3beRMFmFpPeTLVuIG6le/f2cKfuF0y7PlqgF3FKBkAS0jXJLLeMkVxXOO3uFd4eQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YwgIdczF;
	arc=none smtp.remote-ip=95.215.58.234
Received: from mta1.migadu.com (out-234.mta1.migadu.com [95.215.58.234])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF5F60A2606
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 05:45:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFF5F60A2606
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YwgIdczF
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+pB1raUuXQSnWsn2TwVMoO8d+Us7Fizp12KZsMm8Os8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795067141; v=1; x=1795671941;
 b=YwgIdczFw/9rhBQCtDhg1v8tRqhCwALpoe3PKUNPfuTIfPKust2u/cljoAAra/nchLWi/jLR
 svNKqDrEd2IsytSpTl0UBOqiyp4aLCo/FWc5U9DhaYDdbXXQgvOIoCy/QQzsbGd71UZifJKQUVZ
 WB9KSxt+EU63aFAol6aNzX7Y=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 64a14d157764c6be;
	Thu, 19 Nov 2026 05:45:41 +0000
X-Mizu-Trace-ID: 64a14d157764c6be
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Thu, 19 Nov 2026 00:45:32 -0500
Subject: [PATCH v2 1/3] dm thin: drop the grace period from thin_ctr()
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-bug-dm-thin-rcu-gp-v2-1-055d627763c3@linux.dev>
References: <20261119-bug-dm-thin-rcu-gp-v2-0-055d627763c3@linux.dev>
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v2-0-055d627763c3@linux.dev>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

thin_ctr() adds the new thin to pool->active_thins with
list_add_tail_rcu() and then calls synchronize_rcu(), so that a
wake_worker() call can't miss the bios of a thin that isn't visible yet.

The grace period doesn't make the entry any more visible. A worker that
walks the list after list_add_tail_rcu() finds the thin, and the thin
gets no bios before its table is resumed. A walk already in progress may
miss it, but the wake_worker() for the first bio queues the worker
again. Still, activating a thin device waits for a full grace period,
which takes about half of the activation.

Remove the synchronize_rcu() call.

Activating 100 thin devices of an idle pool with dmsetup create takes
per device (mean of five rounds, min-max of the rounds in parentheses):

  before (ms)        after (ms)       change
  15.3 (14.8-15.7)   7.5 (7.3-7.7)      -51%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-thin.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 0b65c1b09f47b..bdd250d1eb2e1 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4292,13 +4292,6 @@ static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	init_completion(&tc->can_destroy);
 	list_add_tail_rcu(&tc->list, &tc->pool->active_thins);
 	spin_unlock_irq(&tc->pool->lock);
-	/*
-	 * This synchronize_rcu() call is needed here otherwise we risk a
-	 * wake_worker() call finding no bios to process (because the newly
-	 * added tc isn't yet visible).  So this reduces latency since we
-	 * aren't then dependent on the periodic commit to wake_worker().
-	 */
-	synchronize_rcu();
 
 	dm_put(pool_md);
 

-- 
2.43.0

