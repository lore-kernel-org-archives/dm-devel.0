Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A3A389
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 00:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715906494; cv=none; b=rOC+YSBJZz8F09BpBbSET2UtQoCAHQX6NW27/NX9djwl8cRvXw2rmOUOqUPG5R5RIIcoY7b6AFNUMfNRAEa54z2sKlBEs1Lchaj/9gPhBur3KA0rWnswGA7P21XlM5+75JhmdyoPr/MAN/c7N0fTBj6l+9Vdr/3CsYdf+1PW+SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715906494; c=relaxed/simple;
	bh=LyHpouuKOXnX3t6QWjD9I1UFI51AazKIZHcUISIrKxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g5wZPiZOYpZi0UzD3Wl4kAMIcZhMqzwr+fqr2ZniXsLscwsViS9rXkxj2Ynkr5bDsrFUbTrLmslLqrbGhFVbFs+D9VsIReyVxTMyllIzD9wsF4kK4xUCxGPdNjnuDXMmU854H5TV+7PoAFYrFleeiE38mwLqidWQbM782/bc6aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CRalRczY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CRalRczY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715906491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0fXk/IX7Wo++TGM1QeYRMV1+4eolS0l8dg4qOBrNK/Q=;
	b=CRalRczYOfQBtkriUpuIR7V5Btptr51/dAl2TRcRvmEIN3C3vEvwAdLUJLvZPcqHtQGoB1
	7jdSugppAgEmWQ6GhzEF9oJ3aSUP1Fcyqki/Bxb+arnF0Xzv5qULmrpvFbf9rr0ASCcoQt
	tQIs29N4c8nZiC5Z975hTPzJTeD+Cyw=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-70CvIGbfM4CrSzilFwdwiA-1; Thu,
 16 May 2024 20:41:29 -0400
X-MC-Unique: 70CvIGbfM4CrSzilFwdwiA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ED5A380670C;
	Fri, 17 May 2024 00:41:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 89293202696B;
	Fri, 17 May 2024 00:41:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44H0fTwa139630
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 20:41:29 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44H0fTlk139629;
	Thu, 16 May 2024 20:41:29 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 1/2] dm: factor out helper function from dm_get_device
Date: Thu, 16 May 2024 20:41:28 -0400
Message-ID: <20240517004129.139615-2-bmarzins@redhat.com>
In-Reply-To: <20240517004129.139615-1-bmarzins@redhat.com>
References: <20240517004129.139615-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Factor out a helper function, dm_devt_from_path(), from dm_get_device()
for use in dm targets.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-table.c         | 33 ++++++++++++++++++++++++---------
 include/linux/device-mapper.h |  5 +++++
 2 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index d124e37dfb00..41b58e0c6876 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -329,23 +329,15 @@ static int upgrade_mode(struct dm_dev_internal *dd, blk_mode_t new_mode,
 }
 
 /*
- * Add a device to the list, or just increment the usage count if
- * it's already present.
- *
  * Note: the __ref annotation is because this function can call the __init
  * marked early_lookup_bdev when called during early boot code from dm-init.c.
  */
-int __ref dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
-		  struct dm_dev **result)
+int __ref dm_devt_from_path(const char *path, dev_t *dev_p)
 {
 	int r;
 	dev_t dev;
 	unsigned int major, minor;
 	char dummy;
-	struct dm_dev_internal *dd;
-	struct dm_table *t = ti->table;
-
-	BUG_ON(!t);
 
 	if (sscanf(path, "%u:%u%c", &major, &minor, &dummy) == 2) {
 		/* Extract the major/minor numbers */
@@ -361,6 +353,29 @@ int __ref dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
 		if (r)
 			return r;
 	}
+	*dev_p = dev;
+	return 0;
+}
+EXPORT_SYMBOL(dm_devt_from_path);
+
+/*
+ * Add a device to the list, or just increment the usage count if
+ * it's already present.
+ */
+int dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
+		  struct dm_dev **result)
+{
+	int r;
+	dev_t dev;
+	struct dm_dev_internal *dd;
+	struct dm_table *t = ti->table;
+
+	BUG_ON(!t);
+
+	r = dm_devt_from_path(path, &dev);
+	if (r)
+		return r;
+
 	if (dev == disk_devt(t->md->disk))
 		return -EINVAL;
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 82b2195efaca..b4c7c4fa2de6 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -179,6 +179,11 @@ int dm_get_device(struct dm_target *ti, const char *path, blk_mode_t mode,
 		  struct dm_dev **result);
 void dm_put_device(struct dm_target *ti, struct dm_dev *d);
 
+/*
+ * Helper function for getting devices
+ */
+int dm_devt_from_path(const char *path, dev_t *dev_p);
+
 /*
  * Information about a target type
  */
-- 
2.45.0

