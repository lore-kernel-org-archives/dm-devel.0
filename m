Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1108028691;
	Sun,  8 Dec 2024 22:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733698703; cv=none; b=nEgvBVPV9UocFzqvwHw4G8IKXgIifI/Gpf48Sd0EZAtbzp2PGvx7tJ0bZCWfbt/Asb+dmFX1a4MzOHeqs67Jl0wmRfUKDX6r2bkM1E5PihMpvfeytCUo/9OLMpKA33njpALc8eDIYVioTQhTSTssVhVPsq4L1ttBv46c6itEu4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733698703; c=relaxed/simple;
	bh=X6kHl0GreNjUC3U327lIvxlHdj0R+lf7MUZZW+ETH50=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J1S8FTkW1rKGcVqL8vFziGrsY5lWUh5uM3Xwk3mkiIvmammdxpteWLx530zpwRL6XVEwJpUE9C7eQ0GKYjG7wl465lDBESfj3fTh3WxqyPQUaQYDhXNf5u+8NiGaU0B6rGwBm2qlOhe7vsQCEyhMYVweUeGkAXNTjnwtdnjbKg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luyCO8qw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luyCO8qw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898FEC4CED2;
	Sun,  8 Dec 2024 22:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733698702;
	bh=X6kHl0GreNjUC3U327lIvxlHdj0R+lf7MUZZW+ETH50=;
	h=From:To:Cc:Subject:Date:From;
	b=luyCO8qwPxjPz0GXDKB5gVyQ1GpvNVYHuItcfwnsu1VJAr70evJqX3876WHvz0Fkh
	 BLOiCRbnadWeyZLFOdR7YdSeMMpT2+zh5d7E4mUDMiz+N/ZjEb/JxUVl5Oaaf+2w6S
	 rQ7LqE6Nl+vMKZFvIR3RdKwGFHkmgbNRx3fBqa75/iKkRE4zG0uPpac6w09ElWEl1B
	 AxTGVRVcD71crA66XHnQu8FnDngNWBLvptqIuQINxkkcLpcOB58YbM6MrfEcP7kE1J
	 Co0NYi4jMg5vAjbEpFNGH9omEzSCBeg+9ZorU8S1JTi1cYuzgetciuEg8HvOGpjnaC
	 d/ePBpZmFBgYw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] Zone write plugging fixes
Date: Mon,  9 Dec 2024 07:57:54 +0900
Message-ID: <20241208225758.219228-1-dlemoal@kernel.org>
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

Changes from v1:
 - Fixed kdoc comment for blkdev_issue_zone_zeroout() in patch 4

Damien Le Moal (4):
  block: Use a zone write plug BIO work for REQ_NOWAIT BIOs
  block: Ignore REQ_NOWAIT for zone reset and zone finish operations
  block: Prevent potential deadlocks in zone write plug error recovery
  dm: Fix dm-zoned-reclaim zone write pointer alignment

 block/blk-zoned.c             | 506 +++++++++++++++-------------------
 drivers/md/dm-zoned-reclaim.c |   4 +-
 include/linux/blkdev.h        |   5 +-
 3 files changed, 228 insertions(+), 287 deletions(-)

-- 
2.47.1

