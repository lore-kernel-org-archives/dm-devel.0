Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B81C43219
	for <dm-devel@archiver.kernel.org>; Wed, 25 May 2022 07:23:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-134-Kvw0qVDxNCeAPGaPEo3kpA-1; Wed, 25 May 2022 03:23:02 -0400
X-MC-Unique: Kvw0qVDxNCeAPGaPEo3kpA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4900618E004B;
	Wed, 25 May 2022 07:22:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AF5CC1415110;
	Wed, 25 May 2022 07:22:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6034E193212A;
	Wed, 25 May 2022 07:22:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 556C71947058
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 10:16:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38FE71121319; Fri, 20 May 2022 10:16:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 349B71121314
 for <dm-devel@redhat.com>; Fri, 20 May 2022 10:16:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D63B41C04B55
 for <dm-devel@redhat.com>; Fri, 20 May 2022 10:16:14 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-50t_IsTdOuCAWPnvNdLvcQ-1; Fri, 20 May 2022 06:16:13 -0400
X-MC-Unique: 50t_IsTdOuCAWPnvNdLvcQ-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220520101611euoutp025852910a2a17ca7dea7ade0d9a7db3c2~wyLvCfDCb2222122221euoutp02-
 for <dm-devel@redhat.com>; Fri, 20 May 2022 10:16:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220520101611euoutp025852910a2a17ca7dea7ade0d9a7db3c2~wyLvCfDCb2222122221euoutp02-
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20220520101611eucas1p13dd922345f7e91a0211cced9694b3ca9~wyLuh2GuU0792907929eucas1p1Q;
 Fri, 20 May 2022 10:16:11 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 07.A9.10009.B6A67826; Fri, 20
 May 2022 11:16:11 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220520101610eucas1p1822ca6014e2a1d55ae74476f83c4de1d~wyLuEwPad0813608136eucas1p1M;
 Fri, 20 May 2022 10:16:10 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220520101610eusmtrp1b047ec44358d3e2d4b2d8fd18217aacf~wyLuDudnP3260932609eusmtrp1e;
 Fri, 20 May 2022 10:16:10 +0000 (GMT)
X-AuditID: cbfec7f2-e95ff70000002719-0a-62876a6b4f0d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 76.A7.09522.A6A67826; Fri, 20
 May 2022 11:16:10 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
 20220520101610eusmtip1c7c8b787f20b055e8d604b8a9c64259c~wyLt1hgig2764527645eusmtip1t;
 Fri, 20 May 2022 10:16:10 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 20 May 2022 11:16:09 +0100
