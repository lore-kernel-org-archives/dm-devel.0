Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840A813BC26;
	Thu,  6 Jun 2024 08:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717662110; cv=none; b=RbPML/aa1SUcBQQs0mH30r9JJw27tte7Obhekgwihm1TXgwjZfeFfD/OKLiq88Gbb47qQCImyw1PpXQ8V4tfWWPNmiP2iKeWmlEjVZNmyvZgRL1Lb2NPAcgZHQW1SXYUZhkpkM+RR9ImUS/uL7HQ+idFOQnGYZ33TWvXlluTVpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717662110; c=relaxed/simple;
	bh=0XEP+VNkR57GYxVykO6r4i9aFhLCEnvCD+59Fbxmcdc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kyygpnzh2w81V9X8gQPoTqoF20v4ywsBG4VlGOwwNvGziXURKnWtreMVvtcRYULDj8FbFbgQme18tV2grVDzX53bZROk0bcsTxW8+8/vua0L8CxJWTHqxRD0qt6OrJw291tTwLRFXkQtW1bejbx+Z8z5SCYpcyLWeS2DWQnB4rA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXfrYSGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXfrYSGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9FCC32782;
	Thu,  6 Jun 2024 08:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717662110;
	bh=0XEP+VNkR57GYxVykO6r4i9aFhLCEnvCD+59Fbxmcdc=;
	h=From:To:Cc:Subject:Date:From;
	b=JXfrYSGEbFAyNYM22DvOdCuetbG88BV0Ett+mu94BpHXufL8LYLr2iy5VCZJ+oDm0
	 zwy5n/b5zhpNtwK88NF+Osk86O+KrEg0s8xXHCIxd3S+egO2uwtSYLp/qa0/7R5gPV
	 CtHPbxCi7gGaPreTHCfT6x8FPpMB/Hm0T9Iaqf8cVmF8nhhLkmq9eOFXpgIU8tST8Z
	 WZbFhstz9L5LUl51vz8mIcdHFi8zchcJ760k32yCc0Zwo2RDsA370WV8Rh9oTEgdPZ
	 1Mz9tGOcI2j+NF3lWm6be4DV2LYlmxJlIub7DgKup4jYqgj+j/TtPO/hsfHzvABG/l
	 qjRI9neK7mIww==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v6 0/4] Fix DM zone resource limits stacking
Date: Thu,  6 Jun 2024 17:21:43 +0900
Message-ID: <20240606082147.96422-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the updated patch 4/4 of the series "Zone write plugging and DM
zone fixes". This patch fixes DM zone resource limits stacking (max open
zones and max active zones limits). Patch 1 is new and is added to help
catch problems and eventual regressions of the handling of these limits.

Changes from v5:
 - Corrected typo in comment in patch 2
 - Simplyfied patch 3 by removing the function dm_set_zone_resources()
   and integrating its code directly in dm_set_zone_restrictions().
 - Added review tags

Changes from v4:
 - Fixed a typo in a comment in patch 1
 - Added patch 2 and changed patch 3 accordingly
 - Added review tags

Changes from v3:
 - Modify patch 1 to always check the zone resource limits values in
   disk_update_zone_resources(), including for DM devices that do not
   use zone write plugging. Simplify patch 2 accordingly by removing the
   same check and adjustment of the zone resource limits.
 - Added patch 3

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

Damien Le Moal (4):
  block: Improve checks on zone resource limits
  dm: Call dm_revalidate_zones() after setting the queue limits
  dm: Improve zone resource limits handling
  dm: Remove unused macro DM_ZONE_INVALID_WP_OFST

 block/blk-settings.c  |   8 ++
 block/blk-zoned.c     |  20 ++++-
 drivers/md/dm-table.c |  15 +++-
 drivers/md/dm-zone.c  | 200 ++++++++++++++++++++++++++++++++----------
 drivers/md/dm.h       |   1 +
 5 files changed, 190 insertions(+), 54 deletions(-)

-- 
2.45.2

