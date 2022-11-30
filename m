Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3FB4C47088
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 08:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669795306;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=xtcHl+m4L/bGR94V7fWJjuZDgbHA68fX/2EwFFezDt4=;
	b=LT4drJpTHDpenTXjz5urBox1FtSecNJTNTtSjqXnnrxSdIFMeK8O4NM8uHxvKgSmTOQKEw
	HLYXeNNeYJc1o82+qfAkqSSwuAgOytkEDVwczKd7IZaIkbk0yggNI2btCLqLYTWDPEJhY5
	QB41oRVrHNxuzrTJvGhAEHv09PvX4wU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-tW7v9m35Mr6-4uIruvthXQ-1; Wed, 30 Nov 2022 03:01:39 -0500
X-MC-Unique: tW7v9m35Mr6-4uIruvthXQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22F843801FE3;
	Wed, 30 Nov 2022 08:01:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DDEE14B3FE5;
	Wed, 30 Nov 2022 08:01:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9278019465A8;
	Wed, 30 Nov 2022 08:01:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 072F319465A0
 for <dm-devel@listman.corp.redhat.com>; Wed, 30 Nov 2022 04:34:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DDBF740C206B; Wed, 30 Nov 2022 04:34:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D476C40C2066
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 04:34:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B067285A59D
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 04:34:22 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-138-ycuXrlHWPKWzTou7UQaqoA-1; Tue, 29 Nov 2022 23:34:19 -0500
X-MC-Unique: ycuXrlHWPKWzTou7UQaqoA-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20221130043416epoutp0491e0152f0f535f5fabd876baf5ce7c8a~sQqlVIVlO1767417674epoutp04W
 for <dm-devel@redhat.com>; Wed, 30 Nov 2022 04:34:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20221130043416epoutp0491e0152f0f535f5fabd876baf5ce7c8a~sQqlVIVlO1767417674epoutp04W
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20221130043416epcas5p1e5e92913164855ae029853bde2aa43bf~sQqks9l2A0431904319epcas5p1z;
 Wed, 30 Nov 2022 04:34:16 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.176]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4NMRDk588bz4x9Pt; Wed, 30 Nov
 2022 04:34:14 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 DB.F9.39477.64DD6836; Wed, 30 Nov 2022 13:34:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20221130042624epcas5p169a43c3b0e5b05a7fa47d925e9a5e186~sQjtMrVtX0044000440epcas5p1v;
 Wed, 30 Nov 2022 04:26:24 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20221130042624epsmtrp252aff7ff1f7dafdc419c2be4e1fa122a~sQjtLavM-1890818908epsmtrp2j;
 Wed, 30 Nov 2022 04:26:24 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-a5-6386dd46c561
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 F7.50.18644.07BD6836; Wed, 30 Nov 2022 13:26:24 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20221130042614epsmtip27f06f8882f26839742901009824ead68~sQjkL-WMh1919419194epsmtip25;
 Wed, 30 Nov 2022 04:26:14 +0000 (GMT)