Date: Fri, 20 May 2022 12:16:08 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Message-ID: <20220520101608.m6lngep5bvp22k6p@ArmHalley.local>
MIME-Version: 1.0
In-Reply-To: <PH0PR04MB741634259FDCF264BF1CA7259BD39@PH0PR04MB7416.namprd04.prod.outlook.com>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAKsWRmVeSWpSXmKPExsWy7djPc7rZWe1JBi+milmsvtvPZvH77Hlm
 i73vZrNaXPjRyGSxZ9EkJouVq48yWTxZP4vZoufABxaLv133mCz23tK2uPR4BbvFnr0nWSwu
 75rDZjF/2VN2ixsTnjJarLn5lMWitecnu4Ogx78Ta9g8ds66y+5x+Wypx6ZVnWwem5fUe+y+
 2cDm0XTmKLPHztb7rB7v911l81i/5SqLx+bT1R6fN8l5tB/oZgrgjeKySUnNySxLLdK3S+DK
 uHnwD1vBep6KJbM+MzcwNnN1MXJySAiYSHRN+cXYxcjFISSwglHi2cKVLBDOF0aJX/OXQjmf
 GSXWTNjKAtPSeWMJM0RiOaPEwrfTWEESYFVPHptCJLYySkx985qti5GDg0VAVeLpI22QGjYB
 e4lLy24xg4RFBIwlfq6zBilnFnjOJrH01w92kBphAX+JibvusIHYvAK2Esd2NjBD2IISJ2c+
 ATuCWcBKovNDEyvIHGYBaYnl/zggwvISzVtng5VzCsRKtD5ZAFYiIaAssXy6L8T5tRJrj51h
 B1krIfCJU6L1SCMTRMJFor/3CCOELSzx6vgWdghbRuL05B6o37MlLp7pZoawSyQWvz/GDDHf
 WqLvTA5E2FFi16T/jBBhPokbbwUhLuOTmLRtOlQ1r0RHm9AERpVZSN6aheStWQhvzULy1gJG
 llWM4qmlxbnpqcWGeanlesWJucWleel6yfm5mxiBifL0v+OfdjDOffVR7xAjEwfjIUYJDmYl
 EV7G3JYkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzJmRsShQTSE0tSs1NTC1KLYLJMHJxSDUyG
 nEIXztz3vhu9S/FVmABz2MlOXaaDKbsD2bYtdfEyLQz+7Pr8jYyjzfrSV4J3EtXtd55n9NDU
 vfO8svHUHd7DJTesQ3LTL05oPO3rNEdm2pwY5wrVfz+ezSwsqJoVtPvSQ+Eb8sI36367rpv8
 OUszwsj6d2Dit5po1e1fdd88W3muat/9OW89w4RLJ+k8sHmdJ7Xp8ami/cYyvierZucv/yXk
 JLr31ZfgH0dfrKg7+tX8RtyVDz1SeQceyhfdtOoyqTgSfL9HZ664sYjwlNYDcx7c8na996c/
 6UX/qYOLIz6J3+UqZbm19NkXz9kve/bsvrz2q9Ox0Pp1BxLU/9zdEOP/fN5V/ndFC2cZGxvL
 KrEUZyQaajEXFScCAP71JLADBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t/xu7pZWe1JBm9uGVisvtvPZvH77Hlm
 i73vZrNaXPjRyGSxZ9EkJouVq48yWTxZP4vZoufABxaLv133mCz23tK2uPR4BbvFnr0nWSwu
 75rDZjF/2VN2ixsTnjJarLn5lMWitecnu4Ogx78Ta9g8ds66y+5x+Wypx6ZVnWwem5fUe+y+
 2cDm0XTmKLPHztb7rB7v911l81i/5SqLx+bT1R6fN8l5tB/oZgrgjdKzKcovLUlVyMgvLrFV
 ija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DLuHnwD1vBep6KJbM+MzcwNnN1
 MXJySAiYSHTeWMLcxcjFISSwlFHi5dU/bBAJGYlPVz6yQ9jCEn+udbFBFH1klPh7/yErhLOV
 UeLJ/DdA7RwcLAKqEk8faYM0sAnYS1xadgssLCJgLPFznTVIObPAUzaJxR9PsIDUCAv4Slyd
 8gbM5hWwlTi2swHqit0sEucXLIVKCEqcnPkEzGYWsJCYOf88I8hQZgFpieX/OCDC8hLNW2cz
 g9icArESrU8WsIKUSAgoSyyf7gtxf63Eq/u7GScwisxCMnQWkqGzEIbOQjJ0ASPLKkaR1NLi
 3PTcYkO94sTc4tK8dL3k/NxNjMBksu3Yz807GOe9+qh3iJGJg/EQowQHs5IIL2NuS5IQb0pi
 ZVVqUX58UWlOavEhRlNgAE1klhJNzgems7ySeEMzA1NDEzNLA1NLM2MlcV7Pgo5EIYH0xJLU
 7NTUgtQimD4mDk6pBibmupTz6mKn6297tPhpBH5z/B5ZeVtmweyHqhETZLJSC8yqVDfv77e8
 qPJPRajC484M9dSph6Q60lb5T7zUfrWySDxlocBNE4UP4ntUFe98XbZVTeUxU2W1Bae2h4tL
 4FmZS1e+sP5OMuotX35x8vb4h5sufNTOy3RZffpzxfK4pIcfqm4+eJvPt2HvRP4bNXETg48a
 uF05tK5SwKyCs5/z/aV5M/T3cm9S6xWQYq/Yta3rYnLK1gMbDPZP97/p+VDL6qmbQZxl9twD
 cTymGg6xEdLZ7mEKRYa5McqX1rC8vPXhGvMV2eWnG1M0jEtOqE/vOCYn3LJYwWi/RLoAc+jL
 W8mabN/MGBcbbPPfp8RSnJFoqMVcVJwIAH96gSuvAwAA
