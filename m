Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40CFFC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 15 Dec 2022 12:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1671107723;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=PUdfA2gBHDfm5MQ0i+eT29/FJ28L/TYjS7bN60UoN6A=;
	b=U+EeQa/wbjMv3tyQgQL5YgjM9zbbiDxege+DnuuRB1kbRcW67xz1UZxVS43SHJAl7CazEH
	VeK0gV5tjp7MRZzvRtZJgaQrvAALxoT6UaygnIXr02ksegL/fcyqYXWYHz7Ir7foE+GBVf
	ovUnW7TqDA78VhyTSc+aukhZDN7Qe5U=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-xIwO_HduOL6ClUGGlV4yVw-1; Thu, 15 Dec 2022 07:35:19 -0500
X-MC-Unique: xIwO_HduOL6ClUGGlV4yVw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C232D101B453;
	Thu, 15 Dec 2022 12:35:17 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id C7DC62166B29;
	Thu, 15 Dec 2022 12:35:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B9C1119466DF;
	Thu, 15 Dec 2022 12:35:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D95F51946586
 for <dm-devel@listman.corp.redhat.com>; Tue, 13 Dec 2022 05:16:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BEB222026D76; Tue, 13 Dec 2022 05:16:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B6E272026D68
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 05:16:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 938203802B88
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 05:16:40 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-515-LDCOtwxaMG-cDdvl0z6nfQ-1; Tue, 13 Dec 2022 00:16:36 -0500
X-MC-Unique: LDCOtwxaMG-cDdvl0z6nfQ-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout2.samsung.com (KnoxPortal) with ESMTP id
 20221213051634epoutp02aa16b3f00005fa967cb6d53aa20588ad~wQoNxQiuH0778407784epoutp02E
 for <dm-devel@redhat.com>; Tue, 13 Dec 2022 05:16:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
 20221213051634epoutp02aa16b3f00005fa967cb6d53aa20588ad~wQoNxQiuH0778407784epoutp02E
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20221213051633epcas5p1acad91d5c441ae413be866ef0006e6c6~wQoNOFeCt1665916659epcas5p1v;
 Tue, 13 Dec 2022 05:16:33 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4NWRYW365cz4x9Q2; Tue, 13 Dec
 2022 05:16:31 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 B4.8C.56352.FAA08936; Tue, 13 Dec 2022 14:16:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20221209082824epcas5p1495ea0cd5680031da91328545784dbd7~vEqkTqdW91652516525epcas5p1P;
 Fri,  9 Dec 2022 08:28:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20221209082824epsmtrp2d616e2963ae733260207e0c15aec456e~vEqkSaXUc2823228232epsmtrp22;
 Fri,  9 Dec 2022 08:28:24 +0000 (GMT)
X-AuditID: b6c32a4b-5f7fe7000001dc20-5e-63980aafdd77
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 3B.A8.14392.7A1F2936; Fri,  9 Dec 2022 17:28:23 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20221209082820epsmtip28ebb1c81323d609b832fef7c6b72c53f~vEqhFnDep1568415684epsmtip2z;
 Fri,  9 Dec 2022 08:28:20 +0000 (GMT)
