Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925B96EB4B;
	Fri, 24 May 2024 09:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716544651; cv=none; b=ZWm5wWl/sbPjpItVqTeu6u49cOcM4fdERn20SzBFUcUCMWK9RSgA5ZaXGuRWZKmWZs9BZcLu6dZqmS6hzg0VhhoNssXKm9IWjORKtPzk+p+6Q88xRlEGaSi0CXexF9R2uhaNOQkhMzlmepK7es6lrNC+hJaq64tdBeDlcq2uPTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716544651; c=relaxed/simple;
	bh=0I5cynNuv4Dqoo8JVCmRAMY1lrY77SMZfnx0Lml79J8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I7aMk387+2Gu0IfO24HcW7232N1nR5c4m1NTJmTsm//pq3OG5VLqVUX7KddFdZMKR/KOemeA+1h3yPSxCUF589QvXhLlbbfbSJyalN9XYVM3ehqHN7N8epk0HwEQV11DCLy9cPSziCQKNMVZuZHoIu9yJX5DGv5n3fARlCwiXrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h25GUNVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h25GUNVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F9DC32782;
	Fri, 24 May 2024 09:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716544651;
	bh=0I5cynNuv4Dqoo8JVCmRAMY1lrY77SMZfnx0Lml79J8=;
	h=From:To:Cc:Subject:Date:From;
	b=h25GUNVVXnGAz7NN901F73xRDLbA9VJkR9d27xkSTED8eQ+uOdJSZrr4Jee1TT1hs
	 hAg422BBJooBBHQVPDVQnm8gzTfcIiEJHIfCgGgfQWevhrCg9s0KPF8IkltU2BBzKe
	 YG8OPG1bNgPv3ibhcMFrpy6W57rjvTbaYTd2zcO1OnD+rsXtq2yEJVasMnXBSfhrhV
	 HvY3EFB6bRJOEqaIN59Dw82ZF/HKZ+3YdTgKqtDjIZ7tm33cQNldA3cJK6CuGrKhLQ
	 vFIjPVjf7jdepB8qVfegDinHFb8EMqFJ0M+4bErFdGzxWwDzO1eRARovLsqKhqM937
	 PDH5GCemNpASw==
From: Hannes Reinecke <hare@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@lst.de>,
	Mike Snitzer <snitzer@kernel.org>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH] block: check for max_hw_sectors underflow
Date: Fri, 24 May 2024 11:57:19 +0200
Message-Id: <20240524095719.105284-1-hare@kernel.org>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The logical block size need to be smaller than the max_hw_sector
setting, otherwise we can't even transfer a single LBA.

Signed-off-by: Hannes Reinecke <hare@kernel.org>
---
 block/blk-settings.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 524cf597b2e9..0cdca702e988 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -133,6 +133,8 @@ static int blk_validate_limits(struct queue_limits *lim)
 		lim->max_hw_sectors = BLK_SAFE_MAX_SECTORS;
 	if (WARN_ON_ONCE(lim->max_hw_sectors < PAGE_SECTORS))
 		return -EINVAL;
+	if (WARN_ON_ONCE((lim->logical_block_size >> SECTOR_SHIFT) > lim->max_hw_sectors))
+		return -EINVAL;
 	lim->max_hw_sectors = round_down(lim->max_hw_sectors,
 			lim->logical_block_size >> SECTOR_SHIFT);
 
-- 
2.35.3

