Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5FC53A8739;
	Sat,  1 Aug 2026 02:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785551524; cv=none; b=Om2VmGCVUxhJccGEUcLCYMBg84rZTPsrpBcRTsKoR1+0Mp/YfE2m+CCOET8Pym4sFQcKxGErOM9iveKFC7NjUju3RLS0D5j1JvPpa/GECx/0sAUIlVj8ZtsF32UgQhcSnI3F0Nv1oli/Sp96uLepaYYMC1BqbOhpwDSLZ/DIq3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785551524; c=relaxed/simple;
	bh=Y+GO4cGJr2DyQF9toXB4QmMs42LMVZ0lwdGnls3VSTo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Kqh4nLeThIZooi0QwtgU7zXOhRxZD3GvwaidLjSI0RDT+OQklZqTZIutTRq2kutZ8ZRAzEph0AFPk0sIEA9rib0i/gxsZDlCwg2w6/0RJ6QGn3X/5NeJcLFSN1DFsqWMY7EuxpyixiTqdRoTe5Z0kfQfbUvNgHi0AZzEpJBdwMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R6w8Y1pi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6w8Y1pi"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 794EAC2BCF5;
	Sat,  1 Aug 2026 02:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785551524;
	bh=Y+GO4cGJr2DyQF9toXB4QmMs42LMVZ0lwdGnls3VSTo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=R6w8Y1pi2uU2LqqGjjWsbw1+5w3xEzDZHUu+83RFSvJsJuAyVIKWmntN5DZcTyzHA
	 AMuzQsnNwUDjvyELyLCqHhtrtsSuFidGbWzntP7drCFUUOqLZiq5kZvc79efjdQtVJ
	 yk7ho2HIyfbxLsSsJ3aL6dSj1QT+AdZiJlU43gQWsimPZT8hwP0AgV9U+pIxMC5JF5
	 SXz/V22aK5e9cEBNH1Hxd8o50cmyOo5OEZu1ZyigayqnrYcdtXkn0/2EXkTOfCArT5
	 WKfkNmjrcNUzHO7ZLULA1/7p7GLCmzG8AtxEdv8ikHExHjheuBYPrXihT4MC9cNwT4
	 I8++Lv1itDo0g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CA4C55171;
	Sat,  1 Aug 2026 02:32:04 +0000 (UTC)
From: Bryam Vargas via B4 Relay <devnull+hexlabsecurity.proton.me@kernel.org>
Date: Fri, 31 Jul 2026 21:32:03 -0500
Subject: [PATCH 1/2] dm btree: hold a node header to the geometry its
 writers guarantee
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260731-b4-disp-1fdddbbb-v1-1-4879ae1012a2@proton.me>
References: <20260731-b4-disp-1fdddbbb-v1-0-4879ae1012a2@proton.me>
In-Reply-To: <20260731-b4-disp-1fdddbbb-v1-0-4879ae1012a2@proton.me>
To: Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>, Ming-Hung Tsai <mtsai@redhat.com>, 
 Heinz Mauelshagen <heinzm@redhat.com>, Alasdair Kergon <agk@redhat.com>, 
 dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Benjamin Marzinski <bmarzins@redhat.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785551523; l=3926;
 i=hexlabsecurity@proton.me; s=default; h=from:subject:message-id;
 bh=SnIoIuUzdET3sEwmH/NlsmiMJYNEfOw+g2ZqpCChPcQ=;
 b=xxC02AzzptIh1Qei8U7/FuEVMTtkd8cyQf3at4duF5do4FTaVkJnK2LDcUsIhDasBzMGRXoNu
 XpmBRdmUeXVDU6bVcor/7qVrr5DIYMsMmA8JXLBlwtElzCjE8oTotLL
X-Developer-Key: i=hexlabsecurity@proton.me; a=ed25519;
 pk=xw1AhCtQdvuoQc+bOQIYy9o8G++cp4/VniI2G/tc3G8=
X-Endpoint-Received: by B4 Relay for hexlabsecurity@proton.me/default with
 auth_id=893
X-Original-From: Bryam Vargas <hexlabsecurity@proton.me>
Reply-To: hexlabsecurity@proton.me

From: Bryam Vargas <hexlabsecurity@proton.me>

