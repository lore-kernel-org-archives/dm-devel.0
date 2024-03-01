Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59C139AC4
	for <dm-devel@lists.linux.dev>; Fri,  1 Mar 2024 15:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709306505; cv=none; b=jOARZ8QqlJj0p/QSfOeL+5U9z6XGxejfJc0H/oSJP4r6c2dnChsjeiHTCm17NuYz5wBFQPwQ3HVUl8anFs/MTHCDQ9lpqtByORlWAfJ7o7dXZPY9nRisBxWcMD6IBoBrLIdGNoXdNCPpV/D9wBMXKaZA67BEVA+Z8bWAFJDqc4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709306505; c=relaxed/simple;
	bh=vEqcjpRsJ+ymHW0SAOe0HJPDbgpPW3ZgJYkU6M1pu/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ffdFVCGa7l3RzvpO7n1d1+lpe8VsR1Z/OmkrtIJ1bPQ9ZxgqE5V2n6KqUxTkZAShBoe1Aauhl38HVSdM2qvjfFtHarYAOmnUQS/5OMTAbo7b8e0VFnJSY67iicxtYEZbDG5EH5Glvuae0E/AuLJhoC74b27pGRBoG2vRYPU3ej0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XEQ0RX/2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XEQ0RX/2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709306502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8hY8wKrmrPYhSBN3Tuj0rq8VL+4sl5GthNYEjh9QoQY=;
	b=XEQ0RX/2FVt+HFZHzd0CrlLaxPfwKmhnbtukMr1IRMYtL2ZOscC4eDXHsFy2mo0R+Ogidu
	SwToRD6BvgWlhmNOn9A5DqCtolO/MWCeLD8V4D2AI5gBgmUmIVUw0QgwkGfV7IwN0Zko+4
	r8X1NtZHtw1BJRyfRwJ7JiiZkhx6vN0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-503-KDdy2XpCPiWnl84NoVjaBg-1; Fri,
 01 Mar 2024 10:21:38 -0500
X-MC-Unique: KDdy2XpCPiWnl84NoVjaBg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1B4F4381644B;
	Fri,  1 Mar 2024 15:21:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 904901121312;
	Fri,  1 Mar 2024 15:21:34 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 1/4] md: Revert "md: Don't register sync_thread for reshape directly"
Date: Fri,  1 Mar 2024 23:21:25 +0800
Message-Id: <20240301152128.13465-2-xni@redhat.com>
In-Reply-To: <20240301152128.13465-1-xni@redhat.com>
References: <20240301152128.13465-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

This reverts commit ad39c08186f8a0f221337985036ba86731d6aafe.

The reverted patch says there is no way to guarantee that md_do_sync
will be executed. Users should choose a sutiable chance to wake up sync
thread after registering sync thread.

And this patch set tries to use a minimal change to fix dmraid regressions.
With patch03 and patch04 and commit 82ec0ae59d02
("md: Make sure md_do_sync() will set MD_RECOVERY_DONE"), all deadlock
problems can be fixed. So revert this one and we can rethink about this
in future.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c     |  5 +----
 drivers/md/raid10.c | 16 ++++++++++++++--
 drivers/md/raid5.c  | 29 +++++++++++++++++++++++++++--
 3 files changed, 42 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9e41a9aaba8b..db4743ba7f6c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9376,7 +9376,6 @@ static void md_start_sync(struct work_struct *ws)
 	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
 	int spares = 0;
 	bool suspend = false;
-	char *name;
 
 	/*
 	 * If reshape is still in progress, spares won't be added or removed
@@ -9414,10 +9413,8 @@ static void md_start_sync(struct work_struct *ws)
 	if (spares)
 		md_bitmap_write_all(mddev->bitmap);
 
-	name = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
-			"reshape" : "resync";
 	rcu_assign_pointer(mddev->sync_thread,
-			   md_register_thread(md_do_sync, mddev, name));
+			   md_register_thread(md_do_sync, mddev, "resync"));
 	if (!mddev->sync_thread) {
 		pr_warn("%s: could not start resync thread...\n",
 			mdname(mddev));
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a5f8419e2df1..7412066ea22c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4175,7 +4175,11 @@ static int raid10_run(struct mddev *mddev)
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+		rcu_assign_pointer(mddev->sync_thread,
+			md_register_thread(md_do_sync, mddev, "reshape"));
+		if (!mddev->sync_thread)
+			goto out_free_conf;
 	}
 
 	return 0;
@@ -4569,8 +4573,16 @@ static int raid10_start_reshape(struct mddev *mddev)
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+
+	rcu_assign_pointer(mddev->sync_thread,
+			   md_register_thread(md_do_sync, mddev, "reshape"));
+	if (!mddev->sync_thread) {
+		ret = -EAGAIN;
+		goto abort;
+	}
 	conf->reshape_checkpoint = jiffies;
+	md_wakeup_thread(mddev->sync_thread);
 	md_new_event();
 	return 0;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 6a7a32f7fb91..4c1f572cc00f 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7936,7 +7936,11 @@ static int raid5_run(struct mddev *mddev)
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+		rcu_assign_pointer(mddev->sync_thread,
+			md_register_thread(md_do_sync, mddev, "reshape"));
+		if (!mddev->sync_thread)
+			goto abort;
 	}
 
 	/* Ok, everything is just fine now */
@@ -8502,8 +8506,29 @@ static int raid5_start_reshape(struct mddev *mddev)
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
+	rcu_assign_pointer(mddev->sync_thread,
+			   md_register_thread(md_do_sync, mddev, "reshape"));
+	if (!mddev->sync_thread) {
+		mddev->recovery = 0;
+		spin_lock_irq(&conf->device_lock);
+		write_seqcount_begin(&conf->gen_lock);
+		mddev->raid_disks = conf->raid_disks = conf->previous_raid_disks;
+		mddev->new_chunk_sectors =
+			conf->chunk_sectors = conf->prev_chunk_sectors;
+		mddev->new_layout = conf->algorithm = conf->prev_algo;
+		rdev_for_each(rdev, mddev)
+			rdev->new_data_offset = rdev->data_offset;
+		smp_wmb();
+		conf->generation--;
+		conf->reshape_progress = MaxSector;
+		mddev->reshape_position = MaxSector;
+		write_seqcount_end(&conf->gen_lock);
+		spin_unlock_irq(&conf->device_lock);
+		return -EAGAIN;
+	}
 	conf->reshape_checkpoint = jiffies;
+	md_wakeup_thread(mddev->sync_thread);
 	md_new_event();
 	return 0;
 }
-- 
2.32.0 (Apple Git-132)

