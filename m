Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com [209.85.221.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3742238B9B5
	for <dm-devel@lists.linux.dev>; Tue, 13 Jan 2026 11:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768302196; cv=none; b=Wydi/s9WirmMD7MQ+VkSvvl5Aga6IBqiKJmXuT0usjFySj0Ipn4CcpC/g9gbXV1bayZjMMEiz5vMDfks7mjXt4cOQGUM461G87rvwHQ0bjbmF1xWQeL8O9+MKbZXi/hUym3QPsaswMieuCS9I95zRNptTvDJASbtFugIHyu9LwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768302196; c=relaxed/simple;
	bh=lG5jprjFqToilE6Vli+lGoCGRq0lzulLFEw2Folq2nY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BhRIWNPr4DwX8vMc5wH8Dmpc0bDnA7rSTzlq52pqYuWtneFfa55yVe+WzMpddn+9srRSHtcohba48G3Bj+LIYAnq4brdbso0Wagi5TDqZsYTOh3PQnLCgpc8snATrCw601mekKr8kfLRR35nbBcnO6wJK0s0dFMekQwseUQ36zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=cDy8IIk4; arc=none smtp.client-ip=209.85.221.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="cDy8IIk4"
Received: by mail-wr1-f68.google.com with SMTP id ffacd0b85a97d-432d2c96215so4128168f8f.3
        for <dm-devel@lists.linux.dev>; Tue, 13 Jan 2026 03:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768302192; x=1768906992; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TIydhpDYEin5WEa34aOrXn3znF9vrpWZEzLwlwUWUWE=;
        b=cDy8IIk4DOCFpKHW7wthDi5clh6VYiKJ9Pj8awJKrl3VD610QnoCCoK4MK75iXNZxT
         crxaw2T4Q0oZKTwqcUwPX8zGxkvPdA9TXtd2jc2ytKFAZXQe/rUGRBv7u3jXk+L+ZPjz
         gqoEB6IxJoQBzmOEHv+dVEMnwU1H/iO4aD8xKP2Mcqjls51liWfhwSBkaWh5gwcFeVH/
         Hl4ypdsDP3EKkhRM1WCqmkPYl2VZvBQO0VndMsteYAGy3iNrZp3piOjHUc4IWMCY6eiW
         YkLNW+IRdjw6Q/G3fiKOLe6KxG7UZiZ9SoGlawTihRgwpRh02wns8zVW1L3Lpcb4mnz4
         YyBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768302192; x=1768906992;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TIydhpDYEin5WEa34aOrXn3znF9vrpWZEzLwlwUWUWE=;
        b=LAQOnesFe9Aaah9RAZb62XRDh5pGFLxoBviPSyWDySZWdHAl++7bE+jtn9cJuoVlUG
         8wvWQwEiHHvD5VGBWhyuIv6pvLuuN6GVyTPH1GpZZo0T5k9aLkkpJmHLhYeND3uxd/pg
         Fx6x4L5uAsbgxcblxEVIjmtlX7v5qL2vhvvLcoauzJfJlYTRHBEMmz1uP4TZdviX+1sU
         h0TkX6PUPuByHK3RXThX70PQYXwj51MzrJ5rAX9EtIPpUEFJ17pRlnEWymFsQx/kcBCy
         KOu6+SErlTpvDZAg5ieUEMt5V6qZ8nq/Ld/nIBPtOlg23E19evLr06eRPdzi4SmiiJNy
         hzow==
X-Forwarded-Encrypted: i=1; AJvYcCWz2Dlc4aBB8R2k0n/lIEMGQtaFzivlgbY3XkXrY93sQ0aRZwJj8jKMO0JaDKfSV8hFupURVQuR3g==@lists.linux.dev
X-Gm-Message-State: AOJu0YzQMCqcFib1qtNrpvbAXLNQR4AVX3aBJRJRixTfMWXa8j5pBo3F
	L5Ly61FZFZrHJDXcIV4oYed4XtPKaF9vXhKD/MRfgXaa6nJ/K1xeNtz1++PR9lZ50yXY7ts6UH5
	+rkIG
X-Gm-Gg: AY/fxX6s8JCjszy+CzpEI+iI8oK2pSzblwnuvvI2onbRMO+d9+Xz3+gI+i2VO4K7daJ
	LnGS7QLTdJGdGYt9SKrHPEzxj14UaH4BXUcdH0sigkTi29fwFzLVZ2ea5WHOiZl08pLLk3thAa5
	5Cq6zOfNLy2yB2K0V80RGKyuwxK0GJZWbAxvFx/dTam1KSMgB2CN+kIYRC5iRyEhxzgPbhCHa6b
	qWwGEbaC0ayyqukxAk7ZYgg4Y3QWkDhB/JZvZnqx4kVr47JglhFlyZCV3QtDsjAKICzYl76QJi7
	CnX5n/GWpe3wyc2H5eYQvpIpC+Rz5tn1cKexflASlMND5HnHyycsiEm3o0KqKp85dk82/In4vi/
	gNctOgxLyKhFA65tAK4/lzBTP+hCAs9dk5hoL9g+9+1VQVTejmOehBh2sKy6P57IG2nAFPYQJkM
	LnAm9TGKrqD2la8Q==
X-Google-Smtp-Source: AGHT+IGkg93NTJzZuUw3iB7rqeo01QC2UwgbQ2nCJQyYsUwAEkbWOEw7sG2aQC0i6160uAcq3JhGog==
X-Received: by 2002:a05:6000:2084:b0:42b:2ee0:569f with SMTP id ffacd0b85a97d-432c37c87c6mr27543793f8f.33.1768302192357;
        Tue, 13 Jan 2026 03:03:12 -0800 (PST)
Received: from linux ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd0e199bsm43258792f8f.16.2026.01.13.03.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 03:03:12 -0800 (PST)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: add WQ_PERCPU to alloc_workqueue users
Date: Tue, 13 Jan 2026 12:03:02 +0100
Message-ID: <20260113110302.114843-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This continues the effort to refactor workqueue APIs, which began with
the introduction of new workqueues and a new alloc_workqueue flag in:

   commit 128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
   commit 930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

The refactoring is going to alter the default behavior of
alloc_workqueue() to be unbound by default.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn’t explicitly specify WQ_UNBOUND
must now use WQ_PERCPU. For more details see the Link tag below.

In order to keep alloc_workqueue() behavior identical, explicitly request
WQ_PERCPU.

Link: https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/
Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
---
 drivers/md/dm-bufio.c              |  3 ++-
 drivers/md/dm-cache-target.c       |  3 ++-
 drivers/md/dm-clone-target.c       |  3 ++-
 drivers/md/dm-crypt.c              |  6 ++++--
 drivers/md/dm-delay.c              |  4 +++-
 drivers/md/dm-integrity.c          | 15 ++++++++++-----
 drivers/md/dm-kcopyd.c             |  3 ++-
 drivers/md/dm-log-userspace-base.c |  3 ++-
 drivers/md/dm-mpath.c              |  5 +++--
 drivers/md/dm-raid1.c              |  5 +++--
 drivers/md/dm-snap-persistent.c    |  3 ++-
 drivers/md/dm-stripe.c             |  2 +-
 drivers/md/dm-verity-target.c      |  4 +++-
 drivers/md/dm-writecache.c         |  3 ++-
 drivers/md/dm.c                    |  3 ++-
 drivers/md/md.c                    |  4 ++--
 16 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 5235f3e4924b..f41f649c01d4 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2833,7 +2833,8 @@ static int __init dm_bufio_init(void)
 	__cache_size_refresh();
 	mutex_unlock(&dm_bufio_clients_lock);
 
-	dm_bufio_wq = alloc_workqueue("dm_bufio_cache", WQ_MEM_RECLAIM, 0);
+	dm_bufio_wq = alloc_workqueue("dm_bufio_cache",
+				      WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!dm_bufio_wq)
 		return -ENOMEM;
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index a10d75a562db..7bad7cc87d37 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2533,7 +2533,8 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 		goto bad;
 	}
 
