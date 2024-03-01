Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F316A330
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 08:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709283293; cv=none; b=dR2A+3iWCYICFi7ehGMTOy/8AvlHzq8Wx8bXUWzhS7UITc73dA0qqxgGwkJgMGkyenSNEK+Ohd1YFcQo65iWNhI3Nyp93Egap6xxYj6TO3AJRtrF7Uc5aEFItMvPJvHeYZu+iv/WU3lY3CoRFydrR0e40UGk+jQdJWbU16VpN+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709283293; c=relaxed/simple;
	bh=78R0hTFd1L1D+1TwAPXwdv5e5//ZSYxzJCbiOleQUrI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Cd0J3MaV3N16HGknafGqdKZFNiz08E9Lb2Uf4us+a2Fp9WhRFn+iaB7uEqECpxPh+6AGeFn1+lphlyrY1RkzfOL+OWJYTQSjaPm1J7X4AhXnfPaqOHFWoutLMWdSpkO78kSZSBDfM1qMSIcYZDrFiR7PIpYnOYX4a8+Bfx60klE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=DPiTcMdl; arc=none smtp.client-ip=115.124.30.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="DPiTcMdl"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1709283283; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=PMW1G5gR++CtOAeD29pBWv3v1d4NWeli+yzFyyvGrsg=;
	b=DPiTcMdlUctrzIEtRVwJhrqr5PrNyC1E4NZOkjmvnIXKkaEY0Z3IGChOs7Y5b954oKcJXM2ePNbPXa68KyJhvTaZM/+EAagDI0r8haGb4g0+dRlFxOgp83n1xmpwbxmm5QuCaq+mBQb+0bCTU4ZgzymuhX49nFKExXyQQ4Jxg5c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0W1azfxv_1709283281;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0W1azfxv_1709283281)
          by smtp.aliyun-inc.com;
          Fri, 01 Mar 2024 16:54:42 +0800
From: Yang Li <yang.lee@linux.alibaba.com>
To: msakai@redhat.com,
	dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Yang Li <yang.lee@linux.alibaba.com>
Subject: [PATCH -next] dm vdo: Remove unneeded semicolon
Date: Fri,  1 Mar 2024 16:54:40 +0800
Message-Id: <20240301085440.64541-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch removes the unnecessary semicolons at the end of the
for statements which cleans up the code and ensures consistency
with the rest of the kernel coding style.

Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/md/dm-vdo/block-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index 42ec3a252e73..4389df8c9271 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -2707,7 +2707,7 @@ void vdo_traverse_forest(struct block_map *map, vdo_entry_callback_fn callback,
 
 		cursor->waiter.callback = launch_cursor;
 		acquire_vio_from_pool(cursors->pool, &cursor->waiter);
-	};
+	}
 }
 
 /**
-- 
2.20.1.7.g153144c

