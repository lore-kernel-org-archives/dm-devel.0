Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ACD25BADB
	for <dm-devel@lists.linux.dev>; Tue, 23 Jan 2024 09:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706003034; cv=none; b=EpsM5BKa2fywFrX5JUPbEaxqoL39veW0Zbew16pvqraaaUOJtds05gA5RbT+YDOGA8apqdOsdPE0vkduBL6Q/viw/u8aO0hPAlpKXepJOqDfYNw3Oy3MTOD8JMcMXHhoEUkZ6LbSN+sFf+re5/x9iK3wEqYGae55nL0OoA0JxPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706003034; c=relaxed/simple;
	bh=/4h6qYS/eHpSlVim37uPdGcbFkvmnDTQ5JZLyrLcZnE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ZJ9zSc0G6wdP5sUOq4xno64eSm8I6MlL2te/87GKNMmaqlUePyxhd2qNQB8dcW9fQoM+NqiT4bCQYh+X2KB16a0s1U1mcKXPoQu6rmh9ThoyZJGD6nZJBXGfFt8q3hA478jWyJYHy/Uwy47v6ruPBmQg5EsdIRXunpboAtRv+tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=BZounjcf; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BZounjcf"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1706003032; x=1737539032;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=/4h6qYS/eHpSlVim37uPdGcbFkvmnDTQ5JZLyrLcZnE=;
  b=BZounjcfJC/4TDPLtoqToETNwnCu/atG+5VfXANRQNW8ExJ/mQjtNX8y
   Pe9rYpOQr0F4PlVbn6sriS6XiLZdYswBFx78ab4ju+KVaOOKYGJBqehwu
   rSeTik3Lr6cKp9l84LX/sRnd1Tqh6WFDLGnAonYupnvp4I9fsHF1V0le/
   N86ahugTaRLESBsRqJ5sC/CZQDe+6VH++az38oxJXQpIn+3uXlKI+P4s5
   1Ww78mupWAQY2ovwJTRHx1JSQvSQARAT6fmy7mdsPYg/el82qWWPcvffK
   mgyI2qdglPZpctt87svr4UTcVN11OIe0I4M59v9DzeHNQIYq8nM/gsewU
   g==;
X-CSE-ConnectionGUID: YDTXav91RXS8x04klnPFZg==
X-CSE-MsgGUID: g/qo+xFVR9S+bYrVQ8iD8w==
X-IronPort-AV: E=Sophos;i="6.05,214,1701100800"; 
   d="scan'208";a="7743959"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2024 17:43:51 +0800
IronPort-SDR: k4e5CjjsytrhOaR9dEyiyVnFzE/0I+YOKQDMAJKjtfH3kmM8cZW4m336mnNrXPiVYLNTfPjKck
 fIhkXSGmrZtA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jan 2024 00:48:12 -0800
IronPort-SDR: zUnRHHmVsKHmYWHqPESmgsAEmU5gU8xkWm6MN/q4pTyWM+A4c3LciGXWMEKUbx1GLBqQ7hfn4G
 QMsyEBuf/JKg==
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 23 Jan 2024 01:43:47 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/5] block: remove gfp_mask for blkdev_zone_mgmt()
Date: Tue, 23 Jan 2024 01:43:41 -0800
Message-Id: <20240123-zonefs_nofs-v1-0-cc0b0308ef25@wdc.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAE2Kr2UC/x3MMQqAMAxA0atIZgtpKA5eRUTUppqllQZELL27x
 fEN/xdQzsIKY1cg8y0qKTbYvoP9XOPBRnwzEJJDa9G8KXLQJaagxnvLRBsxugFacWUO8vy3aa7
 1AzrU4INdAAAA
To: Damien Le Moal <dlemoal@kernel.org>, 
 Naohiro Aota <naohiro.aota@wdc.com>, Mike Snitzer <snitzer@kernel.org>, 
 dm-devel@lists.linux.dev, Chris Mason <clm@fb.com>, 
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>, 
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>, 
 Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, 
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, 
 Johannes Thumshirn <johannes.thumshirn@wdc.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1706003027; l=1540;
 i=johannes.thumshirn@wdc.com; s=20230613; h=from:subject:message-id;
 bh=/4h6qYS/eHpSlVim37uPdGcbFkvmnDTQ5JZLyrLcZnE=;
 b=XWApU1yRY0zet3szE9Y5YwxO0lp/MB+nH+oGhmBdyhChEBIQpYa6r7zw4rgXKerbrVnIXc2mT
 UtgASe05xPWAqN+bStf/4/hcrd6JLPpuUKW556WA7lZY9ZeLtErtKq6
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
Johannes Thumshirn (5):
      zonefs: pass GFP_KERNEL to blkdev_zone_mgmt() call
      dm: dm-zoned: pass GFP_KERNEL to blkdev_zone_mgmt
      btrfs: zoned: call blkdev_zone_mgmt in nofs scope
      f2fs: guard blkdev_zone_mgmt with nofs scope
      block: remove gfp_flags from blkdev_zone_mgmt

 block/blk-zoned.c              | 19 ++++++++-----------
 drivers/md/dm-zoned-metadata.c |  2 +-
 drivers/nvme/target/zns.c      |  5 ++---
 fs/btrfs/zoned.c               | 35 +++++++++++++++++++++++++----------
 fs/f2fs/segment.c              | 15 ++++++++++++---
 fs/zonefs/super.c              |  2 +-
 include/linux/blkdev.h         |  2 +-
 7 files changed, 50 insertions(+), 30 deletions(-)
---
base-commit: 7ed2632ec7d72e926b9e8bcc9ad1bb0cd37274bf
change-id: 20240110-zonefs_nofs-dd1e22b2e046

Best regards,
-- 
Johannes Thumshirn <johannes.thumshirn@wdc.com>

