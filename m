Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FD2143881;
	Thu, 30 May 2024 05:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717047642; cv=none; b=O9adZjRG7e4R0UfsVXOoj4A2cBxhE1NlxIp34YyjGQZeizB8arOhhhmI3iZUgSGzoFRXgFgvCjfHAafRrVhUO8YXf9/J7dk0EqnwsIIjVWowzRvLSUc7fqE1Oyrp2ntqvCGuaxKE7yezn6cpM/fGLfXs6gc10XNPCyBRxqUkPyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717047642; c=relaxed/simple;
	bh=PdWwzmYj0FalkU2p3VQavwmK6ssWnPRHTkGVetRA6oE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=srWaTmvNRvM8nVZSEnYAGrQd4/TMh0ZzE6Sjc16EymPuXtOB/a6D5p9EQl/QgOdP8UFP9nCNU+u6Vl4tWWGJ7ccCdVbgfvet/oVMkEZAC4FCKD20FQhpf+oK85XBRSKE7ScDzrtAZJOvoi0zmb0sTyS0IzUJ5lcUb+WCPJy6L80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MhiNy0fM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MhiNy0fM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0346FC3277B;
	Thu, 30 May 2024 05:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717047641;
	bh=PdWwzmYj0FalkU2p3VQavwmK6ssWnPRHTkGVetRA6oE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MhiNy0fMo/5SPPz/ebLCpn6dDGVoN8dsvTtf3BUr7eUi/+Am36P3vpIr2gSwlJc5K
	 yfS/koeL0iunR6q4v/8/YO0Fcbpa+oDrUqkqAAtliR7DPPubMhDnsIl15DBiDbESL/
	 7k4egnDXPRnmqHr2F4jc8P7CpJ2L0itIInOsRY5+Gf+PMY+KNkqGwG6chXnPasyBd6
	 bSkYfJ5TmyUgFotB5NAMcPh5Yx9bEWdagX0HF7YiT/PBTzx7R3HeLxoIKbF/hqdWJs
	 jVv0zrEE1opN6tok3R02H3p2UQu1UBY1U/avMPihHZ9Mpruls3sE3eCvpDfW4ic0/d
	 n2fMU7pMILkow==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] block: Fix validation of zoned device with a runt zone
Date: Thu, 30 May 2024 14:40:33 +0900
Message-ID: <20240530054035.491497-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240530054035.491497-1-dlemoal@kernel.org>
References: <20240530054035.491497-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit ecfe43b11b02 ("block: Remember zone capacity when revalidating
zones") introduced checks to ensure that the capacity of the zones of
a zoned device is constant for all zones. However, this check ignores
the possibility that a zoned device has a smaller last zone with a size
not equal to the capacity of other zones. Such device correspond in
practice to an SMR drive with a smaller last zone and all zones with a
capacity equal to the zone size, leading to the last zone capacity being
different than the capacity of other zones.

Correctly handle such device by fixing the check for the constant zone
capacity in blk_revalidate_seq_zone() using the new helper function
disk_zone_is_last(). This helper function is also used in
blk_revalidate_zone_cb() when checking the zone size.

Fixes: ecfe43b11b02 ("block: Remember zone capacity when revalidating zones")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 03aa4eead39e..402a50a1ac4d 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -450,6 +450,11 @@ static inline bool disk_zone_is_conv(struct gendisk *disk, sector_t sector)
 	return test_bit(disk_zone_no(disk, sector), disk->conv_zones_bitmap);
 }
 
+static bool disk_zone_is_last(struct gendisk *disk, struct blk_zone *zone)
+{
+	return zone->start + zone->len >= get_capacity(disk);
+}
+
 static bool disk_insert_zone_wplug(struct gendisk *disk,
 				   struct blk_zone_wplug *zwplug)
 {
@@ -1693,11 +1698,13 @@ static int blk_revalidate_seq_zone(struct blk_zone *zone, unsigned int idx,
 
 	/*
 	 * Remember the capacity of the first sequential zone and check
-	 * if it is constant for all zones.
+	 * if it is constant for all zones, ignoring the last zone as it can be
+	 * smaller.
 	 */
 	if (!args->zone_capacity)
 		args->zone_capacity = zone->capacity;
-	if (zone->capacity != args->zone_capacity) {
+	if (!disk_zone_is_last(disk, zone) &&
+	    zone->capacity != args->zone_capacity) {
 		pr_warn("%s: Invalid variable zone capacity\n",
 			disk->disk_name);
 		return -ENODEV;
@@ -1732,7 +1739,6 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 {
 	struct blk_revalidate_zone_args *args = data;
 	struct gendisk *disk = args->disk;
-	sector_t capacity = get_capacity(disk);
 	sector_t zone_sectors = disk->queue->limits.chunk_sectors;
 	int ret;
 
@@ -1743,7 +1749,7 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 		return -ENODEV;
 	}
 
-	if (zone->start >= capacity || !zone->len) {
+	if (zone->start >= get_capacity(disk) || !zone->len) {
 		pr_warn("%s: Invalid zone start %llu, length %llu\n",
 			disk->disk_name, zone->start, zone->len);
 		return -ENODEV;
@@ -1753,7 +1759,7 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	 * All zones must have the same size, with the exception on an eventual
 	 * smaller last zone.
 	 */
-	if (zone->start + zone->len < capacity) {
+	if (!disk_zone_is_last(disk, zone)) {
 		if (zone->len != zone_sectors) {
 			pr_warn("%s: Invalid zoned device with non constant zone size\n",
 				disk->disk_name);
-- 
2.45.1

