Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A613762D3
	for <dm-devel@lists.linux.dev>; Tue, 20 Feb 2024 15:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708443090; cv=none; b=Gvr+tMJ3vPDItuKPQYtWIBaqrnIYQVzPpXegnM14R+K+Ic5GfIXfG6m067Adyl+6iMcG9jyuOWY4gQY/2rRqR/Dpm6/l8+25ZAnmaJU22HpZBZnZKZsEom+3lUO+tOB9+JrX3VyOQwOor5u6oRGoSHB346vmipCLBJEFFFTowZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708443090; c=relaxed/simple;
	bh=YQgRhjJnmOdq6hzxnwElyN0M+rhLrw16jErkKXYFXnw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jcmpQzDSYPdi18rgf+BpZw6VvlKf35e+GztfwA37bXq1OeoHrnsVRu1nuLKOtO6pf7J4M9sJcdX+G/zGJW7/rbkbbmd1TXXQgXi6At+gZOksbfjJQUBQgsQNhdUeYhif62ahdQmGomAgKam64qw3MqoWihNFu1Qg3VXR62xukzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TBNIJOwZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TBNIJOwZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708443087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3O/l03CW7RpLup6cJbwXZ5GvVgqZNdwKAG705VYtdgA=;
	b=TBNIJOwZsIyoJSOuGNmK+eDNTdVoJN6/WM6TO31F9GyDi0m6qtis2OVGDtB5H1hDCFwgIf
	whb8VViBf/9o/4kgP7/+rudP1syzvf8s8A9PXlxiPC91PDlYOPLQBR3WMTyi7hXWv5hH+E
	LmltCAwBYri4VHR3kSNB7oWuCBfhuAY=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-54-4YJFml8aPvaP5-_Lkmn2GA-1; Tue,
 20 Feb 2024 10:31:23 -0500
X-MC-Unique: 4YJFml8aPvaP5-_Lkmn2GA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB2803816448;
	Tue, 20 Feb 2024 15:31:22 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.2])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2681D20229A4;
	Tue, 20 Feb 2024 15:31:18 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: song@kernel.org
Cc: yukuai1@huaweicloud.com,
	bmarzins@redhat.com,
	heinzm@redhat.com,
	snitzer@kernel.org,
	ncroxon@redhat.com,
	neilb@suse.de,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH RFC V2 4/4] md/raid5: Don't check crossing reshape when reshape hasn't started
Date: Tue, 20 Feb 2024 23:30:59 +0800
Message-Id: <20240220153059.11233-5-xni@redhat.com>
In-Reply-To: <20240220153059.11233-1-xni@redhat.com>
References: <20240220153059.11233-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

stripe_ahead_of_reshape is used to check if a stripe region cross the
reshape position. So first, change the function name to
stripe_across_reshape to describe the usage of this function.

For reshape backwards, it starts reshape from the end of array and conf->
reshape_progress is init to raid5_size. During reshape, if previous is true
(set in make_stripe_request) and max_sector >= conf->reshape_progress, ios
should wait until reshape window moves forward. But ios don't need to wait
if max_sector is raid5_size.

And put the conditions into the function directly to make understand the
codes easily.

This can be reproduced easily by lvm2 test shell/lvconvert-raid-reshape.sh
For dm raid reshape, before starting sync thread, it needs to reload table
some times. In one time dm raid uses MD_RECOVERY_WAIT to delay reshape and
it doesn't start sync thread this time. Then one io comes in and it waits
because stripe_ahead_of_reshape returns true because it's a backward
reshape and max_sectors > conf->reshape_progress. But the reshape hasn't
started. So skip this check when reshape_progress is raid5_size

Fixes: 486f60558607 ("md/raid5: Check all disks in a stripe_head for reshape progress")
Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/raid5.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8497880135ee..4c71df4e2370 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5832,17 +5832,12 @@ static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,
 					  sector >= reshape_sector;
 }
 
-static bool range_ahead_of_reshape(struct mddev *mddev, sector_t min,
-				   sector_t max, sector_t reshape_sector)
-{
-	return mddev->reshape_backwards ? max < reshape_sector :
-					  min >= reshape_sector;
-}
-
-static bool stripe_ahead_of_reshape(struct mddev *mddev, struct r5conf *conf,
+static sector_t raid5_size(struct mddev *mddev, sector_t sectors, int raid_disks);
+static bool stripe_across_reshape(struct mddev *mddev, struct r5conf *conf,
 				    struct stripe_head *sh)
 {
 	sector_t max_sector = 0, min_sector = MaxSector;
+	sector_t reshape_pos = 0;
 	bool ret = false;
 	int dd_idx;
 
@@ -5856,9 +5851,12 @@ static bool stripe_ahead_of_reshape(struct mddev *mddev, struct r5conf *conf,
 
 	spin_lock_irq(&conf->device_lock);
 
-	if (!range_ahead_of_reshape(mddev, min_sector, max_sector,
-				     conf->reshape_progress))
-		/* mismatch, need to try again */
+	reshape_pos = conf->reshape_progress;
+	if (mddev->reshape_backwards) {
+		if (max_sector >= reshape_pos &&
+		    reshape_pos != raid5_size(mddev, 0, 0))
+			ret = true;
+	} else if (min_sector < reshape_pos)
 		ret = true;
 
 	spin_unlock_irq(&conf->device_lock);
@@ -5969,7 +5967,7 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	}
 
 	if (unlikely(previous) &&
-	    stripe_ahead_of_reshape(mddev, conf, sh)) {
+	    stripe_across_reshape(mddev, conf, sh)) {
 		/*
 		 * Expansion moved on while waiting for a stripe.
 		 * Expansion could still move past after this
-- 
2.32.0 (Apple Git-132)

