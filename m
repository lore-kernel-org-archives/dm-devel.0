Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49A53C04A6A
	for <dm-devel@archiver.kernel.org>; Wed,  2 Aug 2023 04:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690950697;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=GNxW3265dZ3Lc8Jgz3fDJGaR8NaSMBoXqxttZW4FufA=;
	b=AkV1P5BMgl1ONYg6ctf6eBAfx+dKIkQszdj2BDkCeSW2e/eLBVsGvqYvUOmOgpJMGGGiwF
	ZPdHJ+kWFRv1HEnZcvD9NaNWv6IAVXbZD7LutvULCpmZS351KbxRBFSoGMHT/1SYq6c9Jh
	Eld8Z6YUpIm1+42vhuUZ6fVyfDRrHQY=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-468-5wkCb0LCN6mX-lNtunUSug-1; Wed, 02 Aug 2023 00:31:30 -0400
X-MC-Unique: 5wkCb0LCN6mX-lNtunUSug-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 06C523811F25;
	Wed,  2 Aug 2023 04:31:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C244F401DA9;
	Wed,  2 Aug 2023 04:31:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 83CD21946A45;
	Wed,  2 Aug 2023 04:31:27 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 482331946A43
 for <dm-devel@listman.corp.redhat.com>; Wed,  2 Aug 2023 04:31:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 190B14A9004; Wed,  2 Aug 2023 04:31:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1080E401DA9
 for <dm-devel@redhat.com>; Wed,  2 Aug 2023 04:31:25 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A301F3C00086
 for <dm-devel@redhat.com>; Wed,  2 Aug 2023 04:31:25 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-364-i3BPVCb_NFitcYhKWYZCBQ-1; Wed, 02 Aug 2023 00:31:21 -0400
X-MC-Unique: i3BPVCb_NFitcYhKWYZCBQ-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230802043118epoutp0148372d5de7d4c901cd556916e81b255c~3dq7O-uv51100011000epoutp01h
 for <dm-devel@redhat.com>; Wed,  2 Aug 2023 04:31:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230802043118epoutp0148372d5de7d4c901cd556916e81b255c~3dq7O-uv51100011000epoutp01h
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230802043117epcas5p4f65a3af8f58ed9fbd09a0de76a1a6e98~3dq6q3CdP0307103071epcas5p4G;
 Wed,  2 Aug 2023 04:31:17 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.183]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4RFzZD00jzz4x9Q8; Wed,  2 Aug
 2023 04:31:16 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 46.DF.06099.31CD9C46; Wed,  2 Aug 2023 13:31:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
 20230801131020epcas5p39ed61d99f4711bb3275c06db551abe96~3RG0as1091260612606epcas5p3k;
 Tue,  1 Aug 2023 13:10:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230801131020epsmtrp120d0022b70a61a613b1e6a625a053500~3RG0YTEid1439414394epsmtrp1v;
 Tue,  1 Aug 2023 13:10:20 +0000 (GMT)
X-AuditID: b6c32a4b-cafff700000017d3-74-64c9dc13528b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 28.29.34491.C3409C46; Tue,  1 Aug 2023 22:10:20 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230801131015epsmtip2074fb69732b70a6432999c6e507196bd~3RGwMiLU92662426624epsmtip2c;
 Tue,  1 Aug 2023 13:10:15 +0000 (GMT)
