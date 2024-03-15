Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 945075A4DC
	for <dm-devel@lists.linux.dev>; Fri, 15 Mar 2024 23:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710544263; cv=none; b=Jj9SeeP9cFQyCLn8P21HkTwFDS9iv3N4Fc19+bVl/M0Hxc11Bj6NkVvjWaeozTdEMxMVLXE9TO5k+e33t1bSPSwmHwnSc5SkPdQAMIwMTyILvom1SzvGTYIwhdzIVsn+Tl/vB7Y6knBt6MIyiBzRsBTluXpqOUUvfDockXCamO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710544263; c=relaxed/simple;
	bh=6z9ptPkZJyNlCCbReaCMcDO+wIfkiqd1gZi8WCCPb8I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A6yDXCB9XJEovqJ6530LfwiJzcDN4D6JuJVUrpvGqKldb/FB6IK2Qcr0R1JGDQfa1/G7Fv9Pvf/99AAxCTghmN1urksrnvWco9BfnMtnpHLA4R4RzmnV//vjGO3HPvWh94gsiV5FLFal4DQyaP2HcspgTAF5AfnckEzx7hCIytM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ESrmpDLN; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ESrmpDLN"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-414008713beso7777935e9.1
        for <dm-devel@lists.linux.dev>; Fri, 15 Mar 2024 16:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1710544258; x=1711149058; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=SP904sJEbIFsGYDCNq0ABzyOPyyPe1UZ07yVv8Q3LgY=;
        b=ESrmpDLNw4l4YHd7urB/liGvzILGw0Fi67Dm6R93mJbWr12NsOBZksuBcmyOuE8K8G
         H5oBKp7N5MG28m/FPNZPOg6ouO3maqezGowuegnaQNX0XNrnvR2xvMlpLSSnaVGxoKQR
         1DjtkdkcJA9bkM+nLKYXabFNsBZuVxmyVIsC+495phf4SiPA9GK4HQFX9p+c/UclIIyj
         wF+w3eV3XoJfEYlR6XRrTZFH2IxckSmpxrVCrxhOaio1pEdhtvIakagcW7pLrF4v6gOy
         UgvjtJjhESsYu//wrKrIhZ9TetKt1RhGRwlIyc/D10I7QCDI3SV9eRl1u4tgd/gGPIDe
         kEkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710544258; x=1711149058;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SP904sJEbIFsGYDCNq0ABzyOPyyPe1UZ07yVv8Q3LgY=;
        b=CZAjNmvyQRxvS3YpDEOqPDBS0l34vcpIWeBhJRMTxLdrzzWiyIZTcFNjUA5dPrbB0i
         7QtbR3yBVxkSLVOjhIK25fQA6jCN2TtanEv5rbbH8bHbT5N3St3mOOUyK7GdEQLUfIjY
         vfd8VMEo+YqLYEQUpb91h3T0FB7gVKFTCMDlSW4n61rwO+2rqhrtPqic/+H5DwLfYt3Y
         p1gEHJMTgvwJEK2BHfcHJ4shbm3SazfrPfEX/q1UuCTAnzRxOJVffII5mOA/Yg55Ssk5
         eO4Jc/872uX5j5X8O4gx87JV07nFX3SJsUdqwWPoxfxAUMTOSlqvbcmxryOOqKtO2WxD
         vXAQ==
X-Gm-Message-State: AOJu0Yxg/kilTu9rXkijcbJcM0UKKlOOFOP/uIzbYzFtMXSpC8SHa0wJ
	xS7I0pIJhvJzJeZdZBLqzBFY6JCNtRFOGvIUiM+saOqYGV7+gdzePApjc6kX27M=
X-Google-Smtp-Source: AGHT+IFWV40ZJ1QDdk+rUIOl7a5ZD9zkZeRKVxCOsRd4W6SOOS46McAOUt0PvShDdWdtIky2SGwQZQ==
X-Received: by 2002:a05:600c:3f90:b0:413:fff2:a7d1 with SMTP id fs16-20020a05600c3f9000b00413fff2a7d1mr2469162wmb.29.1710544257786;
        Fri, 15 Mar 2024 16:10:57 -0700 (PDT)
Received: from localhost (dslb-002-202-118-224.002.202.pools.vodafone-ip.de. [2.202.118.224])
        by smtp.gmail.com with UTF8SMTPSA id j30-20020a05600c1c1e00b004133825e6cfsm10295805wms.24.2024.03.15.16.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 16:10:57 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Mike Snitzer <snitzer@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Martin Wilck <mwilck@suse.com>,
	Ming Lei <ming.lei@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Vasilis Liaskovitis <vliaskovitis@suse.com>
Subject: [RFC Patch] dm: make sure to wait for all dispatched requests in __dm_suspend()
Date: Sat, 16 Mar 2024 00:10:35 +0100
Message-ID: <20240315231035.26046-1-mwilck@suse.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In a recent kernel dump analysis, we found that the kernel crashed because
dm_rq_target_io tio->ti was pointing to invalid memory in dm_end_request(),
in a situation where multipathd was doing map reloads because of a storage
failover. The map of the respective mapped_device had been replaced by a
different struct dm_table.

