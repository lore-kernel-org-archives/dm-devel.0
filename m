Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6A41D8DE1
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 11:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739964889; cv=none; b=t9nZnt8ExhMJcEqr7TLV90Nrn8Onp647y7+01bXPlp9UKN4NuguaAVwyOQ40uQXp3CV0uymsv0i4PGMyfO7HsAFyIDp1l9q1HRazMEQ4b59okLoBQnfmQ85MAfWeMZ3uPuZ935KezHL2w3fqFmW2MvjBayaGje0dFGFKxR5FEg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739964889; c=relaxed/simple;
	bh=atq6Pu3VmSN8V1TtYuU5IFio1ZAWTUJ6Kh4eRB/77Vc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=UESbyESpJhlbC3yfxyUtJdbIKuXMABg3FB81+MXDmQjoMcFbllhd5ZKoZJBWgJQ0fsDhrKDE8zRRmMYlzC6u5ohWatXIAcKKyBuyBAmyoVAoIIwsYttcZz0ipFDGNuy7zn7FVsBrsZdvKlu8kBLbAnNu5pFno7WYE1ck3Xg8qvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=en22y91V; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="en22y91V"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250219113445epoutp0304c3d52e85c602c778d962f8506f71cf~lmNhKK9mM2835728357epoutp03s
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 11:34:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250219113445epoutp0304c3d52e85c602c778d962f8506f71cf~lmNhKK9mM2835728357epoutp03s
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739964885;
	bh=jwNHhrc1AfEiAb6CfqYbzTGi3Z6uacM31m3mp1/sNpg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=en22y91VBfEHieRFCgFdcesS4pokbX/0k4qHIengDUwB50PlUYqtsey3CBk/gux5i
	 /mQMGAY7TEGVT3f9WB7kyFWYldHKNRT9fkkWvlWbfAB4we1+MnRrBUQ07WGz/Mhh6A
	 suRC4Ya148CXVunWhzWAJmJRRxoivfDEA/DsxZq0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250219113445epcas5p11312275f4c4bde61cd23e06884c8810f~lmNgy_C3m1895018950epcas5p1Q;
	Wed, 19 Feb 2025 11:34:45 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4YyZ772dSSz4x9Q0; Wed, 19 Feb
	2025 11:34:43 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F5.19.29212.3D1C5B76; Wed, 19 Feb 2025 20:34:43 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250219113443epcas5p24cac6deafccb8ab2c57db303a210c63f~lmNelRYhl3021030210epcas5p2E;
	Wed, 19 Feb 2025 11:34:43 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250219113442epsmtrp29464c6861e4e1cce592f111e46f0e91e~lmNekltbG1970019700epsmtrp2B;
	Wed, 19 Feb 2025 11:34:42 +0000 (GMT)
X-AuditID: b6c32a50-801fa7000000721c-31-67b5c1d38ee5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DB.56.18949.2D1C5B76; Wed, 19 Feb 2025 20:34:42 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250219113441epsmtip27b6b238127c5172151328483d649ca14~lmNc7j6R81617716177epsmtip2T;
	Wed, 19 Feb 2025 11:34:41 +0000 (GMT)
