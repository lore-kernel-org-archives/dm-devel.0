Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1293352F79
	for <dm-devel@lists.linux.dev>; Mon, 29 Jan 2024 07:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706514757; cv=none; b=FVX5yXs+BAvuMbxM9dLCmGyurR96fqJJcWuTC0/oCJCXNxsUYhws/qPCDXNlXON6zuxuQl5Ih5mo023MYxtnftVWwXud0jmzzCmgHlKec4wBFPPlur5JC8tMaMB+6zztw0WtuAPS9CN6DBOFVEOMLG9HOfq6tYZgpZc6BLvWEl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706514757; c=relaxed/simple;
	bh=rp5FcjO4/GYjbF5Qyk/GxKqz5Dm+QfeA7jbL0YYHdsM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=KyAeq2CBVke3JrOpCOEdaY39czmfPCdNJvbaAUzppdxKlr8FH6DvmT2tCLkLXgyzedba/R+YHJew69+eUzJnRA8oola8JAvKseYrHZotQtrGpTWyENX1y0EIMxMOltkA1/2EZWNoeqMIecLvr+c2PZE0GfQND6o+vbmMBGPhk9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BsljqVwt; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BsljqVwt"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1706514754; x=1738050754;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=rp5FcjO4/GYjbF5Qyk/GxKqz5Dm+QfeA7jbL0YYHdsM=;
  b=BsljqVwt88x1I8KARiEYdlfq5mzTxvlXfMhXxdpwQe6RXxESq0b2vXUB
   lNJCAlHsZTbGI0sUyTxzK19ZXTOvRZqvqylQAiM8Uw5cGExsQvV4eOF+k
   ya1e9zBk6f2QSYIneq9XmHHdHH1/cRHmfz6yCeiNvkz5LUBcioa7nGJNd
   DMOO10G/mnwWDI77jqeoQghErql9RPltHAt4FIgWvfUNOI/rkV8p0Iypu
   CuPqQF5WfyNV4WQ2xN5J8EnpkddAVc5KkNPY/BQTpQWdt5Mi1H9iMI1yf
   6CHp52XHgslBHwYIqWcugVFEALnszlNyb5c1/jI0cE1pNV2t/0Z7iJ4al
   g==;
X-CSE-ConnectionGUID: 8Fx+/vPpQAW8TiGgIEN+jw==
X-CSE-MsgGUID: XiDQlMZ1Qau+qeuLdzOafA==
X-IronPort-AV: E=Sophos;i="6.05,226,1701100800"; 
   d="scan'208";a="8194604"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jan 2024 15:52:27 +0800
IronPort-SDR: nIbSFdrhHPQlgavC6HcRyEuEUKwryO2+N+DMj6rp97mUPQbJ6G2GJji2OM1ujSAoJmoudQjIKK
 yx9I46RFjq3w==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jan 2024 22:56:42 -0800
IronPort-SDR: a+xFj1elJxUfjnGbMLQtq4lQiX7ERjA+Y4ZquDyvRef/cnam2FbEjwxso8q5jVbsGBbnmT7XDU
 gx4d10id9lHQ==
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 28 Jan 2024 23:52:24 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 0/5] block: remove gfp_mask for blkdev_zone_mgmt()
Date: Sun, 28 Jan 2024 23:52:15 -0800
Message-Id: <20240128-zonefs_nofs-v3-0-ae3b7c8def61@wdc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADBZt2UC/1XMywrCMBCF4VeRWRuZTC+2rnwPEbHJxGZhIonES
 +m7mxZBuzwH/m+AyMFyhN1qgMDJRutdHsV6Bao/uwsLq/MGQipRShRv79jEk/MmCq0lE3XEWNa
 Qi1tgY5+zdjjm3dt49+E140lO79ehYuEkKVAohR0W2LChav/QaqP8FSYl0X9ZLUvKJel2W6lGy
 brFXzmO4wfFfYJg3gAAAA==
To: Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
 Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>, 
 David Sterba <dsterba@suse.com>, Jaegeuk Kim <jaegeuk@kernel.org>, 
 Chao Yu <chao@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
 Chaitanya Kulkarni <kch@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1706514743; l=1894;
 i=johannes.thumshirn@wdc.com; s=20230613; h=from:subject:message-id;
 bh=rp5FcjO4/GYjbF5Qyk/GxKqz5Dm+QfeA7jbL0YYHdsM=;
 b=2ejVcWAH227cyBcLTAnmQV/viZ0C5PHZhudgyn72fAlTiBCd6IOpK+wyllf64WvtEBVU5sViJ
 8eBBKuHqePeBlFpK16YJ9MZy0ZO2EaU/AF6A2deSt4WZJ/fyuLoWemF
X-Developer-Key: i=johannes.thumshirn@wdc.com; a=ed25519;
 pk=TGmHKs78FdPi+QhrViEvjKIGwReUGCfa+3LEnGoR2KM=

Fueled by the LSFMM discussion on removing GFP_NOFS initiated by Willy,
I've looked into the sole GFP_NOFS allocation in zonefs. As it turned out,
it is only done for zone management commands and can be removed.

After digging into more callers of blkdev_zone_mgmt() I came to the
conclusion that the gfp_mask parameter can be removed alltogether.

So this series switches all callers of blkdev_zone_mgmt() to either use
GFP_KERNEL where possible or grab a memalloc_no{fs,io} context.

The final patch in this series is getting rid of the gfp_mask parameter.

Link: https://lore.kernel.org/all/ZZcgXI46AinlcBDP@casper.infradead.org/

---
Changes in v3:
- Fix build error after rebase in dm-zoned-metadata.c
- Link to v2: https://lore.kernel.org/r/20240125-zonefs_nofs-v2-0-2d975c8c1690@wdc.com

Changes in v2:
- guard blkdev_zone_mgmt in dm-zoned-metadata.c with memalloc_noio context
- Link to v1: https://lore.kernel.org/r/20240123-zonefs_nofs-v1-0-cc0b0308ef25@wdc.com

---
Johannes Thumshirn (5):
      zonefs: pass GFP_KERNEL to blkdev_zone_mgmt() call
      dm: dm-zoned: guard blkdev_zone_mgmt with noio scope
      btrfs: zoned: call blkdev_zone_mgmt in nofs scope
      f2fs: guard blkdev_zone_mgmt with nofs scope
      block: remove gfp_flags from blkdev_zone_mgmt

 block/blk-zoned.c              | 19 ++++++++-----------
 drivers/md/dm-zoned-metadata.c |  5 ++++-
 drivers/nvme/target/zns.c      |  5 ++---
 fs/btrfs/zoned.c               | 35 +++++++++++++++++++++++++----------
 fs/f2fs/segment.c              | 15 ++++++++++++---
 fs/zonefs/super.c              |  2 +-
 include/linux/blkdev.h         |  2 +-
 7 files changed, 53 insertions(+), 30 deletions(-)
---
base-commit: 615d300648869c774bd1fe54b4627bb0c20faed4
change-id: 20240110-zonefs_nofs-dd1e22b2e046

Best regards,
-- 
Johannes Thumshirn <johannes.thumshirn@wdc.com>

