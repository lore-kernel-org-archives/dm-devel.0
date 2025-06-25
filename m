Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF3C1B87E9;
	Wed, 25 Jun 2025 06:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750831274; cv=none; b=BrPME+qDCtIA+hshGpeNN/mTWKxhYrTvg1tAaBeXsWc6AWdquMxlmrG/GN+EYQHP98OouX1XqpDZEjYin+L8E6nF7rhHPiwDHc1QgDAXgFdl2t5RrYLyOD8V/Z3qffW2J/1LpPNJ12wD1OCzVuG2phFfw85ctvQmgwB17m+5IAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750831274; c=relaxed/simple;
	bh=ZXx7MnekMdPkgQN6qqZYe69IVqrNzCBACOiPTWAqJC8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YFNvorQLKh7aWT3ez5uWmuvImVFJjseMro/u7gY+p6oH8IrznY8JbIxNOtahPfOwizm32+RWb4HgCzByXVgHZBIecHrOClTUwy31GStxNOTdccg3R0U7JZJfaw2hvqVG7B9lbWtyX1BBF3i4kxmUEiXcFFiQbm74iwZymMVpa3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=quwwlGpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="quwwlGpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4121C4CEEA;
	Wed, 25 Jun 2025 06:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750831273;
	bh=ZXx7MnekMdPkgQN6qqZYe69IVqrNzCBACOiPTWAqJC8=;
	h=From:To:Cc:Subject:Date:From;
	b=quwwlGpfkEnKqFPFwk4JHTAhun+YWwfMr1lBv/AE8z47pTEazWdmryjmXBIRtXp8Y
	 f+Oameo9tOssXJY3aLW+Bu75oJ4Avu4bNahrGUdcEJayl0saQukw/MTOlfy+QmswKs
	 n1rhy61AszzkIW71sBW6gErfpo6jSuR0GHRdXTj5mkliyT5NZyEPrEu8PBsbArLd6j
	 FRZDVovUtuqAvNYLuZ/c0YsesqwQ/0ySEllR5FdNYEp6kJ4eqoxtdp4e/Y/DCIl2f5
	 ZjX090gn/Zf8xXeYFqtCfiXBAmEBszrcL19ZkFUi50mN60tI6zPCMjxt1AK2IH+kJZ
	 Nwmu6QP2+PtLw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] Fix write operation handling for zoned DM devices
Date: Wed, 25 Jun 2025 14:59:04 +0900
Message-ID: <20250625055908.456235-1-dlemoal@kernel.org>
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

The first patch introduces a new block layer helper function in
preparation for the second patch which forces DM to split zone write
operations to the device limits. The third patch removes dm-crypt
internal BIO splitting of zone write operations.

The last patch adds checks to dm_accept_partial_bio() to catch forbidden
splits of zone write operations.

Changes from v1:
 - Added patch 1 and 2
 - Reworked patch 3 to be more general, that is, to avoid splits of all
   write operations instead of only write operations that are used to
   emulate zone append
 - Modified patch 4 to be consistent with the changes in patch 2 and 3.

Damien Le Moal (4):
  block: Introduce bio_needs_zone_write_plugging()
  dm: Always split write BIOs to zoned device limits
  dm: dm-crypt: Do not split write operations with zoned targets
  dm: Check for forbidden splitting of zone write operations

 block/blk-zoned.c      | 40 ++++++++++++++++++++++++++++++++++
 drivers/md/dm-crypt.c  | 49 +++++++++++++++++++++++++++++++++---------
 drivers/md/dm.c        | 45 ++++++++++++++++++++++++++++----------
 include/linux/blkdev.h |  9 ++++++++
 4 files changed, 122 insertions(+), 21 deletions(-)

-- 
2.49.0

