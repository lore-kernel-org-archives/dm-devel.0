Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BEE5171641;
	Tue, 30 Apr 2024 12:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481505; cv=none; b=GUA5eEtQR+s//7z6HKIlx2dx3J6+wfVMh1jskh/izzCad3keAZ9qqjuW2kCDU4RRia2VYZTBhxSei0dcLn9+vO5EYGw+J8dgvcFKMNukdrq8EIf8fXDWnJRjxTfgNCX1NFoh7hThSVPkOVGoein7EpK7D+MgJPjuc+2oQATuNHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481505; c=relaxed/simple;
	bh=rxcDOJchV0H2cRWow4MQwLCQK/4ZMh+ro+93jdcguss=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J5ERftxUgF+2gd75qkc1kPZoA0GoQHJFOFZ2OTcbwI7EedRdKgB3925SmCW7gE2kuB/wy/FnfWLj+BB25Kfcc7+pxtJJMAh9/ZJfYr5MAqZd1O88ILIk6LDmHUyPHgeIivtzG+476LtZoC4aogusNSmKBfMs8UL9+HmdPld7q0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nU2OTN7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nU2OTN7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27EADC4AF1A;
	Tue, 30 Apr 2024 12:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481504;
	bh=rxcDOJchV0H2cRWow4MQwLCQK/4ZMh+ro+93jdcguss=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=nU2OTN7q3G0OABTW4bLbTGHaYL0Y4jkJL8IvwMMhUvmB4QjJXL5mIpsWgjPi75PRm
	 TaanVCFJOmKXMEQMbZV9Mr8V58oRYb0OOgxjjEuY/y2QHM4LcBzMZW2vG106BhXD2g
	 R7xdm6BM5gxIqxEHG0yIRqJZSVyIukxxcetYrPs1qQ6Ue+eFHPWDE6EUZf97fu/Iol
	 jn/ke7G8HBqXPCD+c1SBAbMK/OJHZJsyc1nWwKxae8rt4CuUKO7CF7ZLRlzKjsO8SN
	 beEKRn3o+LNyPTzJuV01Su0uhAQmg8bRbXsU8o8nskdD4LHlHLmVXt7qrZa1L8ZK1/
	 IEpA96Y1DYVxg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 10/13] block: Improve blk_zone_write_plug_bio_merged()
Date: Tue, 30 Apr 2024 21:51:28 +0900
Message-ID: <20240430125131.668482-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430125131.668482-1-dlemoal@kernel.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Improve blk_zone_write_plug_bio_merged() to check that we succefully get
a reference on the zone write plugi of the merged BIO, as expected since
for a merge we already have at least one request and one BIO referencing
the zone write plug. Comments in this function are also improved to
better explain the references to the BIO zone write plug.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index b551fe4e684f..d962ba7c9ae1 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -866,11 +866,16 @@ void blk_zone_write_plug_bio_merged(struct bio *bio)
 	bio_set_flag(bio, BIO_ZONE_WRITE_PLUGGING);
 
 	/*
-	 * Increase the plug reference count and advance the zone write
-	 * pointer offset.
+	 * Get a reference on the zone write plug of the target zone and advance
+	 * the zone write pointer offset. Given that this is a merge, we already
+	 * have at least one request and one BIO referencing the zone write
+	 * plug. So this should not fail.
 	 */
 	zwplug = disk_get_zone_wplug(bio->bi_bdev->bd_disk,
 				     bio->bi_iter.bi_sector);
+	if (WARN_ON_ONCE(!zwplug))
+		return;
+
 	spin_lock_irqsave(&zwplug->lock, flags);
 	zwplug->wp_offset += bio_sectors(bio);
 	spin_unlock_irqrestore(&zwplug->lock, flags);
-- 
2.44.0

