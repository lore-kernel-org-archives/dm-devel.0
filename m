Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EF229D270;
	Sun,  1 Mar 2026 01:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328750; cv=none; b=A30gExHCK3kCQCuklYtKjF3QKFsbRf2Afyry3hc4OWrNqFk6PQG0XGTMyWhx1Yzc7RFfQ+e7Em1VRSKoFEt5Q3e/MTnDTWl+zAFgdWiBv3lhuRfjM4aHv2VB5Sxo2NMBX+r3N/DggNS4R1wWy/LaBvvQ7F9xe8NgkZrQVWRql3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328750; c=relaxed/simple;
	bh=e7Zoi+CR3Z3G2lEw20DOPseLJyZXSkuFXvTRS5S8FFA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gaYWSmrDouqlxlzZuLNaQ8vGVQgAmlM+dsT/jlIJzH6F4vPOCqnX0R23/Na0sR2tpdjQYvJrCdBg6b4xzZC6R7XBcXkuzaNjAfKN6QldI2+x2NUR/9HnDZ4PpRCxkxO8JKityh4ui7V3bVYEKof20uwap+4TLyC3H0O48VInSrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UXCKIdmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UXCKIdmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04187C19421;
	Sun,  1 Mar 2026 01:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328750;
	bh=e7Zoi+CR3Z3G2lEw20DOPseLJyZXSkuFXvTRS5S8FFA=;
	h=From:To:Cc:Subject:Date:From;
	b=UXCKIdmExFTqtxEB0QDqdwBM/58EGAMpBKsxbKUkXCPF6j92cycrFimHxPf9tTSBQ
	 D5F2rMntJLR1sp0llm2Y1NGQh0YIRFioBzdJbRdTK5JU97U7e0z4PSB8f8ERSMeYKU
	 i9N800D6CLDsoKYgQLlWSylH8yW+J7GckFANDZaAMp+4mcpRiB+Dbti2kxl+iwQmau
	 n60qcZmxZF/AjNVSPhZfEypeWjW/hT3dOw42DU9stBsnPNMI7FluHRexVxBi51lxPP
	 F7KGN/V5N/kgOvOymD2SKraCj2B3BlMPPuSi9OToUBqlnHMnZ2XuhpIksnxIP25qaj
	 pdsc+RMAwhS/g==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev
Subject: FAILED: Patch "dm-integrity: fix a typo in the code for write/discard race" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:32:28 -0500
Message-ID: <20260301013228.1691438-1-sashal@kernel.org>
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

The patch below does not apply to the 6.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From c698b7f417801fcd79f0dc844250b3361d38e6b8 Mon Sep 17 00:00:00 2001
From: Mikulas Patocka <mpatocka@redhat.com>
Date: Mon, 12 Jan 2026 21:15:27 +0100
Subject: [PATCH] dm-integrity: fix a typo in the code for write/discard race

If we send a write followed by a discard, it may be possible that the
discarded data end up being overwritten by the previous write from the
journal. The code tries to prevent that, but there was a typo in this
logic that made it not being activated as it should be.

Note that if we end up here the second time (when discard_retried is
true), it means that the write bio is actually racing with the discard
bio, and in this situation it is not specified which of them should win.

Cc: stable@vger.kernel.org
Fixes: 31843edab7cb ("dm integrity: improve discard in journal mode")
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-integrity.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 170bf67a2edd9..79d60495454a5 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2411,7 +2411,7 @@ static void dm_integrity_map_continue(struct dm_integrity_io *dio, bool from_map
 
 		new_pos = find_journal_node(ic, dio->range.logical_sector, &next_sector);
 		if (unlikely(new_pos != NOT_FOUND) ||
-		    unlikely(next_sector < dio->range.logical_sector - dio->range.n_sectors)) {
+		    unlikely(next_sector < dio->range.logical_sector + dio->range.n_sectors)) {
 			remove_range_unlocked(ic, &dio->range);
 			spin_unlock_irq(&ic->endio_wait.lock);
 			queue_work(ic->commit_wq, &ic->commit_work);
-- 
2.51.0




