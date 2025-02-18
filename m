Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AEF2356A3;
	Tue, 18 Feb 2025 18:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739902937; cv=none; b=ayH3yXXzrTq9D14+bEu9o3L8vFGiXpIvGhDrLRR61SM0tln03xPCGFuA15zFxZVQ/UvY/rtJLSQQkogfEBH15DbeOcv5+/45fKxxx1ZfbZEJzGjpJaMroWgpEZQ/YTZlEg8E7RDGWcoKfzxt/MX3+49CF6Qcr8k2Fy6u9vGQpS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739902937; c=relaxed/simple;
	bh=V8Wda3vpKCO+OiRyaVserBuknDuXTmcLLPcvdYe/ccg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zp/VLa84AvGt1vW9YH5gHojsRQYktSq9UtduGJLG1vD9lf0+1WVAObxGbEK0zZ7BxbE/r+A38h/x+BfnSaLzkIg/MnSsW6hYe3nc8EHgJMGJXKTTlzJoKUouDAaFguVEevmUQWUylTdQDylDIKQIEauJMwhsiZvyfXKwdw4Bc10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TIdLqWuX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TIdLqWuX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=gxdcs/BQiaa4UGs9ySIrV4fQuXuoqlwi3siPPnozHI8=; b=TIdLqWuXKPXBHM2NSLo2ngDhw/
	2KfNjVvHcJd4wGVIXs4jWj65lbBijZYgID9b33lh8c32nRujD0aP7VELTQAej+S7hKUrnrzNjobrR
	Q+aPiiw6+LFecvpQDhBjlEVvRbiB4Zn6GHE+fJ8YL14jl2gE8eWBdmOYUWbUPGM5mpHh+v+hrAV1b
	eWOHpnOeYW5c0OO8Kz/B121IRgZOCeUI8P5zcdAIgl5zRw7WESA5x+fVHA9I5eLzJGpTLBBwl1WB1
	mo43SpCV3Vc6QFlPYsWKLTA6IUO9dAHPa8YjD6ZofPfWIqXuZOv7z9Vp97KzuLrZS+ylerEVKQN6i
	ez65bjXQ==;
Received: from 2a02-8389-2341-5b80-8ced-6946-2068-0fcd.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8ced:6946:2068:fcd] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tkSEU-00000009KE0-1IGc;
	Tue, 18 Feb 2025 18:22:10 +0000
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
Subject: split out the auto-PI code and data structures
Date: Tue, 18 Feb 2025 19:21:55 +0100
Message-ID: <20250218182207.3982214-1-hch@lst.de>
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

Changes since RFC
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
