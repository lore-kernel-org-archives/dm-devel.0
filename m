Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F89317C9E9
	for <dm-devel@lists.linux.dev>; Tue,  8 Oct 2024 06:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728369663; cv=none; b=aSZr/piBeELuaSDM77e3V1WWDCJ8u5t36ySGLoZ5HvoX408eCyKQHX4aD8M6oZAtTBOtAFRdGlUQIqvPA0NQOkKq4L5LCCHQcfUip33+Xrd2clvyt8K8ZSzmkttqUalKKG2oRDXfGveFAWD4ma8PSn/Q0ouZlRmWbUxPcu/IjJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728369663; c=relaxed/simple;
	bh=abhOrbVXBb8FBxrr+crhnDa5MKWzMoI+Ek3Kr8nGJwU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=UBhUU7fy/chK5m7vyJr70VPjCNffNJ2zyWbvUXN5iZBTKDgPFhLt6jcicjtU6178ca6beopE4Su4dAsmd5I8HgB7LBUmM5gUSRGxSLS0HNwG1g/X8luxKcWFLtDDYWv3HgCQwI/Dly1VDQWo66ihgDy6jg2BkiYkJTts4BSRwkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=ga7objZw; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="ga7objZw"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20241008064058epoutp0341154ea7292333f8410b0170495ebd80~8ZwwLUwx21349613496epoutp03O
	for <dm-devel@lists.linux.dev>; Tue,  8 Oct 2024 06:40:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20241008064058epoutp0341154ea7292333f8410b0170495ebd80~8ZwwLUwx21349613496epoutp03O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1728369658;
	bh=abhOrbVXBb8FBxrr+crhnDa5MKWzMoI+Ek3Kr8nGJwU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ga7objZwurTA/of2sQ0OILyraSV9LlEsUVA1e8tkRE8/7WTzuzHVqqTJrHATy4CyK
	 02G7wm+TK/FLu9IdITUbJsatNdBZsmC5F/7AnOgH0mkH/9gnBRxl9zkoEdkDxYILkX
	 oq/D2QdPLe7KIUGBMgtGYtw6hhQckBtCE+gKG01U=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241008064057epcas5p4716dae467e0c31c9eafa91b41b10bf06~8Zwvtacy-1950719507epcas5p4y;
	Tue,  8 Oct 2024 06:40:57 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4XN5xz6s2dz4x9Q9; Tue,  8 Oct
	2024 06:40:55 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	CD.5B.08574.5F3D4076; Tue,  8 Oct 2024 15:40:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241008064019epcas5p2a90ac1faf4a33d5f2bf3f85f2e4005ff~8ZwMFiePn0697706977epcas5p2t;
	Tue,  8 Oct 2024 06:40:19 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241008064019epsmtrp29b91607d9dd59cf1e32dd03b5ceee4b4~8ZwMEcbZq1035510355epsmtrp2j;
	Tue,  8 Oct 2024 06:40:19 +0000 (GMT)
