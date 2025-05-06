Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734E428000C
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 12:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746536240; cv=none; b=SLQAS7wFcNtlB9eHmtUkUZ5W/uYgMm+EQ8/dwG3mmrDAq/1qCSbGRoaJVOr57eI+rsH1VaVPvcOuk21lUr/vrBL8CIsYY2YykPJ5LB6giPRLk118A9wJUUI7A4HuiyDlOKI65F/0CX+1auaRsUm2yaj9H0AJBv2bda+34rv5hNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746536240; c=relaxed/simple;
	bh=saEcFj+KXFIN8lSpRxf00Xv6969suwf4SqX88dg2bPc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=alddMlzJ1ofqSKHvcJtQvxMdZk0FjJ5mtkecrQGDiYUMiZW6m9jwmjWO4nnSjvG9TcA+5U5k94zY+IaAWuO0s6s3sPCTnwn4urSlyYrwZgd/6OVPGda2wvA9TRjzTE5EFtd7GU/LIjahYq1SkmTzYV+8z7vORCBPCZ17C8w5Qh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ZsJMH5qF6zYQtLh
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:57:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 31C921A018D
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:57:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl8pBxpoilNvLg--.37994S4;
	Tue, 06 May 2025 20:57:14 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	song@kernel.org,
	hch@lst.de,
	john.g.garry@oracle.com,
	hare@suse.de,
	xni@redhat.com,
	pmenzel@molgen.mpg.de
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v3 1/9] blk-mq: remove blk_mq_in_flight()
Date: Tue,  6 May 2025 20:48:54 +0800
Message-Id: <20250506124903.2540268-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506124658.2537886-1-yukuai1@huaweicloud.com>
References: <20250506124658.2537886-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl8pBxpoilNvLg--.37994S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ary7AFykKrW3Ww1xWw17KFg_yoW8Xw18pF
	W3Ga15CrW2gr18uFyxtanxXayakwsrKryxXan3A345Kr18Kry3ZF10qr4kXrZYvrZ3AFsr
	uF1ayFy8GF18K37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9F14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcS
	sGvfC2KfnxnUUI43ZEXa7sRRKZX5UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

After commit 7be835694dae ("block: fix that util can be greater than
100%"), it's not used and can be removed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-mq.c | 10 ----------
 block/blk-mq.h |  2 --
 2 files changed, 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 83c651a7facd..45989960a89d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -101,16 +101,6 @@ static bool blk_mq_check_inflight(struct request *rq, void *priv)
 	return true;
 }
 
-unsigned int blk_mq_in_flight(struct request_queue *q,
-		struct block_device *part)
-{
-	struct mq_inflight mi = { .part = part };
-
-	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
-
-	return mi.inflight[0] + mi.inflight[1];
-}
-
 void blk_mq_in_flight_rw(struct request_queue *q, struct block_device *part,
 		unsigned int inflight[2])
 {
diff --git a/block/blk-mq.h b/block/blk-mq.h
index d15ff1e130c8..eeac0d47c878 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -246,8 +246,6 @@ static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
 	return hctx->nr_ctx && hctx->tags;
 }
 
-unsigned int blk_mq_in_flight(struct request_queue *q,
-		struct block_device *part);
 void blk_mq_in_flight_rw(struct request_queue *q, struct block_device *part,
 		unsigned int inflight[2]);
 
-- 
2.39.2

