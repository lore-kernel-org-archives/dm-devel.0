Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95FDDC4332F
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 07:02:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-cKrTLf6XOCmwCFotOBntwA-1; Fri, 20 May 2022 03:01:59 -0400
X-MC-Unique: cKrTLf6XOCmwCFotOBntwA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8179804196;
	Fri, 20 May 2022 07:01:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9282540D2821;
	Fri, 20 May 2022 07:01:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 53ABD194EB8F;
	Fri, 20 May 2022 07:01:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F049C1947058
 for <dm-devel@listman.corp.redhat.com>; Fri, 20 May 2022 06:59:47 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DF1AA7774; Fri, 20 May 2022 06:59:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BD4E57AE4
 for <dm-devel@redhat.com>; Fri, 20 May 2022 06:59:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9E7E2801210
 for <dm-devel@redhat.com>; Fri, 20 May 2022 06:59:47 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-328-kj83lgpdNZWv7z1p3juRFA-1; Fri, 20 May 2022 02:59:44 -0400
X-MC-Unique: kj83lgpdNZWv7z1p3juRFA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20220520065942euoutp024413cc124740891060c9d8e3233cca92~wvgLknZ5T3228532285euoutp02B
 for <dm-devel@redhat.com>; Fri, 20 May 2022 06:59:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20220520065942euoutp024413cc124740891060c9d8e3233cca92~wvgLknZ5T3228532285euoutp02B
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20220520065942eucas1p2c8721732b62af59ccfc2110b4655da17~wvgLVSAmh0722907229eucas1p2_;
 Fri, 20 May 2022 06:59:42 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
 eusmges3new.samsung.com (EUCPMTA) with SMTP id 9C.29.10260.E5C37826; Fri, 20
 May 2022 07:59:42 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
 20220520065941eucas1p105cf273ede995dc4bf92f3245fad09b1~wvgKPDE413192831928eucas1p1m;
 Fri, 20 May 2022 06:59:41 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220520065941eusmtrp119cec5b2f3eb4133ff4c909e1066456d~wvgKM9niN0344103441eusmtrp19;
 Fri, 20 May 2022 06:59:41 +0000 (GMT)
X-AuditID: cbfec7f5-bddff70000002814-c5-62873c5e7aec
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id F4.76.09522.D5C37826; Fri, 20
 May 2022 07:59:41 +0100 (BST)
