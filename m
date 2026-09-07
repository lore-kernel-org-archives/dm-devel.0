Received: from mail.stuffedcow.net (mail.stuffedcow.net [38.49.217.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B48346AFD
	for <dm-devel@lists.linux.dev>; Mon,  7 Sep 2026 21:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=38.49.217.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788817613; cv=none; b=kkg48L2EOEF9SIsIH55SmNZ29hbcJrsAEZ/453zySZP9H5WOgXwvm+IyIQCJJSE00Kuoq1keNM1K0zfYxi7+Wq2h6AajUKWOBn2Hf0R+R0SinH4pWglgoqT51/wSq2eWGHxEd9uXTwcxsd68kQJQ/NQhWnEhxuzrs4yfPgNKGTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788817613; c=relaxed/simple;
	bh=4WRCKQ99ToixA5GmLvAoZjMww5Nj/9a55qnA+2C45dE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DVAs9gtDlK2vTbLjaK4T88d+eMlC9spOrVi/05bRVq1ZLjWthYM423x4+K9iC/ciqCM12/uLL/rWv/wDHiq4NgkTbMwW8gQ+aPwQvUI00IcP4OmH4lubznKB8NQROGPp35NCtsV7kOy34mnAFLDvR0uOSB720V1EPyOiSSqII8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stuffedcow.net; spf=pass smtp.mailfrom=stuffedcow.net; arc=none smtp.client-ip=38.49.217.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stuffedcow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stuffedcow.net
Received: from henry2.or.stuffedcow.lan (henry2.or.stuffedcow.lan [192.168.1.227])
	by mail.stuffedcow.net (Postfix) with ESMTP id 6BE051E0E3B;
	Mon, 07 Sep 2026 17:46:49 -0400 (EDT)
From: Henry Wong <henry@stuffedcow.net>
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com
Subject: [PATCH 0/2] dm-writecache: Retain clean blocks to serve read hits
Date: Mon,  7 Sep 2026 14:46:46 -0700
Message-ID: <20260907214648.3691695-1-henry@stuffedcow.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello all,

These two patches are technically independent, but I bundled them together because they touch the same code.

The first patch modifies the in-memory metadata to cut 8 bytes per cache block. It should not change behaviour. The main change is that I removed the 47-bit wc_entry::index field that looked unnecessary to me. Hopefully someone more familiar with the code can confirm.

The second patch adds a "clean" state to the cache block (after writing back), rather than immediately dropping cache blocks after writeback, so that subsequent reads to that cache block can be served from the cache. This is primarily useful when the writecache is much bigger than system RAM, so you can't rely on "recently"-written blocks to still be in the page cache. In this scenario, one might not want to keep a cache block dirty for long periods without writing it back to disk, yet still want the cache to provide near-100% read hits for anything "recently" written (where "recently" could mean multiple days).

The new "clean" state allows the cache to write back a block, yet still retain it to serve future reads. It does not modify the eviction policy (no new LRU tracking), so the writecache is still primarily focused on buffering bursts of writes. The default behaviour is unchanged: I added a new "evict_clean_blocks" configuration knob that controls the new behaviour.

To make this work (allow a cache block to be in both the rbtree and the freelist/freetree at the same time), the in-memory metadata is increased by 8 bytes.

Henry Wong (2):
  dm-writecache: Reduce metadata memory use by 8 bytes per cache block.
  dm-writecache: Add evict_clean_blocks option to allow read hits on
    clean blocks

 .../admin-guide/device-mapper/writecache.rst  |  19 +-
 drivers/md/Kconfig                            |   5 +-
 drivers/md/dm-writecache.c                    | 187 ++++++++++++------
 3 files changed, 141 insertions(+), 70 deletions(-)

-- 
2.52.0