Date: Wed, 30 Nov 2022 09:44:50 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20221130041450.GA17533@test-zns>
MIME-Version: 1.0
In-Reply-To: <a7b0b049-7517-bc68-26ac-b896aaf5342e@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTHvfe2txc24PLSH6izK1umaCtlBX8wQBYNuT7HnNscicFabqAB
 2qaPOd0fIlLNMIgQJKMDh4N1iAwGZYxngTreYFUEBgawUoGNCkPYyGTIWloW//ucx/d3fuec
 HALzyGb5EmKJkpZLhEkc3JlRc2fHdm7U6CVRwEMLE1Z0t2Mw9doKBm+PZuJwrnWCCZf7jBhs
 mv2GCYdb6lB463YbChtuzqOwbfUZDk2LIwyYbRhEYNPITtjY1MWA/fX5OPxW+5QFszp0TFhr
 voDAhe/TWLB8Zo4B9ZoDsHNkMzSudDAjN1Ga8T6cqtOMsijjWCWD6u9TUVWlX+GUrvg81TCc
 glMZF2etCepxJjWnH8Cpq9WlCLVQ9QZ1ueUKSlWZn6HRrjGJYQm0MI6Ws2mJSBonlsSHcw59
 FLsvNig4gM/lh8A9HLZEmEyHc/YfjuZGiZOs7XPYnwuTVFZXtFCh4OyOCJNLVUqanSBVKMM5
 tCwuSSaQ8RTCZIVKEs+T0MpQfkBAYJA18VRiwsRQG1Nm8PyiQR2RgvS7pSNOBCAFoFfbz0hH
 nAkPsgEBd58amXbjOQJuVLay7MYCAqaMFsa6xFJrcWTVI6D113TMbkwioL931RohCAb5Nngw
 t92GOLkT9KwSNq0XyQMDI7+tPYqRYwS43vOAZQt4kmFAd/9n3MYuJBdUDHdidnYHXXlma2EW
 4URGgBeHbV5v0g+01HSgtmcAqXMCpsafHH/bDxb1k4idPcEfHdUsO/uChdkm3M5nwK2cEtwu
 TkOAZkjjEOwF6u7MtboYmQAu6s0O8VZwvbsctftdQcayGbX7XUDtjXX2A2UVhY4CPmBw6YKD
 KWApm3PMV4OCruksxjVkm+aV3jSv1LPzLlDY8BzXWGeHkZvBDy8JO+4AFfW7CxFmKeJDyxTJ
 8bQiSBYooc/8v2+RNLkKWTsO/4O1iOnxnzwDghKIAQEExvFymT+mFnm4xAnPnqPl0li5KolW
 GJAg66qyMF9vkdR6XRJlLF8QEiAIDg4WhLwbzOdscin62l/kQcYLlXQiTcto+boOJZx8U9BP
 0cxHZZXpqd4fyrbxPis2bcx79MGJ03divCLedFdlHPpyQ3jBkGVgqS5bv/JvgaEv9eiP0zUH
 DKNnQbbxraixqeWjliLtTde/LlWrx8LmWU8SLXRbb8nHMc0+ke5FT6R/637/JL+m6cWUkrt1
 cPK84bXidx7u1ea+bjo+sOXIQbEs0M1TfckzzXnGLX5XebOJY7bc71oU1NNFx+HJ0Ms9eat7
 NKx933UyQycitbINmrZzgr6JY+0bl7neS+Yctm5LV+Pw6Xs+Xr/wxSXkyEnscQF/lfXyPb/4
 f7QlOfrSqCOneqd5JfPNvlcUrkx2bv5Qrr5zNKP9hDN4v31m/N5drriew1AkCPn+mFwh/A+E
 mpVZpQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsWy7bCSvG7B7bZkg8mHOC3WnzrGbNE04S+z
 xeq7/WwW7w8+ZrX4ffY8s8Xed7NZLW4e2MlksXL1USaL3Qs/Mlkc/f+WzeLhl1ssFpMOXWO0
 2HtL22LP3pMsFpd3zWGzmL/sKbvFxOObWS12PGlktPi8tIXdYt3r9ywW+2Z5Wpy4JW1x/u9x
 Vgdxj1n3z7J57Jx1l93j/L2NLB6Xz5Z6bFrVyeaxeUm9x+6bDWwevc3vgApa77N6vN93lc2j
 b8sqRo/Pm+Q82g90M3lsevKWKYAvissmJTUnsyy1SN8ugSvj/KxXzAVNghX39v9laWBcw9vF
 yMkhIWAi8WbHG9YuRi4OIYEdjBIXbn5mgkhISiz7e4QZwhaWWPnvOTtE0RNGia/nvjB2MXJw
 sAioSlx6rwFisgloS5z+zwFSLiKgJ3H11g2wcmaBFxwSiz49B5sjLGAjsfniVjYQm1dAV2L9
 zRNgcSGBWUwSy7t8IeKCEidnPmEBsZkFtCRu/HvJBDKfWUBaYvk/oPnsHJwCdhK/fEAKRAWU
 JQ5sO840gVFwFpLeWUh6ZyH0LmBkXsUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERzt
 Wlo7GPes+qB3iJGJg/EQowQHs5II78eg1mQh3pTEyqrUovz4otKc1OJDjNIcLErivBe6TsYL
 CaQnlqRmp6YWpBbBZJk4OKUamJqefXm8YUKr1ZXjrZIc1vt/xL2e5LCVc8PBpEORC3bG8yku
 1KyXvDrrCvOskszXs38b/XM7fu36ik+m2T/0+mRTOBaG382btK/VNztaaLFc+98dN1YuyFNY
 /dvq5jT5qKXKlZcZpUL7e++pWZkv7v5XOVWJQc6ldMezxt6Wpc4iwZMfCFpuXHhwZ9iMl7Lz
 K+e4nT+4xsfCcnf1VPGv9WyCBqzLhQvz9od43Oz+ej5udT7bzvqJ/iWbTPz1E3z3bb8ylcOx
 9vnvvT6Pn0a472bMM7p3asXTN9dvdb1eYNBxN5f75vXrvbuLC4S4HDe23PNMuRZVvnJesH7Q
 216HuddPW9xsKtG3e9maqnxnvooSS3FGoqEWc1FxIgDjKZW2ZQMAAA==
