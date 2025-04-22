Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA215219317
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 23:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745365666; cv=none; b=NDLztHPHvZqwwuTg8sU8/COZ1GQeA6y2++eK0BftFuXnvAf7ltRksg50rWx8Dvol6dzD1NNVSry5sU/yuuhU5C7o2SauZdTorHTs2LioI8wIGn8SkAa1qo4Yez5P+aCxIYnDahdLNXmfEhSI+YxSu2CGq3coF4cUZ7h3Z1T0bwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745365666; c=relaxed/simple;
	bh=WYBVEpCDCDtqo/rWSJXFkzD7osbCetD06AWEnniM9l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=ttZrhnMEmh8tfxlYLeQTlw34cWypEJ6uFb3s7DiW1JRwos2vtd6H+DHfZIfCnYKidlb8K//xmekUWk6j+Q25Q69LQMJw6xZ6XVt13euVrKlSq6ZhehKNMxa/j+5O98e6YbvdCdGTZRshQ68355JGMdMLDB1KmEoKcg+yYzTeJT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mpu2Qy3z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mpu2Qy3z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745365663;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Trw0Zu4RXNdcGW9S9VFuJ81atUs0KHK8P6nbCzzH/FE=;
	b=Mpu2Qy3zByWri+HHKTdmvodgWlEOd/d4Eimw5ziZ9JsfMgmMWQVX0c34YmDIEqrvlbrD5X
	b6qIkxjkUv5W5+965SJ3SQAv1ZfeOBGJ2d7imU/SlkI5UBzwC/Tv1t1+V36H/u2lL7h4cI
	UXSp2BcO/oN1ln8SiiMbbzwomgNUgSk=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-LLevxNN0NiSmY1Qp5nDruQ-1; Tue,
 22 Apr 2025 19:47:42 -0400
X-MC-Unique: LLevxNN0NiSmY1Qp5nDruQ-1
X-Mimecast-MFC-AGG-ID: LLevxNN0NiSmY1Qp5nDruQ_1745365661
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DCDF195609D;
	Tue, 22 Apr 2025 23:47:41 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8FC6E1800374;
	Tue, 22 Apr 2025 23:47:40 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53MNlcD81654081
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 22 Apr 2025 19:47:39 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53MNlcg01654080;
	Tue, 22 Apr 2025 19:47:38 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kent Overstreet <kent.overstreet@linux.dev>
Subject: [PATCH 4/4] dm-flakey: make corrupting read bios work
Date: Tue, 22 Apr 2025 19:47:38 -0400
Message-ID: <20250422234738.1654052-5-bmarzins@redhat.com>
In-Reply-To: <20250422234738.1654052-1-bmarzins@redhat.com>
References: <20250422234738.1654052-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jBZm99f82TfBcPOyi13KgopW6flTVHhwfG2Zp7hgd4Y_1745365661
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

dm-flakey corrupts the read bios in the endio function.  However, the
corrupt_bio_* functions checked bio_has_data() to see if there was data
to corrupt. Since this was the endio function, there was no data left to
complete, so bio_has_data() was always false. Fix this by saving a copy
of the bio's bi_iter in flakey_map(), and using this to initialize the
iter for corrupting the read bios. This patch also skips cloning the bio
for write bios with no data.

Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
Fixes: a3998799fb4df ("dm flakey: add corrupt_bio_byte feature")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-flakey.c | 54 ++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 0421f9336680..a8ee3df32d5f 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -47,7 +47,8 @@ enum feature_flag_bits {
 };
 
 struct per_bio_data {
-	bool bio_submitted;
+	bool bio_can_corrupt;
+	struct bvec_iter saved_iter;
 };
 
 static int parse_features(struct dm_arg_set *as, struct flakey_c *fc,
@@ -354,7 +355,8 @@ static void flakey_map_bio(struct dm_target *ti, struct bio *bio)
 }
 
 static void corrupt_bio_common(struct bio *bio, unsigned int corrupt_bio_byte,
-			       unsigned char corrupt_bio_value)
+			       unsigned char corrupt_bio_value,
+			       struct bvec_iter start)
 {
 	struct bvec_iter iter;
 	struct bio_vec bvec;
@@ -363,7 +365,7 @@ static void corrupt_bio_common(struct bio *bio, unsigned int corrupt_bio_byte,
 	 * Overwrite the Nth byte of the bio's data, on whichever page
 	 * it falls.
 	 */
-	bio_for_each_segment(bvec, bio, iter) {
+	__bio_for_each_segment(bvec, bio, iter, start) {
 		if (bio_iter_len(bio, iter) > corrupt_bio_byte) {
 			unsigned char *segment = bvec_kmap_local(&bvec);
 			segment[corrupt_bio_byte] = corrupt_bio_value;
@@ -372,36 +374,31 @@ static void corrupt_bio_common(struct bio *bio, unsigned int corrupt_bio_byte,
 				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",
 				bio, corrupt_bio_value, corrupt_bio_byte,
 				(bio_data_dir(bio) == WRITE) ? 'w' : 'r', bio->bi_opf,
-				(unsigned long long)bio->bi_iter.bi_sector,
-				bio->bi_iter.bi_size);
+				(unsigned long long)start.bi_sector,
+				start.bi_size);
 			break;
 		}
 		corrupt_bio_byte -= bio_iter_len(bio, iter);
 	}
 }
 
-static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
+static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc,
+			     struct bvec_iter start)
 {
 	unsigned int corrupt_bio_byte = fc->corrupt_bio_byte - 1;
 
-	if (!bio_has_data(bio))
-		return;
-
-	corrupt_bio_common(bio, corrupt_bio_byte, fc->corrupt_bio_value);
+	corrupt_bio_common(bio, corrupt_bio_byte, fc->corrupt_bio_value, start);
 }
 
