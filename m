Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D00D28DB5;
	Sun, 24 Mar 2024 18:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711304444; cv=none; b=eKNFT2tA4lJcUTufHI6NNmpNR9fxvQsxRbD5fI242HBKwCneD6z82ISYDvjg0j8WFD/U11/Cy/WCuNYpWOtsSe1ojSDQJMz2ECW462KuCSRr/FMG1IM+Jz1+cMl2cRA4/UAlpPAbDE4XLHnNynoeLckvkLhBpdo6Zj4oUIaRsMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711304444; c=relaxed/simple;
	bh=cmrumHV1nDHTElTW7zkuW1S+/tsEaONJ0FiCWaDtVLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nTlMWDScP6ZWu+90OFYkuro0OVGPVIMwVaKinuF3/s9Pw0ee6y8GHzYtItYHxViNbSNr7sfVEsyijDU+udMfaHL0v4FF0/XK5UQempkq4IwaT3ucOmBd/78L2XAN9lPvoXfbrl28gUezMm1bJnS8/CqawuQqf674h1osJocAANE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NvdXcbDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NvdXcbDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B78DC433C7;
	Sun, 24 Mar 2024 18:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711304444;
	bh=cmrumHV1nDHTElTW7zkuW1S+/tsEaONJ0FiCWaDtVLU=;
	h=From:To:Cc:Subject:Date:From;
	b=NvdXcbDxq802aQm8vsrc9wL20RBKbIsmMmD1wmTg3ihOqR+mpgR1ZsjGWNF133AGQ
	 o59i1SDuRz1flXmdegehC3KKPJT1SFbef8LJojTqoNeIpfM7g6avR5kvH94G4b+En2
	 B4ljBG8hiRDpiRiAyqg2KHT/PIthEy5noN20kD/zeJwVxFK8LjAPHkXXLXAHyKNSsl
	 Y+la1GuL4pCYUHSkrJqlvVuVkuX8edrMklaQ7BNCbh/6Gm9pIBnuvV5Atgn55Y0wuJ
	 xqNLO6ddMbgEyapXjm/8/OCAPB337tRLmKkaVQTVMDu4lhbDE0k1hRrj3cBsrih/FZ
	 TqIjLcxyC4r5Q==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-integrity: align the outgoing bio in integrity_recheck" has been added to the 6.7-stable tree
Date: Sun, 24 Mar 2024 14:20:42 -0400
Message-ID: <20240324182042.643892-1-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit

This is a note to let you know that I've just added the patch titled

    dm-integrity: align the outgoing bio in integrity_recheck

to the 6.7-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-align-the-outgoing-bio-in-integrity_rec.patch
and it can be found in the queue-6.7 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 7e3c6ec5da50c9692f2d17c57db6576e2cb7f3d9
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Thu Mar 21 17:48:45 2024 +0100

    dm-integrity: align the outgoing bio in integrity_recheck
    
    [ Upstream commit b4d78cfeb30476239cf08f4f40afc095c173d6e3 ]
    
    It is possible to set up dm-integrity with smaller sector size than
    the logical sector size of the underlying device. In this situation,
    dm-integrity guarantees that the outgoing bios have the same alignment as
    incoming bios (so, if you create a filesystem with 4k block size,
    dm-integrity would send 4k-aligned bios to the underlying device).
    
    This guarantee was broken when integrity_recheck was implemented.
    integrity_recheck sends bio that is aligned to ic->sectors_per_block. So
    if we set up integrity with 512-byte sector size on a device with logical
    block size 4k, we would be sending unaligned bio. This triggered a bug in
    one of our internal tests.
    
    This commit fixes it by determining the actual alignment of the
    incoming bio and then makes sure that the outgoing bio in
    integrity_recheck has the same alignment.
    
    Fixes: c88f5e553fe3 ("dm-integrity: recheck the integrity tag after a failure")
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index ec8df735077fe..2cc30b9ab232a 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1699,7 +1699,6 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
 	struct bio_vec bv;
 	sector_t sector, logical_sector, area, offset;
 	struct page *page;
-	void *buffer;
 
 	get_area_and_offset(ic, dio->range.logical_sector, &area, &offset);
 	dio->metadata_block = get_metadata_sector_and_offset(ic, area, offset,
@@ -1708,13 +1707,14 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
 	logical_sector = dio->range.logical_sector;
 
 	page = mempool_alloc(&ic->recheck_pool, GFP_NOIO);
-	buffer = page_to_virt(page);
 
 	__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
 		unsigned pos = 0;
 
 		do {
+			sector_t alignment;
 			char *mem;
+			char *buffer = page_to_virt(page);
 			int r;
 			struct dm_io_request io_req;
 			struct dm_io_region io_loc;
@@ -1727,6 +1727,14 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
 			io_loc.sector = sector;
 			io_loc.count = ic->sectors_per_block;
 
+			/* Align the bio to logical block size */
+			alignment = dio->range.logical_sector | bio_sectors(bio) | (PAGE_SIZE >> SECTOR_SHIFT);
+			alignment &= -alignment;
+			io_loc.sector = round_down(io_loc.sector, alignment);
+			io_loc.count += sector - io_loc.sector;
+			buffer += (sector - io_loc.sector) << SECTOR_SHIFT;
+			io_loc.count = round_up(io_loc.count, alignment);
+
 			r = dm_io(&io_req, 1, &io_loc, NULL, IOPRIO_DEFAULT);
 			if (unlikely(r)) {
 				dio->bi_status = errno_to_blk_status(r);
