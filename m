Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D581C6FFD
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 11:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739964857; cv=none; b=BNTJruP/pillaD5NzKS+3w8sP9QbrEbBfhpe2OPCu2sf0fVfA8rJYenDoD7NjpuTRLCMTZtdtIeHHZ5z3TYIqN4I62ZG0Hc9oT+iFtbQ0auWezIxKqLUzPLXrt1AOuqzvyMg+GqIioy02ARZSw9Rh+HwSMV5Ab5VZwxup1EnJNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739964857; c=relaxed/simple;
	bh=q3QKNAD1HbPIZobbO74e+99+Af0xmx9FbtiKI1359x4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=qWXbWl36wtMckOudpt+j0bKbHPP1LiGC3p3g5J7qaCKkwFrd8kE6RbfoFMREJ5MHsi5hQjRBukVSxlrvgR9t5ED1+vYJ6yn9cxzRZwkPIHjZnYWiYwB0HnLby+Xo/a5xRM8wpItJnqt+rQB3IgnyK1lshcueuUdJay48uYxnMfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bQZ7Ub1j; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bQZ7Ub1j"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250219113406epoutp044dec8c88e44cde9be1c4681413d243b5~lmM8yDVPp2697526975epoutp04U
	for <dm-devel@lists.linux.dev>; Wed, 19 Feb 2025 11:34:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250219113406epoutp044dec8c88e44cde9be1c4681413d243b5~lmM8yDVPp2697526975epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1739964846;
	bh=PqKn35gzT2r3v5tfRxbCbfThiaGkSqsVYoyLWVULZOY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=bQZ7Ub1jSTGq154ckB8C7e1pXJ9gsB4Etq9myUNocZmU7bSrmM9lPQX6q1Qm/juiK
	 5V9Bu8+Q/pEXxeyTYYufmYnDFI1Oqx+dWaap+tiX7iFyLJ+psRpp0KKz/aiWvW/97y
	 qEpbL82+w47CsYvvokdKNaoQZD76vb0j37P17ULg=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20250219113405epcas5p30367f78dc4aeb2935edd2743124675a4~lmM8Ea5Hu1304413044epcas5p3v;
	Wed, 19 Feb 2025 11:34:05 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.178]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4YyZ6N0JPRz4x9Q2; Wed, 19 Feb
	2025 11:34:04 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	EA.AC.20052.9A1C5B76; Wed, 19 Feb 2025 20:34:01 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250219113400epcas5p394cd7569eadc76acfa4a7e10f0b93109~lmM3KSst11304413044epcas5p3j;
	Wed, 19 Feb 2025 11:34:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250219113400epsmtrp1e77fa577e43aa500ed817eb728b376fe~lmM3I4ZCj3182931829epsmtrp1k;
	Wed, 19 Feb 2025 11:34:00 +0000 (GMT)
X-AuditID: b6c32a49-3d20270000004e54-2a-67b5c1a9d0b7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2A.4F.18729.8A1C5B76; Wed, 19 Feb 2025 20:34:00 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250219113359epsmtip2d080602954c02a311242f790a6c46f66~lmM1my5hY1503015030epsmtip2P;
	Wed, 19 Feb 2025 11:33:58 +0000 (GMT)
