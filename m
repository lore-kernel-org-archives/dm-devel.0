Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793846941;
	b=TBZycIdZT5Sr/7QEbmRkr3rriE9VaIaKzPbP8eBxSeHlVy7QK/HkKyf9y6dOazRmiu+Z
	 tAGM25He0jdTcLIIJ/r4MEHOmomMuLATou1Af5Hi2toKYp6pDdjvKlITZL2uqxalU9nMO
	 UJZDhP/SlSQe+HWp7gsz0qc2HuyyCn5kUuMNG74mRVHz9owTE6+2ADGwvsPJUrZ6TtFcB
	 kJNiOP8/s1GZytRBLLQr1afpFNvw4ZJIJxvtEFqwjr8bll58hU7QqwlHlWmVOb/ThvBlX
	 Dzp2xgOan1nat5E1J9QywUtIGzmHe907MyZ+59h6mcCsPvhUcmZgrfJPKj+pIzBxANg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793846941;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=FKBNEnYTdFQwZoVoFH6/jkTZRVpG1zL+lcRWLILZ58U=;
	b=u0oBqaJh2E7shNJDieUfTaZ4szuabS00Yg1+eVn1ZaIpZ14T84qc6ZxKkt2FybgBPgjK
	 to7IjpYifpoyNm3k+Fq1UCK4ZiVM15qbr00wMzZ/jO8wWDfh7RzAEr/ELTekpnkywMyJB
	 IKzrPo2lCziZKa8jqMt9sIv2va42COfriO6f28B4FK6EMBB9Tz5yOjHAhDkZMVyI60Llr
	 c1Z4Mj5xm2oRtdT49/kSDU1+lGxMss7itWkcCZ8gpFBun6i/xknXMSZ93nOU2G7nv/YSf
	 7dutIBemVrBfgu6Og6dFzPSrva5xc99ycLPwCoLbrybHe3B+YqyPZUF+xdUvDZweuHA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b585LFOd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707C3606A326;
	Thu,  5 Nov 2026 02:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b585LFOd
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793846941;
	b=Df4MJKgAFqapVFsyYMzwYH/h2mGgurMkKm+lSFJy7ok2xjBDZRS1sTpdzD4v0xao2Wup
	 ltBTj8LTJkB7f8BOgZyKmgAR3wHS8QlfIoXI5Pyjv9Adckbg5CGU9AMJAFr+KslB7jRd9
	 rEaINQpW+mMPr8twyEOgV/ZeSpdq6cjZrpkTPlgoHw1uAeQBeZ/b/P4rElY6+UjFY8cJL
	 TCSNaR0ZxPKfOT05uu7lJV5lFd63gDvcKFGOnM+i+dfWGqxUXb+chrZfGf5R5QUi14Kce
	 9Fqijrah1eD+m3c+MGCa/A5TkCBGSYcb0qsG+vMLUUvR/Y+PmPrc/C24LouAgpxJQng==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793846941;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:To:Cc:X-Mailer:X-Developer-Signature:
	 X-Developer-Key:X-Endpoint-Received:X-Original-From:Reply-To:
	 Content-Transfer-Encoding;
	bh=FKBNEnYTdFQwZoVoFH6/jkTZRVpG1zL+lcRWLILZ58U=;
	b=2KaIaqBD4rOGNpNwP/1NP5KEsj4UrDZfozAzp6kNjVITNU4ozgklwci3GyehxTC44JPY
	 PGgMUmoC+RQy29qFEhBG8yb2bfYtIDPEVS5R0jsXv9/8JGyzOieZ0WnZ8yUrbvInP13yc
	 o0P4//0JTgp8tNRkuUpsaro9c2VBSebzIysWOqtpcJpc6QVU8HJn471OfM20BKP4j9/Tf
	 3atRVCmq4YdTrJtK0cKWODxOzCyb9BTRl7Ja5poBWcsCJedk6DotgMW66jaLq9N6MQptU
	 32Ut/HTRiEaNirDnHR+UAWE1qbnn4oXo8xTaWILt8QJkWeDDRPNoqTopBHmwAEe5CDA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 589471F000C1;
	Thu,  5 Nov 2026 02:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793846940;
	bh=FKBNEnYTdFQwZoVoFH6/jkTZRVpG1zL+lcRWLILZ58U=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=b585LFOd6PoGVcUY+koOjRbY7jcmMttI1FUjVplyfa7agfoRVP8L+JvWZ1MQtlamR
	 Z8lU5v7t3g+aqdd7kjOn0+7eGYCDjTMzmbzU/JLnkRHH0LfdTEnYd6Vp7DIzsVPizZ
	 +yF8LyMJMfYC7te38EXJ5x78PjOX+cAqTq8ero3BuoGOgMhkgSM0ks6ubgRqNhU6Gl
	 /FaFKa0HXMvCkPoKlZo8PpjIHmF0ym+0kUiKFiTmc/WDgJiqZg/kbz2mrlCWbZephR
	 JIatxY69i1kHfyZUbK4bKgSe7erR7WuvDuxjYWVskz1Z1ESq32/3WvCCShtN8KaduA
	 7mqN2djaTRNbg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id ABEAA4704A;
	Thu,  5 Nov 2026 02:48:59 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Date: Thu, 05 Nov 2026 11:49:00 +0900
