Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F90316F8E7;
	Tue, 11 Jun 2024 02:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718073408; cv=none; b=FoxNHSbf8/Y5J/lyod6YEcIR3JWAG6pfKElaz9IKvMmT5OQyU0yjJ3YCU2qJimfOYeZJwbnUQsD86zGCQ/JHTGGATmSCjQzYad/gGD1bkficQBfmE/2BxGmJjARJQq4x3aBaIT1o9AE6eQCevvsnHNrti1Dw0L6px7B69nvHLA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718073408; c=relaxed/simple;
	bh=bOWW+q/OdT/XGwQaqQKeua+YxTYz7jSZLwZEjjPprbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heFrxmQ/v13GzgsbrgG46nwmdsplGxN5Ql7VWhSYTxHC0/m1ck0ZVOIYr7KcWCoqYKOKppyDS7KEYKyPmzB2JihdW2a4XMfuVmCNGa5+VfnpI3fKXvyn4p9CUm5Ng5XZ1p1ID0oZOpyReF8PBtqFoIeO4d/LrGpUnJmDeHOHn2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Emf9YyFr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Emf9YyFr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A8BC2BBFC;
	Tue, 11 Jun 2024 02:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718073408;
	bh=bOWW+q/OdT/XGwQaqQKeua+YxTYz7jSZLwZEjjPprbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Emf9YyFrTioj9Zasg1mtcFx/yQTcfKhaXaOM4aPwADvoycM9VkNQBesdvttREmxHQ
	 XmbH71EXfCIuurbp7xY7o6IvUEE4JhWKbhnf1REHAd3zyt53rW1F/r/b7x7Rlp5IRl
	 VCvAM48+RNJMcQtrhn0Csh4dsFkuEC8UjTyNA/Pql7PIV4gmqIZIgI3fLCq/7bWuP0
	 PjaxqOfoh5tDPgtSEA8bnrvw3S4oZGgz9gYpP/P6DoIAR/et87e+vNB4bX5eZWtz/Y
	 gNY0niaKve7chreZhmTOppEJdEagKgRtwhqrvbUH/AbcIqA5ag8AkwA1s5R1aAxDWy
	 XYqjsBdqGQ/Tg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v8 4/4] dm: Remove unused macro DM_ZONE_INVALID_WP_OFST
Date: Tue, 11 Jun 2024 11:36:39 +0900
Message-ID: <20240611023639.89277-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240611023639.89277-1-dlemoal@kernel.org>
References: <20240611023639.89277-1-dlemoal@kernel.org>
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
 drivers/md/dm-zone.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index ac9f1f82108b..70719bf32a2e 100644
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

