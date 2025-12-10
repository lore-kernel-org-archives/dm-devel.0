Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856962D7DCF
	for <dm-devel@lists.linux.dev>; Wed, 10 Dec 2025 03:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765336722; cv=pass; b=B9au6O8FA2nk99txAG41W7RUq1TR/V8W02W02qW86gdF/5i4TLYYvWPb+vb9djnhC/ohHfws3aspWiA/MDZnGPBRtISDBG4VXpS9ThhFTvTvjBtjxxc3aDd0iQIkm+BWa7evjzTxS0Ue0O+A9HwfKo99lxwnCFPyvVq6e494UcQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765336722; c=relaxed/simple;
	bh=/RQyN8CyP7ndedeS67p4/hrrxyXB3Jf0HRbF7sVuyeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NsmnANerWWnZBth9Qvlm66BSzoRsA/MzmhmJ+yPqEmiLUvmFu8IApu+dpLjprUUXaRoKKR4kMzm+KqQAxYanFnMWpZ9sTubee+2vtgXVT/e3IjrEz6CzJ3TnuCwBVSB32+EZVKfYHoRtfj9iuP+a+W4aA3DMChIovNc0t+PmSZ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=Ji5S4ToB; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="Ji5S4ToB"
ARC-Seal: i=1; a=rsa-sha256; t=1765336685; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=WBCGo8RxIOIPBomyNPkH2/wPzgwtDdniJqSVgjVY2r5PuDLuJPZ0usFZ1qNSPcQ7NPR5or2mxRRbo6OxDn+sSm4Z/SVZEZ5sw02pHRbv8B2FwO14zxvgvmIvxZmGSdl9jOBt7ee5LBHjCGb5ujXZuah+TLjthtS1oVbd4YuFO80=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1765336685; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=yG+YUHo9AdIi9TOeB/vnYVX42rCG6sWVKqEYo3WL+H4=; 
	b=Osq0orl284qRvpx8kXRjuIldnpHoGNKjJzqrVXxJqxIEb7s53mzb22DSdDik/cl5a5Xc55hPIV7PHn/63w7O6rtfh16KLWq4w5yRsCIlA0hyhoAarMJkLZJ1P5cRxIW5zxpc0YnXXdb68HHaWlRndXZmU7ZjamMY8Iv/XOI9tqo=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1765336685;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=yG+YUHo9AdIi9TOeB/vnYVX42rCG6sWVKqEYo3WL+H4=;
	b=Ji5S4ToBJvRfDyVMvs9STc5tpKHO65WmBFk0GeMDhAcWOj5DeLV6r6PIC+lJQkqa
	5GpU5lHL5Na0T0mLqSVsaMP0nf/h9gjAtF/zT8Vjx9WpPGZW27Sg13oHPuJZjsNA/sY
	ohcPqErZY/iY9cowB1gwylaGBiMNXFKNxMPevsRo=
Received: by mx.zohomail.com with SMTPS id 1765336684111650.803501073786;
	Tue, 9 Dec 2025 19:18:04 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH 2/2] dm clone: drop redundant size checks
Date: Wed, 10 Dec 2025 11:17:57 +0800
Message-ID: <20251210031757.66037-2-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210031757.66037-1-me@linux.beauty>
References: <20251210031757.66037-1-me@linux.beauty>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

The clone target already exposes both source and destination devices via
clone_iterate_devices(), so dm-table's device_area_is_invalid() helper
ensures that the mapping does not extend past either underlying block
device.

The manual comparisons between ti->len and the source/destination device
sizes in parse_source_dev() and parse_dest_dev() are therefore
redundant. Remove these checks and rely on the core validation instead.
This changes the error strings reported when the devices are too small,
but preserves the failure behaviour.

Signed-off-by: Li Chen <me@linux.beauty>
---
 drivers/md/dm-clone-target.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index e956d980672c..ac94e3466560 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1697,7 +1697,6 @@ static int parse_metadata_dev(struct clone *clone, struct dm_arg_set *as, char *
 static int parse_dest_dev(struct clone *clone, struct dm_arg_set *as, char **error)
 {
 	int r;
-	sector_t dest_dev_size;
 
 	r = dm_get_device(clone->ti, dm_shift_arg(as),
 			  BLK_OPEN_READ | BLK_OPEN_WRITE, &clone->dest_dev);
@@ -1706,20 +1705,12 @@ static int parse_dest_dev(struct clone *clone, struct dm_arg_set *as, char **err
 		return r;
 	}
 
-	dest_dev_size = get_dev_size(clone->dest_dev);
-	if (dest_dev_size < clone->ti->len) {
-		dm_put_device(clone->ti, clone->dest_dev);
-		*error = "Device size larger than destination device";
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
 static int parse_source_dev(struct clone *clone, struct dm_arg_set *as, char **error)
 {
 	int r;
-	sector_t source_dev_size;
 
 	r = dm_get_device(clone->ti, dm_shift_arg(as), BLK_OPEN_READ,
 			  &clone->source_dev);
@@ -1728,13 +1719,6 @@ static int parse_source_dev(struct clone *clone, struct dm_arg_set *as, char **e
 		return r;
 	}
 
-	source_dev_size = get_dev_size(clone->source_dev);
-	if (source_dev_size < clone->ti->len) {
-		dm_put_device(clone->ti, clone->source_dev);
-		*error = "Device size larger than source device";
-		return -EINVAL;
-	}
-
 	return 0;
 }
 
-- 
2.51.0

