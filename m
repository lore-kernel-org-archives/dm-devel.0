Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EA33C001B0
	for <dm-devel@archiver.kernel.org>; Mon, 14 Aug 2023 11:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692011105;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=IugCiMFZngBXGOH0r8pr7KBGvDpBx2yRYshuGEuwD1w=;
	b=EjIsuYjcMJtEPz09JS3PN9puQeDu9F+6vLP+CoZBnCUrapehka5jbleEB9Eau8d/pcN+Zl
	1LrFXwT39HSsiz0k7oNxvvkbB1G0X+nS9m9ymdv0kQ9UdaTpTsHADWOfWTxjbJx20NR3Ey
	ik5eOlPpRbc4a4p5lgBRoSUHfWrvMk0=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-367-bHfvSUTBPGOHD-JGNPiZnA-1; Mon, 14 Aug 2023 07:05:00 -0400
X-MC-Unique: bHfvSUTBPGOHD-JGNPiZnA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16D163C108C4;
	Mon, 14 Aug 2023 11:04:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2E34340D2839;
	Mon, 14 Aug 2023 11:04:53 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D6DA01946587;
	Mon, 14 Aug 2023 11:04:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1CD2E1946586
 for <dm-devel@listman.corp.redhat.com>; Mon, 14 Aug 2023 11:04:46 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C4F1A4021C8; Mon, 14 Aug 2023 11:04:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BBEF2401E6A
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 11:04:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90A0C3806706
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 11:04:41 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-PKzAjOEEMaWeqngFFps7ng-1; Mon, 14 Aug 2023 07:04:39 -0400
X-MC-Unique: PKzAjOEEMaWeqngFFps7ng-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20230814110436epoutp02c300c678ff0f5a7e387185bea0a9fd17~7Oxvl4oiI3050230502epoutp02N
 for <dm-devel@redhat.com>; Mon, 14 Aug 2023 11:04:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20230814110436epoutp02c300c678ff0f5a7e387185bea0a9fd17~7Oxvl4oiI3050230502epoutp02N
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230814110435epcas5p439e065a790dea8509bce6fb988775511~7Oxu9c-JP2023920239epcas5p4V;
 Mon, 14 Aug 2023 11:04:35 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4RPWkS6hHXz4x9Pp; Mon, 14 Aug
 2023 11:04:32 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
 BA.7E.55173.04A0AD46; Mon, 14 Aug 2023 20:04:32 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230814103355epcas5p114de1c2977fe97f8281218a25ef3a6dd~7OW9zWzlA0591305913epcas5p1q;
 Mon, 14 Aug 2023 10:33:55 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230814103355epsmtrp2af3e2c51166a8e225642c7d02bb42bed~7OW9yaU--1787017870epsmtrp2j;
 Mon, 14 Aug 2023 10:33:55 +0000 (GMT)
X-AuditID: b6c32a50-df1ff7000001d785-c7-64da0a409dcb
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 BC.02.14748.3130AD46; Mon, 14 Aug 2023 19:33:55 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230814103352epsmtip1bfa9454f6fc7f53da273f13b70b179e0~7OW6ddTKg0808008080epsmtip1p;
 Mon, 14 Aug 2023 10:33:51 +0000 (GMT)
