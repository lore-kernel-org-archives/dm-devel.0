Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D56B28B3FB
	for <dm-devel@lists.linux.dev>; Wed,  7 May 2025 15:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746632654; cv=none; b=o4azzHPRmYt1OmCQe3RHcPdkdaIja/siTv9B2H3YodsfWWKrPQVlpE2CUrNE3RUH6MdcFIxuvtSRuUFmAsJWqz0B/PSMm7KRQAWwa5HdHmONPnFiBwIrPzX4Y9fPRvBkIZLWNt2x8nCVtkt3UDKWOj4pupmG4hvMjJlLz1qdGeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746632654; c=relaxed/simple;
	bh=qnR1Y+HtlUnFWD8R+hi38YyhqOeBa/HiPHEMpUd7rmw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=GAGF74tO7SST+tHo3u6PZzFIkeoAKgu8cNAE9hzWDuzmw+roV/wYLkhgp5m3cMoKvTt7Hkgn3S3QfJwnmuX2NKAv6u63t5POrDZ+Z+GyKkDO0UjtirizHaIrUYLFWrzkBHP+jVFSxxUoffyJO0EkNdJHk7x1fkesk3WmLoFOp1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pc1VjF0C; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pc1VjF0C"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Zt01Q0JJZzlvkSx;
	Wed,  7 May 2025 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746632648; x=1749224649; bh=qnR1Y+HtlUnFWD8R+hi38Yyh
	qOeBa/HiPHEMpUd7rmw=; b=pc1VjF0CHZLW6ci45jUl7mXMbQVtFGMNcBWDOPqe
	1fKYQlxD+od6fdxvhvbhOJoZQcAypzZegDZe8Fue5QAHZTEJJxc+dZf1QA8s+own
	pByfNnRus/CiCSazS0sOxRv3DMuAooDrtTLV5OjDuXy8ojyW2if8DSaBjb9NZcfl
	cjSNydV1bcENKYRfNR6xrkxoY8OCcz2B0SdZBfErUHtu6twi2tGmpFho8r1hVRRb
	qomwyatZq+ZdrG/4yGASzdvmI5rh+3jwr57pwDAVMs8cYiVYZJhzL9np0CeHiOyj
	5Qkme4tqlzOk7WfKBamiUxbhAkejzK9/e1Q92tE0bfcmIw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gCDazEgCr4j5; Wed,  7 May 2025 15:44:08 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Zt01M0vx2zltPsg;
	Wed,  7 May 2025 15:44:05 +0000 (UTC)
Message-ID: <c09e5298-4824-4b0c-8fc8-0be33975da17@acm.org>
Date: Wed, 7 May 2025 08:44:04 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: LVM RAID1 regression in 6.15-rc5, bisected
To: =?UTF-8?Q?Malte_Schr=C3=B6der?= <malte.schroeder@tnxip.de>,
 bmarzins@redhat.com, dm-devel@lists.linux.dev
References: <fc8148d9-4b9f-4c13-9924-2f9b0eced194@tnxip.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fc8148d9-4b9f-4c13-9924-2f9b0eced194@tnxip.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 5/7/25 3:40 AM, Malte Schr=C3=B6der wrote:
> kernel 6.15-rc5 fails to access lvs which use mirroring (lvcreate -m1).
> Last working release is -rc4. Reverting
> 5a2a6c428190f945c5cbf5791f72dbea83e97f66 fixes the issue.

 From commit f1aff4bc199cb92c055668caed65505e3b4d2656 in Linus' master
branch:

Fixes: 5a2a6c428190 ("dm: always update the array size in realloc_argv=20
on success")

Bart.
