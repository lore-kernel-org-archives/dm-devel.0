Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD59C4321E
	for <dm-devel@archiver.kernel.org>; Wed, 30 Nov 2022 08:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669795309;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=vSRMX/Dm3XkexKkiPaqsAw4cymlrDVxjC8CDWjmCHVU=;
	b=H7yfqmInkAzuxfXPHvEAZNGO6DwawWrRs6/qD0BbfAQHWjGPt/HjQmvZFO58eRovnpMxn3
	Z/rk+INshb45UhLcSvsqxP+W8gUlhU25c3aazMSaE1x18NqkO34pi8wyFaO+zgVYtW8QMi
	P7Nc3Rum9I8ufrhSlGUICQYcWRqPUbY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-ZrOsvfpKP0yNaYFiLK5-CQ-1; Wed, 30 Nov 2022 03:01:40 -0500
X-MC-Unique: ZrOsvfpKP0yNaYFiLK5-CQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22D911C068C5;
	Wed, 30 Nov 2022 08:01:37 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7B9B44B3FCE;
	Wed, 30 Nov 2022 08:01:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 578CB1946A50;
	Wed, 30 Nov 2022 08:01:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4E8C61946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Nov 2022 13:42:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3D23549BB69; Tue, 29 Nov 2022 13:42:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 35A1B49BB60
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 13:42:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 16A54801585
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 13:42:27 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-YN9ixu1fNyGIjJlGcTUDMg-1; Tue, 29 Nov 2022 08:42:24 -0500
X-MC-Unique: YN9ixu1fNyGIjJlGcTUDMg-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20221129134222epoutp043d307f5fb057f4c72405b9de506c164d~sEf1z8MRp1417814178epoutp048
 for <dm-devel@redhat.com>; Tue, 29 Nov 2022 13:42:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20221129134222epoutp043d307f5fb057f4c72405b9de506c164d~sEf1z8MRp1417814178epoutp048
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20221129134221epcas5p18886014f367e20afde819fd9d11b35aa~sEf0_zgNL2512725127epcas5p14;
 Tue, 29 Nov 2022 13:42:21 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp2.localdomain (Postfix) with ESMTP id 4NM3Rb49LBz4x9Px; Tue, 29 Nov
 2022 13:42:19 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 EB.F7.39477.B3C06836; Tue, 29 Nov 2022 22:42:19 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20221129115552epcas5p1a9284109967b87aa67e010d7e2ac336b~sDC3PJYy42001820018epcas5p1Q;
 Tue, 29 Nov 2022 11:55:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20221129115552epsmtrp1e1baa107fa401cc398a54d49ac7ca047~sDC3Nz0Ex1078010780epsmtrp1U;
 Tue, 29 Nov 2022 11:55:52 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-5a-63860c3b862b
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 5E.89.18644.843F5836; Tue, 29 Nov 2022 20:55:52 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20221129115549epsmtip24466c55a01239c5949e95ffc059fa2bb~sDC0PdTgz0992009920epsmtip2X;
 Tue, 29 Nov 2022 11:55:49 +0000 (GMT)
