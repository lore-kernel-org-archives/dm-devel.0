Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91892F58;
	Sun, 24 Mar 2024 18:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711304830; cv=none; b=FFT0RzvVu3RuDc1uB8dKa6BNiPlD9Ba5dDw3lgUUkU0qz1EGqxjgNaAp8PCdM2XcvrCfEvO7/0Mmz4aUquAsOD0UsxDhn4GfNfiPE8w/g/3XbwxJASpSY8LmnemMkboQX/PZEIDULruuznOUvxuf3BfFNM5Xigr9LpUJnk8lEp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711304830; c=relaxed/simple;
	bh=6VfBeiCJKnqeVcZHF2n+DxGhxDCY3+oRkv3RkGZB/Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=up75tbzQMfDpZOmUaG2FtMu0pygSDZk82HfFqbUxZZzseoIbT5qrHMRaybm/vyEynfVQhTT8668kXkIhS25qWfNpwBE8LnlatGAxsRZ2OsOmPnn9FQAqWtuHgr0tPDF0JsaTWkGchQMt2aLSGQ+tD8DTWlmX/xPv1Pz7/jbxbMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8DNqbSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8DNqbSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59D3C433F1;
	Sun, 24 Mar 2024 18:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711304830;
	bh=6VfBeiCJKnqeVcZHF2n+DxGhxDCY3+oRkv3RkGZB/Ys=;
	h=From:To:Cc:Subject:Date:From;
	b=e8DNqbSukwDg7NmeAzOh/8U04Vh+h6kU+YOmXMaH1FT6ZdTyk74q3tzVmzJRPTll1
	 t+rGjYnnys+VroGqDggRFTAXMcoB/sXxyekfyFetC1JXWOE37srbkzfVFmqqdKcIgY
	 CSAL0ueHGMwEas32vUrKt6+pMshXm4hStBUAdpwWfAHzkcsD44teiKdi+tKrX/7Eu8
	 O59JNeU+DSLCvtrObOPBFoXfBLkaZ83z62ezaeCSLbKxuLqSwqtatD6gc1gO47t0iW
	 MAZyhK8DyxTg7twHpTk0rWhv1fkYe8OEB0RuSjXl0tawfHnMqlM/utiOV3PfSVL55v
	 b5QFGhw9nsfBA==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-integrity: align the outgoing bio in integrity_recheck" has been added to the 6.1-stable tree
Date: Sun, 24 Mar 2024 14:27:08 -0400
Message-ID: <20240324182709.650293-1-sashal@kernel.org>
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

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-align-the-outgoing-bio-in-integrity_rec.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit cbee6076b3123d67dd0c7184553892d298a6c5da
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
index aff818eb31fbb..9c9e2b50c63c3 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1709,7 +1709,6 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
 	struct bio_vec bv;
 	sector_t sector, logical_sector, area, offset;
 	struct page *page;
-	void *buffer;
 
 	get_area_and_offset(ic, dio->range.logical_sector, &area, &offset);
 	dio->metadata_block = get_metadata_sector_and_offset(ic, area, offset,
@@ -1718,13 +1717,14 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
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
@@ -1737,6 +1737,14 @@ static noinline void integrity_recheck(struct dm_integrity_io *dio, char *checks
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
