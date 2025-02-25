Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CA126139E
	for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 10:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740478255; cv=none; b=Lwman80OEyhSVGzFXtiOLepS/u7WGWLW4CDFh4AgeuMw0FW2q3cZSCz+PmXF/ETu/Z2n0GgTtcNgjzIZlml8TxqGP3hG0fbJKfQ64m3L5RYo1CUpHqYyNnMw8qjRPsFiYmCk85lUn3lb5UK0th98Cb0hDb3TAhzps7GGMfx+8eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740478255; c=relaxed/simple;
	bh=GWzqqlCT06eb9B7i/eIKfXdoQykhCIJFjgICCdBuTMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=L6r/X5HMnCQvZLxkiB7B105I3UYQ8FlGRjDJqn1ACeBa5pHwLyfWNFVWleQSjyoBGeKjnYF2nPv7wlbYbZujhHWDM7juZjtKSpLvEYqLM43EyaSEU/7bMaEAQs2NBLseNwpdwBvz3TJfpDJ1bWnNMzufyKrmsC8hNNMb3LbuwE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=N1rvkqIr; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N1rvkqIr"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250225101050epoutp01e3e85365294aa2afcaafe280031196d2~na79rbzzG3028730287epoutp01X
	for <dm-devel@lists.linux.dev>; Tue, 25 Feb 2025 10:10:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250225101050epoutp01e3e85365294aa2afcaafe280031196d2~na79rbzzG3028730287epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740478250;
	bh=aC0FsBJLXuOLnCiKDY4IxA4Aven5YhSy4at6GHW93LY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=N1rvkqIrZrebO3YozweP8ejoTAjne4QEidBrPk5e/s+fdXtpMmaLmZHSwVrGAv3SD
	 kHc6AC3xvfLFlPKAcg2XAyNhYFgf9i92YYrOy6rl5ivKC5NTvuDYri78425y2DQKzL
	 7C6jvZlkN+x4701yt5vTSjQYzpCx80nG7XdzCFXA=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20250225101050epcas5p13f53bcc551b251bf57c43fd66930c950~na79cjH9s0830908309epcas5p1P;
	Tue, 25 Feb 2025 10:10:50 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Z2CzY2d1Vz4x9Pw; Tue, 25 Feb
	2025 10:10:49 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	63.62.29212.5279DB76; Tue, 25 Feb 2025 19:10:45 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250225101044epcas5p46cd487380822a642877d0a23401f9eb7~na74I4jam0557605576epcas5p4L;
	Tue, 25 Feb 2025 10:10:44 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250225101044epsmtrp1f2e4b3050b8cc08fd2b7478f99717698~na74ISMOw0899108991epsmtrp1c;
	Tue, 25 Feb 2025 10:10:44 +0000 (GMT)
X-AuditID: b6c32a50-7ebff7000000721c-f8-67bd9725c0df
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	08.DB.18949.4279DB76; Tue, 25 Feb 2025 19:10:44 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250225101038epsmtip17be557f4958ff6fe9b2d72a09dc2a5a6~na7ybcuzP2752027520epsmtip1g;
	Tue, 25 Feb 2025 10:10:37 +0000 (GMT)
