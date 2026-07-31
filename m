Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A387E21255A
	for <dm-devel@lists.linux.dev>; Fri, 31 Jul 2026 02:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785463767; cv=none; b=SnmE5v19rWLG5IQOkf2KTCYEdwI9cbllnk+Y0cTTOvM06Ygcz1OGR/oHr9qxt+I5sBNWB1uooR5olhYQTC+I/Df/VsW7SyywAFvSTaio37rAlmgVci6i3xmmUDHQNENOxyv+VUjNHKLbip5BxtLeHXXS5/cGQBJl/JyXaF5Dzls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785463767; c=relaxed/simple;
	bh=fnvx4I6Iz74ite3g3RiporF8jrVYkn+E6+jmvKq9i0Y=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ufqMJbYSh4W0hccw4o8dB4nhCfbyRmI8I7OpOZJsXfQyRzcqSS/vYuRihQS6QbR4olO5KEiBpMkf8Tgp0plcZIhGjw7UKRxx3tBXTpPU4eQ7cxaQr8z8uNR1chKPJ/US5QHjT6TyK3zmOa4XNttHp9P47ORofqm2TDrblaEm0a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LuTiSG+8; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LuTiSG+8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=jR
	7eriqff1SCpkNP2P5hNstsWuqzql2J5jGk5CvXBpI=; b=LuTiSG+84URuTbaMmH
	Uvr/K2baInmbBaq3cRmMK4S2DZ9TdRK4Rd+zVFHsE/66Kxm1/G8JgPggZvFdXk3n
	2BvJ8xoAM1DkjxZ4Swloohj8FCVkl09D5ImcrB6ntu6Qt3ef5e/UYevPbaPagJjS
	+iyOSdM7QjfGEUDpj4MW62i1o=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgD3vyyyA2xqtDuKJw--.12852S2;
	Fri, 31 Jul 2026 10:08:52 +0800 (CST)
From: dayou5941@163.com
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com
Cc: dm-devel@lists.linux.dev,
	liyouhong <liyouhong@kylinos.cn>
Subject: [PATCH] dm-era: fix shadowed superblock leak on take-snap failure
Date: Fri, 31 Jul 2026 10:08:49 +0800
Message-Id: <20260731020849.912213-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgD3vyyyA2xqtDuKJw--.12852S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7WF18Zr13urWfAFyDZFWfGrg_yoW8CF4kpa
	yUXrZ5G393KrW8WF9xZ3WUuFySg3W8W342yr4Iq3Z7AFyfWFn7Ca1kArn5AFy8tF92v3WD
	XayUXa4UWF4Utr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jOtxhUUUUU=
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3RSjUmpsA7SvXgAA34

From: liyouhong <liyouhong@kylinos.cn>

metadata_take_snap() bumps the live superblock refcount and then
dm_tm_shadow_block() allocates a new block for the metadata snapshot.
If the subsequent dm_sm_inc_block() of writeset_tree_root or
era_array_root fails, the function only unlocks the clone and
returns.  The newly allocated shadow block is never returned to the
metadata space map, so each failed take-snap permanently leaks one
metadata block.

Free the clone with dm_sm_dec_block() on those error paths, matching
the final step of metadata_drop_snap().

Fixes: eec40579d848 ("dm: add era target")
Signed-off-by: liyouhong <liyouhong@kylinos.cn>
---
 drivers/md/dm-era-target.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 7fe4d19ade4f..ea499adca4ce 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1034,6 +1034,7 @@ static int metadata_checkpoint(struct era_metadata *md)
 static int metadata_take_snap(struct era_metadata *md)
 {
 	int r, inc;
+	dm_block_t location;
 	struct dm_block *clone;
 
 	if (md->metadata_snap != SUPERBLOCK_LOCATION) {
@@ -1071,7 +1072,9 @@ static int metadata_take_snap(struct era_metadata *md)
 	r = dm_sm_inc_block(md->sm, md->writeset_tree_root);
 	if (r) {
 		DMERR("%s: couldn't inc writeset tree root", __func__);
+		location = dm_block_location(clone);
 		dm_tm_unlock(md->tm, clone);
+		dm_sm_dec_block(md->sm, location);
 		return r;
 	}
 
@@ -1079,7 +1082,9 @@ static int metadata_take_snap(struct era_metadata *md)
 	if (r) {
 		DMERR("%s: couldn't inc era tree root", __func__);
 		dm_sm_dec_block(md->sm, md->writeset_tree_root);
+		location = dm_block_location(clone);
 		dm_tm_unlock(md->tm, clone);
+		dm_sm_dec_block(md->sm, location);
 		return r;
 	}
 
-- 
2.25.1

