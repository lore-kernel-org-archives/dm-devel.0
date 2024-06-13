Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699974206C
	for <dm-devel@lists.linux.dev>; Thu, 13 Jun 2024 15:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718292649; cv=none; b=QtieB0PlVOF/GzOi5r8XfmMfKveWPyYfuQJpxuBDKdIv79jE5LvwwJkRI+NxhTk0+G/UxT1/5U/v/WUkxa/aYVPQ5Tth5kU8/kAJofsAMg+Xp3hBVXcOWnT0wcTFdkVOzl7n0UafR4+xjHt/6IbNi6s5JqQCrg8VXascnhAjdlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718292649; c=relaxed/simple;
	bh=E5Z/kvoYNLWK7q5vDNQGpNcYHR+4lhEXh6Q1FfEvcKs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jtFK5klk5L9jjLcAiqRQcPFS7N3a57k/+cUafNh9ulmxVcX01sFuFznD2ajj6zB/ShJQk1jtN3Dv6Xj/zlmHApElfdkzMXKTjugoYcNGA8qg1bwQsPpjosHnZ6r5WpNIdDIVjE8xZcd0qZkhMlo5F6ku9um1wnPaRZWTZajvVbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H/B5myue; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H/B5myue"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718292647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RaaICOy7sXWTrLxa0w8bYVdyRJ8mVGxyWQW61GPDUrA=;
	b=H/B5myuefnv2uZPQy9nu4z2up8bU/HQEV05c8QcilhdQKytNZj1VPfRjWbvzm2V0YLKf7A
	3NuWSNhJit9EjHTT2E23ysT3jxmuk6vDBwZNkEDio0Xs/BKPWBFnCcIjEI8gFHFE4Rz6/5
	g+2NMr+DZh5e4VhB00IAHuysxRdHUWA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-590-dxf5QbPuMP6-Fj3kiaJxfA-1; Thu,
 13 Jun 2024 11:30:43 -0400
X-MC-Unique: dxf5QbPuMP6-Fj3kiaJxfA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1714A195605B;
	Thu, 13 Jun 2024 15:30:42 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AB4219560AA;
	Thu, 13 Jun 2024 15:30:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45DFUeeV912445
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 13 Jun 2024 11:30:40 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45DFUd7F912444;
	Thu, 13 Jun 2024 11:30:39 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
        Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org
Subject: [PATCH v3] dm-raid: Fix WARN_ON_ONCE check for sync_thread in raid_resume
Date: Thu, 13 Jun 2024 11:30:39 -0400
Message-ID: <20240613153039.912436-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

rm-raid devices will occasionally trigger the following warning when
being resumed after a table load because DM_RECOVERY_RUNNING is set:

WARNING: CPU: 7 PID: 5660 at drivers/md/dm-raid.c:4105 raid_resume+0xee/0x100 [dm_raid]

The failing check is:
WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));

This check is designed to make sure that the sync thread isn't
registered, but md_check_recovery can set MD_RECOVERY_RUNNING without
the sync_thread ever getting registered. Instead of checking if
MD_RECOVERY_RUNNING is set, check if sync_thread is non-NULL.

Fixes: 16c4770c75b1 ("dm-raid: really frozen sync_thread during suspend")
Suggested-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
---
Changes in v3:
  - Fixed Yu Kuai's email address in the Suggested-by trailer
Changes in v2:
  - Move mddev_lock_nointr() earlier to protect dereference and use
    rcu_dereference_protected() to access sync_thread

 drivers/md/dm-raid.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index abe88d1e6735..b149ac46a990 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4101,10 +4101,11 @@ static void raid_resume(struct dm_target *ti)
 		if (mddev->delta_disks < 0)
 			rs_set_capacity(rs);
 
+		mddev_lock_nointr(mddev);
 		WARN_ON_ONCE(!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery));
-		WARN_ON_ONCE(test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
+		WARN_ON_ONCE(rcu_dereference_protected(mddev->sync_thread,
+						       lockdep_is_held(&mddev->reconfig_mutex)));
 		clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
-		mddev_lock_nointr(mddev);
 		mddev->ro = 0;
 		mddev->in_sync = 0;
 		md_unfrozen_sync_thread(mddev);
-- 
2.45.0

