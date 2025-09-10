Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3878820297C
	for <dm-devel@lists.linux.dev>; Wed, 10 Sep 2025 01:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757468494; cv=none; b=kiZdGbyATQaFg/jBabpojhpEnTcc1trUHNfsX7npGT4VLct8gh5oiWbgT1qnAaI1FIuTCmIygmtwwJRPfwzvuYU+/FkaU99yToV+DN+7VTTcyR3u4kK1K4Q9xkMiwtQ+1zwfXlP0D2Kf/lUVhhZ03iM3GLSoj6ni4jisARb3EqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757468494; c=relaxed/simple;
	bh=yNXeXX4b7wqXOuT/ePnPLhHbB2kJYPtuDhJAd3tM150=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H8IpKW8eIXMUTt6WtCrxXfDdLL645puJUMI8xpsdUCI6+4XZUgz0yf/NMxiZA1jtkLMy5eNJryENwJeqIY8Q4yrUWdh2/sQ07tyODKXjJOQw10I2oTyCvqBIDoSICZ2P9FzM2yRoV3sA+f0TOMxjfgbDmXq8iLMLvhW6irGjqNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXAZjokg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXAZjokg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A000C4CEF4;
	Wed, 10 Sep 2025 01:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757468493;
	bh=yNXeXX4b7wqXOuT/ePnPLhHbB2kJYPtuDhJAd3tM150=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VXAZjokgJPyPTQa+soTsv/BT0MD8IJm0glNTyIAGd6UuDGXchEb8PYxiGHsvIy1N6
	 Y/k+ntEtBpZYtPnzkFWeKiOc6Hu0w78pPtK0ORoNdfsrPvORCoq3XEnAb/GZGmqmTc
	 YuleaT9n8UbvWwDLZDPkmBsn30RBhr5NmhtmukIMt5f0i60FQvHCrcTQQ7Jf3hjsDd
	 pn0GhsyY7bbyTKffKu27Z1ag1OUoWtPLaAVZ5btyVqTkI41y+nVd1XnWxMPT8cUzJF
	 ALg9w40K8ohtbbHI5evCIxhD5Es3Y4Wte+ZER0E18JvEEfv6NHiPpLIRF30cDBTqLW
	 LtA1ybheiTDhw==
Message-ID: <f3c4dfe5-5930-4fde-bf33-1a5004a98b23@kernel.org>
Date: Wed, 10 Sep 2025 10:38:31 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: Preserve the order of REQ_PREFLUSH writes
To: Bart Van Assche <bvanassche@acm.org>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Alasdair Kergon <agk@redhat.com>
References: <20250909182641.3496300-1-bvanassche@acm.org>
 <aec57265-20e4-4012-b3ae-8cb9c375da60@kernel.org>
 <f4ca5122-a24d-4d37-8b90-2fdc2aed7699@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <f4ca5122-a24d-4d37-8b90-2fdc2aed7699@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/25 10:29 AM, Bart Van Assche wrote:
> On 9/9/25 5:53 PM, Damien Le Moal wrote:
>> On 9/10/25 3:26 AM, Bart Van Assche wrote:
>>> Splitting a bio into an empty flush bio and a non-flush data bio is
>>> only necessary if there are multiple underlying devices. Do not split
>>> REQ_PREFLUSH bios if there is only one underlying device. This patch
>>> preserves the order of REQ_PREFLUSH writes if there is only one
>>> underlying device and if multiple writes are queued. This patch fixes
>>> a write error observed with zoned storage devices and with write
>>> pipelining enabled.
>>
>> Write pipelining is not upstream.
> 
> That doesn't matter in this case because this patch also improves
> performance without write pipelining, even for conventional (non zoned) storage
> devices.

Then please rewrite the commit message to clearly state that and add Fixes tags
as appropriate. Do not mention things that are not upstream please.

> BTW, I'm still waiting for a review from you for this patch series that
> was posted two weeks ago: "[PATCH v24 00/18] Improve write performance
> for zoned UFS devices"
> (https://lore.kernel.org/linux-block/20250827212937.2759348-1-bvanassche@acm.org/)

Yes, I still have this series in my inbox. I have been very busy and have lots
of conferences coming up so the review is going to be slow.


-- 
Damien Le Moal
Western Digital Research
