Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6A4255E37
	for <dm-devel@lists.linux.dev>; Tue,  8 Apr 2025 23:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744156329; cv=none; b=s1Vsq4goZf2ttpk+Q3L/6Nv+vhQt0KRwSRPY8pq2QSkMw7deE6wrzwiX4V/0Uk03Rzy48mdRGbH+GI0IlG7UYnH6A6K/885iag2h19GsCNezcVPyYJAt35wt4hCQZ6RGvYzFuI9rQ+vLAjvAPjkB8MHWH7cvm+Q/jZgJEGfAYJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744156329; c=relaxed/simple;
	bh=avA/K8CWsY4Pci06rNHNdUL8Q0MAAApxnpKeR7F8xyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=guxbk+qamdGCb0N/qIJwpjmFsQDFTCl7r5aODulfPOBpmo/6YsgRAypkRCVMlcIsUPMSLL4QricTAOgOW5malV94e5RBpSDHKEBZzF8Es4AMERlYOy6Ue+Y5AH9zJu8HfN5hQjp2unGXT4caGAco7VEGQB4dpwjp+pCkpilSLdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Yac7S3oU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yac7S3oU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744156326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RkWV1GgFEZGi9nt6Ij1mhj3YtogvIjfkm8VSTSCcyfs=;
	b=Yac7S3oUxiunkZ4M4ElBPnNQ09cpf4QmCPR+bHezLknX5Gyv1mbINFsfWjklTvIm8vmTBw
	HCHRSoWLqQhemYn+pDK4vAhMF54KdNifJRFD5w/WU6e4IhOHdsrjw/8z5pAZZL/fqjrXY9
	+aGfDi4V7KD9Gzc9n2U1aygJMFl4/qk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-JWjsHkayMeGticGhdNwtmA-1; Tue,
 08 Apr 2025 19:52:03 -0400
X-MC-Unique: JWjsHkayMeGticGhdNwtmA-1
X-Mimecast-MFC-AGG-ID: JWjsHkayMeGticGhdNwtmA_1744156322
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 59A5719560BB;
	Tue,  8 Apr 2025 23:52:02 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F6113001D0E;
	Tue,  8 Apr 2025 23:52:01 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 538Nq02s4128877
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 8 Apr 2025 19:52:00 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 538Nq0034128876;
	Tue, 8 Apr 2025 19:52:00 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 6/6] dm: fix native zone append devices on top of emulated ones
Date: Tue,  8 Apr 2025 19:51:59 -0400
Message-ID: <20250408235159.4128838-7-bmarzins@redhat.com>
In-Reply-To: <20250408235159.4128838-1-bmarzins@redhat.com>
References: <20250408235159.4128838-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nCpbUgfrTMbiwgXAhUn_wq4hY6aT8x9n1xqp0jg8USg_1744156322
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

If a DM device that can pass down zone append commands is stacked on top
of a device that emulates zone append commands, it will allocate zone
append emulation resources, even though it doesn't use them. This is
because the underlying device will have max_hw_zone_append_sectors set
to 0 to request zone append emulation. When the DM device is stacked on
top of it, it will inherit that max_hw_zone_append_sectors limit,
despite being able to pass down zone append bios. Solve this by making
sure max_hw_zone_append_sectors is non-zero for DM devices that do not
need zone append emulation.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-zone.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 1d419734fefc..f89590f904e1 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -345,11 +345,15 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 
 	/*
 	 * Check if zone append is natively supported, and if not, set the
-	 * mapped device queue as needing zone append emulation.
+	 * mapped device queue as needing zone append emulation. If zone
+	 * append is natively supported, make sure that
+	 * max_hw_zone_append_sectors is not set to 0.
 	 */
 	WARN_ON_ONCE(queue_is_mq(q));
 	if (!dm_table_supports_zone_append(t))
 		lim->max_hw_zone_append_sectors = 0;
+	else if (lim->max_hw_zone_append_sectors == 0)
+		lim->max_hw_zone_append_sectors = lim->max_zone_append_sectors;
 
 	/*
 	 * Determine the max open and max active zone limits for the mapped
-- 
2.48.1

