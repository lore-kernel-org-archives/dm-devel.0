Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.151
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795404488;
	b=cnKShh0nl29Bxy8/R6s6ndYVvxOwqtoHCqkW2mf7TmHvEXbZdZQ58KXjwm1rrShBvzWw
	 jYWxnPVp8aJN/1ZTOUGW1tcR7CBx6puKJaG2Nb+G2an4KvouTwKEKu54gBJci9x3UpONS
	 1k9Juk52J67BLs7yoTGD0C1QXsKKmf1Y2FBchL6NXF44o/dlUG8jNl5PmTJMFOs4k5ydT
	 6UkxOsBDjWNoql3Ocu79N/C7BnRw4dr4HkoUNuC6eWRM9LDeGGiRXZ3rz6hvI8drelBd/
	 +eHxapoCz7Z+mDr+86AS05pTdcCMYVwE9MpEz5M5JEV6Z03Sr8z+x9IjmKjI6ArLTRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795404488;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3OcNsE5BiTvJ0Z5anDFahPqafPoJf9lHCANaqQ2uhnU=;
	b=226OJhFuDueMihI/bdIJGBfi+dcMDl98NQGVYyY/Wr6Ni9hRiZD+uhR7vRSgmwUs7ZaJ
	 5z4/jtLhJktRO5nnZkvtdSdv/6oEJ75Ewkuv04DY99TamnDtRRfJw2wDqdd5LpuA/4t8K
	 PyjUD+HIjdGN0H0TvDrdKo6wGytFtgDifJMKUABcdV/8aDqZ1X+K9lfHrcOhagVQd5kz2
	 PA7p6dwaKjyhWo50rEOB6mMEwz6AZ01oGucywa7OOhxNTqgyDCiVGX+qWraRiRPHIAaZo
	 xkhK9AJHLl/05GamovXOlcoRCVUymCZAvW0uchwkrEFIggZSQBRVsSGn86Rewf5nTHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=q9+sooj2;
	arc=none smtp.remote-ip=111.22.67.151
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A87606A335
	for <dm-devel@lists.linux.dev>; Mon, 23 Nov 2026 03:28:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31A87606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=q9+sooj2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=q9+sooj2XJykjEbdB/hJzjLwCP2ClJNhElJQTSjEP+m6iiHfq4JdFQy1dTZmbyMxHL5BJRYHk4D9o
	 08kdcc3muQnBnJLWb0WvcqozLwzHSgbpg/G+7Csg3DPo2Rjz/WUnbw8UIp1Ea8zHkxH4H3fVOx2ilK
	 IMfR/ayccfg3ewKU=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee26b03b2c55a3-74d0e;
	Mon, 23 Nov 2026 11:28:05 +0800 (CST)
X-RM-TRANSID:2ee26b03b2c55a3-74d0e
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee96b03b2c33ef-84efa;
	Mon, 23 Nov 2026 11:28:05 +0800 (CST)
X-RM-TRANSID:2ee96b03b2c33ef-84efa
From: Aibing Chen <chenaibing@cmss.chinamobile.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-integrity: initialize free_sectors when the superblock changes on resume
Date: Mon, 23 Nov 2026 11:28:03 +0800
Message-ID: <20261123032803.1817-1-chenaibing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
In-Reply-To: <a0d2a86b-a001-9f82-1d08-fd8348688218@redhat.com>
References: <a0d2a86b-a001-9f82-1d08-fd8348688218@redhat.com>
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Post: <mailto:dm-devel@lists.linux.dev>
List-Help: <mailto:dm-devel+help@lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
List-Owner: <mailto:dm-devel+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Mikulas,

Thanks, I missed that.  e5e03918fbec ("dm-integrity: don't attempt to
commit journal on disabled device") covers this case, so the patch is not
needed.  I will drop it.

Thanks,
Aibing Chen


