Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638192C029D
	for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 03:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765336698; cv=pass; b=H1IaCkeGoopWHQVYAbfiM3puuGEDaSA1wdJ5D/GiHxsLNFwgFa5cIE6uyraS3gjwelWROkFGX9RNuna+wuKGKbEM9voikMKC3bHzHlizLs/LsVIidh9Q3sZa2SroSjpM6mMzhEgN5m6thX2jVgA47rZe6M/yCXyULFjI1ej52MU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765336698; c=relaxed/simple;
	bh=C5o2spya9duhrzJkpGmXbGIDRlEFChbxI1HS32o22ro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fEusAaSWqHEmmbaRM5eDLqxydnnQ6ZtsKl4OKjbPexwX0WOjZRD4x7e4poh+4m+hM5rv4cIkU/HfbN+5uaVQLVq2njRlUExGuTpY7C1U4OkbD4Qrx21vnQZdGH7mf1zyeCCXefV9mhwA29asUEleypM+yjoqLtJFWpCVn11Jnso=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=TisOklsL; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="TisOklsL"
ARC-Seal: i=1; a=rsa-sha256; t=1765336683; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=ELMRgBTfoGS3Zbs7anbjdZ0zqHmjtIXNh4ba9mskqoqHtkj30728z8Z/Ev2bRjRxfa/66S6X4A9xrZQRTHmf9vwP4ywTsfO3P9okgGKuPOHr2poLMALZWU5ZkHaKar8np1/e+L/C27rfc0PVcNqaaWSSou1GD9AYvSeqZdt7fiA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1765336683; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=FuL6Yw4vO3qymCRWyX5JIcyGKMyOZCkR/J1Z31sGApg=; 
	b=eIwfdz0Uqc1uuzhkoMua3uy3h8LPXAU7g1Ll0pU6yYrwzodd91wDZ+XgKO9knJgaqDyBhTlu6i1s/T2QPngz+o3/1QcUGPbGavwyz2IHgx+1PRPzbEpBBOnfUW55viYT6nUB8EcXSzgc6WfkxEtfyoEQEiOPa1DLehVc9oyX+xU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1765336683;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=FuL6Yw4vO3qymCRWyX5JIcyGKMyOZCkR/J1Z31sGApg=;
	b=TisOklsLsj6XXIjlO8lyV/TLf70rYBqWwsaE2wew3iA7uPXexrGfLQBYTfdhyUIf
	oD7u4Jj6W/Zf/i3wMZlFseWcgvnc8IQq555quwcrGD9ByRaFWwZ7iAin5qTBwSs8IFh
	DTQne9AUp40AIBHfPASf4nFpxWja/Lm+w30bID/4=
Received: by mx.zohomail.com with SMTPS id 1765336681546732.3238133730674;
	Tue, 9 Dec 2025 19:18:01 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH 1/2] dm cache: drop redundant origin size check
Date: Wed, 10 Dec 2025 11:17:56 +0800
Message-ID: <20251210031757.66037-1-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

The cache target already exposes the origin device through
cache_iterate_devices(), which allows dm-table to call
device_area_is_invalid() and verify that the mapping fits inside the
underlying block device.

The explicit ti->len > origin_sectors test in parse_origin_dev() is
therefore redundant. Drop this check and rely on the core device
validation instead. This changes the user-visible error string when the
origin is too small, but preserves the failure behaviour.

Signed-off-by: Li Chen <me@linux.beauty>
---
 drivers/md/dm-cache-target.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index a10d75a562db..350a0aa53365 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2099,7 +2099,6 @@ static int parse_cache_dev(struct cache_args *ca, struct dm_arg_set *as,
 static int parse_origin_dev(struct cache_args *ca, struct dm_arg_set *as,
 			    char **error)
 {
-	sector_t origin_sectors;
 	int r;
 
 	if (!at_least_one_arg(as, error))
@@ -2112,12 +2111,6 @@ static int parse_origin_dev(struct cache_args *ca, struct dm_arg_set *as,
 		return r;
 	}
 
-	origin_sectors = get_dev_size(ca->origin_dev);
-	if (ca->ti->len > origin_sectors) {
-		*error = "Device size larger than cached device";
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
-- 
2.51.0

