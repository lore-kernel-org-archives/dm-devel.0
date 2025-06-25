Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D076D2676DF;
	Wed, 25 Jun 2025 09:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750844132; cv=none; b=laFYc+IRMLFTUqb8DdHrH+45D/rhjalHKHF2DZ5nx+47kgLQQ43rxxkwRQhxLrj0G5ZBN/4ph6Z+p34N9P5ZS/21A2cAickmO8bSWcA3g0xBrdCUyfvgOaegHLh6f/gDpPnSYkJfBvhKehrIqTk4b1nUjBkUfLK85AYE0VmcVjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750844132; c=relaxed/simple;
	bh=+KRJ+M/fyJ5uSz0vgOWZLJmmxIgWvn29ReLbt8KGrdI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HLP3zXHIsuaqLD3lZrC+iL2scAAaXFrx1N97oqykschGkw+1rCagsax4XTUFEHw2lANNuU0ww4Dsq2h3OX/jjYVIDYJbSao4/vo1ZYy7X5wrmVZrOI0ziRR66suTalSOOVKWTBMGpNclQLpRBlSBY+mcS/tOLHXWEelzF7I/4gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CWAIehBA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CWAIehBA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A350BC4CEEA;
	Wed, 25 Jun 2025 09:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750844132;
	bh=+KRJ+M/fyJ5uSz0vgOWZLJmmxIgWvn29ReLbt8KGrdI=;
	h=From:To:Cc:Subject:Date:From;
	b=CWAIehBABqj6WNqxkJE9WwzuOccQuk43GGT8iwUv9cv7eNh/4qT0ICdo0KClxfT1f
	 SAKMj0Xxy50pHdbIsJCY/+XLuzIPuUX2hd/aWI3bpULf22mVPxeD4EgUkYncFe1/7g
	 vhp8MU8MKYzQe98BLou7iP2r3HHkBXReKQ+MRYdDWJXVU8OSbIlcqbbTT9KdwZRwED
	 hq4cFncAyefN8LmjXl0XDUukrQRwIJW82tjWm29l90jnQM45dWEuUTw4kHmu9Q3FyH
	 OGtxgSMy9LYvSNuDeAdl9xxTAY8KYRrGVsjJGdhmoSkYc69yZ+Suq5QlCUfnAbEhLt
	 eH+GuE/2j2K0Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/5] Fix write operation handling for zoned DM devices
Date: Wed, 25 Jun 2025 18:33:22 +0900
Message-ID: <20250625093327.548866-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jens, Mike, Mikulas,

Any zoned DM device using target drivers that internally split BIOs
using dm_accept_partial_bio() can cause deadlocks with concurrent queue
freeze operations. Furthermore, target splitting write operations used
to emulate zone append requests break the emulation. This patch series
addresses both issues by forcing DM to split BIOs to the DM device
limits before passing the BIOs to the target map() function, and by
avoiding calls to dm_accept_partial_bio() for Zoned DM targets that use
zone append emulation.

dm-crypt is the only DM target that is affected by the issue.

The first two patches patch are preparation for the third patch. These
do not intorduce any functional change but are marked as fixes as they
are needed byt the other 3 fix patches.

The third patch forces DM to split zone write operations to the device
limits. The fourth patch removes dm-crypt internal BIO splitting of zone
write operations. The last patch adds checks to dm_accept_partial_bio()
to catch forbidden splits of zone write operations.

Changes from v2:
 - Added patch 1
 - Reworked patch 2 to make the bio_needs_zone_write_plugging() and
   inline function used to drive calls to blk_zone_plug_bio() in blk-mq
   and DM.
 - Adjusted patch 3 to match the changes in patch 2

Changes from v1:
 - Added patch 1 and 2
 - Reworked patch 3 to be more general, that is, to avoid splits of all
   write operations instead of only write operations that are used to
   emulate zone append
 - Modified patch 4 to be consistent with the changes in patch 2 and 3.

Damien Le Moal (5):
  block: Make REQ_OP_ZONE_FINISH a write operation
  block: Introduce bio_needs_zone_write_plugging()
  dm: Always split write BIOs to zoned device limits
  dm: dm-crypt: Do not partially accept write BIOs with zoned targets
  dm: Check for forbidden splitting of zone write operations

 block/blk-mq.c            |  6 +++--
 block/blk-zoned.c         | 20 +-------------
 drivers/md/dm-crypt.c     | 49 +++++++++++++++++++++++++++-------
 drivers/md/dm.c           | 50 ++++++++++++++++++++++++++---------
 include/linux/blk_types.h |  6 ++---
 include/linux/blkdev.h    | 55 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 140 insertions(+), 46 deletions(-)

-- 
2.49.0

