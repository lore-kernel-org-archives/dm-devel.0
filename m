Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D97190473;
	Wed,  5 Jun 2024 06:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717569551; cv=none; b=QvRQ3OdvsX0i+5TGzRoFsNEZF5BSibhswufVzIy/yOCnap7dDnIfLsa+4oWF4otDB012WM8FFb7x1Xoq8pqx4sxeOEqEAVqIkU2eCFb3WDOOe3Lu2C0YOOR9C6iCD6uowkN5DJ4jka+Kk8RX/2crecmMBIE4Q3HlpyEkCBTTcF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717569551; c=relaxed/simple;
	bh=iOf65yNWsWFkb1Rj3364TvfCriRiHD1Xp3O3Wb9Smds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C7Y6cyX/sYt+nQMDJNMmwrVREAJLPC34zG367lYQJbRJT3SEOQqYRAT/9VrC08m/FTQmdiXkOtHc86qM0nv6j/mxH3uuw3y5LhhFQrZPt0eUVtLWa5YGY/goBoktKXscQkHlE4j913TFpe2FuWWCOaOXI9NByyYmyX+CPsjhrnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=huU4rS+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="huU4rS+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E2FC32781;
	Wed,  5 Jun 2024 06:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717569549;
	bh=iOf65yNWsWFkb1Rj3364TvfCriRiHD1Xp3O3Wb9Smds=;
	h=From:To:Cc:Subject:Date:From;
	b=huU4rS+kyUTuLgqvI3MHCNYMh9+sqDQ8xj0DPzBH71t9kXyoY6GEyF61yWnKJ2qSG
	 t/4P2LwfItw9MbxoCYEQibAKx1OWKnE/wygLqVAY87O36Z3kLp8tmrQzkZJUyMWaUH
	 oXz5/3O1O84lZWLYjq64mnPSTAf6Qz3Yat9vvcy0sJAglpyp7N3NgNH2n0mcPPMs53
	 cAApKDKB1yZkJHbYiIcZZxT8aGJdLHOg2Kk2qlaACvw0RJvLUiDm1AjnezzyUp7+CI
	 EoAnUf48GW1I5QoXCAWqYvPk5Ru3/yvIvyOyD1wqnaMv1wRPNwDqv0+V6mUYeT8qRI
	 9UpoU2aPTstlQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v3 0/2] Fix DM zone resource limits stacking
Date: Wed,  5 Jun 2024 15:39:04 +0900
Message-ID: <20240605063907.129120-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is V2 of the patch 4/4 of the series "Zone write plugging and DM
zone fixes". This patch fixes DM zone resource limits stacking (max open
zones and max active zones limits). Patch 1 is new and is added to help
catch problems and eventual regressions of the handling of these limits.

Changes from v2:
 - Modify patch 1 to return an error for the case where the max open
   zones limit is greater than the max active zones limit.
 - Modify patch 2 to avoid duplicated actions on the limits and to
   remove warnings for unusual zone limits.

Changes from v1:
 - Added patch 1
 - Modified patch 2 to not cap the limits for a target with the number
   of sequential zones mapped but rather to use the device limits as is
   when more zones than the limits are mapped and 0 otherwise (no
   limits).

Damien Le Moal (2):
  block: Imporve checks on zone resource limits
  dm: Improve zone resource limits handling

 block/blk-settings.c |   8 ++
 block/blk-zoned.c    |  17 +++-
 drivers/md/dm-zone.c | 220 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 205 insertions(+), 40 deletions(-)

-- 
2.45.1

