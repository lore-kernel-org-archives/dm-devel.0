Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 726FEC77B6E
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680157988;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=caIo8yBnLU4XNMs6+PbfKiXH5otFLtL49WZYmbKK86o=;
	b=UxkZk2fY5e5ypxy7sXKBcT61ScopaAoiIEuFImWix8uaHwBx0dICoHn0D3CNeeYKvt1C2e
	6iINgQqlnQ2fRNPvrq8waqYIl+iqAtd8zyPXeXgbKaxRxq/1y0c9MCK8ObP+ng6jeu7zXK
	bAZbB50C8frzAaw2oSHDWnRFHQDvbnA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-127-dhsn5jCLMd6EbxJF2RJ8Xw-1; Thu, 30 Mar 2023 02:33:06 -0400
X-MC-Unique: dhsn5jCLMd6EbxJF2RJ8Xw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6978185A7A8;
	Thu, 30 Mar 2023 06:33:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B33402027040;
	Thu, 30 Mar 2023 06:33:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1E0F019472DF;
	Thu, 30 Mar 2023 06:33:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3A91A1946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 15:32:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2C9A1492B01; Wed, 29 Mar 2023 15:32:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2503D492C3E
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:32:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2089818056AB
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:32:02 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-lQmYu2fNM0u4WWT4DxfPhA-1; Wed, 29 Mar 2023 11:31:51 -0400
X-MC-Unique: lQmYu2fNM0u4WWT4DxfPhA-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230329153146epoutp01a3de614e849fe780caa0a7b251db27c0~Q7Zn3PIc01615916159epoutp01O
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 15:31:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230329153146epoutp01a3de614e849fe780caa0a7b251db27c0~Q7Zn3PIc01615916159epoutp01O
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230329153145epcas5p35b6fdeb14808610a8be55f99ff00fab3~Q7ZnBqelD2866228662epcas5p3c;
 Wed, 29 Mar 2023 15:31:45 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4PmrBS0h0xz4x9Pt; Wed, 29 Mar
 2023 15:31:44 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 65.DD.10528.FD954246; Thu, 30 Mar 2023 00:31:43 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230329123527epcas5p19f78611d6900111716a43a3c4286c5e7~Q4-rYhrYm1108811088epcas5p18;
 Wed, 29 Mar 2023 12:35:27 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230329123527epsmtrp1161d3c81b432a24ee110b1121b0de50c~Q4-rXY9h81008710087epsmtrp1S;
 Wed, 29 Mar 2023 12:35:27 +0000 (GMT)
X-AuditID: b6c32a49-e75fa70000012920-cc-642459df9d3a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 84.F7.18071.F8034246; Wed, 29 Mar 2023 21:35:27 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230329123524epsmtip1138b35b1bdc68767a1329c754dfb5ae9~Q4-oYsfK82800228002epsmtip1c;
 Wed, 29 Mar 2023 12:35:24 +0000 (GMT)
