Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB7E84A49;
	Fri, 23 Feb 2024 16:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708704779; cv=none; b=SgmZU+5MqXPkVMAeA/Qc+2Q2h6ajpFnpyaD5g3Bj/DAeRKWQBAybcDa2edV86ULe8yPMXNSeUSHnv2v975c2L0tPgN8THMm5obflhS9fRBAb6J6Ta3+mBSMHZNsXLpwAEyptFKSzjATdH3UZ/ZtwCNPrKcxVpPQZbhhzwU7C7Vo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708704779; c=relaxed/simple;
	bh=iQyOkottnsrAwDoRlhsKzDtzCHTrvfsby3H8Wp/Af64=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M8XucyWbdD1qevn5LwR5fwsRE5WY1Q/kMcp3xJ4kBBNoa8CtcU/EsVRsVL43AVm1qpB/0Cqeq7HBSgFGjnbBXGJS4fOYM3J16dc7wrlfhjNOTWqC833ev6/ZL0GFh9EU90+mEVFK1+wbnizr+runKAAEDcp3nwjOx7NihcisIg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=26+axJut; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="26+axJut"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=k3HOQnbWtGh3BvZkNVjW58+PG2/qlXYQEbUShSEwg/A=; b=26+axJutulMlpbxUK89etwpfKi
	k4WJiaojYBAaRMrpEI+P9ZApbx13xNEPJHobtXfKhD28rTyePdjhQbE4QYUzxxhb9bUWgkXjgWlro
	FTpdqDBZiyiTXnm4tlmI1j0lgUsr1UNUe/TQt8QKg0LPeJhU+A5RKOekO52GX26mwxhHIbLEXLq5K
	gbIK/Zg931ZkYvZhkxzQgxc8w09VHbFhDHlVPfNpXa6+rAeyT+66yZuSiCuR/sdhAiuT0eA1sN3go
	QA2CYd/kLNVdqrvL6+njEmPMZ6X84H3wGUCAPrZkgn7hkoCzqFMdBjTz1g8suSedKaW0zyMtYxOnM
	lfBYH1/w==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdYAL-0000000AAdM-46Ca;
	Fri, 23 Feb 2024 16:12:50 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: atomic queue limit updates for stackable devices
Date: Fri, 23 Feb 2024 17:12:38 +0100
Message-Id: <20240223161247.3998821-1-hch@lst.de>
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
of failures as the baseline.  I've still not managed to get the dm
testuite running unfortunately, but it survives xfstests which exercises
quite a few dm targets and blktests.

drbd and nvme-multipath will be handled separately.

Diffstat:
 block/blk-settings.c   |   46 ++++++++++++------
 drivers/md/dm-table.c  |   27 ++++------
 drivers/md/md.c        |   37 ++++++++++++++
 drivers/md/md.h        |    3 +
 drivers/md/raid0.c     |   35 ++++++-------
 drivers/md/raid1.c     |   24 +++------
 drivers/md/raid10.c    |   52 +++++++++-----------
 drivers/md/raid5.c     |  123 ++++++++++++++++++++++---------------------------
 include/linux/blkdev.h |    5 +
 9 files changed, 193 insertions(+), 159 deletions(-)
