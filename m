Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6890819D8A9;
	Thu,  6 Jun 2024 02:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717639931; cv=none; b=Y7vqcML5pDhP8SS32VY3IUN+tinkHEMW+1v4A2cOWM5KiRIkSDiK5zMeg38SaHxU70g1g8YbzX0PPOi6uuBGmbShIYjnQYAci0wWrFZ+CKw/f4ncRPGaWByz2mOiBUvOpnHgd/m1zI9OnecMwnHzKXVzLIe15gAQjKh6Tzay25w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717639931; c=relaxed/simple;
	bh=Nu0ebJvDvi3CvrhFcCQzVxNxSxRPBKNE1k+wt8mz6f4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nt3viixrmwEaNthapUC0g530Tjzs4I6U4cLd/l02GeUVc+Ndi5E1cerV63KXLw1beGjZuPjWzxg0bMOTz2aquRWZxnaF1wvPjn0dI38cj+/2kYS3IAqmdjn8+YY42gWM7IAiR/NApJuqWzIUnFIk6xKcKtbJsad06dP282oStEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MOb4W/oD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MOb4W/oD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B06C2BD11;
	Thu,  6 Jun 2024 02:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717639930;
	bh=Nu0ebJvDvi3CvrhFcCQzVxNxSxRPBKNE1k+wt8mz6f4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MOb4W/oDkh5yR87MB1s+n6GFhcjBdb1UARwGHNUMIP7opQJzeqSGdf8rkZ9Tl7ssS
	 qzzTkgd6Z0Zi/6/0wkCOoGSfggwme0J291lLhs96ydlPHA1LnSBKdSnDM9UYnVcaxF
	 zHSgcSVAQOOg96XZ0oIrTrSS/8deAxh403weVzL2KBiS6P8HgTHTS2xWiNkXcz9LT/
	 lJSZeBi/IRTSp/zdxhKb5HTR9PFnh9PzfxDgeV3wv3mDW33d6/dTGRtT/Nn7XmfyJX
	 FpFGnGYjDA0xyfuQBh8KE/HsLGxvXoEJCC0/ChRaKnptgCnvmI4v+E0tV1R+hw3fwC
	 cOcTdn8NzuumQ==
Message-ID: <11c62aed-0048-4420-8edc-a38df761bef2@kernel.org>
Date: Thu, 6 Jun 2024 11:12:08 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] block: Improve checks on zone resource limits
To: Niklas Cassel <cassel@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Benjamin Marzinski <bmarzins@redhat.com>
References: <20240605075144.153141-1-dlemoal@kernel.org>
 <20240605075144.153141-2-dlemoal@kernel.org> <ZmCfmlnoo7wjQLTg@ryzen.lan>
 <2e8b1334-61a1-4c1c-a4f7-9550e32e7be6@kernel.org>
 <ZmEPFn9tvZb95fgz@ryzen.lan>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZmEPFn9tvZb95fgz@ryzen.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 10:21 AM, Niklas Cassel wrote:
>> Right now, this all works the same way for DM and nvme zns, so I think this is
>> all good. If anything, we should probably add a warning in the nvme driver
>> about the potentially unreliable moz/moz limits if we see a ZNS device with
>> multiple zoned namespaces.
> 
> Well, it is only a problem for ZNS devices with NS management.
> 
> If there are two ZNS namespaces on the device, and the device does not
> support NS management, the device vendor would have been seriously silly
> to not allocate and set the limits in the I/O Command Set Specific Identify
> Namespace Data Structure for the Zoned Namespace Command Set correctly.
> 
> But yes, this concern cannot be solved in disk_update_zone_resources(),
> which operates on per gendisk (and there is one gendisk per namespace),
> so not much this function can do. If we were to do something, it would
> have to be done in the nvme driver.
> 
> 
> Perhaps if the device is ZNS, and does support NS management, but does
> not have the Zoned Namespace Resource Management supported bit is set,
> divide the MAR/MOR values reported by each namespace by the number of
> ZNS namespaces?

Maybe. But that would still not provide any guarantee: a buggy application not
respecting the limits would be able to steal resources from the other namespace.

In any case, I think this is a discussion to have on the nvme list.

-- 
Damien Le Moal
Western Digital Research

