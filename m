Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89FD4C636D4
	for <dm-devel@archiver.kernel.org>; Mon, 13 Feb 2023 20:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676319341;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=dhpigT0k0vIDFs++oPEcSDOjixk0oAmbfOlgUe6/OsM=;
	b=dIrZTnbCxdjHZeXbAjm5mMv373zdyVnRnvYKYQb30NIUKoTPdkYF7TCtgxT0ndO7qtc6AO
	5DStCUThUpmNLG7aacaFCXC1WzOHWDeZL7DrfsBcSPnoEPg4C8RLLu7CpGVK/lGtrrzc3W
	cKJDv3YIo+RDm9dDmGcT5keUves47Z0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-426-tn-4gTuZMbemJ3c4pCjuUQ-1; Mon, 13 Feb 2023 15:15:35 -0500
X-MC-Unique: tn-4gTuZMbemJ3c4pCjuUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6ECB638145B1;
	Mon, 13 Feb 2023 20:15:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 591952026D4B;
	Mon, 13 Feb 2023 20:15:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 44A471946588;
	Mon, 13 Feb 2023 20:15:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1643C1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 13 Feb 2023 20:15:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 08ACC140EBF4; Mon, 13 Feb 2023 20:15:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 00CBD140EBF6
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 659E510726D3
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 20:15:11 +0000 (UTC)
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com
 [209.85.160.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-675-DbxyeTz9NLSKshstsIP0pA-3; Mon, 13 Feb 2023 15:15:04 -0500
X-MC-Unique: DbxyeTz9NLSKshstsIP0pA-3
Received: by mail-qt1-f176.google.com with SMTP id g18so15180655qtb.6
 for <dm-devel@redhat.com>; Mon, 13 Feb 2023 12:15:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=content-transfer-encoding:mime-version:references:in-reply-to
 :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
 :subject:date:message-id:reply-to;
 bh=lXQnE0jQXylQc7StXr56Gk4XeUofFa62wdjSBrwD3EY=;
 b=w47tbKWDyL05VIze2fNAm5seCOZs76MCy6ZLWYmQQIgZxjFFY1j8I5q+qxSGy3TqyY
 ycwfPkbcFogrFxVJOpv7p66LNap2re8cpSWkXFDrW2cMuhDkjmDF5vsxyFDu2KxlFBW7
 nKZQ1784/2qISurrP/qd4S0HR5TUf6iLke3U9rvxaZR5uCztUsMLz0HGpCrMr6xBc03p
 FvDnz23W/FmiZc++tSDVKy1AKvZfrcfjOmWopSllZDLBLksi1ef6ErHnkh1yIxgTAnN4
 FYbAUJg4n61FSLctJ/gpv26IpJTDXd00X37WBg5+EOb4rtwG38st1QkBadl6axmQGgAu
 aV5g==
X-Gm-Message-State: AO0yUKWSUymSLBv1BMBPS6L/XpLofGxraSRgo1B36GpDs0IBhkv4gpzw
 aWVdFx7P7rfj1wADPTxWoa3WsujOdluRFUN+ArBbAMxsPWqOp9608W/Psknp5qscCLCBE0JoaN7
 lYNxNBCtOb2QDnYPJxpeckWTPqUKUStS30yzTXCf9n5mM+vPE79etQti3ePJl/7i6N17ArQ==
X-Google-Smtp-Source: AK7set+rfGeJiERAULWp4sUxyIzQ4GjWidcVnPCP71kqorE9X3R6dZjMB+cf4ADIq7Zv6IDDbe0YVw==
X-Received: by 2002:a05:622a:188d:b0:3b9:a441:37f3 with SMTP id
 v13-20020a05622a188d00b003b9a44137f3mr35753317qtc.64.1676319299757; 
 Mon, 13 Feb 2023 12:14:59 -0800 (PST)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net.
 [68.160.166.30]) by smtp.gmail.com with ESMTPSA id
 j190-20020a37b9c7000000b0073912c099cesm7351157qkf.73.2023.02.13.12.14.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 13 Feb 2023 12:14:59 -0800 (PST)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@redhat.com
