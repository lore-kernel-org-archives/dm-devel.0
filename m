Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C267E792;
	Sun, 11 Oct 2026 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791737276; cv=none; b=cVfxksUP+WvHpPR0JDZ5m0vz2jqibWV35IQ26tjN61aJk4UbgkTToEr+TMcdRP0PRmXJ61i7Qu34X1OteLtisLod5M0vDHXzrsQ1uuw7GeWE8KcVkBng5Gmeds1ndrlePqGAnIxuLh3bCPuCyke8hwZjeJkIPezU1XGM3C+7TzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791737276; c=relaxed/simple;
	bh=OVGo8dveVvVAx8FNd5XcZlkwgwrwQ05THxwYXOHlNXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qBAkfI21mWiUABueqxfKXMiCMKxiL7VuEGZHAgOwC2ke5U14ZIx8f/b4bSKWmxsvc4buAY4lTPRqjo7OvkY3Doph8fjXu2YGDc7AUj+JgPwDeOG2n6qhy5i8CdPFBItXi4D6icYsnGK1vHJi6ogTX30pyE3VTfyaFoc3xdTfJfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I0i5zUIr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I0i5zUIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD661F0089B;
	Sun, 11 Oct 2026 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791737274;
	bh=PZx66SNzwXD+jDh1BHHrQGaE+eCg+axuqiwcG6OzGvY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I0i5zUIr92BP0gcfo+EkMmENLIZHvBWo9OPMvkVBHAC2Iv05USoGhD83bA+8tTMVJ
	 3OM5sBwIyLWxkHeOMvH/o0GPim9v9gZbYX1CrOYb1gpLfYLpsjC3PUua3Um1OPWuXK
	 +KZUL/v+5GvsPW46SqSqPVDUfrBaM17mmPbhVbXfXiQEhkVLzzXudlY6xOXV3ZMfFx
	 IKSsBx8U/NtLa+l81mK2sKN3p6VvUQAp5iC8hckkPECKmuGyzRjF6lffwIO2b6ukoU
	 ACZVgNBBJVPa3rju+8WyEUnfDJabjxOaWc55pF20FYdYAIIJCE/TA0U5VuBJbZuEIj
	 tEgWB/KyS8VXQ==
Message-ID: <9258312e-0527-41b4-8d67-a1e8f46eb466@kernel.org>
Date: Sun, 11 Oct 2026 18:47:51 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] dm zoned: back off when reclaim finds no
 destination zone
To: illofspeed <illofspeed@gmail.com>
Cc: dm-devel@lists.linux.dev, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, bmarzins@redhat.com, hare@suse.de,
 linux-kernel@vger.kernel.org
References: <8d1ee370-2785-438d-9c5b-8363584a23aa@kernel.org>
 <20261011161731.394-1-illofspeed@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20261011161731.394-1-illofspeed@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/10/11 18:17, illofspeed wrote:
> Damien Le Moal wrote:
>> Patch looks OK, but is "ilofspeed" your full name?
> 
> illofspeed is not my legal name, but it is the name I use for all my
> public work (GitHub and this series), and I understood
> Documentation/process/submitting-patches.rst ("using a known identity")
> to allow that. If you need a legal name in the Signed-off-by, please let
> me know and I will resend.

Re-reading the doc, "Sign your work - the Developer's Certificate of Origin"
states that:

...
using a known identity (sorry, no anonymous contributions.)

The key here is "sorry, no anonymous contributions.)", but your github handle is
anonymous, in a way. I am not a lawyer, but that is how I interpret it.

Nevertheless, some googling is telling me that pseudonyms like a github user
name are OK. Personally, I do prefer and appreciate peoples giving their full
name, but if you prefer your github handle, that is fine.


-- 
Damien Le Moal
Western Digital Research
