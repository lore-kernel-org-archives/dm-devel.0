Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7A142AA5;
	Thu,  6 Jun 2024 07:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717659444; cv=none; b=UmssEFCCt11rLI3LtjOTHZIyYSBU8tiuzfMu7fXxu6ZL/f+qXbpMqKhw0LC4ZbZfA/KHJl5YzQt+3H3bZFaWA6020t1BpJTvwpH7LmiFfdgtEzw10BeWLghN/b5Un+IJv9aSRX+NXobotuj/4BMQs9z0+8ntORjnc6ZaAALJLKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717659444; c=relaxed/simple;
	bh=L0K+WiW3ABNuQ3KeIQMajcq2YSoXFPLjMRjl/5b6e80=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VI84M7rGz9XekRL2KKHvpqxJ3GSZwLJXxTPb+WuJcG7Mc1maH0RrnPah6giiz4RLzCy/Cy/B/0TSKHyFVy1tKE57b6UGo1A/Yl2gMwoCTTfGRdXzznVB5koY0uCcMOp0Jd3x4tXELNur1JdxfdXEjbTmtdqOUEV3b9zZ+pIZ40o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gg4KGpOK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gg4KGpOK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 105C6C4AF0C;
	Thu,  6 Jun 2024 07:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717659444;
	bh=L0K+WiW3ABNuQ3KeIQMajcq2YSoXFPLjMRjl/5b6e80=;
	h=From:To:Cc:Subject:Date:From;
	b=gg4KGpOKCxM1PWQkD7wtm028lb0dVxVyeexHnEWK10lXt2GcHL75+KXPOuzW14fSg
	 sMGZsARPXkARgOmaAqKjOEkoUdzTLEzPlViFFnrFykIy8x9jmO8x2wloOBEj5KO1qi
	 jDiRdjUpThROkud8SqkWLODcmcsBRb3jgYys/mgHqdqmmcuTwBTFufZQ/H9er8Rv4R
	 CHju/MoqVdFrNFRzEGXHt/jev33NskCavFHrKKRTBLG320SOBRpQ7Vh6PjyN6/2DpA
	 /X3YantISUA1UC3prWLp86LSOLGnbxK2125BzmCKqWWKPxOKy1juqDEt0zgj0lu3+8
	 F/XwcoBfC7RwQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v5 0/4] Fix DM zone resource limits stacking
Date: Thu,  6 Jun 2024 16:37:17 +0900
Message-ID: <20240606073721.88621-1-dlemoal@kernel.org>
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
 block/blk-zoned.c     |  20 +++-
 drivers/md/dm-table.c |  15 ++-
 drivers/md/dm-zone.c  | 220 ++++++++++++++++++++++++++++++++----------
 drivers/md/dm.h       |   1 +
 5 files changed, 207 insertions(+), 57 deletions(-)

-- 
2.45.2

