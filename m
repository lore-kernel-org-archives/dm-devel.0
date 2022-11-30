Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B02BAC4321E
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 08:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669795305;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=+vLDNn5jm/4YFXUv3KB9Gi1PTv/brxoHQTe+dmsy4a8=;
	b=HGOxnEyGG6oOgPoQj9RKL9I0TwM9rxCL68jtHR5+J3LjiJcxF6+vsO56l2dgdDwkfGH3e1
	2gOXg61mDg3fkavRhMCMcovqMllU13F8Y5JANd+R0r97YzFTRt4MN2BuNOVT90aUu4MWD4
	PAxpKyMC8Tuz/gQavpaVZsE0gCprRpM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-fhiZOOMaOlyrjDxLaWS2ag-1; Wed, 30 Nov 2022 03:01:39 -0500
X-MC-Unique: fhiZOOMaOlyrjDxLaWS2ag-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 204C7101E148;
	Wed, 30 Nov 2022 08:01:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 80B9C202343B;
	Wed, 30 Nov 2022 08:01:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 18F941946A6F;
	Wed, 30 Nov 2022 08:01:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2528A19465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 04:34:32 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EFBB0C15BB4; Wed, 30 Nov 2022 04:34:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E7C99C15BA4
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 04:34:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CC6FB185A794
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 04:34:31 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-359-IPkrdbx_NPKR79T_an2Pzw-1; Tue, 29 Nov 2022 23:34:29 -0500
X-MC-Unique: IPkrdbx_NPKR79T_an2Pzw-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20221130043426epoutp0455acadcc67b0ffad42452e4e209bca3b~sQquqTa3L1783117831epoutp045
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 04:34:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20221130043426epoutp0455acadcc67b0ffad42452e4e209bca3b~sQquqTa3L1783117831epoutp045
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20221130043426epcas5p14146e3fe701874a0fae62fd456c6b9e6~sQqt6rutC0431904319epcas5p1K;
 Wed, 30 Nov 2022 04:34:26 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4NMRDq5fljz4x9QB; Wed, 30 Nov
 2022 04:34:19 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 05.0A.39477.B4DD6836; Wed, 30 Nov 2022 13:34:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20221130042855epcas5p28a892bc5d2b37a713a71b7fa55133095~sQl5zOb2G2276422764epcas5p2n;
 Wed, 30 Nov 2022 04:28:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20221130042855epsmtrp2cb2597a35f998d3be03227f0c7a35ecf~sQl5wmr1z2076220762epsmtrp2h;
 Wed, 30 Nov 2022 04:28:55 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-be-6386dd4b5f56
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 4A.90.18644.70CD6836; Wed, 30 Nov 2022 13:28:55 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20221130042850epsmtip215b5fc4dce992794a71b94362d374fe2~sQl1dJQ-21697616976epsmtip2R;
 Wed, 30 Nov 2022 04:28:50 +0000 (GMT)