X-CMS-MailID: 20220520101610eucas1p1822ca6014e2a1d55ae74476f83c4de1d
X-Msg-Generator: CA
X-RootMTR: 20220520101610eucas1p1822ca6014e2a1d55ae74476f83c4de1d
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220520101610eucas1p1822ca6014e2a1d55ae74476f83c4de1d
References: <20220517081048.GA13947@lst.de> <YoPAnj9ufkt5nh1G@mit.edu>
 <7f9cb19b-621b-75ea-7273-2d2769237851@opensource.wdc.com>
 <20220519031237.sw45lvzrydrm7fpb@garbanzo>
 <69f06f90-d31b-620b-9009-188d1d641562@opensource.wdc.com>
 <PH0PR04MB74166C87F694B150A5AE0F009BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
 <4a8f0e1b-0acb-1ed4-8d7a-c9ba93fcfd02@opensource.wdc.com>
 <16f3f9ee-7db7-2173-840c-534f67bcaf04@suse.de>
 <20220520062720.wxdcp5lkscesppch@mpHalley-2.localdomain>
 <PH0PR04MB741634259FDCF264BF1CA7259BD39@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20220520101610eucas1p1822ca6014e2a1d55ae74476f83c4de1d@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Wed, 25 May 2022 07:22:55 +0000
Subject: Re: [dm-devel] [PATCH v4 00/13] support non power of 2 zoned devices
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
Cc: Pankaj Raghav <p.raghav@samsung.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
 Theodore Ts'o <tytso@mit.edu>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "pankydev8@gmail.com" <pankydev8@gmail.com>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dsterba@suse.com" <dsterba@suse.com>, Luis Chamberlain <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMjAuMDUuMjAyMiAwOTozMCwgSm9oYW5uZXMgVGh1bXNoaXJuIHdyb3RlOgo+T24gMjAvMDUv
