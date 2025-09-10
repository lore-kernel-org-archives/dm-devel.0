Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4EE255F5E
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 17:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757525299; cv=none; b=Vl3krrqOUlQGHfZ6uq6jtfpVHV3XynWL2DOgNJKe5LSN49jKKhrMns46Q0sA5fCGp56FvYZXiNgzFq83anTDZodOS/uDQm9Vs/U78SxlVSI24ciY+Xl2ei+YQ+Bx93wzi9hHWe4ZSWK9p7+IORlZEBIBUd6BgDpcg4GEcLl0v1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757525299; c=relaxed/simple;
	bh=HONrheF+yhniOsGz6B7hjfHxd925apj7mM8aMEVshJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rOtDERUThNIkUx5cu0OysoXuDZKvE7gW/zqYstKJVBpxsJArD0f9AO3+/HCTJOqHC7PaaOQ6En7qG0UmkhK/6vqRdyFtvHzRITZeV16YVPuiwTu5GI9qgEDKx/3CmJ+osM9rKGtxWsRC6WWuF9fDB1VjEJpwQc9LXSy88Dj5/w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cQq58GoN; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cQq58GoN"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cMSMH4qwMzlgqV9;
	Wed, 10 Sep 2025 17:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1757525290; x=1760117291; bh=CDgW4KseLVAHUTJw7PkjMgOZ8xVqERMsqvk
	G4sJR5Ak=; b=cQq58GoNgSBy5JVReI9TWB2fVucsZ8U8/+2A/a3VCwvm0Vi5KMG
	sxNudduajI4009PA7ZZ/UI8gf9al+7ERBYR8td0OOqonJmcWrO6WJPig8v3K3S5L
	PjIqyoXEyZf8D3KTX5zu9q9NtCMUYmrO6n7G7xQbdUpL0hEl0/WwsRd/tM98DVDB
	gAqrB3wJT9eRo7J+sgQ7sykm4RsNNNJLdRuUlsCvmxfvUiW4ItyYF4LQFvauz97x
	VFMOpI8djlC7MLOPS+kmiecLHYzv7bB3NHZw0rkSsuWbChh5xqKkeqMuTk9pODq0
	fZ+Gx4NX/vXtu2cNrjpMJTXF+pCyBE8sFDA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iWaswBo5_eJN; Wed, 10 Sep 2025 17:28:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cMSMB5Q5Gzlgn8k;
	Wed, 10 Sep 2025 17:28:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>
Subject: [PATCH v2] dm: Preserve the order of REQ_PREFLUSH writes
Date: Wed, 10 Sep 2025 10:27:41 -0700
Message-ID: <20250910172742.187645-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The dm core splits REQ_PREFLUSH bios that have data into two bios.
First, a REQ_PREFLUSH bio with no data is submitted to all underlying
dm devices. Next, the REQ_PREFLUSH flag is cleared and the same bio is
resubmitted. This approach is essential if there are multiple underlying
devices to provide correct REQ_PREFLUSH semantics.

Splitting a bio into an empty flush bio and a non-flush data bio is
not necessary if there is only a single underlying device. Hence this
patch that does not split REQ_PREFLUSH bios if there is only one
underlying device.

This patch preserves the order of REQ_PREFLUSH writes if there is only
one underlying device and if one or more write bios have been queued
past the REQ_PREFLUSH bio before the REQ_PREFLUSH bio is processed.

Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1:
 - Made the patch description more detailed.
 - Removed the reference to write pipelining from the patch description.

 drivers/md/dm.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 66dd5f6ce778..d0791eef21f7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -490,9 +490,13 @@ u64 dm_start_time_ns_from_clone(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
=20
-static inline bool bio_is_flush_with_data(struct bio *bio)
+static inline bool bio_is_flush_with_data(struct mapped_device *md,
+					  struct bio *bio)
 {
-	return ((bio->bi_opf & REQ_PREFLUSH) && bio->bi_iter.bi_size);
+	guard(rcu)();
+
+	return bio->bi_opf & REQ_PREFLUSH && bio->bi_iter.bi_size &&
+	       ((struct dm_table *)rcu_dereference(md->map))->num_targets > 1;
 }
=20
 static inline unsigned int dm_io_sectors(struct dm_io *io, struct bio *b=
io)
@@ -501,7 +505,7 @@ static inline unsigned int dm_io_sectors(struct dm_io=
 *io, struct bio *bio)
 	 * If REQ_PREFLUSH set, don't account payload, it will be
 	 * submitted (and accounted) after this flush completes.
 	 */
-	if (bio_is_flush_with_data(bio))
+	if (bio_is_flush_with_data(io->md, bio))
 		return 0;
 	if (unlikely(dm_io_flagged(io, DM_IO_WAS_SPLIT)))
 		return io->sectors;
@@ -976,7 +980,7 @@ static void __dm_io_complete(struct dm_io *io, bool f=
irst_stage)
 	if (requeued)
 		return;
=20
-	if (bio_is_flush_with_data(bio)) {
+	if (bio_is_flush_with_data(md, bio)) {
 		/*
 		 * Preflush done for flush with data, reissue
 		 * without REQ_PREFLUSH.
@@ -1715,7 +1719,7 @@ static void dm_queue_poll_io(struct bio *bio, struc=
t dm_io *io)
 }
=20
 /*
- * Select the correct strategy for processing a non-flush bio.
+ * Select the correct strategy for processing a bio.
  */
 static blk_status_t __split_and_process_bio(struct clone_info *ci)
 {
@@ -1996,7 +2000,7 @@ static void dm_split_and_process_bio(struct mapped_=
device *md,
 	}
 	init_clone_info(&ci, io, map, bio, is_abnormal);
=20
-	if (bio->bi_opf & REQ_PREFLUSH) {
+	if (bio->bi_opf & REQ_PREFLUSH && ci.map->num_targets > 1) {
 		__send_empty_flush(&ci);
 		/* dm_io_complete submits any data associated with flush */
 		goto out;
