Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E115915CB
	for <dm-devel@lists.linux.dev>; Thu, 16 May 2024 20:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715892603; cv=none; b=XVJzrwiX7K9yIbdyqD6Aibd56VeioO2vKMYEWPh6LTGfTFF4FfFjpq05M15YZTkc18XkmAHi0d0BLSeGvhljGl+BKOSk4mHbHI59UFCv5C7s/ZDdovScmDeRt4FyNosyRV8eRuZb0Ys51DhqVsMjqn2vqB/dzqQF0ohArDDYynQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715892603; c=relaxed/simple;
	bh=O2ewFUdwq+gbmSDgv62d/vyBToUFpAKRIEjy2L8N0fI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MTIYZX4YM4o1HKggcO11+sG4c1Xe1uG8Xn/mAw7sgMz6dRyINHhJuVybc4mO6j95QdKZyL6D7tdQvWyxO2l9FL0zzcmmH+4R4xH2ivC57qucd6vmF6eHP1383Q9xpLR5Gf/awmwYYi5qnXbNAY7szWR0AtMcFCNGtF7Q6jdQkq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RIBeprdV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RIBeprdV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715892597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O+fAnIIebPuxwkKSzMwnCOwSYdgO9pXZPB02aKazGyo=;
	b=RIBeprdV6qcz0nEXczWv9zJ8VJM4TepWPyDgYaPpjFl3pOBj1iekI9ul8AwIhifDq9s8tD
	0DwPQ0BTXzdjL0uYytqJS4f/wcJD/ud4syQijbgA22hRdbQ5ZqRFdFfyOW8Y3uCoyt97XL
	sDd8qzB0Jrg2eK85bzoTgI/u4Z7vqs0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-330-a75kPsHoM7esCkPxXErHZA-1; Thu,
 16 May 2024 16:49:56 -0400
X-MC-Unique: a75kPsHoM7esCkPxXErHZA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E17043C025C9;
	Thu, 16 May 2024 20:49:55 +0000 (UTC)
