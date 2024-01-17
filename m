Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE9922EE0
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 18:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705515683; cv=none; b=qB9Co5RyssRURKNfkB5QLxO+Ub1SPQ3mETlk8C3o90VGVKr6nyYKPq044hW20WHyKUu2ASBlHAqWfTlWoRcAAmvr8CyVjMAFP/uI6vwED21uhWDqjgLNdnSV53XAWceJPoEChmdZVTmxdo++k34/l9/VXRUyRFtU2QGPRnQDx1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705515683; c=relaxed/simple;
	bh=XOrPZkYfAHI/W4PT+jSquhG2aWQvQlifjO4edvwXWlE=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-Scanned-By; b=PlaycImd1nDVxRxQ3YdnebIICX1/432SEO+1kgCd8SlP7mqZSBO3v80BvAQDwoxmBl78ZuKX6vQ2mukW26VwPPiQCA8s1YIm/rK5x/awJ2Wf7f83Po1059Qv5rpqNjQo1JU1OuAU3eMH6B3cdnTw0VLFKyzAonDMcZuPJ2wXV0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IyfSYAWk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IyfSYAWk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705515680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cIqqbSPoded3Wn+vyLp5YJWW6srr8m4G6HETipUFS2g=;
	b=IyfSYAWkfZT+MxxQtrKhv9E0+N98GeGxMG0OA0WIp3U9VG7VVxTxUd282SeN4pcC+G5CxY
	ShWKdev6w11HaJ9bW9JWQQuh93xC5VeXePnBbGsUh5FTO4y62wXxWeI+WQxDzP3n82Z5dd
	PhxvhQVFs16HWohcY+Wsfw5ZCmHaPnE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-4v5w3_AEPFWuYTiK6-pOQg-1; Wed, 17 Jan 2024 13:21:17 -0500
X-MC-Unique: 4v5w3_AEPFWuYTiK6-pOQg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB66B82A6C3;
	Wed, 17 Jan 2024 18:21:16 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C2A7840C6EB9;
	Wed, 17 Jan 2024 18:21:16 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id BA27430C039C; Wed, 17 Jan 2024 18:21:16 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id B93CF3FB50;
	Wed, 17 Jan 2024 19:21:16 +0100 (CET)
Date: Wed, 17 Jan 2024 19:21:16 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>, 
    David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
    Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 5/7] md: fix deadlock in
 shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh
In-Reply-To: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Message-ID: <ece2b06f-d647-6613-a534-ff4c9bec1142@redhat.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

This commit fixes a deadlock in the LVM2 test
shell/lvconvert-raid-reshape-linear_to_raid6-single-type.sh

When MD_RECOVERY_WAIT is set or when md_is_rdwr(mddev) is true, the
function md_do_sync would not set MD_RECOVERY_DONE. Thus, stop_sync_thread
would wait for the flag MD_RECOVERY_DONE indefinitely.

Also, md_wakeup_thread_directly does nothing if the thread is waiting in
md_thread on thread->wqueue (it wakes the thread up, the thread would
check THREAD_WAKEUP and go to sleep again without doing anything). So,
this commit introduces a call to md_wakeup_thread from
md_wakeup_thread_directly.

task:lvm             state:D stack:0     pid:46322 tgid:46322 ppid:46079  flags:0x00004002
Call Trace:
 <TASK>
 __schedule+0x228/0x570
 schedule+0x29/0xa0
 schedule_timeout+0x6a/0xd0
 ? timer_shutdown_sync+0x10/0x10
 stop_sync_thread+0x197/0x1c0 [md_mod]
 ? housekeeping_test_cpu+0x30/0x30
 ? table_deps+0x1b0/0x1b0 [dm_mod]
 __md_stop_writes+0x10/0xd0 [md_mod]
 md_stop_writes+0x18/0x30 [md_mod]
 raid_postsuspend+0x32/0x40 [dm_raid]
 dm_table_postsuspend_targets+0x34/0x50 [dm_mod]
 dm_suspend+0xc4/0xd0 [dm_mod]
 dev_suspend+0x186/0x2d0 [dm_mod]
 ? table_deps+0x1b0/0x1b0 [dm_mod]
 ctl_ioctl+0x2e1/0x570 [dm_mod]
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0x85/0xa0
 do_syscall_64+0x5d/0x1a0
 entry_SYSCALL_64_after_hwframe+0x46/0x4e

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Cc: stable@vger.kernel.org	# v6.7

---
 drivers/md/md.c    |    8 +++++++-
 drivers/md/raid5.c |    4 ++++
 2 files changed, 11 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/md.c
===================================================================
--- linux-2.6.orig/drivers/md/md.c
+++ linux-2.6/drivers/md/md.c
@@ -8029,6 +8029,8 @@ static void md_wakeup_thread_directly(st
 	if (t)
 		wake_up_process(t->tsk);
 	rcu_read_unlock();
+
+	md_wakeup_thread(thread);
 }
 
 void md_wakeup_thread(struct md_thread __rcu *thread)
@@ -8777,10 +8779,14 @@ void md_do_sync(struct md_thread *thread
 
 	/* just incase thread restarts... */
 	if (test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
-	    test_bit(MD_RECOVERY_WAIT, &mddev->recovery))
+	    test_bit(MD_RECOVERY_WAIT, &mddev->recovery)) {
+		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+			set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 		return;
+	}
 	if (!md_is_rdwr(mddev)) {/* never try to sync a read-only array */
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+		set_bit(MD_RECOVERY_DONE, &mddev->recovery);
 		return;
 	}
 

