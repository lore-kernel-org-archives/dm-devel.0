Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866F213C823;
	Thu,  6 Jun 2024 08:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717662115; cv=none; b=Wlj5VTZnxHP51E1n1ZX4VKLZiOj1+80UoeaRAY9eAKpu6Yjh5hChnZvwXSDcdaaw5m/wL+Vr8YbatUzMMPGrW9yKoQ6j0D4ue/qwIhvlAb/Q7Eysda1aHsz1WXKvkOErbqsl7xp2DwttwRYwnvHzeLZknEZH3H1KFrwkBw55wOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717662115; c=relaxed/simple;
	bh=F990ByQXr37k+fzd8nj5P5520PdYT2EX/iTo48g1fLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UWwEA5U6mNg9Vvv1/+OCK2fzTWHqhtsJy71jOWG7XSUBtalHJ5Ag5Vb54ZvgSqmaDb2Ncj0X7WtCL695FzgaeZvoqFEkwVHIi/IFXb4JhLhJHRqF15f5wiUz3ftWqbS7ylCHbxnTYWx/e1KVlatxU4NJ48nYZi6zh0Uheivt/Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LtinRLi3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LtinRLi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CCCC32782;
	Thu,  6 Jun 2024 08:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717662115;
	bh=F990ByQXr37k+fzd8nj5P5520PdYT2EX/iTo48g1fLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtinRLi3b9tMERKYs1wkGRDTavMbPFePU6lfw2y9qBEAfHwh7cEMJHg//cRgthown
	 m99vHSnKVtx9BYr7Ff9fg84ysfl7woVoNMNU6SUT/shyptvy/a4+qtz002ak14JVIB
	 GxxbIM1rRj7UjN3FtFjaxnwpeEMs7kVVEyIwtT1iKdSbnBsVYf2rJ4QX4OnKxUZBkC
	 NCBd22/yQDy6EORyGcUKSXIvuvw4SaRKl3iOaC/qepH9k5nvPIfnrPvoTKvCdAvJe8
	 FWMUYNGgftoQxCZ3+fjqHBAWP8G3VMdXk4RQPhotr8ucgBkhUTrNq35NcDCIshBxkj
	 AXbltQTKPS4Tw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v6 4/4] dm: Remove unused macro DM_ZONE_INVALID_WP_OFST
Date: Thu,  6 Jun 2024 17:21:47 +0900
Message-ID: <20240606082147.96422-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606082147.96422-1-dlemoal@kernel.org>
References: <20240606082147.96422-1-dlemoal@kernel.org>
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
index d9f8b7c0957a..c9c7f9118c88 100644
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

