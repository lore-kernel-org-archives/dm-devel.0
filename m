Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814536BB52
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 10:03:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709287390; cv=none; b=aMaWA6R0AoVeNpeNFEZ91VnVxdiDuPQCsHj9SeOMQTCR31wPwq+FLiUsHPOKeuEWSrqiB84BEuqOuNPVi7kzxyiQ5UgJkk+/s7RB8IAqRoi0PfCY4GjylOOVu/BnMncFa3RVAmUVqxIQZlnyM3JkemhEhJbxyOplK57RYkK0JLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709287390; c=relaxed/simple;
	bh=E5zo5NpUAL7fyD63lB0F+hEq8d50qyAXDY7Lyqsjrfg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mxjMzzVIZzyvBfZYwWgm4/TVcmnV3rncdAxzEFecn6/HpiP81Uh1E/z5msuFauuii8yzSyAPZpIsG9Oi+YHfGBcRHLHk6HY5VVSJ8+4NPR+1qcEYCTKbxhd1XeJRGwtoyparMbt9GmVrfl/Dwkl7n8at3oIPHKzA3Dbhq0dG9tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TmNv81yBjz4f3jJ2
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 18:03:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 8CC6B1A0172
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 18:03:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBHTp+FlqmBuFg--.36874S8;
	Fri, 01 Mar 2024 18:03:05 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: zkabelac@redhat.com,
	xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	heinzm@redhat.com,
	neilb@suse.de,
	jbrassow@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH -next 4/9] md: add a new helper reshape_interrupted()
Date: Fri,  1 Mar 2024 17:56:52 +0800
Message-Id: <20240301095657.662111-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240301095657.662111-1-yukuai1@huaweicloud.com>
References: <20240301095657.662111-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBHTp+FlqmBuFg--.36874S8
X-Coremail-Antispam: 1UD129KBjvdXoWrZr1fAF15Ar1kJr1DJryxZrb_yoWkuFcE9F
	48u343Gr17Za4rKF1qyw1avry3JFWkXw1DZFWSk347AFyUCr1fXrWrGr1Uuw48ZFZ8KF90
	kr4Uur1xJF4rKjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbq8FF20E14v26rWj6s0DM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUAVCq3wA2048vs2
	IY020Ec7CjxVAFwI0_Xr0E3s1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28E
	F7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUOBTY
	UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The helper will be used for dm-raid456 later to detect the case that
reshape can't make progress.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 09368517cc6c..b961c1b4ead7 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -570,6 +570,25 @@ static inline bool md_is_rdwr(struct mddev *mddev)
 	return (mddev->ro == MD_RDWR);
 }
 
+static inline bool reshape_interrupted(struct mddev *mddev)
+{
+	/* reshape never start */
+	if (mddev->reshape_position == MaxSector)
+		return false;
+
+	/* interrupted */
+	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
+		return true;
+
+	/* running reshape will be interrupted soon. */
+	if (test_bit(MD_RECOVERY_WAIT, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_INTR, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
+		return true;
+
+	return false;
+}
+
 static inline int __must_check mddev_lock(struct mddev *mddev)
 {
 	return mutex_lock_interruptible(&mddev->reconfig_mutex);
-- 
2.39.2

