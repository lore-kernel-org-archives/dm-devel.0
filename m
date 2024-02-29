Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BD8141279
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 15:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709221815; cv=none; b=Pw8mYvSoXQh5waQwV5KTWF9/zrEO/snhUDvyDD1r+s30X1+WLM9u5HhzP8L5mgPcrpDDwlKl4SwquZMLorO+6slG68j0EGPWXfYDPgl8HmZM+XGAzzeK/U2Jt/q4HQgQ/scCBYCuXK65TXt20rH4APfCAlVfiF0oEJRqF6jRdDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709221815; c=relaxed/simple;
	bh=0rnQyoyTlg3NbFP2xDGLMqFSdLbaPSQzUA+5qj2XTgA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sxvNhlxtrkbVxwMQWLBgxbHRAiOlnDnuongAu1SehKin3Oirf1uoLYc3ad2HXX7iedMknRYEIp1NV4YlQJ5tPmD8hVY3N3OVUtyX2z/RdGE8GV5KIA+oyq4feD9QWBbGdFnfNFnE+xksToRelx6+50qcqxGKD1fEKFC5L/NrhkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PgZbfTRs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PgZbfTRs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709221812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dt9GfymT1kyhV1QstwRrdfFuwoG4I2AsFDk18HlPQIc=;
	b=PgZbfTRssmlKEEbf817xKluA5H+InArQGElvpo4YNdm0JULvGxoxwjDdQppBbXT6/9HzhU
	n5JW3KZKQz4WJ4SKt5HlyiIfodGFgJFj89V7rxPdcUb2NDJc7l5/xIpA20mjSLQbcSj6Ot
	adzq0dacs959jIyyYMqQXYF4DkzhJ3g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-QaiRIttkPSOf714xg3SBMQ-1; Thu, 29 Feb 2024 10:50:08 -0500
X-MC-Unique: QaiRIttkPSOf714xg3SBMQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 69AF088D28B;
	Thu, 29 Feb 2024 15:50:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E0FBDC185C4;
	Thu, 29 Feb 2024 15:50:04 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 5/6] md: Set MD_RECOVERY_FROZEN before stop sync thread
Date: Thu, 29 Feb 2024 23:49:40 +0800
Message-Id: <20240229154941.99557-6-xni@redhat.com>
In-Reply-To: <20240229154941.99557-1-xni@redhat.com>
References: <20240229154941.99557-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.8

After patch commit f52f5c71f3d4b ("md: fix stopping sync thread"), dmraid
stops sync thread asynchronously. The calling process is:
dev_remove->dm_destroy->__dm_destroy->raid_postsuspend->raid_dtr

raid_postsuspend does two jobs. First, it stops sync thread. Then it
suspend array. Now it can stop sync thread successfully. But it doesn't
set MD_RECOVERY_FROZEN. It's introduced by patch f52f5c71f3d4b. So after
raid_postsuspend, the sync thread starts again. raid_dtr can't stop the
sync thread because the array is already suspended.

This can be reproduced easily by those commands:
while [ 1 ]; do
vgcreate test_vg /dev/loop0 /dev/loop1
lvcreate --type raid1 -L 400M -m 1 -n test_lv test_vg
lvchange -an test_vg
vgremove test_vg -ff
done

Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f264749be28b..cf15ccf0e27b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6341,6 +6341,7 @@ static void __md_stop_writes(struct mddev *mddev)
 void md_stop_writes(struct mddev *mddev)
 {
 	mddev_lock_nointr(mddev);
+	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	__md_stop_writes(mddev);
 	mddev_unlock(mddev);
 }
-- 
2.32.0 (Apple Git-132)

