Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7F065C
	for <dm-devel@lists.linux.dev>; Sat, 27 Jan 2024 02:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706322954; cv=none; b=E+VvPqRfGDBEVhVr17P8hryRXUFCeJG9tCYrmir9uvUHKAnFbuSg2UbQOfpx+i2bbuWDzTRO3qdF7bDSxR9ryNY2LqEhchBS4mjMIjjGMdiiAF5QNoexbwoPkD3X+BV+t70FdxbGPzZ440+kvkPnkUvz/A0U5pIGNJXF9wwPNVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706322954; c=relaxed/simple;
	bh=HrStFWzjn0phHu7TW6gLnml9OHSKiAJ4ZGe+7RJDwqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q9haleZgkwgYwLWr/oreK+rKAbVjjXwxSsc7PdO4mX+MLpYH5FjRmYh5IE+t2ICzMnFygZLW17VZUk48Uvb4PRTCzK2DywxaKF5p9Ph0snERm91LL9WOjEl0E9uBx49aLvEqKr+m2e9Xssb/vUSE8/BAy/KHZkC6KelNY2VKGBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ddqqaIGM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ddqqaIGM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706322951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwordXpELz2O9MVOgDXVigGHpQ8FCY5j6wtLbNNXjc4=;
	b=ddqqaIGMxELrrD2kD6ybMlhWgYcBolkIt3bM45T8BZGU5mOVf4c9TTbOguRWFi/iicwqFa
	EujfSes9P0qmv6tKjvDjefKhekzHKqPZErBkSF4hnXVjtged0niTDFJfCNor2TleEiaqOq
	QESqvsC0Rm8+/JtEa+z80PzjtAc1zls=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-gHP7944DNSKqmX3JFBmn8g-1; Fri, 26 Jan 2024 21:35:49 -0500
X-MC-Unique: gHP7944DNSKqmX3JFBmn8g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 776D5827D8D;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: from vdo-builder-msakai.permabit.com (vdo-builder-msakai.permabit.lab.eng.bos.redhat.com [10.0.103.170])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 60846203C981;
	Sat, 27 Jan 2024 02:35:49 +0000 (UTC)
Received: by vdo-builder-msakai.permabit.com (Postfix, from userid 1138)
	id 59906560C5; Fri, 26 Jan 2024 21:35:49 -0500 (EST)
From: Matthew Sakai <msakai@redhat.com>
To: dm-devel@lists.linux.dev
Cc: Mike Snitzer <snitzer@kernel.org>,
	Matthew Sakai <msakai@redhat.com>
Subject: [PATCH 3/5] dm vdo block-map: remove extra vdo arg from initialize_block_map_zone
Date: Fri, 26 Jan 2024 21:35:47 -0500
Message-ID: <8feda8993a1720e4b8dd577ce875bf466e8ca020.1706322049.git.msakai@redhat.com>
In-Reply-To: <cover.1706322049.git.msakai@redhat.com>
References: <cover.1706322049.git.msakai@redhat.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

From: Mike Snitzer <snitzer@kernel.org>

The block_map is passed to initialize_block_map_zone, but the
block_map's vdo member is already initialized with the same vdo
instance, so just use it.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
---
 drivers/md/dm-vdo/block-map.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-vdo/block-map.c b/drivers/md/dm-vdo/block-map.c
index eb838e6ae3e6..eda42383a2c1 100644
--- a/drivers/md/dm-vdo/block-map.c
+++ b/drivers/md/dm-vdo/block-map.c
@@ -2719,12 +2719,12 @@ void vdo_traverse_forest(struct block_map *map, vdo_entry_callback_fn callback,
  */
 static int __must_check initialize_block_map_zone(struct block_map *map,
 						  zone_count_t zone_number,
-						  struct vdo *vdo,
 						  page_count_t cache_size,
 						  block_count_t maximum_age)
 {
 	int result;
 	block_count_t i;
+	struct vdo *vdo = map->vdo;
 	struct block_map_zone *zone = &map->zones[zone_number];
 
 	BUILD_BUG_ON(sizeof(struct page_descriptor) != sizeof(u64));
@@ -2898,8 +2898,7 @@ int vdo_decode_block_map(struct block_map_state_2_0 state, block_count_t logical
 
 	map->zone_count = vdo->thread_config.logical_zone_count;
 	for (zone = 0; zone < map->zone_count; zone++) {
-		result = initialize_block_map_zone(map, zone, vdo, cache_size,
-						   maximum_age);
+		result = initialize_block_map_zone(map, zone, cache_size, maximum_age);
 		if (result != VDO_SUCCESS) {
 			vdo_free_block_map(map);
 			return result;
-- 
2.42.0

