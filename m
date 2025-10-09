Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865F2230D0F
	for <dm-devel@lists.linux.dev>; Thu,  9 Oct 2025 03:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759980258; cv=none; b=FIerdHQDBm85XsZ+oX3daSSR2VjYvyf+8Nn/XOZHiCHZIUmJpA27tctlPRWC7JmGAnXRBpq0DtJP6Q4mrVrF37WL+NOcbrZKSvj0t+ZADp8hMOzN658vcl3Yg0lynzmX0z6Gauf8/s6GDPTGJ/DHeSppzlgauE4Q4gfQA3mrhKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759980258; c=relaxed/simple;
	bh=rxvOsMzt3JanEJ8zem9ikPg39p1OkGE2itVAHnpDJyc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=okLtb/JApDd+YX0zx37Y2rSmbP1080Z0/KBLCZmZfodhAMPGsT8DYQp3na7C3JIkgmQY6voxEDcdfQhdc09le2n/fa7C5pl8omT+S1s84lcE2LPkzOdOvcpkjOccnSJUiqKkf27cyPhxKUWRb9LRk8gwYDFNbUwW2fOmrJZknkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PE+ogehJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PE+ogehJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759980255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wzygK8JTMb25m0lvIkVep8qhj/uQBukGr7zaysDQkBI=;
	b=PE+ogehJ8lcOG+OPV4BUgv+0ysCFbOtMxlbl+GvkoimwVsYV09sXS/sVDuqkRplIvIAycw
	S9xihrJUtsi/ms/g63GBaamRcfcnMOOKAi/iOMhYeIgYQFbLor7gn9Hq4T9zpNFt2Zc5k1
	44jg/vqEje8fbt3yZ8pM0WUGk7LY7xk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-624-C7uDypTdNn2z1BMEB7J2xQ-1; Wed,
 08 Oct 2025 23:24:14 -0400
X-MC-Unique: C7uDypTdNn2z1BMEB7J2xQ-1
X-Mimecast-MFC-AGG-ID: C7uDypTdNn2z1BMEB7J2xQ_1759980253
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A1461800365;
	Thu,  9 Oct 2025 03:24:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B07981800576;
	Thu,  9 Oct 2025 03:24:12 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5993OBiR2896193
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 8 Oct 2025 23:24:11 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5993OBuw2896192;
	Wed, 8 Oct 2025 23:24:11 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, dm-devel@lists.linux.dev
Subject: [PATCH] dm: remove useless md->nr_zones variable
Date: Wed,  8 Oct 2025 23:24:11 -0400
Message-ID: <20251009032411.2896184-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aEtgDHeh4Kqcul_Gr89zhkEF_zyS6LoWtdpIS_rQUJI_1759980253
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

md->nr_zones is no longer used for anything. Remove it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-core.h | 1 -
 drivers/md/dm-zone.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index a3c9f74fe2dc..1cda8618d74d 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -139,7 +139,6 @@ struct mapped_device {
 	struct srcu_struct io_barrier;
 
 #ifdef CONFIG_BLK_DEV_ZONED
-	unsigned int nr_zones;
 	void *zone_revalidate_map;
 	struct task_struct *revalidate_map_task;
 #endif
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 78e17dd4d01b..cf4553e863f0 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -193,8 +193,6 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 		return ret;
 	}
 
-	md->nr_zones = disk->nr_zones;
-
 	return 0;
 }
 
@@ -442,7 +440,6 @@ void dm_finalize_zone_settings(struct dm_table *t, struct queue_limits *lim)
 			set_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
 	} else {
 		clear_bit(DMF_EMULATE_ZONE_APPEND, &md->flags);
-		md->nr_zones = 0;
 		md->disk->nr_zones = 0;
 	}
 }
-- 
2.50.1

