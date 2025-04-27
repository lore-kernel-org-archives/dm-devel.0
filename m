Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0BF1F3BAC
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 08:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745743033; cv=none; b=sFX5VqkNSZnHnC807K4WhIlBICNiXn0dHFDwTHO4TDoK88yUujufoq9nX9/wxjucw+jkm9pCkn8w3E13IXiw8jL17mu7CYU8QpzjW1gZO5FRERiJcF7x6EfUhT8PLWVKVqyIMrtYpBKC0BTy+8awbt1OVnl6b6Co9asobgh5ZSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745743033; c=relaxed/simple;
	bh=Fy+XrpR+XQNXmNL2PJU2JswxEOnS0jPUJGAsgpm1quQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cCpMQGNE2cEwXc0Z+XFVc8anWjxg3MWH4+NljBNztiPirHGjH7uRC0gPtMvRwPxaSytEOUZN0L3+2LGZIJZShhqQnltLes6P0lBdsjTqmXh7lKuTHkDhdHAlCPPgrzrSYg+1L2IAnNyLyexOgD1EvMpPP9/S1NMj/Wljvblph64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zlg0p5Bl7z4f3lDK
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 16:36:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 5B6971A18E8
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 16:37:08 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDHGsWx7A1oOv4xKg--.7274S5;
	Sun, 27 Apr 2025 16:37:08 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: hch@infradead.org,
	axboe@kernel.dk,
	xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	cl@linux.com,
	nadav.amit@gmail.com,
	ubizjak@gmail.com,
	akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 1/9] blk-mq: remove blk_mq_in_flight()
Date: Sun, 27 Apr 2025 16:29:20 +0800
Message-Id: <20250427082928.131295-2-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250427082928.131295-1-yukuai1@huaweicloud.com>
References: <20250427082928.131295-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDHGsWx7A1oOv4xKg--.7274S5
X-Coremail-Antispam: 1UD129KBjvJXoW7KFyrKrW7Wry8ArW3Kw4kZwb_yoW8Jw4UpF
	W5Gan8CrW2gr18uFy8tanrX3Wayws8KryxAwsxAry5tr18Kr13ZF18Zr4kZr4SvrZ3uFZr
	uFs0yFy7CF10g37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmvb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I
	0E8cxan2IY04v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCa
	FVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_Jr
	Wlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j
	6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUv
	cSsGvfC2KfnxnUUI43ZEXa7sRMv31JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

It's not used and can be removed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/blk-mq.c | 10 ----------
 block/blk-mq.h |  2 --
 2 files changed, 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index c2697db59109..301dbd3e1743 100644
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
index 3011a78cf16a..a23d5812d08f 100644
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

