Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2B0192B8F
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 08:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737361088; cv=none; b=DZiYc/gfQr/7vClW2qY8shEPqX108bix6s11HNcezB895MVnkzmEImWFDFzH/8SvUn2eAd4mwX19/TW7FUgbMwrtH6fkKUbYnYSBgokfumsI+1/FUBa35hipT3TdJcyCMxepZyxN228eH7f1El0RvcyQ33KR+dEscq+3WyKrWns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737361088; c=relaxed/simple;
	bh=Ob2SdWxGrUMRjy3ma62dPMHrK7w9BBPUyA/ur+6BmWw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V4tdZYjhtdIicauN+uedOfMctHPKbjv5sNBL/JOHMS2MNj53/Q3wRTfHIbplYenMr6NfQWB9yX/T65gc+OycF1KxOTZrCEAxxhYzFtC6Rzx/C3iKS3GvUAIIPooQLkUMsZ8gtNPfIcucuvM3VtgA1b77esH2K4pDKA/XzX+McRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Yc39Y2zH6z4f3jXT
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F21421A1725
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgB321+kBo5n8sHjBQ--.22840S9;
	Mon, 20 Jan 2025 16:17:57 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	houtao1@huawei.com
Subject: [PATCH 5/6] dm-crypt: don't initialize cc_sector again
Date: Mon, 20 Jan 2025 16:29:50 +0800
Message-Id: <20250120082951.1423804-6-houtao@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgB321+kBo5n8sHjBQ--.22840S9
X-Coremail-Antispam: 1UD129KBjvdXoW7JrykKw15Zw45Ar1rCr15Jwb_yoW3uwc_uF
	y5urZ3Xr48GF1vkFn0yr43Zr90vF4F9ryxuFyfKF13Zr93X393ZF1j9F45ur1UCrW7AF98
	Cr47Jry7Aw12qjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfxYFVCjjxCrM7AC8VAFwI0_Wr0E3s1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l82xGYIkIc2x26280x7IE14v26r126s
	0DM28IrcIa0xkI8VCY1x0267AKxVW5JVCq3wA2ocxC64kIII0Yj41l84x0c7CEw4AK67xG
	Y2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14
	v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAF
	wI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2
	WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkE
	bVWUJVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UGJP_UUUUU=
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/

From: Hou Tao <houtao1@huawei.com>

For aead_recheck case, cc_sector has already been initialized in
crypt_convert_init() when trying to re-read the read. Therefore, remove
the duplicated initialization.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm-crypt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 8cee6b660e90d..8b15f57af36a9 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2211,7 +2211,6 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 	crypt_inc_pending(io);
 
 	if (io->ctx.aead_recheck) {
-		io->ctx.cc_sector = io->sector + cc->iv_offset;
 		r = crypt_convert(cc, &io->ctx,
 				  test_bit(DM_CRYPT_NO_READ_WORKQUEUE, &cc->flags), true);
 	} else {
-- 
2.29.2