Received: from CAMSVWEXC01.scsc.local (unknown [106.1.227.71]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20220520065941eusmtip2778dbf13ef9c02edb6e5f1e63237ea6b~wvgKAjsFg2107821078eusmtip2U;
 Fri, 20 May 2022 06:59:41 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC01.scsc.local
 (2002:6a01:e347::6a01:e347) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 20 May 2022 07:59:40 +0100
Date: Fri, 20 May 2022 08:59:39 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20220520065939.yjqlgsxs3qchpgzo@mpHalley-2.localdomain>
MIME-Version: 1.0
In-Reply-To: <be429864-09cb-e3fb-2afe-46a3453c4d73@opensource.wdc.com>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTZxjG851bDzUlh+rgHTq3ISabOtCo29F6YRku5x8G2T+iTkehZ0Bo
 i+ttg41ZblMoA2QLbIXgMhDQegsKEQdbZWuxAURoOinjoqHFDURBIRSnOMvRjf9+3/s8z/t9
 T/LRuPQBGUqnqnW8Ri1XhlFiotk+3/PWoR1HEzeWT6xiLUMlFPtPdw/Ott2rJNkbvmyMbf2p
 DGNPWWwY6zlvxtki6xTBPikcxti2gfVs32iDiG1tcxCs80oVxZ6o84rY/lIvYs+4vQSbXzQv
 igriFq6dobgW85CIc3brucbTBRR3sfYI97PbSHE5XTaca8kfIbn7v7go7vwlF8Fd7PyCe9i4
 mjtqNWFxkv3iHQpemWrgNZG7EsQpg1cH8MO21z+vscySRvQ4tBAF0MBsgUn7DaoQiWkp04Cg
 ZnwQ+QUpM4PAeT1TEB4iGL5dK3qR+N5TjQShHoHn3hT6z5VjySWEQxOC6tFszB8hmLVQ98cE
 7meK2Q19dQOLvILZCpNF+YsBnLlDQZ0zh/QLy5lYOH5lkPKzhImG7ptPCYGDwPGDZ5FxZjsU
 TPn99DNeCfULtDB+FXKbKhf3BzDvw+UJJ+a3ALMG6itihAZZcNbeJfJfC8yjAHhc5aIEIRoq
 TAtI4OUw3nHpeeVV0PltESFwGvR2mXCBdVBz344L+2VQ3KUUxu/CufwSShgHQv9kkPCyQChr
 rnjulsCxr6WlKNy8pJZ5SS3z/7XMS2r9iIjTKITXa1XJvHazmv8sQitXafXq5IikdFUjevYt
 Oxc6Zi+jhvHpiHaE0agdAY2HrZAgVV6iVKKQZ2TymvSPNXolr21HK2kiLESSlHpBLmWS5To+
 jecP85oXKkYHhBqxN8669P2kwRMMzQdXv3lnzJm4VbxNYc3FNMF5LbH4oLPW/sF09ElRa4Li
 6ga0mx+xpm0Xgel3dkbZc7c7yvfhLJC3quYOzZHmGXH8Xxv3pMorsyLSs7V7P32vXJEhXdb7
 6JtiW9aEdVfksrsjjqdxke2h3t/c3k8mZXtePuAL7+tdqxoP37Dvz+vH/naLh+ZqGmbJkp3m
 jLz1+6qJ8gLfS9iQWpN4arh5NObLlCgU/wANlJGS7+Y7Qhodrl8NbxvcTZm1N2+PXYu0+G5t
 VmWkHNkrM2TGHgx0GF4jdPxJY85H72ySTSd4q7cUnwveZpR9FZM0EzetKx2Lt+18xfQkjNCm
 yDetwzVa+b9FxuryBQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t/xe7qxNu1JBj9nC1msvtvPZvH77Hlm
 i73vZrNaXPjRyGSxZ9EkJouVq48yWTxZP4vZoufABxaLv133mCz23tK2uPR4BbvFnr0nWSwu
 75rDZjF/2VN2ixsTnjJarLn5lMWitecnu4Ogx78Ta9g8ds66y+5x+Wypx6ZVnWwem5fUe+y+
 2cDm0XTmKLPHztb7rB7v911l81i/5SqLx+bT1R6fN8l5tB/oZgrgjdKzKcovLUlVyMgvLrFV
 ija0MNIztLTQMzKx1DM0No+1MjJV0rezSUnNySxLLdK3S9DLuHPwFnPBUcWKxau/sjYw/pHq
 YuTkkBAwkZjxZB5jFyMXh5DAUkaJf38Ws0IkZCQ+XfnIDmELS/y51sUGUfSRUeLozslsIAkh
 ga2MEmsulYPYLAKqEsuuvWYGsdkE7CUuLbsFZosImEq87WllAWlmFnjKJnH+3U9GkISwgK/E
 1SlvWEBsXgEXibPX/7NAbFjCInHp41JGiISgxMmZT8CKmAUsJGbOPw8U5wCypSWW/+OACMtL
 NG+dDbaMU8BNYsfry0wgJRICyhLLp/tCPFAr8er+bsYJjCKzkAydhWToLIShs5AMXcDIsopR
 JLW0ODc9t9hQrzgxt7g0L10vOT93EyMwnWw79nPzDsZ5rz7qHWJk4mA8xCjBwawkwsuY25Ik
 xJuSWFmVWpQfX1Sak1p8iNEUGEQTmaVEk/OBCS2vJN7QzMDU0MTM0sDU0sxYSZzXs6AjUUgg
 PbEkNTs1tSC1CKaPiYNTqoEpQNSsz/fuIQbdhzqvWlK3CRjn5c/2c+x4Ycs385PYpcz7fcdW
 Fttc2X3ZJEIz0rlr9ivNI4a9ug217xYvX25flT7RM0//m3tC56tJbVoGR7y3Pn7w5GzL1ca2
 /LgjzaHO99gbPPaHR+Ts5mxbZ6LBfkrCafY84Y9HZ00ROcL26VWOScYXph3nY3d7L79bePum
 Pmv7niiejxPbH6npPtF5Om36va74CRlJJ/Vlgn3aXa0S/sy9WHc10ftm45HNSTYP2mV/VHod
 Y7RJXG7avZjhyrZrJyItE6TObnPxyPwh2v5+gdB1uwnZ6xteGielz3NkmWaYsGbVy7L8qt6e
 lgf3z6za/ZvrwqnsA+LdzNJKLMUZiYZazEXFiQDpv0hasAMAAA==
X-CMS-MailID: 20220520065941eucas1p105cf273ede995dc4bf92f3245fad09b1
X-Msg-Generator: CA
X-RootMTR: 20220520065941eucas1p105cf273ede995dc4bf92f3245fad09b1
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20220520065941eucas1p105cf273ede995dc4bf92f3245fad09b1
References: <20220517081048.GA13947@lst.de> <YoPAnj9ufkt5nh1G@mit.edu>
 <7f9cb19b-621b-75ea-7273-2d2769237851@opensource.wdc.com>
 <20220519031237.sw45lvzrydrm7fpb@garbanzo>
 <69f06f90-d31b-620b-9009-188d1d641562@opensource.wdc.com>
 <PH0PR04MB74166C87F694B150A5AE0F009BD09@PH0PR04MB7416.namprd04.prod.outlook.com>
 <4a8f0e1b-0acb-1ed4-8d7a-c9ba93fcfd02@opensource.wdc.com>
 <16f3f9ee-7db7-2173-840c-534f67bcaf04@suse.de>
 <20220520062720.wxdcp5lkscesppch@mpHalley-2.localdomain>
 <be429864-09cb-e3fb-2afe-46a3453c4d73@opensource.wdc.com>
 <CGME20220520065941eucas1p105cf273ede995dc4bf92f3245fad09b1@eucas1p1.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Fri, 20 May 2022 07:01:49 +0000
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
 Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
 "jiangbo.365@bytedance.com" <jiangbo.365@bytedance.com>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dsterba@suse.com" <dsterba@suse.com>, Luis Chamberlain <mcgrof@kernel.org>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"

T24gMjAuMDUuMjAyMiAxNTo0MSwgRGFtaWVuIExlIE1vYWwgd3JvdGU6Cj5PbiA1LzIwLzIyIDE1
OjI3LCBKYXZpZXIgR29uesOhbGV6IHdyb3RlOgo+PiBPbiAyMC4wNS4yMDIyIDA4OjA3LCBIYW5u
ZXMgUmVpbmVja2Ugd3JvdGU6Cj4+PiBPbiA1LzE5LzIyIDIwOjQ3LCBEYW1pZW4gTGUgTW9hbCB3
cm90ZToKPj4+PiBPbiA1LzE5LzIyIDE2OjM0LCBKb2hhbm5lcyBUaHVtc2hpcm4gd3JvdGU6Cj4+
Pj4+IE9uIDE5LzA1LzIwMjIgMDU6MTksIERhbWllbiBMZSBNb2FsIHdyb3RlOgo+Pj4+Pj4gT24g
NS8xOS8yMiAxMjoxMiwgTHVpcyBDaGFtYmVybGFpbiB3cm90ZToKPj4+Pj4+PiBPbiBUaHUsIE1h
eSAxOSwgMjAyMiBhdCAxMjowODoyNlBNICswOTAwLCBEYW1pZW4gTGUgTW9hbCB3cm90ZToKPj4+
Pj4+Pj4gT24gNS8xOC8yMiAwMDozNCwgVGhlb2RvcmUgVHMnbyB3cm90ZToKPj4+Pj4+Pj4+IE9u
IFR1ZSwgTWF5IDE3LCAyMDIyIGF0IDEwOjEwOjQ4QU0gKzAyMDAsIENocmlzdG9waCBIZWxsd2ln
IHdyb3RlOgo+Pj4+Pj4+Pj4+IEknbSBhIGxpdHRsZSBzdXJwcmlzZWQgYWJvdXQgYWxsIHRoaXMg
YWN0aXZpdHkuCj4+Pj4+Pj4+Pj4KPj4+Pj4+Pj4+PiBJIHRob3VnaCB0aGUgY29uY2x1c2lvbiBh
dCBMU0YvTU0gd2FzIHRoYXQgZm9yIExpbnV4IGl0c2VsZiB0aGVyZQo+Pj4+Pj4+Pj4+IGlzIHZl
cnkgbGl0dGxlIGJlbmVmaXQgaW4gc3VwcG9ydGluZyB0aGlzIHNjaGVtZS4gIEl0IHdpbGwgbWFz
c2l2ZWx5Cj4+Pj4+Pj4+Pj4gZnJhZ21lbnQgdGhlIHN1cHBvcnRlZCBiYXNlZCBvZiBkZXZpY2Vz
IGFuZCBhcHBsaWNhdGlvbnMsIHdoaWxlIG9ubHkKPj4+Pj4+Pj4+PiBoYXZpbmcgdGhlIGJlbmVm
aXQgb2Ygc3VwcG9ydGluZyBzb21lIFNhbXN1bmcgbGVnYWN5IGRldmljZXMuCj4+Pj4+Pj4+Pgo+
Pj4+Pj4+Pj4gRldJVywKPj4+Pj4+Pj4+Cj4+Pj4+Pj4+PiBUaGF0IHdhc24ndCBteSBpbXByZXNz
aW9uIGZyb20gdGhhdCBMU0YvTU0gc2Vzc2lvbiwgYnV0IG9uY2UgdGhlCj4+Pj4+Pj4+PiB2aWRl
b3MgYmVjb21lIGF2YWlsYWJsZSwgZm9sa3MgY2FuIGRlY2lkZSBmb3IgdGhlbXNlbHZlcy4KPj4+
Pj4+Pj4KPj4+Pj4+Pj4gVGhlcmUgd2FzIG5vIHJlYWwgZGlzY3Vzc2lvbiBhYm91dCB6b25lIHNp
emUgY29uc3RyYWludCBvbiB0aGUgem9uZQo+Pj4+Pj4+PiBzdG9yYWdlIEJvRi4gTWFueSBkaXNj
dXNzaW9ucyBoYXBwZW5lZCBpbiB0aGUgaGFsbHdheSB0cmFjayB0aG91Z2guCj4+Pj4+Pj4KPj4+
Pj4+PiBSaWdodCBzbyBubyBkaXJlY3QgY2xlYXIgYmxvY2tlcnMgbWVudGlvbmVkIGF0IGFsbCBk
dXJpbmcgdGhlIEJvRi4KPj4+Pj4+Cj4+Pj4+PiBOb3IgYW55IGNsZWFyIE9LLgo+Pj4+Pgo+Pj4+
PiBTbyB3aGF0IGFib3V0IGNyZWF0aW5nIGEgZGV2aWNlLW1hcHBlciB0YXJnZXQsIHRoYXQncyB0
YWtpbmcgbnBvMiBkcml2ZXMgYW5kCj4+Pj4+IG1ha2VzIHRoZW0gcG8yIGRyaXZlcyBmb3IgdGhl
IEZTIGxheWVycz8gSXQgd2lsbCBiZSB2ZXJ5IHNpbWlsYXIgY29kZSB0bwo+Pj4+PiBkbS1saW5l
YXIuCj4+Pj4KPj4+PiArMQo+Pj4+Cj4+Pj4gVGhpcyB3aWxsIHNpbXBsaWZ5IHRoZSBzdXBwb3J0
IGZvciBGU2VzLCBhdCBsZWFzdCBmb3IgdGhlIGluaXRpYWwgZHJvcCAoaWYKPj4+PiBhY2NlcHRl
ZCkuCj4+Pj4KPj4+PiBBbmQgbW9yZSBpbXBvcnRhbnRseSwgdGhpcyB3aWxsIGFsc28gYWxsb3cg
YWRkcmVzc2luZyBhbnkgcG90ZW50aWFsCj4+Pj4gcHJvYmxlbSB3aXRoIHVzZXIgc3BhY2UgYnJl
YWtpbmcgYmVjYXVzZSBvZiB0aGUgbm9uIHBvd2VyIG9mIDIgem9uZSBzaXplLgo+Pj4+Cj4+PiBT
ZWNvbmRlZCAob3IgbWF5YmUgdGhpcmRlZCkuCj4+Pgo+Pj4gVGhlIGNoYW5nZXMgdG8gc3VwcG9y
dCBucG8yIGluIHRoZSBibG9jayBsYXllciBhcmUgcHJldHR5IHNpbXBsZSwgYW5kCj4+PiByZWFs
bHkgSSBkb24ndCBoYXZlIGFuIGlzc3VlIHdpdGggdGhvc2UuCj4+PiBUaGVuIGFkZGluZyBhIGRl
dmljZS1tYXBwZXIgdGFyZ2V0IHRyYW5zZm9ybWluZyBucG8yIGRyaXZlcyBpbiBwbzIKPj4+IGJs
b2NrIGRldmljZXMgc2hvdWxkIGJlIHByZXR0eSB0cml2aWFsLgo+Pj4KPj4+IEFuZCBvbmNlIHRo
YXQgaXMgaW4geW91IGNhbiBzdGFydCBhcmd1aW5nIHdpdGggdGhlIHRoZSBGUyBmb2xrcyBvbgo+
Pj4gd2hldGhlciB0byBpbXBsZW1lbnQgaXQgbmF0aXZlbHkuCj4+Pgo+Pgo+PiBTbyB5b3UgYXJl
IHN1Z2dlc3RpbmcgYWRkaW5nIHN1cHBvcnQgZm9yICFQTzIgaW4gdGhlIGJsb2NrIGxheWVyIGFu
ZAo+PiB0aGVuIGEgZG0gdG8gcHJlc2VudCB0aGUgZGV2aWNlIGFzIGEgUE8yIHRvIHRoZSBGUz8g
VGhpcyBhdCBsZWFzdAo+PiBhZGRyZXNzZXMgdGhlIGhvbGUgaXNzdWUgZm9yIHJhdyB6b25lZCBi
bG9jayBkZXZpY2VzLCBzbyBpdCBjYW4gYmUgYQo+PiBmaXJzdCBzdGVwLgo+Cj5ZZXMsIGFuZCBp
dCBhbHNvIGFsbG93cyBzdXBwb3J0aW5nIHRoZXNlIG5ldyAhcG8yIGRldmljZXMgd2l0aG91dAo+
cmVncmVzc2lvbnMgKHJlYWQgbGFjayBvZikgaW4gdGhlIHN1cHBvcnQgYXQgRlMgbGV2ZWwuCj4K
Pj4KPj4gVGhpcyBzYWlkLCBpdCBzZWVtcyB0byBtZSB0aGF0IHRoZSBjaGFuZ2VzIHRvIHRoZSBG
UyBhcmUgbm90IGJlaW5nIGEKPj4gcmVhbCBpc3N1ZS4gSW4gZmFjdCwgd2UgYXJlIGV4cG9zaW5n
IHNvbWUgYnVncyB3aGlsZSB3ZSBnZW5lcmFsaXplIHRoZQo+PiB6b25lIHNpemUgc3VwcG9ydC4K
Pgo+Tm90IGFyZ3Vpbmcgd2l0aCB0aGF0LiBCdXQgc2luY2Ugd2UgYXJlIHN0aWxsIHN0YWJpbGl6
aW5nIGJ0cmZzIFpOUwo+c3VwcG9ydCwgYWRkaW5nIG1vcmUgY29kZSByaWdodCBub3cgaXMgYSBs
aXR0bGUgcGFpbmZ1bC4KPgo+Pgo+PiBDb3VsZCB5b3UgcG9pbnQgb3V0IHdoYXQgdGhlIGNoYWxs
ZW5nZXMgaW4gYnRyZnMgYXJlIGluIHRoZSBjdXJyZW50Cj4+IHBhdGNoZXMsIHRoYXQgaXQgbWFr
ZXMgc2Vuc2UgdG8gYWRkIGFuIGV4dHJhIGRtIGxheWVyPwo+Cj5TZWUgYWJvdmUuIE5vIHJlYWwg
Y2hhbGxlbmdlLCBqdXN0IG5lZWRzIHRvIGJlIGRvbmUgaWYgYSBjbGVhciBhZ3JlZW1lbnQKPmNh
biBiZSByZWFjaGVkIG9uIHpvbmUgc2l6ZSBhbGlnbm1lbnQgY29uc3RyYWludHMuIEFzIG1lbnRp
b25lZCBhYm92ZSwgdGhlCj5idHJmcyBjaGFuZ2VzIHRpbWluZyBpcyBub3QgaWRlYWwgcmlnaHQg
bm93IHRob3VnaC4KPgo+QWxzbyBwbGVhc2UgZG8gbm90IGZvcmdldCBhcHBsaWNhdGlvbnMgdGhh
dCBtYXkgZXhwZWN0IGEgcG93ZXIgb2YgMiB6b25lCj5zaXplLiBBIGRtLXpzcDIgd291bGQgYmUg
YSBuaWNlIHNvbHV0aW9uIGZvciB0aGVzZS4gU28gcmVnYXJkbGVzcyBvZiB0aGUKPkZTIHdvcmss
IHRoYXQgbmV3IERNIHRhcmdldCB3aWxsIGJlICp2ZXJ5KiBuaWNlIHRvIGhhdmUuCj4KPj4KPj4g
Tm90ZSB0aGF0IGZvciBGMkZTIHRoZXJlIGlzIG5vIGJsb2NrZXIuIEphZWdldWsgcGlja2VkIHRo
ZSBpbml0aWFsCj4+IHBhdGNoZXMsIGFuZCBoZSBhZ3JlZWQgdG8gYWRkIG5hdGl2ZSBzdXBwb3J0
Lgo+Cj5BbmQgdW50aWwgdGhhdCBpcyBkb25lLCBmMmZzIHdpbGwgbm90IHdvcmsgd2l0aCB0aGVz
ZSBuZXcgIXBvMiBkZXZpY2VzLi4uCj5IYXZpbmcgdGhlIG5ldyBkbSB3aWxsIGF2b2lkIHRoYXQg
c3VwcG9ydCBmcmFnbWVudGF0aW9uIHdoaWNoIEkgcGVyc29uYWxseQo+cmVhbGx5IGRpc2xpa2Uu
IFdpdGggdGhlIG5ldyBkbSwgd2UgY2FuIGtlZXAgc3VwcG9ydCBmb3IgKmFsbCogem9uZWQgYmxv
Y2sKPmRldmljZXMsIGFsYmVpdCBuZWVkaW5nIGEgZGlmZmVyZW50IHNldHVwIGRlcGVuZGluZyBv
biB0aGUgZGV2aWNlLiBUaGF0IGlzCj5ub3QgbmljZSBhdCBhbGwgYnV0IGF0IGxlYXN0IHRoZXJl
IGlzIGEgd2F5IHRvIG1ha2UgdGhpbmdzIHdvcmsgY29udGludW91c2x5LgoKQWxsIHRoZSBhYm92
ZSBzb3VuZHMgdmVyeSByZWFzb25hYmxlLiBUaGFua3MgRGFtaWVuLgoKSWYgd2UgYWxsIGNhbiBh
Z3JlZSwgd2UgY2FuIGFkZHJlc3MgdGhpcyBpbiB0aGUgbmV4dCB2ZXJzaW9uIGFuZCBjb21lCm1h
aW50YWluIHRoZSBuYXRpdmUgRlMgc3VwcG9ydCBvZmYtdHJlZSB1bnRpbCB5b3Ugc2VlIHRoYXQg
Z2VuZXJhbCBidHJmcwpzdXBwb3J0IGZvciB6b25lZCBkZXZpY3NlIGlzIHN0YWJsZS4gV2Ugd2ls
bCBiZSBoYXBweSB0byBoZWxwIHdpdGggdGhpcwp0b28uCgotLQpkbS1kZXZlbCBtYWlsaW5nIGxp
c3QKZG0tZGV2ZWxAcmVkaGF0LmNvbQpodHRwczovL2xpc3RtYW4ucmVkaGF0LmNvbS9tYWlsbWFu
L2xpc3RpbmZvL2RtLWRldmVsCg==

