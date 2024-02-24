Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CF313AE9;
	Sat, 24 Feb 2024 13:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708781803; cv=none; b=mtK/ECDoKGdUGYGWxcnsFv2C7n3ZYha1FZydUxkF4TgXJ80fJy5+MsQI5nZ0DQrl5ZS03A9XDdpkJlTkgikDPW4UggCxtGmRyMV/itU44kgFIXuaC3rLF2Ev7kAmZWqpztv32Pu6clQu8c9Z5UTr9NpqpvnNF9Y+GJrRX4CbbcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708781803; c=relaxed/simple;
	bh=eJhU03MqBbaHHCZ+ZzyLcvbTDj5g3QZLy6DxfWu6JqE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dLVLwdVuGsSQ2P7fbuC04b8x7UjS9tEDecrmSgd4OdRTVue8IG7WCuzl6MbAQJYjSHIE+0zK0DHjywR1mCUDpCoddar/GcJMdqmcLGt9Eoir3BBoVHvh7TAmBXbHKsCeBcVoMFmD99ANBIOKGpuYgJbuSblAVvciRFnSQjMUEbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WDKohMW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WDKohMW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F79AC433C7;
	Sat, 24 Feb 2024 13:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708781803;
	bh=eJhU03MqBbaHHCZ+ZzyLcvbTDj5g3QZLy6DxfWu6JqE=;
	h=From:To:Cc:Subject:Date:From;
	b=WDKohMW/71O8uX6WWYU1woPUa5KKmV9iuOZs16yynV781144MRtrQSMImoIA+Z3wl
	 vsXSzxT5CUnJ2Ne4BfIK3acdYNLpE2A91s9KS7/N0Pan1bi4ZCdKzcnBzmCIKbYhR/
	 /CxjhvQuGMdT5YZ0E9eACIazvOPrLpG9NxAmd/FjKCfgPeQruDy+xEGvI2HTTC1iX3
	 1NE1GHqRTxhuAlbhhKrygPSVrRBjGx68LoI9yun01Pg8p9N1Kj9AsK/Ce8Q1ww1CHf
	 g9uJgUpAuVx613iuGoKJQkO0wdTiMO57GLLDphZBhL3XInsynnqZyjv0Xrtv97JAXw
	 x/WlNwvJtnaZQ==
From: Sasha Levin <sashal@kernel.org>
To: stable-commits@vger.kernel.org,
	mpatocka@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Patch "dm-integrity: don't modify bio's immutable bio_vec in integrity_metadata()" has been added to the 5.4-stable tree
Date: Sat, 24 Feb 2024 08:36:42 -0500
Message-ID: <20240224133642.198326-1-sashal@kernel.org>
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

    dm-integrity: don't modify bio's immutable bio_vec in integrity_metadata()

to the 5.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     dm-integrity-don-t-modify-bio-s-immutable-bio_vec-in.patch
and it can be found in the queue-5.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit a786824d93478146b4fd965e4c4a3a05732e0cdd
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Tue Dec 5 16:39:16 2023 +0100

    dm-integrity: don't modify bio's immutable bio_vec in integrity_metadata()
    
    commit b86f4b790c998afdbc88fe1aa55cfe89c4068726 upstream.
    
    __bio_for_each_segment assumes that the first struct bio_vec argument
    doesn't change - it calls "bio_advance_iter_single((bio), &(iter),
    (bvl).bv_len)" to advance the iterator. Unfortunately, the dm-integrity
    code changes the bio_vec with "bv.bv_len -= pos". When this code path
    is taken, the iterator would be out of sync and dm-integrity would
    report errors. This happens if the machine is out of memory and
    "kmalloc" fails.
    
    Fix this bug by making a copy of "bv" and changing the copy instead.
    
    Fixes: 7eada909bfd7 ("dm: add integrity target")
    Cc: stable@vger.kernel.org      # v4.12+
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@kernel.org>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 81157801a3dc6..f3246f7407d61 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -1582,11 +1582,12 @@ static void integrity_metadata(struct work_struct *w)
 		}
 
 		__bio_for_each_segment(bv, bio, iter, dio->bio_details.bi_iter) {
+			struct bio_vec bv_copy = bv;
 			unsigned pos;
 			char *mem, *checksums_ptr;
 
 again:
-			mem = (char *)kmap_atomic(bv.bv_page) + bv.bv_offset;
+			mem = (char *)kmap_atomic(bv_copy.bv_page) + bv_copy.bv_offset;
 			pos = 0;
 			checksums_ptr = checksums;
 			do {
@@ -1595,7 +1596,7 @@ static void integrity_metadata(struct work_struct *w)
 				sectors_to_process -= ic->sectors_per_block;
 				pos += ic->sectors_per_block << SECTOR_SHIFT;
 				sector += ic->sectors_per_block;
-			} while (pos < bv.bv_len && sectors_to_process && checksums != checksums_onstack);
+			} while (pos < bv_copy.bv_len && sectors_to_process && checksums != checksums_onstack);
 			kunmap_atomic(mem);
 
 			r = dm_integrity_rw_tag(ic, checksums, &dio->metadata_block, &dio->metadata_offset,
@@ -1615,9 +1616,9 @@ static void integrity_metadata(struct work_struct *w)
 			if (!sectors_to_process)
 				break;
 
-			if (unlikely(pos < bv.bv_len)) {
-				bv.bv_offset += pos;
-				bv.bv_len -= pos;
+			if (unlikely(pos < bv_copy.bv_len)) {
+				bv_copy.bv_offset += pos;
+				bv_copy.bv_len -= pos;
 				goto again;
 			}
 		}