Date: Mon, 13 Feb 2023 15:13:41 -0500
Message-Id: <20230213201401.45973-20-snitzer@kernel.org>
In-Reply-To: <20230213201401.45973-1-snitzer@kernel.org>
References: <20230213201401.45973-1-snitzer@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 19/39] dm: avoid split of quoted strings where
 possible
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
Cc: ebiggers@kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Heinz Mauelshagen <heinzm@redhat.com>

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-crypt.c                  |  3 +--
 drivers/md/dm-ioctl.c                  |  6 ++----
 drivers/md/dm-log-userspace-transfer.c |  5 ++---
 drivers/md/dm-log.c                    |  3 +--
 drivers/md/dm-raid1.c                  |  7 +++----
 drivers/md/dm-snap-persistent.c        |  6 ++----
 drivers/md/dm-snap-transient.c         |  3 +--
 drivers/md/dm-snap.c                   | 21 +++++++--------------
 drivers/md/dm-stripe.c                 | 12 ++++--------
 drivers/md/dm-table.c                  | 18 ++++++------------
 drivers/md/dm-thin-metadata.c          |  8 ++++----
 drivers/md/dm-zoned-metadata.c         | 12 ++++--------
 12 files changed, 37 insertions(+), 67 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d7c0d54bf212..303f59bea63c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -733,8 +733,7 @@ static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	}
 
 	if (crypto_skcipher_blocksize(any_tfm(cc)) != cc->iv_size) {
-		ti->error = "Block size of EBOIV cipher does "
-			    "not match IV size of block cipher";
+		ti->error = "Block size of EBOIV cipher does not match IV size of block cipher";
 		return -EINVAL;
 	}
 
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 2e2777d502aa..eac73b0d3bfa 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -449,8 +449,7 @@ static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 		hc = __get_name_cell(new);
 
 	if (hc) {
-		DMERR("Unable to change %s on mapped device %s to one that "
-		      "already exists: %s",
+		DMERR("Unable to change %s on mapped device %s to one that already exists: %s",
 		      change_uuid ? "uuid" : "name",
 		      param->name, new);
 		dm_put(hc->md);
@@ -1831,8 +1830,7 @@ static int check_version(unsigned int cmd, struct dm_ioctl __user *user)
 
 	if ((DM_VERSION_MAJOR != version[0]) ||
 	    (DM_VERSION_MINOR < version[1])) {
-		DMERR("ioctl interface mismatch: "
-		      "kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
+		DMERR("ioctl interface mismatch: kernel(%u.%u.%u), user(%u.%u.%u), cmd(%d)",
 		      DM_VERSION_MAJOR, DM_VERSION_MINOR,
 		      DM_VERSION_PATCHLEVEL,
 		      version[0], version[1], version[2], cmd);
diff --git a/drivers/md/dm-log-userspace-transfer.c b/drivers/md/dm-log-userspace-transfer.c
index 55c743056578..d2f363d34684 100644
--- a/drivers/md/dm-log-userspace-transfer.c
+++ b/drivers/md/dm-log-userspace-transfer.c
@@ -109,9 +109,8 @@ static int fill_pkg(struct cn_msg *msg, struct dm_ulog_request *tfr)
 			if (pkg->error != -EAGAIN)
 				*(pkg->data_size) = 0;
 		} else if (tfr->data_size > *(pkg->data_size)) {
-			DMERR("Insufficient space to receive package [%u] "
-			      "(%u vs %zu)", tfr->request_type,
-			      tfr->data_size, *(pkg->data_size));
+			DMERR("Insufficient space to receive package [%u] (%u vs %zu)",
+			      tfr->request_type, tfr->data_size, *(pkg->data_size));
 
 			*(pkg->data_size) = 0;
 			pkg->error = -ENOSPC;
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 9683d683396e..f1bc14b6fd7c 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -389,8 +389,7 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 		else if (!strcmp(argv[1], "nosync"))
 			sync = NOSYNC;
 		else {
-			DMWARN("unrecognised sync argument to "
-			       "dirty region log: %s", argv[1]);
+			DMWARN("unrecognised sync argument to dirty region log: %s", argv[1]);
 			return -EINVAL;
 		}
 	}
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index a71c03591014..4e7bf0fa7659 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -239,8 +239,8 @@ static void fail_mirror(struct mirror *m, enum dm_raid1_error error_type)
 		 * Better to issue requests to same failing device
 		 * than to risk returning corrupt data.
 		 */
-		DMERR("Primary mirror (%s) failed while out-of-sync: "
-		      "Reads may fail.", m->dev->name);
+		DMERR("Primary mirror (%s) failed while out-of-sync: Reads may fail.",
+		      m->dev->name);
 		goto out;
 	}
 
@@ -526,8 +526,7 @@ static void read_callback(unsigned long error, void *context)
 	fail_mirror(m, DM_RAID1_READ_ERROR);
 
 	if (likely(default_ok(m)) || mirror_available(m->ms, bio)) {
-		DMWARN_LIMIT("Read failure on mirror device %s.  "
-			     "Trying alternative device.",
+		DMWARN_LIMIT("Read failure on mirror device %s. Trying alternative device.",
 			     m->dev->name);
 		queue_bio(m->ms, bio, bio_data_dir(bio));
 		return;
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 9258d8bc472d..089ce904b41a 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -358,8 +358,7 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 		return 0;
 
 	if (chunk_size_supplied)
-		DMWARN("chunk size %u in device metadata overrides "
-		       "table chunk size of %u.",
+		DMWARN("chunk size %u in device metadata overrides table chunk size of %u.",
 		       chunk_size, ps->store->chunk_size);
 
 	/* We had a bogus chunk_size. Fix stuff up. */
@@ -966,8 +965,7 @@ int dm_persistent_snapshot_init(void)
 
 	r = dm_exception_store_type_register(&_persistent_compat_type);
 	if (r) {
-		DMERR("Unable to register old-style persistent exception "
-		      "store type");
+		DMERR("Unable to register old-style persistent exception store type");
 		dm_exception_store_type_unregister(&_persistent_type);
 		return r;
 	}
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index 8e1e4b4e14b5..37d76d06eeed 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -143,8 +143,7 @@ int dm_transient_snapshot_init(void)
 
 	r = dm_exception_store_type_register(&_transient_compat_type);
 	if (r) {
-		DMWARN("Unable to register old-style transient "
-		       "exception store type");
+		DMWARN("Unable to register old-style transient exception store type");
 		dm_exception_store_type_unregister(&_transient_type);
 		return r;
 	}
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index fee741b20e78..b0ae8fcbc3b5 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -495,8 +495,7 @@ static int __validate_exception_handover(struct dm_snapshot *snap)
 	if ((__find_snapshots_sharing_cow(snap, &snap_src, &snap_dest,
 					  &snap_merge) == 2) ||
 	    snap_dest) {
-		snap->ti->error = "Snapshot cow pairing for exception "
-				  "table handover failed";
+		snap->ti->error = "Snapshot cow pairing for exception table handover failed";
 		return -EINVAL;
 	}
 
@@ -523,8 +522,7 @@ static int __validate_exception_handover(struct dm_snapshot *snap)
 
 	if (!snap_src->store->type->prepare_merge ||
 	    !snap_src->store->type->commit_merge) {
-		snap->ti->error = "Snapshot exception store does not "
-				  "support snapshot-merge.";
+		snap->ti->error = "Snapshot exception store does not support snapshot-merge.";
 		return -EINVAL;
 	}
 
@@ -943,8 +941,7 @@ static int __remove_single_exception_chunk(struct dm_snapshot *s,
 
 	e = dm_lookup_exception(&s->complete, old_chunk);
 	if (!e) {
-		DMERR("Corruption detected: exception for block %llu is "
-		      "on disk but not in memory",
+		DMERR("Corruption detected: exception for block %llu is on disk but not in memory",
 		      (unsigned long long)old_chunk);
 		return -EINVAL;
 	}
@@ -971,8 +968,7 @@ static int __remove_single_exception_chunk(struct dm_snapshot *s,
 		e->new_chunk++;
 	} else if (old_chunk != e->old_chunk +
 		   dm_consecutive_chunk_count(e)) {
-		DMERR("Attempt to merge block %llu from the "
-		      "middle of a chunk range [%llu - %llu]",
+		DMERR("Attempt to merge block %llu from the middle of a chunk range [%llu - %llu]",
 		      (unsigned long long)old_chunk,
 		      (unsigned long long)e->old_chunk,
 		      (unsigned long long)
@@ -1065,8 +1061,7 @@ static void snapshot_merge_next_chunks(struct dm_snapshot *s)
 						      &new_chunk);
 	if (linear_chunks <= 0) {
 		if (linear_chunks < 0) {
-			DMERR("Read error in exception store: "
-			      "shutting down merge");
+			DMERR("Read error in exception store: shutting down merge");
 			down_write(&s->lock);
 			s->merge_failed = true;
 			up_write(&s->lock);
@@ -2215,12 +2210,10 @@ static int snapshot_preresume(struct dm_target *ti)
 	if (snap_src && snap_dest) {
 		down_read(&snap_src->lock);
 		if (s == snap_src) {
-			DMERR("Unable to resume snapshot source until "
-			      "handover completes.");
+			DMERR("Unable to resume snapshot source until handover completes.");
 			r = -EINVAL;
 		} else if (!dm_suspended(snap_src->ti)) {
-			DMERR("Unable to perform snapshot handover until "
-			      "source is suspended.");
+			DMERR("Unable to perform snapshot handover until source is suspended.");
 			r = -EINVAL;
 		}
 		up_read(&snap_src->lock);
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index e4eb729ee71a..9f203a1790d5 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -109,15 +109,13 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	width = ti->len;
 	if (sector_div(width, stripes)) {
-		ti->error = "Target length not divisible by "
-		    "number of stripes";
+		ti->error = "Target length not divisible by number of stripes";
 		return -EINVAL;
 	}
 
 	tmp_len = width;
 	if (sector_div(tmp_len, chunk_size)) {
-		ti->error = "Target length not divisible by "
-		    "chunk size";
+		ti->error = "Target length not divisible by chunk size";
 		return -EINVAL;
 	}
 
@@ -125,15 +123,13 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 * Do we have enough arguments for that many stripes ?
 	 */
 	if (argc != (2 + 2 * stripes)) {
-		ti->error = "Not enough destinations "
-			"specified";
+		ti->error = "Not enough destinations specified";
 		return -EINVAL;
 	}
 
 	sc = kmalloc(struct_size(sc, stripe, stripes), GFP_KERNEL);
 	if (!sc) {
-		ti->error = "Memory allocation for striped context "
-		    "failed";
+		ti->error = "Memory allocation for striped context failed";
 		return -ENOMEM;
 	}
 
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 58b9198b1c78..fc5b46197407 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -235,8 +235,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 
 	if ((start >= dev_size) || (start + len > dev_size)) {
-		DMERR("%s: %pg too small for target: "
-		      "start=%llu, len=%llu, dev_size=%llu",
+		DMERR("%s: %pg too small for target: start=%llu, len=%llu, dev_size=%llu",
 		      dm_device_name(ti->table->md), bdev,
 		      (unsigned long long)start,
 		      (unsigned long long)len,
@@ -281,8 +280,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 
 	if (start & (logical_block_size_sectors - 1)) {
-		DMERR("%s: start=%llu not aligned to h/w "
-		      "logical block size %u of %pg",
+		DMERR("%s: start=%llu not aligned to h/w logical block size %u of %pg",
 		      dm_device_name(ti->table->md),
 		      (unsigned long long)start,
 		      limits->logical_block_size, bdev);
@@ -290,8 +288,7 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	}
 
 	if (len & (logical_block_size_sectors - 1)) {
-		DMERR("%s: len=%llu not aligned to h/w "
-		      "logical block size %u of %pg",
+		DMERR("%s: len=%llu not aligned to h/w logical block size %u of %pg",
 		      dm_device_name(ti->table->md),
 		      (unsigned long long)len,
 		      limits->logical_block_size, bdev);
@@ -884,8 +881,7 @@ static int dm_table_determine_type(struct dm_table *t)
 			bio_based = 1;
 
 		if (bio_based && request_based) {
-			DMERR("Inconsistent table: different target types"
-			      " can't be mixed up");
+			DMERR("Inconsistent table: different target types can't be mixed up");
 			return -EINVAL;
 		}
 	}
@@ -1188,8 +1184,7 @@ static int dm_table_register_integrity(struct dm_table *t)
 	 * profile the new profile should not conflict.
 	 */
 	if (blk_integrity_compare(dm_disk(md), template_disk) < 0) {
-		DMERR("%s: conflict with existing integrity profile: "
-		      "%s profile mismatch",
+		DMERR("%s: conflict with existing integrity profile: %s profile mismatch",
 		      dm_device_name(t->md),
 		      template_disk->disk_name);
 		return 1;
@@ -1711,8 +1706,7 @@ int dm_calculate_queue_limits(struct dm_table *t,
 		 * for the table.
 		 */
 		if (blk_stack_limits(limits, &ti_limits, 0) < 0)
-			DMWARN("%s: adding target device "
-			       "(start sect %llu len %llu) "
+			DMWARN("%s: adding target device (start sect %llu len %llu) "
 			       "caused an alignment inconsistency",
 			       dm_device_name(t->md),
 			       (unsigned long long) ti->begin,
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index 71720c8712f6..afa574799461 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -269,15 +269,15 @@ static int sb_check(struct dm_block_validator *v,
 	__le32 csum_le;
 
 	if (dm_block_location(b) != le64_to_cpu(disk_super->blocknr)) {
-		DMERR("sb_check failed: blocknr %llu: "
-		      "wanted %llu", le64_to_cpu(disk_super->blocknr),
+		DMERR("sb_check failed: blocknr %llu: wanted %llu",
+		      le64_to_cpu(disk_super->blocknr),
 		      (unsigned long long)dm_block_location(b));
 		return -ENOTBLK;
 	}
 
 	if (le64_to_cpu(disk_super->magic) != THIN_SUPERBLOCK_MAGIC) {
-		DMERR("sb_check failed: magic %llu: "
-		      "wanted %llu", le64_to_cpu(disk_super->magic),
+		DMERR("sb_check failed: magic %llu: wanted %llu",
+		      le64_to_cpu(disk_super->magic),
 		      (unsigned long long)THIN_SUPERBLOCK_MAGIC);
 		return -EILSEQ;
 	}
diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index b13c1aa5e53b..c90a8a7fb022 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1014,10 +1014,8 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_sb *dsb,
 
 	sb_block = le64_to_cpu(sb->sb_block);
 	if (sb_block != (u64)dsb->zone->id << zmd->zone_nr_blocks_shift) {
-		dmz_dev_err(dev, "Invalid superblock position "
-			    "(is %llu expected %llu)",
-			    sb_block,
-			    (u64)dsb->zone->id << zmd->zone_nr_blocks_shift);
+		dmz_dev_err(dev, "Invalid superblock position (is %llu expected %llu)",
+			    sb_block, (u64)dsb->zone->id << zmd->zone_nr_blocks_shift);
 		return -EINVAL;
 	}
 	if (zmd->sb_version > 1) {
@@ -1030,16 +1028,14 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_sb *dsb,
 		} else if (uuid_is_null(&zmd->uuid)) {
 			uuid_copy(&zmd->uuid, &sb_uuid);
 		} else if (!uuid_equal(&zmd->uuid, &sb_uuid)) {
-			dmz_dev_err(dev, "mismatching DM-Zoned uuid, "
-				    "is %pUl expected %pUl",
+			dmz_dev_err(dev, "mismatching DM-Zoned uuid, is %pUl expected %pUl",
 				    &sb_uuid, &zmd->uuid);
 			return -ENXIO;
 		}
 		if (!strlen(zmd->label))
 			memcpy(zmd->label, sb->dmz_label, BDEVNAME_SIZE);
 		else if (memcmp(zmd->label, sb->dmz_label, BDEVNAME_SIZE)) {
-			dmz_dev_err(dev, "mismatching DM-Zoned label, "
-				    "is %s expected %s",
+			dmz_dev_err(dev, "mismatching DM-Zoned label, is %s expected %s",
 				    sb->dmz_label, zmd->label);
 			return -ENXIO;
 		}
-- 
2.37.0 (Apple Git-136)

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

