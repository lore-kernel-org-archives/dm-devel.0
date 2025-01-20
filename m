Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A238918FC83
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 08:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737361088; cv=none; b=k/8rOgm2faR60SV51VCpmPt4GOYi3A0Cx3mxxdkJuhCt67UVwublIjeEMEfPYlD6Ytb7tWpzk6iRXS7N+7/GGI6C2ll9UmsxxKHM+lz6zns9KzMJBsIAEi7x/MFPu0ZsPpOA9FiDB3EKV/oYvf5Ry71hBVmZuYEzNkFyTNsYXb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737361088; c=relaxed/simple;
	bh=YfMmOCGMhoGHp4b+LHQA+P2KerjLM5aLDk1x/Dpt5I4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eHQsFe70S7AvA8vsY3koG5UHo6FWmHdg+Pbcv/ceZfJdcCbTwKARslfifoWHrWCf+NtLF3dMKEyuU0kMMYfRY2tJOf4UOUf5b2rYMwMR2v2bkdrU3mOLl/zyKBwwoqoWFIAVxcjOeF1cwUFY8JSVGpDYiKgg3KaVEcYJnBn8kzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yc39f1ZWNz4f3jss
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:42 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 98B971A1719
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgB321+kBo5n8sHjBQ--.22840S8;
	Mon, 20 Jan 2025 16:17:57 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	houtao1@huawei.com
Subject: [PATCH 4/6] dm-crypt: don't update io->sector after kcryptd_crypt_write_io_submit()
Date: Mon, 20 Jan 2025 16:29:49 +0800
Message-Id: <20250120082951.1423804-5-houtao@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgB321+kBo5n8sHjBQ--.22840S8
X-Coremail-Antispam: 1UD129KBjvJXoWxWw1DtFW8JFW8tF15CFWfKrg_yoW5WF43pF
	W5KFyfCF98Jr1F9F1DtFy8urySgryxGFW3Cr4UWw45Wr1SgrnYgFW2y3y0vr1UAFZ5Jrya
	vw4kAa15Z3ZrZFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB0b4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAV
	Cq3wA2048vs2IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0
	rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267
	AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E
	14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7
	xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Y
	z7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUrfOzUUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/

From: Hou Tao <houtao1@huawei.com>

The updates of io->sector are the leftovers when dm-crypt allocated
pages for partial write request. However, since commit cf2f1abfbd0db
("dm crypt: don't allocate pages for a partial request"), there is no
partial request anymore.

After the introduction of write request rb-tree, the updates of
io->sectors may interfere the insertion procedure, because ->sectors of
these write requests which have already been added in the rb-tree may be
changed during the insertion of new write request.

Fix it by removing these buggy updates of io->sectors. Considering these
updates only effect the write request rb-tree, the commit which
introduces the write request rb-tree is used as the fix tag.

Fixes: b3c5fd305249 ("dm crypt: sort writes")
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm-crypt.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 4634e2d850f21..8cee6b660e90d 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2090,7 +2090,6 @@ static void kcryptd_crypt_write_continue(struct work_struct *work)
 	struct crypt_config *cc = io->cc;
 	struct convert_context *ctx = &io->ctx;
 	int crypt_finished;
-	sector_t sector = io->sector;
 	blk_status_t r;
 
 	wait_for_completion(&ctx->restart);
@@ -2107,10 +2106,8 @@ static void kcryptd_crypt_write_continue(struct work_struct *work)
 	}
 
 	/* Encryption was already finished, submit io now */
-	if (crypt_finished) {
+	if (crypt_finished)
 		kcryptd_crypt_write_io_submit(io, 0);
-		io->sector = sector;
-	}
 
 	crypt_dec_pending(io);
 }
@@ -2121,14 +2118,13 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	struct convert_context *ctx = &io->ctx;
 	struct bio *clone;
 	int crypt_finished;
-	sector_t sector = io->sector;
 	blk_status_t r;
 
 	/*
 	 * Prevent io from disappearing until this function completes.
 	 */
 	crypt_inc_pending(io);
-	crypt_convert_init(cc, ctx, NULL, io->base_bio, sector);
+	crypt_convert_init(cc, ctx, NULL, io->base_bio, io->sector);
 
 	clone = crypt_alloc_buffer(io, io->base_bio->bi_iter.bi_size);
 	if (unlikely(!clone)) {
@@ -2145,8 +2141,6 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 		io->ctx.iter_in = clone->bi_iter;
 	}
 
-	sector += bio_sectors(clone);
-
 	crypt_inc_pending(io);
 	r = crypt_convert(cc, ctx,
 			  test_bit(DM_CRYPT_NO_WRITE_WORKQUEUE, &cc->flags), true);
@@ -2170,10 +2164,8 @@ static void kcryptd_crypt_write_convert(struct dm_crypt_io *io)
 	}
 
 	/* Encryption was already finished, submit io now */
-	if (crypt_finished) {
+	if (crypt_finished)
 		kcryptd_crypt_write_io_submit(io, 0);
-		io->sector = sector;
-	}
 
 dec:
 	crypt_dec_pending(io);
-- 
2.29.2

