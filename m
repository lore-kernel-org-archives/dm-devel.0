Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0832750E3
	for <dm-devel@lists.linux.dev>; Tue,  9 Sep 2025 18:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757442427; cv=none; b=etTxQ3Qp5bktX1KywOGhbq6NRtthuZhzJ4Y0MnYF+Vh8OytaJ9OxCQkpMN/jV4D5YVl1ooE/xL0fElcHDK48XxN10so94Nj+nOZdO5tOzzggEYyb964WZvJL9DC/fFGQ3dcparl/UxMAJ4MllWQJtg63ok2Y2Jq51FOshU9KHjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757442427; c=relaxed/simple;
	bh=rpbdHd3WaoK5cdh7o809UiKQeSa9jDi1qGqgFENfd/U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JHGHYP0pkdkw8c8C4n2q7t2ba6lrT05Q1YV/vlj9l7RLjaPvZrOoYPHbKcIJDa5Qba8rRigk5tm4xaBv6iEaeytqhKgLr0jTyCV51LMyog/d/frvG9uPrgAyUJFlOLatEmUaEOdWYPf0I/lUJjbTAIUuMWyWlkYCG1AH4tv8kBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jimSMqXl; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jimSMqXl"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cLsjb237Xzm174F;
	Tue,  9 Sep 2025 18:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1757442417; x=1760034418; bh=Vi6Z22Lv+oo5sNCFQnB7iFn27Ygp5Pv6yiY
	uVGhDZ0s=; b=jimSMqXldkIgR3OJuWOg5SrhFqqfwu0dDXNWCHf/MJhENZp+mL6
	28/ySKQgkYBcGDEElYDVbvGsvhmdXtoenjxm8VJePKk1+TIWQRWM4yjkCXYBvheM
	ywN6liId/WAbd9NhGu8ulApfSq5wmcbdg2lW2cSij+ei77xQBMW0apz8SMx8dZ1n
	WBpqIeoE8YmSZVcBaLTl02UsOheki4IvTUD9qKM7P28aUKvBafTFQqN0SBNY7+mE
	PEenaCooumkzRISLFUqTvMo7y1FJJ7H5InGEqIgIDAUwxcSSxWV6WGs70GK8pfkc
	mhwdo7smZzSWxDOmQrsAUb4WHbc71aKbH+A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ALqiw2EQTjYm; Tue,  9 Sep 2025 18:26:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cLsjV1Ntnzm1749;
	Tue,  9 Sep 2025 18:26:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>
Subject: [PATCH] dm: Preserve the order of REQ_PREFLUSH writes
Date: Tue,  9 Sep 2025 11:26:40 -0700
Message-ID: <20250909182641.3496300-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Splitting a bio into an empty flush bio and a non-flush data bio is
only necessary if there are multiple underlying devices. Do not split
REQ_PREFLUSH bios if there is only one underlying device. This patch
preserves the order of REQ_PREFLUSH writes if there is only one
underlying device and if multiple writes are queued. This patch fixes
a write error observed with zoned storage devices and with write
pipelining enabled.

Cc: Mike Snitzer <snitzer@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
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
