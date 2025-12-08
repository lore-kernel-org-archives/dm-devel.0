Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ACC31194A
	for <dm-devel@lists.linux.dev>; Mon,  8 Dec 2025 11:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.112
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765193166; cv=pass; b=LD+QKnb4+KSGIov/QTHQ3ZmLimXM8JtA7Dt636iPBZXyYkGMSmOeiwu4UrVYfT69tMkrJhsq/PdAQC3gk3JF8SOVfda47DEEeP77JK9L7YYExYHrYs7ukCCihF6hpU/ET1QgC+5cZkKnjxqvGjf/gdMrsoeoSzixZBwPwgytbXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765193166; c=relaxed/simple;
	bh=1C3bGeDQVRKuSa9z1leLkmIheMwNi2jwSjnXOCy0OIg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YTRMawcYXTjJnu6pt3UKwKg2f5gMW0K9YeCtqy5c8+6L1kx2lVYo5yxlZPFopbR+wIgKhtOLXIUU6Ug7VdZyCFCitcoYqdZ/9bZps2eOCTuasHJplGpgiaH1H/8imZK7pThBrwJpxEMrc1ZvWLWCu+iqwVU61AGEZBxscwXb+I0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=beaai7Rc; arc=pass smtp.client-ip=136.143.188.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="beaai7Rc"
ARC-Seal: i=1; a=rsa-sha256; t=1765193158; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=S57+iG09g265+dpFvF61jAEEXFYqt1uabucaPiWL7Y3WVwnS3nv/37rKwayh090QLg7/P6ecqPhFVgVj9B9rh8Ldn5x5MXDOZyzYDo08a9RyqjetAnwxVdwAqpTroHKJTkPtgASjdFEurazFXzNDILfim7YBNvurSCuu6Y0jmAc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1765193158; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=2/pygMDPzjAu1xACfqkj/LncZvnXj2660hhgiqx7Xpg=; 
	b=Q9ii3lU82MfbrGq8jI4zY1ltfseFw9ZQxnOkG0TpqQu5xUx8IoxwYI4BMjHRT7BQmFN1mcffPqUtYO3Olj5z41A05mqE3Uz9MAT6vZExzp5UJtxSF2sjnq9PUaCyg24qz5/O+Bb/yx6EX9lD62IzgV9mNt9MELOVuUiwdSGPf0w=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1765193158;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=2/pygMDPzjAu1xACfqkj/LncZvnXj2660hhgiqx7Xpg=;
	b=beaai7Rc4YI2y8tVa2j9XinCgqfmyL0z6xlaZ6lbf4S27RhlHqlQ73l5EYCne/c2
	59bjR2pt2UaFU8ewBrVsMA7Lde1kipUjN84WPFphwAkIzS81hqYvaBgsvV4O26YQ6gW
	tkQmeOGBfGyUPdjB9ANaVG4DDm/Uq+eowzcHaHFg=
Received: by mx.zohomail.com with SMTPS id 176519315678899.9941859036453;
	Mon, 8 Dec 2025 03:25:56 -0800 (PST)
From: Li Chen <me@linux.beauty>
To: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dongsheng Yang <dongsheng.yang@linux.dev>,
	Zheng Gu <cengku@gmail.com>
Cc: Li Chen <me@linux.beauty>
Subject: [PATCH] dm pcache: reject mappings larger than backing
Date: Mon,  8 Dec 2025 19:25:51 +0800
Message-ID: <20251208112552.147756-1-me@linux.beauty>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Reject pcache targets whose logical size exceeds the backing device.
Prevent oversized tables from issuing IO past the end of the backing,
which may corrupt memory and cause kernel crash.

Signed-off-by: Li Chen <me@linux.beauty>
---
 drivers/md/dm-pcache/dm_pcache.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/md/dm-pcache/dm_pcache.c b/drivers/md/dm-pcache/dm_pcache.c
index e5f5936fa6f0..f72d1ba4b740 100644
--- a/drivers/md/dm-pcache/dm_pcache.c
+++ b/drivers/md/dm-pcache/dm_pcache.c
@@ -199,6 +199,8 @@ static int parse_cache_opts(struct dm_pcache *pcache, struct dm_arg_set *as,
 static int pcache_start(struct dm_pcache *pcache, char **error)
 {
 	int ret;
+	struct dm_target *ti = pcache->ti;
+	struct pcache_backing_dev *backing_dev;
 
 	ret = cache_dev_start(pcache);
 	if (ret) {
@@ -212,6 +214,19 @@ static int pcache_start(struct dm_pcache *pcache, char **error)
 		goto stop_cache;
 	}
 
+	/* Sanity-check: logical size must not exceed backing device size */
+	backing_dev = &pcache->backing_dev;
+	if (ti->len > backing_dev->dev_size) {
+		pcache_dev_err(
+			pcache,
+			"backing device too small: logical=%llu sectors, backing=%llu sectors",
+			(unsigned long long)ti->len,
+			(unsigned long long)backing_dev->dev_size);
+		*error = "Requested mapping exceeds backing device size";
+		ret = -EINVAL;
+		goto stop_backing;
+	}
+
 	ret = pcache_cache_start(pcache);
 	if (ret) {
 		*error = "Failed to start pcache";
-- 
2.51.0

