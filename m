Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C69E80026
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 07:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709623777; cv=none; b=D2OJrgLRB4dBaC61QKUSvwnC8JCNJ9QdN+RQxZ2dzgsB1i71K+KYcHR9XUm5zJ0GOm2ISuAg+WqNrjZU8g0Dy3mDjfsh3seQC5/MvB3bGaDs1OWZ+H0Hic1NxzRTuGuh7g5bTbHS6k1KPeXwEQ6EZKNCVrmrZInOE4tHh8UmWIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709623777; c=relaxed/simple;
	bh=xLrCo0TM2lW9vZ7sDJbrPgQEy+ULwHr3T5cie4P5Ah4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=evPyRY3DFZpvLYyBBE4GqIoe2yBbT5RtxOhZFFq2qf/AQ/NApzsp8JQQqc2EKQ4QDZ57Jmd/VXMDHMvsDw2YXYt2sogu4tS3tAS9OLvJVs75Xil9LzY7DTe7E99mmoWSs74DnU2TARgxOTnwnlwAlLr66qD+xu1s3F7KJOf3xWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4TpnJ25Md2z4f3jsb
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 15:29:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 2875D1A0232
	for <dm-devel@lists.linux.dev>; Tue,  5 Mar 2024 15:29:28 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgBHGBHRyeZlGnf+Fw--.17927S8;
	Tue, 05 Mar 2024 15:29:28 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com,
	zkabelac@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	dm-devel@lists.linux.dev,
	song@kernel.org,
	yukuai3@huawei.com,
	heinzm@redhat.com,
	jbrassow@redhat.com,
	neilb@suse.de
Cc: linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.8 v2 4/9] md: add a new helper reshape_interrupted()
Date: Tue,  5 Mar 2024 15:23:01 +0800
Message-Id: <20240305072306.2562024-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240305072306.2562024-1-yukuai1@huaweicloud.com>
References: <20240305072306.2562024-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHGBHRyeZlGnf+Fw--.17927S8
X-Coremail-Antispam: 1UD129KBjvJXoWrZw15Zr18uFW8Xr48Ar1fWFg_yoW8JF48pa
	yxGFZ8Zr4UAF9xGanrtF1kZa45uwn5KryDGFyfuan8AF13Xr129ryrWr1UArykGFySqa1a
	qa1rtFyUCr1xWw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPF14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJV
	W8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUOBTY
	UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The helper will be used for dm-raid456 later to detect the case that
reshape can't make progress.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/md.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 684cc866402a..7f955115d78d 100644
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

