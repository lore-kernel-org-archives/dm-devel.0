Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E42328FFF3
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 19:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744314594; cv=none; b=hWJEB7ti9c3v9ND1IMJ2FebmJDh0SEJfRcEjn/s50zBvqto4vqW0OXAIL48yJ55k8X7za0GN0yyUfK4mtEbPKjcRfkqgfTVvkqp84omCBP7gIPHUYoDkJ1NpEZIBS0VaPFy7qEud+BnaVqLt6VrN+S8YwB4CrREKdwfjWBIEhcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744314594; c=relaxed/simple;
	bh=KgwV/JXghWHg1ROaQ1S0hf98vdTKeAbJEyFU55URBrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:content-type; b=RuRJaG0JV+TKQjsYW/WLAoAh59uQUCO8AH1Wgidl0Fe7BfEZVqvnAuSy4v0tp85dhp57qZ9b70ZOXvqiH7Cj30WMwCnLdUDoXfXaFC/LdDQ3NjwR1w9I5/mh4JlamfCa4vusx0H6KgHDZYTh/OksKnJs0eSPH+/LElO3MEAarIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QlTbEYKJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QlTbEYKJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744314592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yO2yRDoRMq5NHtjVG7C7V+aJ90r9zmSYflgn4eRCl4k=;
	b=QlTbEYKJGCOEm8xS4gBnGH+452knpF2SHedP9OrGMGZ7ri7wFB+W0VWVaJV9gf7BJmMcCc
	vhoia9X7VcjK5G372xnud9ua3xjioWKbpAcM7RdNDhBxRWB1+olLj+eFZQSg0UwOWONywC
	HHBfg3ezbJG0T88OxjHzp68nQV9FhS0=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-9H1WHP3OOVKgDpB93YI5Bw-1; Thu,
 10 Apr 2025 15:49:47 -0400
X-MC-Unique: 9H1WHP3OOVKgDpB93YI5Bw-1
X-Mimecast-MFC-AGG-ID: 9H1WHP3OOVKgDpB93YI5Bw_1744314586
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7022B1956059;
	Thu, 10 Apr 2025 19:49:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A0B0180B486;
	Thu, 10 Apr 2025 19:49:46 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 53AJnjfq009365
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 10 Apr 2025 15:49:45 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 53AJnjjB009364;
	Thu, 10 Apr 2025 15:49:45 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@lists.linux.dev, Damien Le Moal <dlemoal@kernel.org>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v4 6/6] dm: fix native zone append devices on top of emulated ones
Date: Thu, 10 Apr 2025 15:49:43 -0400
Message-ID: <20250410194943.9326-7-bmarzins@redhat.com>
In-Reply-To: <20250410194943.9326-1-bmarzins@redhat.com>
References: <20250410194943.9326-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sMF-2ADW2on27KrkUZ0EB8Q38qARDxv42jcpWT3wJl8_1744314586
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

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-zone.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 037295db1c2d..d1f8c96cee46 100644
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

