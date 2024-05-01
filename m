Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4E4F10F4;
	Wed,  1 May 2024 00:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522177; cv=none; b=lW2VsN4pMlkbSDzf4D4QVfkAjoc8vvrfOpI2Sm1vv6twQZ/30Ur6DZKg1Z7zNOaEYxU785Ci/+EV4CT8SKAeFEHZJo+GbgqE8x4QqWnnhFRRh1E7btTByhs5BbIxqVh3fbY1+0sU5wwMPbyT63W1yE1rMKxkGWiZt6/kJ4xdJRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522177; c=relaxed/simple;
	bh=sOTOshkpbQbsJkVc1P//maH/b0XmB/j5rgwXc0sBu1s=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=QXueFmLZmYqSSF5Z0KWLq3Lay1uZJl1S3f6YmrExUJbqAVJcVyU0EPQz1w03+Mnz6UL3WDMZ/E4u4Eo3Am81hRaSFbNnsEzrNxfp60yc5W3uHyuP5gMlpN8+gzIVc/C1kgk7mbHIsGLLczIAVphO8ZC5qHaXPt4kRZ4RCv5rfIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C5PHm71M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C5PHm71M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8102EC2BBFC;
	Wed,  1 May 2024 00:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522177;
	bh=sOTOshkpbQbsJkVc1P//maH/b0XmB/j5rgwXc0sBu1s=;
	h=From:To:Subject:Date:From;
	b=C5PHm71MHLImg3WMwNdHsht2mcscJWlg7dzzYFzyn3uPIFPVQ8XSAlw1uFRrwV4Us
	 peKoO5/6LgdeJzWCplGCXdN5Jb4z6DD8+fRa+T9JfO6zcKGZDJptwex9XT4oZTsifM
	 Rtnwke3F60CaTHc3Q1khzQ01Yw3qY/hi2gWG/fJxQsgAdDOkVGlTdO8ocNZcQIcInh
	 r9CfxO3QJ3eTtvzt4XzqurIEB2lb8eyYcYJjOboyELHOafXzVmflkshsEL+E98UHhw
	 gUrOUN3hQtzEcs7iy9mzf812ZUGkHoLzzHkRFkMEyivQbDRNRcXFRaEs3LdmHGnsVH
	 xzgnIgjptDHfg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 00/14] Zone write plugging fixes and cleanup
Date: Wed,  1 May 2024 09:09:21 +0900
Message-ID: <20240501000935.100534-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jens, Mike,

With more testing of zone write plugging on more device setups,
including weird/test setups (with scsi debug and null_blk), several
issues were identified. This patch series addresses them and cleanup the
code a little to try to make it more obvious.

The first patch is a DM modification to not expose zoned devices
composed solely of conventional zones as zoned block devices. The second
patch is a fix partly related to this to expose a correct max open zones
limit for devices with no limits (which DM devices are as the max
open/active limit is not propagated to the mapped device as there is no
easy way to do that).

Patches 3 to 9 are bug fixes. The most serious problem among theses was
detected with tests using scsi_debug zoned devices and is fixed in
patch 7.

Patches 10 to 14 improve and cleanup the code.

Changes from v1:
 - Changed patch 4 as suggested by Christoph
 - Added additional comments in patch 7 to clarify the check for the
   zone write plug reference count in disk_should_remove_zone_wplug()
 - Added patch 14
 - Added review tags

Damien Le Moal (14):
  dm: Check that a zoned table leads to a valid mapped device
  block: Exclude conventional zones when faking max open limit
  block: Fix zone write plug initialization from blk_revalidate_zone_cb()
  block: Fix reference counting for zone write plugs in error state
  block: Hold a reference on zone write plugs to schedule submission
  block: Unhash a zone write plug only if needed
  block: Do not remove zone write plugs still in use
  block: Fix flush request sector restore
  block: Fix handling of non-empty flush write requests to zones
  block: Improve blk_zone_write_plug_bio_merged()
  block: Improve zone write request completion handling
  block: Simplify blk_zone_write_plug_bio_endio()
  block: Simplify zone write plug BIO abort
  block: Cleanup blk_revalidate_zone_cb()

 block/blk-flush.c     |   3 +-
 block/blk-mq.c        |  12 +-
 block/blk-zoned.c     | 407 +++++++++++++++++++++++++++---------------
 block/blk.h           |  12 +-
 drivers/md/dm-table.c |   3 +-
 drivers/md/dm-zone.c  |  53 ++++++
 6 files changed, 334 insertions(+), 156 deletions(-)

-- 
2.44.0

