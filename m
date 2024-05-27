Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A166B38FA6;
	Mon, 27 May 2024 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716813400; cv=none; b=HF6NzXTpD2L/n5kL2mcexNwH7XMv1vd38vDaG3bZfXsy1LIxoX1EqIs22Q7DzsfXovMtoCnHHCrCsRgDoPNXaawispZx5z0n/v1/1RztkrJ4MbmrmXQdTWMXxpBixwdYSIvNPCSAsZ1JsdyQDxENM3IUXFRorSzJihrXIBLMMuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716813400; c=relaxed/simple;
	bh=MoeIQNvNi6ajgnykJbuhNskZsyug6pSENV0YaxwuHG4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RjHlCPXmrxpvBu3lFgXKO4/lfuJDstpw8Pk1TQu514oX1+y4lOuWTMUu+z6A36p8BjCaCCP2W442/v6UiTq8hYxer8D+2LEPhaRo8tPggczGBQPXrQ8+0NPzeuMcsmJT8ZGpx6rpispErCq/27PX1TDpA3QLfrQlSTh9p89ZRic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QaIty8Cy; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QaIty8Cy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=WJug3wL4ANQw9Fk0iLB+ivMtAVggdSmQdy+fcb6+wIs=; b=QaIty8Cy0wvVBnsww2hdMTD9S+
	E0PX7X1UPbW6l/jQhRcKcsFwKy8KV/gN7g1IWcyin0vP1M8yPPrx+wOEB9vUkHUkDuKGIh6N+E9GS
	Kcq6K9HALloQGDB9B5LV55/NltNuCUTR/9QkelMFU2bgj6Yc7kO/whUOedw2z1ACCJgqAuWzy0/qH
	rpUl1s0LJn9HSix6fUjLWYOU2PKtKLdghaYxfuCpqlc/hdAcyqsqhv5xR91D9nXucy0Iga4Jxy9uP
	/1n0hbcjcV9kWfMdbYx8RlTb8GW+ImG2geNtFAbSUzAXFKTBYk5mEfrpv1Yik0KdXy/bkHh9YrUVX
	RsD9DePw==;
Received: from 2a02-8389-2341-5b80-3177-e4c1-2108-f294.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3177:e4c1:2108:f294] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sBZaf-0000000Eu18-1vKc;
	Mon, 27 May 2024 12:36:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: convert newly added dm-zone code to the atomic queue commit API v3
Date: Mon, 27 May 2024 14:36:17 +0200
Message-ID: <20240527123634.1116952-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

the new dm-zone code added by Damien in 6.10-rc directly modifies the
queue limits instead of using the commit-style API that dm has used
forever and that the block layer adopted now, and thus can only run
after all the other changes have been commited.  This is quite a land
mine and can be easily fixed.

Mike said he's fine with merging this through the block tree as the
dm-zone changes came in through that.

Changes since v2:
 - add a missing IS_ENABLED() to fix compilation without zoned device
   support

Changes since v1:
 - fix an error return
 - remove a superflous queue_limits_update_cancel call

Diffstat:
 dm-table.c |   15 +++++-------
 dm-zone.c  |   72 +++++++++++++++++++++++++++----------------------------------
 dm.h       |    3 +-
 3 files changed, 41 insertions(+), 49 deletions(-)
