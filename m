Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793019081;
	b=F3e+UMJXRVys82Ve6QzZL3s1IR7wXH7HLdbir+XHubeZ5BZUTDQtUUeal0MMmkEJslF5
	 vC7CwQH1WJvWKkOaKZf2V3IMKC6ciP14mgUrgFBVY+Is1Oh2nzH/aW6DSsDZBZkOGCGm0
	 HX23z0E6CBPDnsKsEkTkHs9gTCtiV5yhIjd1UK9Qn8uDtumzwKaHhIrUicXcygDDzvjLK
	 Q3wNwmnTha4Q5UrckZQb/im7HnwGUwkIvVHVKmyFIFdgBEX96Q1Zt16OZ9gMca02SzsB2
	 xm4Xa0ygbYAFn1jBgmL3qsWjmwCl907Amq4c+7w7i2vQARy9SUe4edfHnx5pmO5LR3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793019081;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=AyJwyUEzaLqYdxznGDAau4i6Ab2C6BDv4m/n+Yvt084=;
	b=R1RUKOVbKXcvDyH2ah1fSsAh1LXXfQpT6qsOBG/8PIyL5Sv1ZpDQm2ciQvSVvc2HgvPq
	 Ku+i1acpUlWCa07hWQUMVpu8Io+pbLz+SPg5LBHY44WcNKHArB8rWYbGto3SNDdGuQn8x
	 PHO9MqDODGO9RB52E6ZyGzLFzNZr9KS+w3kH82zCDi7AK4vePbFpZOx+3iNCdoaRtNawT
	 zON5uqAaDX6iyNq2mNh83LI6TqNpCDoR8vWarSFnWx/OeVbaB5fC44C82oczR5AsqcYFo
	 +Q3rko4kRK76GL3L4QOqcNxuk2dcF5hi27gfyWgi/hZCLWSRs8MAgD5eBwkWUTXuwbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=O+onSR53;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58470606A322
	for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 12:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 58470606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=O+onSR53
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e0d1da913so2358871f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 26 Oct 2026 05:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793019080; x=1793623880; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AyJwyUEzaLqYdxznGDAau4i6Ab2C6BDv4m/n+Yvt084=;
        b=O+onSR53/V8uikF+UtaUiCHO7vLTiC52Tmt87pcqiCmnOCqXk/giyNI+3jM5u3oyOz
         tkKgNMy6Frf8gp7oN869v1B6b3R3cLQWQaDtGncwIeqsnjXcBwL6H6W7C4/K9jE37yKl
         d8YKSwpf2Ul+o3nZp+ZRBUoKBOiUvUognVMcNxKBq5kiK7vO/AWMxo3I5JWlvL0016Ob
         KKbd+KxkXJQYXHRALhYllXrVoYYkuWG1tGDN7NSZiJI3C9nTJxMYe5LXK4S0VgDtkc3Q
         3mscyT5s5qlYvc1HiCtFCc6PkNAXRTnOK7yBD9/M35YeYhqm4qMyUKPmjSyXu1xr+KIk
         aZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793019080; x=1793623880;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AyJwyUEzaLqYdxznGDAau4i6Ab2C6BDv4m/n+Yvt084=;
        b=y4l2KgsjAvsC2T4XDtIFlrkTYg90tf1L6lPehOF+wW/nxZ/ta8LkfIqz+YoW67gMZX
         6/LHv2i6h8pUo2gVUbtnwQV/H5KivcNzML8AZn62Axp18bJKMo5rer42ptVl1XXIAse6
         q3738bzE4G3rYjCTmjJ7yBicbN8nn0p0R9Y1QTU8jT/t2j1T6Xu37q+3GQ+ZHt8Zo+x+
         RT681hXSwtwXKEtv1lqd6rrK71JKsgJha7HqoXlnXaprhGIhzlaUhWLd4EIWDHxGRkif
         lQTlkm3W9uu+F/wPQDLYyYmDm40YVynoL71TaRRK1AkRJAqtAmci2bjzWb5QiqJNHOAQ
         nvYw==