Message-ID: <3161bd56-71ee-4f7e-a988-de51caedb567@samsung.com>
Date: Wed, 19 Feb 2025 17:04:40 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] block: split struct bio_integrity_data
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka
	<mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai
	<yukuai3@huawei.com>, "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20250218182207.3982214-4-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFJsWRmVeSWpSXmKPExsWy7bCmlu7lg1vTDQ7e4LNYfbefzWLBorks
	FitXH2Wy2HtL26J9/i5Gi+XH/zFZTOy4ymRx4pa0xfHlf9ksWpe+ZbKYs5DNgduj5chbVo/L
	Z0s9Nq3qZPN4sXkmo8fumw1sHh+f3mLxeL/vKpvH501yARxR2TYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFcqKZQl5pQChQISi4uV9O1sivJLS1IV
	MvKLS2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7IzdjXOZCu4yFZx/c1stgbGpaxd
	jJwcEgImElM6vzJ3MXJxCAnsYZT4fvckO4TziVFi/5GJbBDON0aJG5N+M8K0HHs5iwUisZdR
	4smaTVBVbxklNuydxAxSxStgJ/H52X2wDhYBVYk3v9vYIeKCEidnPmEBsUUF5CXu35oBFhcW
	sJdofrkArFdEwEFi9oalYEOZBTYxSXxvXcEEkmAWEJe49WQ+kM3BwSagKXFhcilImFPASOL5
	40aoEnmJ7W/ngD0kIbCHQ2J660NmkHoJAReJHV2WEB8IS7w6voUdwpaS+PxuLxuEnS3x4NED
	Fgi7RmLH5j5oINlLNPy5wQoyhhlo7fpd+hCr+CR6fz9hgpjOK9HRJgRRrShxb9JTqE5xiYcz
	lkDZHhJvj10Au1JIYC2jxM7jzBMYFWYhBcosJD/OQvLMLITFCxhZVjFKpRYU56anJpsWGOrm
	pZbDIzw5P3cTIzgRawXsYFy94a/eIUYmDsZDjBIczEoivG31W9KFeFMSK6tSi/Lji0pzUosP
	MZoCo2cis5Rocj4wF+SVxBuaWBqYmJmZmVgamxkqifM272xJFxJITyxJzU5NLUgtgulj4uCU
	amDqkZ5yWWHT0j91e+uOvQzQT7JZqvyx9MwBM/FVlzcrb9Ez5MiSdmx6wzLBoj15W/BEg09/
	jhzUP/+a5e/hyH0x3S/2Gcj33XEuXrrG9NYsk74V7KtnXxDcqv12R6ytWbmL/vM7XPt8mrjf
	Pbp7fbFsgrRCmQ/fyxvOxif9pJTXugc7VvwW35z8h/1Jc9O+74Wq+SXMX/bMmXtuD29ue771
	G6aCz/zHfj6Piwi7cCPetS67ZGnklStsU4OFVZzbC4Sn3X3dJ/hmd/vhqw9S1hjLbw/+3JPO
	fL37lrD7y60/jIQ/S1n0Hvjfxnlld164sO3aWW23LzEHWLMqnE9Izr8Zc6ckL9ar4/6/paWq
	ClJKLMUZiYZazEXFiQB7iG0mTQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsWy7bCSvO6lg1vTDfpOGlusvtvPZrFg0VwW
	i5WrjzJZ7L2lbdE+fxejxfLj/5gsJnZcZbI4cUva4vjyv2wWrUvfMlnMWcjmwO3RcuQtq8fl
	s6Uem1Z1snm82DyT0WP3zQY2j49Pb7F4vN93lc3j8ya5AI4oLpuU1JzMstQifbsEroxdjTPZ
	Ci6yVVx/M5utgXEpaxcjJ4eEgInEsZezWEBsIYHdjBKXzypCxMUlmq/9YIewhSVW/nsOZHMB
	1bxmlDj3ogesmVfATuLzs/uMIDaLgKrEm99t7BBxQYmTM5+ADRUVkJe4f2sGWFxYwF6i+eUC
	ZhBbRMBBYvaGpWwgQ5kFNjFJ7Ni/HGrDWkaJFY03wTqYgc649WQ+UxcjBwebgKbEhcmlIGFO
	ASOJ548bmSBKzCS6tnYxQtjyEtvfzmGewCg0C8kds5BMmoWkZRaSlgWMLKsYJVMLinPTc4sN
	C4zyUsv1ihNzi0vz0vWS83M3MYKjTktrB+OeVR/0DjEycTAeYpTgYFYS4W2r35IuxJuSWFmV
	WpQfX1Sak1p8iFGag0VJnPfb694UIYH0xJLU7NTUgtQimCwTB6dUA1NTzOrK/ovPLgsciDzv
	HPDyXcTBGVpsUxwbDi8WZNKu0OdayRuavj7K+VovW6+L7PUpbRHfOk4LPto4+YK862z93mXB
	6t0Md9b7POjXO7Dhbaus5+/j5z7EX3+Qt3Xx5Z9BYTLTXorO+LtK6GtKhNPXs3OfWZaYH9l4
	6HfWxpW3C8/Ur+vpO8A18YTYxymfdOQyvnYGyLbNc7n0eiX3afFXK/++S7/0JknCVXCDWv6D
	k+XAVHUmnjMjQDdOa785n6wVX7aNReDxg3WXeNtredytzym3ak5+fj3skGPZ7UjtiSwv92hW
	7D37LOt2Y1bENb//UrM/OqyZYhPG0zHNZ2Lp/PUz6k2Eoso2GH8KcVViKc5INNRiLipOBABN
	3CFWKQMAAA==
X-CMS-MailID: 20250219113443epcas5p24cac6deafccb8ab2c57db303a210c63f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250218182226epcas5p1220b8916a79937e8bcea46a993647694
References: <20250218182207.3982214-1-hch@lst.de>
	<CGME20250218182226epcas5p1220b8916a79937e8bcea46a993647694@epcas5p1.samsung.com>
	<20250218182207.3982214-4-hch@lst.de>

On 2/18/2025 11:51 PM, Christoph Hellwig wrote:
> Many of the fields in struct bio_integrity_data

Patch title and this should say - struct bio_integrity_payload.

  are only needed for
> the default integrity buffer in the block layer, and the variable
> sized array at the end of the structure makes it very hard to embed
> into caller allocated structures.
> 
> Reduce struct bio_integrity_data to the minimal structure needed in
> common code,

Same here. Seems bio_integrity_data is not meant to be used in common code.

  and create containing structures for the payload + bvec
> allocation for submitter provided buffers, and the default integrity
> code.  Stop using mempools for the submitter buffers as they don't sit
> below the I/O stack,

Maybe it's just me, but I am yet to parse sitting below the I/O stack part.
