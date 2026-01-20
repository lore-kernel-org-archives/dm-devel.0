Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247BE366566
	for <dm-devel@lists.linux.dev>; Tue, 20 Jan 2026 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768917139; cv=none; b=nFTC+Xg8phBhRb2gwIUd4l0nrCrb4n18/KQynPVSizu9a9gvni9NkD5WCdpcQc3mGq/+qE0Y05VJvfzESkIZ+/A11T3Zvi06mqJHr81bP4EnrFRWKWiZZggZlMOWUc7i2dfl8GG7hdqBj9MEejVISLlKCuvO1m15EXPWl63+tl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768917139; c=relaxed/simple;
	bh=hN1rzh+D74zkk3guIa93OV+Cmw6/7lSN+6IYnBtvn08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AGEzGmYMrM5nHzJNH4viEJbwb1YhZyf7y5erjJ4BSsuET40JJY2/N9OmHDsq6zq7khswt1XkRATD+6CCP4a3xObjSbjuiYGvFxM2qqYbTKNV4TjcOe0LNZSCC5c+bYRUHopfAhzpCKlKwcljNe56uLd0eyOVT7vdcP9tSm/5KAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uW0qdnB6; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uW0qdnB6"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dwTKC4tFmzllvdb;
	Tue, 20 Jan 2026 13:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768917134; x=1771509135; bh=z7Ql9TF2OpQSssME+GiX4LkC
	lditYptFsmWfqe2RLcw=; b=uW0qdnB6x3bNqUZRyfSWE87oFKz4Nj5AUucYBsnJ
	0LClNve3Oza4YjV9LKGc/1ILZ/1q5zDXnT69reHUyCBe+R1kg5k2AyYVYG/cXb/F
	f/1+ZW57HuLwyRnXzgtQC1P2ZC6wLJQuHbeZS0GFvI7lbFxqIEdtyDei31q9wbgZ
	/m/S12VEzV2PWvi+DKKBWoSZZHw57fng12G56YKL5h43PwAjETxhOS3x8qIAxUVo
	NGNyZK8s2aRbwjM1wuQLOt4C0U+r64iAZGBodquAEH2XVAlgpQaa9sSZHiNis+vA
	+kPTDvgpJPTbTagrbHZ3oVkroDD7qCpNPpVxxErR+XaBZw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c3Zh-qtrd4qM; Tue, 20 Jan 2026 13:52:14 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dwTK86NG7zlgxrb;
	Tue, 20 Jan 2026 13:52:12 +0000 (UTC)
Message-ID: <188351f4-e632-421f-b8d1-85afc75edd6d@acm.org>
Date: Tue, 20 Jan 2026 05:52:11 -0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Patch for mapping bug in drivers/md/dm-unstripe.c
To: Matt Whitlock <kernel@mattwhitlock.name>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev
References: <68f72c7d-7e4e-4182-87fc-78c138046cd3@mattwhitlock.name>
 <113951bf-b1f9-02ad-3e9b-9fc1e30a575b@redhat.com>
 <88ac5d9b-bc4a-4c7f-bc06-c4bee4ad9b33@mattwhitlock.name>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <88ac5d9b-bc4a-4c7f-bc06-c4bee4ad9b33@mattwhitlock.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 1/19/26 8:10 AM, Matt Whitlock wrote:
> On Monday, 19 January 2026 09:13:04 EST, Mikulas Patocka wrote:
>> The patch is OK. Please re-send it with the "Signed-off-by: Matt Whitlock
>> <kernel@mattwhitlock.name>" line inserted - this line indicates that you
>> have legal right to send the patch.
> 
> I'll never understand the obsession with this one redundant snippet of text. It's not as though my hitting Copy+Paste on it changes anything. Did I discover this bug? Did I write this one-liner to fix it? As it happens, yes and yes, but suppose I didn't: would you then really be legally barred from fixing this bug, forever doomed to preserve the incorrect behavior in the kernel because someone who didn't have the "right" to tell you how to fix it told you how to fix it? Good grief.
It seems like you are unaware of this part of history:
https://en.wikipedia.org/wiki/SCO%E2%80%93Linux_disputes

Bart.