X-Gm-Message-State: AFq9FYLZPbzRXrAV2qb64A2HsQiUlfDQOR80U/fYylEwV3JsYRWp8bHr
	lwC46l2CwJh7ADEfahYGSbxy+6clW7LtQNQZoW+TwBLyqZv3Mk8qsUdN
X-Gm-Gg: AYBFou0dfXujmu4Ixv45LogPlkCKaXiYeuzzfLlJv7AZlwtdD6T16oqC1oZitVUN6a5
	FQbVckcIX4AICW9OONXnBD6byvqzP1RhLO5CkPFi1giu5As0jfHaJHhbOvtfXFILVXDPCZYciXO
	kXpl6AsW1/AZexGxo1DkwH3h0kpqLsulLXWGOjouXFValg1h6sWNLMJjq2IPjzyVXYAtNY83hRG
	/g0yjakPfozqR86HSdEFJ234m454yje7IfbeI4V2nqFzcEcBzuv0/a+dLeuv7TBIk+Au2f28t8g
	g7AWRnJJ+YNx58h6qJLsBn4ip3adWQ3bmOqQqjYIhWZFrcadp9kv3AslXAJ73Ef5Cql+RsU7vwY
	SNrOpSr4afthTHN/HXIwhNKm8kciqG2nLOvnpBCMTjJwONREYNRUiIWzG5+VQc7kJmEYcDabyxK
	063g0/VstBMa16/HXjnKjRe+wIsVkJfiA4M9EopSzFInC6LpxMvG63Z/3lticLg3mERiFi12OqO
	/n4BiVWkHhIoSGM8V+qhloWWXBIv1B20ePhuxnBg6mwYEvvl3pe1NrrLTAcvmUBVFrJ7wCk7dS/
	VXIpmZOSNDpfvOVWW1DWaTREhU9eRQ==
X-Received: by 2002:a5d:6308:0:b0:48a:fff3:f9c1 with SMTP id ffacd0b85a97d-48e3eb87c2amr9417775f8f.20.1793019079507;
        Mon, 26 Oct 2026 05:51:19 -0700 (PDT)
Received: from DESKTOP-IR7J1S9.localdomain ([129.45.79.200])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3dd7sm15828994f8f.15.2026.10.26.05.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 05:51:19 -0700 (PDT)
From: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	jason.cai.kern@gmail.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>,
	syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: [PATCH] dm: reject aliased metadata/data and pool/origin devices
Date: Mon, 26 Oct 2026 13:51:14 +0100
Message-ID: <20261026125114.251-1-drifabdelmalekmohamedsaid@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm_get_device() identifies devices by their resolved dev_t, but pool_ctr()
and thin_ctr() only reject identical argument strings.  Different paths
such as "/dev/ram0" and "1:0" therefore bypass the check and select the
same dm_dev_internal.

syzbot reported a slab-use-after-free in pool_ctr() when a read-only pool
used such aliased metadata and data devices.  Opening the metadata device
read-only first and the data device read-write second made upgrade_mode()
replace dd->dm_dev and free the old table_device, leaving metadata_dev
dangling before __pool_find() dereferenced metadata_dev->bdev.

syzbot reported:

