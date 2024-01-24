Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7DD17C96
	for <dm-devel@lists.linux.dev>; Wed, 24 Jan 2024 09:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706088051; cv=none; b=Fx6PBuZJBKRvn0u46Q35QowDUzbdEPKxwVlWAoYInB7pgsvdo3/jXUkduSB+sXQDXNiJs6qKaE144dnDnO0oY5rsdlWbICSpzKAFI5nEVkQmUjC/bDf+BsqTvXwGzRfxV3NtTN5RwLPgqxKqx8eRpi032rOANqUoJfYmwqz2R3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706088051; c=relaxed/simple;
	bh=khR8VN0nW3AZEac17bucoey0NPJ0wJECbGw6pkiHPS8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cy/982zS7loRi6uO71SbVuUWHpHX3chxJnGLRSxG1yJ6xzKyL0/jgPv9FWtMPsZzjbQeegj7ny4bNl5i7BZbgH5Bdr1WKYKkYKXU8+3yLbKU9tSRPOzP86qDRdE8e0hcFJFMLFecVIPxdGUPU6xuNkH5Fl8GuRgZL85Qt8nTB5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4TKdgW1cgJz1Q85S;
	Wed, 24 Jan 2024 17:19:03 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id BF5EF1A0171;
	Wed, 24 Jan 2024 17:20:32 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 24 Jan
 2024 17:18:25 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<dm-devel@lists.linux.dev>, <xni@redhat.com>, <song@kernel.org>,
	<yukuai3@huawei.com>, <jbrassow@f14.redhat.com>, <neilb@suse.de>,
	<heinzm@redhat.com>, <shli@fb.com>, <akpm@osdl.org>
CC: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH v2 08/11] dm-raid: remove mddev_suspend/resume()
Date: Wed, 24 Jan 2024 17:14:18 +0800
Message-ID: <20240124091421.1261579-9-yukuai3@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240124091421.1261579-1-yukuai3@huawei.com>
References: <20240124091421.1261579-1-yukuai3@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)

dm_suspend() already make sure that no new IO can be issued and will
wait for all dispatched IO to be done. There is no need to call
mddev_suspend() to make sure that again.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 6b6c011d9f69..f1637cf88559 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3241,7 +3241,7 @@ static int raid_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	rs->md.in_sync = 1;
 
 	/* Has to be held on running the array */
-	mddev_suspend_and_lock_nointr(&rs->md);
+	mddev_lock_nointr(&rs->md);
 
 	/* Keep array frozen until resume. */
 	md_frozen_sync_thread(&rs->md);
@@ -3825,11 +3825,9 @@ static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
 
-	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
+	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags))
 		/* Writes have to be stopped before suspending to avoid deadlocks. */
 		md_stop_writes(&rs->md);
-		mddev_suspend(&rs->md, false);
-	}
 }
 
 static void attempt_restore_of_faulty_devices(struct raid_set *rs)
@@ -4085,7 +4083,7 @@ static void raid_resume(struct dm_target *ti)
 		mddev->ro = 0;
 		mddev->in_sync = 0;
 		md_unfrozen_sync_thread(mddev);
-		mddev_unlock_and_resume(mddev);
+		mddev_unlock(mddev);
 	}
 }
 
-- 
2.39.2

