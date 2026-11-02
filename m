Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793626314;
	b=VnG6k9pWdpvrF6EQHOalWxicHQJBmJBxBdx5P/Rp/RYd7lDjP9VNXdArq2l0eVFSnQli
	 YHWnZWoMlUd9OK1Tnzs+7MXyYjn3ijmZBEF/QuYUWjapa/55FV3elboTjnZZSvmpU3coB
	 Luh7mbgXTKPTiK579m+DYzYejQy4ld4Sz0rk/o1CZ8D/SS2IC+MFyZ9DBjQH5kshx0LMt
	 ZLUVRUGCFgh1PNrsRp/8aMzMT4s2U4C4tMkMtSFU9dEY7UjW/W+PFn2nxO+Le8BTwNpLF
	 y0jEcgBm9YueeQrL2sVAaOu9LLSob1e0rzAzD3DFiuFn52cu/gZgHzyDZ3Kxh8CuWcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793626314;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:cc:Subject:
	 In-Reply-To:Message-ID:References:MIME-Version:X-Scanned-By:
	 X-Mimecast-MFC-PROC-ID:X-Mimecast-Originator:Content-Type;
	bh=hnPB6euaz3l9Eqtz7WhTh9m/aNcF7JByTI5Br7bduOc=;
	b=hAuLrfCyNqYlxNqmXCDyi/n/ktiy1/0v2hftE/UI37TJ7eAjlL2qdGHeeqy/XueJoR52
	 4Cu6D3aqQILGXOh3cvoW0Seb08KvvYLQSeqUwVFzqqjI/v6mAb5o+dEAm/cDltZzk89H9
	 9I+O4lKjUEKeghsi67Io7HO+yX+jA+WM3PKXmJSr5yjXPT2ehgB2M4sgoXkScNtFKq5VK
	 r5tiFkKDmD1w+rxbto5DRoQxechF/zLYGNNoSHI1+kIIQXqWgiy6qx4kiQrNPLbTTnn7p
	 VrmiaK2dNGeiW4kr09Rftls/U79Lbr0vHBZnLkwdlJIRl++ssfrNFj3Yyx45TB52tMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="U74H/4kH";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A768D606A327
	for <dm-devel@lists.linux.dev>; Mon,  2 Nov 2026 13:31:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A768D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=U74H/4kH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793626312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hnPB6euaz3l9Eqtz7WhTh9m/aNcF7JByTI5Br7bduOc=;
	b=U74H/4kH8bg+NZdhQY8wGG5wz/vlyTXy6+a6tKclRLEMsEiIMRqZVImq25FR0RQ/XZNPLH
	nIz0IPqUJOpr+VWtpbxMqkCaCKfyxkjA+HcPoCQdeKjA2qI2X5rtT/VH0TipvCT52IJeu2
	AYfPUYthmRmGD0UA11ViVGzawtHp4xU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-557-80JaAku5Ny-FyKAB5gNciQ-1; Mon,
 02 Nov 2026 08:31:49 -0500
X-MC-Unique: 80JaAku5Ny-FyKAB5gNciQ-1
X-Mimecast-MFC-AGG-ID: 80JaAku5Ny-FyKAB5gNciQ_1793626308
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 097091955D71;
	Mon,  2 Nov 2026 13:31:48 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0A14F1956087;
	Mon,  2 Nov 2026 13:31:45 +0000 (UTC)
Date: Mon, 2 Nov 2026 14:31:43 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: syzbot <syzbot+41e0d7cdfb1ecfc4a007@syzkaller.appspotmail.com>
cc: agk@redhat.com, bmarzins@redhat.com, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org, snitzer@kernel.org, 
    syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [dm?] BUG: unable to handle kernel NULL pointer
 dereference in dm_bufio_client_create
