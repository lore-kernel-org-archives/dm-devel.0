Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F69C221FD4
	for <dm-devel@lists.linux.dev>; Tue,  9 Jun 2026 00:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780964633; cv=none; b=SrK1vqk1VtQmhdch0xTyulVYa0KQKlLa8DsA08Q4StjFScmkcet7w7DCgZEx2OyTMoDGwqkM7Ii6vm0ATqHG8D0ndh21W60SSBTchBS05O2xq9bnTp6KCvY1Tb8/2inQ/OweQiWqYjg4IWzThtjA6LP8ywUMKegNFLF4D70qDIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780964633; c=relaxed/simple;
	bh=KwJDusgurB8zElbvnaE0qzzDToxmVKocdhHGIJKevcE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bgNC8l0Bc2QZ9u/8+z34yI3GUAj5XCJRWq4VvMU74kZH7luwonqDIMMb03rd7vaob81bR7Q8BXWfBUTrNZMr0YNtC5Ir4eSThhhHKPwAvFsMJaWvSZWHsA8cgG3Ppuw8QpWUb4Y1ea3LMYB3lbTcemSzTuCMs1NrIZf97nTESTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=IUxW2nZd; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="IUxW2nZd"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-9159477c893so623844685a.0
        for <dm-devel@lists.linux.dev>; Mon, 08 Jun 2026 17:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780964632; x=1781569432; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TExXr7ZTT0Z8KSeyDMKzahcY7zGRitsi6l8bmPbp6AQ=;
        b=IUxW2nZd1fyXVOKig0xVc8NIppNnM8LYLoOoA0WgXgwd8GuI1SKP1kdgzzLPLjzsRr
         V5ySkjuzzUSLGus19oPcS/FXJPIfzj5iAFXFmS+DgJQHJVbgMXobf9OyTwZimFyvAGxQ
         4/xmMV8cbrrORyAG6THCwpGxR0uDFjm+PkRDlY7+yvMWSEK7kHF7ZM2ln0ux4/22fCy5
         rxypoqlZJuSuDRrCq1Pf5pJ8A5SrZkU08fH2a+dnJP12Bz1omLoSwNrc/nUp9bdWt5Yj
         G/4EhVdYiWsvuxvqdxW+NyZGLHNruL2OeKHY5FumPi6JsecGPOrUnDV6AIrUFI+HuUoM
         7isA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964632; x=1781569432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TExXr7ZTT0Z8KSeyDMKzahcY7zGRitsi6l8bmPbp6AQ=;
        b=BwGihM7AVBmuGFITVo/rIh2tUmBaUNUFK1u2EjgGMyrc3zpdFDNnEam9/O50mFIhsL
         hEmzbTDoJPgYPkkBKOafdoksUW0EAd4g7aORn/jpZ2VX5kSdSHEV+D61YuLalGPz29vT
         EZAYO/DMS64xuxqI1DHybBzxlJa787Tvy1FY0IeecMcYGCIiosuC+obdB5jYhiaHp7jw
         AR2i+ZkNGimRR8WmB/Jkzpxbr8vLQHVZ4mlkSMuhrcDmMedB9mKpH2G73qKqWCKTHQBv
         KLdCLbkfB95823R3XsLqZLadh2IehrXxyQ6Z+f4p7aLdL85qAK0Ia+adqjqgplQ8181x
         yccg==
X-Forwarded-Encrypted: i=1; AFNElJ9jHf0SIY9b6Q9qtApXNL6g76AfirXIczXgtmIFMhfqw/NhZMuTWP1FAoRCiW5jFVM/ejcR9peQcQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy0oUrOPeOr9SANFp50s3DaLtjy6IvLDDzMFLRpjHk4N5Jxl56C
	BP2IaFm9dec38SMI4RWBMuKZ1aA6hkwftJ055/Hm5M1bbz8soV0iCQRuZxpTQWLXKPE=
