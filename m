Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3305438DE7;
	Mon, 26 Feb 2024 10:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943494; cv=none; b=WMmgWX4/TIONZwYfuoxuims3cOiqHSTPbpAvcVzvsGNusISptvwM+SiUuHGh47riBQFdDojCeXCMrgSxiVBGAbgrdqYq+/P6EUEg6hKmtUg3MKBUbaDrSyXVtC+zNMiNzR8wMYWXmBZTYi3vr3WZ9wRfjgvqOSdhUe2IeXP2gwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943494; c=relaxed/simple;
	bh=WZ2XdsWjVwQod0N+mJSg6AOyJz4P/zy2BHCxKr7xQYs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WbYh0sIF58XzjurMs/Y/Sb5C5Fuws1JfhpB7IStXRYAtSEwCcXg2VisZxwRM6ykCWP/oL7NKdql91/zHAF4ukiDrq/+CO6HpZtPr1kUExf7Th6NTKB4FIVCeFtSZgK9QWk5OQHfSHDPOPIBEqgY07U5u0poCJ+qOZJZbCVbTbXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qjsooldI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qjsooldI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Wu4aQNgacSiuDXEhKe8iEjuSJnZOtB4WhweP8yWkb8A=; b=qjsooldISJHjyWSal051NGtIef
	07Tq+qgT/tbD+Bl2Cc2p0AgXpD0IPv9HoZond+UiuOCmV9kYrTmGuPIpn3cZRlEE9/ydcxtyU29fr
	q+69wVlcnDs+UurlPPpX448+3QCZ2YrhENrwDddSPYyacw/BsVUm5vyCFoOI4GlSO2UN15fPmCDpf
	8wVj6z0zpNd4cQpP46kO9MZnQCF1coqusHgNQnSLC+tamLTnmvaVB0e7vB7vQ5hZvAPtyoJ837guh
	AWsCuyskGwImOhjvMwNoKJdXXEp4ByxYHHG3mMccwrLFA811PRk4gZ6dEZ1JHgISnZcNP9sfbvSYb
	bDBg+UbQ==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYGg-0000000055z-125o;
	Mon, 26 Feb 2024 10:31:31 +0000
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
Subject: [PATCH 14/16] drbd: don't set max_write_zeroes_sectors in decide_on_discard_support
Date: Mon, 26 Feb 2024 11:30:02 +0100
Message-Id: <20240226103004.281412-15-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226103004.281412-1-hch@lst.de>
References: <20240226103004.281412-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

fixup_write_zeroes always overrides the max_write_zeroes_sectors value
a little further down the callchain, so don't bother to setup a limit
in decide_on_discard_support.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_nl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 0f40fdee089971..a79b7fe5335de4 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1260,7 +1260,6 @@ static void decide_on_discard_support(struct drbd_device *device,
 	blk_queue_discard_granularity(q, 512);
 	max_discard_sectors = drbd_max_discard_sectors(connection);
 	blk_queue_max_discard_sectors(q, max_discard_sectors);
-	blk_queue_max_write_zeroes_sectors(q, max_discard_sectors);
 	return;
 
 not_supported:
-- 
2.39.2

