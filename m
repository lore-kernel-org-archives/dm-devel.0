Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85812A923
	for <dm-devel@lists.linux.dev>; Wed, 11 Jun 2025 01:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749604605; cv=none; b=LQmnRMnr6MIxpx2H5Yak+9zypbXgykzb0Wb26vR9ozzwbAJL0pXf6bkDBcKOrnRuC2rdCxFn+l4L7O+P9Rw1TCzKdAkBRPi7xUDRUKoEp6U9HQ2gyIPQ+s+Ndz1Bwv7VMzMyTBvFSivlU4XB2bwe5jn1epwPbOiMgKtgVNyHkuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749604605; c=relaxed/simple;
	bh=Nyrj2+1GQQJOjHhtOP3MM+JG1k//6/kp3JyrnYB5cAE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=htYOE4qmsh9FQOgHNb0nJAdliUu08Xu9lnDVjhd5PgCBgIDUuvbLL9kQf8oJNFE9aSzbG7Ww0RejxDelMDwhoZ1FLuMVwkBdFui5J4CSqH25ZWfVnr01ll0WJlH6N3ioFxxaUOukXKTjY7j6bduG1R3dJxXRaQ5hIPMuPBF+O34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMIZ/w6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMIZ/w6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8D6C4CEF3;
	Wed, 11 Jun 2025 01:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749604605;
	bh=Nyrj2+1GQQJOjHhtOP3MM+JG1k//6/kp3JyrnYB5cAE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=CMIZ/w6Bo7rsZKWYrXZvB2GFELX6GKSZ0iqsHqobZe8TUk/8tcwm53MRIIn0rUl8s
	 GASFlwp0h4fSAeBNSvIAd+58f0JnZDK2S9Lq0yEPY+PDHFLLZ9OicDg6UPG2UXN/y7
	 NyssHDhfciJf83bBo2TDkTc9lrOrkon8iaiR6eTwp1jBQiFL6tIJATHOzrBCtRj9m3
	 d7bh9WyJrgTrSzHIJi33m2LWhHEs+yBybRFIb9UXpH5vifqQ/OnZY+iKRcb9EQCqy5
	 76yfT480/SkqdvK8QawogELfYFeWHA1SLTzLaZGNZdtwsW9FndqLF2r78+jIhxTrBC
	 iP1KN9EDmVp8A==
From: Damien Le Moal <dlemoal@kernel.org>
To: dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm: Remove unnecessary return in dm_zone_endio()
Date: Wed, 11 Jun 2025 10:14:56 +0900
Message-ID: <20250611011457.92309-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250611011457.92309-1-dlemoal@kernel.org>
References: <20250611011457.92309-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The return statement at the end of dm_zone_endio() is not needed.
Remove it.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm-zone.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 97ba70190821..4678076f5972 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -467,8 +467,6 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
 			bdev_offset_from_zone_start(disk->part0,
 						    clone->bi_iter.bi_sector);
 	}
-
-	return;
 }
 
 static int dm_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
-- 
2.49.0

