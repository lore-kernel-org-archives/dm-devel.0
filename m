Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0043E1586E7;
	Tue, 30 Apr 2024 12:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481494; cv=none; b=mOHY3ffGVF+Ztd7GGBtjh8AVOk67ut4MQ8ouIAMaTPRzhGo46S/PxrKADkkQXYaKjy8CgZdFyFlMmQiWYpFqvHHG5aEaDV3IOS0si75a5p5IHnJhZ9vOYCrpMQtCEWPi5ZisEwb8Zo/ulgdD96/NCFTCPQwQNt4hu9PQCq+NCi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481494; c=relaxed/simple;
	bh=13EJIdDIIKJvQbnawLVU0hRJU4zgM5cCsm5gxmSqovg=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=gKHLkq5tKL2tgSmIrLBZMqJXmg4oYnkT7yvCNpETwXQuW3uv1UHj1jA65z/pbbbiVER9fwCsdf6y6fH9Dn/O+/xiRr8evWhxeWOQL8XBEmYM/CjlgMueSfCLqaA/ZK/Z9CSmypqpTV8rDCaQPlcFj2m2HIGI+LWI8NDz/wy3W7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qlOGMI+Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qlOGMI+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDABFC2BBFC;
	Tue, 30 Apr 2024 12:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481493;
	bh=13EJIdDIIKJvQbnawLVU0hRJU4zgM5cCsm5gxmSqovg=;
	h=From:To:Subject:Date:From;
	b=qlOGMI+YgLDLZbUjODAX2aDCCwUkRz5ou4MAkq60HvniLa82IOFLePRbcWqZNK/HO
	 /C6pOnP5tjIXNC4kyFuyijoErb6K53c6GI4mWWXAMDN/PJ6khI+LT4v0RXUqsrX9GY
	 Djq764k0x6sanDPrAHO7rSeCcbqwLloGFQSStV+NveSKyHqgO2dpwGaNc6H+9lnf+b
	 1P8dI/r6agEePuwEfoFd2OjQrjEDIuTMOt/QsduhwU7/1AAJtvpqRrwDWl6IACFbic
	 SmXeDoFd1IvuiYOrBDq5Rt/NK9qWlUUM053FytlSk305gaJlCEJbq9vKugLmgR1E3a
	 J8+gQnvuMwmuQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 00/13] Zone write plugging fixes and cleanup
Date: Tue, 30 Apr 2024 21:51:18 +0900
Message-ID: <20240430125131.668482-1-dlemoal@kernel.org>
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

Patches 10 to 13 improve and cleanup the code.

Damien Le Moal (13):
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

 block/blk-flush.c     |   3 +-
 block/blk-mq.c        |  12 +-
 block/blk-zoned.c     | 269 +++++++++++++++++++++++++++---------------
 block/blk.h           |  12 +-
 drivers/md/dm-table.c |   3 +-
 drivers/md/dm-zone.c  |  53 +++++++++
 6 files changed, 243 insertions(+), 109 deletions(-)

-- 
2.44.0

