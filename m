Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B014127E14
	for <dm-devel@lists.linux.dev>; Mon, 15 Apr 2024 13:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713186157; cv=none; b=agx5t7YmCa/jpXn8apySDzGrb4SjnqiQHV7igrTobDAJtJgDzhTh17CZJLFchQK9jYdjoCRAChtjhHoI1N9QGoZsaYHdIgy6i/do69xgNhpqQ40Y77jbwkuOadQlejh2aopCHVOXdyLkhMBmJ66Bf0c10lB5gOGKCWhP08h21MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713186157; c=relaxed/simple;
	bh=RoxAGvomIR/7mfhwQ5ZKYXw87HUfhCwHYzumIR7qulk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=Xh2kPNJSA9/amjaxBE9zUFGPXbPK7hfo3/csLnGWGQ90ml4MmUe7RZcORF1O2dE2Wt6VXqGWdqs5QEg/7E2hf8k4JvE0cA7H1weZ63m0zVgO5X9rrkX7GgP+bMO/llNJ4sdpDrnd/O5fHLj4jed8ScUlR+T2SZdPmoZCcRTppds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no; spf=pass smtp.mailfrom=schwermer.no; dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b=3kUPeqTi; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=schwermer.no
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=schwermer.no
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=schwermer.no header.i=@schwermer.no header.b="3kUPeqTi"
X-Virus-Scanned: Yes
Message-ID: <847a0907-b174-4ba2-90b0-3be96db2e2da@schwermer.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=schwermer.no; s=mail;
	t=1713186146; bh=RoxAGvomIR/7mfhwQ5ZKYXw87HUfhCwHYzumIR7qulk=;
	h=Subject:To:References:From:Cc:In-Reply-To;
	b=3kUPeqTi344zi63tFhgM2MKbmRdOmvWAnjTyZn9FpYuJNIBm0Alw7VgyN/Ji/mSUR
	 iA1ITCntEpNTXRi7Ds+4USPqp7dL9WHKgj0bEASrKOWcuaHRTclqmLbkmxtix+Vl2B
	 XT52J6/Ca8cDX7t44gcEgMBqPG0EB8aUpnxoakAzz/GiI1udY8AA16gDOCuW0ftjBZ
	 0+J9UXPIsXReisRCv6Swb9h5pQEEWNHdV3JvwIWUF363KFvqB+Fh2fGQpKQFqkBLeD
	 +8O3g2rANWX3E+SBnpz2Gu5wXaHEwk5/3bzyHeQHjaTecGsVGtkEHosTaFiXxzh4xu
	 zp3uchDppn+zQ==
Date: Mon, 15 Apr 2024 15:02:25 +0200
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: dm-init/dm-verity: Data device lookup failed
To: Christoph Hellwig <hch@lst.de>
References: <b5c5cd56-b9dd-4368-a8e1-b9e0a07b79b4@schwermer.no>
 <20240409142323.GA22617@lst.de>
 <ba299ab0-9b70-469f-8c1b-bf88465df63f@schwermer.no>
 <20240415073829.GA32688@lst.de>
Content-Language: en-US
From: Sven <dm-devel@schwermer.no>
Cc: dm-devel@lists.linux.dev
In-Reply-To: <20240415073829.GA32688@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

> Yea, the early lookup behavior is weird.  But it also dates back
> a long time, so I'm not sure this changed, except for maybe timings?

This might just be a timing change. I don't know. As mentioned in the 
initial email, this change looks relevant: 
https://lore.kernel.org/all/20230531125535.676098-19-hch@lst.de/

> If you go down the device open route it should us the kernel open
> routins and not just the not open ones.

OK. Would you mind elaborating why?

> That being said the right
> fix is to not use this code at all, which was only shoe horned together
> and doesn't have a chance to work solidly and just wait for the
> device in userspace because we do have reliably udev events there.

I cannot wait for user space because my root device is dm-verity-backed 
which is why I am using dm-init in the first place. And I am not using 
an initramfs. Isn't the point of dm-init to be able to use e.g. 
dm-verity for the root device or did I misunderstand the docs?

Thanks,
Sven
