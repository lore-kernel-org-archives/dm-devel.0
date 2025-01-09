Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBCD217F4A
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 13:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736430453; cv=none; b=MNuWU9ZjYAGiVZpogd+3SHnT0M7HAqAx0NxBeN3L2RITwRnhTaUTTVa+4d6ynnmxC695TGVAWSp/XxHv01+nvEDreu+djUCYM6DyhwGJtpYfqY6XU5BcXIWOBU84G8fQZAGSuoYleRd5O7OZjNqeCiJzJeanvOeIaZRb00ggl18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736430453; c=relaxed/simple;
	bh=2eiD2WJFmmgsgzTRhud28HKLRKuSDO6Jjh5Ycxps3/Q=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=Ukj6OLK4P8KzdV4G/F3EuK8nX2bxwoWE+fi5N9Asj/gvOpP801vQwvAqDSxSbJr5Svfgz21kUQ8MuDbXAYKld1U2d1NwryxKzwSXCotjpIoLlZGqLjrxoGjRXNSneJ87B6oC004H/ZCH4JXahtIcsiME1gJXAgiBzobMoxxYZgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CghERFXv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CghERFXv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736430450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=CuWmW578vlpFHtle6CQ1aqS58Edo/SfMXsE7rNhFtAc=;
	b=CghERFXv72rffNbJxAXHLYK3CWc6Yfw5/oZBj6g/jo3UNxdb9XqdgLUN5kMQWiI0kPIJP4
	Ms4eF8dVED9G5cZ5foV9mGqUbaFvlHShTLLJ0YDu6LDt3CiWQVxq6aaSdP2YEXeKVt48vF
	jSOy9naO9PEGnHod7F+iPQt/6rmvFCA=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-492-TXgebwXMPSG3AR1T42UYOg-1; Thu,
 09 Jan 2025 08:47:29 -0500
X-MC-Unique: TXgebwXMPSG3AR1T42UYOg-1
X-Mimecast-MFC-AGG-ID: TXgebwXMPSG3AR1T42UYOg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 757CE1955DE9;
	Thu,  9 Jan 2025 13:47:28 +0000 (UTC)
Received: from [10.45.224.27] (unknown [10.45.224.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 20EB019560AD;
	Thu,  9 Jan 2025 13:47:26 +0000 (UTC)
Date: Thu, 9 Jan 2025 14:47:20 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: remove useless test in alloc_multiple_bios
Message-ID: <74fed282-8a21-13b5-ebc6-6057f4045940@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7RjRlQao0yoyeW8_9sitt4MmTTYM4n6qt2wdh8-qsAU_1736430448
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The test gfp_flag & GFP_NOWAIT was always true, because both GFP_NOIO and
GFP_NOWAIT include the flag __GFP_KSWAPD_RECLAIM. Luckily, this oversight
didn't result in any harm; the loop always started with "try = 0".

This patch removes the faulty test and explicitly starts the loop with
"try = 0" (so that we don't hold the mutex in the first iteration).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2025-01-08 17:24:52.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2025-01-08 17:26:52.000000000 +0100
@@ -1479,12 +1479,12 @@ static void setup_split_accounting(struc
 
 static void alloc_multiple_bios(struct bio_list *blist, struct clone_info *ci,
 				struct dm_target *ti, unsigned int num_bios,
-				unsigned *len, gfp_t gfp_flag)
+				unsigned *len)
 {
 	struct bio *bio;
-	int try = (gfp_flag & GFP_NOWAIT) ? 0 : 1;
+	int try;
 
-	for (; try < 2; try++) {
+	for (try = 0; try < 2; try++) {
 		int bio_nr;
 
 		if (try && num_bios > 1)
@@ -1508,8 +1508,7 @@ static void alloc_multiple_bios(struct b
 }
 
 static unsigned int __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
-					  unsigned int num_bios, unsigned int *len,
-					  gfp_t gfp_flag)
+					  unsigned int num_bios, unsigned int *len)
 {
 	struct bio_list blist = BIO_EMPTY_LIST;
 	struct bio *clone;
@@ -1526,7 +1525,7 @@ static unsigned int __send_duplicate_bio
 	 * Using alloc_multiple_bios(), even if num_bios is 1, to consistently
 	 * support allocating using GFP_NOWAIT with GFP_NOIO fallback.
 	 */
-	alloc_multiple_bios(&blist, ci, ti, num_bios, len, gfp_flag);
+	alloc_multiple_bios(&blist, ci, ti, num_bios, len);
 	while ((clone = bio_list_pop(&blist))) {
 		if (num_bios > 1)
 			dm_tio_set_flag(clone_to_tio(clone), DM_TIO_IS_DUPLICATE_BIO);
@@ -1564,7 +1563,7 @@ static void __send_empty_flush(struct cl
 
 			atomic_add(ti->num_flush_bios, &ci->io->io_count);
 			bios = __send_duplicate_bios(ci, ti, ti->num_flush_bios,
-						     NULL, GFP_NOWAIT);
+						     NULL);
 			atomic_sub(ti->num_flush_bios - bios, &ci->io->io_count);
 		}
 	} else {
@@ -1612,7 +1611,7 @@ static void __send_abnormal_io(struct cl
 		    __max_io_len(ti, ci->sector, max_granularity, max_sectors));
 
 	atomic_add(num_bios, &ci->io->io_count);
-	bios = __send_duplicate_bios(ci, ti, num_bios, &len, GFP_NOIO);
+	bios = __send_duplicate_bios(ci, ti, num_bios, &len);
 	/*
 	 * alloc_io() takes one extra reference for submission, so the
 	 * reference won't reach 0 without the following (+1) subtraction
@@ -1849,7 +1848,7 @@ static blk_status_t __send_zone_reset_al
 			 * not go crazy with the clone allocation.
 			 */
 			alloc_multiple_bios(&blist, ci, ti, min(nr_reset, 32),
-					    NULL, GFP_NOIO);
+					    NULL);
 		}
 
 		/* Get a clone and change it to a regular reset operation. */
@@ -1881,7 +1880,7 @@ static void __send_zone_reset_all_native
 	unsigned int bios;
 
 	atomic_add(1, &ci->io->io_count);
-	bios = __send_duplicate_bios(ci, ti, 1, NULL, GFP_NOIO);
+	bios = __send_duplicate_bios(ci, ti, 1, NULL);
 	atomic_sub(1 - bios, &ci->io->io_count);
 
 	ci->sector_count = 0;