Date: Wed, 29 Mar 2023 18:04:44 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20230329123444.GA3895@green5>
MIME-Version: 1.0
In-Reply-To: <03c647ff-3c4f-a810-12c4-06a9dc62c90e@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfUxTZxTG8957e7llAy8F5AU2JZcxAw5oR8suDsYWjbmTmREF2VwUG3oD
 SFualk43E4ZzwCATCoJKp8A2RcEFQqmMr06sAaTKYONrIF8jYCKgfGwKrAIrXFz873ee85y8
 7zknh0AFF+w8iERlCqtWSuUUbo/V3vH18x/99A2ZcOTyLrrK0orSX+tWUPrGcC5OT99ZAPT5
 uWWUtnZ0orTpyfc8eqC5HqGbfsxH6PIbLQjd+MM8QresPcbpfHMfoCd79QhtGtxJN5naMbq7
 4RJOl5RN2tHmc2cQum7iNKArp2cx+u6gJ9250sZ7343p7olg9KMdOFOvH7ZjOkeqMaa7Q8sY
 KrJwpubKV0zjQBrOnD3zxGZIH+Uxs7/24kyOsQIwNfdOMX8btjGGicdI5JbDSaEJrFTGqr1Y
 ZVyyLFEZH0ZFHIzdHSsJFor8RSH0O5SXUqpgw6g9H0X6702U20ZAeX0ulWttUqRUo6EC3wtV
 J2tTWK+EZE1KGMWqZHKVWBWgkSo0WmV8gJJN2SUSCt+W2IzHkhLMl2Yw1czWk8NllWgamHPK
 BnwCkmJYUriGZgN7QkA2AthvyrbjggUAx7sMGBc8A7D50Z+8bEBslGTm8derBaQJwOfXnTjP
 BICWmae89QRG+sAG4+KGHyd3wntrxLrsQkrg4+/SsXVGyTIenB3asDuTUfB8z5jdOjuQfnC1
 9Q/AsRNsL5rY8PPJvXBhdHXD70p6w+baNmT9XUjW8OFSda8d184e+OzmRZRjZzjVZtzUPeCj
 3IxNPgHLC67jXPE3AOr79YBLhMN0Sy7K/S4RppvyMU5/HRZaKhFOd4RnrRMIpzvAuuIX7A1/
 rirFOXaHfYunN5mBupUrmyPtR2Dx5DKmA9v1L3Wnf+k9jt+CpY0LuN42PJT0hNdWCQ59YVVD
 YCngVQB3VqVRxLMaiUqkZE/8v/C4ZIUBbFyI34d1YHhsLsAMEAKYASRQysXB2kfJBA4y6Rdf
 surkWLVWzmrMQGJbVh7q4RqXbDsxZUqsSBwiFAcHB4tDgoJFlJvDjrD2OAEZL01hk1hWxapf
 1CEE3yMNKQxxbvCc6CrBrmZFlSiWfwoURL9acGh/xlQ6Y4z+uPyVcGNrvs7icHnfay1XhZ88
 XOx9ntpoyQjfFi25VVy8UC5Zi0LlMb8trZXFiOTK0eMKRXYoVN46mvdu5uzyVLFAp629Tekm
 ne4uNMUpLD2p47PH662f+R6bLr5QxX+zqilL8wsLC3us6L8X/TNLqx29bh445H2/TfvXQaP7
 kUHX2x98W3tYuf1B+7WynAMJLkP7jGOZMquvwbvraX1O4MkdQ85Fv88v+WwZqdASVp6LdDLe
 L8qU1y32CZs/4tjndnSrfUzB+P7UwlMRA2JZ84OHVJCRsOBFvtNOnSWt/ySeux9EYZoEqcgP
 VWuk/wGpNaFjqgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02RWUwTURiFc2em0ylKHAqGKxhNqiSKrEaTS0Jc4sIoPLiGaIxY6YgoLU1r
 BcVo2VzADURSBokWjUhVVERkaQVaBUuDiKgshkVEXAgUaxRRW6Wg0bcv/znne/kpXNhOeFGx
 sn2sQiaOE5EuRLlJNMv/TNBcSdD7jxDdaqzHUcpZO46ud50h0aDJBlDuyBiOfjQ148gwnM9D
 HbWVGNIXZmOo+PojDFVrP2Ho0a8hEmUbXwL09gWHIUPnAqQ3mAnUWnWBRBevvuUj47lUDFX0
 JwNUMmgl0ONOb9Rsb+At82Ran4czXE8TyVRyXXymufsOwbQ2qZhS3QmSuXvlCFPdoSaZU6nD
 44X0Hh5jffCCZE6X6QBz15LEfC6dxZT2D2Hrpm11CZWwcbH7WUXgkh0uu1s4Gykv9kjUFqfx
 1KB+WgagKEgvgseyBBnAhRLS1QAWphWCDCAYv8+AV+0P8Ul2h8WOd/zJUh+AYz9HCWdA0D6w
 qmyU5xSR9AJo+UU5zx70Yjh0Mn2igtM6Huyu8neyO70J5j7v5TvZlfaFjvpnYNLZhkHHUe2f
 wA2a8/r/jH1hu+MD5vTjtDcsckz4BfRqaOtx8Jw8nZ4Da8sbsLPAjftvzf235v6tLwFcB2aw
 cqU0RqoMlgfL2IQApViqVMliAqLjpaVg4vm+8yvAfd1IgBFgFDACSOEiD9cfL0USoatEfOAg
 q4iPUqjiWKUReFOEyNP1aYY5SkjHiPexe1lWzir+phgl8FJjy0dLfOruGR8nZZUtfNfrIbH4
 1dRk7uxNNkeUDDFj/tr1pzfn2wcqB+pS3m+/EtcGxAXZn6oz16qx3HBST0xdrAm5XLt0unam
 Z81C/ZgmVhgfbU9Pk/PJn+qIqMyqyBUrWmbro/eENK75tqwrb6Z1w6Cpz3GtQmrbn+ijCc1c
 0lLAYTGhmqLDD78riloMi9rnmSwVtYHXIr03iueav0rbSnIirHNeqwwai9/KTnd+Wt9OS07A
 KiwnsnBq58rzz5K+qHhh4VMEbxLdygcab9tYzy2yJ2t3jbxKiOL8biZuOy7SBt4wDTvYlL7+
 1LAir6xDq5Kt7XV1x+8nBTXUq7ZFiwjlbnGwL65Qin8D0vJpxWsDAAA=
