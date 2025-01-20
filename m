Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD84119259D
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 08:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737361087; cv=none; b=YvsypWvDL1W0dKCDWRCuSN7s0gLTovTJYzyjMQlLlPyua8vAN8H0Ng5E8/RSj/ydw3PbiQEXt7BsCkY2L95uhBKH+Yf/1r5ZGLnBSLqZMA4bdeGD9XRQa345M7conaUW3I/aD86VM7YxHXieF9oCGeFHUV0fyjlcI0XWeL5Syhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737361087; c=relaxed/simple;
	bh=6ue9qDIovKeqk6Zty8GV1q069VtciY2yqTIXyRin/hc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ggGjCg5/kOZkRR0bRNAhfghRMhdPru5J/NtNcWw8KZdxAR1p1PWn3Gt11tpZVP0W95+ewREzPu6lCOMOY8FoPRY7Qi2OMhb1+vWBi5Yz4wWQILhN2YKsCkeOk1yVLcV4CBoutS+3fZ+ZXitW/jLZdlq8YssbwkgBscsQcPvnORc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yc39W3PYwz4f3jLJ
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 455531A1CCB
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgB321+kBo5n8sHjBQ--.22840S7;
	Mon, 20 Jan 2025 16:17:57 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	houtao1@huawei.com
Subject: [PATCH 3/6] dm-crypt: use bi_sector in bio when initialize integrity seed
Date: Mon, 20 Jan 2025 16:29:48 +0800
Message-Id: <20250120082951.1423804-4-houtao@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgB321+kBo5n8sHjBQ--.22840S7
X-Coremail-Antispam: 1UD129KBjvdXoW7Jw47Jw1rZw4UurWDCr18Grg_yoWDKrb_u3
	Za9FWrX34UGFn7tF1DAF4fZrZ2vF1Sgr1xuFyftFWfCr4fXws3Ar17WrsxAr1xZryxJF4Y
	kr9Fqw13Zw12gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbTkYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r1rM2
	8IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK
	021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r
	4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UJOzsUUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/

From: Hou Tao <houtao1@huawei.com>

bio->bi_iter.bi_sector has already been initialized when initialize the
integrity seed in dm_crypt_integrity_io_alloc(). There is no need to
calculate it again. Therefore, use the helper bip_set_seed() to
initialize the seed and pass bi_iter.bi_sector to it instead.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm-crypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 551c934bfc501..4634e2d850f21 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1187,7 +1187,7 @@ static int dm_crypt_integrity_io_alloc(struct dm_crypt_io *io, struct bio *bio)
 
 	tag_len = io->cc->tuple_size * (bio_sectors(bio) >> io->cc->sector_shift);
 
-	bip->bip_iter.bi_sector = io->cc->start + io->sector;
+	bip_set_seed(bip, bio->bi_iter.bi_sector);
 
 	ret = bio_integrity_add_page(bio, virt_to_page(io->integrity_metadata),
 				     tag_len, offset_in_page(io->integrity_metadata));
-- 
2.29.2

