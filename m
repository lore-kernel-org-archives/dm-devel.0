Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6694254662;
	Mon, 26 Feb 2024 10:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943413; cv=none; b=q8zWU7UH+RLtw0iSfEWBqIm8cSM+jYARLXjkXYiAc5r2R+obUbkMJJ8vp9ryoaOsLYFV7bB/kIT21oanVssHMCg72/26JosARSEv4ayLGFCpDAxm39Y/KALRQY3TS/I8sfGPMcSe5/e4w74l4+bjvj+DCtGgAEJOw/CqNBWHfn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943413; c=relaxed/simple;
	bh=PzLygCOwXvtGAVXHFdpWVOEeJPDkmJsSwnSUM+iouxQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nUZaKC6qW//lv5xdgz8W+D5PXDdsRqtW80qH24gFU3DCRR5m5LUTy67OqOkX+6d6mmflBN+2qaB+HA7T6AfjppMANyaHJhlEtygAC5qRiSM8Nni3jH4Jjdu4BlZtzFGZLRKKuSWkSoOdu2O7cyWSCGmamRKYT5T+K7PweaeFk90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PVY5zDhQ; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PVY5zDhQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=UGOSCCyPj/BmRrHF9CnihwGu6XS72OjDXvKcF03cHYA=; b=PVY5zDhQgnDSI3xSU6JaYDl3yV
	DI+C56e+8os7t3dK8OC8gGlQMnO6B1Nf5dsaqNKizXuShwPEAfCqW6NEI9wrzKg/tX70chdIPPUsW
	AV7KihXFeQpy9VwQRd8rNmFKm6KBpfwgv37P2mlUz2ih5C0wC7LRIYrSyXYrriLDQEYYmt5FDMLwI
	B3wpoIKggevVlZ+30j0svvtMdwN0KMSrsP37jyLCZwmoKIN+FlFn7FQSXgwsbUobSjRWDT4tAMsUC
	2lE4G1uSQEBameQtvWHf0bpn4xAibws088GAdTVLnpWSKThCGSU3LqsCnaCGOMzURH23XOcuAVhN+
	SS3AJNVQ==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYFM-000000004WJ-2FR6;
	Mon, 26 Feb 2024 10:30:09 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>
Cc: drbd-dev@lists.linbit.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: atomic queue limit updates for stackable devices v2
Date: Mon, 26 Feb 2024 11:29:48 +0100
Message-Id: <20240226103004.281412-1-hch@lst.de>
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

nvme-multipath will be handled separately as it is too tightly integrated
with the rest of nvme.

Changes since v1:
 - a few kerneldoc fixes
 - fix a line remove after testing in raid0
 - also add drbd

Diffstat:
 block/blk-settings.c           |   47 ++++++---
 drivers/block/drbd/drbd_main.c |   13 +-
 drivers/block/drbd/drbd_nl.c   |  210 +++++++++++++++++++----------------------
 drivers/md/dm-table.c          |   27 ++---
 drivers/md/md.c                |   37 +++++++
 drivers/md/md.h                |    3 
 drivers/md/raid0.c             |   37 +++----
 drivers/md/raid1.c             |   24 +---
 drivers/md/raid10.c            |   52 ++++------
 drivers/md/raid5.c             |  123 ++++++++++--------------
 include/linux/blkdev.h         |    5 
 11 files changed, 305 insertions(+), 273 deletions(-)
