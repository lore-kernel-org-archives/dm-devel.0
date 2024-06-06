Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B65813BC02;
	Thu,  6 Jun 2024 07:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717659449; cv=none; b=r/blY6XS0j0rL+QQq6vLxh6HNTTMXiRC89N00dbrJPAt3bcXjqdxy7TnwYPygX+5GT2ASDB8Ez2nOGIfboz/+PkCE9YiHV6tYO8QGueN130yRkRyjTwtW/0DynDFJO1WC7HwLVp7gDu2jhlyqOU5tVBeQUFCDH3mVTD60eS+uig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717659449; c=relaxed/simple;
	bh=KRE2dv22LHVk2zvzJvwlpR2Tk++NVvfFBggCAC+nQC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEeSAp/BGaEc2351guIXljTEFw92OeexnxgNGKx7xY1VGsJf60EXVIMKY0A32MREqbN8RGLQuTfhpJ77EYR+YSY/RKuKp4clnRHEiwhgGFPlofvK4skT0nDqoH5Nk8a9feNMprYWsPnFLqzx+287lthOrx7tguG3v56eNxkp9wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o0NLUkGq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o0NLUkGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DA3C4AF15;
	Thu,  6 Jun 2024 07:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717659449;
	bh=KRE2dv22LHVk2zvzJvwlpR2Tk++NVvfFBggCAC+nQC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0NLUkGqdqIMjwbsU8zs7Z9+NiYOGwYxcrZuyzpUwVhwnUlxFo3ecfNL6ak60nVtp
	 fKoF5raCV8HtcgZ5Bk1TkaV5upSYFJ40pkBJHIVXxRfIwQJDpzfGHgjCeog7rzzBHc
	 K3BwQX9Mqb8ZqR9wH2+yfme0Dgdsev8zgc103/UtX4cLhTexHCD+G7tYQHxJjxg+Ia
	 9+SHuh3OCBSUNz3JMYYRKzRHeputveRHkUukFrTiWow9mj9fS/5b6MyRAUv0/AI7Hz
	 V7I2eJLJ7JGcnerPvn6rmJFZA/Ovv66J7BGp9S+sN3i5sRxhvyh7QXBcG8FLafgH/u
	 uQR/BY3xOlfnw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v5 4/4] dm: Remove unused macro DM_ZONE_INVALID_WP_OFST
Date: Thu,  6 Jun 2024 16:37:21 +0900
Message-ID: <20240606073721.88621-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606073721.88621-1-dlemoal@kernel.org>
References: <20240606073721.88621-1-dlemoal@kernel.org>
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
---
 drivers/md/dm-zone.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index e913a117d388..97c3140adad0 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -13,8 +13,6 @@
 
 #define DM_MSG_PREFIX "zone"
 
-#define DM_ZONE_INVALID_WP_OFST		UINT_MAX
-
 /*
  * For internal zone reports bypassing the top BIO submission path.
  */
-- 
2.45.2

