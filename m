Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E46329F05
	for <dm-devel@lists.linux.dev>; Thu, 11 Sep 2025 16:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608297; cv=none; b=sM1J2avQijX9aWCZdNi7xjHU9ps9wNOreFQzFFGHP6sptOjTffY/rTNPZhnp+b19PiHML3lVuVH5Dwn/zjBinF7jAhAojhcygg67r/H5Vs/abK7gFnBPdxtghzfpe/sg3rDDDaMiJP2OubQDQzBwmagvZfIO65MT927IFdKnHVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608297; c=relaxed/simple;
	bh=1WW8i0F0VT2tz/ozU9Qjv4ROaWAIR11Z+l+hCK3fBSw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UlH8yYT2ujnn/JQMknmU6FHWCzQXCqvSQzU6n6IZI9+FxE3LTHIB6BynlNm0OWpPq+7rEpJh2/sTmr9XUe+Dxns+f2qg7lUKzYCD9pvmcbTP/T1qvUYflDECtsXkw5C313U77JDZPB76lIfnStG0Tbim++7CprfDxcrV97K2mVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xx8aOJJF; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xx8aOJJF"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cN33W0W3pzm174b;
	Thu, 11 Sep 2025 16:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1757608293; x=1760200294; bh=1WW8i0F0VT2tz/ozU9Qjv4RO
	aWAIR11Z+l+hCK3fBSw=; b=xx8aOJJF5W+fYRLfBAYDN8gwzmyJ61QOQQj/Sywu
	m7Rw/SuaN0gO0v9kOvUy+CgWfpijhJL4Tiz83k5LKsdNCWkaInAi2m7teQ76ZAOe
	WgA2nePycx0iBunHep6PBeuvbvrZjPjWODULo5eIfHxeh6F0Vzp8IiVypJdAz+bQ
	MowD3p+ZaKGZY0KNFmsXnta4eEtlVnTgjBvKLAdasUxEMYoQU4Ry7y+gqMijlc1w
	YQPXg/kZrAPn/LjpTI4wCtS2WD6Lcv7xdGOt17eCuLLVV5P7ulXpceie1O4pDol6
	xkPltDaJkryx0QzghdmFU3v3Gi0j9eaFiUVbkpJ9PMpfyg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZDzTMC9S24a9; Thu, 11 Sep 2025 16:31:33 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cN33P2ndPzm174c;
	Thu, 11 Sep 2025 16:31:28 +0000 (UTC)
Message-ID: <bd1b6069-1ea3-4fe9-ab5c-36fe69bd9443@acm.org>
Date: Thu, 11 Sep 2025 09:31:27 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] dm: Preserve the order of REQ_PREFLUSH writes
To: Hannes Reinecke <hare@suse.de>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>
References: <20250910172742.187645-1-bvanassche@acm.org>
 <e1e3a403-87e8-4e06-b68f-b8c8814a3160@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e1e3a403-87e8-4e06-b68f-b8c8814a3160@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/25 11:01 PM, Hannes Reinecke wrote:
> Hmm. But if additional writes can sneak in between sending the empty
> flush and the original write bio, why does that happen only for targets
> with one device?
> IOW: Doesn't this reordering also happen for targets with several
> devices?

Hi Hannes,

Yes, the write reordering for REQ_PREFLUSH bios that I mentioned in the
patch description can happen with any number of target devices.

I'm not sure whether the reordering can be fixed if num_targets > 1.

Thanks,

Bart.
