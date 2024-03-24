Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3AB3771F;
	Sun, 24 Mar 2024 18:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711304655; cv=none; b=DwF0+V9uwHjCCjZ/ObU0F7mybyhe4KdrZxvPECyfViBOl3umH96Sd/341w6RAvHS8ksDSq8WUx59040eXrIKkzIiUS6YFvUxl59r73TO2iH1ZFLBaSZDMLssBapQxEE4O7+QHTl8yelpso11PTgEHtLG8o/w1eh12BGPQiHUHMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711304655; c=relaxed/simple;
	bh=ilWp9NL+csVlM/byy0TAZeWtYyo0+N71kus7kAVVJco=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DnaQfYq1neDIrmFn3JYANxzoMkvGgnUUY07jiHiNP/GsjIt7Lo25AR9iBJrMkoWImDEfR3gZhStMRXe5R1RCMbtqmRl+yMtC+g43d9ZCTTEwmhfhh8exXrQyvNqCPtzvoEpX4Q1RA7lgtGLDBrh6RTRHxWWg6mbfC6JzeDdE9wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vj/NB7le; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vj/NB7le"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD1DC433F1;
	Sun, 24 Mar 2024 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711304655;
	bh=ilWp9NL+csVlM/byy0TAZeWtYyo0+N71kus7kAVVJco=;
	h=From:To:Cc:Subject:Date:From;
	b=Vj/NB7leDrJ4E1CcNFhbYiJ7gryW6TR6ic55mXFv2AUZSTy3CGKV6ecej+R4c/Ptk
	 4bZOmFYFQwp+/VV8NFfaJxjohvsHr5nwrLqpjRpXL+uuJNlehTaMVpUrrofBB3KGZE
	 mq3ZzqQJ9Q/Vh7sHtewD/1zU7/cEWwLMApshxsDUhKPIGv4gDTnAn++g5zRpGEuB24
	 YuAvpdKYJ1caTKVU5Xd2XR+Gl6QczD/ueZ97nIosdM79G5T2LweHMZiHAwHfeE8En2
	 J13422XcrCMoXCMjLEeVx5h2gQWTU/0267QrS2oTBJfiUIkcVMrLnq1jXtQyCatIr0
	 5LLQ2719PbJNQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-integrity: align the outgoing bio in integrity_recheck" has been added to the 6.6-stable tree
Date: Sun, 24 Mar 2024 14:24:14 -0400
Message-ID: <20240324182414.647418-1-sashal@kernel.org>
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

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-align-the-outgoing-bio-in-integrity_rec.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 34f071787888a3728fe25dcd57726499e8074371
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
index 71c3b891c4df5..e7cd27e387df1 100644
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
