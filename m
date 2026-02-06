Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790A22E2DD2;
	Fri,  6 Feb 2026 05:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770354114; cv=none; b=Qs8eZcuJ7l7um783eD8ZZGl9e8M1t0ZHwEdejYUs4cJ2sbEw+kPmZCtJb05t20xKbpHwK13fiDUz1ee7gAwi1lWvEKGKFExZfQgrTjiyWb0KJlUvFb3By6WUxgDdD+VDK/AXiQrsqo+XlxeVjpX9pTVzq5hX0qXynGQPbEHPusc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770354114; c=relaxed/simple;
	bh=awsnYHluhMYiSyOtcwgGx116nbhXaUrMrdS3ZQpowTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReQ0Fecd0QzWmPS31Zc/vmB7R7B8GNFuxfzcCprDK45dHO7zlsETQnvCqx5fTwIIRcVVpYODoVxABsTHJ0eXGr7WTpU0t3bSGl4IUdIe73K5/2FVUibma3ryokvtsWuK7eq1ezg7xavl+jyleWvBuw/B27rS1R0EFI+0/mNlsVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KukJk880; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KukJk880"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1745DC16AAE;
	Fri,  6 Feb 2026 05:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770354114;
	bh=awsnYHluhMYiSyOtcwgGx116nbhXaUrMrdS3ZQpowTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KukJk880K6NnbRiGcQFsNjp8X07faD28UcXBZDbAECOYIy/jSDdG7AEYTGhh9YFaf
	 alGeSBJN8Wl4Dyu/dHP/uC8l5nFTn6Xb7mhRcAyHppQ2kZ9VBak/5JO+/050vv+V2/
	 VgAC+cOTUrkWCifdB6c5W/IFJuqbHhpUWFHhbNHvMsnYtsO56EHhBgPpGsKOXJHic7
	 7lExmnphPv0JVb0mrSMbIq4Tx3t2FnASQTMZVlLQqq7EjtAHPJjw0KhBGuFtEnbrt5
	 NtTbQsJeIWjaJ9pnE9yshT+nhImeGNOaZr5WirjathqMwuOSjTPWtkj7toivfcDJGC
	 PAnP0YedhLT+A==
From: Eric Biggers <ebiggers@kernel.org>
To: dm-devel@lists.linux.dev,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 01/22] dm-verity-fec: correctly reject too-small FEC devices
Date: Thu,  5 Feb 2026 20:59:20 -0800
Message-ID: <20260206045942.52965-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260206045942.52965-1-ebiggers@kernel.org>
References: <20260206045942.52965-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix verity_fec_ctr() to reject too-small FEC devices by correctly
computing the number of parity blocks as 'f->rounds * f->roots'.
Previously it incorrectly used 'div64_u64(f->rounds * f->roots,
v->fec->roots << SECTOR_SHIFT)' which is a much smaller value.

Note that the units of 'rounds' are blocks, not bytes.  This matches the
units of the value returned by dm_bufio_get_device_size(), which are
also blocks.  A later commit will give 'rounds' a clearer name.

Fixes: a739ff3f543a ("dm verity: add support for forward error correction")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 drivers/md/dm-verity-fec.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 7583607a8aa62..5c276d0fc20c0 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -623,11 +623,11 @@ int verity_fec_ctr_alloc(struct dm_verity *v)
  */
 int verity_fec_ctr(struct dm_verity *v)
 {
 	struct dm_verity_fec *f = v->fec;
 	struct dm_target *ti = v->ti;
-	u64 hash_blocks, fec_blocks;
+	u64 hash_blocks;
 	int ret;
 
 	if (!verity_fec_is_enabled(v)) {
 		verity_fec_dtr(v);
 		return 0;
@@ -704,12 +704,11 @@ int verity_fec_ctr(struct dm_verity *v)
 		return PTR_ERR(f->bufio);
 	}
 
 	dm_bufio_set_sector_offset(f->bufio, f->start << (v->data_dev_block_bits - SECTOR_SHIFT));
 
-	fec_blocks = div64_u64(f->rounds * f->roots, v->fec->roots << SECTOR_SHIFT);
-	if (dm_bufio_get_device_size(f->bufio) < fec_blocks) {
+	if (dm_bufio_get_device_size(f->bufio) < f->rounds * f->roots) {
 		ti->error = "FEC device is too small";
 		return -E2BIG;
 	}
 
 	f->data_bufio = dm_bufio_client_create(v->data_dev->bdev,
-- 
2.52.0

