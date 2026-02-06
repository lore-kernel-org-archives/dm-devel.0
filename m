Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5602459C9;
	Fri,  6 Feb 2026 05:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354114; cv=none; b=hU/qJtujQoFuvEtmajh/Rp87YXgEBHR6DFAgDubChhM6uNYsWR5LRDd2+YYarP0mAhhLXxwZ9bd9XitZs+N7R16zuvErLKLfRUVsrosBGmrKjS+72D0wya+S52s5xE9ty9eOqI3r86o9OjRblgV4gFmvGqjVX8ZXy5ANxVbu8P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354114; c=relaxed/simple;
	bh=UHz9Z4qh+E/H53GAJj41bLtE+TUjr2wJNbRySLLGOF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ej/g3ijZHek8ghDzuv3aBmNVKuIPMnHSPcXcetCSSfTL1Zochi4DGsXtVqqHi2fuTY+n4VeirxkoFJEZcrRs/B95jtcfOj05AbQpmg2RyRHNG3yM4iHFXPbAXvacglEJtDzu/RKjhuJ0SXlgS6xaE9VbZ5Zj0LjOenB2CUPVuGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G43MTPu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G43MTPu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6239C19422;
	Fri,  6 Feb 2026 05:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354113;
	bh=UHz9Z4qh+E/H53GAJj41bLtE+TUjr2wJNbRySLLGOF8=;
	h=From:To:Cc:Subject:Date:From;
	b=G43MTPu7TKFNE0YKpOQUYvlk1TE4wgNR7zeCZTTL9sqyY8i5qeikBQ1r8Z1CeY87r
	 +4Ewmu5GYbJh8A8z/e9EopMmbsBakbkQmX4f8JYdbMrhvNKZ5XCmUIFXRUMEFTF1Yu
	 0XCOouPiTCyqx9/IO4j5PcM3Z5qNAKeCwMeSiESlEJ/bVIDJ/sn4UFkUS9tQKIY1Z6
	 /uzBqSAOlknprxmDSTTwPSfI0aQXq5yPckWS3bq0nSLVhha9YklX1pjINmlCsI3Tx3
	 M9kYgUX0K3yQ60nVqj5bCN2GVygbNQGZTYUzDYbLmGmI0SqR1IeQsQEPViikKmZcJq
	 JxkDexvJa874g==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/22] dm-verity: more FEC fixes and cleanups
Date: Thu,  5 Feb 2026 20:59:19 -0800
Message-ID: <20260206045942.52965-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series applies to linux-dm/for-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git dm-verity-fec-2026-02-05

Patches 1-5 fix bugs in dm-verity's forward error correction (FEC):

- FEC and hash devices that are too small were not rejected.

- Corrected blocks could be multiple-counted in statistics.

- The erasures array was significantly oversized for its use case.

- An out-of-bounds read could occur when decoding an RS codeword whose
  parity bytes span a block boundary.

Patches 6-22 clean up the FEC implementation to be easier to understand
and improve documentation and log messages.

Eric Biggers (22):
  dm-verity-fec: correctly reject too-small FEC devices
  dm-verity-fec: correctly reject too-small hash devices
  dm-verity-fec: fix corrected block count stat
  dm-verity-fec: fix the size of dm_verity_fec_io::erasures
  dm-verity-fec: fix reading parity bytes split across blocks (take 3)
  dm-verity: rename dm_verity::hash_blocks to dm_verity::hash_end
  dm-verity-fec: improve documentation for Forward Error Correction
  dm-verity-fec: replace {MAX,MIN}_RSN with {MIN,MAX}_ROOTS
  dm-verity-fec: use standard names for Reed-Solomon parameters
  dm-verity-fec: rename "RS block" to "RS codeword"
  dm-verity-fec: replace io_size with block_size
  dm-verity-fec: rename rounds to region_blocks
  dm-verity-fec: simplify computation of rsb
  dm-verity-fec: simplify computation of ileaved
  dm-verity-fec: simplify deinterleaving
  dm-verity-fec: rename block_offset to out_pos
  dm-verity-fec: move computation of offset and rsb down a level
  dm-verity-fec: compute target region directly
  dm-verity-fec: pass down index_in_region instead of rsb
  dm-verity-fec: make fec_decode_bufs() just return 0 or error
  dm-verity-fec: log target_block instead of index_in_region
  dm-verity-fec: improve comments for fec_read_bufs()

 .../admin-guide/device-mapper/verity.rst      | 122 +++++-
 drivers/md/dm-verity-fec.c                    | 380 ++++++++----------
 drivers/md/dm-verity-fec.h                    |  28 +-
 drivers/md/dm-verity-target.c                 |   8 +-
 drivers/md/dm-verity.h                        |   4 +-
 5 files changed, 294 insertions(+), 248 deletions(-)


base-commit: 218b16992a37ea97b9e09b7659a25a864fb9976f
-- 
2.52.0

