Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE642673AA;
	Sun,  1 Mar 2026 02:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772330453; cv=none; b=mUdcHgz9MdObDsKDkyRP9kWBNt7iSGQw9uuQhnrt1jCZ0jjeGZrW8d+PzSabL3Wva2BTUF4ilan38TAVlIaZHdz+pgMeK6QeMiPlVNiHkD/FDSQxIn8Oiit7c02iSKVvv6nU9AxMF+NtnC89fNaJRaZGok6SJ0Jm4Zph150jBnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772330453; c=relaxed/simple;
	bh=sRiAbVZEtucVV/FCQuNlZZ+or8oZjZ9TM8ZA5WygZqc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p29F6kasNMszOJG06J6DrsSRZbPBmfIOOZtXDqAd/IrA4nXT/X8UAen+2fCBDqxvyQUcUncY825gZSUY3/G7qhwTOzHxLJUOITgRyGxfPZxWTXj/3le+sQfafdqbAQpk0xdawNOi0wCT959TlxlNxOm3kNesNEhNattVGSVADl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyg6uPX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyg6uPX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E1AC19421;
	Sun,  1 Mar 2026 02:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330453;
	bh=sRiAbVZEtucVV/FCQuNlZZ+or8oZjZ9TM8ZA5WygZqc=;
	h=From:To:Cc:Subject:Date:From;
	b=hyg6uPX4GWzEKsR32UzGFtZ+mWeGpFmtyp+QpbFJ8e+2h4vSGTm5JeLmSf0PEEngq
	 afHjyuVC0Yahd3grN0evAl/pS22Af+IobYR+sruDRoYE2uNGCr66r1BFgaxY38x8q1
	 NPRRhp4Et/eUhXjIBkdi3oL5gdGCjSHlTOqwElWJyDyPMLwdXiGWuCAn86HyOwlrxs
	 6EdJ6052dSDP2T1OhQwOT34R0xTA0pTY5hTcgcOrDHU1ATf0lQzN8ppqn105P6iE6q
	 2iINvcMGeei8qFPsENBmHmw2JX5Y99zIVqaFQbfeuegVJhxAO+Nt2FxufpCaH3hyCn
	 3Z8A1pL4WA8oQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	mpatocka@redhat.com
Cc: Ondrej Kozina <okozina@redhat.com>,
	dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm-integrity: fix recalculation in bitmap mode" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:00:51 -0500
Message-ID: <20260301020051.1727770-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 118ba36e446c01e3cd34b3eedabf1d9436525e1d Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Mon, 19 Jan 2026 15:06:02 +0100
Subject: [PATCH] dm-integrity: fix recalculation in bitmap mode

There's a logic quirk in the handling of suspend in the bitmap mode:

This is the sequence of calls if we are reloading a dm-integrity table:
* dm_integrity_ctr reads a superblock with the flag SB_FLAG_DIRTY_BITMAP
  set.
* dm_integrity_postsuspend initializes a journal and clears the flag
  SB_FLAG_DIRTY_BITMAP.
* dm_integrity_resume sees the superblock with SB_FLAG_DIRTY_BITMAP set -
  thus it interprets the journal as if it were a bitmap.

This quirk causes recalculation problem if the user increases the size of
the device in the bitmap mode.

Fix this by reading a fresh copy on the superblock in
dm_integrity_resume. This commit also fixes another logic quirk - the
branch that sets bitmap bits if the device was extended should only be
executed if the flag SB_FLAG_DIRTY_BITMAP is set.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Tested-by: Ondrej Kozina <okozina@redhat.com>
Fixes: 468dfca38b1a ("dm integrity: add a bitmap mode")
Cc: stable@vger.kernel.org
---
 drivers/md/dm-integrity.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 380527f43b2a1..a9c0157bf42fe 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -3788,14 +3788,27 @@ static void dm_integrity_resume(struct dm_target *ti)
 	struct dm_integrity_c *ic = ti->private;
 	__u64 old_provided_data_sectors = le64_to_cpu(ic->sb->provided_data_sectors);
 	int r;
+	__le32 flags;
 
 	DEBUG_print("resume\n");
 
 	ic->wrote_to_journal = false;
 
+	flags = ic->sb->flags & cpu_to_le32(SB_FLAG_RECALCULATING);
+	r = sync_rw_sb(ic, REQ_OP_READ);
+	if (r)
+		dm_integrity_io_error(ic, "reading superblock", r);
+	if ((ic->sb->flags & flags) != flags) {
+		ic->sb->flags |= flags;
+		r = sync_rw_sb(ic, REQ_OP_WRITE | REQ_FUA);
+		if (unlikely(r))
+			dm_integrity_io_error(ic, "writing superblock", r);
+	}
+
 	if (ic->provided_data_sectors != old_provided_data_sectors) {
 		if (ic->provided_data_sectors > old_provided_data_sectors &&
 		    ic->mode == 'B' &&
+		    ic->sb->flags & cpu_to_le32(SB_FLAG_DIRTY_BITMAP) &&
 		    ic->sb->log2_blocks_per_bitmap_bit == ic->log2_blocks_per_bitmap_bit) {
 			rw_journal_sectors(ic, REQ_OP_READ, 0,
 					   ic->n_bitmap_blocks * (BITMAP_BLOCK_SIZE >> SECTOR_SHIFT), NULL);
-- 
2.51.0




