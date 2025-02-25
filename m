Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A641885B8
	for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 10:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740480257; cv=none; b=jB/ACKCr41XdY06jJ7ctf8M6xALDUp6XnI28c7tY8MDvaVkMVXGB1hb7vX/fiJXVrWCC6cCVqgO3CHrjw/w9Aj0vQlhMffj2QQ5zab1A2A50tybRW9zGDXDADBdILBQTyiz4/9u71/tAdRrtvLCDWWQ09mSysPvW1Epl0YjIdb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740480257; c=relaxed/simple;
	bh=+YCvgfJY8kmdCGckU3ZYn9jaBRDU4SyDgXCEvstDpWo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:In-Reply-To:
	 Content-Type:References; b=M9hO+k+iAPZ7eWCuawDbkokfrms6C20+Snep3DwOcLFQNf4j1SiqDUgbfO8qzsqC9utEkifIn52wu8ip0jB7fOwPMe9ZojIUwyrL40aPmI3ey9BmSwuDGDTtx/gRulzkfZ9XXGv3VVDxRzBUBMX2Vn7zlwXYEUONZyPNn5pEFlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qWZu7bA3; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qWZu7bA3"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250225104412epoutp03cecc3b0d31a5fdae1e046cc26c48376e~nbZGOP8-90515405154epoutp03F
	for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 10:44:12 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250225104412epoutp03cecc3b0d31a5fdae1e046cc26c48376e~nbZGOP8-90515405154epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740480252;
	bh=RSnoOOU6uHj4f6zITlTwry2XlgyGNMAfQvzi7dVo7o0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qWZu7bA3sESQMI5HQx3HILT2CU6gSDYgsQ6ndxxm2SkMWgPp379YZSObOAdL/Kj3e
	 BOIQWXwMtk+qsqUEJnl8u3dcEuqVlvFh7FLTIytQJGayhVhKkDxIbDZimiIcA8nG4X
	 TeZNfYs9ERc/1tBEoHr74BgURaiktTSKuyyIpkVw=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250225104412epcas5p1f4ab699d4c248d3d4bf273a57039ca77~nbZGC7F3I1439714397epcas5p1l;
	Tue, 25 Feb 2025 10:44:12 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Z2Dk32SJsz4x9Q2; Tue, 25 Feb
	2025 10:44:11 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9B.17.19956.BFE9DB76; Tue, 25 Feb 2025 19:44:11 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250225104411epcas5p2ffaf2c1ed42c9df33ce1188d205bf8fc~nbZEgnNY11012510125epcas5p2o;
	Tue, 25 Feb 2025 10:44:11 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250225104411epsmtrp1ed34d150aef35e25a6a1466a94882170~nbZEgApoj2829528295epsmtrp1a;
	Tue, 25 Feb 2025 10:44:11 +0000 (GMT)
X-AuditID: b6c32a4b-fe9f470000004df4-ca-67bd9efbe13d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	05.98.23488.AFE9DB76; Tue, 25 Feb 2025 19:44:10 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250225104405epsmtip1094d4f1c2bd87a459a9a52020f9e4ec6~nbY-Si5eP1574915749epsmtip1g;
	Tue, 25 Feb 2025 10:44:04 +0000 (GMT)
Message-ID: <f6949dd3-220a-4ae8-93aa-d2dd90a3abbd@samsung.com>
Date: Tue, 25 Feb 2025 16:14:03 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: sysfs integrity fields use
From: Kanchan Joshi <joshi.k@samsung.com>
To: Milan Broz <gmazyland@gmail.com>, linux-block
	<linux-block@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig
	<hch@infradead.org>, "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Content-Language: en-US