Date: Tue, 29 Nov 2022 17:14:28 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20221129114428.GA16802@test-zns>
MIME-Version: 1.0
In-Reply-To: <Y3607N6lDRK6WU7/@T590>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTdxTHd+8ttxdGyQV5/CjTkSsz8qashR8DnBHn7hwxRBOTuS3srtxR
 QmmbtkyZc/KwoBAe2hFG5ygLIvIYzEIIj6EMZAwU+EN5OiZMmJm8yiMjgQBruWXxv8/ve875
 nd/3d3IIzKWYLySSFFpWrWDkFO7Aa+72PRwY6ZgtDVk3vgEb+n/DYGbRFgZrJwtxuDkwhMGO
 xe/t4HhnKwqra3tQ2P7jMgp7dhZwOL02wYM3ukYQODtsQGHHhD/8paOPBx+33cSh8fYsH3bp
 s1B4vbfRDrbMZCBwtfIKH9bPLfHg7xNecGir1+6oB214NoDTrYZJPj30510e/XgglTbVXMPp
 xluX6fbxdJzOz1q0JOie2dFL94ZxuqCpBqFXTQfonM48lDbNLKBxTueSo2Qsk8CqvVmFVJmQ
 pEiMpj48Ex8TLwkLEQWKImA45a1gUtho6nhsXOCJJLnFP+X9JSNPtUhxjEZDBR+JUitTtay3
 TKnRRlOsKkGuEquCNEyKJlWRGKRgte+IQkJCJZbEz5Jlev0YqnpAXZir28DSkQdeuYg9AUgx
 GDS+sMtFHAgXsh0BU6arfO6wgoD85iLbYdUSWVhG9kqWNs0oF2hDwKO+BVvW3wgYXbiFWrN4
 5FugwjxqCRAETvqDhzuEVXYlKTA5Wcu3Mkam88DsOGnlfWQsyN1uwq0sIAOBqacM4dgZ9JXO
 8KxsT/qAH8p2dq93Iw+Czube3UcAssEelORtoNZegDwO2sds3vaBl71NfI6F4J/CbBufB9Xf
 3sG52isIMIwabM7eBbr+Qox7nAzUlf6Lcfp+UNxfj3K6E8jfnEE5XQBayvb4IKhrKMc59gQj
 6xk2psETcyXCfZAeBfXz1bwi5E3DK+YMr/TjOACUt6/gBosfjPQCVdsEh76goS24HLGrQTxZ
 lSYlkdVIVKEK9vz/E5cqU0zI7n74nWxBpqfMQV0ISiBdCCAwylWwfFondREkMGlfsWplvDpV
 zmq6EIllVtcxoZtUaVkwhTZeJI4IEYeFhYkj3g4TUR6Ciu/8pC5kIqNlk1lWxar36lDCXpiO
 xhhrquhwRxdMNyY7tXN2rpjfdnjUjZktKFF25sRsoYsftBLXQmNiF56fNmTc/6OuqDEgLavS
 Y7AEq+643aoynj1m6lY7bvsK2BVZ94lvAgqcI7/4tedInMH/0nP8vfop/NgjbDtlv0N3i7Pz
 xrInHnTASTK99tDH/Ul/kdm9FEKfM8LXvo5Zy23A0qSZ4judxz6enK+Izr1g/nz23KDONfNq
 lT4bLR+byMvXBUcenb9/yF/uLublNCU2hp38ZGju576/DoWXr9+tUvRK6BdrT18uva/PuRlc
 iVLLPwmHTyW/3ur61Ki8dzFUdfHSR16fXo4qdFSlZ60oGXokiVkiPCieRsaI/DC1hvkPUtHL
 +KgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ra0hTYRjHec85OzvOJkctfOe6sSxEcWlpvGTXL3XQbnSjhMqhp1VuKpuz
 i1imSbSwtKJwphmVtimJU+Ylb8zULIaVbZplJk0zyxumVrat3Ij69vD8fv/n/+GhcK8uwpc6
 Hp/EKuIlMhHJIwzNoiVBzGRmTHDjaz9U9qwVR+nZNhyV9F4l0aypA0f1o3kc9KapBkPakhYM
 Pb47gaEWxwiJ+r/1EOia0QLQgFmDofqeQFRX306gztrbJLpTNMBFxusZGMppq+Cgaut5gCYf
 XOCiR1/GCPS0R4g6bG2cTT6Mps9EMjWaXi7T8b6cYDpNKkavu0QyFffPMY/fpJFMVsboHyGz
 j8OMNZhJ5kqlDjCT+sXMxabLGKO3jmC7PKJ462JZ2fFkVrFyQzTvmKHrI5F4YempjMvPiDSQ
 L1ADNwrSoXBsdhxTAx7lRVcDODhs5biAABbZnuCu2Rtq7Z+4LskK4HB/OTEHCHo5vDfe9QdQ
 FEkHwucOam49nxbB3t4Sp4/T6QQssLwl54A3vQ2q7ZXOmU8HQX1LAXAdvYXBX98vYS7gCdtz
 rc4CnA6A3fbP2FwBTgthsd1Z4Eb7wfwCh1NfQC+DTYY2LBt4av5La/5La/6lCwGuAwI2USmX
 ypUhiavi2ZNipUSuVMVLxTEJcj1w/j4goBrU6cbFRoBRwAgghYvm8yd2Z8Z48WMlp8+wioQj
 CpWMVRqBkCJEPvwX6vYjXrRUksTGsWwiq/hLMcrNNw2LagiN9JWeEAy22tYQgn1Zhw9sLHs1
 VFlZWDWd8j0raJRX9eNp7OjUggcDtcn9kaF4asTC644yzxlh8VYpuNNNJ2x1q7FsH7phcLiT
 qcuWztzbs+jEvMW7BozcqEGVqTZFvZ+/cyYuN1shT3UP082cLv1QZbu2c8fCKW1IVrkt9Fzn
 oZEbycGr3de/XDRlbZKcNZubVSHad0pxdMrXxg3aaKEHE3FQ6xFRmC3z6fJO9p1g/OydI/7p
 k+KGn3qj4XCOwLLCvLLb/0CQ7uFBHSoPn543WzrcWpdjCX8bFvl8y2CqVtwf+YotCs7fsjfu
 6EZZMJarsfL918aY8m5uHnshIpTHJCEBuEIp+Q36NlGKagMAAA==
