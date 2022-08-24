Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C1FC00140
	for <dm-devel@archiver.kernel.org>; Wed, 24 Aug 2022 11:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1661340366;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=a3NapiKt+rs0yACLqpC4bg/l8C8LwDWuqYAbWrVK9Gs=;
	b=imS+k9cVX4CCk/sK65rG2k9lBiVlt9RodMTXDY5y3rejXMZp2c7uW7SQtCSIxwKnqKq2QD
	MwACsn75O1zN3I80CnLXR6spV1qtYDQDEoog8YtBBOyaaD9uwGpTFHCTW+w+SZAM7BbceN
	TtouzE1kH029wxwAoZWVW7Uhvpn1iY0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-82gKPce6Nt6Ck5mHtqRCjQ-1; Wed, 24 Aug 2022 07:26:03 -0400
X-MC-Unique: 82gKPce6Nt6Ck5mHtqRCjQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 36A0F18A6532;
	Wed, 24 Aug 2022 11:26:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E0F972166B26;
	Wed, 24 Aug 2022 11:25:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A1FDD1946A5E;
	Wed, 24 Aug 2022 11:25:59 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 80CBE1946A42
 for <dm-devel@listman.corp.redhat.com>; Wed, 24 Aug 2022 11:25:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 71B9C40D2832; Wed, 24 Aug 2022 11:25:57 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com
 (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C1D140D2830;
 Wed, 24 Aug 2022 11:25:57 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id
 27OBPvnh031799; Wed, 24 Aug 2022 07:25:57 -0400
Received: from localhost (mpatocka@localhost)
 by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP
 id 27OBPvxu031795; Wed, 24 Aug 2022 07:25:57 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka
 owned process doing -bs
Date: Wed, 24 Aug 2022 07:25:57 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Message-ID: <alpine.LRH.2.02.2208240723580.31584@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: [dm-devel] [PATCH] dm: change DMWARN to DMERR
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: dm-devel@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Change DMWARN to DMERR in cases when there is an unrecoverable error.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -434,10 +434,10 @@ static struct mapped_device *dm_hash_ren
 		hc = __get_name_cell(new);
 
 	if (hc) {
-		DMWARN("Unable to change %s on mapped device %s to one that "
-		       "already exists: %s",
-		       change_uuid ? "uuid" : "name",
-		       param->name, new);
+		DMERR("Unable to change %s on mapped device %s to one that "
+		      "already exists: %s",
+		      change_uuid ? "uuid" : "name",
+		      param->name, new);
 		dm_put(hc->md);
 		up_write(&_hash_lock);
 		kfree(new_data);
@@ -449,8 +449,8 @@ static struct mapped_device *dm_hash_ren
 	 */
 	hc = __get_name_cell(param->name);
 	if (!hc) {
-		DMWARN("Unable to rename non-existent device, %s to %s%s",
-		       param->name, change_uuid ? "uuid " : "", new);
+		DMERR("Unable to rename non-existent device, %s to %s%s",
+		      param->name, change_uuid ? "uuid " : "", new);
 		up_write(&_hash_lock);
 		kfree(new_data);
 		return ERR_PTR(-ENXIO);
@@ -460,9 +460,9 @@ static struct mapped_device *dm_hash_ren
 	 * Does this device already have a uuid?
 	 */
 	if (change_uuid && hc->uuid) {
-		DMWARN("Unable to change uuid of mapped device %s to %s "
-		       "because uuid is already set to %s",
-		       param->name, new, hc->uuid);
+		DMERR("Unable to change uuid of mapped device %s to %s "
+		      "because uuid is already set to %s",
+		      param->name, new, hc->uuid);
 		dm_put(hc->md);
 		up_write(&_hash_lock);
 		kfree(new_data);
@@ -750,7 +750,7 @@ static int get_target_version(struct fil
 static int check_name(const char *name)
 {
 	if (strchr(name, '/')) {
-		DMWARN("invalid device name");
+		DMERR("invalid device name");
 		return -EINVAL;
 	}
 
@@ -773,7 +773,7 @@ static struct dm_table *dm_get_inactive_
 	down_read(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
-		DMWARN("device has been removed from the dev hash table.");
+		DMERR("device has been removed from the dev hash table.");
 		goto out;
 	}
 
@@ -1026,7 +1026,7 @@ static int dev_rename(struct file *filp,
 	if (new_data < param->data ||
 	    invalid_str(new_data, (void *) param + param_size) || !*new_data ||
 	    strlen(new_data) > (change_uuid ? DM_UUID_LEN - 1 : DM_NAME_LEN - 1)) {
-		DMWARN("Invalid new mapped device name or uuid string supplied.");
+		DMERR("Invalid new mapped device name or uuid string supplied.");
 		return -EINVAL;
 	}
 
@@ -1061,7 +1061,7 @@ static int dev_set_geometry(struct file
 
 	if (geostr < param->data ||
 	    invalid_str(geostr, (void *) param + param_size)) {
-		DMWARN("Invalid geometry supplied.");
+		DMERR("Invalid geometry supplied.");
 		goto out;
 	}
 
@@ -1069,13 +1069,13 @@ static int dev_set_geometry(struct file
 		   indata + 1, indata + 2, indata + 3, &dummy);
 
 	if (x != 4) {
-		DMWARN("Unable to interpret geometry settings.");
+		DMERR("Unable to interpret geometry settings.");
 		goto out;
 	}
 
 	if (indata[0] > 65535 || indata[1] > 255 ||
 	    indata[2] > 255 || indata[3] > ULONG_MAX) {
-		DMWARN("Geometry exceeds range limits.");
+		DMERR("Geometry exceeds range limits.");
 		goto out;
 	}
 
@@ -1388,7 +1388,7 @@ static int populate_table(struct dm_tabl
 	char *target_params;
 
 	if (!param->target_count) {
-		DMWARN("populate_table: no targets specified");
+		DMERR("populate_table: no targets specified");
 		if (ti_error)
 			*ti_error = "no targets specified";
 		return -EINVAL;
@@ -1398,7 +1398,7 @@ static int populate_table(struct dm_tabl
 
 		r = next_target(spec, next, end, &spec, &target_params);
 		if (r) {
-			DMWARN("unable to find target");
+			DMERR("unable to find target");
 			if (ti_error)
 				*ti_error = "unable to find target";
 			return r;
@@ -1409,7 +1409,7 @@ static int populate_table(struct dm_tabl
 					(sector_t) spec->length,
 					target_params, ti_error);
 		if (r) {
-			DMWARN("error adding target to table");
+			DMERR("error adding target to table");
 			return r;
 		}
 
@@ -1462,8 +1462,8 @@ static int table_load(struct file *filp,
 	if (immutable_target_type &&
 	    (immutable_target_type != dm_table_get_immutable_target_type(t)) &&
 	    !dm_table_get_wildcard_target(t)) {
-		DMWARN("can't replace immutable target type %s",
-		       immutable_target_type->name);
+		DMERR("can't replace immutable target type %s",
+		      immutable_target_type->name);
 		r = -EINVAL;
 		ti_error = "can't replace immutable target";
 		goto err_unlock_md_type;
@@ -1473,13 +1473,13 @@ static int table_load(struct file *filp,
 		/* setup md->queue to reflect md's type (may block) */
 		r = dm_setup_md_queue(md, t);
 		if (r) {
-			DMWARN("unable to set up device queue for new table.");
+			DMERR("unable to set up device queue for new table.");
 			ti_error = "unable to set up device queue for new table";
 			goto err_unlock_md_type;
 		}
 	} else if (!is_valid_type(dm_get_md_type(md), dm_table_get_type(t))) {
-		DMWARN("can't change device type (old=%u vs new=%u) after initial table load.",
-		       dm_get_md_type(md), dm_table_get_type(t));
+		DMERR("can't change device type (old=%u vs new=%u) after initial table load.",
+		      dm_get_md_type(md), dm_table_get_type(t));
 		r = -EINVAL;
 		ti_error = "can't change device type after initial table load";
 		goto err_unlock_md_type;
@@ -1491,7 +1491,7 @@ static int table_load(struct file *filp,
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
-		DMWARN("device has been removed from the dev hash table.");
+		DMERR("device has been removed from the dev hash table.");
 		up_write(&_hash_lock);
 		r = -ENXIO;
 		ti_error = "device has been removed from the dev hash table";
@@ -1703,19 +1703,19 @@ static int target_message(struct file *f
 
 	if (tmsg < (struct dm_target_msg *) param->data ||
 	    invalid_str(tmsg->message, (void *) param + param_size)) {
-		DMWARN("Invalid target message parameters.");
+		DMERR("Invalid target message parameters.");
 		r = -EINVAL;
 		goto out;
 	}
 
 	r = dm_split_args(&argc, &argv, tmsg->message);
 	if (r) {
-		DMWARN("Failed to split target message parameters");
+		DMERR("Failed to split target message parameters");
 		goto out;
 	}
 
 	if (!argc) {
-		DMWARN("Empty message received.");
+		DMERR("Empty message received.");
 		r = -EINVAL;
 		goto out_argv;
 	}
@@ -1735,12 +1735,12 @@ static int target_message(struct file *f
 
 	ti = dm_table_find_target(table, tmsg->sector);
 	if (!ti) {
-		DMWARN("Target message sector outside device.");
+		DMERR("Target message sector outside device.");
 		r = -EINVAL;
 	} else if (ti->type->message)
 		r = ti->type->message(ti, argc, argv, result, maxlen);
 	else {
-		DMWARN("Target type does not support messages");
+		DMERR("Target type does not support messages");
 		r = -EINVAL;
 	}
 
@@ -1831,11 +1831,11 @@ static int check_version(unsigned int cm
 
 	if ((DM_VERSION_MAJOR != version[0]) ||
 	    (DM_VERSION_MINOR < version[1])) {
-		DMWARN("ioctl interface mismatch: "
-		       "kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
-		       DM_VERSION_MAJOR, DM_VERSION_MINOR,
-		       DM_VERSION_PATCHLEVEL,
-		       version[0], version[1], version[2], cmd);
+		DMERR("ioctl interface mismatch: "
+		      "kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
+		      DM_VERSION_MAJOR, DM_VERSION_MINOR,
+		      DM_VERSION_PATCHLEVEL,
+		      version[0], version[1], version[2], cmd);
 		r = -EINVAL;
 	}
 
@@ -1944,11 +1944,11 @@ static int validate_params(uint cmd, str
 
 	if (cmd == DM_DEV_CREATE_CMD) {
 		if (!*param->name) {
-			DMWARN("name not supplied when creating device");
+			DMERR("name not supplied when creating device");
 			return -EINVAL;
 		}
 	} else if (*param->uuid && *param->name) {
-		DMWARN("only supply one of name or uuid, cmd(%u)", cmd);
+		DMERR("only supply one of name or uuid, cmd(%u)", cmd);
 		return -EINVAL;
 	}
 
@@ -1995,7 +1995,7 @@ static int ctl_ioctl(struct file *file,
 
 	fn = lookup_ioctl(cmd, &ioctl_flags);
 	if (!fn) {
-		DMWARN("dm_ctl_ioctl: unknown command 0x%x", command);
+		DMERR("dm_ctl_ioctl: unknown command 0x%x", command);
 		return -ENOTTY;
 	}
 
@@ -2220,7 +2220,7 @@ int __init dm_early_create(struct dm_ioc
 					(sector_t) spec_array[i]->length,
 					target_params_array[i], NULL);
 		if (r) {
-			DMWARN("error adding target to table");
+			DMERR("error adding target to table");
 			goto err_destroy_table;
 		}
 	}
@@ -2233,7 +2233,7 @@ int __init dm_early_create(struct dm_ioc
 	/* setup md->queue to reflect md's type (may block) */
 	r = dm_setup_md_queue(md, t);
 	if (r) {
-		DMWARN("unable to set up device queue for new table.");
+		DMERR("unable to set up device queue for new table.");
 		goto err_destroy_table;
 	}
 
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -234,12 +234,12 @@ static int device_area_is_invalid(struct
 		return 0;
 
 	if ((start >= dev_size) || (start + len > dev_size)) {
-		DMWARN("%s: %pg too small for target: "
-		       "start=%llu, len=%llu, dev_size=%llu",
-		       dm_device_name(ti->table->md), bdev,
-		       (unsigned long long)start,
-		       (unsigned long long)len,
-		       (unsigned long long)dev_size);
+		DMERR("%s: %pg too small for target: "
+		      "start=%llu, len=%llu, dev_size=%llu",
+		      dm_device_name(ti->table->md), bdev,
+		      (unsigned long long)start,
+		      (unsigned long long)len,
+		      (unsigned long long)dev_size);
 		return 1;
 	}
 
@@ -251,10 +251,10 @@ static int device_area_is_invalid(struct
 		unsigned int zone_sectors = bdev_zone_sectors(bdev);
 
 		if (start & (zone_sectors - 1)) {
-			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %pg",
-			       dm_device_name(ti->table->md),
-			       (unsigned long long)start,
-			       zone_sectors, bdev);
+			DMERR("%s: start=%llu not aligned to h/w zone size %u of %pg",
+			      dm_device_name(ti->table->md),
+			      (unsigned long long)start,
+			      zone_sectors, bdev);
 			return 1;
 		}
 
@@ -268,10 +268,10 @@ static int device_area_is_invalid(struct
 		 * the sector range.
 		 */
 		if (len & (zone_sectors - 1)) {
-			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %pg",
-			       dm_device_name(ti->table->md),
-			       (unsigned long long)len,
-			       zone_sectors, bdev);
+			DMERR("%s: len=%llu not aligned to h/w zone size %u of %pg",
+			      dm_device_name(ti->table->md),
+			      (unsigned long long)len,
+			      zone_sectors, bdev);
 			return 1;
 		}
 	}
@@ -280,20 +280,20 @@ static int device_area_is_invalid(struct
 		return 0;
 
 	if (start & (logical_block_size_sectors - 1)) {
-		DMWARN("%s: start=%llu not aligned to h/w "
-		       "logical block size %u of %pg",
-		       dm_device_name(ti->table->md),
-		       (unsigned long long)start,
-		       limits->logical_block_size, bdev);
+		DMERR("%s: start=%llu not aligned to h/w "
+		      "logical block size %u of %pg",
+		      dm_device_name(ti->table->md),
+		      (unsigned long long)start,
+		      limits->logical_block_size, bdev);
 		return 1;
 	}
 
 	if (len & (logical_block_size_sectors - 1)) {
-		DMWARN("%s: len=%llu not aligned to h/w "
-		       "logical block size %u of %pg",
-		       dm_device_name(ti->table->md),
-		       (unsigned long long)len,
-		       limits->logical_block_size, bdev);
+		DMERR("%s: len=%llu not aligned to h/w "
+		      "logical block size %u of %pg",
+		      dm_device_name(ti->table->md),
+		      (unsigned long long)len,
+		      limits->logical_block_size, bdev);
 		return 1;
 	}
 
@@ -434,8 +434,8 @@ void dm_put_device(struct dm_target *ti,
 		}
 	}
 	if (!found) {
-		DMWARN("%s: device %s not in table devices list",
-		       dm_device_name(ti->table->md), d->name);
+		DMERR("%s: device %s not in table devices list",
+		      dm_device_name(ti->table->md), d->name);
 		return;
 	}
 	if (refcount_dec_and_test(&dd->count)) {
@@ -618,12 +618,12 @@ static int validate_hardware_logical_blo
 	}
 
 	if (remaining) {
-		DMWARN("%s: table line %u (start sect %llu len %llu) "
-		       "not aligned to h/w logical block size %u",
-		       dm_device_name(t->md), i,
-		       (unsigned long long) ti->begin,
-		       (unsigned long long) ti->len,
-		       limits->logical_block_size);
+		DMERR("%s: table line %u (start sect %llu len %llu) "
+		      "not aligned to h/w logical block size %u",
+		      dm_device_name(t->md), i,
+		      (unsigned long long) ti->begin,
+		      (unsigned long long) ti->len,
+		      limits->logical_block_size);
 		return -EINVAL;
 	}
 
@@ -1013,7 +1013,7 @@ static int dm_table_alloc_md_mempools(st
 	struct dm_md_mempools *pools;
 
 	if (unlikely(type == DM_TYPE_NONE)) {
-		DMWARN("no table type is set, can't allocate mempools");
+		DMERR("no table type is set, can't allocate mempools");
 		return -EINVAL;
 	}
 
@@ -1117,7 +1117,7 @@ static bool integrity_profile_exists(str
  * Get a disk whose integrity profile reflects the table's profile.
  * Returns NULL if integrity support was inconsistent or unavailable.
  */
-static struct gendisk * dm_table_get_integrity_disk(struct dm_table *t)
+static struct gendisk *dm_table_get_integrity_disk(struct dm_table *t)
 {
 	struct list_head *devices = dm_table_get_devices(t);
 	struct dm_dev_internal *dd = NULL;
@@ -1190,10 +1190,10 @@ static int dm_table_register_integrity(s
 	 * profile the new profile should not conflict.
 	 */
 	if (blk_integrity_compare(dm_disk(md), template_disk) < 0) {
-		DMWARN("%s: conflict with existing integrity profile: "
-		       "%s profile mismatch",
-		       dm_device_name(t->md),
-		       template_disk->disk_name);
+		DMERR("%s: conflict with existing integrity profile: "
+		      "%s profile mismatch",
+		      dm_device_name(t->md),
+		      template_disk->disk_name);
 		return 1;
 	}
 
@@ -1332,7 +1332,7 @@ static int dm_table_construct_crypto_pro
 	if (t->md->queue &&
 	    !blk_crypto_has_capabilities(profile,
 					 t->md->queue->crypto_profile)) {
-		DMWARN("Inline encryption capabilities of new DM table were more restrictive than the old table's. This is not supported!");
+		DMERR("Inline encryption capabilities of new DM table were more restrictive than the old table's. This is not supported!");
 		dm_destroy_crypto_profile(profile);
 		return -EINVAL;
 	}
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -1149,7 +1149,7 @@ static void clone_endio(struct bio *bio)
 			/* The target will handle the io */
 			return;
 		default:
-			DMWARN("unimplemented target endio return value: %d", r);
+			DMCRIT("unimplemented target endio return value: %d", r);
 			BUG();
 		}
 	}
@@ -1455,7 +1455,7 @@ static void __map_bio(struct bio *clone)
 			dm_io_dec_pending(io, BLK_STS_DM_REQUEUE);
 		break;
 	default:
-		DMWARN("unimplemented target map return value: %d", r);
+		DMCRIT("unimplemented target map return value: %d", r);
 		BUG();
 	}
 }
@@ -2005,7 +2005,7 @@ static struct mapped_device *alloc_dev(i
 
 	md = kvzalloc_node(sizeof(*md), GFP_KERNEL, numa_node_id);
 	if (!md) {
-		DMWARN("unable to allocate device, out of memory.");
+		DMERR("unable to allocate device, out of memory.");
 		return NULL;
 	}
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

