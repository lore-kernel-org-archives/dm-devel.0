Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59152E401
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 01:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744939014; cv=none; b=JXGpvvLmVG5HeWssVGUksAePipfWis5AMBeTfFIH96Qd2DLsxVn9L2uWDntKzynoPYnAI/2gS4oIOkKHjyadB/QGnkodmp1QI1q9Od8eLqxYnYcn74Gq603R5fX4vz96ATUQbax4mTB9a9wdorWL4WdDtt8K67Fl1tDW9PYlFYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744939014; c=relaxed/simple;
	bh=Ubf9NVVxVgXVJwynH42c+GpCfZfjXZQYOXILtxUffBM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CcxJ6ZdQu7QqQYB/hO3IqeK7jduYSA4iAikoRWwZC8YlJRBOkjMnWjOFdkMwgjIjP/26/NUihN2LK3mr9vgxmacNFKYpepObJH1p28M05GhjyFLv4S/J1i/mWXVuofodGk79j6TcpfXUgWlar6SJPbq6Fwx9XOjysIJmtueJ+y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Zdxg210VPz4f3jLm
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 09:16:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 879B21A07BD
	for <dm-devel@lists.linux.dev>; Fri, 18 Apr 2025 09:16:48 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2D8pwFoK5w2Jw--.18201S6;
	Fri, 18 Apr 2025 09:16:48 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: axboe@kernel.dk,
	xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com,
	viro@zeniv.linux.org.uk,
	akpm@linux-foundation.org,
	nadav.amit@gmail.com,
	ubizjak@gmail.com,
	cl@linux.com
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v2 2/5] md: record dm-raid gendisk in mddev
Date: Fri, 18 Apr 2025 09:09:38 +0800
Message-Id: <20250418010941.667138-3-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250418010941.667138-1-yukuai1@huaweicloud.com>
References: <20250418010941.667138-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2D8pwFoK5w2Jw--.18201S6
X-Coremail-Antispam: 1UD129KBjvJXoW7AFy8Gw4xtF1kGF4rCr1ftFb_yoW8Wryrpa
	1DA3yrArW5A39Fq3WDJr4DZa45X3WqqryrKF9xCaySvayavF98Ww1kGF42qr4DGrZIgFnx
	ur4jvws8Kry0yrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjTRNiSHDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Following patch will use gendisk to check if there are normal IO
completed or inflight, to fix a problem in mdraid that foreground IO
can be starved by background sync IO in later patches.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c | 3 +++
 drivers/md/md.h      | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 6adc55fd90d3..127138c61be5 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -14,6 +14,7 @@
 #include "raid5.h"
 #include "raid10.h"
 #include "md-bitmap.h"
+#include "dm-core.h"
 
 #include <linux/device-mapper.h>
 
@@ -3308,6 +3309,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	/* Disable/enable discard support on raid set. */
 	configure_discard_support(rs);
+	rs->md.dm_gendisk = ti->table->md->disk;
 
 	mddev_unlock(&rs->md);
 	return 0;
@@ -3327,6 +3329,7 @@ static void raid_dtr(struct dm_target *ti)
 
 	mddev_lock_nointr(&rs->md);
 	md_stop(&rs->md);
+	rs->md.dm_gendisk = NULL;
 	mddev_unlock(&rs->md);
 
 	if (work_pending(&rs->md.event_work))
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1cf00a04bcdd..9d55b4630077 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -404,7 +404,8 @@ struct mddev {
 						       * are happening, so run/
 						       * takeover/stop are not safe
 						       */
-	struct gendisk			*gendisk;
+	struct gendisk			*gendisk;    /* mdraid gendisk */
+	struct gendisk			*dm_gendisk; /* dm-raid gendisk */
 
 	struct kobject			kobj;
 	int				hold_active;
-- 
2.39.2

