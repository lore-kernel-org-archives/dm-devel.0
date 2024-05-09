Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85E813BC3F
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 01:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218150; cv=none; b=ah+B4gJJ8qQBP0pp4X+3vp4Ld94GbQZ60VsdhGAk7+qIpqAJJmeDKmXm0Gj7GqNHdES7WzGLBUk7RV0Kwb2Xz8Z1pYkRE98Y9EoCqzyDeUmCj9w9Oe4HNU0mIhDnmobzUGUPhiUg88oktmEDLhWv14UVSFVwn/dHhNATjRF+gok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218150; c=relaxed/simple;
	bh=U03wBk7HDXB0sFrPIc2tbiab0SncvyWu7xn1xRY1pmQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=TP4N/L0BIUO9R0pOmHLw2GSxJ3axDqf+JwsGphQnnyyB5lSGVQtjlatEQGl0dKQq6NHt6q4NK4XZp2NCeEvDi/1rxjcHnkjIm/8keB4m8VHpVHX0cSGYVNLFfedaB/8tHPJ8TsRFwOolBlzUIXX0Ds/4uX0w5b7gyXO4QeRZs1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VZZDB2Vzzz4f3kjp
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:28:58 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id ADC771A0B1B
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:29:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDeJjxm5MuXMA--.59814S4;
	Thu, 09 May 2024 09:29:03 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH RFC md-6.10 0/9] md: refactor and cleanup for sync action
Date: Thu,  9 May 2024 09:18:51 +0800
Message-Id: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxDeJjxm5MuXMA--.59814S4
X-Coremail-Antispam: 1UD129KBjvdXoWruFy8JF4fCF4DKw15Zw48tFb_yoWfWwcEga
	4kXFy3Jw45uF1UJFy5tr1S9rWjka1Ygrs7Ja43trWSyr97ZF17GF1jkrWfXw1fZrZF9r1Y
	vry8C3yfArsFgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628v
	n2kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
	UZa9-UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Motivation of this patchset is that during code review, I found some
places is not good coded, and I decide to make code more readable.

Yu Kuai (9):
  md: rearrange recovery_flage
  md: add a new enum type sync_action
  md: add new helpers for sync_action
  md: factor out helper to start reshape from action_store()
  md: replace sysfs api sync_action with new helpers
  md: use new helers in md_do_sync()
  md: replace last_sync_action with new enum type
  md: factor out helpers for different sync_action in md_do_sync()
  md: pass in max_sectors for pers->sync_request()

 drivers/md/dm-raid.c |   2 +-
 drivers/md/md.c      | 367 ++++++++++++++++++++++++++++---------------
 drivers/md/md.h      | 122 +++++++++++---
 drivers/md/raid1.c   |   5 +-
 drivers/md/raid10.c  |   8 +-
 drivers/md/raid5.c   |   3 +-
 6 files changed, 344 insertions(+), 163 deletions(-)

-- 
2.39.2

