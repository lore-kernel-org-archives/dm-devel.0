Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F04170826
	for <dm-devel@lists.linux.dev>; Wed, 21 Aug 2024 21:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724275890; cv=none; b=NnfC3+fJ7/nzBQHcMlPysYMCPquEzJ/TiywdDuDfAG5VjemwtcnPwAmWu38DOOdkzsAvD8WJlThPLCx+2WMdbLKxHN7kDBBkYkfq6inMA7REN6JWrBS28oHTc/0krDa7WAv5ncJTcl7W1WPUIpz0IqOVbOifO/FoFVSMCAkmTEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724275890; c=relaxed/simple;
	bh=13Gb/RMl6q3swlRFNwPCffDQHdXZXtufKiZG1cadPNg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Fb9L8GqOzYsdpAMB6Dhy1K6sgNx7hlkX6KCmmlGKEvDsaVe2NAsHRy+yvhTcWICAkxNXLLIu7M+g2FLvjyVZ3DObvtcUOmz6PkiV4xRGu1v2xl5Vo6Qm8SsECZzEOE9oSlsfT8YCNwRxG3GHrkO116yxNx+Yy7rk/xuGO45gO50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHRfOwWu; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHRfOwWu"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5bebd3b7c22so2030664a12.0
        for <dm-devel@lists.linux.dev>; Wed, 21 Aug 2024 14:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724275888; x=1724880688; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cyaVmd0NKFFDt4jDA5xpNFtWFHhwLK4nU/+8+CzA/xg=;
        b=aHRfOwWuxs1+ygi7vTN44Yvzm1FQNrQIdT2i0dMLBIWBtoDmuYj4kQKwPUC9LhomP/
         LK12JJl9GXDssV7kyqZwTsrSwgMmpAr+VOP4KS8Xsk9XKMKmTzv3zUVq2VR0bKnEk0HS
         nOoAz4PKqmzrlK50GxY5xKYuhQGrX70ArrxEfD1f3d9QNmAkKocbkMBnfdK5cVdFrZ+0
         NpQBlgShaci6jtigREl1f0ub7xEinJ6LMNJUoQa4xcvvm+WIGisAUI0DocjdNztnhafg
         N9RO2WXfgcidanPDubx/RIcrpUsZMd+Qzeu2mPkiEh2wwCmdzaeP79AQ0KyTD2r7SG6F
         1d1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724275888; x=1724880688;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cyaVmd0NKFFDt4jDA5xpNFtWFHhwLK4nU/+8+CzA/xg=;
        b=xN700z83eGOSmzLvZ5qNDhprLUsyjY08N6PVn3DkXZbPVi1EXR7/asLN+LHv6vD0Ee
         nBf/CPAPPuGaffv/fhXtCf5kUVIHkwOSqlRtFXdDFjbDntQQduxCvP1cBuNzLRgVPCmG
         fpxlId13JlDxNdMAJKLsugClGOOMEmUVmoiOkrpqHfx5vRWnLmq+ggQ06DLv5BE/lA9/
         5HAEXopmrU22sTCepXpb1tH+gj3HzCFsPAAhxkfiAdRWcUFUZP6pppkDeOattjx5zLvj
         c2KjTsdvP/sAjMf2EaKj8RYsI+xvo0C22lD57ezaV9KZNBpYXoFuIP8StWafprX2MhLB
         26aA==
X-Forwarded-Encrypted: i=1; AJvYcCU6+yfDw5InEMT2TDz9+TcFuXfw+lsoHHc+9o79YkBYCRzjfUpgiGVbdEnCVCaHHkDnKhq0DKTGWg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/dOGy9jTgLIyrAMtNUD+/pW8TtihWT90DS+HylFDq/IMZcRIC
	BWkBqRPy/4r5/2D2WZu8kTg9hmQ124rXbnrkhL8TnVfM4NZVWz7F3F30+w==
X-Google-Smtp-Source: AGHT+IFLKTY9hGauEHRaP/JAEHEXViE3iNpe4vmfGq6Pa/xlFaqwEsIPBdIvpVqlkTOmzokW2Gkpgw==
X-Received: by 2002:a17:906:5d5:b0:a86:8b5f:65e5 with SMTP id a640c23a62f3a-a868b5f6870mr64815466b.12.1724275887356;
        Wed, 21 Aug 2024 14:31:27 -0700 (PDT)
Received: from luk-pc.lan (093105062173.zamosc.vectranet.pl. [93.105.62.173])
        by smtp.googlemail.com with ESMTPSA id a640c23a62f3a-a868f21fe5esm13755866b.8.2024.08.21.14.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 14:31:26 -0700 (PDT)
From: =?UTF-8?q?=C5=81ukasz=20Patron?= <priv.luk@gmail.com>
To: priv.luk@gmail.com
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] dm: Implement set_read_only
Date: Wed, 21 Aug 2024 23:30:41 +0200
Message-ID: <20240821213048.726082-1-priv.luk@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This lets us change the read-only flag for device mapper block devices
via the BLKROSET ioctl.

Signed-off-by: Łukasz Patron <priv.luk@gmail.com>
---
 drivers/md/dm.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 87bb90303435..538a93e596d7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -410,6 +410,12 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return dm_get_geometry(md, geo);
 }
 
+static int dm_blk_set_read_only(struct block_device *bdev, bool ro)
+{
+	set_disk_ro(bdev->bd_disk, ro);
+	return 0;
+}
+
 static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 			    struct block_device **bdev)
 {
@@ -3666,6 +3672,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
+	.set_read_only = dm_blk_set_read_only,
 	.report_zones = dm_blk_report_zones,
 	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
-- 
2.46.0

