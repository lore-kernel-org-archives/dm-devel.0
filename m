Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4801E10FF
	for <dm-devel@lists.linux.dev>; Tue,  3 Sep 2024 00:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725323255; cv=none; b=qfGtcUnMhFXnRRuX+Zd5kAnzg0l1WChTEwj/Jc7hw7PlALW2K6tOmRINRbcJ2DzfbHT+3tRNqXH7nlTNHVNqufw4IHgJWZz57yOXlXxS+DZschskdg17rWPdOZd/8w21L1tIFmtzCz6mrNXFcoN/h6Y3JVg3SL3zqzowpT9ydwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725323255; c=relaxed/simple;
	bh=HfnyfCFs2y55va0C01gVCK3e4OJKYlY5y+I3+tf2EKs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=bUa6s38vNkysCnnAd6OfpOHo+XYQDmNa7YKSRpwMeBVqH5KNgQ45YBL2ivunhoQqEMee8bn3EGhlzOqTPg02Gmw3sAo0FTKCDpQ9Xe1UO130cMcWABjLEoltxINSIidJOX9ooazu9oKLpkHUreAsNBlHJPGDYbCNUhULZJ9MJX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=BmvAacBW; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="BmvAacBW"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240903002731epoutp03d293a7fcb1ad8f36f57b17ec540e5f00~xlFsSiMmI1364413644epoutp03U
	for <dm-devel@lists.linux.dev>; Tue,  3 Sep 2024 00:27:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240903002731epoutp03d293a7fcb1ad8f36f57b17ec540e5f00~xlFsSiMmI1364413644epoutp03U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725323251;
	bh=aq9sdhrNTcFVxu38axoQmVv8fha1C+W10hQiJU+va4k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BmvAacBW3t16oxVrKsvgBg6GyE7ZiWCX7Gk27Y/5aPSEEsX1tshqPmfawnj/UsLN+
	 lLSMbTv6tQE0tOZlKdC1HO8coeLjn7kGaRvkN7gyPQlRMhkiSo+nOoL5SsEGMJ5Xsr
	 8Bj/RzLtoI9o7n8OnOywpbdzD1i8OsPKJ7wsyhZk=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240903002730epcas5p27b95e949e772857b1fe9d6092d0e4ef1~xlFrzqvgR2589725897epcas5p2D;
	Tue,  3 Sep 2024 00:27:30 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WyRKF0hCBz4x9Pv; Tue,  3 Sep
	2024 00:27:29 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4D.CA.09640.0F756D66; Tue,  3 Sep 2024 09:27:28 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240902195329epcas5p2b948111861fe6cbb403311a09ad6f864~xhWbmRZyQ2378523785epcas5p2z;
	Mon,  2 Sep 2024 19:53:29 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240902195329epsmtrp1fb2fa7b0a7cda6c15c208230161fb17e~xhWbluscl2355023550epsmtrp1d;
	Mon,  2 Sep 2024 19:53:29 +0000 (GMT)
X-AuditID: b6c32a49-a57ff700000025a8-f1-66d657f07c4b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B0.BC.07567.9B716D66; Tue,  3 Sep 2024 04:53:29 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20240902195328epsmtip29ec94b0e0c98fa06e5f4f8ffeb4bc751~xhWagwUif1600016000epsmtip2L;
	Mon,  2 Sep 2024 19:53:27 +0000 (GMT)