-	cache->wq = alloc_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM, 0);
+	cache->wq = alloc_workqueue("dm-" DM_MSG_PREFIX,
+				    WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!cache->wq) {
 		*error = "could not create workqueue for metadata object";
 		goto bad;
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index e956d980672c..b25845e36274 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1877,7 +1877,8 @@ static int clone_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	clone->hydration_offset = 0;
 	atomic_set(&clone->hydrations_in_flight, 0);
 
-	clone->wq = alloc_workqueue("dm-" DM_MSG_PREFIX, WQ_MEM_RECLAIM, 0);
+	clone->wq = alloc_workqueue("dm-" DM_MSG_PREFIX,
+				    WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!clone->wq) {
 		ti->error = "Failed to allocate workqueue";
 		r = -ENOMEM;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 79704fbc523b..0e479de75ad0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3400,7 +3400,9 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (test_bit(DM_CRYPT_HIGH_PRIORITY, &cc->flags))
 		common_wq_flags |= WQ_HIGHPRI;
 
-	cc->io_queue = alloc_workqueue("kcryptd_io-%s-%d", common_wq_flags, 1, devname, wq_id);
+	cc->io_queue = alloc_workqueue("kcryptd_io-%s-%d",
+				       common_wq_flags | WQ_PERCPU, 1,
+				       devname, wq_id);
 	if (!cc->io_queue) {
 		ti->error = "Couldn't create kcryptd io queue";
 		goto bad;
@@ -3408,7 +3410,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	if (test_bit(DM_CRYPT_SAME_CPU, &cc->flags)) {
 		cc->crypt_queue = alloc_workqueue("kcryptd-%s-%d",
-						  common_wq_flags | WQ_CPU_INTENSIVE,
+						  common_wq_flags | WQ_CPU_INTENSIVE | WQ_PERCPU,
 						  1, devname, wq_id);
 	} else {
 		/*
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index 4bb6553278c7..029f04776490 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -290,7 +290,9 @@ static int delay_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	} else {
 		timer_setup(&dc->delay_timer, handle_delayed_timer, 0);
 		INIT_WORK(&dc->flush_expired_bios, flush_expired_bios);
-		dc->kdelayd_wq = alloc_workqueue("kdelayd", WQ_MEM_RECLAIM, 0);
+		dc->kdelayd_wq = alloc_workqueue("kdelayd",
+						 WQ_MEM_RECLAIM | WQ_PERCPU,
+						 0);
 		if (!dc->kdelayd_wq) {
 			ret = -EINVAL;
 			DMERR("Couldn't start kdelayd");
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 170bf67a2edd..564d8099361a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4990,7 +4990,8 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 	}
 
 	ic->metadata_wq = alloc_workqueue("dm-integrity-metadata",
-					  WQ_MEM_RECLAIM, METADATA_WORKQUEUE_MAX_ACTIVE);
+					  WQ_MEM_RECLAIM | WQ_PERCPU,
+					  METADATA_WORKQUEUE_MAX_ACTIVE);
 	if (!ic->metadata_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
@@ -5008,7 +5009,8 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		goto bad;
 	}
 
-	ic->offload_wq = alloc_workqueue("dm-integrity-offload", WQ_MEM_RECLAIM,
+	ic->offload_wq = alloc_workqueue("dm-integrity-offload",
+					  WQ_MEM_RECLAIM | WQ_PERCPU,
 					  METADATA_WORKQUEUE_MAX_ACTIVE);
 	if (!ic->offload_wq) {
 		ti->error = "Cannot allocate workqueue";
@@ -5016,7 +5018,8 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 		goto bad;
 	}
 
-	ic->commit_wq = alloc_workqueue("dm-integrity-commit", WQ_MEM_RECLAIM, 1);
+	ic->commit_wq = alloc_workqueue("dm-integrity-commit",
+					WQ_MEM_RECLAIM | WQ_PERCPU, 1);
 	if (!ic->commit_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
@@ -5025,7 +5028,8 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 	INIT_WORK(&ic->commit_work, integrity_commit);
 
 	if (ic->mode == 'J' || ic->mode == 'B') {
-		ic->writer_wq = alloc_workqueue("dm-integrity-writer", WQ_MEM_RECLAIM, 1);
+		ic->writer_wq = alloc_workqueue("dm-integrity-writer",
+						WQ_MEM_RECLAIM | WQ_PERCPU, 1);
 		if (!ic->writer_wq) {
 			ti->error = "Cannot allocate workqueue";
 			r = -ENOMEM;
@@ -5197,7 +5201,8 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 	}
 
 	if (ic->internal_hash) {
-		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc", WQ_MEM_RECLAIM, 1);
+		ic->recalc_wq = alloc_workqueue("dm-integrity-recalc",
+						WQ_MEM_RECLAIM | WQ_PERCPU, 1);
 		if (!ic->recalc_wq) {
 			ti->error = "Cannot allocate workqueue";
 			r = -ENOMEM;
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 6ea75436a433..cec9a60227b6 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -934,7 +934,8 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(struct dm_kcopyd_throttle *thro
 		goto bad_slab;
 
 	INIT_WORK(&kc->kcopyd_work, do_work);
-	kc->kcopyd_wq = alloc_workqueue("kcopyd", WQ_MEM_RECLAIM, 0);
+	kc->kcopyd_wq = alloc_workqueue("kcopyd", WQ_MEM_RECLAIM | WQ_PERCPU,
+					0);
 	if (!kc->kcopyd_wq) {
 		r = -ENOMEM;
 		goto bad_workqueue;
diff --git a/drivers/md/dm-log-userspace-base.c b/drivers/md/dm-log-userspace-base.c
index 9fbb4b48fb2b..607436804a8b 100644
--- a/drivers/md/dm-log-userspace-base.c
+++ b/drivers/md/dm-log-userspace-base.c
@@ -299,7 +299,8 @@ static int userspace_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 	}
 
 	if (lc->integrated_flush) {
-		lc->dmlog_wq = alloc_workqueue("dmlogd", WQ_MEM_RECLAIM, 0);
+		lc->dmlog_wq = alloc_workqueue("dmlogd",
+					       WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 		if (!lc->dmlog_wq) {
 			DMERR("couldn't start dmlogd");
 			r = -ENOMEM;
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d5d6ef7ba838..c748e7f952c4 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -2328,7 +2328,8 @@ static int __init dm_multipath_init(void)
 {
 	int r = -ENOMEM;
 
-	kmultipathd = alloc_workqueue("kmpathd", WQ_MEM_RECLAIM, 0);
+	kmultipathd = alloc_workqueue("kmpathd", WQ_MEM_RECLAIM | WQ_PERCPU,
+				      0);
 	if (!kmultipathd) {
 		DMERR("failed to create workqueue kmpathd");
 		goto bad_alloc_kmultipathd;
@@ -2347,7 +2348,7 @@ static int __init dm_multipath_init(void)
 		goto bad_alloc_kmpath_handlerd;
 	}
 
-	dm_mpath_wq = alloc_workqueue("dm_mpath_wq", 0, 0);
+	dm_mpath_wq = alloc_workqueue("dm_mpath_wq", WQ_PERCPU, 0);
 	if (!dm_mpath_wq) {
 		DMERR("failed to create workqueue dm_mpath_wq");
 		goto bad_alloc_dm_mpath_wq;
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 268f734ca9c3..943c0c6b2087 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1128,7 +1128,8 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->per_io_data_size = sizeof(struct dm_raid1_bio_record);
 
-	ms->kmirrord_wq = alloc_workqueue("kmirrord", WQ_MEM_RECLAIM, 0);
+	ms->kmirrord_wq = alloc_workqueue("kmirrord",
+					  WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!ms->kmirrord_wq) {
 		DMERR("couldn't start kmirrord");
 		r = -ENOMEM;
@@ -1500,7 +1501,7 @@ static int __init dm_mirror_init(void)
 {
 	int r;
 
-	dm_raid1_wq = alloc_workqueue("dm_raid1_wq", 0, 0);
+	dm_raid1_wq = alloc_workqueue("dm_raid1_wq", WQ_PERCPU, 0);
 	if (!dm_raid1_wq) {
 		DMERR("Failed to alloc workqueue");
 		return -ENOMEM;
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 568d10842b1f..0e13d60bfdd1 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -871,7 +871,8 @@ static int persistent_ctr(struct dm_exception_store *store, char *options)
 	atomic_set(&ps->pending_count, 0);
 	ps->callbacks = NULL;
 
-	ps->metadata_wq = alloc_workqueue("ksnaphd", WQ_MEM_RECLAIM, 0);
+	ps->metadata_wq = alloc_workqueue("ksnaphd",
+					  WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!ps->metadata_wq) {
 		DMERR("couldn't start header metadata update thread");
 		r = -ENOMEM;
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 1461dc740dae..1cff9df5b8b4 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -489,7 +489,7 @@ int __init dm_stripe_init(void)
 {
 	int r;
 
-	dm_stripe_wq = alloc_workqueue("dm_stripe_wq", 0, 0);
+	dm_stripe_wq = alloc_workqueue("dm_stripe_wq", WQ_PERCPU, 0);
 	if (!dm_stripe_wq)
 		return -ENOMEM;
 	r = dm_register_target(&stripe_target);
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 5c17472d7896..d00298d50ffb 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1651,7 +1651,9 @@ static int verity_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 * will fall-back to using it for error handling (or if the bufio cache
 	 * doesn't have required hashes).
 	 */
-	v->verify_wq = alloc_workqueue("kverityd", WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
+	v->verify_wq = alloc_workqueue("kverityd",
+				       WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_PERCPU,
+				       0);
 	if (!v->verify_wq) {
 		ti->error = "Cannot allocate workqueue";
 		r = -ENOMEM;
diff --git a/drivers/md/dm-writecache.c b/drivers/md/dm-writecache.c
index d8de4a3076a1..af54e289bceb 100644
--- a/drivers/md/dm-writecache.c
+++ b/drivers/md/dm-writecache.c
@@ -2275,7 +2275,8 @@ static int writecache_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	wc->writeback_wq = alloc_workqueue("writecache-writeback", WQ_MEM_RECLAIM, 1);
+	wc->writeback_wq = alloc_workqueue("writecache-writeback",
+					   WQ_MEM_RECLAIM | WQ_PERCPU, 1);
 	if (!wc->writeback_wq) {
 		r = -ENOMEM;
 		ti->error = "Could not allocate writeback workqueue";
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b63279202260..ea2c43cddde1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2366,7 +2366,8 @@ static struct mapped_device *alloc_dev(int minor)
 
 	format_dev_t(md->name, MKDEV(_major, minor));
 
-	md->wq = alloc_workqueue("kdmflush/%s", WQ_MEM_RECLAIM, 0, md->name);
+	md->wq = alloc_workqueue("kdmflush/%s", WQ_MEM_RECLAIM | WQ_PERCPU, 0,
+				 md->name);
 	if (!md->wq)
 		goto bad;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6d73f6e196a9..3882a66bad85 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -10493,11 +10493,11 @@ static int __init md_init(void)
 		goto err_bitmap;
 
 	ret = -ENOMEM;
-	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM, 0);
+	md_wq = alloc_workqueue("md", WQ_MEM_RECLAIM | WQ_PERCPU, 0);
 	if (!md_wq)
 		goto err_wq;
 
-	md_misc_wq = alloc_workqueue("md_misc", 0, 0);
+	md_misc_wq = alloc_workqueue("md_misc", WQ_PERCPU, 0);
 	if (!md_misc_wq)
 		goto err_misc_wq;
 
-- 
2.52.0