X-AuditID: b6c32a44-6dbff7000000217e-b7-6704d3f5e9b0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	5A.3B.08229.3D3D4076; Tue,  8 Oct 2024 15:40:19 +0900 (KST)
Received: from ubuntu (unknown [107.99.41.245]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20241008064018epsmtip1e4d8dcd69c135c47825b5bd325eec017~8ZwK4SgSC1622616226epsmtip11;
	Tue,  8 Oct 2024 06:40:18 +0000 (GMT)
Date: Tue, 8 Oct 2024 12:02:38 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Chenyuan Yang <chenyuan0y@gmail.com>, agk@redhat.com,
	snitzer@kernel.org, dm-devel@lists.linux.dev, Zijie Zhao
	<zzjas98@gmail.com>, syzkaller@googlegroups.com, secalert@redhat.com
Subject: Re: [PATCH] dm: fix a crash if blk_alloc_disk fails
Message-ID: <20241008063238.zzo3bzjqai6jel3w@ubuntu>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <16e9030d-e55c-47eb-1a2a-dff8a50e6627@redhat.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMJsWRmVeSWpSXmKPExsWy7bCmlu7XyyzpBvtZLNafOsZs8XLGUmaL
	BYvmslhM7LjKZLHtjbbFiVvSFkfedDNb3G/5yebA4bFz1l12jz0TT7J5bFrVyebxYvNMRo/3
	+66yBbBGZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
	MgUqTMjOaNo2i7XgKXvF4u0T2BoYn7F1MXJySAiYSLQt2c3cxcjFISSwm1Hi/5cZbBDOJ0aJ
	FTsPsUA43xglXk48wQ7Tsn7aNWYQW0hgL6PE3js2EEVPGCVOX18F1M7BwSKgItG1yAPEZBPQ
	ljj9nwOkXERAU+LSnDesIOXMINtm9VxjAUkIC9hIfJo3HewkXqD53xq/skLYghInZz4Bq+EU
	sJPYeP8BWLOEwE92iacLHzFBHOQi8WTHTxYIW1ji1fEtUIdKSXx+txfqz3KJlVNWsEE0twBt
	vj6LESJhL9F6qh/sG2aBDIlza75BDZWVmHpqHRNEnE+i9/cTqDivxI55MLayxJr1C6AWSEpc
	+94IZXtI7LvcyQgJlRuMEqvfXmCewCg3C8lHs5Dsg7CtJDo/NLHOAoYYs4C0xPJ/HBCmpsT6
	XfoLGFlXMUqmFhTnpqcmmxYY5qWWw2M5OT93EyM4dWq57GC8Mf+f3iFGJg7GQ4wSHMxKIrwR
	axjThXhTEiurUovy44tKc1KLDzGaAiNoIrOUaHI+MHnnlcQbmlgamJiZmZlYGpsZKonzvm6d
	myIkkJ5YkpqdmlqQWgTTx8TBKdXAZGuVFhJ/TbuMQ6jdL//N23cT58yNkE99I3eu9oWWbuWL
	Y7e28+/2cTAy2i9qtcL89zvOLEuFwM3uHzqO/RN+uNBk/hTN5VZLzmlfeXJnjvTp3lfVrdv8
	1C5YTlz+gKUiL9lq7g6L84uDkz/tuD6x84n36U/7nWXretU2J3hWBEtdOF0/7WCdj3RA6bv4
	M//z35TFnP2wNbM9bAfrUWWTPR7Xl9tL9wrP1Ln++/CNlGt7XyzpmrVbXeVI++5tZxgSNj/J
	LArXkJoUO9W13+BrNeuf8ArFq4JTZP/t0G8qcjkQdX+fkMWXXq3FQftKpnZE6X39av7zVID7
	KeWu6p+HnTJcMlbuXb78g5ts9pWNZUosxRmJhlrMRcWJAOz7TpImBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWy7bCSnO7lyyzpBoseK1usP3WM2eLljKXM
	FgsWzWWxmNhxlcli2xttixO3pC2OvOlmtrjf8pPNgcNj56y77B57Jp5k89i0qpPN48XmmYwe
	7/ddZQtgjeKySUnNySxLLdK3S+DKWDB1NnvBdNaKpk2nGBsYN7F0MXJySAiYSKyfdo25i5GL
	Q0hgN6PEsZt/WCESkhLL/h5hhrCFJVb+e84OUfSIUeLPvj4gh4ODRUBFomuRB4jJJqAtcfo/
	B0i5iICmxKU5b1hBypkF9jJK/N5+FGyZsICNxKd509lAbF6gxd8av7JCzGxhlDj38BAzREJQ
	4uTMJ2ANzAJmEvM2P2QGWcAsIC2x/B/YAk4BO4mN9x+wTmAUmIWkYxaSjlkIHQsYmVcxSqYW
	FOem5xYbFhjmpZbrFSfmFpfmpesl5+duYgSHvJbmDsbtqz7oHWJk4mA8xCjBwawkwhuxhjFd
	iDclsbIqtSg/vqg0J7X4EKM0B4uSOK/4i94UIYH0xJLU7NTUgtQimCwTB6dUA1P4QrX2hzIS
	bvZ6CaJpYv8dQ/ZF1Dp5FT6zsGNYv6SC/dU9Sx2908xMCzf713145lpTzbvkbbUaE++C+wu3
	T8n8rhjLw9/17luO07zfas/1Ge+6yqofVGa8f2L3znlzDsr/3RTbfs/H6Uib+ToW4XPX9q7v
	joxjPf5rqejrNhdBzV+8K6Ycq1FvddT112NrfrJ+zvUE97Q0u21SWwJqpz636z8q/PJou1Ea
	/7SNr/5bmWiYn5qTek/9MFvId1cXI8OL04N2Je7RWyR2P+fvWnWrlhsVHw+HnVks6Su+sZs7
	8+xZedEDK9I5eF3uqwkdPxisvbBvX+eE+n0nZH9pS3o1RH2eEta06kPFqQerTymxFGckGmox
	FxUnAgA0XQIZ6AIAAA==
X-CMS-MailID: 20241008064019epcas5p2a90ac1faf4a33d5f2bf3f85f2e4005ff
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_24bb2_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241008064019epcas5p2a90ac1faf4a33d5f2bf3f85f2e4005ff
References: <CALGdzuo-1QZgk4ZmNXf8_Nyb+d9JLRktCR-3pJZsdVUmKjaXhQ@mail.gmail.com>
	<16e9030d-e55c-47eb-1a2a-dff8a50e6627@redhat.com>
	<CGME20241008064019epcas5p2a90ac1faf4a33d5f2bf3f85f2e4005ff@epcas5p2.samsung.com>

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_24bb2_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 07/10/24 01:38PM, Mikulas Patocka wrote:
>
>Hi
>
>Here I'm submitting a patch for this bug.
>
>Mikulas
>
>
>From: Mikulas Patocka <mpatocka@redhat.com>
>
>If blk_alloc_disk fails, the variable md->disk is set to an error value.
>cleanup_mapped_device will see that md->disk is non-NULL and it will
>attempt to access it, causing a crash on this statement
>"md->disk->private_data = NULL;".
>
>Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>Reported-by: Chenyuan Yang <chenyuan0y@gmail.com>
>Closes: https://marc.info/?l=dm-devel&m=172824125004329&w=2
>Cc: stable@vger.kernel.org

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_24bb2_
Content-Type: text/plain; charset="utf-8"


------Q5hryimWBrG20CTDo2Cycv07rC8cEZ5s1mVzGfufIajJO9l9=_24bb2_--