BUG: KASAN: slab-use-after-free in pool_ctr+0x874/0xd60 drivers/md/dm-thin.c:3363
Read of size 8 at addr ffff8880340cc698 by task syz.0.17/5507

Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 pool_ctr+0x874/0xd60 drivers/md/dm-thin.c:3363
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]
 dm_ctl_ioctl+0x9ec/0xe10 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

 Allocated by task 5507:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:409 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:426
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __kmalloc_cache_node_noprof+0x3cc/0x620 mm/slub.c:5582
 _kmalloc_node_noprof include/linux/slab.h:1196 [inline]
 open_table_device drivers/md/dm.c:733 [inline]
 dm_get_table_device+0x23e/0x730 drivers/md/dm.c:821
 dm_get_device+0x327/0x760 drivers/md/dm-table.c:388
 pool_ctr+0x4ae/0xd60 drivers/md/dm-thin.c:3329
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]
 dm_ctl_ioctl+0x9ec/0xe10 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5507:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:264 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:296
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2748 [inline]
 slab_free mm/slub.c:6509 [inline]
 kfree+0x1c5/0x650 mm/slub.c:6802
 close_table_device drivers/md/dm.c:798 [inline]
 dm_put_table_device+0x255/0x2a0 drivers/md/dm.c:841
 upgrade_mode drivers/md/dm-table.c:326 [inline]
 dm_get_device+0x56f/0x760 drivers/md/dm-table.c:399
 pool_ctr+0x585/0xd60 drivers/md/dm-thin.c:3336
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]
 dm_ctl_ioctl+0x9ec/0xe10 drivers/md/dm-ioctl.c:2243
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8880340cc680
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 24 bytes inside of
 freed 96-byte region [ffff8880340cc680, ffff8880340cc6e0)

Validate the resolved device numbers with dm_devt_from_path() before either
device is opened, keeping the existing string comparison.  Do this in both
pool_ctr() and thin_ctr(), which has the same problem for the pool and
optional origin devices.  Checking the device identity up front avoids the
mode upgrade entirely and is preferable to switching the dm_get_device()
call order, which would rely on the data mode being a superset of the
metadata mode and would only cover pool_ctr().

Reported-by: syzbot+83827f9a59abe148bff4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83827f9a59abe148bff4
Fixes: 70de2cbda8a5 ("dm thin: add sanity checks to thin-pool and external snapshot creation")
Cc: stable@vger.kernel.org
Signed-off-by: Drif Abdelmalek Mohamed Said <drifabdelmalekmohamedsaid@gmail.com>
---
 drivers/md/dm-thin.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 358ed77ffb2b..281b2e1745c3 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3292,6 +3292,8 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	dm_block_t low_water_blocks;
 	struct dm_dev *metadata_dev;
 	blk_mode_t metadata_mode;
+	dev_t metadata_devt;
+	dev_t data_devt;
 
 	/*
 	 * FIXME Remove validation from scope of lock.
@@ -3314,6 +3316,22 @@ static int pool_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto out_unlock;
 	}
 
+	r = dm_devt_from_path(argv[0], &metadata_devt);
+	if (r) {
+		ti->error = "Error opening metadata block device";
+		goto out_unlock;
+	}
+	r = dm_devt_from_path(argv[1], &data_devt);
+	if (r) {
+		ti->error = "Error opening metadata data device";
+		goto out_unlock;
+	}
+	if (metadata_devt == data_devt) {
+		ti->error = "Error setting metadata or data device";
+		r = -EINVAL;
+		goto out_unlock;
+	}
+
 	/*
 	 * Set default pool features.
 	 */
@@ -4204,12 +4222,30 @@ static int thin_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	tc->sort_bio_list = RB_ROOT;
 
 	if (argc == 3) {
+		dev_t pool_devt;
+		dev_t origin_devt;
 		if (!strcmp(argv[0], argv[2])) {
 			ti->error = "Error setting origin device";
 			r = -EINVAL;
 			goto bad_origin_dev;
 		}
 
+		r = dm_devt_from_path(argv[0], &pool_devt);
+		if (r) {
+			ti->error = "Error opening metadata block device";
+			goto out_unlock;
+		}
+		r = dm_devt_from_path(argv[2], &origin_devt);
+		if (r) {
+			ti->error = "Error opening metadata data device";
+			goto out_unlock;
+		}
+		if (pool_devt == origin_devt) {
+			ti->error = "Error setting metadata or data device";
+			r = -EINVAL;
+			goto out_unlock;
+		}
+
 		r = dm_get_device(ti, argv[2], BLK_OPEN_READ, &origin_dev);
 		if (r) {
 			ti->error = "Error opening origin device";
-- 
2.43.0