Date: Tue, 1 Aug 2023 18:37:02 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Christoph Hellwig <hch@lst.de>
Message-ID: <20230801130702.2taecrgn4v66ehtx@green245>
MIME-Version: 1.0
In-Reply-To: <20230720075050.GB5042@lst.de>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTH/d3bXi5s7a5Fth8PB1azKYbXhPKDlEcicVcwiJI5NpeUht4B
 AqVpy5jTbTyUhwo4ZG7reMhDKLDAKLihlI0ArgME4qowiDCeZkB4OpRB0BUuLP73yTnne545
 JC7QmdmQ0XI1o5RLY4WEBeentgNvO1k+6pC5NqyKUG3nbzhKubqOo+qhHALNtC0BdH3hXxxN
 tKQDZJzgo5Ff/VDz3PdcNNByG0P6klwMVVbfxVBuax9Akw81GGoePIiK08o4SN/cwUHGO/kE
 KiqfNEOX+xsJVGF4jqHWa6kYapxIBqhmZp6Dfh+0ReOXMwDqXTdw0dpKPuFvRxsfBNG3NUNm
 dO9wHYeu1zrSxu4EWleVSdD1ZV/STQNJBF2afY1LZ6XOEfTi5CCHnv/lIUFnN1QBur7rHP1E
 9yatm5jFQqgPY8RRjFTGKB0YeUS8LFoe6SMMCpUclniIXN2c3LyQp9BBLo1jfIQBx0KcjkTH
 mrYjdPhEGptgMoVIVSqhi69YGZ+gZhyi4lVqHyGjkMUq3BXOKmmcKkEe6Sxn1N5urq7veJgC
 w2Oiio2ruGL41U/rV0axJKC1uATMSUi5w/G0x8QlYEEKqCYAKwp7uRsOAbUEYPtoNOt4CmBR
 +7jZtqKmZQ1nHc0APqku2ZI/BnDpVjXYiOJQ+2BqgdEURZIEdRB2vSA3zLsoIZyc7gYb8ThV
 SsDxobHNcpaUN+xuHN3U8igRzK3/A2N5J+z4boKzweamPH+PD212YUXZwW9vLuNsR8PmMDn9
 BMsBsHRBy2HZEk4bGra6toFTOWlbnAgr87SbTUPqAoCafg1gHX7wYmfOZlKcioJ63Z9bgt3w
 684ajLXzYdbaBMbaebCxcJv3wh9qbxAsW8O+Z8nExvCQomGP8TC7oBEAMwc6wVVgr3lpNs1L
 5Vj2hpkLKVyNSY5TtrDiOcniAVh7x+UG4FYBa0ahiotkVB6KQ3Im8f+DR8TH6cDm8zgGNYKx
 kQXnVoCRoBVAEhfu4tmuGWQCnkx69jNGGS9RJsQyqlbgYbrVV7iNVUS86fvkaombu5eru0gk
 cvc6JHITvsGbuVggE1CRUjUTwzAKRrmtw0hzmyQs9f2s0BIrm9CCHz/WLBp+fs1wf0fXktno
 5GxYjstdcWre68II0vAij3v6GxFfa+CHd6/49ZxqX1bz35vi/+V6fvGR/x69ryh4RjYdeKYv
 cn6Hf1naUd7+ujpf3ok1mHWqKX+f2B4k8r08nkFe8v3V8LjgLzyrzt/MLz+pDxsP3m1VmSIQ
 g3dT6sbEMfb6mMYMiaSjedo8oGjNm5wtP5nKe3A25J+2paPa09r1fKvAdZv63KA5OnvlracL
 /mcMnj2DTu6rhbpi348srLPuZWb0LwbM7A0dXjnXtFKql17f33C8+njvnqaUe8wUmXzs0ufp
 RwIlYa98sKC9cuuCk10od+eykKOKkro54kqV9D+VmoMoxQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7bCSvK4Ny8kUgyOHBCzWnzrGbNE04S+z
 xeq7/WwWrw9/YrSY9uEns8WTA+2MFpef8Fk82G9vsffdbFaLmwd2MlnsWTSJyWLl6qNMFpMO
 XWO0eHp1FpPF3lvaFgvblrBY7Nl7ksXi8q45bBbzlz1lt+i+voPNYvnxf0wWhyY3M1nseNLI
 aLHu9XsWixO3pC0ed3cwWpz/e5zV4vePOWwOMh6Xr3h77Jx1l93j/L2NLB6bV2h5XD5b6rFp
 VSebx+Yl9R67bzaweSzum8zq0dv8js3j49NbLB7v911l8+jbsorRY/Ppao/Pm+Q8Nj15yxQg
 EMVlk5Kak1mWWqRvl8CVcWL/Z8aCCVwVSw+dZGlg/MLexcjJISFgIrHuwG/mLkYuDiGB3YwS
 LyZNg0pISiz7e4QZwhaWWPnvOTtE0RNGiWX9K1hAEiwCKhLNcy8DFXFwsAloS5z+zwESFhFQ
 knj66iwjSD2zwHI2iQWXN4ANEhawkji74yEjiM0rYCYxafMlJoihDxglej7dYINICEqcnPkE
 bAEzUNG8zQ/BFjALSEss/we2gBNo14vHd8EOFRWQkZix9CvzBEbBWUi6ZyHpnoXQvYCReRWj
 ZGpBcW56brFhgWFearlecWJucWleul5yfu4mRnDK0NLcwbh91Qe9Q4xMHIyHGCU4mJVEeKV/
 H08R4k1JrKxKLcqPLyrNSS0+xCjNwaIkziv+ojdFSCA9sSQ1OzW1ILUIJsvEwSnVwLRRRvvt
 jTsc388q2D+55KOQYXOwcfOeS+eM/yRb5P7wKWYtk1VWytf+GyZ0dV6cqJuU2J5DWy7efrTi
 +YRzr2OuXvxpd1ihqNB5oVf1+/9m4epam478m31wguKimAe7VIW9zryOD7K+ELqP137lmauH
 3mowp69yXVK8v0i5c+cx5aTCI/I15g8knt15Xvh2yikB05VLPOwXMk/84np3Qfud10kuF0/8
 T4/4/XrvjAXvZPT0WFvXVh/xXrZ0Uc3B8lkGnd/OWaQbvlZbLfWxl3nb67NTcqSe8VwvXHKo
 e57zR4tj9TuXZJ1T2Nv9vsBL+fO2pc0XH6x7Lf6nq1mn8DhD9valXcYix5O+HFRfc7zslRJL
 cUaioRZzUXEiADYZ85yIAwAA
