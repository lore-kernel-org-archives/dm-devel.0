Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.248
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795067152;
	b=Wn+FDq4YJ0hQ9ppGr1cWdqJuBOPbHENBWW+V42mHLfd3Ht4St9Qy5OvB0d5QDCQ0zp6D
	 ndNfLBWdcvuxWZ1j0WPjXYbNQaryOwBhc2ZSyg/KeysDE/DmufgLy+lqJmuYWBTeiVOym
	 9DfW2F96U1Q9Bc6qEwcy3MHt6gjxCj7FpQZRGfBCVLQdAFN5Ab1/8DJ+fmbszRP0xRBrH
	 qHyFkfLr7ceG4c65SFKVetyJy9NB9fpHLqjoJPIzwMwbCPUtqjR0Eybft1jV42EUsh/ks
	 K4O0oVmjI02tKVxNj1KUYfgB9riUV7NMfE4Hu8RUr1iYF9vVuisDnQkVNGQTbpTCv+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795067152;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=VVrWeoLyvky1fcgODekhdtwxogAAzSz6gjdJU75YmvQ=;
	b=FXw4W3Rs5jEDpwvEsbPegOKQqi+EmhcvmH7kX5cX7IhtYvrMbm7G6fxkw6xMv7WX7VPM
	 8o514rodHHg6b4D/5PqvRPHQV2zqsAuHVY94Eu5fS4vRXEPW142ANcKoh7J4EQP6hALWt
	 W/35pKtqDcgB5aXCPlyVimLIfhX9kJlzxx7HAJ2n4K5k/Mg7rILMPaYgSGLU8//Q5zjXZ
	 zshmm0QKJqbqPP1pvFIaglx99ohBfWprYZEQxhoQyNBLDLbiaFzhR/c30PkcZlNuOEbii
	 YfgOLFZJzeEhoGuKMuooBVrWk6TwKKEDRUAHEJrewXl1aONfYKydjbKBSHoaB//fqJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PE+DUfcG;
	arc=none smtp.remote-ip=95.215.58.248
Received: from mta1.migadu.com (out-248.mta1.migadu.com [95.215.58.248])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5A860A2623
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 05:45:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F5A860A2623
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PE+DUfcG
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=WHFgyKpY02mIunkOLDQ0vqEf6qoDQheEPXtKq57nqd4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795067150; v=1; x=1795671950;
 b=PE+DUfcGZsnIi4sDI/YrgR9AU5NLQT8OrgwAzfzl6PcFgTZWRvGuQ2gofQGQ38T5hhILqGuB
 cltMRsTzKM4dgTvOwgddYTb0shQSryTTZ/VZ7DYcPGRThpkQ1wEvfmrlQkqkU0jG/MVV+3e3fgd
 2O+eOPMkO9ZZI4mNblNe3w+c=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cba1dd314961dd08;
	Thu, 19 Nov 2026 05:45:50 +0000
X-Mizu-Trace-ID: cba1dd314961dd08
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Thu, 19 Nov 2026 00:45:34 -0500
Subject: [PATCH v2 3/3] dm thin: free thins with kfree_rcu() instead of
 waiting in thin_dtr()
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
Message-Id: <20261119-bug-dm-thin-rcu-gp-v2-3-055d627763c3@linux.dev>
References: <20261119-bug-dm-thin-rcu-gp-v2-0-055d627763c3@linux.dev>
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v2-0-055d627763c3@linux.dev>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

thin_dtr() waits until the last reference on the thin is dropped, which
also takes it off pool->active_thins, and then for a grace period, so
that requeue_bios() and error_retry_list_with_code(), which walk the
list under rcu_read_lock(), are done with the thin before it is freed.

Removing a thin device thus waits for a full grace period in thin_dtr(),
although those readers only need the memory of the thin to stay around.

Free the thin with kfree_rcu() instead of waiting for the grace period.

Removing 100 thin devices of an idle pool with dmsetup remove takes per
device (mean of five rounds, min-max of the rounds in parentheses). The
queue freeze in del_gendisk() waits for a grace period of its own, which
the one in thin_dtr() used to overlap, so only part of it is saved:

  before (ms)        after (ms)         change
  16.6 (16.2-17.0)   13.5 (13.2-14.0)     -19%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/md/dm-thin.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index f79f5982ae36c..9d9b3cd817f7a 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -362,6 +362,7 @@ struct thin_c {
 	refcount_t refcount;
 	struct completion can_destroy;
 	bool dead;
+	struct rcu_head rcu;
 };
 
 /*----------------------------------------------------------------*/
@@ -4166,8 +4167,6 @@ static void thin_dtr(struct dm_target *ti)
 	WRITE_ONCE(tc->dead, true);
 	thin_put(tc);
 	wait_for_completion(&tc->can_destroy);
-	/* Let RCU readers of active_thins finish with tc */
-	synchronize_rcu();
 
 	mutex_lock(&dm_thin_pool_table.mutex);
 
@@ -4176,7 +4175,8 @@ static void thin_dtr(struct dm_target *ti)
 	dm_put_device(ti, tc->pool_dev);
 	if (tc->origin_dev)
 		dm_put_device(ti, tc->origin_dev);
-	kfree(tc);
+	/* Let RCU readers of active_thins finish with tc before freeing it */
+	kfree_rcu(tc, rcu);
 
 	mutex_unlock(&dm_thin_pool_table.mutex);
 }

-- 
2.43.0

