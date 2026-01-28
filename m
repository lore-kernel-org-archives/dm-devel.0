Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF87C2BB13
	for <dm-devel@lists.linux.dev>; Wed, 28 Jan 2026 00:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769559153; cv=none; b=JoRtFFSFMFwg8h+T2LYyjWzkXfi26xNMG4nZI3COkzQ5+yqcw/rifHBsssUn1Y9uM5gfi1fZd97jftuOI8/jsf5VL9IKJQ1SghEIm56z1G054aRgCrBQLnfd6txIUVYUyLNOH+0uDoMJJ5ZhjKmDYzmKGQT1d4e5pnWeAwfgTNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769559153; c=relaxed/simple;
	bh=+6Oh8OhsITv1eVwQ8yUtXuGZbXuCQ+CNqLjzlIJaSaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ZqiTTwYMTcddWwFy3+rMLJggNst0EjApwkshsYTk3mR20mpDJNHLcHMlSQ1LkrosmEoSWi0NkM49ovuPntMEgWTCeobqjQdWzG/xbStA8jycAU3IhHjyykl1twivRqWhv7AMYOlFx6RYEvoUW+Sr2MMymbARmSkTUpJ8PMNwahw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RiSijN1D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RiSijN1D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769559150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0v2KePrnF9zirJTPVM2TmlS5oFDwK0abt3MbCx1AInI=;
	b=RiSijN1Dwh1SDxbk+G+Gf3ZI89z3QVq5o1Kv4Z0ZouQldTr4ckC1zBZICKurs7oI4Pzxlw
	f3DduCK1906Yd/+P9L7Qr4qUsM5DXhI0BTEE7JHpfbmKkzJLo4nEk+8Yqs6h5RofKzg4SD
	N5vo1Nupu4OleL74LwoSCmpb3j5rW/c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-zBbEknyQMdyB0KI9yqtIow-1; Tue,
 27 Jan 2026 19:12:27 -0500
X-MC-Unique: zBbEknyQMdyB0KI9yqtIow-1
X-Mimecast-MFC-AGG-ID: zBbEknyQMdyB0KI9yqtIow_1769559146
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75CC619775A3;
	Wed, 28 Jan 2026 00:12:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27BEF19560B2;
	Wed, 28 Jan 2026 00:12:26 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 60S0CPFj462766
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 19:12:25 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 60S0CPmG462765;
	Tue, 27 Jan 2026 19:12:25 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: Martin Wilck <mwilck@suse.com>, dm-devel@lists.linux.dev
Subject: [PATCH 2/3] Revert "dm: fix a race condition in retrieve_deps"
Date: Tue, 27 Jan 2026 19:12:23 -0500
Message-ID: <20260128001224.462746-3-bmarzins@redhat.com>
In-Reply-To: <20260128001224.462746-1-bmarzins@redhat.com>
References: <20260128001224.462746-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1IiKu8QN0GI2kkAy7uKwdFQ4WvYZ3bSrZi_ctvZxAgc_1769559146
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

This reverts commit f6007dce0cd35d634d9be91ef3515a6385dcee16.

Commit f6007dce0cd3 ("dm: fix a race condition in retrieve_deps") was
added to fix a race between retrieving the list of dm table devices and
multipath_message() modifying the list of table devices. But Commit
a48f6b82c5c4 ("dm mpath: don't call dm_get_device in multipath_message")
removed the call to dm_get_device() from multipath_message(). After that
commit, the only calls to dm_get_device() and dm_put_device() are in
target constructors and destructors, so the race with retrieve_deps() is
no longer possible.

Suggested-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-core.h  |  1 -
 drivers/md/dm-ioctl.c |  7 +------
 drivers/md/dm-table.c | 32 ++++++++------------------------
 3 files changed, 9 insertions(+), 31 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 1cda8618d74d..a3b8ad6e1c42 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -215,7 +215,6 @@ struct dm_table {
 
 	/* a list of devices used by this table */
 	struct list_head devices;
-	struct rw_semaphore devices_lock;
 
 	/* events get handed up using this callback */
 	void (*event_fn)(void *data);
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 4165fef4c170..fd4bf8e1d73e 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1648,8 +1648,6 @@ static void retrieve_deps(struct dm_table *table,
 	struct dm_dev_internal *dd;
 	struct dm_target_deps *deps;
 
-	down_read(&table->devices_lock);
-
 	deps = get_result_buffer(param, param_size, &len);
 
 	/*
@@ -1664,7 +1662,7 @@ static void retrieve_deps(struct dm_table *table,
 	needed = struct_size(deps, dev, count);
 	if (len < needed) {
 		param->flags |= DM_BUFFER_FULL_FLAG;
-		goto out;
+		return;
 	}
 
 	/*
@@ -1676,9 +1674,6 @@ static void retrieve_deps(struct dm_table *table,
 		deps->dev[count++] = huge_encode_dev(dd->dm_dev->bdev->bd_dev);
 
 	param->data_size = param->data_start + needed;
-
-out:
-	up_read(&table->devices_lock);
 }
 
 static int table_deps(struct file *filp, struct dm_ioctl *param, size_t param_size)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4b70872725d0..7be1d8dc8bdd 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -139,7 +139,6 @@ int dm_table_create(struct dm_table **result, blk_mode_t mode,
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&t->devices);
-	init_rwsem(&t->devices_lock);
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -380,20 +379,16 @@ int dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
 	if (dev == disk_devt(t->md->disk))
 		return -EINVAL;
 
-	down_write(&t->devices_lock);
-
 	dd = find_device(&t->devices, dev);
 	if (!dd) {
 		dd = kmalloc(sizeof(*dd), GFP_KERNEL);
-		if (!dd) {
-			r = -ENOMEM;
-			goto unlock_ret_r;
-		}
+		if (!dd)
+			return -ENOMEM;
 
 		r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev);
 		if (r) {
 			kfree(dd);
-			goto unlock_ret_r;
+			return r;
 		}
 
 		refcount_set(&dd->count, 1);
@@ -403,17 +398,12 @@ int dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
 	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
-			goto unlock_ret_r;
+			return r;
 	}
 	refcount_inc(&dd->count);
 out:
-	up_write(&t->devices_lock);
 	*result = dd->dm_dev;
 	return 0;
-
-unlock_ret_r:
-	up_write(&t->devices_lock);
-	return r;
 }
 EXPORT_SYMBOL(dm_get_device);
 
@@ -464,12 +454,9 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 {
 	int found = 0;
-	struct dm_table *t = ti->table;
-	struct list_head *devices = &t->devices;
+	struct list_head *devices = &ti->table->devices;
 	struct dm_dev_internal *dd;
 
-	down_write(&t->devices_lock);
-
 	list_for_each_entry(dd, devices, list) {
 		if (dd->dm_dev == d) {
 			found = 1;
@@ -478,17 +465,14 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 	}
 	if (!found) {
 		DMERR("%s: device %s not in table devices list",
-		      dm_device_name(t->md), d->name);
-		goto unlock_ret;
+		      dm_device_name(ti->table->md), d->name);
+		return;
 	}
 	if (refcount_dec_and_test(&dd->count)) {
-		dm_put_table_device(t->md, d);
+		dm_put_table_device(ti->table->md, d);
 		list_del(&dd->list);
 		kfree(dd);
 	}
-
-unlock_ret:
-	up_write(&t->devices_lock);
 }
 EXPORT_SYMBOL(dm_put_device);
 
-- 
2.50.1

