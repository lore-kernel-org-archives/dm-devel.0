Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2156255E5C;
	Wed,  1 May 2024 11:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714561750; cv=none; b=WflcJZeXqx6oQpCzudhdgAsEBw77A1xyTwlRneTn44JS45nbOEjuHkga0qQqcwIn6vIXtmwKMTK449MRg838y1X7V9jBQg2Gaa1elhcSFeS4yg6ga0+3iilTsBVhBeuKxsvn0GhmDZ7BRwaCNY9dTU5YFnxaUfk6BYUshlhbU7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714561750; c=relaxed/simple;
	bh=wUwUZ80gGl66idWUjcG5fEc8n8bJt1XPFcSZD5GRzTI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=tjxY7SsxD5t6kVxQ1oITTSiv2CyT6xPv4KOJyTLKH1vCBoCTXQSDZ7UI25cbv7YG0XEvTOwkd8ZZi9Gt4IiltWFvkmDKZmO7PaZcC4qyoP+z0lyeMaiB4JYsp9TUvcJFGenXSSTcsf3nsHd6GVX8IHa8FgrqD7sn8VZNDU3TbKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGiiE3qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGiiE3qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D616DC32789;
	Wed,  1 May 2024 11:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714561749;
	bh=wUwUZ80gGl66idWUjcG5fEc8n8bJt1XPFcSZD5GRzTI=;
	h=From:To:Subject:Date:From;
	b=TGiiE3qfoeMHZVZW3a+BYgguUD9UmD4TYyqfAm3NtXPVvhaxHL7nKyfuuvIGFZDgd
	 AyOrX3nZyQaPfD6+6098fW7KwhQNA9WIjj337/QJowOY8lWgd4ruPuk+awqgFzYhGQ
	 /RkGyRzgrlw981DWmiezjkVqPIeEe8Nx6psYlJdi0HGNO9wEOM22IJcTBZEGExjpTD
	 3jIYPe9sxoD839pZ8dAt0BtkrEINq2aVwQNgaiCYjJF8QzDw3uyPWLAIN0V6ySqn2b
	 qX69+oSRjJgiGo09wk9JIlgimTge1TmYha7jJCPOzvCJVp6vRF8BUUm8AiKCNZK0C0
	 zwOnYX2WC2n2A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 00/14] Zone write plugging fixes and cleanup
Date: Wed,  1 May 2024 20:08:53 +0900
Message-ID: <20240501110907.96950-1-dlemoal@kernel.org>
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

Changes from v2:
 - Fixed comment in patch 1
 - Addressed Christoph's suggestion in patch 2 (mempool_resize call).
 - Added review tags

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
 block/blk-zoned.c     | 403 +++++++++++++++++++++++++++---------------
 block/blk.h           |  12 +-
 drivers/md/dm-table.c |   3 +-
 drivers/md/dm-zone.c  |  57 ++++++
 6 files changed, 335 insertions(+), 155 deletions(-)

-- 
2.44.0

