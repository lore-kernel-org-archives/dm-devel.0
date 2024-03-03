Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C75BD26B;
	Sun,  3 Mar 2024 14:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474520; cv=none; b=abfNFUNf06uVekMgXWRVU9+qPdEI/mpV3KvqIsXJeSobYCYPdTNpMQRJnaPdBOoZdbdhj4MAqvbdcouaM8etkNgy73S44wKcr/t3HUBtDk0JtcBXDpJzgwoO0wOa8GA/z3WngBO9ITbqcxcwPA8hdMvrx9jIa4aRz81C18A8PlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474520; c=relaxed/simple;
	bh=5Btg5eZQK1RZvD2zxbOdzMy4CQ1VUM6kvAqF6RQ5yqw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RM2z1q8FHecny5q8I0WUyMCIWTsbM41D7HDOMyULRt3Krsepz6LYTsssTv2ZPWmcuQzv6VtDvOEcgpzl4HSNE01zxk5wPjemzV9hvQyJ8eKlECGj96UPw+SSgRPja9qIY7dPZZSJKaXi0S+6inuyoumEOZTykdcIMWgNYQL5NyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mlYC39vk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mlYC39vk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=QHIeWXwdHJY6TPIuBsWMVBmXvb1Fp62DeIfgaS00TTw=; b=mlYC39vkT4XZv1Cs24VEAW4jqn
	SlLzREi7yIImJvxJ2zNjwsSkn7wnkvKKxzT7kOg7MNMpe4X6K7HBDeuQ1IN7FbB/YOKSvMoKscbZe
	j/+PpVZhx3/TIaLhyuDNuM5U0uLgvmXcHDBcquAh4XB+miIM6PbtfZLZXW9muT38UJ8GLHAIQ7U1W
	R0kGwpLPkKd/bqWhhWJH4E21MStotHNvgx+exHoFL9mQphmccKxM/llftYawv73S+KRgnfYLjfkcn
	3q00wb1ti5MKfu+E5s3AXvqYVCVqWNLHNNGHdTG1llf6GSFx7aNwYFkRTgmzwRNfbIFPdTLfoWkMS
	rtt+Xqfw==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmPZ-000000061go-3S3z;
	Sun, 03 Mar 2024 14:01:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: atomic queue limit updates for md v4
Date: Sun,  3 Mar 2024 07:01:39 -0700
Message-Id: <20240303140150.5435-1-hch@lst.de>
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

This converts md to the atomic queue limits update API.  It passes
the mdadm and lvm2 test suites without regressions.

Changes since v3:
 - drop the already merged core block layer and dm patches
 - sort out a minor conflict after rebasing to the latest block tree

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
 block/blk-settings.c   |   24 ------
 drivers/md/md-bitmap.c |    9 --
 drivers/md/md.c        |   89 ++++++++++++++++++-------
 drivers/md/md.h        |   28 +++++++
 drivers/md/raid0.c     |   42 ++++++-----
 drivers/md/raid1.c     |   51 ++++++--------
 drivers/md/raid10.c    |   85 +++++++++++------------
 drivers/md/raid5-ppl.c |    3 
 drivers/md/raid5.c     |  174 +++++++++++++++++++++++--------------------------
 include/linux/blkdev.h |    2 
 10 files changed, 265 insertions(+), 242 deletions(-)
