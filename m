Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C628116F844;
	Tue, 11 Jun 2024 02:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718073403; cv=none; b=DBqR+GuvA+c3YWujvmNTyE5wwhqsmsQ35XDqoOKqKXQb5lL6xgQo2uFOyRdb4iqRkQ78kVWLkX+q7OEQUn31CgiEQr15cZ0hXaWCTxAPvs9Q8//0hh57cCdcVsapNv2hmUjSz7fjO5Fm7aPki9B+A/QUCjfolRcl/E3gy83iHZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718073403; c=relaxed/simple;
	bh=qGAtCihYbDPzQC8H87WRFsCOLSxp4EoNPL8oaF6G6a8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kLqjrgfa9t5A1y+5gXfpCivOkZ7SblUPBdmEkEFA1i3kcV1wsM6vDnx5WaT+vdVqy3URbXhiVmqZ33G5QgVTIagC4ss1DPSZb9ujBsWDtcqVfp9kmb0bVaBPvuxzmXfDhcLYZu2yGCRY0jK3TixCXPvy7gFfB8iU6W9HMqDnmGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZrexgMrk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZrexgMrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AA3C2BBFC;
	Tue, 11 Jun 2024 02:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718073403;
	bh=qGAtCihYbDPzQC8H87WRFsCOLSxp4EoNPL8oaF6G6a8=;
	h=From:To:Cc:Subject:Date:From;
	b=ZrexgMrkgNtBnHyIXSr4SBoQwSz1sg//qvvsRNpNqdm/A6J5UWMaq0TaLconLGf9b
	 U//WesEv8M/sJfIMbVIr1S4fv7DxVGHLUTrpmzD/N4Z1oN1gnX4alo99Ma+jYpQtFN
	 T3BbE/rtGdavnKj69AYrN3qr9qAGUm+UqiVNM9dIEExcqkiGtapLGIGd+krzNHDRWc
	 1W94sHuXGulmugEQru+2bcFK5HeX+3vtWRLF0reOzb/O0DxfwU77rjI8SzfBacReRg
	 yr1oAlqOGcXnZmUDUFymQXBWu7dkfmo9KBf2lTq+Vim2K/kHWvEpY4rigzYk+hpuAP
	 HVXmk7mw3DQjQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v8 0/4] Fix DM zone resource limits stacking
Date: Tue, 11 Jun 2024 11:36:35 +0900
Message-ID: <20240611023639.89277-1-dlemoal@kernel.org>
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

Changes from v7:
 - Moved v7 changes mistakenly added to patch 4 to patch 3 where they
   belong.

Changes from v6:
 - Modified patch 3 as suggested by Niklas (moved the increment of
   zlim->mapped_nr_seq_zones after handling zc.target_nr_seq_zones == 0)
 - Rebased on rc3
 - Added review tags
 
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
 drivers/md/dm-zone.c  | 205 ++++++++++++++++++++++++++++++++----------
 drivers/md/dm.h       |   1 +
 5 files changed, 195 insertions(+), 54 deletions(-)

-- 
2.45.2

