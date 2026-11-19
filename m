Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.155
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795086355;
	b=0lbD7V8kjlJwwdK7fz4Fon1uf4Saerp2l3EG4Cu0xlDi60rDpC8XVUtEF032aBRxGteY
	 PpND7bSJLja4PJdJG1mripRnF12/qtuxoaxIgfRRrjaesJIe0/4XinWcLL9sOwkYmuBPB
	 twCSzNK7okvWtW6YVn9bSEAm4pPafFmB0KW6X6KsUIdwIH1fc2Y7EpOep5iKe1rEc7ynd
	 m3mLMhpHo9XVXBUQ6qT9vsxGf5Uys0bYxdO2tskenZWXiyXRMl0i9WK26dE0MaJzHCzZF
	 CWH8lsjUXc9TKY1ktpMBWcZbuSFMlySwTAUZIkjzJdHtQow5zjPusRR2TYApWH2uPLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795086355;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=4SML9PZo2oH2XHwA/ryYTkae5HMzK3G8Ykz1zCFl2n0=;
	b=XxJopWgJtIptdI/fft3dUKqBZ8HG6NFbZFZn/1BSm8Xd6orasUNP3lbC+tRYGJNE0KTi
	 p0d1OPF+VI5hu4d4MVWDIVatfFO9M0dL0mEm/YAnrN9pjQ2dEd77MmoJubhYfkNh2r1mf
	 FoIQtJhe8lGOJcEwEwS2MlQhXEWuCuyCqno6jHRLc6rjQulTR2Ko+/GyXIcMnB0EICD23
	 I2RfjIYyq+M3y2OMadyvPc15TvT4XjV8N7CPchOmb9RvgRg4/eijYgAulJoYRBFoHemqK
	 mmSvxr586Vgf43weka1Ctp7x7PZhsuQNPSdQDE4kKzaweOVdUsz9IMHEHkPg7VXnMtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t215atGw;
	arc=none smtp.remote-ip=95.215.58.155
Received: from mta1.migadu.com (out-155.mta1.migadu.com [95.215.58.155])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A49606A324
	for <dm-devel@lists.linux.dev>; Thu, 19 Nov 2026 11:05:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D8A49606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=t215atGw
X-Envelope-To: dm-devel@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=XSOl3/qcTJy668FU0UogTk2zPC1x8CJWVBIH++9siQc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795086353; v=1; x=1795691153;
 b=t215atGwwP6lxogK0BNMlphC+Nn/30D0u5ZTJwBVAg6LXPBkMuTKacFQd9RBD57hb6jSOwJq
 /jR+gZnsjhISwvG99N9MbDsxjfqbDQTYJZrxq60472Re0TZuGuJ7NkkyQe8/ghDdtcs5uHP7Pbs
 1xnoGU3W82v2V0VK7uQrjoTY=
X-Envelope-To: dm-devel@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 78f296d0b03a8005;
	Thu, 19 Nov 2026 11:05:52 +0000
X-Mizu-Trace-ID: 78f296d0b03a8005
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Thu, 19 Nov 2026 06:05:08 -0500
Subject: [PATCH v3 3/3] dm thin: free thins with kfree_rcu() instead of
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
Message-Id: <20261119-bug-dm-thin-rcu-gp-v3-3-c80ecc475e1e@linux.dev>
References: <20261119-bug-dm-thin-rcu-gp-v3-0-c80ecc475e1e@linux.dev>
In-Reply-To: <20261119-bug-dm-thin-rcu-gp-v3-0-c80ecc475e1e@linux.dev>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

thin_dtr() takes the thin off pool->active_thins once its last
reference is dropped and then waits for a grace period, so that
requeue_bios() and error_retry_list_with_code(), which walk the list
under rcu_read_lock(), are done with the thin before it is freed.

Removing a thin device thus waits for a full grace period in thin_dtr(),
although those readers only need the memory of the thin to stay around.

Free the thin with kfree_rcu() instead of waiting for the grace period.

Removing 100 thin devices of an idle pool with dmsetup remove takes per
device (mean of five rounds, min-max of the rounds in parentheses). The
queue freeze in del_gendisk() waits for a grace period of its own, which
the one in thin_dtr() used to overlap, so only part of it is saved:

  before (ms)        after (ms)         change
  17.2 (17.0-17.4)   13.7 (13.2-14.4)     -20%

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/md/dm-thin.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 62ef96bf08cb3..e695fc356c4dc 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -360,6 +360,7 @@ struct thin_c {
 	 */
 	refcount_t refcount;
 	struct completion can_destroy;
+	struct rcu_head rcu;
 	/*
 	 * Keeps new active_thin walkers from grabbing the table while
 	 * thin_dtr() is waiting for the existing holders to finish.
@@ -4169,7 +4170,6 @@ static void thin_dtr(struct dm_target *ti)
 	spin_lock_irq(&tc->pool->lock);
 	list_del_rcu(&tc->list);
 	spin_unlock_irq(&tc->pool->lock);
-	synchronize_rcu();
 
 	mutex_lock(&dm_thin_pool_table.mutex);
 
@@ -4178,7 +4178,8 @@ static void thin_dtr(struct dm_target *ti)
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

