Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F861FC3
	for <dm-devel@lists.linux.dev>; Mon, 12 May 2025 23:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747091467; cv=none; b=m9MnIoQq2wJVMoy0cUHmVaGXNfalI0ssZhN+FboH2dWPucEWe8EllZX3DHNizvRs9WqERnwPKyGaUCAaz7KDv1dCtcMTVlrAjnKvrat2AEOoFzy1oK2jRe7p8DpZ0zHky2N58LiyUwgPVS8cgTPtVPIAbHzKqDAnEiQ+Jz0S9tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747091467; c=relaxed/simple;
	bh=Qi13CNnogSbiS0dFpoJs1L8dGQ8hx35ryntd8HTljlY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sCHENQNM+nSVWfDuMelTK3YkNOf0qfmG6E1AmmzsRUz+KGJcr+O2YjLK4MJYBDRnIQ8VAh5s/x09iTyRjb3UUkUqAOExdxBc7isqfDlPxC0joK2MQ/3inR9S6RV1wVAZ4h0OnupMGyzPcF9nvptWV2cwbFiUm+smLditV2uhnWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3uBiRbiu; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3uBiRbiu"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZxFhm4GzZzltKl3;
	Mon, 12 May 2025 23:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1747091463; x=1749683464; bh=T76eC6rzEDzp+jk5pgTixlWxfUSKmqgWwnP
	nn4N4UDo=; b=3uBiRbiuDppP2DUCfctwbg066QhdUqVJO/PuPdQ+sLkpHXrFi4A
	Tu6sKqZiTkLwaEQiejZu+YOVSp/x8z4PB91hJi+6mWAdV7xKAps7bZWZirDSCkTH
	tk5ijq5DVsUv/sSrHVg4ULq5HHFQvfV/3fNKq56K7eWWX4XQSKhOAyHXwat9fcDN
	8qeJ3B3G0kHRLWQIAVG7UcMdOQ90BzUJLWBccWeiaTv7d22ZqNYyf1/BzcQpbw9o
	jtreYNpD9j/OYivk2lAOTYNdTPSpxl31mNgBeJhH8D5YH1vn9Gmq9Gnr1+ZW5mPO
	zFjOC8YmGAunY1RLu4sJRjZmwNDmk6tgP8w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id zyykAH9Bp9mF; Mon, 12 May 2025 23:11:03 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZxFhh22BMzlsxF1;
	Mon, 12 May 2025 23:10:58 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: dm-devel@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH] dm-zone: Use bdev_*() helper functions where applicable
Date: Mon, 12 May 2025 16:10:27 -0700
Message-ID: <20250512231027.251751-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Improve code readability by using bdev_is_zone_start() and
bdev_offset_from_zone_start() where applicable. No functionality
has been changed.

This patch includes a subset of a patch from Pankaj Raghav.

See also https://lore.kernel.org/linux-block/20220923173618.6899-11-p.rag=
hav@samsung.com/.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/md/dm-table.c | 4 ++--
 drivers/md/dm-zone.c  | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6b23e777e10e..4e2a5fe8986f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -257,7 +257,7 @@ static int device_area_is_invalid(struct dm_target *t=
i, struct dm_dev *dev,
 	if (bdev_is_zoned(bdev)) {
 		unsigned int zone_sectors =3D bdev_zone_sectors(bdev);
=20
-		if (start & (zone_sectors - 1)) {
+		if (!bdev_is_zone_start(bdev, start)) {
 			DMERR("%s: start=3D%llu not aligned to h/w zone size %u of %pg",
 			      dm_device_name(ti->table->md),
 			      (unsigned long long)start,
@@ -274,7 +274,7 @@ static int device_area_is_invalid(struct dm_target *t=
i, struct dm_dev *dev,
 		 * devices do not end up with a smaller zone in the middle of
 		 * the sector range.
 		 */
-		if (len & (zone_sectors - 1)) {
+		if (!bdev_is_zone_start(bdev, len)) {
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
