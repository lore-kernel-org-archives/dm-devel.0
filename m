Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A03628C5C0
	for <dm-devel@lists.linux.dev>; Fri,  1 Aug 2025 16:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754065250; cv=none; b=Or582rftlNdVHcLB4+rJK3b3H/fyLqvu1s2uiZhkNRbqzW/2MpQMlyEZ3kzsvsclkG2idwnd9uVrifQlsGdtCrCLAgqmw3puK8LgLULyMy22CSJpB1Nwv0Lg2+8IX6dDSbhmzJFSlqbho8w/TuHEfa3HtUGXW7aJ2YkwQ31b6UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754065250; c=relaxed/simple;
	bh=RENC8vur61d94NKH9iHE1FnEmdUamEZEbKYNI5M7zM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UOrzIg3ppLui8zKxSxqgCVXN0oD4a3Sul52BH5vtKB+v4fPUV2TAB0v6D2pNaXxqXpdau1r5uGMOOc+ky6vAgAZDXWWykkF0IVmAAKGudSU7DGoJiYhSoiUejFv89glXYTBODuup6Hy6OPgPFhnY/1y93DeCbrqrv+Po9+E/1Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YR3llIkB; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YR3llIkB"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4btrlt3cVWzm0ytX;
	Fri,  1 Aug 2025 16:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1754065241; x=1756657242; bh=RENC8vur61d94NKH9iHE1FnE
	mdUamEZEbKYNI5M7zM0=; b=YR3llIkB+MCHCqpgwl0lfWSK/QeAsYQ52ruG01V4
	IbHezGRDwHYdyVF3Z6YY9RMoTMynSvXU/lbeZfHCo2IM6sykPVMWNvjDJl3SgBXg
	dp68WbQ7vQyQ1nOamE58ry2q2ImUZLxuBaaVW38fUnpzG4fvN1VLmx1K9DShglPf
	Ze7qpnF5EH5DPBnktzsxdoscCoSXLAQn2y92Ih80DoGSn57wD/8GpfUGeEM3stli
	iyiPKNPmOWvd02KLfYF20MBJypGJ7Lu/uc9Z0+ppNnx7kwHbWW6MeDChvntmxQSD
	JK4EbzASWlRWXZYUXy546QQ8lut4M5jfZG+uCdQmR6r1Iw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ORHgdQyybtM4; Fri,  1 Aug 2025 16:20:41 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4btrln0ljwzm0c2s;
	Fri,  1 Aug 2025 16:20:35 +0000 (UTC)
Message-ID: <50e9b6dc-3ed7-4354-9aff-5da62268b036@acm.org>
Date: Fri, 1 Aug 2025 09:20:34 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: sysfs: use sysfs_emit() in dm_attr_*_show()
To: =?UTF-8?Q?Miguel_Garc=C3=ADa?= <miguelgarciaroman8@gmail.com>,
 dm-devel@lists.linux.dev
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
 linux-kernel@vger.kernel.org
References: <20250801131907.371700-1-miguelgarciaroman8@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250801131907.371700-1-miguelgarciaroman8@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/1/25 6:19 AM, Miguel Garc=C3=ADa wrote:
> This patch replaces the existing sprintf/strcat/strlen patterns in the
> four dm-sysfs show() callbacks with the sysfs_emit() API, as recommende=
d by
> Documentation/filesystems/sysfs.rst.

That recommendation only applies to new code. See also
https://lore.kernel.org/all/20250724153449.2433395-1-bvanassche@acm.org/

Bart.
