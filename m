Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21415C433FE
	for <dm-devel@archiver.kernel.org>; Mon, 21 Feb 2022 06:07:28 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-JgE8Ryf5P0aT3YbV-puU9g-1; Mon, 21 Feb 2022 01:07:22 -0500
X-MC-Unique: JgE8Ryf5P0aT3YbV-puU9g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72B4318397A7;
	Mon, 21 Feb 2022 06:07:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5752E6C192;
	Mon, 21 Feb 2022 06:07:18 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0ECFE4A7CB;
	Mon, 21 Feb 2022 06:07:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21I50px3000305 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Feb 2022 00:00:51 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 4535C40FF412; Fri, 18 Feb 2022 05:00:51 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 402CF40FF40D
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 05:00:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EA70F1857F16
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 05:00:50 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-517-n2oj7CTbP1ixWKVI6XXIPw-1; Fri, 18 Feb 2022 00:00:48 -0500
X-MC-Unique: n2oj7CTbP1ixWKVI6XXIPw-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20220218050045epoutp02c83876128818ae25395bb57d6abea6ff~UyLWH7WAW2920729207epoutp02i;
	Fri, 18 Feb 2022 05:00:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20220218050045epoutp02c83876128818ae25395bb57d6abea6ff~UyLWH7WAW2920729207epoutp02i
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20220218050045epcas5p268ef3f00ae6635c8035d5bfbcb14a2ca~UyLVV-p3W2406724067epcas5p2u;
	Fri, 18 Feb 2022 05:00:45 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4K0KJl21lBz4x9Q0;
	Fri, 18 Feb 2022 05:00:39 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B5.F7.05590.6F72F026; Fri, 18 Feb 2022 14:00:38 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20220217130715epcas5p2159ed983a5d32b04709d44b6c155e12e~UlK08gd8s1495614956epcas5p22;
	Thu, 17 Feb 2022 13:07:15 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20220217130715epsmtrp106f09d07c77a34cb19ee343b972efdf0~UlK06Jz2_1226812268epsmtrp17;
	Thu, 17 Feb 2022 13:07:15 +0000 (GMT)
X-AuditID: b6c32a4b-739ff700000015d6-47-620f27f65a47
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2E.9C.29871.3884E026; Thu, 17 Feb 2022 22:07:15 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20220217130710epsmtip197f0af2b21b2d267e9a7e52f7935cd7f~UlKwioze70271602716epsmtip1S;
	Thu, 17 Feb 2022 13:07:10 +0000 (GMT)
