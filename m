Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3776A3C
	for <dm-devel@lists.linux.dev>; Sat, 18 Nov 2023 00:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fXymKy7g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700267647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PmQas8MPwrIfAPv+ezSJFB5Tn8MMMMoLg6BOcrBgE5Y=;
	b=fXymKy7gyuRsBsGZ8ZWSJjTEz9SPELY+fKqehAmvl91wSX5enURh6S8A+1tlqo2yp2oLLS
	yA7uzIac/qvBQ5zLSOLKzJClS6LG9J4oS9ivO4w0pEpu7LKwaA7k2YMQr7RFfazhbw8gd6
	ou8dAZpSPJh1o6H8SeRZoHfgf5IBHUI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-567-JhoTqh3xOX2SpzqXXFiCRA-1; Fri, 17 Nov 2023 19:34:06 -0500
X-MC-Unique: JhoTqh3xOX2SpzqXXFiCRA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E6D318556E8;
	Sat, 18 Nov 2023 00:34:05 +0000 (UTC)
Received: from pbitcolo-build-10.permabit.com (pbitcolo-build-10.permabit.lab.eng.bos.redhat.com [10.19.117.76])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D6006492BFD;
	Sat, 18 Nov 2023 00:34:05 +0000 (UTC)
Received: by pbitcolo-build-10.permabit.com (Postfix, from userid 1138)
	id 88A5B3003B; Fri, 17 Nov 2023 19:34:05 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 1/5] dm vdo io-submitter: remove get_bio_sector
Date: Fri, 17 Nov 2023 19:34:01 -0500
Message-Id: <a34a32723cc1dafc145c6e3f7584210725793933.1700266895.git.msakai@redhat.com>
In-Reply-To: <cover.1700266895.git.msakai@redhat.com>
References: <cover.1700266895.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

Just open-code access to bio's sector.

Reviewed-by: Susan LeGendre-McGhee <slegendr@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/io-submitter.c | 33 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-vdo/io-submitter.c b/drivers/md/dm-vdo/io-submitter.c
index ea27043f06e1..6952ee572a7b 100644
--- a/drivers/md/dm-vdo/io-submitter.c
+++ b/drivers/md/dm-vdo/io-submitter.c
@@ -115,11 +115,6 @@ static void send_bio_to_device(struct vio *vio, struct bio *bio)
 	submit_bio_noacct(bio);
 }
 
-static sector_t get_bio_sector(struct bio *bio)
-{
-	return bio->bi_iter.bi_sector;
-}
-
 /**
  * process_vio_io() - Submits a vio's bio to the underlying block device. May block if the device
  *                    is busy. This callback should be used by vios which did not attempt to merge.
@@ -149,8 +144,10 @@ static struct bio *get_bio_list(struct vio *vio)
 	assert_in_bio_zone(vio);
 
 	mutex_lock(&bio_queue_data->lock);
-	vdo_int_map_remove(bio_queue_data->map, get_bio_sector(vio->bios_merged.head));
-	vdo_int_map_remove(bio_queue_data->map, get_bio_sector(vio->bios_merged.tail));
+	vdo_int_map_remove(bio_queue_data->map,
+			   vio->bios_merged.head->bi_iter.bi_sector);
+	vdo_int_map_remove(bio_queue_data->map,
+			   vio->bios_merged.tail->bi_iter.bi_sector);
 	bio = vio->bios_merged.head;
 	bio_list_init(&vio->bios_merged);
 	mutex_unlock(&bio_queue_data->lock);
@@ -193,7 +190,7 @@ static struct vio *get_mergeable_locked(struct int_map *map, struct vio *vio,
 					bool back_merge)
 {
 	struct bio *bio = vio->bio;
-	sector_t merge_sector = get_bio_sector(bio);
+	sector_t merge_sector = bio->bi_iter.bi_sector;
 	struct vio *vio_merge;
 
 	if (back_merge)
@@ -216,31 +213,32 @@ static struct vio *get_mergeable_locked(struct int_map *map, struct vio *vio,
 		return NULL;
 
 	if (back_merge) {
-		return (get_bio_sector(vio_merge->bios_merged.tail) == merge_sector ?
+		return (vio_merge->bios_merged.tail->bi_iter.bi_sector == merge_sector ?
 			vio_merge : NULL);
 	}
 
-	return (get_bio_sector(vio_merge->bios_merged.head) == merge_sector ?
+	return (vio_merge->bios_merged.head->bi_iter.bi_sector == merge_sector ?
 		vio_merge : NULL);
 }
 
 static int map_merged_vio(struct int_map *bio_map, struct vio *vio)
 {
 	int result;
+	sector_t bio_sector;
 
-	result = vdo_int_map_put(bio_map, get_bio_sector(vio->bios_merged.head), vio,
-				 true, NULL);
+	bio_sector = vio->bios_merged.head->bi_iter.bi_sector;
+	result = vdo_int_map_put(bio_map, bio_sector, vio, true, NULL);
 	if (result != VDO_SUCCESS)
 		return result;
 
-	return vdo_int_map_put(bio_map, get_bio_sector(vio->bios_merged.tail), vio, true,
-			       NULL);
+	bio_sector = vio->bios_merged.tail->bi_iter.bi_sector;
+	return vdo_int_map_put(bio_map, bio_sector, vio, true, NULL);
 }
 
 static int merge_to_prev_tail(struct int_map *bio_map, struct vio *vio,
 			      struct vio *prev_vio)
 {
-	vdo_int_map_remove(bio_map, get_bio_sector(prev_vio->bios_merged.tail));
+	vdo_int_map_remove(bio_map, prev_vio->bios_merged.tail->bi_iter.bi_sector);
 	bio_list_merge(&prev_vio->bios_merged, &vio->bios_merged);
 	return map_merged_vio(bio_map, prev_vio);
 }
@@ -253,7 +251,7 @@ static int merge_to_next_head(struct int_map *bio_map, struct vio *vio,
 	 * that's compatible with using funnel queues in work queues. This avoids removing an
 	 * existing completion.
 	 */
-	vdo_int_map_remove(bio_map, get_bio_sector(next_vio->bios_merged.head));
+	vdo_int_map_remove(bio_map, next_vio->bios_merged.head->bi_iter.bi_sector);
 	bio_list_merge_head(&next_vio->bios_merged, &vio->bios_merged);
 	return map_merged_vio(bio_map, next_vio);
 }
@@ -290,7 +288,7 @@ static bool try_bio_map_merge(struct vio *vio)
 		/* no merge. just add to bio_queue */
 		merged = false;
 		result = vdo_int_map_put(bio_queue_data->map,
-					 get_bio_sector(bio),
+					 bio->bi_iter.bi_sector,
 					 vio, true, NULL);
 	} else if (next_vio == NULL) {
 		/* Only prev. merge to prev's tail */
@@ -299,7 +297,6 @@ static bool try_bio_map_merge(struct vio *vio)
 		/* Only next. merge to next's head */
 		result = merge_to_next_head(bio_queue_data->map, vio, next_vio);
 	}
-
 	mutex_unlock(&bio_queue_data->lock);
 
 	/* We don't care about failure of int_map_put in this case. */
-- 
2.40.0

