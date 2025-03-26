Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C041A2541
	for <dm-devel@lists.linux.dev>; Wed, 26 Mar 2025 20:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743021149; cv=none; b=dOKwuk1gMgMlspnrW9JqfRZ+75XteBUJeNEPH0aJB/NYc2byEhzmJJfF3nKdjDhFcI8P9Uta2YdLbGZRJvYfdZL6yuGgp2jaibSVdqXaNWcK1p3TS1tJbe7xJOlRZt1VyAmBlYkOrZuS+jitxoXjFq6dCMMwDwQBR30ePWUIGxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743021149; c=relaxed/simple;
	bh=5IJnG5CC5CLQbAbRWi5c0RbaCHfWp1UKYbYgIphvwyE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XTjRGQuw/+faQQ6atY+2SUIeuaKwgetsfXi4CjxwUQilPBIyp3HN3hkXliDVdBEgEr90b2F4QP59KpPrHsZ1vYXKHlcem/SkbDNb/pvZcVjkIjxf6D0Kx+w17FF1IymFCsHKi/Np2SPlNnbmTPTS+Os92YVvkuiJpzf3bc0BXU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=GhH4rLU3; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="GhH4rLU3"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZNJPJ6q5Dzlyw8L;
	Wed, 26 Mar 2025 20:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1743021139; x=1745613140; bh=22nCE/JdheVwlJ0qulXutrPQ
	FmbXQq0Se/8tA2qFuXQ=; b=GhH4rLU34yFZD8Q0s0yabwImVBwmnsLfr9V0Jv8j
	xxorKdAFTmM/fPay/2kuSpm+/nWKq4eOZuF6ADp3K7SFmOynZMRTXYW1WvwZyC4d
	HRSJppoSjIT+GN3ghp2qJ6u0bXTOLpygnRggbtO7Yn7dDyNfhnh0153yRIiagSN6
	P5A6gOvLB4vymPOylGU1yAUzqMVADikGwpRpu0eWwhp/NLv6grtkLXM4V6LzeHBg
	igN3+TjnvLQTIWTevWBFbpqomJS4iW+FKu/mW129ySrpAtktsr2vXqldwwjXQ3Fd
	uJQD0A4NJapISSe+fQQTi8hAKcLoW2z0rMUEmlQF6VDY1w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5ErmMQoYtZ7y; Wed, 26 Mar 2025 20:32:19 +0000 (UTC)
Received: from [172.22.32.156] (unknown [99.209.85.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZNJPB17fZzlvq84;
	Wed, 26 Mar 2025 20:32:13 +0000 (UTC)
Message-ID: <20581448-73f1-41fe-993c-a46cc6309cdd@acm.org>
Date: Wed, 26 Mar 2025 16:32:10 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm-verity: support block number limits for different
 ioprio classes
To: Mikulas Patocka <mpatocka@redhat.com>, Eric Biggers <ebiggers@kernel.org>
Cc: LongPing Wei <weilongping@oppo.com>, agk@redhat.com,
 dm-devel@lists.linux.dev, guoweichao@oppo.com, snitzer@kernel.org
References: <50200020-3c4f-0667-1697-7c2ff62133b2@redhat.com>
 <20250326013049.1292617-1-weilongping@oppo.com>
 <93b863a6-24f3-2281-c9a7-c3e59b2a6ec2@redhat.com>
 <431f8798-e0e5-362c-bf6b-fb6cddadd4b2@oppo.com>
 <20250326165336.GB1243@sol.localdomain>
 <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <052d22b6-2d49-7faf-49f3-742c9b79fc8e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/26/25 2:50 PM, Mikulas Patocka wrote:
> OK, so I'll set it to 8KiB.
> 
> Do you think that I should increase this limit to "unlimited" for
> IOPRIO_CLASS_RT and disable this feature at all for IOPRIO_CLASS_NONE?

How about a single limit for all I/O priority classes? Running too much
work in tasklet context can cause all kinds of nasty issues, e.g. the
user interface seeming to freeze if the tasklet happens to run on the
same CPU core as the user interface code.

Thanks,

Bart.