X-CMS-MailID: 20221129115552epcas5p1a9284109967b87aa67e010d7e2ac336b
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
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Wed, 30 Nov 2022 08:01:29 +0000
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----G62UEJgdyo2JOumF_Do4Y7B7G39M5PuLVzFwfXKQiOy3iUJg=_7d38c_"

------G62UEJgdyo2JOumF_Do4Y7B7G39M5PuLVzFwfXKQiOy3iUJg=_7d38c_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Nov 24, 2022 at 08:03:56AM +0800, Ming Lei wrote:
> On Wed, Nov 23, 2022 at 03:37:12PM +0530, Nitesh Shetty wrote:
> > On Wed, Nov 23, 2022 at 04:04:18PM +0800, Ming Lei wrote:
> > > On Wed, Nov 23, 2022 at 11:28:19AM +0530, Nitesh Shetty wrote:
> > > > Introduce blkdev_issue_copy which supports source and destination bdevs,
> > > > and an array of (source, destination and copy length) tuples.
> > > > Introduce REQ_COPY copy offload operation flag. Create a read-write
> > > > bio pair with a token as payload and submitted to the device in order.
> > > > Read request populates token with source specific information which
> > > > is then passed with write request.
> > > > This design is courtesy Mikulas Patocka's token based copy
> > > 
> > > I thought this patchset is just for enabling copy command which is
> > > supported by hardware. But turns out it isn't, because blk_copy_offload()
> > > still submits read/write bios for doing the copy.
> > > 
> > > I am just wondering why not let copy_file_range() cover this kind of copy,
> > > and the framework has been there.
> > > 
> > 
> > Main goal was to enable copy command, but community suggested to add
> > copy emulation as well.
> > 
> > blk_copy_offload - actually issues copy command in driver layer.
> > The way read/write BIOs are percieved is different for copy offload.
> > In copy offload we check REQ_COPY flag in NVMe driver layer to issue
> > copy command. But we did missed it to add in other driver's, where they
> > might be treated as normal READ/WRITE.
> > 
> > blk_copy_emulate - is used if we fail or if device doesn't support native
> > copy offload command. Here we do READ/WRITE. Using copy_file_range for
> > emulation might be possible, but we see 2 issues here.
> > 1. We explored possibility of pulling dm-kcopyd to block layer so that we 
> > can readily use it. But we found it had many dependecies from dm-layer.
> > So later dropped that idea.
> 
> Is it just because dm-kcopyd supports async copy? If yes, I believe we
> can reply on io_uring for implementing async copy_file_range, which will
> be generic interface for async copy, and could get better perf.
>

It supports both sync and async. But used only inside dm-layer.
Async version of copy_file_range can help, using io-uring can be helpful
for user , but in-kernel users can't use uring.

> > 2. copy_file_range, for block device atleast we saw few check's which fail
> > it for raw block device. At this point I dont know much about the history of
> > why such check is present.
> 
> Got it, but IMO the check in generic_copy_file_checks() can be
> relaxed to cover blkdev cause splice does support blkdev.
> 
> Then your bdev offload copy work can be simplified into:
> 
> 1) implement .copy_file_range for def_blk_fops, suppose it is
> blkdev_copy_file_range()
> 
> 2) inside blkdev_copy_file_range()
> 
> - if the bdev supports offload copy, just submit one bio to the device,
> and this will be converted to one pt req to device
> 
> - otherwise, fallback to generic_copy_file_range()
>

We will check the feasibilty and try to implement the scheme in next versions.
It would be helpful, if someone in community know's why such checks were
present ? We see copy_file_range accepts only regular file. Was it
designed only for regular files or can we extend it to regular block
device.

> > 
> > > When I was researching pipe/splice code for supporting ublk zero copy[1], I
> > > have got idea for async copy_file_range(), such as: io uring based
> > > direct splice, user backed intermediate buffer, still zero copy, if these
> > > ideas are finally implemented, we could get super-fast generic offload copy,
> > > and bdev copy is really covered too.
> > > 
> > > [1] https://lore.kernel.org/linux-block/20221103085004.1029763-1-ming.lei@redhat.com/
> > > 
> > 
> > Seems interesting, We will take a look into this.
> 
> BTW, that is probably one direction of ublk's async zero copy IO too.
> 
> 
> Thanks, 
> Ming
> 
> 


Thanks,
Nitesh

------G62UEJgdyo2JOumF_Do4Y7B7G39M5PuLVzFwfXKQiOy3iUJg=_7d38c_
Content-Type: text/plain; charset="utf-8"


------G62UEJgdyo2JOumF_Do4Y7B7G39M5PuLVzFwfXKQiOy3iUJg=_7d38c_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------G62UEJgdyo2JOumF_Do4Y7B7G39M5PuLVzFwfXKQiOy3iUJg=_7d38c_--

