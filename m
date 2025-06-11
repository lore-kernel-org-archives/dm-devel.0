Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FA52D5432
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 01:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749604528; cv=none; b=NBQq6HW6ALTMBJnwT3pH9GSTsprNPeb6bePl8EX4pZXiXdUPlNlpR/UxEjn32uG5bPgzb6MR/80JAEUrbpZfCPrUIXBaPTdbLy6yt72frl76oMcDtjkkil4QvqUJ4xdKy5j1fg5XBzYKf+eyQAbi8ooay5crCSY/MWsdKSwXiz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749604528; c=relaxed/simple;
	bh=5HJfqlFdPntGf+cSJx8wIwxccKIIF8Cnk3uL9Me1Ya0=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVBeT4567KDTnM9acHmEstcPsRwXiQXFOt6CZyR1/xIuV3XspvaNMfxE7yn4AnuUDFdgoUDDUy871GynfeMWLxbBlTW67KHPqz9oQXXxMM0cXtY9JfNe2uOX6PnrrItLvf7bnOzUuXAez9JiHn0Ok/yWM0JcI6ZbhzxBsD2N0l8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktVD1Bw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktVD1Bw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D43BC4CEF0;
	Wed, 11 Jun 2025 01:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749604527;
	bh=5HJfqlFdPntGf+cSJx8wIwxccKIIF8Cnk3uL9Me1Ya0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ktVD1Bw9LIOUtc7qAEJBa0z1tiR3P0hsS/wCNY2jP8ye8v61C4CvamnXKOvPDaDiS
	 7jeuNkCHjS9yy9Html/Uw+x6uFTds2WlkMsVnJ5kCUTxeP4yudGbihWd6WSQ0jx0sj
	 sYt4i62hKPSbfF68eKXvsoLow8kSSK0DxmEXInhatgH39hvjKR0BvQ+Od29BAnQz1D
	 oZJF1BhFNEQ0yetOlnwgfsG6zHs58BfMgySwjc8MGtA5gAoM4KsDHzBQJ0cDfMcbAm
	 xETKE/UI52CpzhOyhXAMYIbEVPszYUvdA7H2tFFhLhfxXc0bqiFE8UOdfEMHcAvDyV
	 ICWU6iHk7hkcA==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm: dm-crypt: Prevent splitting of emulated zone append operations
Date: Wed, 11 Jun 2025 10:13:39 +0900
Message-ID: <20250611011340.92226-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250611011340.92226-1-dlemoal@kernel.org>
References: <20250611011340.92226-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a zoned dm-crypt device, the native support for zone append
operations (REQ_OP_ZONE_APPEND) is not enabled and instead dm-crypt
relies on the emulation done by the block layer using regular write
operations. This still requires to properly return the written sector as
the BIO sector of the original BIO. However, this can be done correctly
only and only if there is a single clone BIO used for processing the
original zone append operation issued by the user. If the size of a zone
append operation is larger than dm-crypt max_write_size, then the
orginal BIO will be split and processed as a chain of regular write
operations. Such chaining result in an incorrect written sector being
returned to the zone append issuer using the original BIO sector.
This in turn results in file system data corruptions using xfs or btrfs.

Fix this by modifying crypt_io_hints() to cap the max_hw_sectors limit
for the dm-crypt device to the max_write_size limit. As this limit also
caps the device max_zone_append_sectors limit, this forces the caller to
issue zone append operations smaller than this limit, thus moving the
splitting of large append operations to the caller instead of the
incorrect internal splitting.

This change does not have any effect on the size of BIOs received by
dm-crypt since the block layer does not automatically splits BIOs for
BIO-based devices. So there is no impact on the performance of regular
read and write operations.

Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm-crypt.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9dfdb63220d7..7b1e88781a82 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -3730,6 +3730,18 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
 		max_t(unsigned int, limits->physical_block_size, cc->sector_size);
 	limits->io_min = max_t(unsigned int, limits->io_min, cc->sector_size);
 	limits->dma_alignment = limits->logical_block_size - 1;
+
+	/*
+	 * For zoned devices, we cannot split write operations used to emulate
+	 * zone append operations. And since all write requests are going to be
+	 * split on get_max_request_size(cc, true) size, apply this limit to the
+	 * maximum hardware I/O size so that we have a cap on the
+	 * max_zone_append_sectors limit when the zone limits are validated by
+	 * the block layer.
+	 */
+	if (ti->emulate_zone_append)
+		limits->max_hw_sectors = min(limits->max_hw_sectors,
+					     get_max_request_size(cc, true));
 }
 
 static struct target_type crypt_target = {
-- 
2.49.0

