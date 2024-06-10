Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3234DA0E;
	Mon, 10 Jun 2024 07:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718006221; cv=none; b=P5l+7qUTwHS7iY2rhO5T2DYp9pMSLcbRWVcmliqYxxzk1rMfkuAXA6eA2NWzmHaatjj6i7bdZ/gUg1Dkj0L2lyVk9Obzv6dJgBsjBmlolKijCBM2SkXms0apRirn575DuHLjwIVVcRXF4L8iagIbDLZrGYOLQoIfrDe4e+wxIwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718006221; c=relaxed/simple;
	bh=WVsi4aWk9uObUnNrLTcjWz0sEzVnOanotwjk196nfqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c2sWOvsYAwf+bk6usDiomS2RtQMzfvUX3R4Ychb70GDYI7bw1403wmpids95R8NZ4d8g7abvTkoW8Hl3nlYmVdZ6fSnxem/1McDmyrp4geEn3i8UCI7/54rOwW33UU1D13waCeU4LLfVhhoas5G5i0N+pqcr+tiJozJ6IdxUixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uzjxPlTj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uzjxPlTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9686C4AF1C;
	Mon, 10 Jun 2024 07:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718006221;
	bh=WVsi4aWk9uObUnNrLTcjWz0sEzVnOanotwjk196nfqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzjxPlTjvFA26OYwYWn3Qm0qzObwapG/N9liaedG119s+DkP1Thxx/bZkrm1MGs9w
	 GF/QPMn9xBJttemnGABSImCGbW7CfBS1uMmcdJg6BBOwGnmCMZnYl9DvsiIZvetXdK
	 iilt7x0UcUF/RPvupEkJoFNWiE1z6XDyBXoXNYr9DHSjkLsaPsVfVfQzAds8mhZBj+
	 v+H4CnDKPzreu/qiFsTiaD3RoC+StbFTISG6kJjClaaXZ2K6MmSv2rGeHRzfqwnZjf
	 1uLY9Wh+5CTFg/K3qgNuIWrYXefGbnx6iR6M7gBwLK/imBVt9AQ65oKYUg13ZpG4De
	 e2DV1zo7oqOMQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v7 4/4] dm: Remove unused macro DM_ZONE_INVALID_WP_OFST
Date: Mon, 10 Jun 2024 16:56:55 +0900
Message-ID: <20240610075655.249301-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240610075655.249301-1-dlemoal@kernel.org>
References: <20240610075655.249301-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the switch to using the zone append emulation of the block layer
zone write plugging, the macro DM_ZONE_INVALID_WP_OFST is no longer used
in dm-zone.c. Remove its definition.

Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
---
 drivers/md/dm-zone.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index d9f8b7c0957a..70719bf32a2e 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -13,8 +13,6 @@
 
 #define DM_MSG_PREFIX "zone"
 
-#define DM_ZONE_INVALID_WP_OFST		UINT_MAX
-
 /*
  * For internal zone reports bypassing the top BIO submission path.
  */
@@ -285,8 +283,6 @@ static int device_get_zone_resource_limits(struct dm_target *ti,
 		return ret;
 	}
 
-	zlim->mapped_nr_seq_zones += zc.target_nr_seq_zones;
-
 	/*
 	 * If the target does not map any sequential zones, then we do not need
 	 * any zone resource limits.
@@ -317,6 +313,13 @@ static int device_get_zone_resource_limits(struct dm_target *ti,
 	zlim->lim->max_open_zones =
 		min_not_zero(max_open_zones, zlim->lim->max_open_zones);
 
+	/*
+	 * Also count the total number of sequential zones for the mapped
+	 * device so that when we are done inspecting all its targets, we are
+	 * able to check if the mapped device actually has any sequential zones.
+	 */
+	zlim->mapped_nr_seq_zones += zc.target_nr_seq_zones;
+
 	return 0;
 }
 
-- 
2.45.2