-static void corrupt_bio_random(struct bio *bio)
+static void corrupt_bio_random(struct bio *bio, struct bvec_iter start)
 {
 	unsigned int corrupt_byte;
 	unsigned char corrupt_value;
 
-	if (!bio_has_data(bio))
-		return;
-
-	corrupt_byte = get_random_u32() % bio->bi_iter.bi_size;
+	corrupt_byte = get_random_u32() % start.bi_size;
 	corrupt_value = get_random_u8();
 
-	corrupt_bio_common(bio, corrupt_byte, corrupt_value);
+	corrupt_bio_common(bio, corrupt_byte, corrupt_value, start);
 }
 
 static void clone_free(struct bio *clone)
@@ -496,7 +493,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	unsigned int elapsed;
 	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
 
-	pb->bio_submitted = false;
+	pb->bio_can_corrupt = false;
 
 	if (op_is_zone_mgmt(bio_op(bio)))
 		goto map_bio;
@@ -505,10 +502,11 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 	elapsed = (jiffies - fc->start_time) / HZ;
 	if (elapsed % (fc->up_interval + fc->down_interval) >= fc->up_interval) {
 		bool corrupt_fixed, corrupt_random;
-		/*
-		 * Flag this bio as submitted while down.
-		 */
-		pb->bio_submitted = true;
+
+		if (bio_has_data(bio)) {
+			pb->bio_can_corrupt = true;
+			pb->saved_iter = bio->bi_iter;
+		}
 
 		/*
 		 * If ERROR_READS isn't set flakey_end_io() will decide if the
@@ -531,6 +529,8 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 			return DM_MAPIO_SUBMITTED;
 		}
 
+		if (!pb->bio_can_corrupt)
+			goto map_bio;
 		/*
 		 * Corrupt matching writes.
 		 */
@@ -550,9 +550,11 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 			struct bio *clone = clone_bio(ti, fc, bio);
 			if (clone) {
 				if (corrupt_fixed)
-					corrupt_bio_data(clone, fc);
+					corrupt_bio_data(clone, fc,
+							 clone->bi_iter);
 				if (corrupt_random)
-					corrupt_bio_random(clone);
+					corrupt_bio_random(clone,
+							   clone->bi_iter);
 				submit_bio(clone);
 				return DM_MAPIO_SUBMITTED;
 			}
@@ -574,21 +576,21 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	if (op_is_zone_mgmt(bio_op(bio)))
 		return DM_ENDIO_DONE;
 
-	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
+	if (!*error && pb->bio_can_corrupt && (bio_data_dir(bio) == READ)) {
 		if (fc->corrupt_bio_byte) {
 			if ((fc->corrupt_bio_rw == READ) &&
 			    all_corrupt_bio_flags_match(bio, fc)) {
 				/*
 				 * Corrupt successful matching READs while in down state.
 				 */
-				corrupt_bio_data(bio, fc);
+				corrupt_bio_data(bio, fc, pb->saved_iter);
 			}
 		}
 		if (fc->random_read_corrupt) {
 			u64 rnd = get_random_u64();
 			u32 rem = do_div(rnd, PROBABILITY_BASE);
 			if (rem < fc->random_read_corrupt)
-				corrupt_bio_random(bio);
+				corrupt_bio_random(bio, pb->saved_iter);
 		}
 	}
 
-- 
2.48.1