Subject: [PATCH] dm-log-writes: log earlier flushes' writes when a later
 flush completes
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
Message-Id: <20261105-dmlw-flush-order-v1-1-4f154e06bc78@samsung.com>
X-B4-Tracking: v=1; b=H4sIAJvu62oC/x3MSQqAMAxA0auUrA3YguNVxIW0qQbUSooDFO9uc
 fkW/yeIJEwRepVA6OLIYc/QhQK7TPtMyC4bTGlqrcsK3bbe6NczLhjEkeBETdcaWzlvasjZIeT
 5+ZfD+L4fp3Lx02IAAAA=
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev
Cc: Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793846939; l=5569;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=QMRPbrKH67WwaocGnLh1SuH2BjgDRIWTU01gSB6rW3k=;
 b=tqLmSXBijEpYe5T4s0jo8SrtcUdu54mPjNscxK+IvpTmPO+zaxGm2962Y69S4Y0hU5qGV/HEb
 us+23pU/duUDY/1bGrXInEfptTzvY5eKlV5MdiRw8qNavJFmTaKqhzH
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
Content-Transfer-Encoding: 7bit

From: Daejun Park <daejun7.park@samsung.com>

Each flush takes the writes that completed since the previous flush
was issued, and logs them when it completes. If a later flush
completes first, the earlier flush's writes are logged after anything
logged in between, such as a mark. A replay to that mark then misses
writes that were already stable. Crash consistency tests report this
as data loss.

Those writes completed before the later flush was issued, so its
completion makes them stable. Log them when it completes, and document
this in log-writes.rst.

Fixes: 0e9cebe72459 ("dm: add log writes target")
Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
Found on XFS (xfs for-next, QEMU guest, loop devices on tmpfs) with 8
writers that each write a block, fsync it and log a mark. A replay to
the mark missed the fsynced block at 3 of 1408 marks without this
patch and at none of 1408 with it. generic/455 457 482 757 pass with
and without it, and KASAN and lockdep report nothing.
---
 .../admin-guide/device-mapper/log-writes.rst       |  6 +++++
 drivers/md/dm-log-writes.c                         | 30 ++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/Documentation/admin-guide/device-mapper/log-writes.rst b/Documentation/admin-guide/device-mapper/log-writes.rst
index 23141f2ffb7..1223803684e 100644
--- a/Documentation/admin-guide/device-mapper/log-writes.rst
+++ b/Documentation/admin-guide/device-mapper/log-writes.rst
@@ -36,6 +36,12 @@ Again this is to simulate what is actually on disk, this allows us to detect
 cases where a power failure at a particular point in time would create an
 inconsistent file system.
 
