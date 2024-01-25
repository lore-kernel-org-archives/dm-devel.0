Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081B413DBB2
	for <dm-devel@lists.linux.dev>; Thu, 25 Jan 2024 16:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.71.154.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706201630; cv=none; b=HJYegt55VErXBfz6wBzln4ovMfXPx9ytggXnV1Rwo1E0NpNnJl6PvrOFhQD9RFF18QWyXBL+Vdld0V7gIxGAfDbCYG3YTAq/kQkJ6By8wlWzRZ8XAQHfAOlSwng1Hgc0UShfYLrVVYdBAJq2uqICgiNraf7HGijK0hOOYcGTMo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706201630; c=relaxed/simple;
	bh=CVSDtwbfJeIFTP08Wyxu5GIZXiQgdv2rMRXO0YSre0A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PaC+NsPHfSUa/TddDKqt4fY0hoEmQdMF+yoEqb2xkrv4IzkZ5SZ5gMJK/JNkEZSqdKRxp4kV3UkVq2c8G8phIdXbIBZ8ADd/C4JSoRF12os+98zYj94MkYAb54z8hj7GQ5tBTyrP8tFH3dFGtr9chQWeb73JWyiuUWcgZYgi8n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=SJPHPtd8; arc=none smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SJPHPtd8"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1706201629; x=1737737629;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=CVSDtwbfJeIFTP08Wyxu5GIZXiQgdv2rMRXO0YSre0A=;
  b=SJPHPtd8ZuPoonZag0xyykEjuPbgvMXBtkHq4jvwJo+cMvLNED57M5OV
   IacS/QNdNBOFyKLGS4Qeey2eDDzms1Fym3CXzWteePK2hlA6j+cgOv5Wp
   s6MSaDsDrOm2X3tk4MFd0H7dP5UZpMqsg6Yro5PaTB7yEGKxXJxHxaIM1
   OGjqc4Aerzs5nSe4JmJZP8umWBRte+Z9OOhJbR6p8CFiPGaZbHING5oAs
   ZWmv7i5RhEFTjBRHtjLy/5E9ImTMkLE2bgYACX9I7emFL17LCKrvOBqrd
   iBq2H5mzQyDHfqeyLRD1l/lqxXkqvWmI7mOIuCZ2AaxFvaSRvFASATFFh
   Q==;
X-CSE-ConnectionGUID: heRXptkGTsGk/8O+yOiiUA==
X-CSE-MsgGUID: oIGumv2tQkijz1ucYLCi4g==
X-IronPort-AV: E=Sophos;i="6.05,216,1701100800"; 
   d="scan'208";a="7456551"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jan 2024 00:53:40 +0800
IronPort-SDR: 3k1j8nPszUqnjCGnJDlUk7KRIjxuF36hGUv5V4U+54cPJhKP4Y70/I9200XucP/pdLOLlMYaY/
 HN2M3PrRRtCQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Jan 2024 07:57:59 -0800
IronPort-SDR: sBgbgkN5bVB0enbBw/iyb8cMMu+2pAh1JkthbGxPDDItWfESaHFsqFp68AyWN5LkQ+syR4acGA
 0IKcbDNJkDbA==
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip01.wdc.com with ESMTP; 25 Jan 2024 08:53:37 -0800
From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Date: Thu, 25 Jan 2024 08:53:25 -0800
Subject: [PATCH v2 2/5] dm: dm-zoned: guard blkdev_zone_mgmt with noio
 scope
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240125-zonefs_nofs-v2-2-2d975c8c1690@wdc.com>
References: <20240125-zonefs_nofs-v2-0-2d975c8c1690@wdc.com>
In-Reply-To: <20240125-zonefs_nofs-v2-0-2d975c8c1690@wdc.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1706201608; l=1101;
 i=johannes.thumshirn@wdc.com; s=20230613; h=from:subject:message-id;
 bh=CVSDtwbfJeIFTP08Wyxu5GIZXiQgdv2rMRXO0YSre0A=;
 b=oFwFIqk+a1bu3Gme4liw+RG2cMT5QTjli7I99okyi7hJJltokvsxJSP+mr+nCDIrJWXq34TTT
 jsVdpNzfNZbAcO1z7yd2EbMw7/v2dBFV8630y+/qR9JS2+Bul5QIMOO
X-Developer-Key: i=johannes.thumshirn@wdc.com; a=ed25519;
 pk=TGmHKs78FdPi+QhrViEvjKIGwReUGCfa+3LEnGoR2KM=

Guard the calls to blkdev_zone_mgmt() with a memalloc_noio scope.
This helps us getting rid of the GFP_NOIO argument to blkdev_zone_mgmt();

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/md/dm-zoned-metadata.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
index fdfe30f7b697..165996cc966c 100644
--- a/drivers/md/dm-zoned-metadata.c
+++ b/drivers/md/dm-zoned-metadata.c
@@ -1655,10 +1655,13 @@ static int dmz_reset_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
 
 	if (!dmz_is_empty(zone) || dmz_seq_write_err(zone)) {
 		struct dmz_dev *dev = zone->dev;
+		unsigned int noio_flag;
 
+		noio_flag = memalloc_noio_save();
 		ret = blkdev_zone_mgmt(dev->bdev, REQ_OP_ZONE_RESET,
 				       dmz_start_sect(zmd, zone),
-				       zmd->zone_nr_sectors, GFP_NOIO);
+				       zmd->zone_nr_sectors, GFP_KERNEL);
+		memalloc_noio_restore(noio_flag);
 		if (ret) {
 			dmz_dev_err(dev, "Reset zone %u failed %d",
 				    zone->id, ret);

-- 
2.43.0

