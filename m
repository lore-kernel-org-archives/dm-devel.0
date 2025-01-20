Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC5B1922EF
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 08:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737361088; cv=none; b=Fnk7kepsvLVDoE8QU0NG5xRBbfl0oDGlC0RLDlSI98u+lFeb5HQ2kO+d1PGvPdcj/EsJ89eKTRTSh9jX0owCVVzgDmwvSBNfn9gOHH7jeLtDct2uSK7Ys997oj4l9O9nIQMVoIM7CQAqDG1QEgBGHbUKxaWXxQD4bz7Cp5erlNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737361088; c=relaxed/simple;
	bh=SrsV0BIzupffZv9JwAAcNXAZtABo58x4zFpcAkGh8gA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=djR8qzI75tSYxvfbaUD6XP65WhP88/mvkTJaqY32RVuYODZNjim4ddeTYRhc9NNXlLlBW5DRHxBoL65TjL0hKv5qD2EQ2Fx+gdCH6yROhC3L+h2li5XtjSBgVEqRCf551Bf6p5sSgNTs6IStfjyDIjYr/UCjgKlNRwsVK2fJu4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Yc39X2YpWz4f3jXl
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E34E61A1320
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgB321+kBo5n8sHjBQ--.22840S6;
	Mon, 20 Jan 2025 16:17:56 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	houtao1@huawei.com
Subject: [PATCH 2/6] dm-crypt: fully initialize clone->bi_iter in crypt_alloc_buffer()
Date: Mon, 20 Jan 2025 16:29:47 +0800
Message-Id: <20250120082951.1423804-3-houtao@huaweicloud.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20250120082951.1423804-1-houtao@huaweicloud.com>
References: <20250120082951.1423804-1-houtao@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB321+kBo5n8sHjBQ--.22840S6
X-Coremail-Antispam: 1UD129KBjvJXoW7uw4kKry7tryUCr15Cw4kZwb_yoW5JF1xpF
	4a9r9ayrWrJr4Yg34DK3W8ua4Fvry8Wry5CrWUW3Z5JF12grykXF47J3yFvF1UAF9xuFya
	qF4vya4fZry7ZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Kb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU2FApUUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/

From: Hou Tao <houtao1@huawei.com>

Both kcryptd_io_read() and kcryptd_crypt_write_convert() will invoke
crypt_alloc_buffer() to allocate a new bio. Both of these two callers
initialize bi_iter.bi_sector for the new bio separatedly after
crypt_alloc_buffer() returns. However, kcryptd_crypt_write_convert()
will copy the bi_iter of the new bio into ctx.iter_out or ctx.iter_in.
Although it doesn't incur any harm now, it is better to fully initialize
bi_iter before it is used.

Therefore, initialize bi_iter.bi_sector in crypt_alloc_buffer() instead.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm-crypt.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 424c8fc3f0ada..551c934bfc501 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1719,6 +1719,7 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 	clone->bi_private = io;
 	clone->bi_end_io = crypt_endio;
 	clone->bi_ioprio = io->base_bio->bi_ioprio;
+	clone->bi_iter.bi_sector = cc->start + io->sector;
 
 	remaining_size = size;
 
@@ -1909,7 +1910,6 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 			crypt_dec_pending(io);
 			return 1;
 		}
-		clone->bi_iter.bi_sector = cc->start + io->sector;
 		crypt_convert_init(cc, &io->ctx, clone, clone, io->sector);
 		io->saved_bi_iter = clone->bi_iter;
 		dm_submit_bio_remap(io->base_bio, clone);
@@ -1925,13 +1925,13 @@ static int kcryptd_io_read(struct dm_crypt_io *io, gfp_t gfp)
 	clone = bio_alloc_clone(cc->dev->bdev, io->base_bio, gfp, &cc->bs);
 	if (!clone)
 		return 1;
+
+	clone->bi_iter.bi_sector = cc->start + io->sector;
 	clone->bi_private = io;
 	clone->bi_end_io = crypt_endio;
 
 	crypt_inc_pending(io);
 
-	clone->bi_iter.bi_sector = cc->start + io->sector;
-
 	if (dm_crypt_integrity_io_alloc(io, clone)) {
 		crypt_dec_pending(io);
 		bio_put(clone);
@@ -2039,8 +2039,6 @@ static void kcryptd_crypt_write_io_submit(struct dm_crypt_io *io, int async)
 	/* crypt_convert should have filled the clone bio */
 	BUG_ON(io->ctx.iter_out.bi_size);
 
-	clone->bi_iter.bi_sector = cc->start + io->sector;
-
 	if ((likely(!async) && test_bit(DM_CRYPT_NO_OFFLOAD, &cc->flags)) ||
 	    test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags)) {
 		dm_submit_bio_remap(io->base_bio, clone);
-- 
2.29.2

