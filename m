Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE4517C98;
	Thu,  3 Oct 2024 01:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727918178; cv=none; b=OZ1etKO16w2a5YqcErBjM6muaqmGArhmU0bsh5TzWBWzPkp4ueKhMd1YRzlAOhJLMlC8zgGXHvb2vHfSF0Yl3E+RQDqPCLFwZuECfLHLngUQBOmzHW5WwMle7qHCcYPK261z3UwGaGvi667FL7PqawPzIZ1NCWkcuJrMpdwDi7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727918178; c=relaxed/simple;
	bh=eaSJLNLPMGgaZ7Hm0PkTjhFdrJccaWT0Vr7021A2J2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nk0QwvUKY/0ijV0TcfEBEqS+azJcaGEdlXgiIE5qemiEDmvcUj4rT+qlpPwDW9MRMLwoyXFgdTB5XtYi7zy0/tpTG+HNRtMn+ckDw55GotCtWgdam9w55nT+Gtz2X4ty9d8f/ElNj1pSVOHX3LD63gklAP1DSgOTEg9J1qWBhmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=L6agMQxP; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="L6agMQxP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=bMs5sCW3AIt+TA9E46n5r8V+O+7TgYy4TKjdM6BV0Hc=; b=L6agMQxPaevo90kg
	1geRxu/lY3YfB8XyE3cGnHPtUPdlpjkcCnP1dYUFLZR/U5YmInEFMAaM3WvuIlcD3WL1bAve8rpJj
	QmEDV9iC6k3a+ZpGTGFAyv+dRUujv5X301UdmhyqDrpXuJvx9j7cLtz5GM7U/dRH3jD6o/c6Z7dmy
	gEDh2wVKI5CcHXKTF8jNLPb3WuF43stWCIVnIQBxBUS1hrlmlYLeE0xGAAlPBok9TDQTwpMrKhnIF
	NbK7Sw5OEEbTFPeEGBvpoO2Zh1W1RqyQaRPK2gGUR0Z7Rx74hl92deXTrAqankFlcChsxwnTKaqPa
	jBHeaoBnILyf9IN0yw==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1swARw-008Zju-16;
	Thu, 03 Oct 2024 01:16:12 +0000
From: linux@treblig.org
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 7/9] dm: zoned: Remove unused functions
Date: Thu,  3 Oct 2024 02:15:52 +0100
Message-ID: <20241003011554.266654-8-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241003011554.266654-1-linux@treblig.org>
References: <20241003011554.266654-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

dmz_resume_metadata() is unused since it was added in commit
3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")

dmz_zone_nr_blocks_shift is unused since it was added in commit
368205601375 ("dm zoned: move fields from struct dmz_dev to dmz_metadata")

Remove them.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/md/dm-zoned-metadata.c | 50 ----------------------------------
 drivers/md/dm-zoned.h          |  2 --
 2 files changed, 52 deletions(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index 8156881a31de..deff22ecccbb 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -245,11 +245,6 @@ unsigned int dmz_zone_nr_blocks(struct dmz_metadata *zmd)
 	return zmd->zone_nr_blocks;
 }
 
-unsigned int dmz_zone_nr_blocks_shift(struct dmz_metadata *zmd)
-{
-	return zmd->zone_nr_blocks_shift;
-}
-
 unsigned int dmz_zone_nr_sectors(struct dmz_metadata *zmd)
 {
 	return zmd->zone_nr_sectors;
@@ -3005,48 +3000,3 @@ void dmz_dtr_metadata(struct dmz_metadata *zmd)
 	dmz_cleanup_metadata(zmd);
 	kfree(zmd);
 }
-
-/*
- * Check zone information on resume.
- */
-int dmz_resume_metadata(struct dmz_metadata *zmd)
-{
-	struct dm_zone *zone;
-	sector_t wp_block;
-	unsigned int i;
-	int ret;
-
-	/* Check zones */
-	for (i = 0; i < zmd->nr_zones; i++) {
-		zone = dmz_get(zmd, i);
-		if (!zone) {
-			dmz_zmd_err(zmd, "Unable to get zone %u", i);
-			return -EIO;
-		}
-		wp_block = zone->wp_block;
-
-		ret = dmz_update_zone(zmd, zone);
-		if (ret) {
-			dmz_zmd_err(zmd, "Broken zone %u", i);
-			return ret;
-		}
-
-		if (dmz_is_offline(zone)) {
-			dmz_zmd_warn(zmd, "Zone %u is offline", i);
-			continue;
-		}
-
-		/* Check write pointer */
-		if (!dmz_is_seq(zone))
-			zone->wp_block = 0;
-		else if (zone->wp_block != wp_block) {
-			dmz_zmd_err(zmd, "Zone %u: Invalid wp (%llu / %llu)",
-				    i, (u64)zone->wp_block, (u64)wp_block);
-			zone->wp_block = wp_block;
-			dmz_invalidate_blocks(zmd, zone, zone->wp_block,
-					      zmd->zone_nr_blocks - zone->wp_block);
-		}
-	}
-
-	return 0;
-}
diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
index 265494d3f711..59ba0aaa9531 100644
--- a/drivers/md/dm-zoned.h
+++ b/drivers/md/dm-zoned.h
@@ -192,7 +192,6 @@ enum {
 int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
 		     struct dmz_metadata **zmd, const char *devname);
 void dmz_dtr_metadata(struct dmz_metadata *zmd);
-int dmz_resume_metadata(struct dmz_metadata *zmd);
 
 void dmz_lock_map(struct dmz_metadata *zmd);
 void dmz_unlock_map(struct dmz_metadata *zmd);
@@ -230,7 +229,6 @@ unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd, int idx);
 unsigned int dmz_nr_seq_zones(struct dmz_metadata *zmd, int idx);
 unsigned int dmz_nr_unmap_seq_zones(struct dmz_metadata *zmd, int idx);
 unsigned int dmz_zone_nr_blocks(struct dmz_metadata *zmd);
-unsigned int dmz_zone_nr_blocks_shift(struct dmz_metadata *zmd);
 unsigned int dmz_zone_nr_sectors(struct dmz_metadata *zmd);
 unsigned int dmz_zone_nr_sectors_shift(struct dmz_metadata *zmd);
 
-- 
2.46.2

