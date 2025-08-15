Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC364DDAB
	for <dm-devel@lists.linux.dev>; Fri, 15 Aug 2025 13:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755262840; cv=none; b=tMe/wcBZ7Th8luQDxKqY1y6xopjNAE0VbZbZxHT2dCkrxABThD6W38dypOucKUhNIjhhe7IZmFYqRACS7ge+MKLKRwx/Gw1PmfyHfRbnDwClO1SXeD2N8X+2NlPY1LTO7FKmArgK0ebT/8j7MSOYyy+jnFC9vYXendkcoyCB0gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755262840; c=relaxed/simple;
	bh=wSis39yIb0n9Nkid2+KmzOkvqKCQAn8rxjFclMh78mU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ID/iqI1R6mwXhm2WYbggixxsxo02cuqnWGR5xwvajwKkU5ENMy+DnZtl6xJ3fRDq/13nLhQOkwPe9wgTPT14H7ZM5pX5OkRK8+bQjJrG+ZHfLCCiMxBz7oq2aZR2nFGO3+TamiqacoNXsZtpI1vB6D05UFf99+6cBl0zbGBG40g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g6T7z1+I; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g6T7z1+I"
Message-ID: <0b01e47c-ee81-4650-af5d-328544089391@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755262835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e6IPjYI6u0832mFiHwUFWLMB7x9Um1SBVr0ChQ/OD3k=;
	b=g6T7z1+IKl8PuWBCEU7j82Ich9w+uBUWtkisN+RXw1lpGeFs5fkD8oQmNPbxSFsF/2ucCX
	idgKMU+YR4w2VMdSesRcY912RSHgG1kggty+phpdGmBJU9bCm1B1pzfCUjz/XIYOh+fPnj
	hGOY9Bz9dXAykvcDxR9NCNXE8L2zc0g=
Date: Fri, 15 Aug 2025 21:00:29 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 0/3] Documentation fixes for dm-pcache
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux Device Mapper <dm-devel@lists.linux.dev>
Cc: Zheng Gu <cengku@gmail.com>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
References: <20250815075622.23953-2-bagasdotme@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20250815075622.23953-2-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Acked-by: Dongsheng Yang <dongsheng.yang@linux.dev>


在 8/15/2025 3:56 PM, Bagas Sanjaya 写道:
> Hi,
>
> Here are docs fixes for dm-pcache as reported in linux-next ([1], [2]).
>
> Enjoy!
>
> [1]: https://lore.kernel.org/linux-next/20250815130543.3112144e@canb.auug.org.au/
> [2]: https://lore.kernel.org/linux-next/20250815131115.45518c74@canb.auug.org.au/
>
> Bagas Sanjaya (3):
>    dm-pcache: Remove unnecessary line breaks
>    dm-pcache: Use bullet list for data_crc constructor argument
>    Documentation: device-mapper: Add dm-pcache docs to toctree index
>
>   .../admin-guide/device-mapper/dm-pcache.rst       | 15 ++++-----------
>   Documentation/admin-guide/device-mapper/index.rst |  1 +
>   2 files changed, 5 insertions(+), 11 deletions(-)
>
>
> base-commit: 6fb8fbbaf147fe4153177320ee354c457605800a
