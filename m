Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F19D313558
	for <dm-devel@lists.linux.dev>; Fri,  6 Mar 2026 08:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772784194; cv=none; b=POEiSVm+5hhFoctPvtsFiDWqIN/FCfrdfZJJgxMvzRSwMhjkhxN0JwRtgzh15XoNFr6a0pUDORRaoL515MWkjD5dpbpwtWWkB9ICAiPNwIyhyi+ujk1UmwcAJnJXxRdcMXKKxyFWoNB48V0W6I/4ZwMZvzOjzE/dsVekFL0LDC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772784194; c=relaxed/simple;
	bh=1SHV9W0PtH/lXfkZ3zLo7CrgjsYYiCU3lo5A8Rvnx/g=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZzCjWwAaCS+HsU35g2uY0hf0SUzvHtJOJod/6WtQmvP1fchDLwDUJOig0loRDX92OBPLeYNL2T2zW+anmKr+PY1eR6Yvt0nKt9sB6+xiTgJ+M2cCkE0hEx0l5WRB2NupXyITEXfojZ0iNN2uvFo9i1h6G1UbsOcGeMMN00hKBkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=lM4vdunG; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="lM4vdunG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=rB
	SAR8kg9yv8L7hymQLozckIVNDzn4HqODuktQAHXU8=; b=lM4vdunG4KPR/EKMGU
	tJqgvYqMmCms173foO5FWZHbcDT9Ykg/tNvSWo8ksqYYRIHCnUXYTOboXFhphf4v
	FS4PPQ+HqFvcwjIdV11NibI2hnzdIhPYsL80+dsyKsiV7sfr4Eqi4SDvGi+f6RyN
	cuW+fAESp7zVxVlfkCnOND/LQ=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgAH_OAxiqppjgBfRg--.24S2;
	Fri, 06 Mar 2026 16:02:59 +0800 (CST)
From: luoqing <l1138897701@163.com>
To: agk@redhat.com
Cc: snitzer@kernel.org,
	dm-devel@lists.linux.dev,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dm-bufio: Use struct_size() helper in kmalloc()
Date: Fri,  6 Mar 2026 16:02:57 +0800
Message-Id: <20260306080257.1268206-1-l1138897701@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgAH_OAxiqppjgBfRg--.24S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZw18tw4DZFyUXw43XF4DCFg_yoWfAFc_u3
	98Zr9rWrn8Ca1FkrnrGrW7Aryvyw1DurWfuFnxtF9xW3s8JanxCa4UZr1aqF1kuFyUCrnI
	yr9rJryrJrnrKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUbvtCDUUUUU==
X-CM-SenderInfo: jorrjmiyzxliqr6rljoofrz/xtbC3ROz92mqijMaRgAA3s

From: luoqing <luoqing@kylinos.cn>

Make use of the struct_size() helper instead of an open-coded version,
in order to avoid any potential type mistakes or integer overflows that,
in the worst scenario, could lead to heap overflows.

Signed-off-by: luoqing <luoqing@kylinos.cn>
---
 drivers/md/dm-bufio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 60f7badec91f..f8a6b423b4ea 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2511,7 +2511,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 	}
 
 	num_locks = dm_num_hash_locks();
-	c = kzalloc(sizeof(*c) + (num_locks * sizeof(struct buffer_tree)), GFP_KERNEL);
+	c = kzalloc(struct_size(c, buffer_tree, num_locks), GFP_KERNEL);
 	if (!c) {
 		r = -ENOMEM;
 		goto bad_client;
-- 
2.25.1

