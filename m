Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3B2363;
	Wed, 28 Feb 2024 22:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161017; cv=none; b=W/8scN0ono2l2kIWxZKsimLnclBbq53IaTbmXj4ejKeS/NqGK7PbLU551zzZuLLFG71Bd966XnHCLFoEx3yEW65f99sfunORqYk7h8gGwRSVeQ2EVnAedha9CXjFdaz08abSiPXnysg+kktJ5dzHL3R1mcktc1lOjaDyB5knH8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161017; c=relaxed/simple;
	bh=f0TMfuFnHxnS6RLPrCGmyX5DIkMTOjG4kcDX8m3H6e4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aELiw7O35Zvcd0LXFMKCJdbKDxpDOZIgDYrkG4ZJqvlLVv0JC/z4l0/p/TwA0IT4pG7zuQ/cOYsMIH4dHvdy+QWETV9z7XVjgDJXbKI//SlZgcYXNdD5CKB8vG4TiZV4ABMDgbJdWdFy4NvFMieJc675Vh85ejlTeJwgMuEwoS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T86vCPuY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T86vCPuY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=8mTDEq7YgrLRtB4NmOsw107E6gy3/MmCkonhSVhgMbs=; b=T86vCPuY9f5yn4XzAFOwAdPqW/
	cJvKJFeZW+YF3lNqn/15CMiMUQALh4oaV+VQ/Pi1x88CFfNBt14LYOdbJ79etmC+I0pu+qHZCJTRZ
	ZYOk7gvD12xglRqzv99TDj6GVQDg++9K5yzh0rjsX102c1zpY+GbrsWK/SxDHnQG5+k0MFXyFPFwd
	65E01If7wEjfc/RbBQq10gJ6Zef1UBIYsYIlb0nh2xaHGXrVoTS3/30mfwzItoq0yDDp0Bo6YKD1K
	uUZg29Gre25VbH0ebkhujnGWAxnFLoKcT2ubSRSqKfYyFFs/gVhUJLWu9DfYvSUB/N2tbjgb5WN5Q
	2jM7AoOA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSr7-0000000BCNW-2AL1;
	Wed, 28 Feb 2024 22:56:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: atomic queue limit updates for stackable devices v3
Date: Wed, 28 Feb 2024 14:56:39 -0800
Message-Id: <20240228225653.947152-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series adds new helpers for the atomic queue limit update
functionality and then switches dm and md over to it.  The dm switch is
pretty trivial as it was basically implementing the model by hand
already, md is a bit more work.

I've run the mdadm testsuite, and it has the same (rather large) number
of failures as the baseline, and the lvm2 test suite goes as far as
the baseline before handing in __md_stop_writes.

nvme-multipath will be handled separately as it is too tightly integrated
with the rest of nvme.

Changes since v2:
 - drop drbd from this series again for now as we've not made any
   review progress
 - keep the NULL gendisk checks for DM-mapped MD devices, and add a few
   helpers to better document and abstract them
 - use mddev_suspend instead of blk_mq_freeze_queue around updating
   io_opt

Changes since v1:
 - a few kerneldoc fixes
 - fix a line remove after testing in raid0
 - also add drbd

Diffstat:
 block/blk-mq.c         |   14 ++-
 block/blk-settings.c   |   47 +++++++++----
 drivers/md/dm-table.c  |   27 +++----
 drivers/md/md-bitmap.c |    9 --
 drivers/md/md.c        |   89 ++++++++++++++++++-------
 drivers/md/md.h        |   28 +++++++
 drivers/md/raid0.c     |   42 ++++++-----
 drivers/md/raid1.c     |   51 ++++++--------
 drivers/md/raid10.c    |   85 +++++++++++------------
 drivers/md/raid5-ppl.c |    3 
 drivers/md/raid5.c     |  174 +++++++++++++++++++++++--------------------------
 include/linux/blkdev.h |    5 -
 12 files changed, 321 insertions(+), 253 deletions(-)
