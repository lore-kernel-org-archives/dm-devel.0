Received: from m16.mail.126.com (m16.mail.126.com [117.135.210.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7DC2DF3DA
	for <dm-devel@lists.linux.dev>; Sat, 11 Jul 2026 10:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783764382; cv=none; b=dAuPvu64l//yJ2JCcnMcIxMDUld3mmdHhtRZPNJJZF0LS4qxwAX2CJ0x2c673fLXANaW2qlN4eVhdfyf+PMG9haouAYV4Q4jszRqpsf74ZILYFlqXj6wVTamr9niBKji+4TzHX5IEnLjpRtfKFjyaNg/7iT1qltga9s6W0oMD0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783764382; c=relaxed/simple;
	bh=YRWY2l0mkRmrRt3rjfZMoLCj/5G52iPky2Dkh6MsXB0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NeeZETPYEAWD/XYw6viOxiS7ZHx/ErELKbRnMOZEXD1RkPhBlX/WoZO8CRyyqGiX3M6ZkDLCm/0t7mJJfKRcaz+Tqzf4bdCntJ2xsrWm9r9wmpX4/2eBuBPNq1uni8oZy4gfUJn5XW8mch6Adk3yCCJETC/LM5SSWL32KvJ+Rlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com; spf=pass smtp.mailfrom=126.com; dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b=aPGCvFkM; arc=none smtp.client-ip=117.135.210.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=126.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=126.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.b="aPGCvFkM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=h2
	nToSbHKBQZACrxjxyaVN+GI3bXXec2Ra3NMx0+bF0=; b=aPGCvFkMyH01mSbuQp
	kZhXfMlEsTSixvL9MbaOtahUF6NxgORJ8rtJ66BqyP1vEMSVnfcQNGATiFwjx58E
	r+F9eQf2c/hsSHvg0jslmO0IsLoMspeUEx6vWg1UwowMl4RULfTFK3+xjn9rAh4h
	1PW4oyMV5zn5CoimrR/Ebrulw=
Received: from LAPTOP-N9A9U1FG.lan (unknown [])
	by gzsmtp4 (Coremail) with SMTP id PykvCgD3f2FqFVJqlOIdCw--.28673S4;
	Sat, 11 Jul 2026 18:05:56 +0800 (CST)
From: Genjian <zhanggenjian@126.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	ejt@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Genjian Zhang <zhanggenjian@kylinos.cn>
Subject: [PATCH] dm thin metadata: fix superblock refcount leak on snapshot shadow failure
Date: Sat, 11 Jul 2026 18:05:26 +0800
Message-ID: <20260711100526.835027-1-zhanggenjian@126.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PykvCgD3f2FqFVJqlOIdCw--.28673S4
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFWrCF1ftw48Gr1kZFyftFb_yoWkArc_Wr
	45XFWIqw1DCr4Yvw4xXws2vryIyr4Fgw4UWayjv3Wava4kXF4akry3CrZrtrn5Z3y5t34q
	kr4UZFyrJryxJjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU19Xo3UUUUU==
X-CM-SenderInfo: x2kd0wxjhqyxldq6ij2wof0z/xtbBtASVFGpSFYQbPAAA3-

From: Genjian Zhang <zhanggenjian@kylinos.cn>

__reserve_metadata_snap() increments THIN_SUPERBLOCK_LOCATION in the
metadata space map before shadowing it. When dm_tm_shadow_block()
fails, a reference is leaked in the metadata space map.

Fix by adding the missing dm_sm_dec_block().

Fixes: cc8394d86f04 ("dm thin: provide userspace access to pool metadata")
Signed-off-by: Genjian Zhang <zhanggenjian@kylinos.cn>
---
 drivers/md/dm-thin-metadata.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index b6a2d2081a24..b194fb57d158 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -1353,8 +1353,10 @@ static int __reserve_metadata_snap(struct dm_pool_metadata *pmd)
 	dm_sm_inc_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 	r = dm_tm_shadow_block(pmd->tm, THIN_SUPERBLOCK_LOCATION,
 			       &sb_validator, &copy, &inc);
-	if (r)
+	if (r) {
+		dm_sm_dec_block(pmd->metadata_sm, THIN_SUPERBLOCK_LOCATION);
 		return r;
+	}
 
 	BUG_ON(!inc);
 
-- 
2.43.0