Date: Fri, 9 Dec 2022 13:46:57 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20221209081657.GA6230@test-zns>
MIME-Version: 1.0
In-Reply-To: <Y5B2pCiYsWb5hdrI@T590>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfVCTdRzA/T3bng3uxj3xcvyYqdysRHkbAutHB4WH1VMiUfZH2fGyG49A
 jG3tRQ2vmAolkIJAoqMLpAbICI7JEcgobmqTEcchAY43wQacioC8ZGFAG8/s/O/zfX+7L4fh
 XsrmcdKlKkohFUn4uCuz5fpuv8BG14tiQfUZAjVafmOgU0VrDKQfK8TR055eBuqYK2cha2cb
 hq7ob2Ko/fJjDN3ceISjyeVhJio2DQI0NaDFUMewPzJ2dDFR/7XvcFRRPcVGppLTGDpvvspC
 rbaTAC3pctio4eE8E90a3op618ysaG9Se7cHJ9u0Y2yyd7yJSfb3qElDXR5OXv0xm2y3anDy
 7Ok5u0PuXRY5/8sATp5rrgPkkmE7+XVnAUYabI+weLfDGZFplCiFUvhSUrEsJV2aGsU/cCgp
 JilcKAgJDIlAr/J9paJMKoq/PzY+8K10iX1+vu9RkURtV8WLlEp+8OuRCplaRfmmyZSqKD4l
 T5HIw+RBSlGmUi1NDZJSqtdCBIK94XbH5Iy0618NA7kl8vhE+SCuAaWCfMDhQCIMNszj+cCV
 4060A7iwYWHSwiKAP2lGnMJfANaX5bLygctmxK3iQUAbOgDsNtQ4hWkAJ/42YQ4vJvES/OHB
 DO6ogRP+sHuD41B7Enw4NqZnO5hBaJhwyko42IOIhfnrzbiDuUQA1FZUMWh+AXZdsjEd7GJP
 2d1Xupnei9gJO1vMmKMuJPQucHq1DqO72w81fYXOTj3gA3Mzm2YeXJrrwGk+Bq+U1uJ0cA6A
 2iEtoA1vwFxLIYPuLg2uzM45k26D31oaMFrvBs8+tTn1XNj6/TPeCesbK50FfODgk5NOJuEf
 C7rN/PalYvDCZFYR2KF9bjjtc+VoDoCV7Yu41r47BrEV1qxzaNwNG68FVwJWHfCh5MrMVEoZ
 Lg+VUsf+P7hYlmkAm++x50AruDexEGQCGAeYAOQw+J7cl/0uiN25KaLPsyiFLEmhllBKEwi3
 3+o8g+clltn/S6pKCgmLEIQJhcKwiFBhCN+bqys9I3YnUkUqKoOi5JTiWRzGceFpsPKm3IFL
 q+qS0M9mzJqH7/EFg3HLQvk4yijbsPhvsQSfY1e5VNbo6+4fHi32+2fH6HSs18fLi4Ejx3V7
 TyQXuMasSg4abifWi2tFH3jnbjFyk73rfdpM6yUJOuNQnPcdz6Gc/d37Ck7kjf+ul2RJeQsN
 P7+vMzd/YWs9xKx4xfhnUVKiD3Vv19tmo8+M51o6e1ecDfP9VNt4v1+V0P9RtnXSYo2eZWf6
 j6SvVVfkBdxIaFn+VeB/ubNtsm80tqY/QXinKqgru5bqeSdF2XQwz/P2mx9GH/0kZvabG7xo
 a3vkvwn5j9/NKih7otx+JNr4pc4t+eI2+OKplRxr4pF9HisBGi6fqUwThexhKJSi/wB3NAeB
 pwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Rf0yMcRzH932ep+eejrOnu6zv1XZtD2M6HTe/vowYY4+hobFk1KlHNXeV
 OxE2ndIPZ5XCcFGULtUWLkvcxbnQL+0kF8UxXPLr+kHDlkp3zfjvvffr/f68//hQuNBO+FPx
 Cfs4dYJCyZB8oraBCQy+OlgQPTeLQddaHuEo7eQIjqoceSQabrPhqL6v0At1WW5jqKLqIYZM
 lwcx9HDMRaK3Q90EKrB2AtRj12OovluKzPXNBOq4c4FExYYeHrKeSsdQfmONF6pzHgXoe9kx
 Hqr+0k+gpu4AZBtp9Frhx+rftJHsbb2Dx9pe3yDYjrZk1lh5nGRrrqSypi4tyeak940HMt54
 sf137SSbe7MSsN+NEjbLcgJjjU4XtnFKBH9pDKeM38+p54RE8eOqc55gSbolKWXvzUALXME6
 4E1Bej5sKugEbi2kTQAOfI6Y8MXQMPIAn9AiWDHay9MB/njGCWBv1iDhBgQ9HZZ+7iV1gKJI
 Wgpbxyi37Usz0OGo8uRxOo2ARZ0vSTcQ0euhbvSmRwvo2VBfXIJPHP2FwfJMJ28C+MDm807P
 AE4HwRejnzD3AE4HwPJRz4D3+G5r+2nMrafS06ClthE7CXz0/7X1/7X1/9qXAF4JxFySRhWr
 0siT5AncAZlGodIkJ8TKohNVRuD5fNCsOnCrckBmBRgFrABSOOMrMBjyo4WCGMXBQ5w6MVKd
 rOQ0VhBAEYyf4ImuOVJIxyr2cXs4LolT/6UY5e2vxazmhmydDxJzzILs1huHfweG5Lpqcd7X
 i62uUF72UOGyvVJ+5h0VsTjcN058/cUk/tqtM5deMVssOfjhXaeG7Ns719SVnn2+Z31AOG/s
 1tN7XX2iuy2mDUTeR3ODeO0P0dAWQaCEWLTjR97KD2HXtJGTg/ybJmWVnUuRyOzsoX5HRpTk
 fk0FHgVW9SgFuvx56fOPhA0Xrv4ZfnDddP47+cfFMw3JaDLIYDrq4tjgXWcsZzI5sfaT/H71
 soiYksZZ5ZtPpIaKOkZU7bmSlgjisaxE0r/JnjKQUdRc2Gfc9uxVS7afgZuy28/m/W3nlxlV
 a6T6/IV7pctt65QGU7xwjCE0cQp5EK7WKP4ATwCvr2gDAAA=
