Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9470555897
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 02:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736388127; cv=none; b=XHDfOMEGB44RpR2pTMLUNakZbLnqReNg5/0lbxXU3JcoAQ1N0I6VHty3tH42DRNQ+dX3K4/Y2AaRbJD3+xcYPXMv2TcM9i3hHSs4Lbdp+zNTY+PPGB7bTLRRLGWXj/4STC9YcYMxGcvsYyFxrDynprmKyrXWwit7kTRZnGojT/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736388127; c=relaxed/simple;
	bh=QyRFyW5wC17u9UTxOc+cCccnlpjt1detXEIAG9tHC0w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IjlPSX26ISURWtyd6Hz+Pbei+/W3PgDlJHZRGbAN1OHcU0Mrp4oBOxVNAi88JwR4rRctYF1FIl0a6prfgHEhwRxOpKp6zKqmSJj9GyGuE3SyniQgfyRt3T2x9UE+bMdz4UEmHypnejvWDZ/jFx+hreAmOtDswn3ZlHtxb5+0YpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YT7Ls3pDcz4f3lCf
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 10:01:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E85781A06DD
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 10:02:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl8XLn9nqDrAAQ--.985S10;
	Thu, 09 Jan 2025 10:02:02 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.14 06/12] md/dm-raid: check if bitmap is registered in raid_ctr()
Date: Thu,  9 Jan 2025 09:56:58 +0800
Message-Id: <20250109015704.216128-7-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250109015704.216128-1-yukuai1@huaweicloud.com>
References: <20250109015704.216128-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl8XLn9nqDrAAQ--.985S10
X-Coremail-Antispam: 1UD129KBjvdXoW7XFyDJr43CrWkWr1xGF4kZwb_yoWfJrXEkw
	1Sqr97Xr45G3W3Cw4UtanYvrZYkw1kWrZ7uFWqvay3AF1ruryfKw409r98Wr47ZrZ3AFyr
	CFy7Kr4rZr9rZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbvAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY
	6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17
	CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r4j6ryUMIIF
	0xvE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VU1zpBDUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to support building md-bitmap as kernel module.

dm-raid should always enable bitmap and mdraid will try to load the module
automatically, just in case the module can't be loaded, for example,
user somehow remove the module file.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 0ca73b571c7d..c56c42503ca4 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3054,6 +3054,9 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (IS_ERR(rs))
 		return PTR_ERR(rs);
 
+	if (WARN_ON_ONCE(!md_bitmap_registered(&rs->md)))
+		goto bad;
+
 	r = parse_raid_params(rs, &as, num_raid_params);
 	if (r)
 		goto bad;
-- 
2.39.2

