Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28065280015
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 12:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746536241; cv=none; b=Gu6zF8W7u2PNfj3ABAvH9/pa6LT3AKeWBe0/dC4S0vn1dLOa0Rx4fvlU2DUUZ1FAOgcVGIe7vbHFSBiChuB9knlE7Ddtwx23IXuDILpvA0avIaeRPEC9lU8+Xss7uaLz2WZHUvHcz0HGIf+WVGiUB9ZGe2XRkI5DO+Ap2ecLVmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746536241; c=relaxed/simple;
	bh=ZoZGyy2ujKeJNBjtpyNvAj92ghOzTBMJqipLUBQTMBo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o9CJhJdELScCTDLSW/GOvGqXL69j1O0qBR567hM8QGYy6gEcjksZRld8CMJRaGMCZnnF/hoYr28HR+4cLXMcxRh5D3rVoMAFw1xgTOctlF/ULk0knMx/Z9d0ItneNZMBhO1N3cOh2OyciDKDjcVIeV8u3VJiSlEMMmEbAZ7bIJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZsJLq2Zy2z4f3jd1
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:56:51 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CCA2B1A018D
	for <dm-devel@lists.linux.dev>; Tue,  6 May 2025 20:57:15 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl8pBxpoilNvLg--.37994S5;
	Tue, 06 May 2025 20:57:15 +0800 (CST)
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
Subject: [PATCH v3 2/9] block: reuse part_in_flight_rw for part_in_flight
Date: Tue,  6 May 2025 20:48:55 +0800
Message-Id: <20250506124903.2540268-2-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgDXOl8pBxpoilNvLg--.37994S5
X-Coremail-Antispam: 1UD129KBjvfXoW3ZF18CFW7CrWfAFW5p5X_Gr4ruoWUZwsIq3
	WfJr4UuFWUG348CF93uws5Jw45CFyrZF1Duw1xJw1YvFyY9w4DK3Wrua4YkF9xXFWDZ3W3
	Cr47JF1kn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3AaLaJ3Uj
	IYCTnIWjp_UUUO47AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E
	3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r18M28IrcIa0xkI8VCY1x
	0267AKxVW8JVW5JwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xII
	jxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjc
	xK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IY
	c4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI
	0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY
	0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7
	CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l
	x2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14
	v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IY
	x2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z2
	80aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU
	0xZFpf9x0pR75rsUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

They are almost identical, to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