X-CMS-MailID: 20221209082824epcas5p1495ea0cd5680031da91328545784dbd7
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123061017epcas5p246a589e20eac655ac340cfda6028ff35
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061017epcas5p246a589e20eac655ac340cfda6028ff35@epcas5p2.samsung.com>
 <20221123055827.26996-3-nj.shetty@samsung.com> <Y33UAp6ncSPO84XI@T590>
 <20221123100712.GA26377@test-zns> <Y3607N6lDRK6WU7/@T590>
 <20221129114428.GA16802@test-zns> <20221207055400.GA6497@test-zns>
 <Y5B2pCiYsWb5hdrI@T590>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Thu, 15 Dec 2022 12:35:07 +0000
Subject: Re: [dm-devel] [PATCH v5 02/10] block: Add copy offload support
 infrastructure
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
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com, hch@lst.de,
 agk@redhat.com, naohiro.aota@wdc.com, sagi@grimberg.me, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, james.smart@broadcom.com,
 p.raghav@samsung.com, kch@nvidia.com, anuj20.g@samsung.com, snitzer@kernel.org,
 linux-block@vger.kernel.org, viro@zeniv.linux.org.uk, kbusch@kernel.org,
 axboe@kernel.dk, joshi.k@samsung.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jth@kernel.org, nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----dP7Qx9dcwq0e3k-gT5OC2TLFeuRm6-MlOT8i1nwxNxOSTL6J=_1f9a1_"

------dP7Qx9dcwq0e3k-gT5OC2TLFeuRm6-MlOT8i1nwxNxOSTL6J=_1f9a1_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Dec 07, 2022 at 07:19:00PM +0800, Ming Lei wrote:
> On Wed, Dec 07, 2022 at 11:24:00AM +0530, Nitesh Shetty wrote:
> > On Tue, Nov 29, 2022 at 05:14:28PM +0530, Nitesh Shetty wrote:
> > > On Thu, Nov 24, 2022 at 08:03:56AM +0800, Ming Lei wrote:
> > > > On Wed, Nov 23, 2022 at 03:37:12PM +0530, Nitesh Shetty wrote:
> > > > > On Wed, Nov 23, 2022 at 04:04:18PM +0800, Ming Lei wrote:
> > > > > > On Wed, Nov 23, 2022 at 11:28:19AM +0530, Nitesh Shetty wrote:
> > > > > > > Introduce blkdev_issue_copy which supports source and destination bdevs,
> > > > > > > and an array of (source, destination and copy length) tuples.
> > > > > > > Introduce REQ_COPY copy offload operation flag. Create a read-write
> > > > > > > bio pair with a token as payload and submitted to the device in order.
> > > > > > > Read request populates token with source specific information which
> > > > > > > is then passed with write request.
> > > > > > > This design is courtesy Mikulas Patocka's token based copy
> > > > > > 
> > > > > > I thought this patchset is just for enabling copy command which is
> > > > > > supported by hardware. But turns out it isn't, because blk_copy_offload()
> > > > > > still submits read/write bios for doing the copy.
> > > > > > 
> > > > > > I am just wondering why not let copy_file_range() cover this kind of copy,
> > > > > > and the framework has been there.
> > > > > > 
> > > > > 
> > > > > Main goal was to enable copy command, but community suggested to add
> > > > > copy emulation as well.
> > > > > 
> > > > > blk_copy_offload - actually issues copy command in driver layer.
> > > > > The way read/write BIOs are percieved is different for copy offload.
> > > > > In copy offload we check REQ_COPY flag in NVMe driver layer to issue
> > > > > copy command. But we did missed it to add in other driver's, where they
> > > > > might be treated as normal READ/WRITE.
> > > > > 
> > > > > blk_copy_emulate - is used if we fail or if device doesn't support native
> > > > > copy offload command. Here we do READ/WRITE. Using copy_file_range for
> > > > > emulation might be possible, but we see 2 issues here.
> > > > > 1. We explored possibility of pulling dm-kcopyd to block layer so that we 
> > > > > can readily use it. But we found it had many dependecies from dm-layer.
> > > > > So later dropped that idea.
> > > > 
> > > > Is it just because dm-kcopyd supports async copy? If yes, I believe we
> > > > can reply on io_uring for implementing async copy_file_range, which will
> > > > be generic interface for async copy, and could get better perf.
> > > >
> > > 
> > > It supports both sync and async. But used only inside dm-layer.
> > > Async version of copy_file_range can help, using io-uring can be helpful
> > > for user , but in-kernel users can't use uring.
> > > 
> > > > > 2. copy_file_range, for block device atleast we saw few check's which fail
> > > > > it for raw block device. At this point I dont know much about the history of
> > > > > why such check is present.
> > > > 
> > > > Got it, but IMO the check in generic_copy_file_checks() can be
> > > > relaxed to cover blkdev cause splice does support blkdev.
> > > > 
> > > > Then your bdev offload copy work can be simplified into:
> > > > 
> > > > 1) implement .copy_file_range for def_blk_fops, suppose it is
> > > > blkdev_copy_file_range()
> > > > 
> > > > 2) inside blkdev_copy_file_range()
> > > > 
> > > > - if the bdev supports offload copy, just submit one bio to the device,
> > > > and this will be converted to one pt req to device
> > > > 
> > > > - otherwise, fallback to generic_copy_file_range()
> > > >
> > > 
> > 
> > Actually we sent initial version with single bio, but later community
> > suggested two bio's is must for offload, main reasoning being
> 
> Is there any link which holds the discussion?
> 

