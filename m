Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CF82A1AA
	for <dm-devel@lists.linux.dev>; Wed, 22 May 2024 02:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716346283; cv=none; b=Gpztuflw4jtAxsBZQ5TpEpARs5lYfuzHJBUz/t+5Zw1TVGJS68+mKceW14wGGw+GSvHtF+yaGNCi6p93fu+7ay1AUmudLbkTdDUwxSWz6igkJuObMA9IutImytI/sQYePdqtilE+0STSzbK/eKP+m/A3oDiXH2RriqD0gNyimQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716346283; c=relaxed/simple;
	bh=nw+9U/m6IzUil9LX5+jWVMT7vSrTI3aaobRmeTwjTgw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YkK10RWIiCeLd3psKDrcLuyigkhjPQbXymg7PddvFA/xpOsymzZp0lcJqZYlkNq2pJe5F+ms6vCycZjmzo7b4YaFJidt5FJzQZ8Fhbx0BsiRxAvIjf5zVX/js1esiQ+hU8QNEUxjw4Pjn+yTpO4pvIgc6rsw+XZxCS92vITo/hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=snitzer.net; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=snitzer.net
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-43df44ef2f9so31370341cf.1
        for <dm-devel@lists.linux.dev>; Tue, 21 May 2024 19:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716346279; x=1716951079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JprbaBpshjvrnm8PC3hpDUHsifaejsi6Oxq/zCB98rQ=;
        b=WFhZt2sw/3cEqoPgPiMnwvRm1ISb+ksPObOPlDOPp+GYI+llc8yBA9hvibs4DnEV9y
         Ol//EEH2Ofnd6Nw0zkU4+tfaedPtDXGk5xHxmRA1nu6l+/SCEELmMCPj8dHGKhiLJAio
         PzFbcHmLVo02Vm26CRDWjCqeF3lKMwRdz7BZ9caHcqFH0cxipr1xb5uZemwfbsolKScY
         t7yOV8P5CyDR62nMHViOWWrmStnSBRcDqzP/AY6TMalUlnfx+hQ/g/IF0DR0wFe7jpgH
         2Muc5fa4WKa7hb5wmKIBZzUTC7X3I/JyXjNuyHI6feDtxy2JQzD21xHBw/eo7GNd+GfV
         NsUQ==
X-Gm-Message-State: AOJu0Yzq4V/OFUZqvaJgXLQZY2TAMfp1JQymN/CArfbU7WB8CHxDVgm7
	TAyhy/nKRTp1wmri+LfbxlCejeirlm3OFf0xxKzbQNqiS8AoG3IhH2LlmVIYM+Rof0Kvkd/iEW0
	Oo+eyrA==
X-Google-Smtp-Source: AGHT+IH0FlKvJ4K2kh6y3bCOSMKoFk03tXhm+54ZX4wUSA2seFT02HAZDbyTH/HtJv+RAR8c3v4g0Q==
X-Received: by 2002:ac8:7e90:0:b0:43d:e6fa:1ffc with SMTP id d75a77b69052e-43f9e1abe2bmr7847141cf.54.1716346279671;
        Tue, 21 May 2024 19:51:19 -0700 (PDT)
Received: from localhost (pool-68-160-141-91.bstnma.fios.verizon.net. [68.160.141.91])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-43dfa52e547sm159185701cf.10.2024.05.21.19.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 May 2024 19:51:19 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: dm-devel@lists.linux.dev
Cc: linux-block@vger.kernel.org,
	hch@lst.de,
	Marco Patalano <mpatalan@redhat.com>,
	Ewan Milne <emilne@redhat.com>
Subject: [PATCH] dm: retain stacked max_sectors when setting queue_limits
Date: Tue, 21 May 2024 22:51:17 -0400
Message-ID: <20240522025117.75568-1-snitzer@kernel.org>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Otherwise, blk_validate_limits() will throw-away the max_sectors that
was stacked from underlying device(s). In doing so it can set a
max_sectors limit that violates underlying device limits.

This caused dm-multipath IO failures like the following because the
underlying devices' max_sectors were stacked up to be 1024, yet
blk_validate_limits() defaulted max_sectors to BLK_DEF_MAX_SECTORS_CAP
(2560):

[ 1214.673233] blk_insert_cloned_request: over max size limit. (2048 > 1024)
[ 1214.673267] device-mapper: multipath: 254:3: Failing path 8:32.
[ 1214.675196] blk_insert_cloned_request: over max size limit. (2048 > 1024)
[ 1214.675224] device-mapper: multipath: 254:3: Failing path 8:16.
[ 1214.675309] blk_insert_cloned_request: over max size limit. (2048 > 1024)
[ 1214.675338] device-mapper: multipath: 254:3: Failing path 8:48.
[ 1214.675413] blk_insert_cloned_request: over max size limit. (2048 > 1024)
[ 1214.675441] device-mapper: multipath: 254:3: Failing path 8:64.

The initial bug report included:

[   13.822701] blk_insert_cloned_request: over max size limit. (248 > 128)
[   13.829351] device-mapper: multipath: 253:3: Failing path 8:32.
[   13.835307] blk_insert_cloned_request: over max size limit. (248 > 128)
[   13.841928] device-mapper: multipath: 253:3: Failing path 65:16.
[   13.844532] blk_insert_cloned_request: over max size limit. (248 > 128)
[   13.854363] blk_insert_cloned_request: over max size limit. (248 > 128)
[   13.854580] device-mapper: multipath: 253:4: Failing path 8:48.
[   13.861166] device-mapper: multipath: 253:3: Failing path 8:192.

Reported-by: Marco Patalano <mpatalan@redhat.com>
Reported-by: Ewan Milne <emilne@redhat.com>
Fixes: 1c0e720228ad ("dm: use queue_limits_set")
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
---
 drivers/md/dm-table.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 88114719fe18..6463b4afeaa4 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1961,6 +1961,7 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			      struct queue_limits *limits)
 {
 	bool wc = false, fua = false;
+	unsigned int max_hw_sectors;
 	int r;
 
 	if (dm_table_supports_nowait(t))
@@ -1981,9 +1982,16 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	if (!dm_table_supports_secure_erase(t))
 		limits->max_secure_erase_sectors = 0;
 
+	/* Don't allow queue_limits_set() to throw-away stacked max_sectors */
+	max_hw_sectors = limits->max_hw_sectors;
+	limits->max_hw_sectors = limits->max_sectors;
 	r = queue_limits_set(q, limits);
 	if (r)
 		return r;
+	/* Restore stacked max_hw_sectors */
+	mutex_lock(&q->limits_lock);
+	limits->max_hw_sectors = max_hw_sectors;
+	mutex_unlock(&q->limits_lock);
 
 	if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
 		wc = true;
-- 
2.43.0

