Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC85E12A146;
	Wed,  1 May 2024 11:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714561763; cv=none; b=cV/rYDho5c3C4cgY0lzFBn9EZiR5F0AHDhTQlaMXyYoRVeKrJWhXxbSXJRoMiJjnVUnFvC/guboOJO+9fS4RJQMFqVgKzre3mx+7wuQ+NxgT6SccYVF+n9dJY3kgBAHHNe7WVJgNChePTJPTRwhMEzaRc1dw+qPesjcvgBRDTiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714561763; c=relaxed/simple;
	bh=QYJmwoX2qkYp/gkQ7Tj2YEo555PNXuFgC74P6owF9Dk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N6WOjLIDu3UBLKdbM4y4fFE6p2+z4XdZsJOFfAfRMXUu0DfQ28z0pFTfEKjXWjh7Kl/mqXzMo8otPip8xT57q370iyb+3wG6yXKZ9eRiezZM3vDY157nbsZE0ij/MCGCO4h7pnykBmbTAEwlJfnNlFceHwKNTg5KTl54OMQg6J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u1ckEFFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u1ckEFFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7841CC4AF1D;
	Wed,  1 May 2024 11:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714561763;
	bh=QYJmwoX2qkYp/gkQ7Tj2YEo555PNXuFgC74P6owF9Dk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=u1ckEFFt7tU2/p0mfoUDdQ9aWPGXsafQpJrHySPo5yiCPUDDPS15uHF+V0Coc/5XS
	 ICBJWgHTqjHv0yUWyinhAW6T1U1RASL4SpAww64bJiZP8JfadmJyC1eVWYtKjABRAe
	 rsxJGWf2osZ5JvBNiTwaYwxKaiT8cdE3PlkTShFJhRZxU5fv9npRArwCy+HSHQbLSL
	 kqo+yWorKhksoU46JRf2xZVOSWrc68BmfqKoDLeZ/WbUSwPmHeb0CwYPtgQEgf0UDf
	 bC39jHsCVWPcXvA6adQIrnvCZMb1+cg0hMrPJDWUxknwNYP0TYm2ojDgPmi+yjaaoG
	 Jcs5MrWiPAm5g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 12/14] block: Simplify blk_zone_write_plug_bio_endio()
Date: Wed,  1 May 2024 20:09:05 +0900
Message-ID: <20240501110907.96950-13-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240501110907.96950-1-dlemoal@kernel.org>
References: <20240501110907.96950-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We already have the disk variable obtained from the bio when calling
disk_get_zone_wplug(). So use that variable instead of dereferencing the
bio bdev again for the disk argument of disk_get_zone_wplug().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 759e85e9167c..132eb988f4d7 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1222,8 +1222,7 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 {
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
 	struct blk_zone_wplug *zwplug =
-		disk_get_zone_wplug(bio->bi_bdev->bd_disk,
-				    bio->bi_iter.bi_sector);
+		disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
 	unsigned long flags;
 
 	if (WARN_ON_ONCE(!zwplug))
-- 
2.44.0