We obverved this with a 5.3.18 distro kernel, but the code in question
hasn't change much since then. Basically, we were only missing
b4459b11e840 ("dm rq: don't queue request to blk-mq during DM suspend"),
which doesn't guarantee that the race I'm thinking of (see below) can't
happen.

When a map is resumed after a table reload, the live table is swapped, and
the tio->ti member of any live request becomes stale.  __dm_resume() avoids
this by quiescing the queue and calling dm_wait_for_completion(), which
waits until blk_mq_queue_inflight() doesn't report any in-flight requests.

However, blk_mq_queue_inflight() counts only "started" requests. So, if a
request is dispatched before the queue was quiesced, but
dm_wait_for_completion() doesn't observe MQ_RQ_IN_FLIGHT for this request
because of memory ordering effects, __dm_suspend() may finish successfully,
even though there is an active request, and the resume code path may
proceed through dm_swap_table() and dm_table_destroy(). The request that
sneaked through will then carry an invalid dm_target reference in
tio->ti. This is how I believe the above crash came to pass.

This patch tries to fix this by setting the "started" status of the request
inside a SRCU read side critical section. In __dm_suspend(),
synchronize_srcu(&md->io_barrier) is called after setting
DMF_BLOCK_IO_FOR_SUSPEND. The read side critical section is executed
completely, with all its memory effects, either before or after the
synchronize_srcu(). In the first case, dm_wait_for_completion() will
observe the in-flight status. Otherwise, dm_mq_queue_rq will see
DMF_BLOCK_IO_FOR_SUSPEND and give up. In both cases, there will be no stale
reference in tio->target when the request finishes.

Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Vasilis Liaskovitis <vliaskovitis@suse.com>
---
 drivers/md/dm-rq.c | 51 ++++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index f7e9a3632eb3..7f6c83eb2e5b 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -481,6 +481,10 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	struct dm_rq_target_io *tio = blk_mq_rq_to_pdu(rq);
 	struct mapped_device *md = tio->md;
 	struct dm_target *ti = md->immutable_target;
+	struct dm_table *map;
+	int srcu_idx;
+
+	map = dm_get_live_table(md, &srcu_idx);
 
 	/*
 	 * blk-mq's unquiesce may come from outside events, such as
@@ -488,25 +492,31 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * come during suspend, so simply ask for blk-mq to requeue it.
 	 */
 	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)))
-		return BLK_STS_RESOURCE;
+		goto out_put_table;
+
+	/*
+	 * If this request got dispatched before the queue was stopped in
+	 * __dm_suspend(), make sure dm_wait_for_completion() will
+	 * see this request as in flight. Otherwise this request may be actually
+	 * serviced while the table is swapped, and when it finishes, tio->ti
+	 * may reference a stale target.
+	 * As we're in a read-side critical section here, the synchronize_srcu()
+	 * in __dm_suspend() guarantees that if we haven't seen
+	 * DMF_BLOCK_IO_FOR_SUSPEND here, __dm_suspend() will observe the
+	 * in flight status.
+	 */
+	dm_start_request(md, rq);
 
 	if (unlikely(!ti)) {
-		int srcu_idx;
-		struct dm_table *map;
-
-		map = dm_get_live_table(md, &srcu_idx);
-		if (unlikely(!map)) {
-			dm_put_live_table(md, srcu_idx);
-			return BLK_STS_RESOURCE;
-		}
+		if (unlikely(!map))
+			goto out_put_table;
 		ti = dm_table_find_target(map, 0);
-		dm_put_live_table(md, srcu_idx);
 	}
+	dm_put_live_table(md, srcu_idx);
 
 	if (ti->type->busy && ti->type->busy(ti))
-		return BLK_STS_RESOURCE;
+		goto out_requeue;
 
-	dm_start_request(md, rq);
 
 	/* Init tio using md established in .init_request */
 	init_tio(tio, rq, md);
@@ -517,14 +527,19 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	tio->ti = ti;
 
 	/* Direct call is fine since .queue_rq allows allocations */
-	if (map_request(tio) == DM_MAPIO_REQUEUE) {
-		/* Undo dm_start_request() before requeuing */
-		rq_end_stats(md, rq);
-		rq_completed(md);
-		return BLK_STS_RESOURCE;
-	}
+	if (map_request(tio) == DM_MAPIO_REQUEUE)
+		goto out_requeue;
 
 	return BLK_STS_OK;
+
+out_put_table:
+	dm_put_live_table(md, srcu_idx);
+
+out_requeue:
+	/* Undo dm_start_request() before requeuing */
+	rq_end_stats(md, rq);
+	rq_completed(md);
+	return BLK_STS_RESOURCE;
 }
 
 static const struct blk_mq_ops dm_mq_ops = {
-- 
2.43.2