Message-ID: <12365e80-90c2-4f85-9b74-1df0173ad6ec@samsung.com>
Date: Wed, 19 Feb 2025 17:03:58 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] block: move the block layer auto-integrity code
 into a new file
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka
	<mpatocka@redhat.com>, Song Liu <song@kernel.org>, Yu Kuai
	<yukuai3@huawei.com>, "Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, target-devel@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20250218182207.3982214-3-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBJsWRmVeSWpSXmKPExsWy7bCmuu7Kg1vTDV6cY7FYfbefzWLBorks
	FitXH2Wy2HtL26J9/i5Gi+XH/zFZTOy4ymRx4pa0xfHlf9ksWpe+ZbKYs5DNgduj5chbVo/L
	Z0s9Nq3qZPN4sXkmo8fumw1sHh+f3mLxeL/vKpvH501yARxR2TYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QFcqKZQl5pQChQISi4uV9O1sivJLS1IV
	MvKLS2yVUgtScgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7Iz+o6eYC5o5Kg4+W0+cwPjfrYu
	Rk4OCQETiYOPTzJ2MXJxCAnsZpS4PXESK0hCSOATo8TLXnaIxDdGiaP7XjLCdFze8o8FIrGX
	UaK1eSMzhPOWUeJW7zugDAcHr4CdxMLliSANLAKqEode3GAHsXkFBCVOznzCAmKLCshL3L81
	AywuLBAlMfthI5gtIuAgMXvDUjaQmcwCm5gkvreuYAJJMAuIS9x6Mp8JZD6bgKbEhcmlIGFO
	ASOJjYeOQ5XIS2x/OwfsHgmBAxwSbQ0trBBXu0hsfr2FHcIWlnh1HMaWknjZ3wZlZ0s8ePSA
	BcKukdixuQ+q116i4c8NVpC9zEB71+/Sh9jFJ9H7+wnYORICvBIdbUIQ1YoS9yY9heoUl3g4
	YwkrRImHxMuHTJCQWssosf78E9YJjAqzkEJlFpInZyH5ZhbC4gWMLKsYJVMLinPTU4tNCwzz
	Usvh0Z2cn7uJEZyEtTx3MN598EHvECMTB+MhRgkOZiUR3rb6LelCvCmJlVWpRfnxRaU5qcWH
	GE2B0TORWUo0OR+YB/JK4g1NLA1MzMzMTCyNzQyVxHmbd7akCwmkJ5akZqemFqQWwfQxcXBK
	NTAVSa6LCFZ8wqEwT11zg+MDrh+9hbtObDOsNRQ5uvmdk03TN7mS53en1+yvF5z1Y0utV+n1
	M2sM69U52UXKY63SvTMK3M4+bNKbLR647LfVRK/JstY6D4sqmO+UsgpNbH/Bmv+Z6zn/I516
	n32x9hm8Z9TNE3KXFWY/fZFis+i5fI1tzIfql8J+cs9fs7DM/ffm9tnVspf3nOa52nd94Vq9
	1bbXCn7Pnh8qnr2wrsCeaY1giNmjADXnw5W912OFl+vpNktrHt9Q3VcdlLBy+ae58rJ8E5LW
	dF01T2I7uSrt8FHlrPOnojlWe2za5S/IvSDrZ9ve31k/TusueXy93z3SXOqZfuqaI7tj5hwV
	s1BiKc5INNRiLipOBADgpvZjSwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsWy7bCSvO6Kg1vTDbZOVrVYfbefzWLBorks
	FitXH2Wy2HtL26J9/i5Gi+XH/zFZTOy4ymRx4pa0xfHlf9ksWpe+ZbKYs5DNgduj5chbVo/L
	Z0s9Nq3qZPN4sXkmo8fumw1sHh+f3mLxeL/vKpvH501yARxRXDYpqTmZZalF+nYJXBl9R08w
	FzRyVJz8Np+5gXE/WxcjJ4eEgInE5S3/WLoYuTiEBHYzSpxecoMVIiEu0XztBzuELSyx8t9z
	doii14wSt1dvASri4OAVsJNYuDwRpIZFQFXi0IsbYPW8AoISJ2c+YQGxRQXkJe7fmsEOUi4s
	ECXx/J4dSFhEwEFi9oalbCAjmQU2MUns2L8cav5aRom+FZfAjmAGOuLWk/lMIM1sApoSFyaX
	goQ5BYwkNh46zgRRYibRtbWLEcKWl9j+dg7zBEahWUjOmIVk0iwkLbOQtCxgZFnFKJlaUJyb
	nltsWGCYl1quV5yYW1yal66XnJ+7iREcc1qaOxi3r/qgd4iRiYPxEKMEB7OSCG9b/ZZ0Id6U
	xMqq1KL8+KLSnNTiQ4zSHCxK4rziL3pThATSE0tSs1NTC1KLYLJMHJxSDUz+1bsTmNJ6FGfa
	vN0c9+yb65OO2r4H7idCZUOr9cU2agdH/txkvzC5x7+pTTlw6/3zUVXNT34tzpdZ7rvk7YJC
	Sf2j3ebvs6TOTJDNf9w9/d76H+c3ySiu+NVTM8nWsEr/appj/rJVOaan1WdfVP4nfPbkFQ3L
	NUbGuW0/n2ippN2J0T+SFeprI6jnee3y1X4Gdw5dx5knRX5dmy5y6F8bz47amT4+rxliHXdt
	O8j45niEULZLbqDx9OcX1+24L/giJuKLyNb/n9sef1UTzYhQ+by94sj8EqkJThXH407pcOwv
	Znpn+5RJWT1sXzVfiMTcUMWdP3aq1G1bm6he/bhFcEHqJIsrrnErFzO2WyuxFGckGmoxFxUn
	AgB/6vkSKAMAAA==
X-CMS-MailID: 20250219113400epcas5p394cd7569eadc76acfa4a7e10f0b93109
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250218182222epcas5p2aef15a84f37fab0c69af5d53dfeed240
References: <20250218182207.3982214-1-hch@lst.de>
	<CGME20250218182222epcas5p2aef15a84f37fab0c69af5d53dfeed240@epcas5p2.samsung.com>
	<20250218182207.3982214-3-hch@lst.de>

On 2/18/2025 11:51 PM, Christoph Hellwig wrote:
> The code that automatically creates a integrity payload and generates /
> verifies the checksums for bios that don't have submitter-provided
> integrity payload currently sits right in the middle of the block
> integrity metadata infrastruture.

nit: s/infrastruture/infrastructure.

> +static int __init blk_integrity_default_init(void)
> +{
> +	/*
> +	 * kintegrityd won't block much but may burn a lot of CPU cycles.
> +	 * Make it highpri CPU intensive wq with max concurrency of 1.
> +	 */
> +	kintegrityd_wq = alloc_workqueue("kintegrityd", WQ_MEM_RECLAIM |
> +					 WQ_HIGHPRI | WQ_CPU_INTENSIVE, 1);
> +	if (!kintegrityd_wq)
> +		panic("Failed to create kintegrityd\n");
> +	return 0;
> +}
> +subsys_initcall(blk_integrity_default_init);

Now that you are using the term auto (in place of default), maybe this 
should also be renamed to blk_integrity_auto_init.

Looks good otherwise.
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>