MjAyMiAwODoyNywgSmF2aWVyIEdvbnrDoWxleiB3cm90ZToKPj4gU28geW91IGFyZSBzdWdnZXN0
aW5nIGFkZGluZyBzdXBwb3J0IGZvciAhUE8yIGluIHRoZSBibG9jayBsYXllciBhbmQKPj4gdGhl
biBhIGRtIHRvIHByZXNlbnQgdGhlIGRldmljZSBhcyBhIFBPMiB0byB0aGUgRlM/IFRoaXMgYXQg
bGVhc3QKPj4gYWRkcmVzc2VzIHRoZSBob2xlIGlzc3VlIGZvciByYXcgem9uZWQgYmxvY2sgZGV2
aWNlcywgc28gaXQgY2FuIGJlIGEKPj4gZmlyc3Qgc3RlcC4KPj4KPj4gVGhpcyBzYWlkLCBpdCBz
ZWVtcyB0byBtZSB0aGF0IHRoZSBjaGFuZ2VzIHRvIHRoZSBGUyBhcmUgbm90IGJlaW5nIGEKPj4g
cmVhbCBpc3N1ZS4gSW4gZmFjdCwgd2UgYXJlIGV4cG9zaW5nIHNvbWUgYnVncyB3aGlsZSB3ZSBn
ZW5lcmFsaXplIHRoZQo+PiB6b25lIHNpemUgc3VwcG9ydC4KPj4KPj4gQ291bGQgeW91IHBvaW50
IG91dCB3aGF0IHRoZSBjaGFsbGVuZ2VzIGluIGJ0cmZzIGFyZSBpbiB0aGUgY3VycmVudAo+PiBw
YXRjaGVzLCB0aGF0IGl0IG1ha2VzIHNlbnNlIHRvIGFkZCBhbiBleHRyYSBkbSBsYXllcj8KPgo+
SSBwZXJzb25hbGx5IGRvbid0IGxpa2UgdGhlIHBhZGRpbmcgd2UgbmVlZCB0byBkbyBmb3IgdGhl
IHN1cGVyIGJsb2NrLgo+Cj5BcyBJJ3ZlIHBvaW50ZWQgb3V0IHRvIFBhbmthaiBhbHJlYWR5LCBJ
IGRvbid0IHRoaW5rIGl0IGlzIDEwMCUgcG93ZXJmYWlsCj5zYWZlIGFzIG9mIG5vdy4gSXQgY291
bGQgcHJvYmFibHkgYmUgbWFkZSwgYnV0IHRoYXQgd291bGQgYWxzbyBpbnZvbHZlCj5jaGFuZ2lu
ZyBub24tem9uZWQgYnRyZnMgY29kZSB3aGljaCB3ZSB0cnkgdG8gYXZvaWQgYXMgbXVjaCBhcyB3
ZSBjYW4uCj4KPkFzIERhbWllbiBhbHJlYWR5IHNhaWQsIHdlIHN0aWxsIGhhdmUgaXNzdWVzIHdp
dGggdGhlIGdlbmVyYWwgem9uZWQKPnN1cHBvcnQgaW4gYnRyZnMsIGp1c3QgaGF2ZSBhIGxvb2sg
YXQgdGhlIGxpc3Qgb2Ygb3BlbiBpc3N1ZXMgWzFdIHdlCj5oYXZlLgo+ClNvdW5kcyBnb29kIEpv
aGFubmVzLiBJIHVuZGVyc3RhbmQgdGhhdCB0aGUgcHJpb3JpdHkgaXMgdG8gbWFrZSBidHJmcwpz
dGFibGUgbm93LCBiZWZvcmUgaW50cm9kdWNpbmcgbW9yZSB2YXJpYWJsZXMuIExldCdzIHN0aWNr
IHRvIHRoaXMgYW5kCnRoZW4gd2UgY2FuIGJyaW5nIGl0IGJhY2sgYXMgdGhlIGxpc3Qgb2Ygb3Bl
biBpc3N1ZXMgYmVjb21lcyBtb3JlCm1hbmFnZWFibGUuCgo+WzFdIGh0dHBzOi8vcHJvdGVjdDIu
ZmlyZWV5ZS5jb20vdjEvdXJsP2s9ZjE0YTFkNmYtOTBjMTA4NTktZjE0Yjk2MjAtNzRmZTQ4NWZm
ZmUwLTNmMTg2MWU3NzM5ZDhjYzcmcT0xJmU9MjEzZmNjMjgtM2Y5ZC00MWExLWI2NTMtMGRjMGUy
MDNjNzE4JnU9aHR0cHMlM0ElMkYlMkZnaXRodWIuY29tJTJGbmFvdGElMkZsaW51eCUyRmlzc3Vl
cyUyRgoKVGhhbmtzIGZvciBzaGFyaW5nIHRoaXMgdG9vLiBJdCBpcyBhIGdvb2Qgd2F5IHRvIHdo
ZXJlIHRvIGhlbHAKCi0tCmRtLWRldmVsIG1haWxpbmcgbGlzdApkbS1kZXZlbEByZWRoYXQuY29t
Cmh0dHBzOi8vbGlzdG1hbi5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2ZWwK

