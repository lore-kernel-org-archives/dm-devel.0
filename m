Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F2D5BADB
	for <dm-devel@lists.linux.dev>; Tue, 23 Jan 2024 09:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.141.245
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706003040; cv=none; b=dvWrIioezP2M4fieHcKjYSqX0v2OsJ/VCPC8/OnF9FkoCO0gKRtk/grvZA2I8EV2n6E/ImK8NRrsYLBSPSxcU26sxMf1RWYK+DGfw17NsukZJDko39PeQgdD3ze3/T+jLZ4jlO4/6FGIGDE7lpQgmoRMS389QxUGgO04doEGpyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706003040; c=relaxed/simple;
	bh=aNukikOqhJIFNWqZ0ODBJWyAugGq+LPMMd8TTS5AKQ4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Gn4Fhp2RtPWPbVVhev7PtXN+9iOU1aTWOeL2hvfv7S5bELVG3YWLlm2Do4/yTUAmaoIsLlR+CNuvYc/g/5STEtVo1jjsRjXoQulIJjmRPpkXzFnGjlkn99981tTT4pwDI86YuupwEChklHPW216Q8mtAxr+i17tF82i8Qbjb5fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=fHjvuvpo; arc=none smtp.client-ip=68.232.141.245
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fHjvuvpo"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1706003038; x=1737539038;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=aNukikOqhJIFNWqZ0ODBJWyAugGq+LPMMd8TTS5AKQ4=;
  b=fHjvuvpoqzqv7b2Zfw4H5zEBYAyTbdLb/s1ypry1CiY7JEGS+q6QQApp
   fEwEOgTq8mUBb8aeXuJCrCOnWQISA8fg3ayYQjBtRf39MSnzpOjv+WTYb
   WDovVsSA7poJDLT7heuoKvBLEvrTtTPCH1AWTWmsoU7VNr4XL1H4sDjod
   x+6Q1PTuSnjY9PaM0M+6jS90M8YLQM5HE9c+cl4MC88sdMXhXafADlbMb
   Y1zIZ50WODL2tfDZ4Y/Cy/6huB3D5jh6axZ3fp1mVoGVrIPP/IeZuu442
   tz2o6lpziTGXYjS/o3FwfK6z9tGD6lXS9ostwKY0zJVsGPpxzPcwhI18t
   A==;
X-CSE-ConnectionGUID: mFqHj5sYSj2uHQWU3AfHvQ==
X-CSE-MsgGUID: hFFdgTLtS6eac8kYZW4vfQ==
X-IronPort-AV: E=Sophos;i="6.05,214,1701100800"; 
   d="scan'208";a="7743982"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jan 2024 17:43:58 +0800
IronPort-SDR: CLbUrvqNYcx6V+GsJ0EKF8duK63GqhGbdphejj7yH4mQ1+RkbRcbZ8E/Wq7kl2Vspu6QXFVoYt
 V7GOIQHUUudQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 23 Jan 2024 00:48:20 -0800
IronPort-SDR: dAsmsPa7PoEjEqCMQJaraanxOd8c/fk8dACLylRy5NqXD//OMj6y9vGDZHd8BuQxOm/a02BIsW
 R+tMuSbewV1Q==
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 23 Jan 2024 01:43:54 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Date: Tue, 23 Jan 2024 01:43:43 -0800
Subject: [PATCH 2/5] dm: dm-zoned: pass GFP_KERNEL to blkdev_zone_mgmt
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240123-zonefs_nofs-v1-2-cc0b0308ef25@wdc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1706003027; l=991;
 i=johannes.thumshirn@wdc.com; s=20230613; h=from:subject:message-id;
 bh=aNukikOqhJIFNWqZ0ODBJWyAugGq+LPMMd8TTS5AKQ4=;
 b=ikAnavOye/kaxQOEWNUwKqvdUxWGtXZzJ7FWZYYfiyPrwIlpkg/V/fzRFKDthgXe8Ohpt6KhU
 /FHlNMKNb/eDriIYAew0yBQo7R6HpuBpWUzFGRY/CanTb/8FmZgdOJV
X-Developer-Key: i=johannes.thumshirn@wdc.com; a=ed25519;
 pk=TGmHKs78FdPi+QhrViEvjKIGwReUGCfa+3LEnGoR2KM=

The call to blkdev_zone_mgmt() in dm-zoned is only used to perform a
ZONE_RESET operation when freeing a zone.

This is not done in the IO path, so we can use GFP_KERNEL here, as it will
never recurse back into the driver on reclaim.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index fdfe30f7b697..a39734f0cb7d 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1658,7 +1658,7 @@ static int dmz_reset_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 
 		ret = blkdev_zone_mgmt(dev->bdev, REQ_OP_ZONE_RESET,
 				       dmz_start_sect(zmd, zone),
-				       zmd->zone_nr_sectors, GFP_NOIO);
+				       zmd->zone_nr_sectors, GFP_KERNEL);
 		if (ret) {
 			dmz_dev_err(dev, "Reset zone %u failed %d",
 				    zone->id, ret);

-- 
2.43.0

