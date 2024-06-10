Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FF814BF8D
	for <dm-devel@lists.linux.dev>; Mon, 10 Jun 2024 15:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718032800; cv=none; b=B0oHDWPtqlnSAmSLwFy3m8TwszXRej9DbPjWrU1Fv1/HnfX9rj85ETV6Tfmp2KAGlLwr9ZNE5mSRppxVkOk6EPGp99tB8LP7P9pzNuvZxVDHpFTyzXQSaHWEomomdC+BJZcsJQW1u3XOvKq4w+4J78yj5jIhK3SsZQ060qTolXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718032800; c=relaxed/simple;
	bh=pxv9lGJDatIN37njbSRAvJQ1VnygtjwJuNrClOh6Nzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jElu4Y4rNj8IYyW3lQEcJxpUo9dgxK6XaAUnHZozDpTjKLbE7RsbCarrK35BB+nKmebaWCtLLw7wbii2VZeilGniVwGT3Ps8CwJwvtYfSUFStqrGE5VJi2/hg7o9g6nbGQDGHGeK6OFak5bprgasyWBO43tuw1nFfdCgKBN9ozA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gyRjjWwY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gyRjjWwY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718032798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H5wnuzZJh9onB6Y37nZz40BELb5sUpcrUQW+mUkGNao=;
	b=gyRjjWwY7Q9hYLfX0fMmAIBJ6RALXJy73kLX4PioNIErfoLsED8mjE/aIV0ZpCcu+AaHL5
	fJRZiwL4MAYuTnwm5LDJaqlfYEwdKxQbW6jzYOutVCjwOdD/ACAV5yGAgwL/QHZTXp/I4i
	bPvDL6Vs2tb4sl/Q9rb95DcUaQbwZsE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-574-rSY9f6XRMsG2l3CyMJ42Qg-1; Mon,
 10 Jun 2024 11:19:56 -0400
X-MC-Unique: rSY9f6XRMsG2l3CyMJ42Qg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7D671955E75
	for <dm-devel@lists.linux.dev>; Mon, 10 Jun 2024 15:19:55 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1C10619560B0;
	Mon, 10 Jun 2024 15:19:53 +0000 (UTC)
From: heinzm@redhat.com
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	bmarzins@redhat.com
Subject: [PATCH 2/2] dm raid: fix stripes adding reshape size issues
Date: Mon, 10 Jun 2024 17:19:48 +0200
Message-ID: <aaa7d3c28ea50111ebd1937df4f2ce6bc4fe3c45.1718031649.git.heinzm@redhat.com>
In-Reply-To: <cover.1718031649.git.heinzm@redhat.com>
References: <cover.1718031649.git.heinzm@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Heinz Mauelshagen <heinzm@redhat.com>

Adding stripes to an existing raid4/5/6/10 mapped device grows its
capacity though it'll be only made available _after_ the respective
reshape finished as of MD kernel reshape semantics.  Such reshaping
involves moving a window forward starting at BOD reading content
from previous lesser stripes and writing them back in the new
layout with more stripes.  Once that process finishes at end of
previous data, the grown size may be announced and used.  In order
to avoid writing over any existing data in place, out-of-place space
is added to the beginning of each data device by lvm2 before starting
the reshape process. That reshape space wasn't taken into acount for
data device size calculation.

Fixes resulting from above:

- correct event handling conditions in do_table_event() to set
  the device's capacity after the stripe adding reshape ended

- subtract mentioned out-of-place space doing data device and
  array size calculations

- conditionally set capacity as of superblock in preresume

Testing:

- passes all LVM2 RAID tests including new lvconvert-raid-reshape-size.sh one

Tested-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ac087c6a6796..0926383d6d23 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1673,7 +1673,7 @@ static int rs_set_dev_and_array_sectors(struct raid_set *rs, sector_t sectors, b
 		if (sector_div(dev_sectors, data_stripes))
 			goto bad;
 
-		array_sectors = (data_stripes + delta_disks) * dev_sectors;
+		array_sectors = (data_stripes + delta_disks) * (dev_sectors - _get_reshape_sectors(rs));
 		if (sector_div(array_sectors, rs->raid10_copies))
 			goto bad;
 
@@ -1682,7 +1682,7 @@ static int rs_set_dev_and_array_sectors(struct raid_set *rs, sector_t sectors, b
 
 	else
 		/* Striped layouts */
-		array_sectors = (data_stripes + delta_disks) * dev_sectors;
+		array_sectors = (data_stripes + delta_disks) * (dev_sectors - _get_reshape_sectors(rs));
 
 	mddev->array_sectors = array_sectors;
 	mddev->dev_sectors = dev_sectors;
@@ -1721,11 +1721,20 @@ static void do_table_event(struct work_struct *ws)
 	struct raid_set *rs = container_of(ws, struct raid_set, md.event_work);
 
 	smp_rmb(); /* Make sure we access most actual mddev properties */
-	if (!rs_is_reshaping(rs)) {
+
+	/* Only grow size resulting from added stripe(s) after reshape ended. */
+	if (!rs_is_reshaping(rs) &&
+	    rs->array_sectors > rs->md.array_sectors &&
+	    !rs->md.delta_disks &&
+	    rs->md.raid_disks == rs->raid_disks) {
+		/* The raid10 personality doesn't provide proper device sizes -> correct. */
 		if (rs_is_raid10(rs))
 			rs_set_rdev_sectors(rs);
+
+		rs->md.array_sectors = rs->array_sectors;
 		rs_set_capacity(rs);
 	}
+
 	dm_table_event(rs->ti->table);
 }
 
@@ -4023,6 +4032,11 @@ static int raid_preresume(struct dm_target *ti)
 	if (test_and_set_bit(RT_FLAG_RS_PRERESUMED, &rs->runtime_flags))
 		return 0;
 
+	/* If different and no explicit grow request, expose MD array size as of superblock. */
+	if (!test_bit(RT_FLAG_RS_GROW, &rs->runtime_flags) &&
+	    rs->array_sectors != mddev->array_sectors)
+		rs_set_capacity(rs);
+
 	/*
 	 * The superblocks need to be updated on disk if the
 	 * array is new or new devices got added (thus zeroed
-- 
2.45.2