In-Reply-To: <823d3261-671d-41cb-ab15-10a361c48bca@samsung.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdlhTQ/f3vL3pBmsmC1ksWDSXxeLY/lns
	FqcnLGKy2HtL22L58X9MDqweO2fdZffYvELL48XmmYweH5/eYvH4vEkugDUq2yYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLWSQlliTilQKCCxuFhJ
	386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj0dLHrAUTWSrW
	TL7C0sC4jrmLkZNDQsBE4uG9HywgtpDAbkaJ190qXYxcQPYnRokj53+yQzjfGCUaJ55kgel4
	s2ANK0RiL6PErcbJUM5bRomzm3ewgVTxCthJTL34EcxmEVCVODrhCxNEXFDi5MwnYJNEBeQl
	7t+awQ5iCwuoSzzY+oCxi5GDg01AU+LC5FKQsIhAoETjzjtgVzALTGWUWPL9CNgcZgFxiVtP
	5oPZnAL2En0377BDxOUlmrfOZgZpkBD4yS6xa3YrE8TZLhKtG36zQtjCEq+Ob2GHsKUkXva3
	QdnZEg8ePYB6s0Zix+Y+qHp7iYY/N1hBjmMGOm79Ln2IXXwSvb+fMIGEJQR4JTrahCCqFSXu
	TXoK1Sku8XDGEijbQ+L6mdNMkKA+yijxYwrjBEaFWUihMgvJZ7OQfDMLYfECRpZVjJKpBcW5
	6anFpgXGeanl8PhOzs/dxAhOmFreOxgfPfigd4iRiYPxEKMEB7OSCC9n5p50Id6UxMqq1KL8
	+KLSnNTiQ4ymwOiZyCwlmpwPTNl5JfGGJpYGJmZmZiaWxmaGSuK8zTtb0oUE0hNLUrNTUwtS
	i2D6mDg4pRqYttpJSm5Uar/mX/7QySNJ//x10S0GfffurV1WseVJ+xbzfzNY5HZJftrhUqM/
	/5NNI9ebF1U8gtybfjpsPF2k5KymMm/N3U0LFY0z7vf+qFUPsFleXJn5pe2m2nd1ow1qWdyJ
	gaqTXua2b3m/3Vvmy6qe5RGOHZnzHs9TuXdpm6flf4O4xgjlxcubL2Yc2JRmfPcr27omddn5
	bRUX8o4W1u2wlDZcP+OfumvKAb+3V57yLJtqyLP6UFzYiuMXWeadmGHiWig/aY3IwYZzoUyy
	U65WrEh5lnx/w+KiWHHJrRn/smW/B+0qy1AV+5z/7/XdNZ4Lt/tOepCqaTa7hlVWW32ugqIu
	j0j4kWTRIm5fJZbijERDLeai4kQAAhi6UCEEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsWy7bCSnO7veXvTDZ4mWixYNJfF4tj+WewW
	pycsYrLYe0vbYvnxf0wOrB47Z91l99i8QsvjxeaZjB4fn95i8fi8SS6ANYrLJiU1J7MstUjf
	LoErY9HSx6wFE1kq1ky+wtLAuI65i5GTQ0LAROLNgjWsXYxcHEICuxklNh1bxgqREJdovvaD
	HcIWllj57zk7RNFrRolJD+aDdfMK2ElMvfiRDcRmEVCVODrhCxNEXFDi5MwnLCC2qIC8xP1b
	M8AGCQuoSzzY+oCxi5GDg01AU+LC5FKQsIhAoMS/ufPB5jMLTGeU2H9tFRvEsqNAzoH3YIOY
	gS669WQ+2AJOAXuJvpt32CHiZhJdW7sYIWx5ieats5knMArNQnLHLCTts5C0zELSsoCRZRWj
	ZGpBcW56brJhgWFearlecWJucWleul5yfu4mRnB8aGnsYHz3rUn/ECMTB+MhRgkOZiURXs7M
	PelCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeVcaRqQLCaQnlqRmp6YWpBbBZJk4OKUamJQ+2BZ1
	t+T/2rVMWarMZ4bEm5ym6dzFi5+/2FOxWsHcPGOe9HtBlQ1ns/Yd5++3FhB2XcB9+oOi99q8
	S42rp8hxeOsclzxt6xmylTOyvlLmNpvEu287P5Yc+Rm3VSyjgvfqlhivH84RT/p+hUw7GM7m
	X3+f4b0C4yYhVpf0P2d4Si9FTIhnfyU4b7XAehXrLtFIz9m3j0Tqdtznq0k7envTifbcTBWl
	SxXd96UXcjJLPZifwzb/eIyh/YWFqQllG1oa0zk15LIXHNAUP7DE83ff31MxhzeeuHH3d+Od
	IwUL59xlXlLPtOIwe6Jl0t+Ena2tS1xDuNYX5s+Illg2Y470uxdBMh0bXt/RkWcTUGIpzkg0
	1GIuKk4EAHKXfur+AgAA
X-CMS-MailID: 20250225104411epcas5p2ffaf2c1ed42c9df33ce1188d205bf8fc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250225092525epcas5p31dd0a19ffdfb39f3f2ce4acd1c6da7ee
References: <CGME20250225092525epcas5p31dd0a19ffdfb39f3f2ce4acd1c6da7ee@epcas5p3.samsung.com>
	<67795955-93a4-405b-b0b7-e6b5d921f35e@gmail.com>
	<823d3261-671d-41cb-ab15-10a361c48bca@samsung.com>

On 2/25/2025 3:40 PM, Kanchan Joshi wrote:
>>     According to docs, this is "Number of bytes of integrity tag space
>>     available per 512 bytes of data."
>>     (I think 512 bytes is incorrect; it should be sector size, or perhaps
>>      value in protection_interval_bytes, though.)
>>
>> Then we have new (undocumented) value for NVMe in
>> -/sys/block/<nvme>/integrity/metadata_bytes
>>     This contains the correct 64.
> Maybe you mean "/sys/block/>/metadata_bytes"?

/sys/block/<nvme>/metadata_bytes.
