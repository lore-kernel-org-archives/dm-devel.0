Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304C8298992
	for <dm-devel@lists.linux.dev>; Tue, 22 Apr 2025 19:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745349470; cv=none; b=T8XXoLz3ybgZA3km07FD+KIUK9T4u+v/ESb8lqXDNAoG9GKXfq/hcUr1kFCCEo+eBDfJUPtdUCOarbzSM/dEOLqsgUxdPN38HWkSb4rRcbw7od2Hp/moTsbbbKoyKftTSaNQVttD9IixaDZ7cO8N89zFAQdORgmWWEUyptFsJ6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745349470; c=relaxed/simple;
	bh=baR0HREmFlP4+y6NjbQEUFnXIFQMzK8RdHsehX+COZc=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=eu8T0RybMv+ST5bwB5stjYTGVpQJ1kGhRJSKLq+WLPP9PKmtWONHSKG+duDEyk+5P1S0OgejwyzT1LUEGKNa/iF6auo0qyswrj2yBGr0U457GHeUDZhxU4USzUjGNqFgbeYkX/SzMkX/qrtUabEjuBFPuNoE9gxOSmgP1TGrN/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TdvZG3H6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TdvZG3H6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745349468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=LJ2I9t3vfI5q0dMBA11tCVJ1SI7G0mOvhd+Wk/BT0ts=;
	b=TdvZG3H6fbCpiqZhhlt2aENvJQGjwdV9wLIxpGHjzOMk0v5+fhDDS20ZcuNNi2qUUaBZiM
	sMxI5kCJLxW4Y3LcvN8JZRtOOTg9WBIT6JRDM0ku2ryVvYUg4trO0c5M0c/phuXT9998mm
	tySwNIFm62kz9R3qQ2Lz4RR/xdZvM6g=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-83-ppxpTBAwMBSVNdMvBbhzmA-1; Tue,
 22 Apr 2025 15:17:44 -0400
X-MC-Unique: ppxpTBAwMBSVNdMvBbhzmA-1
X-Mimecast-MFC-AGG-ID: ppxpTBAwMBSVNdMvBbhzmA_1745349463
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5250A1955DCE;
	Tue, 22 Apr 2025 19:17:41 +0000 (UTC)
Received: from [10.22.80.44] (unknown [10.22.80.44])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 11A0318001DA;
	Tue, 22 Apr 2025 19:17:39 +0000 (UTC)
Date: Tue, 22 Apr 2025 21:17:36 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: lock limits when reading them
Message-ID: <4bddce33-2e38-1eff-62f9-85af8889b938@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Ot4mIIRgWGig9TDKpWYnnxR4c3YKHLYPDw1LOhHqNec_1745349463
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Lock queue limits when reading them, so that we don't read halfway
modified values.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-table.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2025-04-14 16:02:04.000000000 +0200
+++ linux-2.6/drivers/md/dm-table.c	2025-04-14 16:02:04.000000000 +0200
@@ -431,6 +431,7 @@ static int dm_set_device_limits(struct d
 		return 0;
 	}
 
+	mutex_lock(&q->limits_lock);
 	if (blk_stack_limits(limits, &q->limits,
 			get_start_sect(bdev) + start) < 0)
 		DMWARN("%s: adding target device %pg caused an alignment inconsistency: "
@@ -448,6 +449,7 @@ static int dm_set_device_limits(struct d
 	 */
 	if (!dm_target_has_integrity(ti->type))
 		queue_limits_stack_integrity_bdev(limits, bdev);
+	mutex_unlock(&q->limits_lock);
 	return 0;
 }
 
@@ -1722,8 +1724,12 @@ static int device_not_write_zeroes_capab
 					   sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
+	int b;
 
-	return !q->limits.max_write_zeroes_sectors;
+	mutex_lock(&q->limits_lock);
+	b = !q->limits.max_write_zeroes_sectors;
+	mutex_unlock(&q->limits_lock);
+	return b;
 }
 
 static bool dm_table_supports_write_zeroes(struct dm_table *t)

