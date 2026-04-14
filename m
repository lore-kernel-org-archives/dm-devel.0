Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712B223EAA6
	for <dm-devel@lists.linux.dev>; Tue, 14 Apr 2026 00:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776126175; cv=none; b=bj07hgXEDC2Frew4fa53nbdAIItDqoh8CvCXQ2JWy4K1CeOVM83ioopEDxPHrVecnRFVaSr1olBk+hjTzXBwlXF0XXz5rhe8YK4f1399VZXyVEVdHcr6dVBFYTmU7RWJeQylYNjuJgIfGjnHvmF454btYlp3FkH1SBRF5HllBk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776126175; c=relaxed/simple;
	bh=KqsoTlKk+zRcPFrDY/twfH8Fpo4KDq8RpfNV0TcC/NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=nV2baHmpZ6acP8xzV1TYujFYPd0ZyCOe8dMP0lc8jJWQZAc6mmSY3vBODzeNV5SB9t9qXVVNfPwdKBUaeALxv/ZZGINMYAViy1cw4YP3pqNXZ3dQTLpARMjmSvEdEd/jRZfxyEdzxmxtA1cJAVUXmtNW49n7pcgAUVcQUkFaBa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RifXyOad; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RifXyOad"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776126173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uSRZJ55VcThoicOU7apFfS/oyfTRUB0uYu0W+Qd0vmU=;
	b=RifXyOadnkUtoPYreSUp73se7cp/zHb0xWozOjSO2zOmAbMPIzO6S1BrIkRIqoSDYtCpU1
	ibn1WkHegPTuQt0AV3Ur4YQKJpwGyVLIzG7pdAHdTblm59F6/mpep52nkyJQLS53NZlvRs
	HhtJJlsJ4vRiI033V/oo5q7LTi2aU+I=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686--4vN-0BbPNmHlbrs30Ofog-1; Mon,
 13 Apr 2026 20:22:48 -0400
X-MC-Unique: -4vN-0BbPNmHlbrs30Ofog-1
X-Mimecast-MFC-AGG-ID: -4vN-0BbPNmHlbrs30Ofog_1776126167
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 38AC5180057A;
	Tue, 14 Apr 2026 00:22:47 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02F9C180049F;
	Tue, 14 Apr 2026 00:22:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63E0Mjlf1917490
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 20:22:45 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63E0MjP31917489;
	Mon, 13 Apr 2026 20:22:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, linux-integrity@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: [PATCH 06/10] dm-ima: remove new_map from dm_ima_measure_on_device_clear
Date: Mon, 13 Apr 2026 20:22:40 -0400
Message-ID: <20260414002244.1917447-7-bmarzins@redhat.com>
In-Reply-To: <20260414002244.1917447-1-bmarzins@redhat.com>
References: <20260414002244.1917447-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: pUGCgn19PwhcW2-KN23J3B-0Ij5Agei6zyUeuA9tlSI_1776126167
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

Now that two processes can't modify md->ima in
dm_ima_measure_on_device_clear() at the same time, there's no need to
track if an inactive table was actually removed. We might as well
clean it up unconditionally, on the off chance that a previous
ima measurement failed and left md->ima.inactive_table behind.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ima.c   | 10 ++++------
 drivers/md/dm-ima.h   |  3 +--
 drivers/md/dm-ioctl.c |  4 +---
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-ima.c b/drivers/md/dm-ima.c
index e8fa049c6317..317f6d7e0e5e 100644
--- a/drivers/md/dm-ima.c
+++ b/drivers/md/dm-ima.c
@@ -549,7 +549,7 @@ void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all,
 /*
  * Measure ima data on table clear.
  */
-void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map,
+void dm_ima_measure_on_table_clear(struct mapped_device *md,
 				   struct dm_ima_context *context)
 {
 	unsigned int l = 0;
@@ -612,11 +612,9 @@ void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map,
 
 	dm_ima_measure_data("dm_table_clear", device_table_data, l, noio);
 
-	if (new_map) {
-		kfree(md->ima.inactive_table.hash);
-		kfree(md->ima.inactive_table.device_metadata);
-		memset(&md->ima.inactive_table, 0, sizeof(md->ima.inactive_table));
-	}
+	kfree(md->ima.inactive_table.hash);
+	kfree(md->ima.inactive_table.device_metadata);
+	memset(&md->ima.inactive_table, 0, sizeof(md->ima.inactive_table));
 
 error:
 	kfree(capacity_str);
diff --git a/drivers/md/dm-ima.h b/drivers/md/dm-ima.h
index 9e1b654867d9..2f2ac69042f2 100644
--- a/drivers/md/dm-ima.h
+++ b/drivers/md/dm-ima.h
@@ -82,7 +82,7 @@ void dm_ima_measure_on_device_resume(struct mapped_device *md, bool swap,
 void dm_ima_measure_on_device_remove(struct mapped_device *md, bool remove_all,
 				     struct dm_ima_context *context,
 				     unsigned int idx);
-void dm_ima_measure_on_table_clear(struct mapped_device *md, bool new_map,
+void dm_ima_measure_on_table_clear(struct mapped_device *md,
 				   struct dm_ima_context *context);
 void dm_ima_measure_on_device_rename(struct mapped_device *md,
 				     struct dm_ima_context *context);
@@ -107,7 +107,6 @@ static inline void dm_ima_measure_on_device_remove(struct mapped_device *md,
 						   struct dm_ima_context *context,
 						   unsigned int idx) {}
 static inline void dm_ima_measure_on_table_clear(struct mapped_device *md,
-						 bool new_map,
 						 struct dm_ima_context *context) {}
 static inline void dm_ima_measure_on_device_rename(struct mapped_device *md,
 						   struct dm_ima_context *context) {}
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 16609882aa92..2288f3d58ce9 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1737,7 +1737,6 @@ static int table_clear(struct file *filp, struct dm_ioctl *param, size_t param_s
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *old_map = NULL;
-	bool has_new_map = false;
 	struct dm_ima_context *ima_context = NULL;
 
 	dm_ima_alloc_context(&ima_context, true);
@@ -1754,13 +1753,12 @@ static int table_clear(struct file *filp, struct dm_ioctl *param, size_t param_s
 	if (hc->new_map) {
 		old_map = hc->new_map;
 		hc->new_map = NULL;
-		has_new_map = true;
 	}
 
 	dm_ima_init_context(hc, ima_context, false);
 	md = hc->md;
 	up_write(&_hash_lock);
-	dm_ima_measure_on_table_clear(md, has_new_map, ima_context);
+	dm_ima_measure_on_table_clear(md, ima_context);
 	dm_ima_free_context(ima_context);
 
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
-- 
2.53.0

