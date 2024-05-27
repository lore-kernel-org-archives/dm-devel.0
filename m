Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2393FB9F;
	Mon, 27 May 2024 08:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716797083; cv=none; b=XXN/domu8kmvJFiHM2QzGI+OIREGqFe48oI1u8wlR4nSKqmtaGUJi9yyNtPBBPy87kI8PqYFhijemp6PDzuQVC6QgBMaZTsTnBG+WnS89FFWN6pb7WTgNlrWzy0dd6fo/6Kv6O5e9pGIy6OC0z5tSAuMEzKf/W02r4GPVoLNff8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716797083; c=relaxed/simple;
	bh=iP/HLBIezJV70qc7W/W6MW6BVBuq/sU6BTmeK3oTlsI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=coNaCkeLE+8VipJvveQm5oq1m+A6Jm7HbMR7OCxf9BiLM0oYTNllQaN/iqCv5a5Vz97FCRdvAau50juiFpoYj/hZfiHPpxkeZSwXKiJFvfeD/V9eRz6H14Rs6WPZBDurxwu1UfyLmSmkfVXHkbt0sj8oI0n2JzsRJ/4AYfZT3WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=oQ/R0Mn6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="oQ/R0Mn6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=E4ezVvhwqIUmKSZLj5VfXc8yElHtfHTns0bwR8b+pO4=; b=oQ/R0Mn6OfeEgUDwdWQfOHr1E0
	9iIZrqatD04dy8m4yUsvEqz73HpfusmQmf2c0+3W3Rb9OHLJLncf9ntoNcXfDns87VCKF/upJAEq2
	U7lqkfsURa8kmWUOYpeGnLPBZWqtGhcUjeLv/QityubLQRAtHigqhvzPn0Mkrpdq9hiOqLGIoCb1Y
	NLxWQ8mWfMt0Ylp/Uf0TzY/drPGRoFM5bwtjajaiAJbyraU9kEQSc1P1nZ3APNlebqujq4fhsQLrY
	gr2W+NEnJGyTrNAfqYi8+gPJTSvnrUPuizL4RwUm4lxSv+Lc45O4FU502fiviTgQCApKuMEewkPgp
	8RG9+Xew==;
Received: from 2a02-8389-2341-5b80-3177-e4c1-2108-f294.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3177:e4c1:2108:f294] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sBVLS-0000000EAgc-3qWM;
	Mon, 27 May 2024 08:04:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org
Subject: convert newly added dm-zone code to the atomic queue commit API v2
Date: Mon, 27 May 2024 10:04:23 +0200
Message-ID: <20240527080435.1029612-1-hch@lst.de>
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

Changes since v1:
 - fix an error return
 - remove a superflous queue_limits_update_cancel call

Diffstat:
 dm-table.c |   15 +++++-------
 dm-zone.c  |   72 +++++++++++++++++++++++++++----------------------------------
 dm.h       |    3 +-
 3 files changed, 41 insertions(+), 49 deletions(-)
