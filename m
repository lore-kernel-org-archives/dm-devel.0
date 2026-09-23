Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C0A48EC9C
	for <dm-devel@lists.linux.dev>; Wed, 23 Sep 2026 10:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790160042; cv=none; b=peqp7IlYL7EtxX+SOWGa/MNXP0XugD2C8kPr7iGDtG8HTB0Rp7GEXyS0WxJ8NkCbXZx6G2Gfg5UviFJi8bRYoA6GOmEsi1RLShUOyAOllEWt49wBX1ANFmtZ5pbR4N4mrfKLTFBMZX+eVSWSndKs0c5b4AgqoDhRDmQaXl0ISVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790160042; c=relaxed/simple;
	bh=F+m84QqqXacroWCTsYeKNP/qEXKau0g3zSSzoRwISMQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=E7ppqOKu3EOggZWa7Gk5aIxvtx3lnTlrNXBDMCX7C+tZuGNn0QHm1Lt9NiHnv3l4CrKcwri1jMs1TRs9A7Mwotkj+q7uPqF4B+NrcI6HQkQ7hmgHkOwNkM6cUO7T8CBiHUb0lRPIiJCBWZRHTeFMHKn3NqrTNiTdm0gbq+jL6Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eMOdrTxQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eMOdrTxQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790160025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qsbU2klqOU4AkrpB7wgb+gvXqw2vPrnZCTT54y86F8w=;
	b=eMOdrTxQwMZXF0DrmDBQRzPHkM7rIVaaJxl8jJ3oMV90J3NOB/3VMC9iQbPzwCZx1c3Hjk
	SpXf+g38/b0vu1Z8JrtLeYczmLGkeTOy0RCdwEmbT8QL5ivNnByy7gwj3pWtRVCoLsCVvO
	Co4JqAUxrZwJ/p0q/609jAZDcs3QHY0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-691-iwf49hb1NJ2FyfDttVrKtQ-1; Wed,
 23 Sep 2026 06:40:22 -0400
X-MC-Unique: iwf49hb1NJ2FyfDttVrKtQ-1
X-Mimecast-MFC-AGG-ID: iwf49hb1NJ2FyfDttVrKtQ_1790160021
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4078118009DB;
	Wed, 23 Sep 2026 10:40:21 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3956B300106E;
	Wed, 23 Sep 2026 10:40:19 +0000 (UTC)
Date: Wed, 23 Sep 2026 12:40:16 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: syzbot <syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com>
cc: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, snitzer@kernel.org, 
    syzkaller-bugs@googlegroups.com
Subject: [PATCH] dm: fix reading free memory in do_resume
In-Reply-To: <6ab2989e.a6af0033.177e91.0022.GAE@google.com>
Message-ID: <57ed5386-c4a4-af9c-053b-14ce7a0f75f1@redhat.com>
References: <6ab2989e.a6af0033.177e91.0022.GAE@google.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: a8Z4ZfWoyDqwVX1iVvBSafNG411TAUUhCyIlgbuSwhU_1790160021
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Tue, 22 Sep 2026, syzbot wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    38872197cae2 Merge branch 'for-next/fixes' into for-kernelci
> git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
> console output: https://syzkaller.appspot.com/x/log.txt?x=116dd805580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=56ed23170c168d4c
> dashboard link: https://syzkaller.appspot.com/bug?extid=bdff1ecf726d2af66afd
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> userspace arch: arm64
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14e8f805580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17efe805580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/c5963fdd6790/disk-38872197.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/a8c2cab00c45/vmlinux-38872197.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/bde15d173380/Image-38872197.gz.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com

Hi

Here I'm sending a patch for this bug. Could you recheck it?

Mikulas



From: Mikulas Patocka <mpatocka@redhat.com>

When do_resume calls dm_table_get_mode(new_map), the call is done without
holding any locks (it only holds a reference to the md). It may be
possible that another concurrent ioctl on the same device will swap table
after dm_swap_table and before dm_table_get_mode. In this case,
dm_table_get_mode(new_map) reads freed memory.

This race condition was triggered by syzbot.

This commit fixes the race by reading mode of the new table before
dm_swap_table. Note that new_map is also passed to dm_ima_need_measure,
but this function doesn't attempt to dereference it, so this call should
be safe.

Note that this is not a security bug because only root can trigger it and
the commonly used tools such as lvm or cryptsetup do not call the ioctls
concurrently, so that they can't trigger it acceidentally.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: syzbot+bdff1ecf726d2af66afd@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org

---
 drivers/md/dm-ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -1267,6 +1267,7 @@ static int do_resume(struct dm_ioctl *pa
 	/* Do we need to load a new map ? */
 	if (new_map) {
 		sector_t old_size, new_size;
+		blk_mode_t new_map_mode;
 
 		dm_ima_context_table_op(md, ima_context, DM_IMA_TABLE_SAVE);
 		/* Suspend if it isn't already suspended */
@@ -1299,6 +1300,7 @@ static int do_resume(struct dm_ioctl *pa
 			}
 		}
 
+		new_map_mode = dm_table_get_mode(new_map);
 		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
@@ -1314,7 +1316,7 @@ static int do_resume(struct dm_ioctl *pa
 		if (old_size && new_size && old_size != new_size)
 			need_resize_uevent = true;
 
-		if (dm_table_get_mode(new_map) & BLK_OPEN_WRITE)
+		if (new_map_mode & BLK_OPEN_WRITE)
 			set_disk_ro(dm_disk(md), 0);
 		else
 			set_disk_ro(dm_disk(md), 1);

