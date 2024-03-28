Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22D213AD3C
	for <dm-devel@lists.linux.dev>; Thu, 28 Mar 2024 20:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711658401; cv=none; b=oy8dED6iHcF1q8H1c2VsjF41bU6ddGejCwkfZb//D6iFgGZF75YXOLmZhCBBrmdV4hhCFREZHu8b71GEQCHrnwyga4jmTvXAuVhUdE7B0VVQeWGiCaXDaNkxteL2IOpTRvtD92zBoFpJy8xW6+WxA0c7zvkKqFzXbEhERGZgosw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711658401; c=relaxed/simple;
	bh=9TzmnhsUKTbqm3MBDZcbvUahak/Gsv0zqkL0N7t7Zn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFy8Ud+9mZNRkeyYJRdi0yMeULfbu9io5ttjCiT3aDxTZXwnIzXH3UpLus8aXkCrx4jkm1n6JyBWN2wk8DPXHYgTo/La3ojYKdwixKf5zeGxazmhiFFg5GPzeJYdKCpdIlk+pP1vBY7ImRDYwuZ3f/wpLAxJY04q3FMj3VUsQfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kc7c71G8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kc7c71G8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711658398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g4rLC5S75oEgMAlRnRiGxyXHyD4Dy8z12uj2IyMw9Nc=;
	b=Kc7c71G8zLDb5NoASgZpWRBI7/kUgG9JWXwW2AbRajYd9LYFqCHphhA8Cz5uiIfyK3j/St
	YohmnrNhnzY1j3N3mEs5+sw8+OitNl5btXRoDUnPyxS//cPR5Lam+pOZfPaSmlaNuc8LB+
	0laGhc1zuTPzvPZvweFlsPpzTL/+ez0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-TPsvWD4yNkqI23cHGTHb_Q-1; Thu, 28 Mar 2024 16:39:52 -0400
X-MC-Unique: TPsvWD4yNkqI23cHGTHb_Q-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5D8DF185A786;
	Thu, 28 Mar 2024 20:39:52 +0000 (UTC)
Received: from localhost (unknown [10.39.194.117])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B501E1C060DC;
	Thu, 28 Mar 2024 20:39:50 +0000 (UTC)
From: Stefan Hajnoczi <stefanha@redhat.com>
To: linux-block@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	eblake@redhat.com,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	David Teigland <teigland@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Joe Thornber <ejt@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>
Subject: [RFC 2/9] loop: add llseek(SEEK_HOLE/SEEK_DATA) support
Date: Thu, 28 Mar 2024 16:39:03 -0400
Message-ID: <20240328203910.2370087-3-stefanha@redhat.com>
In-Reply-To: <20240328203910.2370087-1-stefanha@redhat.com>
References: <20240328203910.2370087-1-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
---
Open issues:
- The file offset is updated on both the blkdev file and the backing
  file. Is there a way to avoid updating the backing file offset so the
  file opened by userspace is not affected?
- Should this run in the worker or use the cgroups?
---
 drivers/block/loop.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 28a95fd366fea..6a89375de82e8 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -750,6 +750,29 @@ static void loop_sysfs_exit(struct loop_device *lo)
 				   &loop_attribute_group);
 }
 
+static loff_t lo_seek_hole_data(struct block_device *bdev, loff_t offset,
+		int whence)
+{
+	/* TODO need to activate cgroups or use worker? */
+	/* TODO locking? */
+	struct loop_device *lo = bdev->bd_disk->private_data;
+	struct file *file = lo->lo_backing_file;
+
+	if (lo->lo_offset > 0)
+		offset += lo->lo_offset; /* TODO underflow/overflow? */
+
+	/* TODO backing file offset is modified! */
+	offset = vfs_llseek(file, offset, whence);
+	if (offset < 0)
+		return offset;
+
+	if (lo->lo_offset > 0)
+		offset -= lo->lo_offset; /* TODO underflow/overflow? */
+	if (lo->lo_sizelimit > 0 && offset > lo->lo_sizelimit)
+		offset = lo->lo_sizelimit;
+	return offset;
+}
+
 static void loop_config_discard(struct loop_device *lo,
 		struct queue_limits *lim)
 {
@@ -1751,13 +1774,14 @@ static void lo_free_disk(struct gendisk *disk)
 }
 
 static const struct block_device_operations lo_fops = {
-	.owner =	THIS_MODULE,
-	.release =	lo_release,
-	.ioctl =	lo_ioctl,
+	.owner =		THIS_MODULE,
+	.release =		lo_release,
+	.ioctl =		lo_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl =	lo_compat_ioctl,
+	.compat_ioctl =		lo_compat_ioctl,
 #endif
-	.free_disk =	lo_free_disk,
+	.free_disk =		lo_free_disk,
+	.seek_hole_data =	lo_seek_hole_data,
 };
 
 /*
@@ -2140,7 +2164,7 @@ static int loop_control_remove(int idx)
 		pr_warn_once("deleting an unspecified loop device is not supported.\n");
 		return -EINVAL;
 	}
-		
+
 	/* Hide this loop device for serialization. */
 	ret = mutex_lock_killable(&loop_ctl_mutex);
 	if (ret)
-- 
2.44.0

