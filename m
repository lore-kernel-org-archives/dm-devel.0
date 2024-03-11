Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E93FB93
	for <dm-devel@lists.linux.dev>; Mon, 11 Mar 2024 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710166003; cv=none; b=rzSSLN94P/c23m2FAyXaYewwCjWUBbHI07YjvG/grekfmrO2cXeGJxUIIYrXVmVcc0yKSFE7x9jBiuZtvbuyGAMlgqID9wBrrhZBSV1l/r24ChZ7c9VYWgxV4TZE/9acjeWvNAYej0X7Qa8+uUV1gzEg75iuJ5X10qz2g8KfWOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710166003; c=relaxed/simple;
	bh=6TGySk3//r4mDpNKHznMt4SDT4rmWub/qQPe9gB0SUE=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=fAjpvtR+fnPWYF2Gm9mDvi80Kwfe1N8yNspBy+QpCiykOtoFspiKr9Sq+sogvhhvwmHrhEWuSYPHbksPup3eCiyMBzd3B78VJAT1tMdjSx+88z8UMiZzAlxEN8xpgFZj1GfFJUY5ioxo6RL4Vi7tYiH32hCyrlQeEhb2ZfY1pZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YwD1Fbcy; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YwD1Fbcy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710166001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=5gvtpmaoeTiXdciD+siGJxCL01B+T22dOGqz+DFU9to=;
	b=YwD1FbcyZGIJ/sn+TcpCl1OVNFmxe08v07njNUzgHaj9dqp9t6IhfSl/1O+ZWcZav9um7t
	xwme0AIrzpiC9KeodyzCsSdD9oUOLcXpCFp3aDMpCvlI3QDaghtfa0Jj0/nDrdlnCUOEPy
	c3cqOUScyw48U5+R3x5KOqcIXw869Zo=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-372-wddmyVkONGyRUIV1wH_xOA-1; Mon,
 11 Mar 2024 10:06:39 -0400
X-MC-Unique: wddmyVkONGyRUIV1wH_xOA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3340E3C0D7B0
	for <dm-devel@lists.linux.dev>; Mon, 11 Mar 2024 14:06:39 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D849492BCD;
	Mon, 11 Mar 2024 14:06:39 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id 1B8AC30C1B93; Mon, 11 Mar 2024 14:06:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id 104813FB4E;
	Mon, 11 Mar 2024 15:06:39 +0100 (CET)
Date: Mon, 11 Mar 2024 15:06:39 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: call the resume method on internal suspend
Message-ID: <8a586fe0-26b9-ddea-ca62-ad401b631bae@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

There is this reported crash when experimenting with the lvm2 testsuite.
The list corruption is caused by the fact that the postsuspend and resume
methods were not paired correctly; there were two consecutive calls to the
origin_postsuspend function. The second call attempts to remove the
"hash_list" entry from a list, while it was already removed by the first
call.

This patch fixes __dm_internal_resume, so that it calls the preresume and
resume methods of the table's targets.

If a preresume method of some target fails, we are in a tricky situation.
We can't return an error because dm_internal_resume isn't supposed to
return errors. We can't return success, because then the "resume" and
"postsuspend" methods would not be paired correctly. So, we set the
DMF_SUSPENDED flag and we fake normal suspend - it may confuse userspace
tools, but it won't cause a kernel crash.

