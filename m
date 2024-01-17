Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249D222EFC
	for <dm-devel@lists.linux.dev>; Wed, 17 Jan 2024 18:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705515734; cv=none; b=HYtVSsNnNnMo0fxPsZl+gmmbHj/Je5MOWj0OqNAO3kyuDX1V1FU1W+apHyt0J1heteLG934x+Jj+/oxYnkthW1pbkHDx78VvFC46y5GAyuX48zOb1qVtb0uMsS9qCE3oF8EuQ2IcPIfp4Bedo3DEsjkvq9v1XV1rIGX0Gj35Q4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705515734; c=relaxed/simple;
	bh=PvLLl7v66q+PUHFprvCUDHoxKOwwMAQAhNVQXQYYT6I=;
	h=DKIM-Signature:Received:X-MC-Unique:Received:Received:Received:
	 Received:Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type:X-Scanned-By; b=LOMaN1jIR5RGrUIFtrGShZ5OdpeQDKDE66hs5DRSVeIoUvvo3XFOQpojpC2WbtwM0fyPxz+vgTNZiJHtW0zNhmvFkIA4PeSShpvOc+AoauNSf2Ujbp6Z4+syvEBd0JYbKQzlNruiG1gPPl8mJLEwSrhF9WuI0EZ5PKRPf1Y2SMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Uxoz8wy9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uxoz8wy9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1705515731;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GG9fyFkKr1M4arY8M7JnB5SochcGhl1C3lyQQS9soBo=;
	b=Uxoz8wy9DckPcJSaQ3pVn9Vh9sHin48IVbnyBexgRMnB4d1ffiHJAoCASoaCXjUCU2Y5ch
	y30Tse2WmnXEdRDteA5y7ySuHHGisyhRPoW2prUARgiH6aV5U8VH05HqoNAI9xidiJM1TH
	hX/telUmOwbbDjmfkSJ/V1kSIlcLiS8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-508-bfiZ0wIIMPy6uwRahF5gWQ-1; Wed, 17 Jan 2024 13:22:06 -0500
X-MC-Unique: bfiZ0wIIMPy6uwRahF5gWQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA777185A791;
	Wed, 17 Jan 2024 18:22:05 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E32872166B33;
	Wed, 17 Jan 2024 18:22:05 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id DB3C730C039C; Wed, 17 Jan 2024 18:22:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id DA6513FB50;
	Wed, 17 Jan 2024 19:22:05 +0100 (CET)
Date: Wed, 17 Jan 2024 19:22:05 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yu Kuai <yukuai3@huawei.com>, Song Liu <song@kernel.org>, 
    David Jeffery <djeffery@redhat.com>, Li Nan <linan122@huawei.com>
cc: dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
    Mike Snitzer <msnitzer@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, 
    Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 6/7] md: partially revert "md/raid6: use valid sector values
 to determine if an I/O should wait on the reshape"
In-Reply-To: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Message-ID: <b725da99-d649-6f1d-af82-c3e482f7f6e@redhat.com>
References: <e5e8afe2-e9a8-49a2-5ab0-958d4065c55e@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Revert the commit c467e97f079f ("md/raid6: use valid sector values to
determine if an I/O should wait on the reshape") - it causes deadlock in
the LVM2 test shell/lvconvert-raid-reshape.sh

sysrq: Show Blocked State
task:(udev-worker)   state:D stack:0     pid:98633 tgid:98633 ppid:320    flags:0x00000006
Call Trace:
 <TASK>
 __schedule+0x213/0x550
 schedule+0x29/0xa0
 schedule_timeout+0xbe/0xd0
 ? __wake_up+0x3b/0x50
 wait_woken+0x47/0x50
 raid5_make_request+0x501/0x10e0 [raid456]
 ? swake_up_all+0xb0/0xb0
 md_handle_request+0x132/0x1e0 [md_mod]
 raid_map+0x20/0x30 [dm_raid]
 __map_bio+0x179/0x1a0 [dm_mod]
 dm_submit_bio+0x166/0x4c0 [dm_mod]
 __submit_bio+0x78/0xf0
 submit_bio_noacct_nocheck+0xb6/0x290
 mpage_readahead+0xc7/0xe0
 ? blkdev_iomap_begin+0x80/0x80
 read_pages+0x42/0x1e0
 page_cache_ra_unbounded+0x128/0x170
 force_page_cache_ra+0x8c/0xb0
 filemap_get_pages+0xf3/0x530
 ? current_time+0x16/0xc0
 filemap_read+0xb3/0x2b0
 ? sgl_alloc_order+0xf0/0x1c0
 ? dm_copy_name_and_uuid+0x6c/0x90 [dm_mod]
 ? dm_attr_uuid_show+0x1a/0x40 [dm_mod]
 ? do_wp_page+0x20c/0xaf0
 ? dm_attr_show+0x32/0x50 [dm_mod]
 ? __pte_offset_map+0x12/0x170
 blkdev_read_iter+0x62/0x140
 vfs_read+0x1a9/0x2a0
 ksys_read+0x4e/0xc0
 do_syscall_64+0x3c/0x110
 entry_SYSCALL_64_after_hwframe+0x46/0x4e
 </TASK>
task:lvm             state:D stack:0     pid:151667 tgid:151667 ppid:150522 flags:0x00000002
Call Trace:
 <TASK>
 __schedule+0x213/0x550
 schedule+0x29/0xa0
 schedule_timeout+0xbe/0xd0
 ? queue_delayed_work_on+0x1b/0x30
 ? srcu_gp_start_if_needed+0x33e/0x4a0
 wait_for_completion+0x6d/0x110
 __synchronize_srcu.part.0+0x6f/0x80
 ? get_rcu_tasks_trace_gp_kthread+0x10/0x10
 __dm_suspend+0x50/0x180 [dm_mod]
 ? table_deps+0x1b0/0x1b0 [dm_mod]
 dm_suspend+0xaf/0xd0 [dm_mod]
 dev_suspend+0x186/0x2d0 [dm_mod]
 ? table_deps+0x1b0/0x1b0 [dm_mod]
 ctl_ioctl+0x2e1/0x570 [dm_mod]
 dm_ctl_ioctl+0x5/0x10 [dm_mod]
 __x64_sys_ioctl+0x85/0xa0
 do_syscall_64+0x3c/0x110
 entry_SYSCALL_64_after_hwframe+0x46/0x4e
 </TASK>

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: c467e97f079f ("md/raid6: use valid sector values to determine if an I/O should wait on the reshape")
Cc: stable@vger.kernel.org	# v6.1+

---
 drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.orig/drivers/md/raid5.c
+++ linux-2.6/drivers/md/raid5.c
@@ -5851,7 +5851,7 @@ static bool stripe_ahead_of_reshape(stru
 			continue;
 
 		min_sector = min(min_sector, sh->dev[dd_idx].sector);
-		max_sector = max(max_sector, sh->dev[dd_idx].sector);
+		max_sector = min(max_sector, sh->dev[dd_idx].sector);
 	}
 
 	spin_lock_irq(&conf->device_lock);

