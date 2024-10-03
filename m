Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A4E171AA;
	Thu,  3 Oct 2024 01:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727918181; cv=none; b=Ee4uqXsmYfZ5SpNE5IpMxuNHFQs5Ki87yHuqxTHlbr48ny1CD4ojAfg+tOHDFWDvFILUiNTcS5f2+xk20z2iyOA81p4/fgcb2t2vLrgskkusTzRsOiHhCIXAOIg65lhgz65wOaqwpGGT1JP81uDKY1GOIQD5Hra/XfgkGvIZe90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727918181; c=relaxed/simple;
	bh=dxFXICqCt0QSr/N4nmikPYHjEvwDeyWCMaRRqTTrSoA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ubsgreWKi3P1099lnk8mBLUs7qunRvPC2Pp2TLSJw7xys8GGzFhVVZxItKLHVWnz9afPVkQNmtYQA5qAamIJcYGOFrHgfS4bDttg90JeIdMaM+D0iilOQ48wSvyifS9EuSTCvstiTZ19S5nmc6rIt1j1gP0JBltfuE7zWR5Ik/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=FqwDs+lz; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="FqwDs+lz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=TPnne8hCEo4MR4/NSkfXeXoUpTEsfuN753UY9bdDuUI=; b=FqwDs+lzyD8hnZBg
	aDLYTnXTpsHsvWEmE6LGaaT4yUEe5Nft/NUBjtpYC8eY3Y56FWcnUe8jTTvDuC6NoLgYpspbVouVD
	cAPM7rUmD6jLgxCT9kocFMmYUgDyGrUxAqYKx/ZQRSA7Yx0wCskslOLUvuUs7jrKzCEXdHszdYgbq
	rI470Wa5Q8hg4jvpVqNZfFJzhkJMrUBOTajJCwdB4o6UaI9mIL4WzFLo0qnST8hmJNoUkxOFUHYB2
	bnnqwYYGTT1Wus1lKth53FgoaQZIIIrNYT0xZ9EU3TF+/S+j8ztICtC0S5vUEXSVXNb7HSqeoj/A6
	h6WWNkQP5Wdjs2N2Cg==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1swARs-008Zju-0X;
	Thu, 03 Oct 2024 01:16:08 +0000
From: linux@treblig.org
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	msakai@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 0/9] dm deadcoding
Date: Thu,  3 Oct 2024 02:15:45 +0100
Message-ID: <20241003011554.266654-1-linux@treblig.org>
X-Mailer: git-send-email 2.46.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

Hi,
  This is a collection of deadcoding in various parts
of dm.  It's all strictly function deletion with no
(expected) change of behaviour.

Build and booted on x86-64, but no dm tests done.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>


Dr. David Alan Gilbert (9):
  dm cache: Remove unused btracker_nr_writebacks_queued
  dm cache: Remove unused dm_cache_dump
  dm cache: Remove unused dm_cache_size
  dm cache: Remove unused functions in bio-prison-v1
  dm: Remove unused dm_set_md_type
  dm: Remove unused dm_table_bio_based
  dm: zoned: Remove unused functions
  dm vdo: Remove unused functions
  dm vdo: Remove unused uds_compute_index_size

 drivers/md/dm-bio-prison-v1.c            | 35 -----------------
 drivers/md/dm-bio-prison-v1.h            | 24 ------------
 drivers/md/dm-cache-background-tracker.c |  6 ---
 drivers/md/dm-cache-background-tracker.h |  1 -
 drivers/md/dm-cache-metadata.c           | 33 ----------------
 drivers/md/dm-cache-metadata.h           |  3 --
 drivers/md/dm-table.c                    |  5 ---
 drivers/md/dm-vdo/data-vio.c             | 29 --------------
 drivers/md/dm-vdo/data-vio.h             |  5 ---
 drivers/md/dm-vdo/indexer/index-layout.c | 26 ------------
 drivers/md/dm-vdo/indexer/indexer.h      |  4 --
 drivers/md/dm-zoned-metadata.c           | 50 ------------------------
 drivers/md/dm-zoned.h                    |  2 -
 drivers/md/dm.c                          |  6 ---
 drivers/md/dm.h                          |  2 -
 15 files changed, 231 deletions(-)

-- 
2.46.2

