Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3504AEDF
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 05:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716873966; cv=none; b=kxxCJL3XY2o+Ey4vdvOewWk5tbyPzGuTwol7WnTtVl0VbWiYYSO4MTlSkWEd5FWoH5V5USwn17xIAQr8p2CX+SGdxRUbmp/y8w8jjBmBPO2xklyp+5hmmSqymIwlrwrJRBZXSPRVZdMun3lVuD9mGZApqNVDEQ0yZFhpN6nop/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716873966; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=iEtaV4Ft98TqB2FULNfCR29y4SbxBngkwB0XJstAQvsqnfyKQPW87qz0LMYI8tHG3uU7GHX9FsAJxD2ZflTu072WXfOncl7WiG0HHoUxCACmX/vqoRR0treaolN7RVAYveJ/itg/h2RudaLYuBu5Lm/+0viPBZyArFE/EaimEKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=eKQU0NpT; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="eKQU0NpT"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240528052554epoutp0393321856f86ba46ca1062eb696525253~Tj8PjZ-TO0281902819epoutp03U
	for <dm-devel@lists.linux.dev>; Tue, 28 May 2024 05:25:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240528052554epoutp0393321856f86ba46ca1062eb696525253~Tj8PjZ-TO0281902819epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1716873954;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=eKQU0NpT9fiumiFihgz705hQjzUXrszAaZpp/j0121QE7PT+cS30aAYVZCtHktQ2g
	 RBJVwy6OfsXUAyZLlrzlpZwlbx3Ply6Z9GUmmQJLfEz4StEBXKUHGG6W3eQYrf/zHx
	 TrzEGHpL8LUhDGqkPayXsMJq3LmjOgEQnR5tBDVQ=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240528052554epcas5p1110e43a96b238c1cf5435fb3f5d379bf~Tj8PKzHc72041920419epcas5p1p;
	Tue, 28 May 2024 05:25:54 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4VpLZm5NhQz4x9QH; Tue, 28 May
	2024 05:25:52 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	95.33.10035.FDA65566; Tue, 28 May 2024 14:25:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240528052550epcas5p27a89e7264e9058afad39e0d8970235a9~Tj8MQyse02997129971epcas5p24;
	Tue, 28 May 2024 05:25:50 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240528052550epsmtrp24139879fedea4bd8e4e03e79ff4be473~Tj8MQGGwA1060410604epsmtrp2p;
	Tue, 28 May 2024 05:25:50 +0000 (GMT)
X-AuditID: b6c32a4b-b11fa70000002733-be-66556adf2de7
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	34.50.07412.EDA65566; Tue, 28 May 2024 14:25:50 +0900 (KST)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240528052549epsmtip1a2ad4691ce9efe5d243006691de7865f~Tj8KqaO2h3181531815epsmtip1W;
	Tue, 28 May 2024 05:25:49 +0000 (GMT)
Message-ID: <4f35011f-c710-c207-ebfc-68f7117cced1@samsung.com>
Date: Tue, 28 May 2024 10:55:48 +0530
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0)
	Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 1/2 v4] block: change rq_integrity_vec to respect the
 iterator
