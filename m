Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76BB2DAFB8;
	Tue, 18 Nov 2025 07:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763449408; cv=none; b=IWCYT3zC0Obkjnj0OIBZVMHfg3GhBQTnsV/nCQ/fXgS9Az2XNlibokGzBj6GN8nla8UdxW1/63GGyy9/eiF/aoS5V+aca9cvVN3CZ2dvhNGtwbeW1ihrs6O5x9F3s8nXkqVm73cgFSbZ+TdBNuJCYmPThnplmEJoCX0FBFeo42k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763449408; c=relaxed/simple;
	bh=AOEvKyVwP+dqRuGZ1bdbCbF2m4xPrwIGn9E8k5eMJE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gO3jAZjnEEvdd8/ou2VDHXQM+BPzXVJFAcPRqAtKt6cwBfvs8R+d1u2BOxUL7J/eD8rqjx/N+jGqS6erJ7EaH7JyWnXcz3kmSmT6iLBgYV8kMZBDUCMo7BMCwV3fdyPq54wFgZf7I2s9hmw53GCBn17OsrVKsLn5gRZaXqdA44g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ZYwTvaNz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZYwTvaNz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=odUqavZCKNqJVf2YUjCerkDNDeembE185J3//oGXXH0=; b=ZYwTvaNzvF8NI+LbkOjYvHOmWR
	utPTeNKjKP1uqFZc6TPGpI0wkJPJISNTfcRlmZRqO7VDwd/3CwKS6vPEGoIyn3G1B6cp6Z99i7lrr
	N8ClU2ZrlJa1JTHL1AE+hc6fxxE9f+mHBF7N9AbI8kxIJfM/kxcGMgnCCYKYGpmDa/VqG4T8f7s7K
	HOrQEVvpK0TcIyD+mY54zFEE5bKiTd7hMjHRFMX+3QSSfqhslGQmm5bm1Z8UneC0eQuFmVMWjPsIr
	3WOqhWosnDBqTmoOIzcNu1JEnbKtrlFXZbnzKNNRYKRNrTJnuXXJ1mod8NFg7gw/kD8ILml20E9GH
	XLv7hAfw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLFkL-0000000HWyG-2Ywn;
	Tue, 18 Nov 2025 07:03:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: add a flag to allow underordered zoned writes
Date: Tue, 18 Nov 2025 08:03:07 +0100
Message-ID: <20251118070321.2367097-1-hch@lst.de>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

currently writes to sequential write zones either need to use Zone
Append, or have a local queue list to order writes before the
submission, just for the block layer than having another ordered list
in the zwplug to issue them one at a time.

This series allows to leverage the zwplug list to create ordering when
the submitter guarantees that it will fill any resulting gap, i.e. unless
an I/O error happens there will be no missing I/Os.  Users of zoned
devices have to do that anyway as they can't leave gaps, but we can't
guaranteed that for user I/O.  Kernel I/O on the other is trusted and can
set this flag.

This series adds the support and converts dm-kcopyd as the most trivial
user.  File system conversion will be a bit more complex as the
call chains are bit more complex and need a full audit.

Diffstat:
 block/blk-mq-debugfs.c    |    1 
 block/blk-zoned.c         |   61 ++++++++++++++++++++++++++++++++++++----------
 drivers/md/dm-kcopyd.c    |   48 ++++--------------------------------
 include/linux/bio.h       |   21 +++++++++++++++
 include/linux/blk_types.h |    2 +
 5 files changed, 79 insertions(+), 54 deletions(-)
