Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214D45BADB
	for <dm-devel@lists.linux.dev>; Tue, 23 Jan 2024 09:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706003037; cv=none; b=T9HZRQ59DOd+LKune/lTju+8fI9/uoE4oJa+ol5BWg/o32p39dmcNkbXrCFSrTF+Dwy4nRTJsa0TVFBEwExoE+v18IG6FOtWl6k0nzQaTtj3BI9vjkTHvxU6vHLG5C1H1byut04tGngHCNNV1Amu0Z+ur3y6ap17HlgP+7yDZUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706003037; c=relaxed/simple;
	bh=USx+V+gR/5Lk+0GJr2lbq1FeCI2pXKMzpek+ct39bMM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=pmOquXHVeRr7YHiQsgKQFrY30keXNX/l6r/xQa0tJ0wfSLd+ZoYInNEFGEaBK3xNJLUVNU/rDg8ENB3lKHqod2qczlZHh5SAFj1mQ1l9ScqbStY5CT3+VOC6V6XVaCicvXRfhZzmEnAFxjXASCfyKXhwmVYlkov8MairqqGFvqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=kmfVXeOq; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="kmfVXeOq"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1706003036; x=1737539036;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=USx+V+gR/5Lk+0GJr2lbq1FeCI2pXKMzpek+ct39bMM=;
  b=kmfVXeOqqQVRRA+NAECdR163sFSw279kgCOknBgXwRPr24LW7ePRnHtW
   rc9XFRVmSaucqrOcHfv8x7BeVrkyv8kS227Vz88LQ+/7A1UlNZnLQhE5r
   UF4nf0EaVyuRNIF+148oJsUrpDgmP8j6TkX0+j9Sdxk5zcuzVg07kiIub
   z0ybsKwxwr56dGiH+sc+ElOC20dZJqGgERP2bMpLqInMyVlvOEbqgnZyB
   DKZvJMlrVDEXzinsiIb+iKoKYMOumy1+klNtu7EP6ngN65KrGpBiBiM+i
   RWUocQURSfol3OA1rpUJYY4cy1XeH9Q4+HDcJWrOoNAewUmmFb2vOB3lL
   A==;
X-CSE-ConnectionGUID: VQJfZ8NmTT2Nt2yMYW0EZA==
X-CSE-MsgGUID: 0F8C21f9RQ+wyhxkn3zY4Q==
X-IronPort-AV: E=Sophos;i="6.05,214,1701100800"; 
   d="scan'208";a="7743973"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2024 17:43:55 +0800
IronPort-SDR: bhiSt19Q9Hi8u6S7iCNHcHM01NIYsBRI66wnSZIJhQBIkSDctggsZxSNwBfjn2hUxYwlL1s7W1
 h9fNXR/7zGpg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jan 2024 00:48:17 -0800
IronPort-SDR: P3OOCgnEiOoiT5kro0hhE2puMVinRxHrlbO9eu21ZDBzEa4K+SZFeEYuAtZNHIp7Zz4lNvn0Hv
 sg9b/x3sDNFA==
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 23 Jan 2024 01:43:50 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Date: Tue, 23 Jan 2024 01:43:42 -0800
Subject: [PATCH 1/5] zonefs: pass GFP_KERNEL to blkdev_zone_mgmt() call
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240123-zonefs_nofs-v1-1-cc0b0308ef25@wdc.com>
References: <20240123-zonefs_nofs-v1-0-cc0b0308ef25@wdc.com>
In-Reply-To: <20240123-zonefs_nofs-v1-0-cc0b0308ef25@wdc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1706003027; l=967;
 i=johannes.thumshirn@wdc.com; s=20230613; h=from:subject:message-id;
 bh=USx+V+gR/5Lk+0GJr2lbq1FeCI2pXKMzpek+ct39bMM=;
 b=CqyzAxjrtVF3h1COiTD1vUp/FvMExp42Wy7b72mtI/+VK3Cc+nQQgb8KdYlLZ32Qn9DwLPhCQ
 2dpOdt+5tGWBTomHGv+qgGPRnYLx+GcwkDEU2N7SunPs8Zz3A98pXO5
X-Developer-Key: i=johannes.thumshirn@wdc.com; a=ed25519;
 pk=TGmHKs78FdPi+QhrViEvjKIGwReUGCfa+3LEnGoR2KM=

Pass GFP_KERNEL instead of GFP_NOFS to the blkdev_zone_mgmt() call in
zonefs_zone_mgmt().

As as zonefs_zone_mgmt() and zonefs_inode_zone_mgmt() are never called
from a place that can recurse back into the filesystem on memory reclaim,
it is save to call blkdev_zone_mgmt() with GFP_KERNEL.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 fs/zonefs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 93971742613a..63fbac018c04 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -113,7 +113,7 @@ static int zonefs_zone_mgmt(struct super_block *sb,
 
 	trace_zonefs_zone_mgmt(sb, z, op);
 	ret = blkdev_zone_mgmt(sb->s_bdev, op, z->z_sector,
-			       z->z_size >> SECTOR_SHIFT, GFP_NOFS);
+			       z->z_size >> SECTOR_SHIFT, GFP_KERNEL);
 	if (ret) {
 		zonefs_err(sb,
 			   "Zone management operation %s at %llu failed %d\n",

-- 
2.43.0

