Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6017248F42
	for <dm-devel@lists.linux.dev>; Tue,  5 Aug 2025 12:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754395720; cv=none; b=mY4U1KdSiekqAEAjKj4Mv7AbPX93YXAOGNsCeTnf55cCEwiJsrgycDj69falnYPi7bybrf8wZS0pmh07wn7BcYZDOUH/LE+RVqvL+TQJE4xiGKq/GyfL2Rwx7BqkZjTRmJEeSPiixHafALLHw9VyEPs6Jo5U5TQtoBbBLB39CCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754395720; c=relaxed/simple;
	bh=0xRUA5q++5+uXcXaYRCTHesOiDk8ux0wg0iIshITagc=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=s6khv3Hh8Qj48prfHoXO1OIQFEsC5G7Smhb1At+yfhHFaXr9SIyxcn2AsoIS16AIO/YD/6ugDFs5xHSzIrIeXhxELOdzoD4s1BvA9ixqaSO80JK+faf6x81sOPNOy3fUVoDlXDKrl1FPGHTZ9phrHqMX85rGgerPyGgbp9mt3Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Q4YP2LTI; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Q4YP2LTI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1754395713; x=1755000513; i=markus.elfring@web.de;
	bh=0xRUA5q++5+uXcXaYRCTHesOiDk8ux0wg0iIshITagc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Q4YP2LTIfd8NxVPueXiLlAu9tWMVvJMPAZQ5lyWazwf8VbvKlvfIHZTVBzqt3S+X
	 DIFVlf8pqkiru0im+Cu88Km1frvdfR3Lds+DtDPHUWfPfqL4AGZ7dB3QIpbtcjXwa
	 Gbnzuib4EvMOwFQXhSd1ub0A1whxN21a5M22KFn+liYgeNqTDETSN4NiRLG/cHWPz
	 CYhs/5jamfc10qqqhu9YoJMdavsSbQ/QAkk7jPYc1i3ZMnbMXDyLbWvQGMMXGyPla
	 eQqi092TH1RriDZ/0+tTcN1ArgAEZsZRKPe0FlHCrg0tejWTFkSePG2sL0/SQFNST
	 z52rCSyQ8FtbCG4vlw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.245]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MKMA1-1v4NQM2XWR-00NuF0; Tue, 05
 Aug 2025 14:08:33 +0200
Message-ID: <06347a42-7ebe-4fbb-9772-0124e308f967@web.de>
Date: Tue, 5 Aug 2025 14:08:32 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Qianfeng Rong <rongqianfeng@vivo.com>, dm-devel@lists.linux.dev
Cc: LKML <linux-kernel@vger.kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250805091448.124183-1-rongqianfeng@vivo.com>
Subject: Re: [PATCH] dm: Use vmalloc_array to simplify code
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250805091448.124183-1-rongqianfeng@vivo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:6qHSEijMbNtMhsNNAFuAn8UxdPekIxbWdZL/Hekte2kZ2PAY3Gv
 pqbTUvSTKkGzrL+qRRP51gqfR5JwPZqo7UiFm9+SEq8L1U2lZTpQJOY3x6U5r5Xwt0aAIPR
 +mSvzTC8IS/5Rj5Nvt5VjZwpH1y33TnMxKQxmvrRD9c1jRM+A8pVuzF4E6Ruozdn/ocdhpG
 XjXooUkUbO5jZSd/PIduQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ucBf4im6rgI=;eL17KsriwFJmx8Rph7ZkcUv9VDr
 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
 7e88ZbF+kDCEhNdMRwQ6eVQ=

> Remove array_size() calls and replace vmalloc() with
> vmalloc_array() to simplify the code.

You may occasionally put more than 52 characters into text lines
of such a change description.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.16#n658

Regards,
Markus
