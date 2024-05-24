Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0374886643
	for <dm-devel@lists.linux.dev>; Fri, 24 May 2024 14:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716560977; cv=none; b=dGpLobiS14GHZWObnC0b7k8wf3cfPru8KZRVGoyUphFdTLlidV3cPi87LjFZy3R2ILCkHH+yldX9rGFVJga2VvXH12ZiXbrgsfkrPunYK4OkClncUB7JQwLXvjcgPSsMvQ7tJIiuuGMA9eAyUqjuyuIKCtGJsuah/7ovDaWW1DM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716560977; c=relaxed/simple;
	bh=Ohy5QNrzBQhb7ipE+naOSgsDYE10Y09HpJNLU/+yU68=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FUqsH7a3itaJo9Aihnr9e6gM83+mo5btwbfSSyO4hMEFawHih4pPYPZ9mIBsVf+ktCfKgF/oDX6Dl5NWFOdqLSxQ0J73VLK/RKxx+uuDr9+Sk5BFNI0BBtqinVx5UQjqveaF1P1dsqhHnmweRx6b7QPjE1457H36SlMacbEMGWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yHmLXGb9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yHmLXGb9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Mj1MYgttxUfUJ9TlcOdxk4xR/ISelJ+im3gCvFtOCjA=; b=yHmLXGb93X6ONAOLr4XGmwgI8B
	Zh3Td3loRG76Zn+m+DkrZfTAN9jonPdNq0wLLn+Gtl3tXNV8jE2bSMM8OmiWPanwkJcTKNKxhJRMY
	40FR/kBBrqc/iqlgTWRTa76VF0xWAQdgPpMtwAOVLbNyNKbxv+95PnK2Xd6EI6LexntJXz6Annr7z
	ySdYL4N0Y3NWtIXd/EtSgerPmF63fAqMPZXevvjoNFCDwDlxzdeAWffwZzRUMxrcGEsc95PolwciV
	OIEdYjIFB2SSsvzgzDv0Ag2UgRTbW2EJIL91VExROwF9e0Y1D299uI5fXvhH9puBSlgZCF95ziWl0
	YC9PatOA==;
Received: from [2001:4bb8:2dd:2931:3dd2:5393:218b:4dfd] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sAVvJ-000000097av-2Q4b;
	Fri, 24 May 2024 14:29:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	dm-devel@lists.linux.dev
Subject: convert newly added dm-zone code to the atomic queue commit API
Date: Fri, 24 May 2024 16:29:08 +0200
Message-ID: <20240524142929.817565-1-hch@lst.de>
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

Note that if this doesn't go into 6.10-rc we'll need a way to get this
in before more block work in this area for 6.11, i.e. probably through
the block tree.

Diffstat:
 dm-table.c |   19 +++++++---------
 dm-zone.c  |   72 +++++++++++++++++++++++++++----------------------------------
 dm.h       |    3 +-
 3 files changed, 44 insertions(+), 50 deletions(-)