X-Gm-Gg: Acq92OFS+q0cgy5gCthncBmxT6kY2txexmUumiVUnt0Lp0DK+VltlmkxARJsoGj8jL0
	DxHuoolHVtMRIQdDbBT5q0CmtegArxm0Qaujij1NHt7FQZqXONqW6dfNZcTJ9eaUm3doir2KTGU
	qCvbRNscs17JBbsYE4BxrYojFVY2aRV0po08wQR1+uynb1/kuoYrf1Ajeb2loXC6lyUon0mMZ+J
	qhXHm4wK/YMfEJ1aaNva79b0L3RzZh8y9DlkdMPLvog+XFga3wEZUr/5SzF6DKG3VUHJNxo47BS
	4gIzDp0+L50FDNGcUCvYM5yUps+XyGGLQfrGeFbCIIYnmc6rPZgX8BC0v7WbMgH/FQhP6v9iWjm
	7NJjt39RBLXtndZrsF3LN3A5XDJMC+mHZM00DHGHPwvRo84Nk5f3Srb9aYQCfLZ4tY7+2RN4hfT
	suaoOpdaQvdOTsizdFOe3f/bRtKljgnO/mG9Z/ZA==
X-Received: by 2002:a05:620a:454c:b0:90d:c28d:9666 with SMTP id af79cd13be357-915a9d56618mr2931778185a.30.1780964631729;
        Mon, 08 Jun 2026 17:23:51 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9158a37cab6sm1900128885a.22.2026.06.08.17.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 17:23:50 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: Alasdair Kergon <agk@redhat.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev (open list:DEVICE-MAPPER  (LVM)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] dm dust: use target-relative sectors in badblock messages
Date: Tue,  9 Jun 2026 00:23:45 +0000
Message-ID: <20260609002231.1236115.614213f87db6.dm-dust-badblock-coordinate-mismatch@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dm-dust stores bad blocks in target-relative sectors, but some messages
report or compare values in a different coordinate space. A table with a
non-zero target offset can therefore describe one sector while reporting
another.

This makes diagnostics misleading and can make scripted validation look
at the wrong logical block.

Keep the badblock control path in target-relative coordinates when
reporting and matching stored bad blocks.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/md/dm-dust.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
index c7e3077fb1f5..45d4154209b7 100644
--- a/drivers/md/dm-dust.c
+++ b/drivers/md/dm-dust.c
@@ -224,15 +224,16 @@ static int dust_map_write(struct dust_device *dd, sector_t thisblock,
 static int dust_map(struct dm_target *ti, struct bio *bio)
 {
 	struct dust_device *dd = ti->private;
+	sector_t dust_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
 	int r;
 
 	bio_set_dev(bio, dd->dev->bdev);
-	bio->bi_iter.bi_sector = dd->start + dm_target_offset(ti, bio->bi_iter.bi_sector);
+	bio->bi_iter.bi_sector = dd->start + dust_sector;
 
 	if (bio_data_dir(bio) == READ)
-		r = dust_map_read(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
+		r = dust_map_read(dd, dust_sector, dd->fail_read_on_bb);
 	else
-		r = dust_map_write(dd, bio->bi_iter.bi_sector, dd->fail_read_on_bb);
+		r = dust_map_write(dd, dust_sector, dd->fail_read_on_bb);
 
 	return r;
 }
@@ -415,7 +416,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 			char *result, unsigned int maxlen)
 {
 	struct dust_device *dd = ti->private;
-	sector_t size = bdev_nr_sectors(dd->dev->bdev);
+	sector_t size = dm_sector_div_up(ti->len, dd->sect_per_block);
 	bool invalid_msg = false;
 	int r = -EINVAL;
 	unsigned long long tmp, block;
@@ -462,8 +463,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 			return r;
 
 		block = tmp;
-		sector_div(size, dd->sect_per_block);
-		if (block > size) {
+		if (block >= size) {
 			DMERR("selected block value out of range");
 			return r;
 		}
@@ -490,8 +490,7 @@ static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
 			return r;
 		}
 		wr_fail_cnt = tmp_ui;
-		sector_div(size, dd->sect_per_block);
-		if (block > size) {
+		if (block >= size) {
 			DMERR("selected block value out of range");
 			return r;
 		}
-- 
2.43.0