Date: Thu, 17 Feb 2022 18:32:15 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Dave Chinner <david@fromorbit.com>
Message-ID: <20220217130215.GB3781@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220214220741.GB2872883@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA01TazBcZxjOd87u2SWDY4N8NJnoarUi2A22n7hURmpOKz+0mWmnmWRYnMFg
	d7NLJG1nECJFZZE20ZXEJVpxGUow29hNGopx60qFEreoS9OktUik7mr3SJt/z/vM87zXebk4
	b4Rjx42WxNNyiTiWT5iyGlucnFxevGURJnhcw0M1nW040gw9Y6PKUSWBLs8t40h/b5KN8pT5
	HFTfNgZQ35Q50s4WsFHvUgqGJus2MaQpycNQeWUrhv4ouwFQU/E8hjK6ejG0NiFErZt/Eyiv
	eQCg6X4VhrQPnZFG28FCfbevEqjw+2kOyvpNTaA7T7U4KmvfwNAvqjUCqadSAGoZ62eh6qd6
	FkqvXQTo/FfLHKRbb2f786m+B0GUaryHoHJTZzlUZwmkflSNcijdWC2LSi0aYVF9PQlUXUUG
	Qd0qTaIuDZYBqmkomaDOdbfiVP7Cc4LKTp0lqPnph6zg3cdjfKJocQQtt6cl4dKIaEmkLz/o
	WEhAiKdIIHQReqF3+PYScRztyz9yNNglMDp2a318+9Pi2IQtKlisUPDd/Hzk0oR42j5Kqoj3
	5dOyiFiZh8xVIY5TJEgiXSV0/CGhQHDQc0sYGhM1sDgMZHk2Z3qUNslAb5kJTLiQ9IANfRUg
	E5hyeWQTgMruNIwJFgDMqhvZDl4AWDe3yskEXKPl1ypnhtcCWLjyNWFIxSNnALyvTDBgFvkm
	bJ1oZxn0BOkMuza5BtqKdIR5eWrc4MXJbgIWpH9p9O4iRTCz4SowYDPyAOxYv8hhsCXs+HaK
	ZcAmpDe8rl42aqxJB/hTY7uxOUheM4XZ4xWAmecIrK0uwxi8Cz5pr+cw2A7+qUznMIYsAJe6
	x7fd+QCm5qQSjOpdeF+zjhnaxskoOHorkKH3wm86q41JcdIcZq9ObRcwg+rrL7EDrKop2k5j
	Cwf+SSGYbVFwMeMEs627AD67scTOAftUrwyn+r8aA51gzW03lbHYPpjaUIAz9GuwbIP7iqII
	EBXAlpYp4iJphafMXUIn/nf5cGlcHTC+2f4gNfj90ZxrM8C4oBlALs63Mpu7ZxbGM4sQn/2M
	lktD5AmxtKIZeG6dLRe3sw6Xbv2pJD5E6OEl8BCJRB5e7iIhf7dZZ+QPYh4ZKY6nY2haRstf
	+jCuiV0yllTS3/tB2mZA0sfnl+uqdra10uURzRasx9NnnFQFJ7qQ+DtovqDLeb0wcNZyeGnd
	666+ssMPn3b2c4wmvWuG11omuzi81S8u6XoPhY7MmITErV0Ix9Mz8qcLd+pOXxhjC1rCPLSl
	YTamgZKJjcQ9Rccbr2yAIqrfd8enQe/Vfxgbp3VvukyPDQxWk/NpDqOamxvtpxoPnNItgWFs
	Jn3donjHJ+H16frS993OYr4BMyT7IH7n0efW4cUBiaIaevBahD7/2MpJvqPi3JBp9Rt/0W9v
	+qt9y0NtFYI076N7lT7Wh61yrZ+4XWm4+KC01P8jDf7zc//qTXXJzJ5Kp5M3V7L4LEWUWLgf
	lyvE/wIvcgCf7wQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SbUxTVxjHd+49vb2UVO+KykEzzeoLwwqDuM2TaJzZgjvGKMtmYuLctOgV
	69qCLSjyYcMV5ygio74EK1ZaiCgghiJQgSq0Qi3oRAsOyMQ4XsxGdkEYiyCFrbBlfPvl/8/z
	e54PD0vLykSLWZU2mddplWo5I4HVbvnSSAOZFx89YXkL32hppnF916gIlz7NYfD54XEaDzX2
	irApJ0+Mbzb3AOzrm4edwkURbnt1nMK99mkK19tMFL5W2kThF8WFANdZX1I4s7WNwpPPY3DT
	9B8MNrmeANzfYaaws1uB651eiH21+Qy+fKVfjLN+djD49qCTxsWeKQr/ZJ5ksKPvOMDung6I
	yweHIP6+YgzgE6fGxfih3yPaJCe+9q3E/OwBQ3INgpi02BC5ZX4qJg97KiAxFPwCie9BCrGX
	ZDKksuhbcqazGJC6rnSGfHe/iSZ5I38yJNsgMORlfzf8NHSXZMN+Xq06wuve3bhXcrDb5aWT
	KkNSG8ZyQTq4Pt8IWBZx76HHZQojkLAyrg6gUqsTGEHQP3kYuuK/S89yCLo29UIcYBnXB5Bl
	TBtgyK1ETc89MOBhOAVqnWYD8QJuFTKZHHTASXNtDPrB72ACRQj3ATJW5c/4pdwa5PWfFs8u
	vgNQ0a+//1u8ibwX+mCAaS4cTVoe04EFNLcEFU+xs/EyZKi6OHNbELceWRzjM6MLueWoodpD
	/Qhk5jkm8xyT+X+TeY6pAMASEMYn6TUJGn1MUoyWPxqlV2r0KdqEqH2JGjuYeajVEQ5QUzIc
	5QIUC1wAsbR8gXS4URovk+5XHkvjdYl7dClqXu8CS1goD5W2Gb17ZFyCMpn/mueTeN1/LcUG
	LU6njNvj+zdPTBQNHF6na4UZ9+9mRNxzhi4M39f5vsL/WhMUe2ADyQPBKvuxdhu7LVbkq+1U
	FaYyb6+QbX8tLSzsdQtx608vOjW0dliRVtP+RtWmUNtK1Hwo4vO1ruzN0ugV1w9rLkFT7lGb
	IsP9YUOzYF+6xQCfKKfd1orLR+rOFCAh2nr73PJImbDoq7hlVZWSgo4WPmM0e+TViGndlm+o
	6vxPIqU5936zfXRix+7auNHg/KKuVMTxseFrvoh4JGRt/SvNc7K8wvRlze6rzDuDEzuyVIK2
	0dPRkBiSefNkZdmt+VA94HnWIg62Jm+EndvU4zmPLGd3ugbCPoPVN8o/lkP9QWXMalqnV/4N
	ksnh0b8DAAA=
