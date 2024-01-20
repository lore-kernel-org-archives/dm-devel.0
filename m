Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776FBD52D
	for <dm-devel@lists.linux.dev>; Sat, 20 Jan 2024 10:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705747283; cv=none; b=LzNZlTzulTUOfvUaf3GZqZpgC1a0WJUmLgzRHaR0g2Od2g5Pyz4spvc0VKAxjWA56UNBmOGbCaedG4RWYdjH8KSOPStl6L47HmCfe74CkpghbaYHLDg0cmN2NJrMTGNZWLAxCCi0tfaagcvpttwiiqL/x3TeOkK2mmWOH6WDDi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705747283; c=relaxed/simple;
	bh=3MODqV2PUrLDsdNPK/NCVS5UAxs9MVyQ33m5klLn2q8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FZM8Z51B3K1ptbbM4teBW93j5/ECKyj7Xm9c27uN9VXiYRtKZYrBGn0UEgbz7cK+QZ0ThoAH+lGxjOg/18SXYWJCdOSOvia9fXtlrf0jP5AZsaB+3FX+vTU1s0b+Xyw7nncyM/QY9flcG+VzKd1FC2RJoTnTy7voQPFNGzO/Gaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4THChD1Jbdz4f3jqs
	for <dm-devel@lists.linux.dev>; Sat, 20 Jan 2024 18:41:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6A4481A09F2
	for <dm-devel@lists.linux.dev>; Sat, 20 Jan 2024 18:41:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgAn+RFKo6tlY4mmBQ--.38494S8;
	Sat, 20 Jan 2024 18:41:18 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	msnitzer@redhat.com,
	heinzm@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC 4/5] md: revert commit fa2bbff7b0b4 ("md: synchronize flush io with array reconfiguration") for dm-raid
Date: Sat, 20 Jan 2024 18:37:33 +0800
Message-Id: <20240120103734.4155446-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240120103734.4155446-1-yukuai1@huaweicloud.com>
References: <20240120103734.4155446-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn+RFKo6tlY4mmBQ--.38494S8
X-Coremail-Antispam: 1UD129KBjvJXoW7WF47JrW5tr47GFyrWryUWrg_yoW8Xw4Upa
	yxXas8Ar4kXF98Gw4UJF4kXFyY9a4ktFWkKFW3Zw1jyF17Wr1kWw1akry8Xrnxur1fAw4D
	Zw4DJr1UJa4jkrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQSdkU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

This commit is used to fix a problem for md/raid, due to rdev lifetime
in conf is different from the array. However, on the one hand, the
management of rdev is completely different from dm-raid; on the other
hand, this commit breaks dm-raid and the test shell/integrity-caching.sh
will hang.

The root cause of the hang is still not clear yet, however, let's revert
the commit for dm-raid to prevent regression first. We can decide what
to do after figuring out the root cause.

Fixes: fa2bbff7b0b4 ("md: synchronize flush io with array reconfiguration")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ba45c7be3dbe..7db749ba7e60 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -544,7 +544,8 @@ static void md_end_flush(struct bio *bio)
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
 		/* The pair is percpu_ref_get() from md_flush_request() */
-		percpu_ref_put(&mddev->active_io);
+		if (mddev->gendisk)
+			percpu_ref_put(&mddev->active_io);
 
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
@@ -640,7 +641,8 @@ bool md_flush_request(struct mddev *mddev, struct bio *bio)
 		 * concurrently.
 		 */
 		WARN_ON(percpu_ref_is_zero(&mddev->active_io));
-		percpu_ref_get(&mddev->active_io);
+		if (mddev->gendisk)
+			percpu_ref_get(&mddev->active_io);
 		mddev->flush_bio = bio;
 		bio = NULL;
 	}
-- 
2.39.2

