Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1962570
	for <dm-devel@lists.linux.dev>; Mon,  2 Sep 2024 13:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725282185; cv=none; b=ouNo+wLXqMXgTYjd3URIET9CX3z6tCFDkzXKqfI2RIx+vTHhYA+cSld/Mh81R7Bsw5AwAyV2wcQVCglgv3PjdMi5HU/HS/153KW5oK2l+OsID6Xqf7IunacpzWDPGkPnhukJWyb0mOHk07ZsZP/JOCFFwI+KO5YPyDkwN096LN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725282185; c=relaxed/simple;
	bh=+BoqzAHHBBH4kUTYQM+k1ax+czqOYBfKnI9QTGSnVf0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=lRusp4ijjggMHxFoabnImgjQyv0teiNaLS1qO8cUF2xXETHRFfW6w/JK7FDZEnjZuIC10b4K+ehX/9BXxYlrwY/X6mHW2gaWzL3K7/ln2K/HLazdw3yBlzIaVSh0/nG4hYJAuae7ad+Wh1J/x+xDWjhhxvkCiqL7+HxVPkYCLyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Wy8575gVBz1xwnh;
	Mon,  2 Sep 2024 21:00:59 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id B47851400D4;
	Mon,  2 Sep 2024 21:02:59 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 2 Sep
 2024 21:02:59 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>
CC: <dm-devel@lists.linux.dev>, <lihongbo22@huawei.com>
Subject: [PATCH -next] dm: Make use of __assign_bit() API
Date: Mon, 2 Sep 2024 21:11:23 +0800
Message-ID: <20240902131123.3007226-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)

We have for some time the __assign_bit() API to replace
open coded
    if (foo)
        __set_bit(n, bar);
    else
        __clear_bit(n, bar);

Use this API to simplify the code. No functional change
intended.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 drivers/md/dm-clone-metadata.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/md/dm-clone-metadata.c b/drivers/md/dm-clone-metadata.c
index 2db84cd2202b..14c5c28d938b 100644
--- a/drivers/md/dm-clone-metadata.c
+++ b/drivers/md/dm-clone-metadata.c
@@ -530,10 +530,7 @@ static int __load_bitset_in_core(struct dm_clone_metadata *cmd)
 		return r;
 
 	for (i = 0; ; i++) {
-		if (dm_bitset_cursor_get_value(&c))
-			__set_bit(i, cmd->region_map);
-		else
-			__clear_bit(i, cmd->region_map);
+		__assign_bit(i, cmd->region_map, dm_bitset_cursor_get_value(&c));
 
 		if (i >= (cmd->nr_regions - 1))
 			break;
-- 
2.34.1

