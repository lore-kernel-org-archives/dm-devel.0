Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3F6329C40
	for <dm-devel@lists.linux.dev>; Thu,  8 Jan 2026 19:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767902119; cv=none; b=HbY97WQTlhX1AaSxjFkoEwpciigBHnJH5N6Py6qS2TvmRX5/pZppHPHK8kkPjnEcmIExNMSvWBoZYW5a0AK4kAe1GrAL1+1zTgpsADoi5qbo8H8OUYvlBd1aIwQ2r5aqy89/P/TwMLYk1caN3T25n7+worfGCoRu6y8eNGRyigk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767902119; c=relaxed/simple;
	bh=9oQz0noK10I4Gs97u9gYDkGVBQoquUmrZoexdOoIXS4=;
	h=Date:From:To:cc:Subject:Message-ID:MIME-Version:Content-Type; b=QCKcENCS9RBqkJAKNMcnnvy8qL5OD5+6AmEmIj75zcQ/T3tCSU3Rw2fKIaOS+Ji/fMKHNdeyzKFG2FbK5HGWmnzOn6IUEuFdu9r+jSuLt1tBk95UbOWH3/7BcPmowBuDvMtKcTmv/+nplmbMO6AAeJ9ilwDbeHs/BqNx4oYJ7oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nat7p78U; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nat7p78U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767902117;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=GTbH5ERjICJNw3spLFbyBm0RPkqBdzwXyyW7oIwUpFk=;
	b=Nat7p78UpZ9fDM7cAjMJiXu5r8/TbJgm2zRZs+QNMro/G66o0oGLzC9JDZf2B/aD/4/NSV
	YH6Oat8TDrmZw1khyD3+eSbdECmQXuJoxBAQKWQpSYR0omCDJqT/Uc2+ahCMNqhkN9LFuP
	KSl38DPT49AMI+8Bfa5lpmVkX4YVa3M=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-c2qo3_YsMIGm6BNTXD3qlg-1; Thu,
 08 Jan 2026 14:55:15 -0500
X-MC-Unique: c2qo3_YsMIGm6BNTXD3qlg-1
X-Mimecast-MFC-AGG-ID: c2qo3_YsMIGm6BNTXD3qlg_1767902115
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1280195605A;
	Thu,  8 Jan 2026 19:55:14 +0000 (UTC)
Received: from [10.44.33.27] (unknown [10.44.33.27])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C46919560A2;
	Thu,  8 Jan 2026 19:55:13 +0000 (UTC)
Date: Thu, 8 Jan 2026 20:55:08 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>
cc: dm-devel@lists.linux.dev
Subject: [PATCH] dm: fix unlocked test for dm_suspended_md
Message-ID: <daf004a4-e171-8225-4d14-f0cfb3ce9b22@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: lvXB-3v3zliBP59HRxZINbnC5KUMCkp5RZQ4n6VBK5c_1767902115
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

The function dm_blk_report_zones tests if the device is suspended with
the "dm_suspended_md" call. However, this function is called without
holding any locks, so the device may be suspended just after it.

Move the call to dm_suspended_md after dm_get_live_table, so that the
device can't be suspended after the suspended state was tested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 37f53a2c60d0 ("dm: fix dm_blk_report_zones")

---
 drivers/md/dm-zone.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-zone.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-zone.c	2026-01-06 15:55:41.000000000 +0100
+++ linux-2.6/drivers/md/dm-zone.c	2026-01-06 22:55:36.000000000 +0100
@@ -60,11 +60,13 @@ int dm_blk_report_zones(struct gendisk *
 		 * Zone revalidation during __bind() is in progress, but this
 		 * call is from a different process
 		 */
-		if (dm_suspended_md(md))
-			return -EAGAIN;
-
 		map = dm_get_live_table(md, &srcu_idx);
 		put_table = true;
+
+		if (dm_suspended_md(md)) {
+			ret = -EAGAIN;
+			goto do_put_table;
+		}
 	} else {
 		/* Zone revalidation during __bind() */
 		map = zone_revalidate_map;
@@ -79,6 +81,7 @@ int dm_blk_report_zones(struct gendisk *
 		ret = dm_blk_do_report_zones(md, map, nr_zones, &dm_args);
 	}
 
+do_put_table:
 	if (put_table)
 		dm_put_live_table(md, srcu_idx);
 

