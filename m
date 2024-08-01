Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BE413D520
	for <dm-devel@lists.linux.dev>; Thu,  1 Aug 2024 13:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722519201; cv=none; b=L3HV7dTqYzh11UBGK6ZgNodvCNxyjmtCprQCZHk9bPjo4YVQkQSDdFSabH72HdlMSpM+9/4RgcbMrreUttoPjvWc9TaxDEkO8X3kjMXiR5s/Z9cAtS2+EYQFlX686YyywTXJ+qma0N4J4OgBBbybLl5A0dG+vlOKe+vMjUtOBzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722519201; c=relaxed/simple;
	bh=r+zCY4kjPAvZlcX/8DIgJ2jyLbAsV7UxE2pW2fdp9Jk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=be+MrnHZ5sixzgEVJCguguqfdbqvFWKmy61NY+QKfHjjMZHriC9vVer3gflQZO/E22mZnGqk1tPl8S+a0Q4R/6ZwQ1CY//0oPrqPkfTOdruDDzfkp/mBMaoEfjXYgk3eDlJb1nBzaJJloQQm0ajL77OCzOlSe6V2PrmsY9EhYLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4WZVCN0ZLfzyP8m;
	Thu,  1 Aug 2024 21:28:16 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id A2C3C18005F;
	Thu,  1 Aug 2024 21:33:15 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 1 Aug
 2024 21:33:15 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<dlemoal@kernel.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>
Subject: [PATCH -next] dm: Remove unused declaration dm_get_rq_mapinfo()
Date: Thu, 1 Aug 2024 21:31:21 +0800
Message-ID: <20240801133121.3021871-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Commit ae6ad75e5c3c ("dm: remove unused dm_get_rq_mapinfo()")
removed the implementation but leave declaration.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 include/linux/device-mapper.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 53ca3a913d06..8321f65897f3 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -524,7 +524,6 @@ int dm_post_suspending(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned int n_sectors);
 void dm_submit_bio_remap(struct bio *clone, struct bio *tgt_clone);
-union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 #ifdef CONFIG_BLK_DEV_ZONED
 struct dm_report_zones_args {
-- 
2.34.1