In-Reply-To: <6ae78418.6552420f.2a0efc.005b.GAE@google.com>
Message-ID: <04bd28f4-c839-f2b1-5a9a-a7df330a5ba0@redhat.com>
References: <6ae78418.6552420f.2a0efc.005b.GAE@google.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: Pq2OsxX6gbybM4bpJdm5SZquPdVjjPJ54S6f44lOdRo_1793626308
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Sun, 1 Nov 2026, syzbot wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    abf8c33470f7 Merge tag 'spi-fix-v7.4-merge-window' of git:..
> git tree:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux master
> console output: https://syzkaller.appspot.com/x/log.txt?x=1578f6ea580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b38f05ed2b645c41
> dashboard link: https://syzkaller.appspot.com/bug?extid=41e0d7cdfb1ecfc4a007
> compiler:       arm-linux-gnueabi-gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> userspace arch: arm
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fc4be0580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134c528d580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-abf8c334.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/dc6a6b2fa900/vmlinux-abf8c334.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/a24896395af6/zImage-abf8c334.xz
> 
> AI-generated root cause summary:
> In drivers/md/dm-thin.c, pool_ctr() attempts to ensure metadata and data devices
> are distinct by checking strcmp(argv[0], argv[1]), which fails when different
> path strings resolve to the same device. When the pool is created with read_only
> mode, dm_get_device() opens the metadata device as read-only, and the subsequent
> open of the data device as read-write invokes upgrade_mode() in
> drivers/md/dm-table.c, which frees the old table device via
> dm_put_table_device(). This leaves metadata_dev as a dangling pointer
> (use-after-free); when metadata_dev->bdev is subsequently read as NULL from the
> freed slab entry and passed to dm_bufio_client_create(), dereferencing
> bdev->bd_dev causes an immediate kernel NULL pointer dereference.
> 
> full analysis:  https://syzkaller.appspot.com/x/ai_root_cause?x=41e0d7cdfb1ecfc4a007
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+41e0d7cdfb1ecfc4a007@syzkaller.appspotmail.com

Hi

Does this patch fix it?

Mikulas



From 6eb66b7887fc04b9917b6868ea5361b39db7af07 Mon Sep 17 00:00:00 2001
From: Ming-Hung Tsai <mtsai@redhat.com>
Date: Fri, 30 Oct 2026 17:16:18 +0800
Subject: [PATCH 1/2] dm: fix use-after-free when dm_get_device() widens the
 open mode

There's an UAF bug in dm_get_device(): when a table construction calls
dm_get_device() on the same device twice with widen access mode (e.g.,
read-only first then read-write), the second dm_get_device() calls
upgrade_mode(), which reopens the device in upgraded mode, making
previously returned dm_dev* a stale pointer.

Fixing approaches:
- Add per-mode views (dm_dev_ref) from a per-device dm_dev_internal to
  multiple table_devices.
- Keep reusing the dm_dev_ref when the requested mode is included, i.e.,
  a read-only reference can reuse the read-write opened device within a
  table.
- Maintain a canonical block_device pointer in dm_dev_internal for
  handling the DM_TABLE_DEPS ioctl.

Also tweak the way of mode sharing check in find_ref() to
"(x & mask) == mask". The result stays the same to the previous
upgrade_mode() guard "(x | mask) == x".

Pros: keep the relationship between dm_dev_internal and table_device:
one dm_dev_internal per device, regardless the mode, so the output of
DMM_TABLE_DEPS ioctl unchanged.

Cons: extra dm_dev_ref allocation.