Received: from file1-rdu.file-001.prod.rdu2.dc.redhat.com (unknown [10.11.5.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C7B4951BF;
	Thu, 16 May 2024 20:49:55 +0000 (UTC)
Received: by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix, from userid 12668)
	id B336F30C1C33; Thu, 16 May 2024 20:49:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by file1-rdu.file-001.prod.rdu2.dc.redhat.com (Postfix) with ESMTP id AFE453FB4F;
	Thu, 16 May 2024 22:49:55 +0200 (CEST)
Date: Thu, 16 May 2024 22:49:55 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
cc: Yang Yang <yang.yang@vivo.com>, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: [PATCH] dm: optimize flushes
In-Reply-To: <60bd4b9-8edd-7e22-ce8b-e5d0e43da195@redhat.com>
Message-ID: <90f4beb-2e15-3f9-4bc2-0d13872e8ea@redhat.com>
References: <20240514090445.2847-1-yang.yang@vivo.com> <20240514090445.2847-4-yang.yang@vivo.com> <ZkTXzG1yrPmW64Z6@redhat.com> <60bd4b9-8edd-7e22-ce8b-e5d0e43da195@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Device mapper sends flush bios to all the targets and the targets send it
to the underlying device. That may be inefficient, for example if a table
contains 10 linear targets pointing to the same physical device, then
device mapper would send 10 flush bios to that device - despite the fact
that only one bio would be sufficient.

This commit optimizes the flush behavior. It introduces a per-target
variable flush_pass_around - it is set when the target supports flush
optimization - currently, the dm-linear and dm-stripe targets support it.
When all the targets in a table have flush_pass_around, flush_pass_around
on the table is set. __send_empty_flush tests if the table has
flush_pass_around - and if it has, no flush bios are sent to the targets
and the list dm_table->devices is iterated and the flush bios are sent to
each member of the list.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reported-by: Yang Yang <yang.yang@vivo.com>

---
 drivers/md/dm-core.h          |    4 ++-
 drivers/md/dm-linear.c        |    1 
 drivers/md/dm-stripe.c        |    1 
 drivers/md/dm-table.c         |    4 +++
 drivers/md/dm.c               |   47 +++++++++++++++++++++++++++++-------------
 include/linux/device-mapper.h |    5 ++++
 6 files changed, 47 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2024-05-15 16:56:49.000000000 +0200
+++ linux-2.6/drivers/md/dm-core.h	2024-05-15 16:56:49.000000000 +0200
@@ -206,7 +206,9 @@ struct dm_table {
 
 	bool integrity_supported:1;
 	bool singleton:1;
-	unsigned integrity_added:1;
+	bool integrity_added:1;
+	/* set if all the targets in the table have "flush_pass_around" set */
+	bool flush_pass_around:1;
 
 	/*
 	 * Indicates the rw permissions for the new logical device.  This
Index: linux-2.6/drivers/md/dm-linear.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-linear.c	2024-05-15 16:56:49.000000000 +0200
+++ linux-2.6/drivers/md/dm-linear.c	2024-05-15 16:56:49.000000000 +0200
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *
 	ti->num_discard_bios = 1;
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->flush_pass_around = true;
 	ti->private = lc;
 	return 0;
 
Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c	2024-05-15 16:56:49.000000000 +0200
+++ linux-2.6/drivers/md/dm-stripe.c	2024-05-15 16:56:49.000000000 +0200
@@ -157,6 +157,7 @@ static int stripe_ctr(struct dm_target *
 	ti->num_discard_bios = stripes;
 	ti->num_secure_erase_bios = stripes;
 	ti->num_write_zeroes_bios = stripes;
+	ti->flush_pass_around = true;
 
 	sc->chunk_size = chunk_size;
 	if (chunk_size & (chunk_size - 1))
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2024-05-15 16:56:49.000000000 +0200
+++ linux-2.6/drivers/md/dm-table.c	2024-05-15 16:56:49.000000000 +0200
@@ -160,6 +160,7 @@ int dm_table_create(struct dm_table **re
 	t->type = DM_TYPE_NONE;
 	t->mode = mode;
 	t->md = md;
+	t->flush_pass_around = 1;
 	*result = t;
 	return 0;
 }
@@ -738,6 +739,9 @@ int dm_table_add_target(struct dm_table
 	if (ti->limit_swap_bios && !static_key_enabled(&swap_bios_enabled.key))
 		static_branch_enable(&swap_bios_enabled);
 
+	if (!ti->flush_pass_around)
+		t->flush_pass_around = false;
+
 	return 0;
 
  bad:
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h	2024-05-15 16:56:49.000000000 +0200
+++ linux-2.6/include/linux/device-mapper.h	2024-05-15 16:56:49.000000000 +0200
@@ -397,6 +397,11 @@ struct dm_target {
 	 * bio_set_dev(). NOTE: ideally a target should _not_ need this.
 	 */
 	bool needs_bio_set_dev:1;
+
+	/*
+	 * Set if the target supports flush optimization
+	 */
+	bool flush_pass_around:1;
 };
 
 void *dm_per_bio_data(struct bio *bio, size_t data_size);
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2024-05-15 16:56:49.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2024-05-16 20:06:32.000000000 +0200
@@ -645,7 +645,7 @@ static struct bio *alloc_tio(struct clon
 
 	/* Set default bdev, but target must bio_set_dev() before issuing IO */
 	clone->bi_bdev = md->disk->part0;
-	if (unlikely(ti->needs_bio_set_dev))
+	if (likely(ti != NULL) && unlikely(ti->needs_bio_set_dev))
 		bio_set_dev(clone, md->disk->part0);
 
 	if (len) {
@@ -1107,7 +1107,7 @@ static void clone_endio(struct bio *bio)
 	blk_status_t error = bio->bi_status;
 	struct dm_target_io *tio = clone_to_tio(bio);
 	struct dm_target *ti = tio->ti;
-	dm_endio_fn endio = ti->type->end_io;
+	dm_endio_fn endio = likely(ti != NULL) ? ti->type->end_io : NULL;
 	struct dm_io *io = tio->io;
 	struct mapped_device *md = io->md;
 
@@ -1154,7 +1154,7 @@ static void clone_endio(struct bio *bio)
 	}
 
 	if (static_branch_unlikely(&swap_bios_enabled) &&
-	    unlikely(swap_bios_limit(ti, bio)))
+	    likely(ti != NULL) && unlikely(swap_bios_limit(ti, bio)))
 		up(&md->swap_bios_semaphore);
 
 	free_tio(bio);
@@ -1566,17 +1566,36 @@ static void __send_empty_flush(struct cl
 	ci->sector_count = 0;
 	ci->io->tio.clone.bi_iter.bi_size = 0;
 
-	for (unsigned int i = 0; i < t->num_targets; i++) {
-		unsigned int bios;
-		struct dm_target *ti = dm_table_get_target(t, i);
-
-		if (unlikely(ti->num_flush_bios == 0))
-			continue;
-
-		atomic_add(ti->num_flush_bios, &ci->io->io_count);
-		bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
-					     NULL, GFP_NOWAIT);
-		atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
+	if (!t->flush_pass_around) {
+		for (unsigned int i = 0; i < t->num_targets; i++) {
+			unsigned int bios;
+			struct dm_target *ti = dm_table_get_target(t, i);
+
+			if (unlikely(ti->num_flush_bios == 0))
+				continue;
+
+			atomic_add(ti->num_flush_bios, &ci->io->io_count);
+			bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
+						     NULL, GFP_NOWAIT);
+			atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
+		}
+	} else {
+		/*
+		 * Note that there's no need to grab t->devices_lock here
+		 * because the targets that support flush pass-around don't
+		 * modify the list of devices.
+		 */
+		struct list_head *devices = dm_table_get_devices(t);
+		unsigned int len = 0;
+		struct dm_dev_internal *dd;
+		list_for_each_entry(dd, devices, list) {
+			struct bio *clone;
+			clone = alloc_tio(ci, NULL, 0, &len, GFP_NOIO);
+			atomic_add(1, &ci->io->io_count);
+			bio_set_dev(clone, dd->dm_dev->bdev);
+			clone->bi_end_io = clone_endio;
+			dm_submit_bio_remap(clone, NULL);
+		}
 	}
 
 	/*

