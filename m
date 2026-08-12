Received: from fhigh-a6-smtp.messagingengine.com (fhigh-a6-smtp.messagingengine.com [103.168.172.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A6741834A
	for <dm-devel@lists.linux.dev>; Wed, 12 Aug 2026 09:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786527488; cv=none; b=qF/5IDaG1xhPNZxq8z5JXoIfwukGh4xyIaLlPVOOZwQ3nJmCgmv1ie6ksUPPpBb+zloKaOYTbIiS6lA+IaF4MZA2MIO1eZW/6vVIMkCvmPwNVQhzSwVQci+H3jS+XF0aoZBnC0s9KHVzBMWHdf4MYFowdANJjyUgjghcqYVSDo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786527488; c=relaxed/simple;
	bh=GKA8R7aB+Vc8kE8aJLjga2cYW7q+vBaQaTkhFAnan1Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XStZF9u6VhxsHXsV2e0/7dX36X/5tDYXbJyMhkiM5E2cW8ntRGkJiWiauIYSEYgelElInVTezxw0I9V+HuPL3jNfXgTlTKgNW3iLbArDS6WoWYSsTWqXvGw8nOqY0KM4cb8+cbdBUoAi5RifZPTno4yNjFfY/xL3UKnqC5Gvb1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de; spf=pass smtp.mailfrom=jaseg.de; dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b=V4tF2JBd; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=D02IjoWl; arc=none smtp.client-ip=103.168.172.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jaseg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jaseg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jaseg.de header.i=@jaseg.de header.b="V4tF2JBd";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="D02IjoWl"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5FC191400109;
	Wed, 12 Aug 2026 05:38:05 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Wed, 12 Aug 2026 05:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1786527485;
	 x=1786613885; bh=pSjU3PJUSKWTwfIa8UTQEEYIsB9CWfqM3x+Bpzgd72o=; b=
	V4tF2JBdQ27kezAu13IgMnmK320iSmSf/SOtvIysOI9Hvnt7Lp2/erkCwJ+agxOo
	Cj23aSg0jwihOfXHHRwaYVDFxT4Q5cIMeEFn5EagDdvYdU1/a8PN0ho4spDOgGk6
	X0AC0bwp8t+BtVY3bR7mVFFlMxu2jE5iOfM3x8Yuz5kwCaPLaT+h+CyO4W9y8Tw+
	RoW/yL244PiCAXYyiSs3eceuOS7U6eXI20po9pMm0P9KiAkUI724vpcIfBxhBJg6
	RfDawx12OmFiIkXzKis5jK3s9DZYrEVvNWDEH4Fp3jlws0SCbTDIKeF61qhUMm02
	qo+XeOhxivZ7NMTMQhzILA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786527485; x=
	1786613885; bh=pSjU3PJUSKWTwfIa8UTQEEYIsB9CWfqM3x+Bpzgd72o=; b=D
	02IjoWlWph4Oad6pZPpNSMCpIJBX9trrIlp3kvbD9/xGVqQiqiKa9n0X3REAw0PX
	PnFtmECdiLSJ3vgWQOrBt/ZFWob26Eyq4TtLwvhuBpW7a4sAyAu66IvDamZb1rKw
	SKSWM7MVzk2gjFSpeRUtrplmZhcvC/5+uWeWTVuoFQd6J7bBZCnw5zYUMr3rDm5P
	4sDCwLV35Nz7sMvvnblgdn0jgPHcZQ0cmzr4LvzQnGWmTrBrWwvsJM8Q8APL3PpB
	DhFa/McXlzB62MeldLjAAKihbxNTcM+GXLYXxdDE8rfA5Ujw/jMx8c+msL7IN12K
	LC/QCY8OjJIhxAbQEZTDw==
X-ME-Sender: <xms:_D58anGesogWwHzZHNLjoWn6EqE_bnHW-94eIAyWVWL_HteiOFkI4A>
    <xme:_D58aimCCx9oZ4V1o1XpDyJmigvMZUTRLiQvxXMap0D0XOni3e_KZVoxbw6oz_7N6
    qT3nDrnIPPh2ZvnUiIVvlaoIgYsFyktifyPjvGTnyu3O53uhSS5eXQ>
X-ME-Received: <xmr:_D58aieF8RFMaaM-j5n7P2X0DCy49XS4fU1vQNoVXRsBDpjhxVwgaVRGA2rrjp1B95QZ0BX-ZBKjTgHZenbGsoQ>
X-ME-Proxy-Cause: dmFkZTF1D1LvN9q+eU+k7sNFuw8bSo2AHKncRkLW62/ntWZUbnh+3xwwW66lrmtXmZ5iKR
    WW0nbPWDT7lYeosyuydiGjxcsMiOhrtqmI1tROhRlk8o5LA+1F+WbM29OxSyGv3g5fUOHH
    AbtqVOpOtHLTDZbvg/Pel3oMpGnLoWeUm7Q+b7osS47kGC59Yqs1B/5c/DV/YFsCRu4XZk
    kGdXfB1eWI2kST5VrrNK/5lHkd238hUWyjRF+L0FTVoU1xj0XvPXlWkNH4+Z6y1WY1r7tn
    592S359Ai/qvOBaNZX/jJo0rYQF8M8/YDHJx31CUqsShucpJpwMbcMVUBdUVQ6urfaOWPX
    rEoq7FClfe+YEqoKYhvR0SNvRvQxsaBHsvHmOfp+djrkuxRzznERUCAq4hOo1xCKvj8kO+
    f54G+qS0FPYkffPok7EUBPzcPOtoHhzDT6bOboO9jGespH5dvA+QFI2qLZJI0bEPq0FEqB
    0JtQDVF/cAjwjt89FHx2reyGEuUrOjIKKpFoEeDkeJ80Wn4IyDuPIan2CypWaaGE8x1PG1
    5ywHnUxuO9PN3XkTZK8pmJnby1n+1rHqlp1nnHRRejkAORg09wTc4mu/I2T/4u8EK+UbAG
    4loWVFj1e3xwuxKDgLm63nzY9avk4CpvANYu99YVCqjPmqJ8geb6WBWAJYZg
X-ME-Proxy: <xmx:_D58aoGOTyqb0l95sfGer9_8C26HhgtPflIajtrnPv4xMunUPRTp1Q>
    <xmx:_D58agiunorDmOfX0zD8_8sTp-m2wWS2CmnHYGATH73RhDptFJ1yHQ>
    <xmx:_D58ak20fLLzPAazgXaCdqGKWsjh32XJMxBQ9HPk-YjnUVROmKObag>
    <xmx:_D58ajcsY86fFJJ0sOJEU17T33b8tAiKhLsZS3xUlG7kcAzrTiwnGQ>
    <xmx:_T58ag22nDi4AFnBCvJuXvWPeWro7Ya32ckFnjJWaqKhHPo64uroOBF3>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 12 Aug 2026 05:38:02 -0400 (EDT)
Message-ID: <653e2af4-12c4-4312-b927-40a961390c2e@jaseg.de>
Date: Wed, 12 Aug 2026 11:38:00 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: memcpy is leaking secret data through ZMM vector registers
To: Zack Weinberg <zack@owlfolio.org>, Florian Weimer <fweimer@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: Alexander Monakov <amonakov@ispras.ru>, Paul Eggert <eggert@cs.ucla.edu>,
 "H . J . Lu" <hjl.tools@gmail.com>,
 GNU libc development <libc-alpha@sourceware.org>,
 Zdenek Kabelac <zkabelac@redhat.com>, Ondrej Kozina <okozina@redhat.com>,
 Milan Broz <gmazyland@gmail.com>, dm-devel@lists.linux.dev
References: <a139443-d6de-7be1-c59b-c099b0b32884@redhat.com>
 <CAMe9rOoErR0xLqf4wLzk13XwTQY9-+cRAxDWKW9HU+rB0GApzQ@mail.gmail.com>
 <a995c5bd-8f80-2118-4d4-86e5e062a77@redhat.com>
 <CAMe9rOpz5Uft3MKXneYd3VqW1CaSXFF_GLBqKEZFiZsidKA43A@mail.gmail.com>
 <e35dccca-a1e7-93c4-f797-b89246877370@redhat.com>
 <9cefd07d-2940-4865-bd77-3dd0899a539f@cs.ucla.edu>
 <d387436c-8c35-4f51-bf49-dc02d829c73a@app.fastmail.com>
 <ae79e84e-5a69-dc3a-08da-ef03f6d17c34@ispras.ru>
 <a2369edc-7159-4f0d-8f89-9d41a79d7f7e@app.fastmail.com>
 <4f9517c-46e-367c-8891-e452d7983b67@redhat.com>
 <df151cf3-fb22-4465-81dc-34e0172a4fcb@app.fastmail.com>
 <c5ac58cf-3e2e-3cc4-5a18-32c9acdef82d@redhat.com>
 <878r196igy.fsf@oldenburg.str.redhat.com>
 <64eab296-05c3-4576-b4e2-526396e1524f@app.fastmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Jan_Sebastian_G=C3=B6tte?= <linux@jaseg.de>
In-Reply-To: <64eab296-05c3-4576-b4e2-526396e1524f@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/20/24 05:29, Zack Weinberg wrote:
> On Fri, Apr 19, 2024, at 7:27 PM, Florian Weimer wrote:
>> * Mikulas Patocka:
>>> On Fri, 19 Apr 2024, Zack Weinberg wrote:
>>>> On Fri, Apr 19, 2024, at 4:15 PM, Mikulas Patocka wrote:
>>>>> On Fri, 19 Apr 2024, Zack Weinberg wrote:
>>>>>> ... the copy
>>>>>> of round_keys in the vector registers *won't* get erased -- the exact
>>>>>> problem being discussed in this thread.
>>>>>
>>>>> On the SYSV ABI, all the vector registers are volatile, so you can erase
>>>>> them in explicit_bzero.
>>>>>
>>>>> On Windows 64-bit ABI, it is more problematic, because some of the vector
>>>>> registers must be preserved.
>>>>
>>>> Oh, huh. Yes, that would work.
>>>
>>> I've just realized that this wouldn't work - if the function
>>> explicit_bzero is lazily resolved, the dynamic linker would spill the
>>> vector registers to the stack prior to calling explicit_bzero.
>>
>> No, the dynamic linker makes a tail call to explicit_bzero.  There's no
>> register restore on the return path, all that happens before the tail
>> call.
> 
> Doesn't help — if the vector registers get spilled at all, we lose.
I've recently come across a similar issue as reported in this old 
thread. I was checking for key residue in memory dumps of a crashed 
system, and I saw parts of keys persist in memory long after they were 
deleted by the application. The leakage mechanism I observed was:

* app memcpy()s key from one place to another
-- key residue left in SIMD regs now (in my case ARM NEON, but would be
    the same on x86)
* app does something with it
* app properly zero's everything
-- key residue in SIMD regs not cleared
* app continues running
* context switch happens, kernel switches to another task. Kernel saves
   SIMD reg contents behind struct task_struct
* system crashes, RAM dump taken. Key residue in kernel memory.

So even if the vector regs never get spilled to the stack, they still 
can easily end up in kernel memory long after the original data was 
erased. While this is not a big issue if everything works alright, it's 
still counter-intuitive and I think it would be good to do defense in 
depth and zero these vector regs after they are no longer needed.

I'm not sure the general purpose memcpy() would be the right place for a 
mitigation though. While AVX has VZEROALL, ARM NEON doesn't and requires 
32 separate instructions, which I think could impact in a measurable 
performance hit even if you only issue the ones a particular call 
actually uses.

- Jan
