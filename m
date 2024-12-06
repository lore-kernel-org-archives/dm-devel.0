Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D73280054;
	Fri,  6 Dec 2024 01:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733449985; cv=none; b=qe/HjyneR/SLjyw3+XGuR4LgBmMFIUD0oJX54Q19tbBk3jTI17C0OnoMDXva/kxAneHj9Ir2d+OUMeq3fb0goSt2YAWpt0PTYR/opP5tqidElRTIciJgej+auhUa0nkaQbO6Vdep0dRDmW+D/yBOwNqEPEMXazHeRhF2Apmlc5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733449985; c=relaxed/simple;
	bh=b2hL4TIR/sZKi1XGa8dCIn9fHLArnFzKz9ua1H+i0Og=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GXVcf6trqOMyyQgfYkAkrjaLdJFYjBAVkY0L7DOpXl5qkw8l5YGlP/JbNNmxKIHLvfWvaAGN48YpK1yURQWciyFSdffWHQAD6ZLIGif5irCGQn3VNrjkFmy6ZFpFbNZHYupfKKENTdF0y2XKHNTQbNY45wJxLs0ZBeH7jQkG6DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pMMA3afH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pMMA3afH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB685C4CED1;
	Fri,  6 Dec 2024 01:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733449985;
	bh=b2hL4TIR/sZKi1XGa8dCIn9fHLArnFzKz9ua1H+i0Og=;
	h=From:To:Cc:Subject:Date:From;
	b=pMMA3afHHnPXtsddrDQEOftbfV7SwtfVDK2f6jMrSi6WitAiCA/7it8WQ4bGWBgpA
	 KPi0QBxhl2e6c1pAA7jXeFMiD4FFOoIqe3evUNtpry5rVRuCqQZ9S8+z2jvfNw26OS
	 YjC298UhaB2y40nb7/n+t/6EAuCiYlKY+3Vu+v6eMlW5UukAvQXMrI+w+j3rLr9di0
	 PVkYWiMo8I31vQUhNnOvSIjCQJzKfsTUcTWwYFHmLP2ozpI0St4RH3SOOPm4vy2lWR
	 fu3ddpVVtPv7ZzjtwEzPlz3rtqoBcIIranZnOSJaUKVl38C5bqeSw8sP1BFkJ77Zw3
	 98hOaWNijE8OA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] Zone write plugging fixes
Date: Fri,  6 Dec 2024 10:52:36 +0900
Message-ID: <20241206015240.6862-1-dlemoal@kernel.org>
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

Damien Le Moal (4):
  block: Use a zone write plug BIO work for REQ_NOWAIT BIOs
  block: Ignore REQ_NOWAIT for zone reset and zone finish operations
  block: Prevent potential deadlocks in zone write plug error recovery
  dm: Fix dm-zoned-reclaim zone write pointer alignment

 block/blk-zoned.c             | 507 +++++++++++++++-------------------
 drivers/md/dm-zoned-reclaim.c |   4 +-
 include/linux/blkdev.h        |   5 +-
 3 files changed, 229 insertions(+), 287 deletions(-)

-- 
2.47.0

