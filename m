Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13BA2E974D;
	Fri, 31 Jul 2026 22:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785538495; cv=none; b=JIt69UcqfgUzt/LQD4HZhPG5Pkr2cdHeZnBcXRG20gkgA5JkkWOwSJLY5KGxXFcbryoILnbzaXvYgkZ8ynUHLNnfBoJWxTHOb5IBSSV3OAenMTGBPZ7i5DO9BNKSWiEwkcFtg11zQv3VU+ElYo9Qq6Jiu9Bn0t6Yo4pEqJR4VXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785538495; c=relaxed/simple;
	bh=EWRsXL2UZCp5C+627LtlOmXNPYa02YdB7Oc6L75P7mw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=m6gZVFWdpfSEgfSlGQbVrdzE7dJIBQT5YOeTl86svn29yz1ieFQb3lYioPCey4uyx0l32uwDbqNKXp/8HfqQxH9HriJ8NCAiOEW/GkOhV+5KuzvGFH1P++gu59b7RdC4wxSxqO1Av8Loa6LCRA39lwbgju5eR7fkcO/gcMGYyZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKbNNg7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKbNNg7E"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A97BCC2BCFA;
	Fri, 31 Jul 2026 22:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785538494;
	bh=EWRsXL2UZCp5C+627LtlOmXNPYa02YdB7Oc6L75P7mw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=BKbNNg7E1Dlz3JgnSVBzscYe1eJIw2wV5jwNmwsKzjTq80OAw5wBbUEpIjxf8wS1+
	 cou8KhA47AU+mbOh8Xs8MNcCCCbU4oT2914T1O5WAWKFWoUAidvoF/XjbM4Jof4jaS
	 5T9fYk2S7lnO0FIXELoKm4nax/X8VvKxPGaZJg+5qwb0DKUCHS2bHgJ4nr15WCSuIA
	 djnKfOw//8H0tH5nilGXX09IObTW8kWhpZzofLBy+ISEoyxqFlYix8tTXqFmDh/SUg
	 c4aGV01Bnun81ULVtHxmwQN+UAYdlnUOqMALYMKspkLCHLcxdtWiQcb9jc408lMzcF
	 ps7ubYYjIRPiQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8905EC55171;
	Fri, 31 Jul 2026 22:54:54 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 31 Jul 2026 17:54:55 -0500
Subject: [PATCH v2 2/2] dm array: reject an array block whose value size is
 not the caller's
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-b4-disp-4fd3bed9-v2-2-7b1835e4e7f6@proton.me>
References: <20260731-b4-disp-4fd3bed9-v2-0-7b1835e4e7f6@proton.me>
In-Reply-To: <20260731-b4-disp-4fd3bed9-v2-0-7b1835e4e7f6@proton.me>
To: Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Ming-Hung Tsai <mtsai@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>, dm-devel@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
 Joe Thornber <ejt@redhat.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785538493; l=2167;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=Ul/YVEYx7ppMlrNbWtiuuf0bp6yCLk0T8hcMri+dvhc=;
 b=GMc3NdEdnxOY3TEwBmNrK1iW6ewemD37170O+LL6VpAiWbYeJ9RhKJKj58jcHkgVi5fx1k/Ng
 KlC8sRhAwB+BYUHmpw5iuKLdBFl5Tbuu3TXdtEdT2PPNSLVon8bGHxg
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

array_block_check() can only compare the header against itself, so a block
with value_size 4 and max_entries 1018 is internally consistent and passes.
dm-cache keeps two arrays -- mappings at 8 bytes and hints at 4 -- and the
roots for both live in the superblock. Point the mappings root at a hint
block and __load_mappings() walks it through an info whose value size is 8,
so element_at() strides 8 bytes over 4-byte entries and reaches offset 8160
of a 4096-byte block.

get_ablock() and __shadow_ablock() are the two places that hold the block
and the caller at once. Reject there when the two value sizes disagree.
Arrays only ever read their own blocks, so this fires on crafted metadata
only.

Fixes: 6513c29f44f2 ("dm persistent data: add transactional array")
Suggested-by: Ming-Hung Tsai <mtsai@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/persistent-data/dm-array.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/md/persistent-data/dm-array.c b/drivers/md/persistent-data/dm-array.c
index 5949fb0e16c6..6de1c0467ec9 100644
--- a/drivers/md/persistent-data/dm-array.c
+++ b/drivers/md/persistent-data/dm-array.c
@@ -247,6 +247,14 @@ static int get_ablock(struct dm_array_info *info, dm_block_t b,
 		return r;
 
 	*ab = dm_block_data(*block);
+	if (le32_to_cpu((*ab)->value_size) != info->value_type.size) {
+		DMERR_LIMIT("%s failed: value_size %u != wanted %u", __func__,
+			    le32_to_cpu((*ab)->value_size),
+			    info->value_type.size);
+		dm_tm_unlock(info->btree_info.tm, *block);
+		return -EILSEQ;
+	}
+
 	return 0;
 }
 
@@ -309,6 +317,14 @@ static int __shadow_ablock(struct dm_array_info *info, dm_block_t b,
 		return r;
 
 	*ab = dm_block_data(*block);
+	if (le32_to_cpu((*ab)->value_size) != info->value_type.size) {
+		DMERR_LIMIT("%s failed: value_size %u != wanted %u", __func__,
+			    le32_to_cpu((*ab)->value_size),
+			    info->value_type.size);
+		dm_tm_unlock(info->btree_info.tm, *block);
+		return -EILSEQ;
+	}
+
 	if (inc)
 		inc_ablock_entries(info, *ab);
 

-- 
2.55.0


