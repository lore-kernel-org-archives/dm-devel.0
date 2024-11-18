Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584372BAF9
	for <dm-devel@lists.linux.dev>; Mon, 18 Nov 2024 15:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731942928; cv=none; b=MMudaIhuWCQabAvr86WHiiMw6NLf45tqQlTLu2SwU5aCXNMAXbrwl+RnTEaYrWijGwKFjf1oE3UBY4oEj4ZadvClRhO5yj0dBYJjlw5tskvwAsUsO/ZwMJvdLOvgDtfCDeLxVPqzdjrZysSO60otxILDLlw0zsabkQLAH3FB3fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731942928; c=relaxed/simple;
	bh=G3Nf+zlDs74IlqOFsFQE4i3OvtRh7VGzC/KVF7WQQmI=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=tNovAex5xMiLemxj9W8ci3K46e34FAhtvINbQuIopkSMuoCKBMIRiyYGOwi1Be+RnyDN9f5RMUpV9TJkUDJrOq4ADWr8EllhJ0BWcARGs6x+fUANzVilEVYOtzJ79wjCMTXCPhqfv274sRvU8nH23nTHyonrKOx+FoclEfh4Ycs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dplM5C9u; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dplM5C9u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731942926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=JbLx4wEe7rMy1hiIj8tlrNdJ8KS7H/D9I1WpQ0FCbmY=;
	b=dplM5C9uf3RQJzyL4F1CLFnzRV8QLC20N3oVAqtxrGGqyRQKGuXh64pdz5GZjJjs5l+F7j
	mq1SL5RFXMtiKUhjOQsOFXnJxadpKz9cRf1ieFREf8wAGAIrcfZxItH4iRcOd4CshiPZz2
	vJefnd2c31KBIBcKDEXcWO+4dhFblj0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-33-OXdiLVEjMv--Ilz_sQrdxg-1; Mon,
 18 Nov 2024 10:15:24 -0500
X-MC-Unique: OXdiLVEjMv--Ilz_sQrdxg-1
X-Mimecast-MFC-AGG-ID: OXdiLVEjMv--Ilz_sQrdxg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F07F618EBEAF;
	Mon, 18 Nov 2024 15:15:23 +0000 (UTC)
Received: from [10.45.225.96] (unknown [10.45.225.96])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDA091956086;
	Mon, 18 Nov 2024 15:15:22 +0000 (UTC)
Date: Mon, 18 Nov 2024 16:15:20 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm-verity: remove the unused "data_start" variable
Message-ID: <0d153702-5a7a-469e-4bbe-b79b259e8a1b@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rsz0YN2uedYFILvTief3O4qrvTgo43S5k9UkwCJN710_1731942924
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Remove the unused "data_start" variable. It is always set to zero and the
user can't override it. If the user needs to use some existing offset
within a block device, it is possible to use the linear target.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-verity-target.c |    6 +++---
 drivers/md/dm-verity.h        |    1 -
 2 files changed, 3 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-verity-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity-target.c	2024-11-07 12:49:00.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity-target.c	2024-11-18 15:31:43.000000000 +0100
@@ -93,7 +93,7 @@ static void dm_bufio_alloc_callback(stru
  */
 static sector_t verity_map_sector(struct dm_verity *v, sector_t bi_sector)
 {
-	return v->data_start + dm_target_offset(v->ti, bi_sector);
+	return dm_target_offset(v->ti, bi_sector);
 }
 
 /*
@@ -952,7 +952,7 @@ static int verity_prepare_ioctl(struct d
 
 	*bdev = v->data_dev->bdev;
 
-	if (v->data_start || ti->len != bdev_nr_sectors(v->data_dev->bdev))
+	if (ti->len != bdev_nr_sectors(v->data_dev->bdev))
 		return 1;
 	return 0;
 }
@@ -962,7 +962,7 @@ static int verity_iterate_devices(struct
 {
 	struct dm_verity *v = ti->private;
 
-	return fn(ti, v->data_dev, v->data_start, ti->len, data);
+	return fn(ti, v->data_dev, 0, ti->len, data);
 }
 
 static void verity_io_hints(struct dm_target *ti, struct queue_limits *limits)
Index: linux-2.6/drivers/md/dm-verity.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-verity.h	2024-11-07 12:49:00.000000000 +0100
+++ linux-2.6/drivers/md/dm-verity.h	2024-11-18 15:31:15.000000000 +0100
@@ -50,7 +50,6 @@ struct dm_verity {
 	unsigned int sig_size;	/* root digest signature size */
 #endif /* CONFIG_SECURITY */
 	unsigned int salt_size;
-	sector_t data_start;	/* data offset in 512-byte sectors */
 	sector_t hash_start;	/* hash start in blocks */
 	sector_t data_blocks;	/* the number of data blocks */
 	sector_t hash_blocks;	/* the number of hash blocks */