Content-Language: en-US
To: Mikulas Patocka <mpatocka@redhat.com>, Axboe <axboe@kernel.dk>, Keith
	Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg
	<sagi@grimberg.me>, Mike Snitzer <snitzer@kernel.org>, Milan Broz
	<gmazyland@gmail.com>, Anuj gupta <anuj1072538@gmail.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-nvme@lists.infradead.org
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <49d1afaa-f934-6ed2-a678-e0d428c63a65@redhat.com>
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJsWRmVeSWpSXmKPExsWy7bCmuu79rNA0g+8XRSw+fv3NYrH6bj+b
	xYJFc1ksju2fxW6xcvVRJotJh64xWuy9pW0xf9lTdouJHVeZLNa9fs9iceKWtAO3x85Zd9k9
	zt/byOJx+Wypx6ZVnWwem5fUe7zYPJPRY/fNBjaP9/uusnl83iQXwBmVbZORmpiSWqSQmpec
	n5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKqSQlliTilQKCCxuFhJ386m
	KL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITvjz9nTrAUmFdfm9jE1
	MOp2MXJySAiYSBzpvsbcxcjFISSwm1Fi0oYZLBDOJ0aJnaeOM0E43xglGnZeZ4NpmbvuE1Ri
	L6PE40N/oPrfMkrcmLMCyOHg4BWwk/i32hukgUVAVWJC6wtWEJtXQFDi5MwnLCC2qECyxM+u
	A2BDhQVCJB7dn8gEYjMLiEvcejIfbIGIwBQmicvzOtggEtESB95cYwKZzyagKXFhcilImBNo
	1Zfnd9khSuQltr+dA3aPhMABDokFR2czQVztIvFu8W9WCFtY4tXxLewQtpTE53d7oT5Llrg0
	8xxUfYnE4z0HoWx7idZT/WB/MQPtXb9LH2IXn0Tv7ydg50gI8Ep0tAlBVCtK3Jv0FGqTuMTD
	GUugbA+JZ2v+QUP3MKPEnRkLmSYwKsxCCpZZSN6fheSdWQibFzCyrGKUTC0ozk1PLTYtMM5L
	LYdHd3J+7iZGcDrW8t7B+OjBB71DjEwcjIcYJTiYlUR4ReYFpgnxpiRWVqUW5ccXleakFh9i
	NAXGz0RmKdHkfGBGyCuJNzSxNDAxMzMzsTQ2M1QS533dOjdFSCA9sSQ1OzW1ILUIpo+Jg1Oq
	gUm5a+auW4FNZk8W9quGLPbf7GK54Hy4xR2tsyXr+tXedhzvfT3lZYbnilsS7MnubjPONWXX
	dCcxmIh2pySeurL98nwuzn0Tygqnvt29WTKGr/zGI+61/RsZH/Z4brppGaBp9yvcXJavPz9A
	+rJ+m82xOzph7mZz68PN67zOlNzYEXtrwgvjhtUdiU28h7bu6L6+td3Qh6d8Q2F0fowR7/lX
	IaGn+F+qvOhI7tm+962p0InsjZf7w8O8Xun7GSfc23Rwjd7qL/JmT64uuP3AoLj22j3J99yJ
	yy8JfrCatSdNu3IHi9yWTyaPAoqq5EVYheo8e5d9L5rTfKRr2/+fmx4atlrZtxr8MuFafvz/
	VCWW4oxEQy3mouJEACXD/5BQBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBIsWRmVeSWpSXmKPExsWy7bCSnO69rNA0g8UXDC0+fv3NYrH6bj+b
	xYJFc1ksju2fxW6xcvVRJotJh64xWuy9pW0xf9lTdouJHVeZLNa9fs9iceKWtAO3x85Zd9k9
	zt/byOJx+Wypx6ZVnWwem5fUe7zYPJPRY/fNBjaP9/uusnl83iQXwBnFZZOSmpNZllqkb5fA
	lfHn7GnWApOKa3P7mBoYdbsYOTkkBEwk5q77xNTFyMUhJLCbUWLq34nsEAlxieZrP6BsYYmV
	/56D2UICrxkllizy6mLk4OAVsJP4t9obJMwioCoxofUFK4jNKyAocXLmExYQW1QgWeLlH4iR
	wgIhEo/uT2QCsZmBxt96Mh9sr4jAFCaJ3rUNjBCJaInjRx4xQxx0mFHiX/MXdpBlbAKaEhcm
	l4LUcALt/fL8LjtEvZlE19YuqF55ie1v5zBPYBSaheSOWUj2zULSMgtJywJGllWMkqkFxbnp
	ucmGBYZ5qeV6xYm5xaV56XrJ+bmbGMGRp6Wxg/He/H96hxiZOBgPMUpwMCuJ8IrMC0wT4k1J
	rKxKLcqPLyrNSS0+xCjNwaIkzms4Y3aKkEB6YklqdmpqQWoRTJaJg1OqgenxewMWzq3zMqeK
	ibTc+906yVFE9d6SqAAJ41xZ1Yv7WvOLcqTuThQyUlnbEKzcVug3oz39mYrMw/crKpTLb16W
	rijo+/9qe3KcZvky66sHbqWvi7Pom3jsbNGjJ6dcT51/4fEgz1iB9d/ig2W1nZMCPxRH56Su
	5kw+L31EZuYZdYmfhlKMamunFghuvZ03c5niUWXtNSeNPPbUHJHWLJ716ZWpznou/mUm3T1G
	2vm8Lkp1PN/n7GFXvNQnlLSqdX3Dzbjzt7llrvIyHtGMj7o3VST4uonItNkntsmtOXT6sf/a
	XSsynI201+f7bl3Iaek6xeXy57WH7gl9VGj8OHVTdEJcrjSbnc2+N9dvHFBiKc5INNRiLipO
	BAB+qBLmKwMAAA==
X-CMS-MailID: 20240528052550epcas5p27a89e7264e9058afad39e0d8970235a9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240527154143epcas5p3a7738864fd2eff65f8dab75b2fd9f1e8
References: <719d2e-b0e6-663c-ec38-acf939e4a04b@redhat.com>
	<CGME20240527154143epcas5p3a7738864fd2eff65f8dab75b2fd9f1e8@epcas5p3.samsung.com>
	<49d1afaa-f934-6ed2-a678-e0d428c63a65@redhat.com>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>

