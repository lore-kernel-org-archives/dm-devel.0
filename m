Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1752A679EF
	for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 09:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706605999; cv=none; b=cjcKruE78xxPwKnvfPfWK9GFuWb8VT4+MbcQ1zVK9Eq0QCWI9/U/1F90iGZ/TkH4p+boWIalEhMp/FeJtt8nYfQD27HTjPHGlDaXXKPWhaxScHmQSc4ap35U2a2sBIvYP7Rb6LNf6CMio/h9cqVIP/WRTBDLZMuqz5nCrdb3rO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706605999; c=relaxed/simple;
	bh=yxd9IHSWjzcBrPuUDO7+SCI1N0zvICZf05uTKbbfPXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvGxjly5iM+H29jokXv6wgFDDUN6c7XxxYyyTis9zougPD3eHiWFy1LpwYNrZhG+mhVTzlezvzGGO7MnJc8zRjFN6N+UuU3sMymfJN1n6pxUMJFx1WlPw4yVd6go6veHfPswnSl85hjr+e4dNFEumlRauUtvGvOq0mpnxKqW6vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mcyaE0MV; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mcyaE0MV"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-595d24ad466so2523739eaf.0
        for <dm-devel@lists.linux.dev>; Tue, 30 Jan 2024 01:13:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706605997; x=1707210797; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kP7G/zPUbEjcGqCRjgaQMWAAf9wDrODicb4k9l2g++8=;
        b=mcyaE0MVESmrH8TGMrYVfdajgZeTv4YZk15PymS87wp5kI4qiYKzFao5XpNRhsQ3bP
         Z00tOlPqMozK3n3xkxyKpmra2WC0Yf7/B9JizUIVlwDr85pZwNQY6LsrzOrJU/1E7eZZ
         MHEMyNddszWGJrLxgtreElpxt+pbLupAqmaIxLWaR5/6S+JSkwrTdYahtxrDOHW0mIXK
         +gBCqCZD6fM7hwi5uY+XjifhZlQN1Hmexy8FTlvE4/9Nd1YWKZsbvP1AEDV5C8+YsRmO
         wdnWgePqrtVb+tj5qX0LZwd8q8HYVU+cV+L+knmBX87HiRxBORMhkee1ijeyvmXbFuC6
         cJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706605997; x=1707210797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kP7G/zPUbEjcGqCRjgaQMWAAf9wDrODicb4k9l2g++8=;
        b=g8mCBJj3dYmCOHF3zU7zGDlqRJxwVb0Jh+iYPXo0rjNPYiJF3YfNGC6Pv/vLc2ICSB
         MIR+ijYZoEtELWyXzceidnCUYJcKPsPJEaMz+ZhkM73Ln+Ju/FuS1j+RPLrZVxm7XWqZ
         OwpPTiwo8tz8+porTilWkChQmHl8/ZheEJCBywCWl0QyCRdviauvRam3OZwlQadKLTMU
         wVVqFMrLPRu317CJPwfwpJLiaRJptZZ29pIZCELgPL4Sf32cdKBN/SCxTGPvho8d/fTg
         QjFXKpnvvxN9lYroX3jlL0wNX7Kb+WHTJzdZZ2u3L6I2rqYCGiy7MAXkcPJKDUm0fvOp
         c1OQ==
X-Gm-Message-State: AOJu0YzNVh4cvaO+jzQPbaQMlrnbxrbn/kJ2prjDYWM7BXKC0VgoLfaZ
	fKyJrmOvG2ddrzQLKfYu+8qiiCLDskA7Csta8EShHl0i0zPCmCwC
X-Google-Smtp-Source: AGHT+IE8Q4KG3NbeQFqt34/6WaZTRJSkgwKNvSafvHvYRaM+fZtDCLEugDIup6U8STh4gXX2K2JK/g==
X-Received: by 2002:a05:6358:7e83:b0:178:7f7d:91a6 with SMTP id o3-20020a0563587e8300b001787f7d91a6mr2601345rwn.46.1706605997066;
        Tue, 30 Jan 2024 01:13:17 -0800 (PST)
Received: from localhost (dhcp-141-239-144-21.hawaiiantel.net. [141.239.144.21])
        by smtp.gmail.com with ESMTPSA id b4-20020a056a000a8400b006dde023cce8sm7211721pfl.57.2024.01.30.01.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 01:13:16 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org,
	mpatocka@redhat.com
Cc: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	msnitzer@redhat.com,
	ignat@cloudflare.com,
	damien.lemoal@wdc.com,
	bob.liu@oracle.com,
	houtao1@huawei.com,
	peterz@infradead.org,
	mingo@kernel.org,
	netdev@vger.kernel.org,
	allen.lkml@gmail.com,
	kernel-team@meta.com,
	Tejun Heo <tj@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 8/8] dm-verity: Convert from tasklet to BH workqueue
Date: Mon, 29 Jan 2024 23:11:55 -1000
Message-ID: <20240130091300.2968534-9-tj@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240130091300.2968534-1-tj@kernel.org>
References: <20240130091300.2968534-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only generic interface to execute asynchronously in the BH context is
tasklet; however, it's marked deprecated and has some design flaws. To
replace tasklets, BH workqueue support was recently added. A BH workqueue
behaves similarly to regular workqueues except that the queued work items
are executed in the BH context.

This patch converts dm-verity from tasklet to BH workqueue.

This is a minimal conversion which doesn't rename the related names
including the "try_verify_in_tasklet" option. If this patch is applied, a
follow-up patch would be necessary. I couldn't decide whether the option
name would need to be updated too.

Only compile tested. I don't know how to verity.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev
---
 drivers/md/dm-verity-target.c | 8 ++++----
 drivers/md/dm-verity.h        | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 14e58ae70521..911261de2d08 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -645,9 +645,9 @@ static void verity_work(struct work_struct *w)
 	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
 }
 
-static void verity_tasklet(unsigned long data)
+static void verity_bh_work(struct work_struct *w)
 {
-	struct dm_verity_io *io = (struct dm_verity_io *)data;
+	struct dm_verity_io *io = container_of(w, struct dm_verity_io, bh_work);
 	int err;
 
 	io->in_tasklet = true;
@@ -675,8 +675,8 @@ static void verity_end_io(struct bio *bio)
 	}
 
 	if (static_branch_unlikely(&use_tasklet_enabled) && io->v->use_tasklet) {
-		tasklet_init(&io->tasklet, verity_tasklet, (unsigned long)io);
-		tasklet_schedule(&io->tasklet);
+		INIT_WORK(&io->bh_work, verity_bh_work);
+		queue_work(system_bh_wq, &io->bh_work);
 	} else {
 		INIT_WORK(&io->work, verity_work);
 		queue_work(io->v->verify_wq, &io->work);
diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
index f9d522c870e6..7c16f834f31a 100644
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -83,7 +83,7 @@ struct dm_verity_io {
 	struct bvec_iter iter;
 
 	struct work_struct work;
-	struct tasklet_struct tasklet;
+	struct work_struct bh_work;
 
 	/*
 	 * Three variably-size fields follow this struct:
-- 
2.43.0

