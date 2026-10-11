Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161812ECD1D;
	Sun, 11 Oct 2026 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791736337; cv=none; b=pRI4zzKPusxt79ePY+n/7Zx/dvAlWTFbIYq1CgpkqbqxXQPm5JZHP1l6MfhxsI+BSzapNEu7W/I7WlJ1i2P69AyzMiGWwCWBrqygFfltEiFBNORLehmFzuwNoqQyagEBODQv8YZP/2h0eGBvmCjwL8RiCFQZTpAaD2REyIZ6rJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791736337; c=relaxed/simple;
	bh=/5/D2cCp4cLtnup4YVAmLACcNOcSGPqcz8HxIyVxSZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xil47ziMTLSEcRCLQ5hpLDnlMVxBJuDzXhXTqIndFCzvsUdI3enripvzUPV4N2V7ic4/pvxS59dtQbDiZYCN0S0tZxjq1MJsCQEcgL2g0pkQ/W9I2nYg21yeiSX66A22xZWLCifcvkWg3azQbtF5jaD2O9qWh4E3yNwCdS+IumQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FDmi4emF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FDmi4emF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D841F0089B;
	Sun, 11 Oct 2026 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791736336;
	bh=e4+vpLVVPaNUrDQ4eqc8qogxeexsOyk5QMQbO4ookdI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FDmi4emFOmfute0xHKk7FqgDic/xcRIPkzefY8LEjdvFGfnpIObnTAM3w/9AsLVJx
	 TvWqhpGTlwYdD9kOK5HbqklFZ/Yk6DIxRJ+oIvS4LhKe5b/S4lNU1DrzDVLVx9h0P7
	 4fOs7NCn/tKOcwAixBrRKvLP4k2vSgCIUEGVEBM3paHH38ALGDKhq4nnRKKBzimeMf
	 rhtb9C9wkxjVrDPQdAtBpiXfjNGi91jaGmgiTXf9m2AXtBBZyU5jGrs5UelY7EkbuS
	 w/XpmojWp4eptO1wfkM2K+RkWSgZAqq9E7BOy6VbnJwXZeGtvMzHtBe1Pa8xq8NY+e
	 eqY/LVr++O39g==
Message-ID: <cbcfcb07-3956-4243-a54e-119d83fb458d@kernel.org>
Date: Sun, 11 Oct 2026 18:32:13 +0200
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

Hmmm... I have not read that doc in a while, but the point here would be how
"identity" is defined. I do not mind you using your github handle, as long as
the rules allow it, that is, "identity" includes a github handle as OK.

-- 
Damien Le Moal
Western Digital Research