Note that now the table_device's count not necessarily mean the number
tables referecing this <dev, mode> pair, since we're allowing multiple
references within a table.

Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>
---
 drivers/md/dm-ioctl.c |   2 +-
 drivers/md/dm-table.c | 142 +++++++++++++++++++++++-------------------
 drivers/md/dm.c       |   2 +-
 drivers/md/dm.h       |  18 +++++-
 4 files changed, 98 insertions(+), 66 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 8f945f0aeda5..4a7cb0926c17 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1794,7 +1794,7 @@ static void retrieve_deps(struct dm_table *table,
 	deps->count = count;
 	count = 0;
 	list_for_each_entry(dd, dm_table_get_devices(table), list)
-		deps->dev[count++] = huge_encode_dev(dd->dm_dev->bdev->bd_dev);
+		deps->dev[count++] = huge_encode_dev(dd->bdev->bd_dev);
 
 	param->data_size = param->data_start + needed;
 }
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a483f49dd4ce..db1ec4ae8e56 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -165,14 +165,16 @@ int dm_table_create(struct dm_table **result, blk_mode_t mode,
 
 static void free_devices(struct list_head *devices, struct mapped_device *md)
 {
-	struct list_head *tmp, *next;
-
-	list_for_each_safe(tmp, next, devices) {
-		struct dm_dev_internal *dd =
-		    list_entry(tmp, struct dm_dev_internal, list);
-		DMWARN("%s: dm_table_destroy: dm_put_device call missing for %s",
-		       dm_device_name(md), dd->dm_dev->name);
-		dm_put_table_device(md, dd->dm_dev);
+	struct dm_dev_internal *dd, *dd_next;
+	struct dm_dev_ref *ref, *ref_next;
+
+	list_for_each_entry_safe(dd, dd_next, devices, list) {
+		list_for_each_entry_safe(ref, ref_next, &dd->refs, list) {
+			DMWARN("%s: dm_table_destroy: dm_put_device call missing for %s",
+			       dm_device_name(md), ref->dm_dev->name);
+			dm_put_table_device(md, ref->dm_dev);
+			kfree(ref);
+		}
 		kfree(dd);
 	}
 }
@@ -218,12 +220,27 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
 	struct dm_dev_internal *dd;
 
 	list_for_each_entry(dd, l, list)
-		if (dd->dm_dev->bdev->bd_dev == dev)
+		if (dd->bdev->bd_dev == dev)
 			return dd;
 
 	return NULL;
 }
 
+/*
+ * See if the device is already open with a mode that covers the
+ * requested one.
+ */
+static struct dm_dev_ref *find_ref(struct dm_dev_internal *dd, blk_mode_t mode)
+{
+	struct dm_dev_ref *ref;
+
+	list_for_each_entry(ref, &dd->refs, list)
+		if ((ref->dm_dev->mode & mode) == mode)
+			return ref;
+
+	return NULL;
+}
+
 /*
  * If possible, this checks an area of a destination device is invalid.
  */
@@ -303,31 +320,6 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	return 0;
 }
 
-/*
- * This upgrades the mode on an already open dm_dev, being
- * careful to leave things as they were if we fail to reopen the
- * device and not to touch the existing bdev field in case
- * it is accessed concurrently.
- */
-static int upgrade_mode(struct dm_dev_internal *dd, blk_mode_t new_mode,
-			struct mapped_device *md)
-{
-	int r;
-	struct dm_dev *old_dev, *new_dev;
-
-	old_dev = dd->dm_dev;
-
-	r = dm_get_table_device(md, dd->dm_dev->bdev->bd_dev,
-				dd->dm_dev->mode | new_mode, &new_dev);
-	if (r)
-		return r;
-
-	dd->dm_dev = new_dev;
-	dm_put_table_device(md, old_dev);
-
-	return 0;
-}
-
 /*
  * Note: the __ref annotation is because this function can call the __init
  * marked early_lookup_bdev when called during early boot code from dm-init.c.
@@ -360,7 +352,9 @@ EXPORT_SYMBOL(dm_devt_from_path);
 
 /*
  * Add a device to the list, or just increment the usage count if
- * it's already present.
+ * it's already present with a mode that covers the requested one.
+ * Otherwise open the device again with the requested mode, so the
+ * dm_devs returned earlier stay valid.
  */
 int dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
 		  struct dm_dev **result)
@@ -368,6 +362,7 @@ int dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
 	int r;
 	dev_t dev;
 	struct dm_dev_internal *dd;
+	struct dm_dev_ref *ref;
 	struct dm_table *t = ti->table;
 
 	BUG_ON(!t);
@@ -380,30 +375,46 @@ int dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
 		return -EINVAL;
 
 	dd = find_device(&t->devices, dev);
