Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559802DC781
	for <dm-devel@lists.linux.dev>; Thu,  1 May 2025 05:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746075994; cv=none; b=iMzU9TuesdrLrcKkPaZY0G5vDjDg8YQGSt4Q7JGtVtE6wZaWnVp9Lr0o+wRWkhIxBGXcKNubJbqU9eBi1dEz1Hd3s+vZY9PoO3zz+zUE/ttdmMuVgp+WM4JKXa9/ZNHBO1UQNzeYIN39qnoTn15kd44kL4MTxU6U2P69NVdYrRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746075994; c=relaxed/simple;
	bh=LD1Koa/BZ/y0dFUtKORMW7yt3LHp9zdOI52g/Hn/XXc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=LfRrq7kvF8tJZGY1N6xs46rikSblLCK6X+KrfbmFEb6nridCas5lfw3/rt8nMYMGufPpC7kNKC82QceEa7OgfMghD8/h7mwVu3M+iDnSBp3RMc+ZLU/W5PDrTmDXlverkRdF2XrxKBfOujWbWGqAvAj5BzudLCqkfyberO1UWsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DERciI9Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DERciI9Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746075990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JWc4arzapnSCLp1YeUxpixbT/l3eDXwSOOwNhPi7glc=;
	b=DERciI9Z/KQ1bGV9hJ/1BIcIjlu1Yo1sn6Zk5Ew76ymyFKyTg6c8/UuN1pbo8Blf3BlSsx
	i+J53isO/ZK5gRWW/NS2Y0+fpCCFZL/7MBWML6uuZdiqIfsfutuMwQ3a4Y4+sLmOzoHH4T
	0Jb4VQyXUDD3FvB7NR8GIh+b5oYaPxM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-478-OO40Z92XPvmbk9KdBH4QfQ-1; Thu,
 01 May 2025 01:06:29 -0400
X-MC-Unique: OO40Z92XPvmbk9KdBH4QfQ-1
X-Mimecast-MFC-AGG-ID: OO40Z92XPvmbk9KdBH4QfQ_1746075988
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E6E6195608A
	for <dm-devel@lists.linux.dev>; Thu,  1 May 2025 05:06:28 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FC101954B05;
	Thu,  1 May 2025 05:06:25 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 54156O1Q2475912
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 1 May 2025 01:06:24 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 54156ON12475911;
	Thu, 1 May 2025 01:06:24 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Kevin Wolf <kwolf@redhat.com>,
        Hanna Czenczek <hreitz@redhat.com>
Subject: [PATCH] dm-mpath: Don't probe paths that are getting initialized
Date: Thu,  1 May 2025 01:06:24 -0400
Message-ID: <20250501050624.2475903-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: m_hzMWBuFy4l3f0C55nK9cQw65xBrEtU-0-BB4Zksl8_1746075988
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

__switch_pg() sets m->current_pg before initializing the pathgroup. If
probe_active_paths() is called and pathgroup has not been fully
initialized, IO to the paths may fail, even though they will be usable
when the pathgroup has finished initializing. Instead, skip sending IO
in this situation and just return the number of usable paths. The next
request will wait for the pathgroup to be fully initialized.

Fixes: d5d16fabe431 ("dm mpath: Interface for explicit probing of active paths")
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-mpath.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index af17a35c6457..53861ad5dd1d 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -2068,19 +2068,28 @@ static int probe_path(struct pgpath *pgpath)
  *
  * Return -ENOTCONN if no valid path is left (even outside of current_pg). We
  * cannot probe paths in other pgs without switching current_pg, so if valid
- * paths are only in different pgs, they may or may not work. Userspace can
- * submit a request and we'll switch. If the request fails, it may need to
+ * paths are only in different pgs, they may or may not work. Additionally
+ * we should not probe paths in a pathgroup that is in the process of
+ * Initializing. Userspace can submit a request and we'll switch and wait
+ * for the pathgroup to be initialized. If the request fails, it may need to
  * probe again.
  */
 static int probe_active_paths(struct multipath *m)
 {
 	struct pgpath *pgpath;
 	struct priority_group *pg;
+	unsigned long flags;
 	int r = 0;
 
 	mutex_lock(&m->work_mutex);
 
-	pg = READ_ONCE(m->current_pg);
+	spin_lock_irqsave(&m->lock, flags);
+	if (test_bit(MPATHF_QUEUE_IO, &m->flags))
+		pg = NULL;
+	else
+		pg = m->current_pg;
+	spin_unlock_irqrestore(&m->lock, flags);
+
 	if (pg) {
 		list_for_each_entry(pgpath, &pg->pgpaths, list) {
 			if (!pgpath->is_active)
-- 
2.48.1

