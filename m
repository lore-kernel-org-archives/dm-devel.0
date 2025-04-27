Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3895A2472BD
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 08:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745743033; cv=none; b=YaQmhC1/q41HovsyId0U/ii7qmuCLTQNYQmdiApFswYZpkZ8oVHOTjwD34hVIDb2U3Bd/MIZMEjl3AEqZD+y9CrDP/Cy3j2N+yvknqPhm/RnzSNI5Zz0drM+AfZ414osFVmCBjAyEmmr4TsUHLnz1dcBV1HOrsWhiRUSz+zxmuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745743033; c=relaxed/simple;
	bh=fXcNQwWqeVyBqzxcd5v2VPNaXfbyZPMYGJAkOljc/Ac=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FJTg+meg5Noj+tU5R36/eQ5W45j/24uJIcPz4XVpaPGLrAawtPlLqVEodJJu8dvR3XhajxVMwJ9uDZF01u3DCBc1xFSsqjBihQWgfGnZ78UYKdvEfbd4Kl/doQpby6sZdjUECbOJrKD73rRIoTYJEkTfKNKJ5d8sDLX5USzkpW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Zlg0r74SPz4f3jd4
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 16:36:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 1A2E01A1DF7
	for <dm-devel@lists.linux.dev>; Sun, 27 Apr 2025 16:37:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDHGsWx7A1oOv4xKg--.7274S6;
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
Subject: [PATCH v2 2/9] block: reuse part_in_flight_rw for part_in_flight
Date: Sun, 27 Apr 2025 16:29:21 +0800
Message-Id: <20250427082928.131295-3-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgDHGsWx7A1oOv4xKg--.7274S6
X-Coremail-Antispam: 1UD129KBjvJXoWrtFyUXryDCr48Xr1UGF43GFg_yoW8Jr48pr
	4SkasIyFWDGr1fur10qr4xXa4ftw4UK34xZ343A34ftF4UJFnxZr93Kwn2yrySvr97Zay5
	u34YyFy7GF1UZw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRNiSHDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

They are almost identical, to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 block/genhd.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index c2bd86cd09de..f671d9ee00c4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -125,21 +125,6 @@ static void part_stat_read_all(struct block_device *part,
 	}
 }
 
-unsigned int part_in_flight(struct block_device *part)
-{
-	unsigned int inflight = 0;
-	int cpu;
-
-	for_each_possible_cpu(cpu) {
-		inflight += part_stat_local_read_cpu(part, in_flight[0], cpu) +
-			    part_stat_local_read_cpu(part, in_flight[1], cpu);
-	}
-	if ((int)inflight < 0)
-		inflight = 0;
-
-	return inflight;
-}
-
 static void part_in_flight_rw(struct block_device *part,
 		unsigned int inflight[2])
 {
@@ -157,6 +142,15 @@ static void part_in_flight_rw(struct block_device *part,
 		inflight[1] = 0;
 }
 
+unsigned int part_in_flight(struct block_device *part)
+{
+	unsigned int inflight[2];
+
+	part_in_flight_rw(part, inflight);
+
+	return inflight[READ] + inflight[WRITE];
+}
+
 /*
  * Can be deleted altogether. Later.
  *
-- 
2.39.2

