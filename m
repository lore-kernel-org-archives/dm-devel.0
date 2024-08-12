Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A59A1366
	for <dm-devel@lists.linux.dev>; Mon, 12 Aug 2024 12:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723464366; cv=none; b=srvWVzI/phF1MxT1QrSiitCYgX4aw3Q/sqku9gsC1bgDUbYq42+M92R5+xLKYbZzGoW5jjQKdyzUTN94Ym20v+ZnWjadx4Gv9X2QK/owmRhGo4uDYHketyXsBM1dB2HNBoDR7BuqglszsMvPe0HJQYEOOQUFTRS2YVofe6lJIpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723464366; c=relaxed/simple;
	bh=XxOEN2LvroViniy7GGcPq9f/iF97UZftqyqwUVF6hl8=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kVQW95XsrRf22BLLweSffU3iRtBQFniOfoWjh5JU0QMQmDP3XMRnWfbybJHyO9RlF6PgiFiHz/exO5VOqYCTNcA85PUQwIAwSeqJ5HR+UD37thAgvLvYkt+JiEUVL3eJxhkw7bq+Jd9/DXbE1YOUt8A0n8ZrRsqIlq5Ox4Jfzxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4WjCll2tvyz1j6Y2;
	Mon, 12 Aug 2024 20:01:07 +0800 (CST)
Received: from kwepemf500003.china.huawei.com (unknown [7.202.181.241])
	by mail.maildlp.com (Postfix) with ESMTPS id B145D18001B;
	Mon, 12 Aug 2024 20:05:56 +0800 (CST)
Received: from huawei.com (10.175.112.208) by kwepemf500003.china.huawei.com
 (7.202.181.241) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 12 Aug
 2024 20:05:56 +0800
From: Zhang Zekun <zhangzekun11@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<dm-devel@lists.linux.dev>
CC: <zhangzekun11@huawei.com>
Subject: [PATCH] dm: Remove unused declaration and empty definition "dm_zone_map_bio"
Date: Mon, 12 Aug 2024 19:53:09 +0800
Message-ID: <20240812115309.113917-1-zhangzekun11@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemf500003.china.huawei.com (7.202.181.241)

dm_zone_map_bio() has beed removed since commit f211268ed1f9 ("dm: Use
the block layer zone append emulation"), remain the declaration unused in
header files. So, let's remove this unused declaration and empty
definition.

Signed-off-by: Zhang Zekun <zhangzekun11@huawei.com>
---
 drivers/md/dm.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index cc466ad5cb1d..8ad782249af8 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -109,7 +109,6 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone);
 int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data);
 bool dm_is_zone_write(struct mapped_device *md, struct bio *bio);
-int dm_zone_map_bio(struct dm_target_io *io);
 int dm_zone_get_reset_bitmap(struct mapped_device *md, struct dm_table *t,
 			     sector_t sector, unsigned int nr_zones,
 			     unsigned long *need_reset);
@@ -119,10 +118,6 @@ static inline bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
 {
 	return false;
 }
-static inline int dm_zone_map_bio(struct dm_target_io *tio)
-{
-	return DM_MAPIO_KILL;
-}
 #endif
 
 /*
-- 
2.17.1