-	if (!dd) {
+	if (dd) {
+		ref = find_ref(dd, mode);
+		if (ref) {
+			refcount_inc(&ref->count);
+			goto out;
+		}
+	} else {
 		dd = kmalloc_obj(*dd);
 		if (!dd)
 			return -ENOMEM;
+		INIT_LIST_HEAD(&dd->refs);
+	}
 
-		r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev);
-		if (r) {
-			kfree(dd);
-			return r;
-		}
+	ref = kmalloc_obj(*ref);
+	if (!ref) {
+		r = -ENOMEM;
+		goto bad;
+	}
 
-		refcount_set(&dd->count, 1);
-		list_add(&dd->list, &t->devices);
-		goto out;
+	r = dm_get_table_device(t->md, dev, mode, &ref->dm_dev);
+	if (r) {
+		kfree(ref);
+		goto bad;
+	}
+	refcount_set(&ref->count, 1);
 
-	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
-		r = upgrade_mode(dd, mode, t->md);
-		if (r)
-			return r;
+	/* A device in the list always has at least one ref */
+	if (list_empty(&dd->refs)) {
+		dd->bdev = ref->dm_dev->bdev;
+		list_add(&dd->list, &t->devices);
 	}
-	refcount_inc(&dd->count);
+	list_add_tail(&ref->list, &dd->refs);
 out:
-	*result = dd->dm_dev;
+	*result = ref->dm_dev;
 	return 0;
+
+bad:
+	if (list_empty(&dd->refs))
+		kfree(dd);
+	return r;
 }
 EXPORT_SYMBOL(dm_get_device);
 
@@ -453,23 +464,28 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
  */
 void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 {
-	int found = 0;
 	struct list_head *devices = &ti->table->devices;
 	struct dm_dev_internal *dd;
+	struct dm_dev_ref *ref;
 
-	list_for_each_entry(dd, devices, list) {
-		if (dd->dm_dev == d) {
-			found = 1;
-			break;
-		}
-	}
-	if (!found) {
-		DMERR("%s: device %s not in table devices list",
-		      dm_device_name(ti->table->md), d->name);
+	list_for_each_entry(dd, devices, list)
+		list_for_each_entry(ref, &dd->refs, list)
+			if (ref->dm_dev == d)
+				goto found;
+
+	DMERR("%s: device %s not in table devices list",
+	      dm_device_name(ti->table->md), d->name);
+	return;
+
+found:
+	if (!refcount_dec_and_test(&ref->count))
 		return;
-	}
-	if (refcount_dec_and_test(&dd->count)) {
-		dm_put_table_device(ti->table->md, d);
+
+	dm_put_table_device(ti->table->md, d);
+	list_del(&ref->list);
+	kfree(ref);
+
+	if (list_empty(&dd->refs)) {
 		list_del(&dd->list);
 		kfree(dd);
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index eb9e32995b79..1fff84b3f869 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1588,7 +1588,7 @@ static void __send_empty_flush(struct clone_info *ci)
 			 */
 			clone = alloc_tio(ci, NULL, 0, &len, GFP_NOIO);
 			atomic_add(1, &ci->io->io_count);
-			bio_set_dev(clone, dd->dm_dev->bdev);
+			bio_set_dev(clone, dd->bdev);
 			clone->bi_end_io = clone_endio;
 			dm_submit_bio_remap(clone, NULL);
 		}
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 7a795979ec72..34f58060243f 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -37,10 +37,26 @@
 
 /*
  * List of devices that a metadevice uses and should open/close.
+ * There is one dm_dev_internal per device. It holds one dm_dev_ref
+ * for each mode that the targets opened the device with.
  */
 struct dm_dev_internal {
 	struct list_head list;
-	refcount_t count;
+	struct block_device *bdev;
+	struct list_head refs;
+};
+
+/*
+ * One open of a device with one mode, shared by the targets of a table.
+ * dm_get_device() reuses a dm_dev_ref whose mode covers the requested
+ * mode, and adds a new one only when none does. So the dm_dev_refs of
+ * a device have different modes, and a table holds each table_device
+ * at most once. table_device->count is still the number of tables that
+ * use the table_device.
+ */
+struct dm_dev_ref {
+	struct list_head list;
+	refcount_t count;	/* dm_get_device() calls that returned dm_dev */
 	struct dm_dev *dm_dev;
 };
 
-- 
2.49.0