node_check() weighs a node header against itself and nothing else, which
leaves three shapes the writers never produce and the reader accepts: a
zero value_size, which collapses value_ptr()'s stride so max_entries
alone places the value area, off the end of the block; an internal node
whose value_size is not the __le64 stride value64() indexes it with; and
a max_entries that disagrees with calc_max_entries(), the formula every
writer computes it from.

Reject all three. Conforming metadata satisfies them by construction:
dm_btree_empty() and btree_split_beneath() take max_entries from
calc_max_entries() and write sizeof(__le64) for an internal node, and
the split paths copy flags, max_entries and value_size together.
calc_max_entries() gains a declaration in dm-btree-internal.h so the
validator shares the formula rather than open-coding it.

Fixes: 3241b1d3e0aa ("dm: add persistent data library")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
---
 drivers/md/persistent-data/dm-btree-internal.h |  2 ++
 drivers/md/persistent-data/dm-btree-spine.c    | 20 +++++++++++++++++++-
 drivers/md/persistent-data/dm-btree.c          |  2 +-
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/md/persistent-data/dm-btree-internal.h b/drivers/md/persistent-data/dm-btree-internal.h
index acebd32858a7..404739149d02 100644
--- a/drivers/md/persistent-data/dm-btree-internal.h
+++ b/drivers/md/persistent-data/dm-btree-internal.h
@@ -43,6 +43,8 @@ struct btree_node {
 } __packed __aligned(8);
 
 
+uint32_t calc_max_entries(size_t value_size, size_t block_size);
+
 /*
  * Locks a block using the btree node validator.
  */
diff --git a/drivers/md/persistent-data/dm-btree-spine.c b/drivers/md/persistent-data/dm-btree-spine.c
index c46fc50c274e..076f836912c8 100644
--- a/drivers/md/persistent-data/dm-btree-spine.c
+++ b/drivers/md/persistent-data/dm-btree-spine.c
@@ -57,6 +57,25 @@ static int node_check(const struct dm_block_validator *v,
 	nr_entries = le32_to_cpu(h->nr_entries);
 	max_entries = le32_to_cpu(h->max_entries);
 	value_size = le32_to_cpu(h->value_size);
+	flags = le32_to_cpu(h->flags);
+
+	if (!value_size) {
+		DMERR_LIMIT("%s failed: value_size is zero", __func__);
+		return -EILSEQ;
+	}
+
+	if ((flags & INTERNAL_NODE) && value_size != sizeof(__le64)) {
+		DMERR_LIMIT("%s failed: internal node value_size %zu != %zu",
+			    __func__, value_size, sizeof(__le64));
+		return -EILSEQ;
+	}
+
+	if (max_entries != calc_max_entries(value_size, block_size)) {
+		DMERR_LIMIT("%s failed: max_entries %u != wanted %u for value_size %zu",
+			    __func__, max_entries,
+			    calc_max_entries(value_size, block_size), value_size);
+		return -EILSEQ;
+	}
 
 	if (sizeof(struct node_header) +
 	    (sizeof(__le64) + value_size) * max_entries > block_size) {
@@ -72,7 +91,6 @@ static int node_check(const struct dm_block_validator *v,
 	/*
 	 * The node must be either INTERNAL or LEAF.
 	 */
-	flags = le32_to_cpu(h->flags);
 	if (!(flags & INTERNAL_NODE) && !(flags & LEAF_NODE)) {
 		DMERR_LIMIT("%s failed: node is neither INTERNAL or LEAF", __func__);
 		return -EILSEQ;
diff --git a/drivers/md/persistent-data/dm-btree.c b/drivers/md/persistent-data/dm-btree.c
index dd02eee4a23c..5ed3b3e9abb9 100644
--- a/drivers/md/persistent-data/dm-btree.c
+++ b/drivers/md/persistent-data/dm-btree.c
@@ -114,7 +114,7 @@ static int insert_at(size_t value_size, struct btree_node *node, unsigned int in
  * We want 3n entries (for some n).  This works more nicely for repeated
  * insert remove loops than (2n + 1).
  */
-static uint32_t calc_max_entries(size_t value_size, size_t block_size)
+uint32_t calc_max_entries(size_t value_size, size_t block_size)
 {
 	uint32_t total, n;
 	size_t elt_size = sizeof(uint64_t) + value_size; /* key + value */

-- 
2.55.0


