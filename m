Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBFF17A31A;
	Sun,  9 Mar 2025 23:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741563116; cv=none; b=DdmiP90TKorZBwovz/peEfZ9fKqPYArXQwW2gf0/+DFqvpfGxjDsys1jQhITpV9EebZEAKJp3jhtVceKNztrfg9pSdu2TEO7olOfXVsyEtUIZFHgSMyha02MS08CJXipqtjGXEuhDs7jRudtI0vad+MFt2/5R5NgAP1YSBj0Ksc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741563116; c=relaxed/simple;
	bh=HoHqYTigoX1mE1j9hShhjHrbCM3WSAnJU2/9V00bmqE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KM5QtGOCRMOrMlEGJ7ISbQDYOHafZoh3uGuV9+Fhhjt/LQlWTV3LZ8xr65k3ILI5jVlDd1u9jYwuHaoraXc46XVVUmWd8+mPnQWFbNbTyml/6umRNonIfDaBSFqr3uHV1YPRIJxcpKZNj7xjtIGg6hCX3vH8DYymLPXBxt6bNW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PlZWJfmV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PlZWJfmV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DA9C4CEE3;
	Sun,  9 Mar 2025 23:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741563115;
	bh=HoHqYTigoX1mE1j9hShhjHrbCM3WSAnJU2/9V00bmqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PlZWJfmVLmA8475InCx/qe87eeTsIuHm5MPQ83N4ARxIs6vYHOM4Rv1BFmxkyrhtK
	 IRbp6w3eXjdQWXLT8pNWB/Yh0VNJPW6VCjTfIeVHqqmU1Oj8J3en83RD75DUDbj+rn
	 M4WKTrys38oIASu5U34X7lFsvtF6QfsxdEO2I1ZAMEi2/1hYSUz7mIh4MLq/MoKyRL
	 tdH1Y+biQhxxrKJaiv8PV6zfGYmnili/3sSG6lgMd9Lu1iv7NXytAAPX1/txkbTZoI
	 9rr2w7YYRLqS5Ish9bt8padEg2jiXLNrZpNXsLsvmOifIMZ9ONZeHm9LDA5CA0qShz
	 3mF7B04uoZhcw==
Message-ID: <456dd8d9-229f-4ba7-b131-233cacd0ae9b@kernel.org>
Date: Mon, 10 Mar 2025 08:31:53 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] blk-zoned: clean up zone settings for devices without
 zwplugs
To: Benjamin Marzinski <bmarzins@redhat.com>,
 Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250309222904.449803-1-bmarzins@redhat.com>
 <20250309222904.449803-6-bmarzins@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250309222904.449803-6-bmarzins@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/10/25 07:29, Benjamin Marzinski wrote:
> Previously disk_free_zone_resources() would only clean up zoned settings
> on a disk if the disk had write plugs allocated. Make it clean up zoned
> settings on any disk, so disks that don't allocate write plugs can use
> it as well.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks OK to me, but as commented in the cover letter, if we do not allow
swtiching tables for a zoned device, then I do not think this patch is needed.

-- 
Damien Le Moal
Western Digital Research
