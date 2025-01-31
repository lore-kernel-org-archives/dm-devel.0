Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3337E0E4;
	Fri, 31 Jan 2025 12:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738326284; cv=none; b=qSgMv/gYnpmRuJxgnmy259BIr2phKtv9M13jPzEnbWfg/6PHATlLX+3bkEcTMZomGUCMxI+e0yj/vJM4oB26g7wfxaucu3w8MQwq7l/lZdGiZd4k54WJ0h9EqTwyIAq5tszwnXQJmASJ+LKi14U7WHeFDoL6pOa1M6WcjmjXAO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738326284; c=relaxed/simple;
	bh=wp+BPXO5fBKcU5G2hUToSlt7o45KS/Ked2aYKBQd19U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BuQZBctyRvYFrNbNHejMXT9TyitxxIsCBPaNxrNPbptEcrkDjQT+xwAuNutT6ewR8QlYPECl973wxo5+c0pUDQHnqgiAfwNfkzXtQzghU2E/rgP0/YAgmZ+m786QZVcJN+2zgoCsukmQvJOQvsM14XxUXgZcfxPTbtnRbCTgZi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vr8ngT8d; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vr8ngT8d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=occ4wLP77kekZzXEqynZpoexMYL0moZi92xQyHmzjWc=; b=Vr8ngT8dWQdKYA26Ph2ow0diVe
	ckIbOLytBH6yGU5z1WIAofpqPm29uorL0kcmhdQRGz7b5+uIwK6L2XxTJN9GlhAciWX/1Xx/w+iY7
	vypViAI2bUCPvsqM0M/1Z9bi0xexEcz3hCa0sazZASxudAwqmYDO54tY2I4cCoTvWZf0/G11vhLx6
	AsfuazxSEqu6NVGoCrql/Fi05qZd2+uB1plerPQGDl9aNUvzsvUU7YVb/UvIEX4XkcvAmdbbGIUVO
	xr0Ng+KQcr55KnZOiMtFZ3C7b33a1DbtSwZZYtHQPomz5ZxVxa242hxDLiYk+tfrNwXeyuDItExfx
	wXlHfsYw==;
Received: from 2a02-8389-2341-5b80-85a0-dd45-e939-a129.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85a0:dd45:e939:a129] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tdq4d-0000000Ab1l-0MZV;
	Fri, 31 Jan 2025 12:24:39 +0000
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
Subject: RFC: split out the auto-PI code and data structures
Date: Fri, 31 Jan 2025 13:24:15 +0100
Message-ID: <20250131122436.1317268-1-hch@lst.de>
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

Diffstat:
 block/Makefile                      |    3 
 block/bio-integrity.c               |  266 ++----------------------------------
 block/bio.c                         |    6 
 block/blk-settings.c                |    5 
 block/blk.h                         |    2 
 block/bounce.c                      |    2 
 block/integrity-default.c           |  191 +++++++++++++++++++++++++
 block/t10-pi.c                      |    6 
 drivers/md/dm-integrity.c           |   12 -
 drivers/md/dm-table.c               |    6 
 drivers/md/md.c                     |   13 -
 drivers/target/target_core_iblock.c |   12 -
 include/linux/bio-integrity.h       |   25 ---
 include/linux/bio.h                 |    4 
 14 files changed, 226 insertions(+), 327 deletions(-)