X-CMS-MailID: 20230329123527epcas5p19f78611d6900111716a43a3c4286c5e7
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230327084216epcas5p3945507ecd94688c40c29195127ddc54d
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084216epcas5p3945507ecd94688c40c29195127ddc54d@epcas5p3.samsung.com>
 <20230327084103.21601-2-anuj20.g@samsung.com>
 <e725768d-19f5-a78a-2b05-c0b189624fea@opensource.wdc.com>
 <20230329104142.GA11932@green5>
 <03c647ff-3c4f-a810-12c4-06a9dc62c90e@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: Re: [dm-devel] [PATCH v8 1/9] block: Introduce queue limits for
 copy-offload support
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
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----20UT-5VtB2RXxRyC_PhwUj8OofNvbA-fDS5AX-3x2UrzL_bJ=_1191b7_"

------20UT-5VtB2RXxRyC_PhwUj8OofNvbA-fDS5AX-3x2UrzL_bJ=_1191b7_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Mar 29, 2023 at 09:24:11PM +0900, Damien Le Moal wrote:
> On 3/29/23 19:41, Nitesh Shetty wrote:
> >>> +What:		/sys/block/<disk>/queue/copy_max_bytes
> >>> +Date:		November 2022
> >>> +Contact:	linux-block@vger.kernel.org
> >>> +Description:
> >>> +		[RW] While 'copy_max_bytes_hw' is the hardware limit for the
> >>> +		device, 'copy_max_bytes' setting is the software limit.
> >>> +		Setting this value lower will make Linux issue smaller size
> >>> +		copies from block layer.
> >>
> >> 		This is the maximum number of bytes that the block
> >>                 layer will allow for a copy request. Must be smaller than
> >>                 or equal to the maximum size allowed by the hardware indicated
> > 
> > Looks good.  Will update in next version. We took reference from discard. 
> > 
> >> 		by copy_max_bytes_hw. Write 0 to use the default kernel
> >> 		settings.
> >>
> > 
> > Nack, writing 0 will not set it to default value. (default value is
> > copy_max_bytes = copy_max_bytes_hw)
> 
> It is trivial to make it work that way, which would match how max_sectors_kb
> works. Write 0 to return copy_max_bytes being equal to the default
> copy_max_bytes_hw.
>
> The other possibility that is also interesting is "write 0 to disable copy
> offload and use emulation". This one may actually be more useful.
>

We were following discard implementation.
I feel now both options are good. We can finalize based on community feedback.

> > 
> >>> +
> >>> +
> >>> +What:		/sys/block/<disk>/queue/copy_max_bytes_hw
> >>> +Date:		November 2022
> >>> +Contact:	linux-block@vger.kernel.org
> >>> +Description:
> >>> +		[RO] Devices that support offloading copy functionality may have
> >>> +		internal limits on the number of bytes that can be offloaded
> >>> +		in a single operation. The `copy_max_bytes_hw`
> >>> +		parameter is set by the device driver to the maximum number of
> >>> +		bytes that can be copied in a single operation. Copy
> >>> +		requests issued to the device must not exceed this limit.
> >>> +		A value of 0 means that the device does not
> >>> +		support copy offload.
> >>
> >> 		[RO] This is the maximum number of kilobytes supported in a
> >>                 single data copy offload operation. A value of 0 means that the
> >> 		device does not support copy offload.
> >>
> > 
> > Nack, value is in bytes. Same as discard.
> 
> Typo. I meant Bytes. Your text is too long an too convoluted, so unclear.
>
Acked, will update in next version

> -- 
> Damien Le Moal
> Western Digital Research
> 
> 

------20UT-5VtB2RXxRyC_PhwUj8OofNvbA-fDS5AX-3x2UrzL_bJ=_1191b7_
Content-Type: text/plain; charset="utf-8"


------20UT-5VtB2RXxRyC_PhwUj8OofNvbA-fDS5AX-3x2UrzL_bJ=_1191b7_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------20UT-5VtB2RXxRyC_PhwUj8OofNvbA-fDS5AX-3x2UrzL_bJ=_1191b7_--

