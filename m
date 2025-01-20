Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB521922C6
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 08:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737361088; cv=none; b=RnCokMO91+HTB9dx6UaLp5GbqblJtWbisUj8777eAlZz9jcO5Pb1IwHq064bN2fPqz6UmS15PCBsjX+mXyuv6wivnkiIib5kB/De2PpmJAM8VWlDBJdWmLmNcGsQwcsLpbVz2pw1FWFEK7B5EwUIrGyF+uNbxKM0z9PX+8jqAVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737361088; c=relaxed/simple;
	bh=lZ3ud1tvmlMjzKz5RLIVeUs+u1g9r0mKJ1gcE13mHTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WmiapM+ErgfFkymF9BnSgLMmZmVfBrgH6xlOnzktaC+xWhGxlFyGzneUhgYT98CudQLJZ3z5YtGADo+apq8EJkYY6aQIZ3ZKMbF6XhRnS93OP0zD3e8Jjzsx6cEtLTT+3PPdk8EyP/78Ng7nhJE6fOcSi6XyJLw/SF1KSe6+bro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yc39V5Slrz4f3jLm
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 927751A170F
	for <dm-devel@lists.linux.dev>; Mon, 20 Jan 2025 16:17:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.124.27])
	by APP4 (Coremail) with SMTP id gCh0CgB321+kBo5n8sHjBQ--.22840S5;
	Mon, 20 Jan 2025 16:17:56 +0800 (CST)
From: Hou Tao <houtao@huaweicloud.com>
To: dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Ignat Korchagin <ignat@cloudflare.com>,
	houtao1@huawei.com
Subject: [PATCH 1/6] dm-crypt: set atomic as false when calling crypt_convert() in kworker
Date: Mon, 20 Jan 2025 16:29:46 +0800
Message-Id: <20250120082951.1423804-2-houtao@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgB321+kBo5n8sHjBQ--.22840S5
X-Coremail-Antispam: 1UD129KBjvJXoW7Jw4rCw47Jr13ur4fAry5Jwb_yoW8JF13pF
	1rua4Fkr45GF4YgF1qq3W0vFy5u3WkKFy3Gw47Cwn0yryYgrWkWF47ta1aqr15JF93AFya
	vF4vyF45G3Z2ya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Kb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_JFI_Gr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMc
	Ij6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_
	Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr4
	1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK
	67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI
	8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAv
	wI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14
	v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUw9a9UUUUU
X-CM-SenderInfo: xkrx3t3r6k3tpzhluzxrxghudrp/

From: Hou Tao <houtao1@huawei.com>

Both kcryptd_crypt_write_continue() and kcryptd_crypt_read_continue()
are running in the kworker context, it is OK to call cond_resched(),
Therefore, set atomic as false when invoking crypt_convert() under
kworker context.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 drivers/md/dm-crypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 1ae2c71bb383b..424c8fc3f0ada 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2098,7 +2098,7 @@ static void kcryptd_crypt_write_continue(struct work_struct *work)
 	wait_for_completion(&ctx->restart);
 	reinit_completion(&ctx->restart);
 
-	r = crypt_convert(cc, &io->ctx, true, false);
+	r = crypt_convert(cc, &io->ctx, false, false);
 	if (r)
 		io->error = r;
 	crypt_finished = atomic_dec_and_test(&ctx->cc_pending);
@@ -2203,7 +2203,7 @@ static void kcryptd_crypt_read_continue(struct work_struct *work)
 	wait_for_completion(&io->ctx.restart);
 	reinit_completion(&io->ctx.restart);
 
-	r = crypt_convert(cc, &io->ctx, true, false);
+	r = crypt_convert(cc, &io->ctx, false, false);
 	if (r)
 		io->error = r;
 
-- 
2.29.2

