Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458CE280017
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 12:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746536241; cv=none; b=byUrnpi2rH/MfVkfDLsSbPF7f0B7pcctE/oVozPttif3V1AtwHkQWdVVICjcTLpY8f4Ds6qtICXPM0WbGI1MtqAHpMKzzb0TG7vnds3syYE2sp4bRbVgok9dKAd5OV8bNmtGOyi3LGgNw2kwCLdUDwxU2BehvXbshlclaAUhLOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746536241; c=relaxed/simple;
	bh=dubRGQ41s/YBbBIHyAC9Um1h25oGLsq+DX0KW1xvEfk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iye5kPvHHrbHDWIM2DqIikKPGv2YlEmSoQZpfhM6EFa7uZ6dGRsfaqAyUl3Uwld+oGbE23tKDTOrNZmPO9gO1/4TdxvYX3A7UTPegZG59nukHmAGp4GgHVXUOS7M6IQEJycU2IaP8DMBkydHLidgOLKvEjonzrKaSRmD/MpS9Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ZsJMK4xJgzKHMgl
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:57:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7877D1A18E6
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:57:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl8pBxpoilNvLg--.37994S6;
	Tue, 06 May 2025 20:57:16 +0800 (CST)
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
Subject: [PATCH v3 3/9] block: WARN if bdev inflight counter is negative
Date: Tue,  6 May 2025 20:48:56 +0800
Message-Id: <20250506124903.2540268-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506124903.2540268-1-yukuai1@huaweicloud.com>
References: <20250506124658.2537886-1-yukuai1@huaweicloud.com>
 <20250506124903.2540268-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl8pBxpoilNvLg--.37994S6
X-Coremail-Antispam: 1UD129KBjvdXoWrtF18GF48Xr1fKw15AFy3CFg_yoWfuFc_GF
	92v34UZw15JrZxArn8ZF4YvrWv9w18XFZxJFy7tF9xGr4UXr9Igr1qyws8JrZ8Xa98KFyS
	yF9rZF1jyr9IqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbkAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXwA2048vs2IY02
	0Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xv
	wVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j
	6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7
	AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE
	2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRRCJPDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Which means there is a bug for related bio-based disk driver, or blk-mq
for rq-based disk, it's better not to hide the bug.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/genhd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index f671d9ee00c4..d158c25237b6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -136,9 +136,9 @@ static void part_in_flight_rw(struct block_device *part,
 		inflight[0] += part_stat_local_read_cpu(part, in_flight[0], cpu);
 		inflight[1] += part_stat_local_read_cpu(part, in_flight[1], cpu);
 	}
-	if ((int)inflight[0] < 0)
+	if (WARN_ON_ONCE((int)inflight[0] < 0))
 		inflight[0] = 0;
-	if ((int)inflight[1] < 0)
+	if (WARN_ON_ONCE((int)inflight[1] < 0))
 		inflight[1] = 0;
 }
 
-- 
2.39.2

