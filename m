Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.105
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795086340;
	b=Q2zg2IqYwX005S8GYOMN76wxrv+wguqp6N2rGJ3GCeHJtCnn/IE6fiNgJiz4lQYpbkvP
	 7l9mrRvu66la92TNgiUfu/wO2reg9VJJSJvzS0Ce02oIZ4fTdYlebhfw9aNGtcvPLiiH7
	 2rGUs9mdqH0PepA5Zy8f3OpzQ5G/sI81FrWZKJZXCnx+wCdNFHfvkCUMrZnk8IGwqIHH/
	 YrNRm5j2f3VSKQhPaANK8mf0sFdSSwHJ0oTvN578Msekr+ekaD40TFZh5rf6qU3B2QkKt
	 6dpamLT3Vb5YncDhUOaw2/KbObmpdDi8YNgEkq22BqG0Nbmx7iEa5FoEwoUCYA739fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795086340;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=1FBQNxs/R1DsmHIJkLhFZceckPD2xMCFOwYjxlGTdSg=;
	b=c+1+HM4N2wNZeH+7GClTy+zlfWelFfzFB+pPvzeXJYotO4ZiYB3I+9rtnqqFI/nA4vWC
	 bLDOWJyqfXnRixE+OAqAUItYhgHv9Vw+8LI1dV6sT7uD1QHJ+Kcq35aycrDxTsMs1pABG
	 OgsawXpEsp7lg9BSNqMP8Rxlfzjxed/GnnCBzIEozRvaziOPv9bxH9DiG6SV0h9ZFUIrW
	 B9R1d0N5pXNXX2X+uCbNsywiECslGQEF4VNNqLz4fi7GjvKCfuuPW64JiUJOP/u6f+Oqw
	 ssVU6hUEitnAam/Byk2luyQD6G+Ppdb8GOMkslnqxll+Mc6Z/DQxrw++IrF30bfC6oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TBf9WBbM;
	arc=none smtp.remote-ip=91.218.175.105
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEB9606A320
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 11:05:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7CEB9606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TBf9WBbM
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=pwBEnk56dhZkjNV77x5nZMxFvZPU6WBrlZc8/rDRk0I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795086337; v=1; x=1795691137;
 b=TBf9WBbMySusyuw1rxno7r1H4yG76fdr5zCLE8NxixKdF8XzUqTOM8tXIfIsB3m0QIADChRI
 EV9HbaJ1RY0jRXAl74GvIl/hTbXxYnKQrTt2bU2yqgIMd8mk5y10PX2wDzzbvQZ0ZBaaKVOglOz
 BTwOYYBr6V6/iVm6AWH8PBF8=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id de80de804197a131;
	Thu, 19 Nov 2026 11:05:22 +0000
X-Mizu-Trace-ID: de80de804197a131
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Thu, 19 Nov 2026 06:05:06 -0500
Subject: [PATCH v3 1/3] dm thin: drop the grace period from thin_ctr()
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
Message-Id: <20261119-bug-dm-thin-rcu-gp-v3-1-c80ecc475e1e@linux.dev>
References: <20261119-bug-dm-thin-rcu-gp-v3-0-c80ecc475e1e@linux.dev>
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v3-0-c80ecc475e1e@linux.dev>
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
  15.5 (15.2-15.7)   7.7 (7.5-7.9)      -50%

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