Message-ID: <823d3261-671d-41cb-ab15-10a361c48bca@samsung.com>
Date: Tue, 25 Feb 2025 15:40:34 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: sysfs integrity fields use
To: Milan Broz <gmazyland@gmail.com>, linux-block
	<linux-block@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig
	<hch@infradead.org>, "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <67795955-93a4-405b-b0b7-e6b5d921f35e@gmail.com>
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAJsWRmVeSWpSXmKPExsWy7bCmuq7q9L3pBlfncFosWDSXxeLY/lns
	FqcnLGKy2HtL22L58X9MDqweO2fdZffYvELL48XmmYweH5/eYvH4vEkugDUq2yYjNTEltUgh
	NS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaLWSQlliTilQKCCxuFhJ
	386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj7epOtoJVXBXv
	DjUxNTDO5ehi5OSQEDCR2HnrOEsXIxeHkMAeRokVLfvZIJxPjBIfz25khnC+MUrsmradCabl
	8YoLrBCJvYwSJ7v/QVW9ZZSYsnALC0gVr4CdxKF7L8A6WARUJZ79a2WDiAtKnJz5BKxGVEBe
	4v6tGewgtrCAusSDrQ8YQWwRgUCJxp132EGGMgtMZZRY8v0I2CBmAXGJW0/mA9kcHGwCmhIX
	JpeChDkFbCU6/i5lhSiRl2jeOhvsIAmBn+wSr6YeZoY420Vi9qZV7BC2sMSr41ugbCmJl/1t
	UHa2xINHD1gg7BqJHZv7WCFse4mGPzdYQfYyA+1dv0sfYhefRO/vJ2DnSAjwSnS0CUFUK0rc
	m/QUqlNc4uGMJVC2h8T1M6fBPhESmMAoMbu5cAKjwiykUJmF5MlZSL6ZhbB4ASPLKkap1ILi
	3PTUZNMCQ9281HJ4jCfn525iBCdNrYAdjKs3/NU7xMjEwXiIUYKDWUmElzNzT7oQb0piZVVq
	UX58UWlOavEhRlNg/ExklhJNzgem7bySeEMTSwMTMzMzE0tjM0Mlcd7mnS3pQgLpiSWp2amp
	BalFMH1MHJxSDUwOLSEhpQumvq4/UxtdmGBmpR86dXHr3hWKTMn6tXukZvCfXHzo2h2ux8zy
	R38xmDAoGbRt+/t7cyCndONMJ5VNB5xn6lu3806YPGVTstSaBx/8697+5Mh756FyN/wl44vv
	fKdOaGd+rFy6ZQJnwsS5AueKSttYn2ytFltmszBrq/vyTYnVp/mfWssqP4jfGbpi/j7JOVwX
	E9xN4xWvNrv9WX2d472s5jK37c+63yRe4XPm12Dv9Fq6q63Ju5Bdi/dakFz7pOk9MwSO88av
	PHdotqn0jhzBZxu2XVv0+HPD1qqyDtZ1wX+t/ztX6Z7W+flsv47+3mULNDU2me1S79AIncqa
	8vRYaxF/jU5jc7USS3FGoqEWc1FxIgD6eP2uIwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWy7bCSnK7K9L3pBgsuGFssWDSXxeLY/lns
	FqcnLGKy2HtL22L58X9MDqweO2fdZffYvELL48XmmYweH5/eYvH4vEkugDWKyyYlNSezLLVI
	3y6BK2Pt6k62glVcFe8ONTE1MM7l6GLk5JAQMJF4vOICaxcjF4eQwG5GiUvPX7NDJMQlmq/9
	gLKFJVb+e84OUfSaUWL3vMdsIAleATuJQ/deMIHYLAKqEs/+tULFBSVOznzCAmKLCshL3L81
	A2yQsIC6xIOtDxhBbBGBQIl/c+eDDWUWmM4osf/aKjaIDRMYJWavWwFWxQx0xq0n84E2cHCw
	CWhKXJhcChLmFLCV6Pi7lBWixEyia2sXVLm8RPPW2cwTGIVmIbljFpJJs5C0zELSsoCRZRWj
	ZGpBcW56brFhgVFearlecWJucWleul5yfu4mRnCEaGntYNyz6oPeIUYmDsZDjBIczEoivJyZ
	e9KFeFMSK6tSi/Lji0pzUosPMUpzsCiJ83573ZsiJJCeWJKanZpakFoEk2Xi4JRqYJqReqc+
	UiGi9+DbqANvVmvaLtk1Y3vX37g8J/5ZqRIbnhjefiEWaR91K++1v8LLSUkqBfZdts5n5Y4p
	B8usfmRy55u7mp6005v+y5qCF1Z0vpXhnaaj7pQ69etmLRujs/8n2H7gVleTPdGaqa0dI6UR
	ysQfWnPIyqTJJ+xl4YUvPk914v42m0+acFstaKaIZ5ny/B1fWTRLZ2vGPDssFbUl94nNzzo+
	J0Ehi9e/eu3VpR0lDbo2Gd9mTGp/M/vEunWdlU/zPT0tmb7w8d/TFN/P+8Tjt+XPmpoE5kor
	odC3PdPf2k2+vuTrx5eB7X9ePO7f3bhU/GzzG8bHSl4L+dbNnjPfWFmlklVbk6VdiaU4I9FQ
	i7moOBEAalKkOP8CAAA=
X-CMS-MailID: 20250225101044epcas5p46cd487380822a642877d0a23401f9eb7
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250225092525epcas5p31dd0a19ffdfb39f3f2ce4acd1c6da7ee
References: <CGME20250225092525epcas5p31dd0a19ffdfb39f3f2ce4acd1c6da7ee@epcas5p3.samsung.com>
	<67795955-93a4-405b-b0b7-e6b5d921f35e@gmail.com>

On 2/25/2025 2:53 PM, Milan Broz wrote:
> Hi,
> 
> I tried to add some support for using devices with PI/DIF metadata
> and checked (through sysfs) how large metadata space per sector
> is available.
> 
> The problem is that some values behave differently than I expected.
> 
> For an NVMe drive, reformatted to 4096 + 64 profile, I see this:
> 
> - /sys/block/<disk>/integrity/device_is_integrity_capable
>    Contains 0 (?)
>    According to docs, this field
>   "Indicates whether a storage device is capable of storing integrity 
> metadata.
>   Set if the device is T10 PI-capable."
> 
> - /sys/block/<disk>/integrity/format
>   Contains expected "nop" (not "none")
> 
> - /sys/block/<disk>/integrity/tag_size
>    Contains 0 (?)

This and "nop" indicates that pi-type was configured to be 0?
Maybe you can share the nvme format command as well.

>    According to docs, this is "Number of bytes of integrity tag space
>    available per 512 bytes of data."
>    (I think 512 bytes is incorrect; it should be sector size, or perhaps
>     value in protection_interval_bytes, though.)
> 
> Then we have new (undocumented) value for NVMe in
> - /sys/block/<nvme>/integrity/metadata_bytes
>    This contains the correct 64.

Maybe you mean "/sys/block/>/metadata_bytes"?