X-CMS-MailID: 20221130042624epcas5p169a43c3b0e5b05a7fa47d925e9a5e186
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123061010epcas5p21cef9d23e4362b01f2b19d1117e1cdf5
References: <CGME20221123061010epcas5p21cef9d23e4362b01f2b19d1117e1cdf5@epcas5p2.samsung.com>
 <20221123055827.26996-1-nj.shetty@samsung.com>
 <cd772b6c-90ae-f2d1-b71c-5d43f10891bf@nvidia.com>
 <20221129121634.GB16802@test-zns>
 <a7b0b049-7517-bc68-26ac-b896aaf5342e@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mailman-Approved-At: Wed, 30 Nov 2022 08:01:29 +0000
Subject: Re: [dm-devel] [PATCH v5 00/10] Implement copy offload support
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
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "hch@lst.de" <hch@lst.de>,
 "agk@redhat.com" <agk@redhat.com>,
 "naohiro.aota@wdc.com" <naohiro.aota@wdc.com>,
 "sagi@grimberg.me" <sagi@grimberg.me>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
 "james.smart@broadcom.com" <james.smart@broadcom.com>,
 "shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>,
 "p.raghav@samsung.com" <p.raghav@samsung.com>,
 "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
 "snitzer@kernel.org" <snitzer@kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
 "kbusch@kernel.org" <kbusch@kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "jth@kernel.org" <jth@kernel.org>,
 "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----G62UEJgdyo2JOumF_Do4Y7B7G39M5PuLVzFwfXKQiOy3iUJg=_80049_"

------G62UEJgdyo2JOumF_Do4Y7B7G39M5PuLVzFwfXKQiOy3iUJg=_80049_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Nov 30, 2022 at 12:05:00AM +0000, Chaitanya Kulkarni wrote:
> On 11/29/22 04:16, Nitesh Shetty wrote:
> > On Wed, Nov 23, 2022 at 10:56:23PM +0000, Chaitanya Kulkarni wrote:
> >> (+ Shinichiro)
> >>
> >> On 11/22/22 21:58, Nitesh Shetty wrote:
> >>> The patch series covers the points discussed in November 2021 virtual
> >>> call [LSF/MM/BFP TOPIC] Storage: Copy Offload [0].
> >>> We have covered the initial agreed requirements in this patchset and
> >>> further additional features suggested by community.
> >>> Patchset borrows Mikulas's token based approach for 2 bdev
> >>> implementation.
> >>>
> >>> This is on top of our previous patchset v4[1].
> >>
> >> Now that series is converging, since patch-series touches
> >> drivers and key components in the block layer you need accompany
> >> the patch-series with the blktests to cover the corner cases in the
> >> drivers which supports this operations, as I mentioned this in the
> >> call last year....
> >>
> >> If you need any help with that feel free to send an email to linux-block
> >> and CC me or Shinichiro (added in CC )...
> >>
> >> -ck
> >>
> > 
> > Yes any help would be appreciated. I am not familiar with blktest
> > development/testing cycle. Do we need add blktests along with patch
> > series or do we need to add after patch series gets merged(to be merged)?
> > 
> > Thanks
> > Nitesh
> > 
> > 
> 
> we have many testcases you can refer to as an example.
> Your cover-letter mentions that you have tested this code, just move
> all the testcases to the blktests.
> 
> More importantly for a feature like this you should be providing
> outstanding testcases in your github tree when you post the
> series, it should cover critical parts of the block layer and
> drivers in question.
> 
> The objective here is to have blktests updated when the code
> is upstream so all the distros can test the code from
> upstream blktest repo. You can refer to what we have done it
> for NVMeOF in-band authentication (Thanks to Hannes and Sagi
> in linux-nvme email-archives.
> 
> -ck
>

Sure, next version will update blktest.

Thank you,
Nitesh

------G62UEJgdyo2JOumF_Do4Y7B7G39M5PuLVzFwfXKQiOy3iUJg=_80049_
Content-Type: text/plain; charset="utf-8"


------G62UEJgdyo2JOumF_Do4Y7B7G39M5PuLVzFwfXKQiOy3iUJg=_80049_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------G62UEJgdyo2JOumF_Do4Y7B7G39M5PuLVzFwfXKQiOy3iUJg=_80049_--

