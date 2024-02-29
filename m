Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FFD7829A
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 15:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709221797; cv=none; b=OR4YdFK2S7a/J6XqCyYYhettjBoir/qXCHpSnc4E/dSXYt+MP6wN6Ex0suFLjyNagZucAqsnDbFYssQDcrqTlOibQNU1CrWb9D2BOFn+03KlFovkLuHbZQ+XQo4CsYWVEKCmHL5+HZdLj7DkBqXc0GhmkFqrLtv0amlOtOAPpfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709221797; c=relaxed/simple;
	bh=ZmC35RCrPhUTQl8+M8nLnEQvNoqf6oq53QOhvyHP3PM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OC1S3WiFIWto/emeJh9ZuCXgz9UBA83BaljOUe8riUijAn9nhuJzPWIdLTZPIUFjDMndDhjXXKZF0+GCUQM/ykPCCroH19XLmF/AJh8gmi8jSGyLUFRlbvgEuZEtwZBbDgdQTJKsxbOBUX23vsDPShQUe+yY+YdR1VPerqeJDYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gQ+q4UOu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gQ+q4UOu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709221795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z9c1/ubZy0Xa4EcWrsRRt62KfmBqmKDvkzP1wK/kFfs=;
	b=gQ+q4UOuso3u3FMHCZTJ+ZHzXUZjYqE9MIwaac5Wb6Nox/ImTzj80AFZ1f0a3KRyR0G5qJ
	pGNWatppijrL47Gg/xQVLPu2OJll+5O2oO4Ki6opnAYI+SjYXt7H5K0PYAgojJZcjwJcit
	+6T/9rmn8hZeq9xZY6BSJBPNC5SZRHU=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-4y5TiYQmPdWWCQ4S0E4x1g-1; Thu,
 29 Feb 2024 10:49:51 -0500
X-MC-Unique: 4y5TiYQmPdWWCQ4S0E4x1g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7560C3C2B608;
	Thu, 29 Feb 2024 15:49:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ECA93C0348B;
	Thu, 29 Feb 2024 15:49:47 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 1/6] md: Revert "md: Don't register sync_thread for reshape directly"
Date: Thu, 29 Feb 2024 23:49:36 +0800
Message-Id: <20240229154941.99557-2-xni@redhat.com>
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

This reverts commit ad39c08186f8a0f221337985036ba86731d6aafe.

Function stop_sync_thread only wakes up sync task. It also needs to
wake up sync thread. This problem will be fixed in the following
patch.

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
index 6a7a32f7fb91..8497880135ee 100644
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

