Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F19A14D449
	for <dm-devel@lists.linux.dev>; Mon, 10 Jun 2024 15:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718032799; cv=none; b=hCsZCeksKu7ag6ZCmE6KEsXY9ie4MzeGy7nExfYUWpe6hZmApzceIQzmijP9/gHrMKjW/9lAyMehn/tzTDIMuQzkuFfkmkyvnbGo5+Oh8J57o5BiKmzT1In3gXIPfq32drypYJdnez0BCfpN5nr1CiNzCsQqc9FNe5t4beGx88k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718032799; c=relaxed/simple;
	bh=4zdq8NlZLhJ9iFteG0qOnd81TldyTXIkZ0qSHecPOPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mxmcc0t6iOD1bcqq71dGpV7dd/XQ+0iP4xt4IZBlWx1U+Rt2alNKGdY/lQ8p3Q+njNpN5/CyldK2xdrmRRPgO1O8qAs/LRCZo13FnVJ+mlubYlAtDeq898FVI9xFOwnlNVeApXxNNY4f9mqBz+UIQOZEnM3v1AhPeDaE/rJWxBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Vn1fiSST; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Vn1fiSST"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718032796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z79O7g79kWBjI/OEH3utw+4mRXCz/JmCv/3JJlyrSXY=;
	b=Vn1fiSSTv50r5Fzt09EF/CCphDZ2QiwCz8jOe6e9Ey6ZmmG4gCI/2Kz5kQ+vDZtnWfoTJl
	Wcwebk+yMKONYFx2NdtvSqUedVgA/qDNTSi4M/SfF3UMd33qSe0ecptUL9cqNqwQ1g96qo
	Ynyxd/9ni6ZQ2k4G01rrVUYjw3lJgPM=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-M20wUF5yPYaLH5C-4qM3GQ-1; Mon,
 10 Jun 2024 11:19:54 -0400
X-MC-Unique: M20wUF5yPYaLH5C-4qM3GQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB7541955F36
	for <dm-devel@lists.linux.dev>; Mon, 10 Jun 2024 15:19:53 +0000 (UTC)
Received: from o.redhat.com (unknown [10.39.192.14])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4165719560AB;
	Mon, 10 Jun 2024 15:19:51 +0000 (UTC)
From: heinzm@redhat.com
To: dm-devel@lists.linux.dev
Cc: mpatocka@redhat.com,
	bmarzins@redhat.com
Subject: [PATCH 1/2] dm raid: move _get_reshape_sectors() as prerequisite to fixing reshape size issues
Date: Mon, 10 Jun 2024 17:19:47 +0200
Message-ID: <19d71b1eca570718d27cd2897f582267cd3eb79c.1718031649.git.heinzm@redhat.com>
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

rs_set_dev_and_array_sectors() needs this function to
calculate device and array size properly in case leg data
devices have out-of-place reshape space allocated.

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-raid.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index abe88d1e6735..ac087c6a6796 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -1626,6 +1626,23 @@ static int _check_data_dev_sectors(struct raid_set *rs)
 	return 0;
 }
 
+/* Get reshape sectors from data_offsets or raid set */
+static sector_t _get_reshape_sectors(struct raid_set *rs)
+{
+	struct md_rdev *rdev;
+	sector_t reshape_sectors = 0;
+
+	rdev_for_each(rdev, &rs->md)
+		if (!test_bit(Journal, &rdev->flags)) {
+			reshape_sectors = (rdev->data_offset > rdev->new_data_offset) ?
+					rdev->data_offset - rdev->new_data_offset :
+					rdev->new_data_offset - rdev->data_offset;
+			break;
+		}
+
+	return max(reshape_sectors, (sector_t) rs->data_offset);
+}
+
 /* Calculate the sectors per device and per array used for @rs */
 static int rs_set_dev_and_array_sectors(struct raid_set *rs, sector_t sectors, bool use_mddev)
 {
@@ -2811,23 +2828,6 @@ static int rs_prepare_reshape(struct raid_set *rs)
 	return 0;
 }
 
-/* Get reshape sectors from data_offsets or raid set */
-static sector_t _get_reshape_sectors(struct raid_set *rs)
-{
-	struct md_rdev *rdev;
-	sector_t reshape_sectors = 0;
-
-	rdev_for_each(rdev, &rs->md)
-		if (!test_bit(Journal, &rdev->flags)) {
-			reshape_sectors = (rdev->data_offset > rdev->new_data_offset) ?
-					rdev->data_offset - rdev->new_data_offset :
-					rdev->new_data_offset - rdev->data_offset;
-			break;
-		}
-
-	return max(reshape_sectors, (sector_t) rs->data_offset);
-}
-
 /*
  * Reshape:
  * - change raid layout
-- 
2.45.2

