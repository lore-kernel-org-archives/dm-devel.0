Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71385230278
	for <dm-devel@lists.linux.dev>; Thu, 19 Jun 2025 11:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750332716; cv=none; b=Si8q6FZzxxxc0YbiB+P2i8Y6Divt5+3mmK1ZkO19y/Fuj1WkJ6mVzctZiLDjx410g2ZFWgcEnEwQt8GOmlO6K2mf4pV5hxnSJDFBtTbIYEFo11AbVRCCzZneZgeqz9ROe/8Nmb9z09FyecV8xxFicTTYf2VhpJdI+paebsmf2Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750332716; c=relaxed/simple;
	bh=83GJJst8jwxirdSyTar+kvybgHU1wa5oBuVzR0C3Xck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qycjrVv1GgCfKtsxINyfQyIwS2OQUUk6H+73BU0yK/d1N4CVuHMNfz/wh8rgtsZ9VEJEX1yoEYY7OuGtBlF592QubXBsQZS3KbZFKD+2QVTMry8hwe/N+U7VwNRILg307AgmJco/E7vlFQ9vS30vsmznCpa69l5L1T+DwmFPNqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bNJNT4J5ZzYQvNS
	for <dm-devel@lists.linux.dev>; Thu, 19 Jun 2025 19:31:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8764D1A12E3
	for <dm-devel@lists.linux.dev>; Thu, 19 Jun 2025 19:31:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.112.188])
	by APP4 (Coremail) with SMTP id gCh0CgCH618Y9VNoihn_Pw--.51230S12;
	Thu, 19 Jun 2025 19:31:52 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org
Cc: linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	tytso@mit.edu,
	djwong@kernel.org,
	john.g.garry@oracle.com,
	bmarzins@redhat.com,
	chaitanyak@nvidia.com,
	shinichiro.kawasaki@wdc.com,
	brauner@kernel.org,
	martin.petersen@oracle.com,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	chengzhihao1@huawei.com,
	yukuai3@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 8/9] block: add FALLOC_FL_WRITE_ZEROES support
Date: Thu, 19 Jun 2025 19:18:05 +0800
Message-ID: <20250619111806.3546162-9-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250619111806.3546162-1-yi.zhang@huaweicloud.com>
References: <20250619111806.3546162-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCH618Y9VNoihn_Pw--.51230S12
X-Coremail-Antispam: 1UD129KBjvJXoW7Zry7Xw4xJr4xAry7Gr1fCrg_yoW8AryUpF
	4UX3WYgFWFgas3GF1rCa1DWrn5Za1kGrWfCayI9w1F9w47Jrn7Krn0gF98tF98JFWUAan5
	XayavryUuF17ArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRiF4iUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Add support for FALLOC_FL_WRITE_ZEROES, if the block device enables the
unmap write zeroes operation, it will issue a write zeroes command.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/fops.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/block/fops.c b/block/fops.c
index e1c921549d28..474656a0de70 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -841,7 +841,7 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 #define	BLKDEV_FALLOC_FL_SUPPORTED					\
 		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
-		 FALLOC_FL_ZERO_RANGE)
+		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_WRITE_ZEROES)
 
 static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 			     loff_t len)
@@ -856,6 +856,13 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 	/* Fail if we don't recognize the flags. */
 	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
 		return -EOPNOTSUPP;
+	/*
+	 * Don't allow writing zeroes if the device does not enable the
+	 * unmap write zeroes operation.
+	 */
+	if ((mode & FALLOC_FL_WRITE_ZEROES) &&
+	    !bdev_write_zeroes_unmap_sectors(bdev))
+		return -EOPNOTSUPP;
 
 	/* Don't go off the end of the device. */
 	isize = bdev_nr_bytes(bdev);
@@ -886,6 +893,9 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
 		flags = BLKDEV_ZERO_NOFALLBACK;
 		break;
+	case FALLOC_FL_WRITE_ZEROES:
+		flags = 0;
+		break;
 	default:
 		error = -EOPNOTSUPP;
 		goto fail;
-- 
2.46.1

