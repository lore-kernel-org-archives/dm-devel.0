Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EDA61F5413
	for <dm-devel@lists.linux.dev>; Thu, 17 Jul 2025 10:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.143.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752748544; cv=none; b=AvQ9Y7b5Inh/TiMVWoYT4Jo0gATQG8AXC+St7yV7JiD4r79XF1TLHT9wEoirpOC3K3DNti7JysHXwM73n+q2vXVVtRBguCFkXrsQ8uDr63oXom5IM12ldzoo9bARvJoQHVmbgBmUK04zZ+wItdsDwK9mXD2ZJE7VZX4tmT+EKfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752748544; c=relaxed/simple;
	bh=rSjhOI59KDa5inUMov9bJZFHW6fti21tVc0v3DX0qY0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iOHCFMeaxFQ9BiHCk8xpDlFoiqhNNqzB6yci4NfOUWphpK6IWMvVoVyIC3bfhHzNee4MIs5xSFwbLGM+AmLdirowfWWw5RudIwUf40nmtA0p4DagiWSUuJpiAheVKmZFloV5F8MFPKoaxhMU2tp7j/ccPTmgpPfGFD9SM6Yx6Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=GB3GO6II; arc=none smtp.client-ip=68.232.143.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GB3GO6II"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1752748542; x=1784284542;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rSjhOI59KDa5inUMov9bJZFHW6fti21tVc0v3DX0qY0=;
  b=GB3GO6II6632Lhke6cWlSGV8vzWXx4kdczXuS5SluifxaivEOF3sMjJg
   NKJPYTKvHOryF6oSjLUkcmue2edGA0OAC2k14EU07O8FTDiSIXPcf5m0l
   +BLMN8ZOkgv6r1Xc/OtwqAbnNeen3cH+xfOWn7ikqeU0C6ujFp4DUMM2G
   CAPw6FSQrTmh1RNiBS1MlRxkBYRfwZOe6F42p6Az33brSJRCJCMnq85cb
   T7b58SKid6xsCxFXPaOoEs949xviLGA1npCrcozI52O+xKqeHk91YF3Fy
   wafmJCC2W8seNFwdfGLJ4TPGOw9QNfY22dUw+6q32NniPLoBriJq8vjhB
   g==;
X-CSE-ConnectionGUID: AfaU4jIQTOSSc/tyafoFAA==
X-CSE-MsgGUID: f8pHYDqHS8W4tIi3reVcFA==
X-IronPort-AV: E=Sophos;i="6.16,318,1744041600"; 
   d="scan'208";a="95470498"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jul 2025 18:35:42 +0800
IronPort-SDR: 6878c35a_9QxFM/lAv4ztzHDK3Xql10soFnPhIsNopcWEJd+ZpMJQULK
 7FolOHG16xeX69gYdxuDPzUFRoky5WI0YuTZdeA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jul 2025 02:33:15 -0700
WDCIronportException: Internal
Received: from 5cg2012pzy.ad.shared (HELO shinmob.flets-east.jp) ([10.224.173.149])
  by uls-op-cesaip02.wdc.com with ESMTP; 17 Jul 2025 03:35:40 -0700
From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH for-next v2] dm: split write BIOs on zone boundaries when zone append is not emulated
Date: Thu, 17 Jul 2025 19:35:39 +0900
Message-ID: <20250717103539.37279-1-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 2df7168717b7 ("dm: Always split write BIOs to zoned device
limits") updates the device-mapper driver to perform splits for the
write BIOs. However, it did not address the cases where DM targets do
not emulate zone append, such as in the cases of dm-linear or dm-flakey.
For these targets, when the write BIOs span across zone boundaries, they
trigger WARN_ON_ONCE(bio_straddles_zones(bio)) in
blk_zone_wplug_handle_write(). This results in I/O errors. The errors
are reproduced by running blktests test case zbd/004 using zoned
dm-linear or dm-flakey devices.

To avoid the I/O errors, handle the write BIOs regardless whether DM
targets emulate zone append or not, so that all write BIOs are split at
zone boundaries. For that purpose, drop the check for zone append
emulation in dm_zone_bio_needs_split(). Its argument 'md' is no longer
used then drop it also.

Fixes: 2df7168717b7 ("dm: Always split write BIOs to zoned device limits")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
* Changes from v1:
- Dropped the first paragraph of the commit message
- Improved the block comment

 drivers/md/dm.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca889328fdfe..abfe0392b5a4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1785,8 +1785,7 @@ static void init_clone_info(struct clone_info *ci, struct dm_io *io,
 }
 
 #ifdef CONFIG_BLK_DEV_ZONED
-static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
-					   struct bio *bio)
+static inline bool dm_zone_bio_needs_split(struct bio *bio)
 {
 	/*
 	 * Special case the zone operations that cannot or should not be split.
@@ -1802,13 +1801,11 @@ static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
 	}
 
 	/*
-	 * Mapped devices that require zone append emulation will use the block
-	 * layer zone write plugging. In such case, we must split any large BIO
-	 * to the mapped device limits to avoid potential deadlocks with queue
-	 * freeze operations.
+	 * When mapped devices use the block layer zone write plugging, we must
+	 * split any large BIO to the mapped device limits to not submit BIOs
+	 * that span zone boundaries and to avoid potential deadlocks with
+	 * queue freeze operations.
 	 */
-	if (!dm_emulate_zone_append(md))
-		return false;
 	return bio_needs_zone_write_plugging(bio) || bio_straddles_zones(bio);
 }
 
@@ -1932,8 +1929,7 @@ static blk_status_t __send_zone_reset_all(struct clone_info *ci)
 }
 
 #else
-static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
-					   struct bio *bio)
+static inline bool dm_zone_bio_needs_split(struct bio *bio)
 {
 	return false;
 }
@@ -1960,7 +1956,7 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 
 	is_abnormal = is_abnormal_io(bio);
 	if (static_branch_unlikely(&zoned_enabled)) {
-		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
+		need_split = is_abnormal || dm_zone_bio_needs_split(bio);
 	} else {
 		need_split = is_abnormal;
 	}
-- 
2.50.1