+If a later REQ_PREFLUSH request completes while an earlier one is still in
+flight, the WRITEs attached to the earlier request are logged then, ahead of the
+later request's own WRITEs. They completed before the later REQ_PREFLUSH was
+issued, so they are on disk as well. The earlier FLUSH is logged when it
+completes.
+
 Any REQ_FUA requests bypass this flushing mechanism and are logged as soon as
 they complete as those requests will obviously bypass the device cache.
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index c72e07c3f5a..982a240f031 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -115,6 +115,7 @@ struct log_writes_c {
 	spinlock_t blocks_lock;
 	struct list_head unflushed_blocks;
 	struct list_head logging_blocks;
+	struct list_head inflight_flushes;
 	wait_queue_head_t wait;
 	struct task_struct *log_kthread;
 	struct completion super_done;
@@ -128,6 +129,7 @@ struct pending_block {
 	char *data;
 	u32 datalen;
 	struct list_head list;
+	struct list_head flush_list;
 	struct bio_vec vecs[];
 };
 
@@ -526,6 +528,7 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	}
 	spin_lock_init(&lc->blocks_lock);
 	INIT_LIST_HEAD(&lc->unflushed_blocks);
+	INIT_LIST_HEAD(&lc->inflight_flushes);
 	INIT_LIST_HEAD(&lc->logging_blocks);
 	init_waitqueue_head(&lc->wait);
 	init_completion(&lc->super_done);
@@ -629,6 +632,7 @@ static void log_writes_dtr(struct dm_target *ti)
 
 	WARN_ON(!list_empty(&lc->logging_blocks));
 	WARN_ON(!list_empty(&lc->unflushed_blocks));
+	WARN_ON(!list_empty(&lc->inflight_flushes));
 	dm_put_device(ti, lc->dev);
 	dm_put_device(ti, lc->logdev);
 	kfree(lc);
@@ -688,6 +692,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 		spin_unlock_irq(&lc->blocks_lock);
 		return DM_MAPIO_KILL;
 	}
+	INIT_LIST_HEAD(&block->flush_list);
 	INIT_LIST_HEAD(&block->list);
 	pb->block = block;
 	atomic_inc(&lc->pending_blocks);
@@ -717,6 +722,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	if (flush_bio && !bio_sectors(bio)) {
 		spin_lock_irq(&lc->blocks_lock);
 		list_splice_init(&lc->unflushed_blocks, &block->list);
+		list_add_tail(&block->flush_list, &lc->inflight_flushes);
 		spin_unlock_irq(&lc->blocks_lock);
 		goto map_bio;
 	}
@@ -764,6 +770,29 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	return DM_MAPIO_REMAPPED;
 }
 
+/*
+ * A flush mapped before @block holds writes that completed before @block was
+ * mapped, so @block's completion makes them stable. Queue them ahead of
+ * @block's own writes. inflight_flushes holds the empty flushes, in map order,
+ * whose writes are not yet queued.
+ */
+static void log_earlier_flushes(struct log_writes_c *lc,
+				struct pending_block *block)
+{
+	struct pending_block *prev;
+
+	lockdep_assert_held(&lc->blocks_lock);
+	if (list_empty(&block->flush_list))
+		return;
+	while ((prev = list_first_entry(&lc->inflight_flushes,
+					struct pending_block,
+					flush_list)) != block) {
+		list_splice_tail_init(&prev->list, &lc->logging_blocks);
+		list_del_init(&prev->flush_list);
+	}
+	list_del_init(&block->flush_list);
+}
+
 static int normal_end_io(struct dm_target *ti, struct bio *bio,
 		blk_status_t *error)
 {
@@ -776,6 +805,7 @@ static int normal_end_io(struct dm_target *ti, struct bio *bio,
 
 		spin_lock_irqsave(&lc->blocks_lock, flags);
 		if (block->flags & LOG_FLUSH_FLAG) {
+			log_earlier_flushes(lc, block);
 			list_splice_tail_init(&block->list, &lc->logging_blocks);
 			list_add_tail(&block->list, &lc->logging_blocks);
 			wake_up_process(lc->log_kthread);

---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261105-dmlw-flush-order-ae7982c5df26

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


