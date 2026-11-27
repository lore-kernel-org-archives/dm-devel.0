Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.28.132
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795744341;
	b=dkaRkwtwuTFaj+naKrglQgYnSam9CvtP+p3U9luV/P1qW6iQr73RfzAGDzmCyluNqM0U
	 AqXOmXBNfvGLX9/edldqApC+YrSe2rMr0tBfBM6uhY2h3+qawEWA6XllZJvDnqMI/OPI2
	 4xE4yx+HyIJv7meuQbRwmZfSvjGxcx3F3cXioq7kz5blGWb0P9xvaG0Gid5XgbQ5VWmYF
	 RTuLJLG3bDK+sAKamj+h2PvMlZstU3RVWKEUkHdJR5p0P2IbMD6pT56MHWR85b/fQ8FJz
	 4djA8x8HxNU0xGPBGGQecX0Jqr2KfDvdGKnCJmb9ObcQxVXEKGzqF/NYSQthnLJuXxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795744341;
	h=DMARC-Filter:X-Alimail-AntiSpam:Received:To:Cc:
	 Content-Transfer-Encoding:Mime-Version:X-Mailer:Received:
	 X-Lms-Return-Path:From:Date:X-Original-From:Subject:Message-Id:
	 Content-Type;
	bh=egpCMpGZUF06mI6a6aM7SRvDsxIQGsgzLEBD/eo7jDM=;
	b=FvgTZ0Ehd3ugn4xabWD8AtN7UfXF9CEedoIeoJqrS7lhbfhdoEKf6QPKcqXBAGKIEPf8
	 IlZxlHs0IHyNN8GxJYJOQumfwiVgdElbELlegAqa0OHQVyPc20lzFPPVuHw/MvAmD1NGm
	 hs3P6nyRVZmW8w8d/akBnuAuKFJsLzAXPxFNF5khfIjVr8gotbBNYMWYcPXhsLCWMAeOQ
	 WDudn0JVQvUfiQRNfIpreICJLZUSNfR+bHIxhe9qijnUhee9WKj7zlY2x6j4D4+Zb8nxi
	 NqMa8Z024LL0hLLip/UYEY+m2y/ax7pqyvOlnAG5ebHCrkY7fdJPjr20JfFwoWkFOyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=kaihong.com;
	spf=pass smtp.mailfrom=kaihong.com;
	arc=none smtp.remote-ip=115.124.28.132
Received: from out28-132.mail.aliyun.com (out28-132.mail.aliyun.com [115.124.28.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB87606A324
	for <dm-devel@lists.linux.dev>; Fri, 27 Nov 2026 01:52:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BB87606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kaihong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kaihong.com
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.3620886|-1;BR=01201311R111S36rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00388624-0.000126094-0.995988;FP=7059271255388518362|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037034020;MF=haoruiqiang@kaihong.com;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.kB6Kq.Z_1795744328;
Received: from localhost(mailfrom:haoruiqiang@kaihong.com fp:SMTPD_---.kB6Kq.Z_1795744328 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 27 Nov 2026 09:52:09 +0800
To: "Dongsheng Yang" <dongsheng.yang@linux.dev>, 
	"Zheng Gu" <cengku@gmail.com>
Cc: <dm-devel@lists.linux.dev>, "Ruiqiang Hao" <haoruiqiang@kaihong.com>, 
	<stable@vger.kernel.org>
Content-Transfer-Encoding: 7bit
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0
Received: from ubuntu24-dev.. ([219.142.21.190]) by smtp.feishu.cn with ESMTPS; Fri, 27 Nov 2026 09:52:05 +0800
X-Lms-Return-Path: <lba+26b08e246+e4db54+linux.dev+haoruiqiang@kaihong.com>
From: "Ruiqiang Hao" <haoruiqiang@kaihong.com>
Date: Fri, 27 Nov 2026 09:51:43 +0800
X-Original-From: Ruiqiang Hao <haoruiqiang@kaihong.com>
Subject: [PATCH] dm-pcache: depend on FS_DAX, not just DEV_DAX
Message-Id: <20261127015143.2350453-1-haoruiqiang@kaihong.com>
Content-Type: text/plain; charset=UTF-8

DM_PCACHE reaches persistent memory through dm_dev->dax_dev and
dax_direct_access(). That dax_device is registered by the block driver with
dax_add_host(), which stores it in the global dax_hosts xarray keyed by the
gendisk pointer; fs_dax_get_by_bdev() later looks it up by
bdev->bd_disk and drivers/md/dm.c:769 assigns the result to
dm_dev->dax_dev. The whole registry, both dax_add_host() and
fs_dax_get_by_bdev(), is compiled under CONFIG_BLOCK && CONFIG_FS_DAX
(drivers/dax/super.c), so with FS_DAX=n neither side exists: pmem and
virtio-pmem still register a dax_device for their char node, but the lookup
can never find one and dm_dev->dax_dev stays NULL. cache_dev_dax_init()
then fails:

  dm-pcache: cache_dev_dax_init:91 252:0 dax_direct_access failed: -95
  dm-pcache: cache_dev_start:254 252:0 failed to init cache_dev 259:0 via
  dax way: -95.

-EOPNOTSUPP here comes from dax_direct_access() taking a NULL dax_device;
the message gives no hint that the kernel is simply missing FS_DAX.
Since the target cannot work at all without it, make the dependency
explicit so Kconfig does not offer a target that can never start.

Verified by Kconfig alone (defconfig, DAX=y DEV_DAX=y):
  FS_DAX=n: DM_PCACHE is not selectable
  FS_DAX=y: DM_PCACHE=m is selectable
and at runtime in QEMU (virtio-pmem + virtio-blk, KASAN kernel): the same
dmsetup table that returned -EOPNOTSUPP without FS_DAX is created
successfully once FS_DAX=y.

Note: DEV_DAX is not what the target uses, so it could arguably be dropped
instead of kept; this change only adds the dependency that is missing.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Ruiqiang Hao <haoruiqiang@kaihong.com>
---
 drivers/md/dm-pcache/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/dm-pcache/Kconfig b/drivers/md/dm-pcache/Kconfig
index 0e251eca892e..bf223eb8accd 100644
--- a/drivers/md/dm-pcache/Kconfig
+++ b/drivers/md/dm-pcache/Kconfig
@@ -2,6 +2,7 @@ config DM_PCACHE
 	tristate "Persistent cache for Block Device (Experimental)"
 	depends on BLK_DEV_DM
 	depends on DEV_DAX
+	depends on FS_DAX
 	help
 	  PCACHE provides a mechanism to use persistent memory (e.g., CXL persistent memory,
 	  DAX-enabled devices) as a high-performance cache layer in front of
-- 
2.43.0
