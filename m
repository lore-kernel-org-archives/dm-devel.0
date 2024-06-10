Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657D446BA0;
	Mon, 10 Jun 2024 07:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718006217; cv=none; b=iQ87ELKwzLSPU8bkSTwI22hULm/0fRnEQ5OrLyek4quRLlLHSe4I2kvleI1lhme0+dX0ivMaL0zv6X9fPe+IP3ciJ6yL9n0FexUGvpE/BJcZehs6B0bT4BsbGvf3aLj9YOCbTsfEHS6ekLCUXswm9pR8om9Ps1BjvwfGzyjG/II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718006217; c=relaxed/simple;
	bh=rnmBcxwtSnQldADxVBtmJAcLgiPYn7TBvheFlV0cwVY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DfR7KHpSsc7C4T3j0p0e8tXczcV/5okXtXJWKt77WG5cVrX4Llb2lcUUtq8rZfwpaE0UDSBz9S8hIzg2kmE7+YpeErI0sUVNiMEfO1Mx0mhDEtZ8G6uA2IB7DzEcheFKg3Ki397kyC3AoX3FkadTsSK94/fuvqkRQXYOBQ1ye4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ym6aNJpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ym6aNJpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60610C4AF1C;
	Mon, 10 Jun 2024 07:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718006217;
	bh=rnmBcxwtSnQldADxVBtmJAcLgiPYn7TBvheFlV0cwVY=;
	h=From:To:Cc:Subject:Date:From;
	b=Ym6aNJpXoy+R1ZGvEPnjOt+hzgkeeqy4PMQacn4j0JLm6BX6BNbpX0duUuBtZPPSQ
	 BpoLxFAnNQq1ttwQCZHE1U+izkNLumuwdyxW9gj7uiU+Jt30WMLPwGUsbXevxIgyxx
	 DfsqV4hlfRVxl2MZ0J+qMa3TzUbT0KzyZ6qNFDqrFWMkSP1jWnY35aBpIEj1Luaqu1
	 ZVn0nZiUPETVgpw5J+YXOyiuXO2odoemxbyAjLLxg6jOlQoWlkYtAsnw8J7HZV7N7P
	 lw3NN6cODuUIBANriKrXsoynFzkYaEWpiCT6G5aSsy3LZi7mv1ImqvmnjJVVieW72h
	 IdJczoVZH2k8Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>,
	Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v7 0/4] Fix DM zone resource limits stacking
Date: Mon, 10 Jun 2024 16:56:51 +0900
Message-ID: <20240610075655.249301-1-dlemoal@kernel.org>
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

