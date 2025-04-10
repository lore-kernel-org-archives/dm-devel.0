Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019FE20C472
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 23:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744329409; cv=none; b=mMohw1PV5LngT6dIDbMVrYJfRdCPOT8OCppeUDNjZ+CQCN41K49zmHxRmS2LK320UQ1BGKaLdrZhSYjBh7Qxbf8ilvyH+fHimnVYeq45SZZlZ/8JP3iYiDV1+Z0FItnMQNR+NpnNfOM4OzUZuiXpObOCT1dzQVkXIzwYbJ9s6TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744329409; c=relaxed/simple;
	bh=4YbmKxuyuIAkRQWraVoFRfsoMXf2znbPsP7eRMcODPo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rLdZIrPaW8OphSSUWMMZn1MXVQ047lDlv3hpy5Jdb8gNi+JobkM1VXePpIOsHeZ7eFSEd4PDZ9JYu8RfILRwhRsv/ff85NOJaobx54DOZZlpi3Gp54qGpBwLH4cJme1TXCdNsaE73eXTOwLGhISg6OLMOq+7rNAkDcoGaw4czIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uRK/NpDc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uRK/NpDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC41AC4CEE7;
	Thu, 10 Apr 2025 23:56:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744329408;
	bh=4YbmKxuyuIAkRQWraVoFRfsoMXf2znbPsP7eRMcODPo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uRK/NpDchEbu9a715TGqijgMXf3wwE/VYhtSUcC3qgjKx2s4pK5NIw1OUcXJbwLYY
	 AzY5Rpxslh4soR2Mue9V+z9YdBnFtoatuJIT4AVLIZiik76ceqHieCO8l6dQHq6LsO
	 m3Z1O7qYwhB/TXEkxO+eQUm0EIqOmpf1DsgvAQSakjZe2cTozc3Sf2qG+Coz1sv6eE
	 une6vEoyj029fH/IuA/qX18cet7mlx9HfZZxtIOMAIBuYGXGUGljXD8fRH+qXYLGsy
	 j8Yh9KijtSuciacdGjvn1E3zjWC2wmos791jsjH0AfHI/DXcTElG4xkm9VJLo5uaqz
	 bG8lz0LoRxtjw==
Message-ID: <96c34cde-0f4b-4f43-b689-f0dfad2f2026@kernel.org>
Date: Fri, 11 Apr 2025 08:56:46 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-delay: Prevent zoned write reordering on suspend
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250410043311.990675-1-dlemoal@kernel.org>
 <20250410075431.GA763@lst.de>
 <df1c183b-3228-4785-ab31-a21d8165abcf@kernel.org>
 <Z_gJqBqsmg-ZB3_w@redhat.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <Z_gJqBqsmg-ZB3_w@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/11/25 03:10, Benjamin Marzinski wrote:
>>> Don't we only need to do that if anything is queued up due to a
>>> suspension?  Then again having a different patch might be premature
>>> optimization, it's not like anyone cares about dm-delay performance
>>> almost by definition :)
>>
>> True. I can add a list_empty check here. Will send a v2 with that.
> 
> I may be pointing out the obvious, but we can't just check if
> dc->delayed_bios is empty, since we pull the bios off the list before we
> submit them. We can only skip adding the bios if the list is empty and
> flush_delay_bios() isn't currently processing any bios.

Hehe, obvious when you hear it :) Good point !
I will not try to micro optimize this.

-- 
Damien Le Moal
Western Digital Research
