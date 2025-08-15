Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603812F9C34;
	Fri, 15 Aug 2025 17:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755278415; cv=none; b=DsL9/0YRmzz+E3+lqQIpRGZcbe84DewUB5XkC9PJVNqPUBlOPkVr6nfp4+wZ+VMv1leoa/JMOLDw8W1P6oy7472KFC0oxtNlHWIAyOK8OzDjIfcZDavh3iC9AJlApgjI3KMLKH7zWUPWVpMjicHLRLumhKDd1TqAu48u5WudA24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755278415; c=relaxed/simple;
	bh=SUiiRJ3yGxoPXaH8M9+QdGkFHbB1hKcd3L5XOGPaRZs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=riM4ShgymNlBkS3uUJcCO4E+pspHQ0tFA+Am/JjEBVMO19O5MDMXRMA+gDRs3LxdEjxDvX8uBTL+H/CALCVuO1Ut6EsxNHIz01QBbsk+FqO7w2keTP18R9duZLyuxcxPoXeKEUqzjiyjFUazhb89KGwczo3JwgjH2lZoEdaPyRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=V8uHfd0g; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="V8uHfd0g"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=3MCf5e3TI9cJ7IsBDtDWvT98184OzmB18hpxzAlH6qg=; b=V8uHfd0gfbvQ6jKOkxOoO1tyld
	jCM8kisINijPGiH2Q+s4+emo0250pJLnRFpxWQ8foiaJgRb+9IjrjIssFRRaG2ydTvH+e4XtnEaN1
	wFajiuoOOTQ6jp64gNTaGL62DF0EII7qtkz6yi8k+r/aoQvqXuIrRyiuOvuSkE5T7tWD+6oPpilZL
	kJgMmbbZ+06A6SzUR544IzoCNcjv7QEuKuaY8P5NpwO3R2ddLPEjvOplbJJDoHOCrIiHw++WlIU+q
	GQnPUyInMaGff5jz6MHX5SVv5Om8YhkMU0lREJeVkM3G+3BIBWCcDcDgHO9I1c+apudNP8p82/3HG
	6tcVmf3w==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1umy68-000000036Uf-45oy;
	Fri, 15 Aug 2025 17:20:13 +0000
Message-ID: <d4a6bf68-3348-49b7-a9fc-d84c8e416b4f@infradead.org>
Date: Fri, 15 Aug 2025 10:20:11 -0700
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Documentation fixes for dm-pcache
To: Bagas Sanjaya <bagasdotme@gmail.com>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Documentation <linux-doc@vger.kernel.org>,
 Linux Device Mapper <dm-devel@lists.linux.dev>
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>
References: <20250815075622.23953-2-bagasdotme@gmail.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250815075622.23953-2-bagasdotme@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/15/25 12:56 AM, Bagas Sanjaya wrote:
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
>   dm-pcache: Remove unnecessary line breaks
>   dm-pcache: Use bullet list for data_crc constructor argument
>   Documentation: device-mapper: Add dm-pcache docs to toctree index
> 
>  .../admin-guide/device-mapper/dm-pcache.rst       | 15 ++++-----------
>  Documentation/admin-guide/device-mapper/index.rst |  1 +
>  2 files changed, 5 insertions(+), 11 deletions(-)


LGTM. Thanks.

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
-- 
~Randy
