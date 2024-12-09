Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA64D223711;
	Mon,  9 Dec 2024 12:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733747065; cv=none; b=tzvPYfSTKXzpfNjJCaxUikLI2RzAimYVW2zK5y51EBLu32MRH0HV/d6Ib2K2W4hfjpomAxC8QgF8Hmb3MWJVLZJhXHlWxzpHD+9gi2nSfUXhRXzfUDQIDYzGVwjWq1aztHgz6yquVQ5IROkQmpCoFZ/hvMB+k6egTOZWACEvqk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733747065; c=relaxed/simple;
	bh=q2IHswbvZNgxrYuXzJZrHd0SKTsmSCLewL2Lkyejcuo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EVVnHnhv4jFNscn5086nnxvdXkgvLiXoeLSiB0K1z0tB18oTbyDlN1T9BBPR1EbxBdbr90Ot5p3uQsfx5T4sM58qdlJz1khnhlLzT+georqtqmFNyG0KHjg84NONTtFnOxyiaCDJm8jKJiGZBFCkX7sgp2c5xVXiSQxaFWW9Kgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NICYXVb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NICYXVb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B198C4CED1;
	Mon,  9 Dec 2024 12:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733747064;
	bh=q2IHswbvZNgxrYuXzJZrHd0SKTsmSCLewL2Lkyejcuo=;
	h=From:To:Cc:Subject:Date:From;
	b=NICYXVb653aoqx6B4w3VSqQYsrD6JQwPLlfjVMXGU70XEYzY52P6Sh1dNBqsAiFJY
	 yDV2hLishWjMeq7YQz9YAVarVL6e3erWuoPN0xne5t6VykYEZrYp+STyEpUzUoJAEp
	 TxHcAW14wbB0zOERoUY91yYVkafb/Hpm2kQD381pGW/5WOX93/hhGMlzIwdTjFqGXW
	 4JwMi9ECswV+rHOREUi68n4cpTRvvg7U1hzH4warsUXuyTR0OG2fC6TbOl/2M6vOxE
	 7SaONTDrIx4gJAE3c+vBI3dsYKxly528vncrFv8MjkHzdEhPPIIIdPpP5wLqLTv2YD
	 Zfqor8AtWEKGw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/4] Zone write plugging fixes
Date: Mon,  9 Dec 2024 21:23:53 +0900
Message-ID: <20241209122357.47838-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jens,

These patches address potential issues with zone write plugging.
The first 2 patches fix handling of REQ_NOWAIT BIOs as these can be
"failed" after going through the zone write plugging and changing the
target zone plug zone write pointer offset.

Patch 3 is a bigger fix and address a potential deadlock issue due to
the zone write plugging internally issuing zone report operations to
recover from write errors. This zone report operation is removed by this
patch and replaced with an automatic recovery when the BIO issuer
execute a zone report. This change in behavior results in a problem with
REQ_OP_WRITE_ZEROES handling and failures in the dm-zoned device mapper.
That is fixed in patch 4.

I will followup these fixes with a cleanup of the report zones API and
its callback function interface to clean it up as patch 4 introduces an
indirect user callback call that is not very pretty.

Changes from v2:
 - Added review tags from Christoph to patch 1 and 2.
 - Reversed the order of patch 3 and 4. Patch 3 now includes some code
   that was implemented in "block: Prevent potential deadlocks in zone
   write plug error recovery" in v2.
 - Adjusted and improved the commit messages of patch 3 and 4.

Changes from v1:
 - Fixed kdoc comment for blkdev_issue_zone_zeroout() in patch 4

Damien Le Moal (4):
  block: Use a zone write plug BIO work for REQ_NOWAIT BIOs
  block: Ignore REQ_NOWAIT for zone reset and zone finish operations
  dm: Fix dm-zoned-reclaim zone write pointer alignment
  block: Prevent potential deadlocks in zone write plug error recovery

 block/blk-zoned.c             | 506 +++++++++++++++-------------------
 drivers/md/dm-zoned-reclaim.c |   6 +-
 include/linux/blkdev.h        |   5 +-
 3 files changed, 229 insertions(+), 288 deletions(-)

-- 
2.47.1

