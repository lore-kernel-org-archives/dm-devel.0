Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 390F114D449
	for <dm-devel@lists.linux.dev>; Sat, 31 Aug 2024 09:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725097192; cv=none; b=YmqzZ4M63Bvyv8+HT4J4SMejbMNETh3aGwM8jT/qdrK7lz4i0V7lVtYBkBEhbxxBYpaKN2tD7W5IRdvgYT3DsUNQ0IwXjmgW58yaOIjSL199/y49k2RixkzWYvujB9yu6VT9ye98NXAI8UUAAEqdt6AOTjwbuNTdCY9gRGdrfK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725097192; c=relaxed/simple;
	bh=gipIEoKM9BsdFl/oyeJh9k64a3AQyWuK1wn4jQST+oI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ClZj4vhQNruXV6COiwM8Nn+UUvwC+YR0GMXsgW9EpWqerGh55A3gBpb8D2e9ViyQk8JCZQXPXdXE/InNjeEPft+HgsB60MAwcwn8No2yQaWKha700N433TJ0XXohuZcfMdoUOl2pNUgR9j95BhuB0iRnKEWqWWf6XDff4rrT0Ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Wwqht3Rm9z14Hd1;
	Sat, 31 Aug 2024 17:38:54 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A78B18006C;
	Sat, 31 Aug 2024 17:39:46 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Sat, 31 Aug
 2024 17:39:46 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>
CC: <dm-devel@lists.linux.dev>, <lihongbo22@huawei.com>
Subject: [PATCH -next] dm integrity: Remove extra unlikely helper
Date: Sat, 31 Aug 2024 17:48:01 +0800
Message-ID: <20240831094801.4155666-1-lihongbo22@huawei.com>
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

In IS_ERR, the unlikely is used for the input parameter,
so these is no need to use it again outside.

Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
---
 drivers/md/dm-integrity.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 51e6964c1305..8306f8511078 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -2447,7 +2447,7 @@ static int dm_integrity_map_inline(struct dm_integrity_io *dio)
 	bio->bi_iter.bi_sector += ic->start + SB_SECTORS;
 
 	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);
-	if (unlikely(IS_ERR(bip))) {
+	if (IS_ERR(bip)) {
 		bio->bi_status = errno_to_blk_status(PTR_ERR(bip));
 		bio_endio(bio);
 		return DM_MAPIO_SUBMITTED;
@@ -2520,7 +2520,7 @@ static void dm_integrity_inline_recheck(struct work_struct *w)
 		}
 
 		bip = bio_integrity_alloc(outgoing_bio, GFP_NOIO, 1);
-		if (unlikely(IS_ERR(bip))) {
+		if (IS_ERR(bip)) {
 			bio_put(outgoing_bio);
 			bio->bi_status = errno_to_blk_status(PTR_ERR(bip));
 			bio_endio(bio);
-- 
2.34.1