X-CMS-MailID: 20220217130715epcas5p2159ed983a5d32b04709d44b6c155e12e
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080551epcas5p201d4d85e9d66077f97585bb3c64517c0
References: <CGME20220214080551epcas5p201d4d85e9d66077f97585bb3c64517c0@epcas5p2.samsung.com>
	<20220214080002.18381-1-nj.shetty@samsung.com>
	<20220214220741.GB2872883@dread.disaster.area>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 21 Feb 2022 01:04:54 -0500
Cc: Sagi, Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	osandov@fb.com, Alasdair Kergon <agk@redhat.com>,
	javier@javigon.com, bvanassche@acm.org,
	linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
	James Smart <james.smart@broadcom.com>, hch@lst.de,
	chaitanyak@nvidia.com, Chaitanya Kulkarni <kch@nvidia.com>,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, Grimberg <sagi@grimberg.me>,
	axboe@kernel.dk, tytso@mit.edu, joshi.k@samsung.com,
	martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
	Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 00/10] Add Copy offload support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
	boundary="----7Im1L.vKorTl163deO4rxYDAHxkziUWsBhtki-3JrW1s26Hg=_8dd40_"

------7Im1L.vKorTl163deO4rxYDAHxkziUWsBhtki-3JrW1s26Hg=_8dd40_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

 Tue, Feb 15, 2022 at 09:08:12AM +1100, Dave Chinner wrote:
> On Mon, Feb 14, 2022 at 01:29:50PM +0530, Nitesh Shetty wrote:
> > The patch series covers the points discussed in November 2021 virtual c=
all
> > [LSF/MM/BFP TOPIC] Storage: Copy Offload[0].
> > We have covered the Initial agreed requirements in this patchset.
> > Patchset borrows Mikulas's token based approach for 2 bdev
> > implementation.
> >=20
> > Overall series supports =E2=80=93
> >=20
> > 1. Driver
> > - NVMe Copy command (single NS), including support in nvme-target (for
> > =09block and file backend)
> >=20
> > 2. Block layer
> > - Block-generic copy (REQ_COPY flag), with interface accommodating
> > =09two block-devs, and multi-source/destination interface
> > - Emulation, when offload is natively absent
> > - dm-linear support (for cases not requiring split)
> >=20
> > 3. User-interface
> > - new ioctl
> >=20
> > 4. In-kernel user
> > - dm-kcopyd
>=20
> The biggest missing piece - and arguably the single most useful
> piece of this functionality for users - is hooking this up to the
> copy_file_range() syscall so that user file copies can be offloaded
> to the hardware efficiently.
>=20
> This seems like it would relatively easy to do with an fs/iomap iter
> loop that maps src + dst file ranges and issues block copy offload
> commands on the extents. We already do similar "read from source,
> write to destination" operations in iomap, so it's not a huge
> stretch to extent the iomap interfaces to provide an copy offload
> mechanism using this infrastructure.
>=20
> Also, hooking this up to copy-file-range() will also get you
> immediate data integrity testing right down to the hardware via fsx
> in fstests - it uses copy_file_range() as one of it's operations and
> it will find all the off-by-one failures in both the linux IO stack
> implementation and the hardware itself.
>=20
> And, in reality, I wouldn't trust a block copy offload mechanism
> until it is integrated with filesystems, the page cache and has
> solid end-to-end data integrity testing available to shake out all
> the bugs that will inevitably exist in this stack....
>=20
> Cheers,
>=20
> Dave.
> --=20
> Dave Chinner
> david@fromorbit.com
>

We had planned copy_file_range (CFR) in next phase of copy offload patch se=
ries.
Thinking that we will get to CFR when everything else is robust.
But if that is needed to make things robust, will start looking into that.

--
Nitesh Shetty

------7Im1L.vKorTl163deO4rxYDAHxkziUWsBhtki-3JrW1s26Hg=_8dd40_
Content-Type: text/plain; charset="utf-8"


------7Im1L.vKorTl163deO4rxYDAHxkziUWsBhtki-3JrW1s26Hg=_8dd40_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
------7Im1L.vKorTl163deO4rxYDAHxkziUWsBhtki-3JrW1s26Hg=_8dd40_--