X-CMS-MailID: 20230801131020epcas5p39ed61d99f4711bb3275c06db551abe96
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230627184020epcas5p13fdcea52edead5ffa3fae444f923439e
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184020epcas5p13fdcea52edead5ffa3fae444f923439e@epcas5p1.samsung.com>
 <20230627183629.26571-4-nj.shetty@samsung.com>
 <20230720075050.GB5042@lst.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v13 3/9] block: add emulation for copy
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: Vincent Fu <vincent.fu@samsung.com>, linux-doc@vger.kernel.org,
 djwong@kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, nitheshshetty@gmail.com, willy@infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_17c6a_"

------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_17c6a_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/07/20 09:50AM, Christoph Hellwig wrote:
>> +static void *blkdev_copy_alloc_buf(sector_t req_size, sector_t *alloc_size,
>> +		gfp_t gfp_mask)
>> +{
>> +	int min_size = PAGE_SIZE;
>> +	void *buf;
>> +
>> +	while (req_size >= min_size) {
>> +		buf = kvmalloc(req_size, gfp_mask);
>> +		if (buf) {
>> +			*alloc_size = req_size;
>> +			return buf;
>> +		}
>> +		/* retry half the requested size */
>> +		req_size >>= 1;
>> +	}
>> +
>> +	return NULL;
>
>Is there any good reason for using vmalloc instead of a bunch
>of distcontiguous pages?
>

kvmalloc seemed convenient for the purpose. 
We will need to call alloc_page in a loop to guarantee discontigous pages. 
Do you prefer that over kvmalloc?

>> +		ctx = kzalloc(sizeof(struct copy_ctx), gfp_mask);
>> +		if (!ctx)
>> +			goto err_ctx;
>
>I'd suspect it would be better to just allocte a single buffer and
>only have a single outstanding copy.  That will reduce the bandwith
>you can theoretically get, but copies tend to be background operations
>anyway.  It will reduce the required memory, and thus the chance for
>this operation to fail on a loaded system.  It will also dramatically
>reduce the effect on memory managment.
>

Next version will have that change.

Thank You,
Nitesh Shetty

------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_17c6a_
Content-Type: text/plain; charset="utf-8"


------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_17c6a_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------nvFln8z3L_krFSQI_duuyTsYVGNcxCMU6qftyQwhOSKtHzaF=_17c6a_--