Date: Wed, 30 Nov 2022 09:47:28 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20221130041728.GB17533@test-zns>
MIME-Version: 1.0
In-Reply-To: <b22652ee-9cca-a5b1-e9f1-862ed8f0354d@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf0xTVxTHd9/rjwdSfAJ1VxqBlGECDGgZ4GWBOTdinjIjY3PZjxD2Ul4o
 obRdWxCNbhVpyZgoEFmgMmEgA8HBBOaACpI6VmBiRQIKk18LxUwH8ivZBkNX+mDxv8855/u9
 55x7cwnco4jvTaQpdYxGSSvEPFfO9VuBgSHx40aZpLdehJr6f8FRTuE6jhrGz/PQ2oANR53z
 F7lotLsdQ1caejBk/nYRQz3P53hoemWMg4otIwDZh00Y6hwLRjc6+zhoqKOchyq+s/NRkbWF
 i9pmTgO0XJPLR41PnnJQ75gI2dat3Dd3UqbJAR7VbhrnU7aJaxxqaCCTaq7/kke1XP6CMo/q
 eVTBmXmHwDDJpZ52DfOoc631gFpu9qHyur/CqOaZOSzB/eP0GDlDpzAaP0YpU6WkKVNjxfHv
 Jb+dHBklkYZIo9FesZ+SzmBixXHvJIQcSFM4Vhf7ZdGKTEcqgdZqxWFvxGhUmTrGT67S6mLF
 jDpFoY5Qh2rpDG2mMjVUyehel0ok4ZEO4afp8pwaO0d9hp89Vd7C14Nhbj5wISAZAf+uXODk
 A1fCgzQD2Ge7zWeDJQAXqvI3g2UAf77xFN+yfFPRzmULHQBOVdk2/bMAdiyWOlUcMgCu/zOB
 5QOC4JHB8NfnxEbai4yEc2cNTj1OPsRhiaWGv1HwJOPhUE6DkwVkCGydfIizvAP2lc1wNtiF
 PABv38tzDi4k/WH3dSu2cRAkq13gH4M/cjeaQTIO5hccYSf1hI+trXyWveHyfCeP5WPwyoU6
 HuvNBdB03wTYwj5o6D/vbIyTcji/Nrtp2A1L+hsxNu8OC9ZmMDYvgG2XttgfXm2q3NTvgiN/
 nd5kCk7+1gbYGyrF4cqfRn4h8DW9sJzphX4svworzUsOJhwsgrXPCBYDYVNHWCXg1oNdjFqb
 kcpoI9XhSubY/08uU2U0A+ffCDrUBqanFkItACOABUACF3sJFhMNMg9BCn38BKNRJWsyFYzW
 AiIdj1WEewtlKsfnUuqSpRHRkoioqKiI6NeipOKXBdWlQTIPMpXWMekMo2Y0Wz6McPHWY/vt
 3OOrxZKCrwtnT2X7usk/Ip8YRmN6/RV2Zm+Sj+ycqtdSljTp82gkYE9hL7QN3H2lQ+R7Lbtx
 Kq9qJRd3MyzUbsuqGfzsoq0g90EqVMVkhyw/mBCmxwC97i5N7yGyPji4+uiw3dpTccjaY/xX
 H7h/+NJVPTFg9zrh+9MOyxwdf+fkzaSKxmpPqut781xx+7Ok99NFHnn2o4dz7jTlxL1U//n9
 Ct+DiYG9brXCnUm3SkXyNqGhpPz3y8g7ZTA+YHes6OQnif2Pj4SF63/I2U6dNW9jFvYZ3+0L
 a5ySLt3cXiZ468K0UZgpQHUf1vkN8FeNLcHBwnuRXUcDQt1PuWrEHK2clgbhGi39HwPz2YSk
 BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsWy7bCSvC77nbZkg68buCzWnzrGbNE04S+z
 xeq7/WwWv8+eZ7bY+242q8XNAzuZLFauPspksXvhRyaLo//fslk8/HKLxWLSoWuMFk+vzmKy
 2HtL22LP3pMsFpd3zWGzmL/sKbvFxOObWS12PGlktPi8tIXdYt3r9ywWJ25JW5z/e5zVQcxj
 1v2zbB47Z91l9zh/byOLx+WzpR6bVnWyeWxeUu+x+2YDm0dv8zuggtb7rB7v911l8+jbsorR
 4/MmOY/2A91MHpuevGUK4IvisklJzcksSy3St0vgyph27Bp7wWGWil9zJrM1MK5j7mLk5JAQ
 MJGYO38naxcjF4eQwA5GiQt75rFAJCQllv09AlUkLLHy33N2iKInjBJ3/z1lB0mwCKhK/P15
 j6mLkYODTUBb4vR/DpCwiICpxNueVrA5zAL3mCVefeIEsYUFvCUuN60Ga+UV0JXYcv8OM8TM
 GcwS/x+uZYFICEqcnPkEqllL4sa/l2DzmQWkJZb/A5vPKeAmceZSOyuILSqgLHFg23GmCYyC
 s5B0z0LSPQuhewEj8ypGydSC4tz03GLDAqO81HK94sTc4tK8dL3k/NxNjOBY19Lawbhn1Qe9
 Q4xMHIyHGCU4mJVEeD8GtSYL8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1
 ILUIJsvEwSnVwCTlEcm6+Z9qokRv97kEPqvld7hOLFpSsNVl1tol9ycbKV+8/WAWv6Xenmjp
 fdqf/Vj/eBo8Ob9wo0+WMpfsL77JpROftHGs/z6Hod+s/G15pm3Ft/8/4z6fMY4O/6XEZ+aq
 cSX5kXjWF26zLZ03e0xWTXMxtd/nU6prmBq+bk+ataVDXUq4zG0uLZlNwvLJnydvDHl/JKKA
 8ZndKt79FRb/mJonx0nWSpRvC6360zXRpOxMsNHj7cdjH7ZMWdAitNjXcmf95dnxlWE5eTEZ
 K23LQ+dusv+1ySlCqEp4k7Lov6VVhyfMvnJr4xymJEEP9Y1fTH4mrLq1dlP2kVte77fbuB48
 eMOM84Yh0JF+SizFGYmGWsxFxYkA8Q6H+GQDAAA=
X-CMS-MailID: 20221130042855epcas5p28a892bc5d2b37a713a71b7fa55133095
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123061044epcas5p2ac082a91fc8197821f29e84278b6203c
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061044epcas5p2ac082a91fc8197821f29e84278b6203c@epcas5p2.samsung.com>
 <20221123055827.26996-11-nj.shetty@samsung.com>
 <729254f8-2468-e694-715e-72bcbef80ff3@opensource.wdc.com>
 <349a4d66-3a9f-a095-005c-1f180c5f3aac@opensource.wdc.com>
 <20221129122232.GC16802@test-zns>
 <b22652ee-9cca-a5b1-e9f1-862ed8f0354d@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mailman-Approved-At: Wed, 30 Nov 2022 08:01:29 +0000
Subject: Re: [dm-devel] [PATCH v5 10/10] fs: add support for copy file range
 in zonefs
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
Cc: axboe@kernel.dk, naohiro.aota@wdc.com, kch@nvidia.com, sagi@grimberg.me,
 joshi.k@samsung.com, gost.dev@samsung.com, anuj20.g@samsung.com,
 snitzer@kernel.org, james.smart@broadcom.com, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk,
 nitheshshetty@gmail.com, kbusch@kernel.org, jth@kernel.org, hch@lst.de,
 agk@redhat.com, p.raghav@samsung.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_80488_"

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_80488_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Nov 30, 2022 at 08:45:55AM +0900, Damien Le Moal wrote:
> On 11/29/22 21:22, Nitesh Shetty wrote:
> > Acked. I do see a gap in current zonefs cfr implementation. I will drop this
> 
> cfr ?
>

yes, will drop zonefs cfr for next version.

> > implementation for next version. Once we finalize on block copy offload
> > implementation, will re-pick this and send with above reviews fixed.
> > 
> > Thank you,
> > Nitesh
> 
> Please trim your replies.
> 

Noted

> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
> 

Thanks,
Nitesh Shetty

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_80488_
Content-Type: text/plain; charset="utf-8"


------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_80488_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_80488_--

