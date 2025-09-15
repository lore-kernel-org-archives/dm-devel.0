Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE6930C61B
	for <dm-devel@lists.linux.dev>; Mon, 15 Sep 2025 14:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757945580; cv=none; b=Wm5wL9MVVzg57sZviBJbfXYMv1Zhbml0BxuMl+huCA4rrxqac/wlzA2q3mrItreDt2qMywWPyVqcQuQ25ZI+8y789U/Y42HKhVYsuHmWERSPJfJT1NuSPoewGJOqo9ofbMyi0b1cxlvblH1ZfDEnVHA+xgQYjbmD9Zs5AyEMMnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757945580; c=relaxed/simple;
	bh=bD1VDb47JqTiFl9l8D1pFl10SPENR4DsAXT3zVs+g6Y=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=gyVYuLgY7AwB3c5zhfdJ/WJS5H0o7lh1cKixx11VbloaOwdK8urO5FQnvI6eg5jBqxEiiEwvhjQwxSGEmQnIa5MRWtPtYipl2fz6pekr+y8B9TOEFsgI3DsovcE9g20RmQD3fsjCEmNvTudcYYn3cqSR6nvoQfWapSynHzA2CdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NUkL+ojz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NUkL+ojz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757945577;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=L7OokSgrhTJ8VA+7L8IMSRj/EETwfbwYTPn91bZUtfg=;
	b=NUkL+ojzM92fvWpTr+Va/w+8ujVtXa6dlO6YSdvQ1+2iZuPYu/f4GcOFx3zpzf3iedpUpd
	HZgv4Qc72633KM6PspByBevuOaQfsIQWsNvOi9tYS+IYg9KQWZw9EZITb8wDb0Cd33ixvI
	O3BklFKM1z7z7FQ8+E7F/OludcSEapU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-367-bXH3eMplPq-mhVZ_FLTWtQ-1; Mon,
 15 Sep 2025 10:12:54 -0400
X-MC-Unique: bXH3eMplPq-mhVZ_FLTWtQ-1
X-Mimecast-MFC-AGG-ID: bXH3eMplPq-mhVZ_FLTWtQ_1757945569
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 131D21944F06;
	Mon, 15 Sep 2025 14:12:49 +0000 (UTC)
Received: from [10.45.225.219] (unknown [10.45.225.219])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C14019540EB;
	Mon, 15 Sep 2025 14:12:45 +0000 (UTC)
Date: Mon, 15 Sep 2025 16:12:40 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: dm-devel@lists.linux.dev, zkabelac@redhat.com
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: [PATCH] dm-raid: don't set io_min and io_opt for raid1
Message-ID: <c434231d-a71c-4610-612c-a27a44d26d6d@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

These commands
# modprobe brd rd_size=1048576
# vgcreate vg /dev/ram*
# lvcreate -m4 -L10 -n lv vg
trigger the following warnings:
device-mapper: table: 252:10: adding target device (start sect 0 len 24576) caused an alignment inconsistency
device-mapper: table: 252:10: adding target device (start sect 0 len 24576) caused an alignment inconsistency

The warnings are caused by the fact that io_min is 512 and physical block
size is 4096.

If there's chunk-less raid, such as raid1, io_min shouldn't be set to zero 
because it would be raised to 512 and it would trigger the warning.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/md/dm-raid.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c	2025-09-15 15:56:34.000000000 +0200
+++ linux-2.6/drivers/md/dm-raid.c	2025-09-15 15:56:56.000000000 +0200
@@ -3813,8 +3813,10 @@ static void raid_io_hints(struct dm_targ
 	struct raid_set *rs = ti->private;
 	unsigned int chunk_size_bytes = to_bytes(rs->md.chunk_sectors);
 
-	limits->io_min = chunk_size_bytes;
-	limits->io_opt = chunk_size_bytes * mddev_data_stripes(rs);
+	if (chunk_size_bytes) {
+		limits->io_min = chunk_size_bytes;
+		limits->io_opt = chunk_size_bytes * mddev_data_stripes(rs);
+	}
 }
 
 static void raid_presuspend(struct dm_target *ti)