This[1] is the starting thread for LSF/MM which Chaitanya organized and it
was a conference call. Also in 2022 LSM/MM there was a discussion on copy
topic as well. One of the main conclusion was using 2 bio's as must have.

Bart has summarized previous copy efforts[2] and Martin too [3],
which might be of help in understanding why 2 bio's are must.

> > dm-layer,Xcopy,copy across namespace compatibilty.
> 
> But dm kcopy has supported bdev copy already, so once your patch is
> ready, dm kcopy can just sends one bio with REQ_COPY if the device
> supports offload command, otherwise the current dm kcopy code can work
> as before.
> 
> > 
> > > We will check the feasibilty and try to implement the scheme in next versions.
> > > It would be helpful, if someone in community know's why such checks were
> > > present ? We see copy_file_range accepts only regular file. Was it
> > > designed only for regular files or can we extend it to regular block
> > > device.
> > >
> > 
> > As you suggested we were able to integrate def_blk_ops and
> > run with user application, but we see one main issue with this approach.
> > Using blkdev_copy_file_range requires having 2 file descriptors, which
> > is not possible for in kernel users such as fabrics/dm-kcopyd which has
> > only bdev descriptors.
> > Do you have any plumbing suggestions here ?
> 
> What is the fabrics kernel user? 

In fabrics setup we are exposing target side NVMe device, to host as
copy offload capable device, irrespective of target device's capability.
This will enable sending copy offload command from host.
From target side, if device doesn't support offload then we emulate.
This way we will avoid data copy over the network.

> Any kernel target code(such as nvme target)
> has file/bdev path available, vfs_copy_file_range() should be fine.
> 

From target side, fabrics device can be created in 2 ways,
1. file backed device: In this setup we get file descriptor. In fact in our
patches[4] are using vfs_copy_file_range to offload copy.
2. block backed device: Here we have only blockdev descriptor.
This setup we can't use vfs_copy_file_range since we are missing file
descriptor.
Your input on how we can plumb blkdev_copy_file_range with bdev would help.

> Also IMO, kernel copy user shouldn't be important long term, especially if
> io_uring copy_file_range() can be supported, forwarding to userspace not
> only gets better performance, but also cleanup kernel related copy code
> much.
>

Using uring is valid if consumer of copy_file_range is userspace.
But there are many possible in-kernel user of copy, such as dm-kcopyd,
garbage collection case such as F2FS GC, also fabrics as explained above.
We can't use uring from these layers.

Present implementation of vfs_copy_file_range(CFR) lacks
a. async implementation, which helps in nvme over fabrics
b. multi range(src,dst pair) support
So here we see going to blkdev_copy_file_range actually regress our present
result. But we do see a goodness of using mature vfs_copy_file_range for
emulation.

[1] https://lore.kernel.org/linux-nvme/BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com/
[2] https://github.com/bvanassche/linux-kernel-copy-offload
[3] https://oss.oracle.com/~mkp/docs/xcopy.pdf
[4] https://lore.kernel.org/lkml/20221130041450.GA17533@test-zns/T/#Z2e.:..:20221123055827.26996-7-nj.shetty::40samsung.com:1drivers:nvme:target:io-cmd-file.c

Thanks,
Nitesh Shetty

------dP7Qx9dcwq0e3k-gT5OC2TLFeuRm6-MlOT8i1nwxNxOSTL6J=_1f9a1_
Content-Type: text/plain; charset="utf-8"


------dP7Qx9dcwq0e3k-gT5OC2TLFeuRm6-MlOT8i1nwxNxOSTL6J=_1f9a1_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------dP7Qx9dcwq0e3k-gT5OC2TLFeuRm6-MlOT8i1nwxNxOSTL6J=_1f9a1_--