Date: Tue, 3 Sep 2024 01:15:51 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH -next] dm: Make use of __assign_bit() API
Message-ID: <20240902194315.pnddelrxvq5bgnin@ubuntu>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240902131123.3007226-1-lihongbo22@huawei.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42LZdlhTS/dD+LU0g2U9VhbrTx1jtliwaC6L
	xbR/h5ksJnZcZbI4cUvagdWj5chbVo9NqzrZPF5snsno8X7fVbYAlqhsm4zUxJTUIoXUvOT8
	lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygvUoKZYk5pUChgMTiYiV9O5ui
	/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9vNQSK0MDAyNToMKE7IyHNzcwFZxlrVgwfylL
	A+Mdli5GTg4JAROJebfus3cxcnEICexmlPjw9xOU84lRYuK65cwgVUIC3xgl9h5OhOl4ffMk
	VNFeRokvp1exQThPGCXmbbrKCFLFIqAicX/hJaAqDg42AW2J0/85QMIiAqoShy/tZwexmQXC
	JWacXgq2QFjAVmLznC1grbxAC77eOQxlC0qcnPkE7FROoJr/R6+wguySELjELnFh6wo2iItc
	JKY2z2aHsIUlXh3fAmVLSbzsb4OyyyVWTlnBBtHcwigx6/osRoiEvUTrqX5miIsyJA4ebGOC
	iMtKTD21jgkizifR+/sJVJxXYsc8GFtZYs36BVBHSEpc+94IZXtILNn9mRUSKhMYJV4tmcM8
	gVFuFpKPZiHZB2FbSXR+aGKdBQwwZgFpieX/OCBMTYn1u/QXMLKuYpRMLSjOTU8tNi0wzEst
	h8dycn7uJkZwWtTy3MF498EHvUOMTByMhxglOJiVRHhjN15NE+JNSaysSi3Kjy8qzUktPsRo
	CoygicxSosn5wMScVxJvaGJpYGJmZmZiaWxmqCTO+7p1boqQQHpiSWp2ampBahFMHxMHp1QD
	0+rWTd93z1v7etOfU2c6lj6MLdJ+xe39hYPjwNm3O8+wSbnefKM4706Cpodw6tSLG0pXXuLy
	PdC87q3m9i+m2zTuvigw//j+Xlfn7VU8dQsvHpT71HTMOH1Va9JstgDJXBMdk60z5q97FN2x
	J/DFlp12/2x3Pbf6KxdneHl1ZX0ha/fXXG39v9+c/mZuy9upHdLOoem47NV3G+GCSOuHb1y/
	rM/fpvdhz51d65jlF2VOrr/LlHnod7fhpBS7g/s02n/eKV/4z9M/3Ygx6tOTmZV35d/cue3u
	bnJDfW5G4tPn+zdVdi85P6kp95bgv78HJPbw95eu6NA4dffdfD/mhcu+NzoLSV1Kmbo+Nlj7
	z9MPSizFGYmGWsxFxYkAl7e36xQEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWy7bCSvO5O8WtpBt2N3BbrTx1jtliwaC6L
	xbR/h5ksJnZcZbI4cUvagdWj5chbVo9NqzrZPF5snsno8X7fVbYAligum5TUnMyy1CJ9uwSu
	jIVTjzIV/GequPhKooFxBVMXIyeHhICJxOubJ9m7GLk4hAR2M0rcWPaXHSIhKbHs7xFmCFtY
	YuW/51BFjxglth+ZywKSYBFQkbi/8BJQgoODTUBb4vR/DpCwiICqxOFL+8HmMAuES8w4vRRs
	jrCArcTmOVsYQWxeoMVf7xwGs4UEbCRu7nnDBhEXlDg58wkLRK+ZxLzND5lBxjMLSEss/wc2
	nhNozP+jV1gnMArMQtIxC0nHLISOBYzMqxglUwuKc9Nzkw0LDPNSy/WKE3OLS/PS9ZLzczcx
	ggNZS2MH4735//QOMTJxMB5ilOBgVhLhjd14NU2INyWxsiq1KD++qDQntfgQozQHi5I4r+GM
	2SlCAumJJanZqakFqUUwWSYOTqkGpqnWmTL9FszGtx1VJice6Xzx9pW37aPjbpdjnD983Bh+
	hWHGkTAdyy9TXhrH6LdKaG7RZEj5bjhnQYjmxdc/1i8/rHby/UOdvX4XOmfG9n/7YKDEvfxh
	zjIfnQUzZykUqTwvtblWLVxpt36PUU5artMn361GqUVz8/zdTfS27jaM3nDX87sE33y/sNL8
	UwHNKeUGv4OKHPSur15YcfzF+yyxiLXczKtu3Lx7Jl5q1mPWJoWuzEI+h7P/kzvE/7MmLeVS
	U6zzMOH4sXb2a549GYnF73MVAx+efu92cONFCcu13W+fCa2RVr3sLv9OqdlJ67Ec073gUAsb
	98XPnsyaO9+2tcmcOVko+LxyXDCzEktxRqKhFnNRcSIAp9o0dtMCAAA=
X-CMS-MailID: 20240902195329epcas5p2b948111861fe6cbb403311a09ad6f864
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----rEVyOeUC1-Pd4ykAKehEErIJv_6LE1Y2HSCt3w26tRlypI58=_ca1f9_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240902195329epcas5p2b948111861fe6cbb403311a09ad6f864
References: <20240902131123.3007226-1-lihongbo22@huawei.com>
	<CGME20240902195329epcas5p2b948111861fe6cbb403311a09ad6f864@epcas5p2.samsung.com>

------rEVyOeUC1-Pd4ykAKehEErIJv_6LE1Y2HSCt3w26tRlypI58=_ca1f9_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 02/09/24 09:11PM, Hongbo Li wrote:
>We have for some time the __assign_bit() API to replace
>open coded
>    if (foo)
>        __set_bit(n, bar);
>    else
>        __clear_bit(n, bar);
>
>Use this API to simplify the code. No functional change
>intended.
>
>Signed-off-by: Hongbo Li <lihongbo22@huawei.com>
>---

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------rEVyOeUC1-Pd4ykAKehEErIJv_6LE1Y2HSCt3w26tRlypI58=_ca1f9_
Content-Type: text/plain; charset="utf-8"


------rEVyOeUC1-Pd4ykAKehEErIJv_6LE1Y2HSCt3w26tRlypI58=_ca1f9_--
