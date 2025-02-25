Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD99EEA9;
	Tue, 25 Feb 2025 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740498295; cv=none; b=V1yHdIqSfyZBKPFrPEOLL48gmOq63mpvK/XqQ8O+TLM9ZA6iVr4clU3rE0cTr1TVL/8EOxzke/I9X5DWETqevv0b6lTR4Jeu2aDbruA44OKmRweN+FFWx9qV2EE6vSg81UZXY3y/txfFqYFYnPD56GOKKgqPC/QmUNWrlc9vKU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740498295; c=relaxed/simple;
	bh=nBD82QW9wkTA0i+mBJoG0PthM8KgDds33uFNY38U+uw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AqBNw/Ng2k7CdiQAppzHUh2wAnda8K+9MfmMzmaLRGZiNrd5sbVifdnCHPzrUsJaYAF1B0aNJB3ZR0wkQeXz6Y2lnp5sdkxO9IFz8DaBsgok1zv6+c4Ck21n6gER33xRIEJiilxNYPpA8HVdqKNuEk9BUQW1F6cC6RWyCQPDjyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b6ut0OsI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b6ut0OsI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=mmTSOdZn1BlgaYBrjh36u/He90CFEEgIZDyN2zVKkso=; b=b6ut0OsIbItYD6P4C6dlfdbDca
	SY+bpXAW9Y+uShCOzKbveqXorjJu6wtgbLMxtxVSwR4MksyeTC2YinaI8yrpl/Vw8YLaworty3GeE
	0QMZLW6a78kjUVKVIAMA0GMVNk26YSbyqf18fh2wMvQpD3UenCeULADIj5MB8SXmz/w53reQGVd8T
	RoXSspuk9aAEonc2NzgqyBr3cyJ7GhQ3aQD77oBXwPgAFSgpSPq/+aYU924ybhvTE0/UN1LRhOS1G
	s1+9PXmbQuPEqkKg8I6YqalvHYgFJqHxLjTzs/UA5xBxe+eXtOGJODpLAK3JHUUBqMPvWWAipAKPV
	0G04OOAw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tmx73-000000006hu-36k3;
	Tue, 25 Feb 2025 15:44:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: split out the auto-PI code and data structures v2
Date: Tue, 25 Feb 2025 07:44:30 -0800
Message-ID: <20250225154449.422989-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this is the tip of the iceberg of some of the PI work I've done a while
ago, and given the current discussions it might be a good time to send it
out.

The idea is to:

 a) make the auto-PI code stand out more clearly as it seems to lead to
    a lot of confusion
 b) optimize the size of the integrity payload to prepare for usage in
    file systems
 c) make sure the mempool backing actually works for auto-PI.  We'll still
    need a mempool for the actual metadata buffer, but that is left for the
    next series.

Changes since v1:
 - rename the initfunc
 - update the commit messages

Changes since RFC:
 - rename the auto-pi source file
 - fix a typo in a printk message

Diffstat:
 block/Makefile                      |    3 
 block/bio-integrity-auto.c          |  191 +++++++++++++++++++++++++
 block/bio-integrity.c               |  266 ++----------------------------------
 block/bio.c                         |    6 
 block/blk-settings.c                |    5 
 block/blk.h                         |    2 
 block/bounce.c                      |    2 
 block/t10-pi.c                      |    6 
 drivers/md/dm-integrity.c           |   12 -
 drivers/md/dm-table.c               |    6 
 drivers/md/md.c                     |   13 -
 drivers/target/target_core_iblock.c |   12 -
 include/linux/bio-integrity.h       |   25 ---
 include/linux/bio.h                 |    4 
 14 files changed, 226 insertions(+), 327 deletions(-)
