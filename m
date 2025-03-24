Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 752971A3173
	for <dm-devel@lists.linux.dev>; Mon, 24 Mar 2025 11:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742814570; cv=none; b=QycULtKd74Ox4t9gJNOOrSBow3gABP5pUT8tWnj9j9XdI36KBKgBejvVM9FkfLsyIUJbKzsGhWv+MTJSA5wBoVEQRyhzT9kiuvDEz0zwBhoh/m9WeW0mWxas05Ad9B6Zp0FJhRBXwRB5JeZWjixK5MWnpPbQkMrdkzE9YFX4kSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742814570; c=relaxed/simple;
	bh=ah3dw0xZMsr6yJFEtxeQyK3cGHYdEasDo0X3AZYn2/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GSwUt+vGwLfXTHKyYPxnvL+ZFmgItDtMjlO3IuAyj6MmMRe0EK6V9G/iwxpZXFHToBojXxAg5/Fkc8V5vj8YcLK9xgVidCgO3Nrsiyg7n9xRGGvkZ6uNxuCTql8ApTHmfCxhnhkD4SyP+xlK2ar3+nDmC572mxwLkvyaYrSu7m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=elSM82Qf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="elSM82Qf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E915C4CEDD;
	Mon, 24 Mar 2025 11:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742814569;
	bh=ah3dw0xZMsr6yJFEtxeQyK3cGHYdEasDo0X3AZYn2/8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=elSM82QftUHe1C6M3esTDeEyEouy5sN1u2cIhKqAhbgTGLK5bqjRRF5dQ1luv8RLN
	 CNrA6XgDcaronUfu8T5zvh4nXCpksgMQWefN0DDys1PHgpW8QrJxvOZdDjrxjQb0+D
	 PyMCR9NzE5DQ97uvY+l9b1pV4eZjxjwiQ2L4dHqiQCNsYpzYI9iHtOwu+XCoORYeYG
	 d7Ww9ue7o7xxa4Ad54eiRGDda+LIfB/2qPWqgz5eOsEobcfD1jLlcUMy5W6lN9VjZg
	 tnLpcMZucYY3ZV2SbgFgAHmWs0gTo/CVQYIfPK/n2tYQOfmrT26uW4zF13htgi3u/3
	 RMDTReyhy5RVw==
Message-ID: <d02b81ee-6416-469f-99e3-c5510b9c9904@kernel.org>
Date: Mon, 24 Mar 2025 07:09:28 -0400
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm-delay: support zoned devices
To: Christoph Hellwig <hch@lst.de>, snitzer@kernel.org, mpatocka@redhat.com
Cc: dm-devel@lists.linux.dev
References: <20250321071816.1674943-1-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250321071816.1674943-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025/03/21 3:18, Christoph Hellwig wrote:
> Add support for zoned device by passing through report_zoned to the
> underlying read device.
> 
> This is required to make enable xfstests xfs/311 on zoned devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
