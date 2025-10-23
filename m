Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7811E25E3
	for <dm-devel@lists.linux.dev>; Thu, 23 Oct 2025 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761242074; cv=none; b=Fw2P+PTV4m+18oVkhJqBmLDQLlrkaarzc2p194nKhcyKxLT3h0eWdVmuiysGvjI1vdyPpbPNxGjj0GvEbEU9gwuriWEng47omPR7JZHtETbTHGrQ1Gw47H/jrcqQ9EpmVoiqrR5bxrilKKNyeB7B008CSejQEixmu5aPxnaR9zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761242074; c=relaxed/simple;
	bh=GmFo2j6mgKMw3obgwRZGhTKWFOfqJgf2PqdrG7YIgZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RAI+Xb7nxHjoTBFfILXGsCFZ3AaQ5jfjcQ286BoKex/se8MP2G/EGRt7tR+JahK4tYDzz6qcOcv74yQbrIWY9sy7bGP5GRlNGF97im0Vr0f23hlaBSDIPB3KZGd/CM2R3LEu8MF8HCBMCqjnfYFuOdp2Y9jsKMHmaGPO8vuPP3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wgatmfnE; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wgatmfnE"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cstvq43cxzltP0w;
	Thu, 23 Oct 2025 17:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761242070; x=1763834071; bh=51nKab0vGeJorWF3jK4Wn4GQ
	D/6NJobUp5ZT92t9RkU=; b=wgatmfnEibyFVYgCUd+QKBRHNUMgSqTnUgdf3Y+3
	hcyxCiEosK1prvgUOG1Hwgf1nbHSm5HEVQx8zzfc7dKuMNGdlEtvUnU407sdoWDX
	bYCqUhIDudeX1SlkZu+/c8WaCHKF41UcZ0LlXzFlhwAmD2+rV9xxWwQd3SYtqFH3
	AP2BZyjBTICGDcHCjimx2WicsKoNqMB/LL6X+8APYpL4ru/fjEhWn9X9soq+QarF
	b00jXnYZ527xv3lJXyU9eMPd0EhETe2y01An9XSOMnkG3hFdHjCcVoOa3JGZWVkF
	JpCJdjat+k5h/a8Tcl1L5C+KtiN2ew+dwJK3znvOphN0Pw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qN3EpXhw2onE; Thu, 23 Oct 2025 17:54:30 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cstvj3PnXzlff8S;
	Thu, 23 Oct 2025 17:54:24 +0000 (UTC)
Message-ID: <f2ed23ab-46fc-419a-9fde-ac554afcf1c9@acm.org>
Date: Thu, 23 Oct 2025 10:54:23 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Fix deadlock when reloading a multipath table
To: Benjamin Marzinski <bmarzins@redhat.com>, Martin Wilck <mwilck@suse.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@lists.linux.dev, linux-block@vger.kernel.org
References: <20251009030431.2895495-1-bmarzins@redhat.com>
 <ed792d72a1ca47937631af6e12098d9a20626bcf.camel@suse.com>
 <aOg2Yul2Di4Ymom-@redhat.com>
 <e407b683dceb9516b54cede5624baa399f8fa638.camel@suse.com>
 <aPfcAfn6gsgNLwC7@redhat.com>
 <a186416aa03bb995b2f04fdb47315c1d12a87cab.camel@suse.com>
 <aPpobIv6j2qEmt4u@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <aPpobIv6j2qEmt4u@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/23/25 10:39 AM, Benjamin Marzinski wrote:
> On Wed, Oct 22, 2025 at 04:11:58PM +0200, Martin Wilck wrote:
>> On Tue, 2025-10-21 at 15:16 -0400, Benjamin Marzinski wrote:
>>> On Fri, Oct 10, 2025 at 12:19:51PM +0200, Martin Wilck wrote:
>>>> I find Bart's approach very attractive; freezing might not be
>>>> necessary
>>>> at all in that case. We'dd just need to avoid a race where paths
>>>> get
>>>> reinstated while the operation that would normally have required a
>>>> freeze is ongoing.
>>>
>>> I agree. Even just the timing out of freezes, his
>>> "[PATCH 2/3] block: Restrict the duration of sysfs attribute changes"
>>> would be enough to keep this from deadlocking the system.
>>>
>>
>> OK, let's see how it goes. Given your explanations, I'm ok with your
>> patch, too.
> 
> I see Mikulas pulled this commit into linux-dm. Bart, does this solve
> your issue? Looking at your hang, it should. Also, do you have any
> interest in attempting again to get your fixes upstream?

I think that I have done what I could to get this regression fixed. As
one can see here I reported on June 30 that a regression got introduced
in the block layer:
https://lore.kernel.org/linux-block/765d62a8-bb5d-4f1d-8996-afc005bc2d1d@acm.org/

Although Linus Torvalds does not tolerate regressions in the Linux
kernel, the people who introduced this regression were not impressed
by my email, refused my patches, did not revert their own patches that
introduced the regression and did not suggest an alternative approach
for fixing the regression.

Bart.
