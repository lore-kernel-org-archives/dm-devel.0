Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146A22561B6
	for <dm-devel@lists.linux.dev>; Tue,  8 Apr 2025 23:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744156329; cv=none; b=q4FILfbuzzfvAV358TfWGzBS4syzlsuCiZqKCc/I8B5PCJuokEUfrBVLrSu354OyCI4v7+ErQpYrE1Nh3KF598BBf9j2VQbhUD5A+Tbx82sCwrn5bcWcq5M8k8/qJTDbUP/G9fB5CABAzpE4IRhLqVUfOO+Mln5kpNEvNKygB9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744156329; c=relaxed/simple;
	bh=1ojgXkn6m/ekNXz/57OvEUaGF5U2i4qchWsdcw6Gf0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=oF8xnVvJQhwuc2suca4Ckw8hemanxXl+HRup+E3e2l0JeMFaoPM6vrMHO4FG8TBcEAaKVC6tanJ1GTymWDbvqOfEO4rYloNatWqjBVYrJRS2sQHzUdOlkIWG3pBPRzPk9iPO52vpNin9mFnfa0oOL3s3xTJIXRmozbAJ4pSuREE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZzD9ggUY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZzD9ggUY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744156327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rN1fa8iLUEVc3AVZrl1MRaKRPIK3sSSRutmV7kpx2tE=;
	b=ZzD9ggUYn69a2lZeid0URCBihDQ0lYXd3tIcFld7c21kLZTKtKmg9ov+h3J/zY8Wy/ZLcB
	iKfNzXKoEMvp7OtdQYEaFbgB1dymFUm9jaU+odB+dDsNgXyyugYudwveUJkH40TASDGzkr
	/JAOb0SOI2LofRfau5mloF6mJQ2vtfk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-411-NLQ9qdXCNdaBl4pD_J6bkQ-1; Tue,
 08 Apr 2025 19:52:02 -0400
X-MC-Unique: NLQ9qdXCNdaBl4pD_J6bkQ-1
X-Mimecast-MFC-AGG-ID: NLQ9qdXCNdaBl4pD_J6bkQ_1744156321
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9B6FC19560B0;
	Tue,  8 Apr 2025 23:52:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD5F91956094;
	Tue,  8 Apr 2025 23:52:00 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 538Npx064128857
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Apr 2025 19:51:59 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 538NpxW44128856;
	Tue, 8 Apr 2025 19:51:59 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 1/6] dm: don't change md if dm_table_set_restrictions() fails
Date: Tue,  8 Apr 2025 19:51:54 -0400
Message-ID: <20250408235159.4128838-2-bmarzins@redhat.com>
In-Reply-To: <20250408235159.4128838-1-bmarzins@redhat.com>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YnU1J7FurjtwDZfpxN-YbIenEegP_x8HneVC7JVuacA_1744156321
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

__bind was changing the disk capacity, geometry and mempools of the
mapped device before calling dm_table_set_restrictions() which could
fail, forcing dm to drop the new table. Failing here would leave the
device using the old table but with the wrong capacity and mempools.

Move dm_table_set_restrictions() earlier in __bind(). Since it needs the
capacity to be set, save the old version and restore it on failure.

Fixes: bb37d77239af2 ("dm: introduce zone append emulation")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5ab7574c0c76..f5c5ccb6f8d2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2421,21 +2421,29 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 			       struct queue_limits *limits)
 {
 	struct dm_table *old_map;
-	sector_t size;
+	sector_t size, old_size;
 	int ret;
 
 	lockdep_assert_held(&md->suspend_lock);
 
 	size = dm_table_get_size(t);
 
+	old_size = dm_get_size(md);
+	set_capacity(md->disk, size);
+
+	ret = dm_table_set_restrictions(t, md->queue, limits);
+	if (ret) {
+		set_capacity(md->disk, old_size);
+		old_map = ERR_PTR(ret);
+		goto out;
+	}
+
 	/*
 	 * Wipe any geometry if the size of the table changed.
 	 */
-	if (size != dm_get_size(md))
+	if (size != old_size)
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	set_capacity(md->disk, size);
-
 	dm_table_event_callback(t, event_callback, md);
 
 	if (dm_table_request_based(t)) {
@@ -2468,12 +2476,6 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		t->mempools = NULL;
 	}
 
-	ret = dm_table_set_restrictions(t, md->queue, limits);
-	if (ret) {
-		old_map = ERR_PTR(ret);
-		goto out;
-	}
-
 	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
 	rcu_assign_pointer(md->map, (void *)t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
-- 
2.48.1

