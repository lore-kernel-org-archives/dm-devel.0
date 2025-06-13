Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1349328DB64
	for <dm-devel@lists.linux.dev>; Fri, 13 Jun 2025 23:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749856140; cv=none; b=gop5Yw8T+lCP3CH21bLag2wNNXFep16nzFck6Aoe6rFzfWfNQ9bVTYCA7BLSvBpHoy7rN4q9sduOvx2qs5P4BnAr2l0BF/DfnQQX374OcadyN9/lOBCQQkuQ3wLj52rdzZzmtSALr5nfBVCOU16oIgenl1NI48fn3VQKUhIJ+Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749856140; c=relaxed/simple;
	bh=OKB3ZxSZeMo1L8dPxpTpWCd6gUeuVuMUM2JO7e2Ut74=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=ggwShBJel5aE68dRvmQObllW+mxTTKYfCsWMuGQ676Z0xhWFHvS9kE6WwcCgiYmG0D61+eh+sNPYuqXxbSgNMnjkQWmdvHBwO7q4mKfXWovbd4zxJjl1vMS8L2JzTD8l5cmWy7INHD2yULtpg+yI/7IYefXTvUrLFb0BzxBUSp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ch7bd4/2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ch7bd4/2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749856136;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2lGgdJuxbKccQ9wiEEvN7KAMFUSGxinKm+oI23MWqj0=;
	b=Ch7bd4/2glKgaAeSbxnk804Yg0QbPPhshYWHS7jsthh7qezphoI80vvx+3b7pvVORJvDCf
	KixAen7figkwlSPj43hI1ET+1RAUv3GI8wvsltWBBqCWEdpfpqmLWa0y3eGoSAo+/hckQT
	N28F6jM5TxAcqH8eisrLM6UpH4aruSM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-AOQLWesqO12LBEoiN1jdFg-1; Fri,
 13 Jun 2025 19:08:55 -0400
X-MC-Unique: AOQLWesqO12LBEoiN1jdFg-1
X-Mimecast-MFC-AGG-ID: AOQLWesqO12LBEoiN1jdFg_1749856134
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8857B195608B
	for <dm-devel@lists.linux.dev>; Fri, 13 Jun 2025 23:08:54 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E230B180045C;
	Fri, 13 Jun 2025 23:08:53 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 55DN8q1b2838277
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 13 Jun 2025 19:08:52 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 55DN8qPs2838276;
	Fri, 13 Jun 2025 19:08:52 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-table: fix checking for rq stackable devices
Date: Fri, 13 Jun 2025 19:08:52 -0400
Message-ID: <20250613230852.2838268-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wr9V7HkcNe41YA8CCBkWWmbnrA0d1dFU7-Y836CpdvY_1749856134
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Due to the semantics of iterate_devices(), the current code allows a
request-based dm table as long as it includes one request-stackable
device. It is supposed to only allow tables where there are no
non-request-stackable devices.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 9f95f77687ef..d91207b2d77f 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -898,17 +898,17 @@ static bool dm_table_supports_dax(struct dm_table *t,
 	return true;
 }
 
-static int device_is_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
-				  sector_t start, sector_t len, void *data)
+static int device_is_not_rq_stackable(struct dm_target *ti, struct dm_dev *dev,
+				      sector_t start, sector_t len, void *data)
 {
 	struct block_device *bdev = dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
 
 	/* request-based cannot stack on partitions! */
 	if (bdev_is_partition(bdev))
-		return false;
+		return true;
 
-	return queue_is_mq(q);
+	return !queue_is_mq(q);
 }
 
 static int dm_table_determine_type(struct dm_table *t)
@@ -1004,7 +1004,7 @@ static int dm_table_determine_type(struct dm_table *t)
 
 	/* Non-request-stackable devices can't be used for request-based dm */
 	if (!ti->type->iterate_devices ||
-	    !ti->type->iterate_devices(ti, device_is_rq_stackable, NULL)) {
+	    ti->type->iterate_devices(ti, device_is_not_rq_stackable, NULL)) {
 		DMERR("table load rejected: including non-request-stackable devices");
 		return -EINVAL;
 	}
-- 
2.48.1