Date: Mon, 14 Aug 2023 16:00:29 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Bart Van Assche <bvanassche@acm.org>
Message-ID: <20230814103029.mc5l4wt6y6dzf7db@green245>
MIME-Version: 1.0
In-Reply-To: <2e263977-0ee7-ae78-5a8a-2a67df43df76@acm.org>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfVRTdRjH+917t91RoxuC/QRRzqJSFNgM1uUt8ER1Cz1xjsc60UGc7MaI
 sa29iMAfEgkoCJJgySLAo4KOtyRCWixoCIt5kDrIcjPfatgJcIDg0DxQYxc6/vd5vuf5/n7P
 y3lw1KeM449nyjW0Si6W8dleWFf/5pDQBC+7RKC3C8h2yyBKFlYuomTzjWNscrL/PiC/mHmE
 ko6+EkDe7o0njc6vWKSt73uEPN88gJDHTVZAjo/pENJo30KeKj6DkT3GIYwcNdSyyfrGcQ7Z
 ZF5CyGuV44Bsm5zGyJ/tAeTIopmVsJYavZpEjdy8gFGjw1qqQ3+ETX175iD1g62ATZ2uqGJR
 5Z852dTsuB2jpn8cY1MVnXpAzXVsoDoc95BkXkpWrJQWS2hVEC1PV0gy5Rlx/KRdaa+nRYoE
 wlBhFPkqP0guzqbj+Ik7kkPfzJS5e+YH7RfLtG4pWaxW88Nfi1UptBo6SKpQa+L4tFIiU0Yo
 w9TibLVWnhEmpzXRQoFgW6Q7cW+WdMzYwVH+yjpg6Z3ACsAEVgq4OCQi4K3jerQUeOE+RA+A
 81MWNhPcB7DpWuNK4ALQ8tcsumpxlTdyltmHMAI48/tuJukugDeqznnexYgXYX1vm5txnE1s
 gZf/xZdlX2ITdN1uwpbzUaKGBbta6jyPriHehgbnsMfLI0TwutPAYfg5OFTj8OhcIgbWdPay
 l9mPWA9Pnn3gqRsSp7mwteEqi6kuEXbOWAHDa+CEuZPDsD+ccxrZDOfA89Xn2Iz5EIC633Qr
 hnhYZDnmqQglpLDa2rdiCIQnLG0Io3vD8scOhNF5sLtulV+ALe0NK/nroHXh0xWmYG2tE2FG
 NANgxZ8utBJs1D3Rne6J/xiOhkdmClk69/RQIgA2LeEMbobthvAGwNIDf1qpzs6g0yOVwlA5
 nfP/ztMV2R3AcxUhyd2g+ZvFMBNAcGACEEf5vjz7W1aJD08izs2jVYo0lVZGq00g0r2uz1F/
 v3SF+6zkmjRhRJQgQiQSRUS9IhLyn+dNFn0t8SEyxBo6i6aVtGrVh+Bc/wLkZb8N0bnTo9mD
 toCeFvE/e27h/Re2OQae0dxFjxIKE7VAZ3JyLpVyvQqP7p26+O5l1SXL9jvcra5oGYcaKUNK
 HLP27g8eCD+p/MWABZb1z1uulOQZDtlifJ9NLKiXid85HPNQO591k2JVh39n3aGPHfjj8MmB
 e5qzsx+y+INLPD9zcXDqvoS+2oSC0uiPh77MXxhoS+6Py3nv/U2NxVOaiq7uEz8N7bl+aue6
 lrXSkeDA7um6opSD+ovBxevr5raGUtur9uc3Xck/EDxi2vX3dMUdwfyw+Y2Up/a5WKnawbKd
 1t3hrTZRbS7CSlXXeH/0+OmXbI/8kmoemnvzWuNbvbzbRXxMLRULQ1CVWvwfmf2HcJ4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsWy7bCSnK4w860Ug4P/NSzWnzrGbNE04S+z
 xeq7/WwWrw9/YrSY9uEns8WTA+2MFg/221vsfTeb1eLmgZ1MFitXH2WymHToGqPF06uzmCz2
 3tK2WNi2hMViz96TLBaXd81hs5i/7Cm7xfLj/5gsbkx4ymix7vV7FosTt6Qtzv89zuog5nH5
 irfH+XsbWTwuny312LSqk81j85J6j903G9g8FvdNZvXobX7H5vHx6S0Wj/f7rrJ59G1Zxejx
 eZOcx6Ynb5kCeKO4bFJSczLLUov07RK4MjY0X2EqaGaueHftDVsD4zamLkZODgkBE4lvvcvY
 uxi5OIQEdjNKrLv2GCohKbHs7xFmCFtYYuW/51BFTxglVm99xAaSYBFQlZi/fx1LFyMHB5uA
 tsTp/xwgYREBDYlvD5azgNQzC8xllVj2+zw7SEJYwFNi17uzLCA2r4CZxO13u8DiQgIfGCWu
 PbeEiAtKnJz5BKyGGahm3uaHzCDzmQWkJZb/A5vPKWAtMXPLfrATRAVkJGYs/co8gVFwFpLu
 WUi6ZyF0L2BkXsUomVpQnJuem2xYYJiXWq5XnJhbXJqXrpecn7uJERzdWho7GO/N/6d3iJGJ
 g/EQowQHs5II7y33aylCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ1nzE4REkhPLEnNTk0tSC2C
 yTJxcEo1MN1YuOKnZ9yKdUyih3XvPQv0+JISmJL2u/O68ybNENZ/HrsXK+Zs3/Pf6tKXy4ab
 Zba5smxT32/6UkST4ejM/5Z3BRaUrS14kF1Vveqro/TUFZNTkkybPK4rRXzZ33xT5pty7M2y
 u2/cNz+6cklKNIe74MWS57ILzHO3NSdn/bj2xnhy29uZi9Ncwy5VbDw2QeD6xKP/e1V8W9/M
 9a+YsP3FhVObTgffvp+7lf3LHqez4SYmNcEzLt/Yf323I1NLhbHbCcXVoh9eVwj//OjBaM9e
 PatA8peP0MKrHrZPmj/d2286N0i4InB6HserhHP7j+Srd3Bxq0VN7m/bulRBQO2LqthX2Xzd
 yYJsSnXeM84osRRnJBpqMRcVJwIAvUnskl0DAAA=
X-CMS-MailID: 20230814103355epcas5p114de1c2977fe97f8281218a25ef3a6dd
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230811105659epcas5p1982eeaeb580c4cb9b23a29270945be08
References: <20230811105300.15889-1-nj.shetty@samsung.com>
 <CGME20230811105659epcas5p1982eeaeb580c4cb9b23a29270945be08@epcas5p1.samsung.com>
 <20230811105300.15889-4-nj.shetty@samsung.com>
 <2e263977-0ee7-ae78-5a8a-2a67df43df76@acm.org>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v14 03/11] block: add copy offload support
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
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 martin.petersen@oracle.com, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
 linux-doc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, dlemoal@kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 mcgrof@kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_545fc_"

------2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_545fc_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/08/11 03:06PM, Bart Van Assche wrote:
>On 8/11/23 03:52, Nitesh Shetty wrote:
>>+		if (rem != chunk)
>>+			atomic_inc(&cio->refcount);
>
>This code will be easier to read if the above if-test is left out
>and if the following code is added below the for-loop:
>
>	if (atomic_dec_and_test(&cio->refcount))
>		blkdev_copy_endio(cio);
>
Acked

Thank you,
Nitesh Shetty

------2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_545fc_
Content-Type: text/plain; charset="utf-8"


------2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_545fc_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------2jlpTr02XJ1Dz0Ro0nWDo60KkQ.efMTj2bJXEJ.ys0a_1.o3=_545fc_--

