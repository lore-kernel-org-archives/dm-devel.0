Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDAA22A813
	for <dm-devel@lists.linux.dev>; Mon, 15 Sep 2025 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757951739; cv=none; b=XN3/d1GrfDAyCAyeC437R/6hhCdTJ2XovvDLrrWrKy55Wt6IY+FzScruPWWGnIo064NA6LIBgXhOzLHiJS9EoQPmlpz3RTpSypYbrq8crtvGrdH/h37ghWA5op1ht0EumsoRtusipk8kk7jbpQZ8DdkjN/N402avxNpyR7THZe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757951739; c=relaxed/simple;
	bh=ji+uQgxz9cFMxjp6XM+xknJW9cLJXtIzOjqxHkHgw2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MVNucinXgp2/spwujGC1Sa+ZHTlmwyC0mU/K37z/OzbBo3Tat1/+6Dadyibfg71bxFfhRgz1mA5YT1b79mPjMsc8j9PKaQjjH09Vq1HMnk6AtFQHtxPX4xmS7Y6JLA/lrd1T2w6hKpj1ohgkfYOV4BW+ZwZW9PzyPgkNPBZURp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sIQ6IZYh; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sIQ6IZYh"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cQV42646FzlgqTs;
	Mon, 15 Sep 2025 15:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757951729; x=1760543730; bh=ji+uQgxz9cFMxjp6XM+xknJW
	9cLJXtIzOjqxHkHgw2k=; b=sIQ6IZYh0HNnHeGljsVGpPOlRXd+d76TbJvJqNtd
	P5g9crHo6OlzUHusYF2oto5kHmku2qkJtfKeJpxaq1J2zMNMYvT7xI54Vc77ceuY
	PKp1Rlh93YuXvHsFC8ZYNxJqJmPD1dB0k+zLMUvdMKIyi43TGOuB1h4m0bwSPBtL
	AYSfuIQIiTlKALkFqnQRvwgw91xqUbmOuKASCJgHQKWPt7a/mF2a/AoCRcXcfyv6
	eaXo1WK/NH3AaxHLyc8Y6IAZ4FRknntt7SYh7SJ+a9+4bv1fSzawnMJTcdGDw41Z
	4L9SuoHRvTgtPnTu0sR2bY1vn6D4kMW01iHTYylm7LLeGw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id LCppEr1RiCO2; Mon, 15 Sep 2025 15:55:29 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cQV3w50lbzlgqTr;
	Mon, 15 Sep 2025 15:55:23 +0000 (UTC)
Message-ID: <b0ab608f-c1a4-4a19-bc53-a5c68dae47fc@acm.org>
Date: Mon, 15 Sep 2025 08:55:22 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] dm: optimize REQ_PREFLUSH with data when using the
 linear target
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org>
 <55e3a5e7-8e4e-3e78-1f36-4bd4300974ae@redhat.com>
 <bbd7cb48-a13c-0077-af7b-39c849c9f6c0@redhat.com>
 <c29b0abc-2443-4cc4-9c2a-a41e6770bb96@acm.org>
 <274476e9-357b-5346-2316-6a6dc2971dfc@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <274476e9-357b-5346-2316-6a6dc2971dfc@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/15/25 8:42 AM, Mikulas Patocka wrote:
> If the table has only linear targets and there is just one underlying
> device, we can optimize REQ_PREFLUSH with data - we don't have to split
> it to two bios - a flush and a write. We can pass it to the linear target
> directly.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
