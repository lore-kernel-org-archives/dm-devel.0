Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D0F13C9F4
	for <dm-devel@lists.linux.dev>; Thu, 29 Feb 2024 15:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709221808; cv=none; b=LdUrUUR5OErzwJlHWenqwzFj1NfLg5RA66GkJwhHJtrLHrfFv7mF9ypBjvX77pFI7wmKS0w3Kc4+bUQpWmVq4vxBwB02FAlEPE+3Q/xWhz3w0dPwkq4UQR/a2xEDhCeXKNiXm+hxaZbd4AoJ8bSlc+z0dGrBiPyqB1KBieIlr9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709221808; c=relaxed/simple;
	bh=pAvQfBq5JEbKKzt67taGpxkFXHje80f2n/ZZC6yHfq4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HJLzP/vMWJR54fQkR7vnLxuaUJkJBl4wL9tFfd02eGk9bJMRNNHBLd+PlitV4sbHTtShpABkDyWK3GcJxRUbE0XVnIUFYrPaoGhe4CVTLWmviHOg46yG+GYRpydy3x8/wFqEdBS3JUp2Olq8g7JE3iIOKIht2t1uM5GagSxwq1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QuTExpUl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QuTExpUl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709221805;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZlVfP7NvFLEr+ZESpyoIezolwSzXWil2f/AjEcRQ9TE=;
	b=QuTExpUlcLlWVaW3vhIvaN6eJYFZSdVEdkD1gYyA8H4iQi7AyJciMHZqmUiamPGdh78PR7
	FnMhOOXME9kRa6Wk3agsbl7x7ZV09odqO478LDbkGFiynxBXQP0KV9BkSD+UTzm/Z1HC8e
	PNcpFbsv1yAh5T2XyzegONQePER307o=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-115-wHv-TnnmMFaWWhymVuHBtw-1; Thu,
 29 Feb 2024 10:50:04 -0500
X-MC-Unique: wHv-TnnmMFaWWhymVuHBtw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3CE532812FF0;
	Thu, 29 Feb 2024 15:50:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.8])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BB497C185C0;
	Thu, 29 Feb 2024 15:50:00 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 4/6] dm-raid/md: Clear MD_RECOVERY_WAIT when stopping dmraid
Date: Thu, 29 Feb 2024 23:49:39 +0800
Message-Id: <20240229154941.99557-5-xni@redhat.com>
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

MD_RECOVERY_WAIT is used by dmraid to delay reshape process by patch
commit 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock").
Before patch commit f52f5c71f3d4b ("md: fix stopping sync thread")
dmraid stopped sync thread directy by calling md_reap_sync_thread.
After this patch dmraid stops sync thread asynchronously as md does.
This is right. Now the dmraid stop process is like this:

1. raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_thread.
stop_sync_thread sets MD_RECOVERY_INTR and wait until MD_RECOVERY_RUNNING
is cleared
2. md_do_sync finds MD_RECOVERY_WAIT is set and return. (This is the
root cause for this deadlock. We hope md_do_sync can set MD_RECOVERY_DONE)
3. md thread calls md_check_recovery (This is the place to reap sync
thread. Because MD_RECOVERY_DONE is not set. md thread can't reap sync
thread)
4. raid_dtr stops/free struct mddev and release dmraid related resources

dmraid only sets MD_RECOVERY_WAIT but doesn't clear it. It needs to clear
this bit when stopping the dmraid before stopping sync thread.

But the deadlock still can happen sometimes even MD_RECOVERY_WAIT is
cleared before stopping sync thread. It's the reason stop_sync_thread only
wakes up task. If the task isn't running, it still needs to wake up sync
thread too.

This deadlock can be reproduced 100% by these commands:
modprobe brd rd_size=34816 rd_nr=5
while [ 1 ]; do
vgcreate test_vg /dev/ram*
lvcreate --type raid5 -L 16M -n test_lv test_vg
lvconvert -y --stripes 4 /dev/test_vg/test_lv
vgremove test_vg -ff
sleep 1
done

Fixes: 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")
Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/dm-raid.c | 2 ++
 drivers/md/md.c      | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index eb009d6bb03a..325767c1140f 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3796,6 +3796,8 @@ static void raid_postsuspend(struct dm_target *ti)
 	struct raid_set *rs = ti->private;
 
 	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
+		if (test_bit(MD_RECOVERY_WAIT, &rs->md.recovery))
+			clear_bit(MD_RECOVERY_WAIT, &rs->md.recovery);
 		/* Writes have to be stopped before suspending to avoid deadlocks. */
 		if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
 			md_stop_writes(&rs->md);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 79dfc015c322..f264749be28b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4908,6 +4908,7 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
 	 * never happen
 	 */
 	md_wakeup_thread_directly(mddev->sync_thread);
+	md_wakeup_thread(mddev->sync_thread);
 	if (work_pending(&mddev->sync_work))
 		flush_work(&mddev->sync_work);
 
-- 
2.32.0 (Apple Git-132)

