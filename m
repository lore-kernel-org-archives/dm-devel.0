Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6360822EF6
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705515574; cv=none; b=M1y78WUAQjrWys8DcujxGdJDXYK+8gfw5dd++SKdnuGxDLUoc+pqhW0mFW6MaPJL2n0iA/p6bnRNY2QtFmAhFmVKGvC/X11wd4lc/4Koiu0lkLBl1bG5S2DoKMGQksDf+YxNv/4+9i/MQHWuD7xQG4JeTu1GzBp9/c6z8sQ9LWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705515574; c=relaxed/simple;
	bh=ydjyH3o9mGh/vlcml3f5BQGwcUUvIaeQjwxMIvKA/CQ=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-Scanned-By; b=OwjfIiLQssMwXLZubxGyl3XauARNh8BMNWXrq5a1v7fRwqAsQbuNPaiuCyb9LAYRziQEUlvEMhvxv+1WQ/s77nmDFgKHb8UJ7OeT42/DxDoFlNcEO8RmzziiDlbva5o2TTq9plFSakmoaHPcJXVFC2Ll6KjCASqBRi9+C6RSe7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KqdNco0H; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KqdNco0H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705515571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=khF1u9GEl7GnxafypCHqAXBIUn3A1Gll1R+lMdfFYY0=;
	b=KqdNco0HvB8dIiyq3quzLEAL3Y9vgQZCvyyefH4vNJSPQ9t5jl/7Kj0VaVZUuX0EDCxAYw
	FH8NldAiAAIizOBtNg/MyuSzYebNeqZUsAc5drry/xEWVQF2/Ldx7GuaTojM+Lp5PJPuW1
	fWKs9rd53gXrjzjljTxuehLdD7+iUt0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-177-fTds6cB9OcKB_w6dWvZ1cw-1; Wed,
 17 Jan 2024 13:19:27 -0500
X-MC-Unique: fTds6cB9OcKB_w6dWvZ1cw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 927451C294A2;
	Wed, 17 Jan 2024 18:19:26 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 88FA01C066AB;
	Wed, 17 Jan 2024 18:19:26 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 7EDC130C039C; Wed, 17 Jan 2024 18:19:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 7E1BC3FB50;
	Wed, 17 Jan 2024 19:19:26 +0100 (CET)
Date: Wed, 17 Jan 2024 19:19:26 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>, 
    David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
    Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 3/7] md: test for MD_RECOVERY_DONE in stop_sync_thread
In-Reply-To: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Message-ID: <9801e40-8ac7-e225-6a71-309dcf9dc9aa@redhat.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

stop_sync_thread sets MD_RECOVERY_INTR and then waits for
MD_RECOVERY_RUNNING to be cleared. However, md_do_sync will not clear
MD_RECOVERY_RUNNING when exiting, it will set MD_RECOVERY_DONE instead.

So, we must wait for MD_RECOVERY_DONE to be set as well.

This patch fixes a deadlock in the LVM2 test shell/integrity-caching.sh.

sysrq: Show Blocked State
task:lvm             state:D stack:0     pid:11422  tgid:11422 ppid:1374   flags:0x00004002
Call Trace:
 <TASK>
 __schedule+0x228/0x570
 schedule+0x29/0xa0
 schedule_timeout+0x6a/0xd0
 ? timer_shutdown_sync+0x10/0x10
 stop_sync_thread+0x141/0x180 [md_mod]
 ? housekeeping_test_cpu+0x30/0x30
 __md_stop_writes+0x10/0xd0 [md_mod]
 md_stop+0x9/0x20 [md_mod]
 raid_dtr+0x1e/0x60 [dm_raid]
 dm_table_destroy+0x53/0x110 [dm_mod]
 __dm_destroy+0x10b/0x1e0 [dm_mod]
 ? table_clear+0xa0/0xa0 [dm_mod]
 dev_remove+0xd4/0x110 [dm_mod]
 ctl_ioctl+0x2e1/0x570 [dm_mod]
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0x85/0xa0
 do_syscall_64+0x5d/0x1a0
 entry_SYSCALL_64_after_hwframe+0x46/0x4e

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org	# v6.7
Fixes: 130443d60b1b ("md: refactor idle/frozen_sync_thread() to fix deadlock")

---
 drivers/md/md.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -4881,7 +4881,8 @@ static void stop_sync_thread(struct mdde
 	if (check_seq)
 		sync_seq = atomic_read(&mddev->sync_seq);
 
-	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+	    test_bit(MD_RECOVERY_DONE, &mddev->recovery)) {
 		if (!locked)
 			mddev_unlock(mddev);
 		return;
@@ -4901,6 +4902,7 @@ retry:
 
 	if (!wait_event_timeout(resync_wait,
 		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+		   test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
 		   (check_seq && sync_seq != atomic_read(&mddev->sync_seq)),
 		   HZ / 10))
 		goto retry;

