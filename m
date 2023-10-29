Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4152C1427C
	for <dm-devel@lists.linux.dev>; Sun, 29 Oct 2023 23:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjRhtPH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021D8C433C8;
	Sun, 29 Oct 2023 23:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698623737;
	bh=TZsviLLaoKnlyH5Qc4n8u9kzBHBomynHp0GiW0FgBLI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HjRhtPH8dz72cQLs2/InRIDzAoE+v/y+BvcOfQfyg55ETfWLhPqYHIvvP15kyFir5
	 PhjN2yBpo0z6nSLiT0ufwi3F3P9pT951Jvj+OzjsSPgS6gMuWpU4SqiY+CRX/gixuP
	 eNG55caoB3x+H/xT6SLKSu3jua8OcJxmrNzELiT02qIb0mHe22Ovyy/tl7RVUP7A7N
	 9+mlVjkAfHi5GYK3axOOaF/TvVoDmfAcEHup8C0uS/kXvX5XYyqqF/HZvcAB15zJEU
	 Qo1bY76V0Hrmfow3v534GGHlAgZePC9+eIQul4MI9y74IqdWwXLeIlvJtpz89p7I+Z
	 TZmQiwWWcKRgQ==
Message-ID: <b86508ed-8fc3-4236-a19f-e804657ee849@kernel.org>
Date: Mon, 30 Oct 2023 08:55:35 +0900
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] dm: error: Add support for zoned block devices
Content-Language: en-US
To: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@lists.linux.dev, Christoph Hellwig <hch@lst.de>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Naohiro Aota <naohiro.aota@wdc.com>
References: <20231026051205.95209-1-dlemoal@kernel.org>
 <ZTwKkV9aphjYBfIj@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZTwKkV9aphjYBfIj@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/28/23 04:08, Mike Snitzer wrote:
> I've picked this up.  But fixed various typos and such in the commit header.
> 
> Also some typos in code comments and bumped the target version to 1.7.
> 
> Please see: https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-6.7&id=c85b4fb8b8edbd915283f6ab3537f2c3b95e7c85

Looks good. Thanks !


-- 
Damien Le Moal
Western Digital Research

