Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14D63793B0;
	Fri, 31 Jul 2026 22:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785538495; cv=none; b=VX7zVfOrfuC3zEszysC5gTznrCLn1oiJp9dWYS4EftR9NnhjWDTbBjgOUMg9vuQrgqgQ+spkQkD68UklONHBEUsVbWczpgywstfAj8/n8ABvWUCJeobONuArX4uhTCOfaVEis1Rl9wN+cS/qkg1Q3oVeGcsPBy5EvOc4VArcPtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785538495; c=relaxed/simple;
	bh=GArldEVppMA0Ukn/Yl9Tr9Abi4jpZvg7kZTfNBRs2aE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IgE6FBQHI3ty1wpD8h9T1cjs3IBM6dk0iZYfofm0DZGzdvPs+5oMhnU76+DKkocm1EH+Nyn/HzYqnqIkuWf80kfZ+/EZknC8JuwfrEivD6KOy+36+114dx9bzjGLjNMVta3m+DxmY7yspxGzHknAmIWfCfqQNxSWql7vRBpz/Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BY2scpWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BY2scpWx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9CCFFC2BCF5;
	Fri, 31 Jul 2026 22:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785538494;
	bh=GArldEVppMA0Ukn/Yl9Tr9Abi4jpZvg7kZTfNBRs2aE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BY2scpWxJ4X7rCKZJ6exrj0dJcPE2fEh3mvkMrc9RUhVIBQEs2NHYtezpnReE5U3K
	 m7rwvX2D6LSqxKhVt0gbFyKi5F7Qax+EM3ORquPtN9oGiR+faX4TJa7iW4729flA9I
	 dTriZQwUEgIlVpBdOdnHWFdQ+uZukUTokUOgNl/oF5b9JMeWl+7pr4P0Tge1t+FtJ0
	 FHu2T0NTE1pI5prug+GtrTh35yUMqmX03WbYjvocydzEWU1yv9tUvn6kPHxiSC0xyn
	 NVqOPCSp/hqYJZ1wgVlm/qj30JwuVYo9ojYO+yKKQpFrKqJdtH1Ic6Bj0ADMID9ag6
	 uv7OLiZXOqrXw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C31BC55172;
	Fri, 31 Jul 2026 22:54:54 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 31 Jul 2026 17:54:54 -0500
Subject: [PATCH v2 1/2] dm array: validate array block headers on read
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-b4-disp-4fd3bed9-v2-1-7b1835e4e7f6@proton.me>
References: <20260731-b4-disp-4fd3bed9-v2-0-7b1835e4e7f6@proton.me>
In-Reply-To: <20260731-b4-disp-4fd3bed9-v2-0-7b1835e4e7f6@proton.me>
To: Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Ming-Hung Tsai <mtsai@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
 Joe Thornber <ejt@redhat.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785538493; l=3385;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=3TugB3ShfulMF0Ws150WFu3vRI3cUITFclPEvmxghdM=;
 b=nqIsT4mK5C34isYF3tPHiRU9r7DF4Lq9nkKilWofOcgdZSIXxUR7h+7qs+zJ7EqtUByRpXQ2B
 nUnVgIylUpaDvtWowj2oPR1shL6dohFO0qJfuGAPeAZQSXPnRmJnRyv
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

array_block_check() validates blocknr and csum and nothing else, while
node_check(), next to it, has bounded the structural fields since both
were written. dm_array_cursor_next() takes its loop bound from the
on-disk nr_entries and element_at() is unguarded pointer arithmetic, so
a count larger than the block holds keeps the cursor in one block while
the index grows past it and the read walks off the dm-bufio buffer --
dm_cache_load_mappings() drives it once per cache block at activation.

Check the header against itself: reject a zero value_size, require
max_entries to equal calc_max_entries() for that value_size and block
size, and require nr_entries to fit. Equality rather than an upper bound,
since a count below the real capacity trips BUG_ON() in fill_ablock() and
trim_ablock(). Metadata dm-array writes satisfies all three.

Fixes: 6513c29f44f2 ("dm persistent data: add transactional array")
Suggested-by: Ming-Hung Tsai <mtsai@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/persistent-data/dm-array.c | 38 +++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 8f8792e55806..5949fb0e16c6 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -38,6 +38,14 @@ struct array_block {
  */
 #define CSUM_XOR 595846735
 
+/*
+ * Each array block can hold this many values.
+ */
+static uint32_t calc_max_entries(size_t value_size, size_t size_of_block)
+{
+	return (size_of_block - sizeof(struct array_block)) / value_size;
+}
+
 static void array_block_prepare_for_write(const struct dm_block_validator *v,
 					  struct dm_block *b,
 					  size_t size_of_block)
@@ -55,6 +63,7 @@ static int array_block_check(const struct dm_block_validator *v,
 			     size_t size_of_block)
 {
 	struct array_block *bh_le = dm_block_data(b);
+	uint32_t nr_entries, max_entries, value_size, wanted;
 	__le32 csum_disk;
 
 	if (dm_block_location(b) != le64_to_cpu(bh_le->blocknr)) {
@@ -74,6 +83,27 @@ static int array_block_check(const struct dm_block_validator *v,
 		return -EILSEQ;
 	}
 
+	nr_entries = le32_to_cpu(bh_le->nr_entries);
+	max_entries = le32_to_cpu(bh_le->max_entries);
+	value_size = le32_to_cpu(bh_le->value_size);
+
+	if (!value_size) {
+		DMERR_LIMIT("%s failed: value_size is zero", __func__);
+		return -EILSEQ;
+	}
+
+	wanted = calc_max_entries(value_size, size_of_block);
+	if (max_entries != wanted) {
+		DMERR_LIMIT("%s failed: max_entries %u != wanted %u for value_size %u",
+			    __func__, max_entries, wanted, value_size);
+		return -EILSEQ;
+	}
+
+	if (nr_entries > max_entries) {
+		DMERR_LIMIT("%s failed: too many entries", __func__);
+		return -EILSEQ;
+	}
+
 	return 0;
 }
 
@@ -138,14 +168,6 @@ static void dec_ablock_entries(struct dm_array_info *info, struct array_block *a
 		on_entries(info, ab, vt->dec);
 }
 
-/*
- * Each array block can hold this many values.
- */
-static uint32_t calc_max_entries(size_t value_size, size_t size_of_block)
-{
-	return (size_of_block - sizeof(struct array_block)) / value_size;
-}
-
 /*
  * Allocate a new array block.  The caller will need to unlock block.
  */

-- 
2.55.0