------------[ cut here ]------------
kernel BUG at lib/list_debug.c:56!
invalid opcode: 0000 [#1] PREEMPT SMP
CPU: 1 PID: 8343 Comm: dmsetup Not tainted 6.8.0-rc6 #4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
RIP: 0010:__list_del_entry_valid_or_report+0x77/0xc0
Code: 50 94 81 e8 eb 65 d4 ff 0f 0b 48 89 fe 48 c7 c7 d0 50 94 81 e8 da 65 d4 ff 0f 0b 48 89 fe 48 c7 c7 00 51 94 81 e8 c9 65 d4 ff <0f> 0b 48 89 fe 48 89 ca 48 c7 c7 38 51 94 81 e8 b5 65 d4 ff 0f 0b
RSP: 0018:ffff8881b831bcc0 EFLAGS: 00010282
RAX: 000000000000004e RBX: ffff888143b6eb80 RCX: 0000000000000000
RDX: 0000000000000001 RSI: ffffffff819053d0 RDI: 00000000ffffffff
RBP: ffff8881b83a3400 R08: 00000000fffeffff R09: 0000000000000058
R10: 0000000000000000 R11: ffffffff81a24080 R12: 0000000000000001
R13: ffff88814538e000 R14: ffff888143bc6dc0 R15: ffffffffa02e4bb0
FS:  00000000f7c0f780(0000) GS:ffff8893f0a40000(0000) knlGS:0000000000000000
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 0000000057fb5000 CR3: 0000000143474000 CR4: 00000000000006b0
Call Trace:
 <TASK>
 ? die+0x2d/0x80
 ? do_trap+0xeb/0xf0
 ? __list_del_entry_valid_or_report+0x77/0xc0
 ? do_error_trap+0x60/0x80
 ? __list_del_entry_valid_or_report+0x77/0xc0
 ? exc_invalid_op+0x49/0x60
 ? __list_del_entry_valid_or_report+0x77/0xc0
 ? asm_exc_invalid_op+0x16/0x20
 ? table_deps+0x1b0/0x1b0 [dm_mod]
 ? __list_del_entry_valid_or_report+0x77/0xc0
 origin_postsuspend+0x1a/0x50 [dm_snapshot]
 dm_table_postsuspend_targets+0x34/0x50 [dm_mod]
 dm_suspend+0xd8/0xf0 [dm_mod]
 dev_suspend+0x1f2/0x2f0 [dm_mod]
 ? table_deps+0x1b0/0x1b0 [dm_mod]
 ctl_ioctl+0x300/0x5f0 [dm_mod]
 dm_compat_ctl_ioctl+0x7/0x10 [dm_mod]
 __x64_compat_sys_ioctl+0x104/0x170
 do_syscall_64+0x184/0x1b0
 entry_SYSCALL_64_after_hwframe+0x46/0x4e
RIP: 0033:0xf7e6aead
Code: 04 25 18 00 00 00 89 44 24 1c 31 c0 8d 44 24 60 c7 04 24 10 00 00 00 89 44 24 08 8d 44 24 20 89 44 24 0c b8 02 02 00 40 0f 05 <3d> 00 f0 ff ff 77 1c 8b 54 24 1c 64 2b 14 25 18 00 00 00 75 29 83
RSP: 002b:00000000ffcfbbf0 EFLAGS: 00000246 ORIG_RAX: 0000000040000202
RAX: ffffffffffffffda RBX: 0000000057fb2370 RCX: 00000000f7e6aead
RDX: 0000000057fb24f0 RSI: 00000000c138fd06 RDI: 0000000000000003
RBP: 0000000000000019 R08: 000000000000ffff R09: 0000000000000000
R10: 00000000f7e1b390 R11: 0000000000000246 R12: 0000000057fb2520
R13: 0000000057fb25a0 R14: 0000000000000000 R15: 0000000057fb24f0
 </TASK>
Modules linked in: dm_snapshot brd dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio dm_mod uvesafb cfbfillrect cfbimgblt fb_io_fops cn cfbcopyarea fb font fbdev autofs4 tun binfmt_misc af_packet ipv6 configfs mousedev virtio_net net_failover virtio_rng failover rng_core virtio_balloon pcspkr qemu_fw_cfg button raid10 raid456 libcrc32c async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod sd_mod t10_pi crc64_rocksoft crc64 crc_t10dif virtio_scsi scsi_mod evdev psmouse bsg scsi_common
---[ end trace 0000000000000000 ]---

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2024-03-11 12:54:20.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2024-03-11 12:54:20.000000000 +0100
@@ -2945,6 +2945,9 @@ static void __dm_internal_suspend(struct
 
 static void __dm_internal_resume(struct mapped_device *md)
 {
+	int r;
+	struct dm_table *map;
+
 	BUG_ON(!md->internal_suspend_count);
 
 	if (--md->internal_suspend_count)
@@ -2953,11 +2956,23 @@ static void __dm_internal_resume(struct
 	if (dm_suspended_md(md))
 		goto done; /* resume from nested suspend */
 
-	/*
-	 * NOTE: existing callers don't need to call dm_table_resume_targets
-	 * (which may fail -- so best to avoid it for now by passing NULL map)
-	 */
-	(void) __dm_resume(md, NULL);
+	map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
+	r = __dm_resume(md, map);
+	if (r) {
+		/*
+		 * If a preresume method of some target failed, we are in a
+		 * tricky situation. We can't return an error to the caller. We
+		 * can't fake success because then the "resume" and
+		 * "postsuspend" methods would not be paired correctly, and it
+		 * would break various targets, for example it would cause list
+		 * corruption in the "origin" target.
+		 *
+		 * So, we fake normal suspend here, to make sure that the
+		 * "resume" and "postsuspend" methods will be paired correctly.
+		 */
+		DMERR("Preresume method failed: %d", r);
+		set_bit(DMF_SUSPENDED, &md->flags);
+	}
 
 done:
 	clear_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);

