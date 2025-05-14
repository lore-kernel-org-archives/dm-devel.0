Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35562E55B
	for <dm-devel@lists.linux.dev>; Wed, 14 May 2025 20:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747255853; cv=none; b=aKoGaXOgKa1XNhVAG32yM15wbjlSAvFqR6c0en34NnE0Q5JoSrpTO7uOtz3RCnf/LCmOoWPnj9lJwmscrWMg1Wdczn7Lvf0DVVtrY5Aqfg8XNG4+qgqXeZ9LitCgS9OJgiZtPI/lzV/aGxX1GyATP92kLAdGk6FoXa6X3vxmNyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747255853; c=relaxed/simple;
	bh=hMP8MvNBqDJ5FhH5B1imFxBEcSPE9JQFPioEMEaZYF0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GQ39dpmYzgpv5pr5M87p+7meuBZDcThAOXt9f9kby3MrHAwdzVi9XN751fnOqIeQR9EenkD4l0SEqQoy4fF70ALBeoZJUfCKftxgRgdzvHGDPqSyVJL2d7nY1sBiPySGvAieEs4ceyhuC6PSi9ENcR9ani4jwJK5LC/asctK0WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SagxdIQk; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SagxdIQk"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZyQTx11dTzlt4DD;
	Wed, 14 May 2025 20:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1747255843; x=1749847844; bh=zOWuZicnPbUQJD+E1wOUKcwavvOnGqtoI7U
	5x88pFb4=; b=SagxdIQksmR8iNkWJVUOVoA3BweJ++qv0D07sEv+6qs4KNCkjVb
	m0dG2HF6zxx83KK5Y+kMZc2imsiwmryFbNXIrTB0ngZocOd/BqF63eWTLbMQRnC6
	K1KXLaOk7h+7AtuWLrg15mE1dQVtr8RMaDWaF/RHZxhd4u4wxF/kur1TrASvZkAS
	O/vc+Z+e7SC7fJW0XlLAN9rhSn54uVRojOaHgREFfUXdiBzaDsjpXYlJoctxyhiq
	jY8A9uB6SrwMHEzJbefduDN3hjEg2oB1FdWtX5CIOBudfCy2EfuMMNDvnrKF6NDf
	XkCkNb8GQ7QvUIyUbBmKyL4trlhH48Srcjw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZR0a7-iTDlrN; Wed, 14 May 2025 20:50:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZyQTr4DPszm2jWv;
	Wed, 14 May 2025 20:50:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2] dm-zone: Use bdev_*() helper functions where applicable
Date: Wed, 14 May 2025 13:50:33 -0700
Message-ID: <20250514205033.2108129-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Improve code readability by using bdev_is_zone_aligned() and
bdev_offset_from_zone_start() where applicable. No functionality
has been changed.

This patch is a reworked version of a patch from Pankaj Raghav.

See also https://lore.kernel.org/linux-block/20220923173618.6899-11-p.rag=
hav@samsung.com/.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1: introduced a new function bdev_is_zone_aligned().

 drivers/md/dm-table.c  | 4 ++--
 drivers/md/dm-zone.c   | 6 +++---
 include/linux/blkdev.h | 7 +++++++
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6b23e777e10e..2fd190579655 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -257,7 +257,7 @@ static int device_area_is_invalid(struct dm_target *t=
i, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors =3D bdev_zone_sectors(bdev);
=20
-		if (start & (zone_sectors - 1)) {
+		if (!bdev_is_zone_aligned(bdev, start)) {
 			DMERR("%s: start=3D%llu not aligned to h/w zone size %u of %pg",
 			      dm_device_name(ti->table->md),
 			      (unsigned long long)start,
@@ -274,7 +274,7 @@ static int device_area_is_invalid(struct dm_target *t=
i, struct dm_dev *dev,
 		 * devices do not end up with a smaller zone in the middle of
 		 * the sector range.
 		 */
-		if (len & (zone_sectors - 1)) {
+		if (!bdev_is_zone_aligned(bdev, len)) {
 			DMERR("%s: len=3D%llu not aligned to h/w zone size %u of %pg",
 			      dm_device_name(ti->table->md),
 			      (unsigned long long)len,
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 20edd3fabbab..7e184ffba252 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -423,9 +423,9 @@ void dm_zone_endio(struct dm_io *io, struct bio *clon=
e)
 	 */
 	if (clone->bi_status =3D=3D BLK_STS_OK &&
 	    bio_op(clone) =3D=3D REQ_OP_ZONE_APPEND) {
-		sector_t mask =3D bdev_zone_sectors(disk->part0) - 1;
-
-		orig_bio->bi_iter.bi_sector +=3D clone->bi_iter.bi_sector & mask;
+		orig_bio->bi_iter.bi_sector +=3D
+			bdev_offset_from_zone_start(disk->part0,
+						    clone->bi_iter.bi_sector);
 	}
=20
 	return;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9a1f0ee40b56..5b863c163d3c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1442,6 +1442,13 @@ static inline bool bdev_is_zone_start(struct block=
_device *bdev,
 	return bdev_offset_from_zone_start(bdev, sector) =3D=3D 0;
 }
=20
+/* Check whether @sector is a multiple of the zone size. */
+static inline bool bdev_is_zone_aligned(struct block_device *bdev,
+					sector_t sector)
+{
+	return bdev_is_zone_start(bdev, sector);
+}
+
 /**
  * bdev_zone_is_seq - check if a sector belongs to a sequential write zo=
ne
  * @bdev:	block device to check
