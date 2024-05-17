Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73219622
	for <dm-devel@lists.linux.dev>; Fri, 17 May 2024 00:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715906496; cv=none; b=pcJjEUTrnzK0WvMdiTYDQw/P0sv46FOyNEMoN0e7jRtxTEP2SnIeslQYi1LekHWbi4sU46xIcMpr2xHxmAl/DjP9zVNrGg3ZyIPkqHoWl40H1k8rQMbZhFK1xe12PwunlAJoi7SFrKlxctWptfIhD2a4OMPZMBdiTO8EAtabmTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715906496; c=relaxed/simple;
	bh=LaHJ64k7Q3eC9qMLxiXcleKpirreeUXEoGzCE/33s28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OnbPLtxHEo5eKMDaEIR/hEGwyBqZN7QudOjgrsSy0QCyZPA9gA/Ww39ttPPf4xQwp7I8o3llLFlXHKRnzxouSji83X3jzaDGHOMMzWpIbG719LmAgS8ucbOKmX2Ykr9U2McNvr5gH/fhMut7GbBW0S17qfQfMtjEhwICapdXkM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dcnvyUEN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dcnvyUEN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715906493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tmhJ70e2wrskIjSUX2+CnkB7yvLwr+zBHMd3dwYbJSE=;
	b=dcnvyUENNQ20Ywbrco66WGI0yqN3rAsTioNMVxOP1KqpDMdh88CibCxAk60bfZShZXwqgT
	DmigkxTWRKERmCyZxoY0jSL8QnkBhUecChmOfSx4FujeKt+XMsm1FPQ0Uk17lF171WA+re
	DVbOliBzlmG5idD3WFLk0Vsg9EBpsf4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-210-jxu1m_PFPTCGJkn5QMjC1Q-1; Thu, 16 May 2024 20:41:30 -0400
X-MC-Unique: jxu1m_PFPTCGJkn5QMjC1Q-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8156101A551;
	Fri, 17 May 2024 00:41:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1E91491037;
	Fri, 17 May 2024 00:41:29 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 44H0fTN7139634
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 16 May 2024 20:41:29 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 44H0fTP6139633;
	Thu, 16 May 2024 20:41:29 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev
Subject: [PATCH 2/2] dm mpath: don't call dm_get_device in multipath_message
Date: Thu, 16 May 2024 20:41:29 -0400
Message-ID: <20240517004129.139615-3-bmarzins@redhat.com>
In-Reply-To: <20240517004129.139615-1-bmarzins@redhat.com>
References: <20240517004129.139615-1-bmarzins@redhat.com>
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

When mutipath_message is called with an action and a device, it needs to
find the pgpath that matches that device. dm_get_device() is not the
right function for this. dm_get_device() will look for a table_device
matching the requested path in use by either the live or inactive table.
If it doesn't find the device, dm_get_device() will open it and add it
to the table. Means that multipath_message will accept any block device,
add it to the table if not present, and then look through the pgpaths
to see if it finds a match. Afterwards it will remove the device if it
was not previously in the table devices list.

This is the only function that can modify the device list of a table
besides the constructors and destructors, and it can only do this when
it was passed an invalid message.  Instead, multipath_message() should
call dm_devt_from_path() to get the device dev_t, and match that against
its pgpaths.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-mpath.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 05d1328d1811..a1d08a702709 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1420,8 +1420,7 @@ static int reinstate_path(struct pgpath *pgpath)
 /*
  * Fail or reinstate all paths that match the provided struct dm_dev.
  */
-static int action_dev(struct multipath *m, struct dm_dev *dev,
-		      action_fn action)
+static int action_dev(struct multipath *m, dev_t dev, action_fn action)
 {
 	int r = -EINVAL;
 	struct pgpath *pgpath;
@@ -1429,7 +1428,7 @@ static int action_dev(struct multipath *m, struct dm_dev *dev,
 
 	list_for_each_entry(pg, &m->priority_groups, list) {
 		list_for_each_entry(pgpath, &pg->pgpaths, list) {
-			if (pgpath->path.dev == dev)
+			if (pgpath->path.dev->bdev->bd_dev == dev)
 				r = action(pgpath);
 		}
 	}
@@ -1960,7 +1959,7 @@ static int multipath_message(struct dm_target *ti, unsigned int argc, char **arg
 			     char *result, unsigned int maxlen)
 {
 	int r = -EINVAL;
-	struct dm_dev *dev;
+	dev_t dev;
 	struct multipath *m = ti->private;
 	action_fn action;
 	unsigned long flags;
@@ -2009,7 +2008,7 @@ static int multipath_message(struct dm_target *ti, unsigned int argc, char **arg
 		goto out;
 	}
 
-	r = dm_get_device(ti, argv[1], dm_table_get_mode(ti->table), &dev);
+	r = dm_devt_from_path(argv[1], &dev);
 	if (r) {
 		DMWARN("message: error getting device %s",
 		       argv[1]);
@@ -2018,8 +2017,6 @@ static int multipath_message(struct dm_target *ti, unsigned int argc, char **arg
 
 	r = action_dev(m, dev, action);
 
-	dm_put_device(ti, dev);
-
 out:
 	mutex_unlock(&m->work_mutex);
 	return r;
-- 
2.45.0

