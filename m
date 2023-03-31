Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F47EC76196
	for <dm-devel@archiver.kernel.org>; Fri, 31 Mar 2023 12:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680265688;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=b+SBTJKQ8fbpztxO2uSsXFvFgQcWzcXttIMD5rhobrw=;
	b=Klo49Uk0BUdMbjIG6DI4akrm17/c4X4skvkXCnVajhzKGhPNsO+mNzjfNmzobSAdDkcBRV
	zLQa7LJ+nyOmLVPtK6is7VWM16dVREVCf/z3Drwry6CpxL5RhEzMWaMpFTeazK4+6saupp
	Sj+guVKjKWMKSbZqD4sqfzDpYPjWI74=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-343-1cmT0CT2M9Cnnp54tKhPhg-1; Fri, 31 Mar 2023 08:28:04 -0400
X-MC-Unique: 1cmT0CT2M9Cnnp54tKhPhg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D9BAC801206;
	Fri, 31 Mar 2023 12:28:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8B7D41415117;
	Fri, 31 Mar 2023 12:28:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3415F19465BD;
	Fri, 31 Mar 2023 12:27:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D20C1946A41
 for <dm-devel@listman.corp.redhat.com>; Fri, 31 Mar 2023 12:27:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 55B8A1415119; Fri, 31 Mar 2023 12:27:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D31C1415117
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 12:27:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3106385C6E4
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 12:27:14 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
 [210.118.77.11]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-210-b3CZvOEWMgC5AiSNPucA7w-1; Fri, 31 Mar 2023 08:27:10 -0400
X-MC-Unique: b3CZvOEWMgC5AiSNPucA7w-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
 20230331122047euoutp01b141e0dc14fdafd925953b22693f34a7~RgFcIzNtb3266232662euoutp01i
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 12:20:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
 20230331122047euoutp01b141e0dc14fdafd925953b22693f34a7~RgFcIzNtb3266232662euoutp01i
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTP id
 20230331122046eucas1p2dd047848b60f9ddc31dd7b266bd86d77~RgFbxwOsi1098310983eucas1p24;
 Fri, 31 Mar 2023 12:20:46 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges1new.samsung.com (EUCPMTA) with SMTP id 14.78.09503.E10D6246; Fri, 31
 Mar 2023 13:20:46 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20230331122046eucas1p247e0cd2d06229a6b7cae9cb26ea43d5b~RgFbZahPc1098310983eucas1p23;
 Fri, 31 Mar 2023 12:20:46 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230331122046eusmtrp238c8959c39aa187032906ac97e80131b~RgFbYiwNm2670526705eusmtrp2U;
 Fri, 31 Mar 2023 12:20:46 +0000 (GMT)
X-AuditID: cbfec7f2-ea5ff7000000251f-bf-6426d01eee9e
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms2.samsung.com (EUCPMTA) with SMTP id F3.4E.09583.E10D6246; Fri, 31
 Mar 2023 13:20:46 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230331122046eusmtip2b8baf2b87eb1e2370ba007aa92d0a40b~RgFbLcVLU2523725237eusmtip2g;
 Fri, 31 Mar 2023 12:20:46 +0000 (GMT)
Received: from localhost (106.110.32.140) by CAMSVWEXC02.scsc.local
 (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 31 Mar 2023 13:20:45 +0100
Date: Fri, 31 Mar 2023 14:12:29 +0200
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Message-ID: <20230331121156.7c7nbxfhagdufpzo@blixen>
MIME-Version: 1.0
In-Reply-To: <7849b142e073b20f033e5124a39080f59e5f19d2.1680108414.git.johannes.thumshirn@wdc.com>
X-Originating-IP: [106.110.32.140]
X-ClientProxiedBy: CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348) To
 CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBKsWRmVeSWpSXmKPExsWy7djPc7pyF9RSDBZPM7TYtm43u8Xqu/1s
 FidXP2azaG3/xmSx991sVosLPxqZLPYsmsRksXL1USaLix9bmSz+dt1jsnh6dRZQyS1ti0uP
 V7Bb7Nl7ksXi3pr/rBbt83cxWhya3Mxk0TW7lc3i9p0fzBYnbklbHF/+l83i9485bA5iHptX
 aHlcPlvqsWlVJ5vHpk+T2D12L/jM5LH7ZgObR2/zOzaP9/uusnms33KVxWPz6WqPz5vkPNoP
 dDMF8ERx2aSk5mSWpRbp2yVwZcz/doOtYCNzxfprsQ2Mj5i6GDk5JARMJI5NaGHsYuTiEBJY
 wSixunsRG4TzhVFi1+QXrBDOZ0aJ7a+uw7WceLyHBSKxnFFiX9M2Rriq46eeQjlbGCUuntsE
 1sIioCqx4etl9i5GDg42AS2Jxk52kLCIgLHEle8LwSYxC5xmlVh4/QsrSEJYwE2ibepCsCJe
 oHVH7ixnhLAFJU7OfMICYjML6Egs2P2JDWQms4C0xPJ/HCBhToFEiZt7FkBdqiTRsPkMC4Rd
 K7G3+QA7hP2NU+LUCiEI20Vix+rNUPXCEq+Ob4GqkZH4v3M+VLxa4umN38wgd0oItDBK9O9c
 D7ZXQsBaou9MDoTpKLFrii2EySdx460gxJF8EpO2TWeGCPNKdLRBLVWT2NG0lXECo/IsJG/N
 QvLWLIS3FjAyr2IUTy0tzk1PLTbMSy3XK07MLS7NS9dLzs/dxAhMnKf/Hf+0g3Huq496hxiZ
 OBgPMUpwMCuJ8BYaq6YI8aYkVlalFuXHF5XmpBYfYpTmYFES59W2PZksJJCeWJKanZpakFoE
 k2Xi4JRqYGJ/Mq99ttHmVS9fhk9x2O7O7HvTf+/R+lhRfRXOv75H4oX0PF9zSC0zsTrB2Hsi
 eKO1iPxXL+MvIfrzNi9OcG46+ol153PN+JnpYbKbTDaqOVs9D1OquC2Qvc6bJZbv0SouaanZ
 J+X3chn66V2wn3wx+Nano/cD+ev+KYgXdvDKXHV6X3w0czGPM8dGn7d1vwrNFazUsroWMtkd
 +Ls72vL37s3Kn4871TzKdpGfZlo61e5ruFDCKqVOfjP5pt+WNy4fDn79+XDsAe7Oo6avAv35
 39y5bHdLp1fXyF+qKOcGH9MF62viPsXSs85vcJbSfPmjgyG4/s+0ABtmk9XT80s+SRrPL0wQ
 ULNpnrtUiaU4I9FQi7moOBEAP8WwqwsEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t/xe7pyF9RSDK5cErfYtm43u8Xqu/1s
 FidXP2azaG3/xmSx991sVosLPxqZLPYsmsRksXL1USaLix9bmSz+dt1jsnh6dRZQyS1ti0uP
 V7Bb7Nl7ksXi3pr/rBbt83cxWhya3Mxk0TW7lc3i9p0fzBYnbklbHF/+l83i9485bA5iHptX
 aHlcPlvqsWlVJ5vHpk+T2D12L/jM5LH7ZgObR2/zOzaP9/uusnms33KVxWPz6WqPz5vkPNoP
 dDMF8ETp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXo
 Zcz/doOtYCNzxfprsQ2Mj5i6GDk5JARMJE483sMCYgsJLGWUeLRWCiIuI/Hpykd2CFtY4s+1
 LrYuRi6gmo+MEptubYFytjBKfJz6G6yKRUBVYsPXy0A2BwebgJZEYydYWETAWOLK94UsIPXM
 AqdZJT7PfskIkhAWcJNom7oQrIgX6Iojd5YzQlwxhVFi8msViLigxMmZT8CuYxbQkViw+xMb
 yHxmAWmJ5f84QMKcAokSN/csgHpGSaJh8xkWCLtWovPVabYJjMKzkEyahWTSLIRJCxiZVzGK
 pJYW56bnFhvpFSfmFpfmpesl5+duYgQmkG3Hfm7Zwbjy1Ue9Q4xMHIyHGCU4mJVEeAuNVVOE
 eFMSK6tSi/Lji0pzUosPMZoCQ2Iis5Rocj4wheWVxBuaGZgamphZGphamhkrifN6FnQkCgmk
 J5akZqemFqQWwfQxcXBKNTDFVzyrFHN98C7HflXCTe5DketvM5byVt4rXXFnmnXppfPP/gtl
 BZ5b8vLrudR/D3Iz/Fasl/4UvMc041N88wNOBgf+xBThdu+rZRy24sznqrl8jSra+Ll+/Yzt
 3xBydFb+naTaadW32p4G3VITy/E2PH3Ft25+7jOHcJGd0efa9vScOnT3UZHSofkuTbK2e6aF
 OpbGm31dtmbVN/uOqc+ubDQIvfkv/5/Jt4LA442q4pY3XU00w07n5CmwnVj63Te1aaPR/7fN
 6xx/JofOXyfrWGzyV7Sgq/yyyfkbxVGrbKvEPRfzpB0tL9sqLRthkNB5f0FPx8pVbt/eSXo8
 /JRkIvyyfrYM914byRPTBJRYijMSDbWYi4oTAXZ/WI2pAwAA
X-CMS-MailID: 20230331122046eucas1p247e0cd2d06229a6b7cae9cb26ea43d5b
X-Msg-Generator: CA
X-RootMTR: 20230331122046eucas1p247e0cd2d06229a6b7cae9cb26ea43d5b
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230331122046eucas1p247e0cd2d06229a6b7cae9cb26ea43d5b
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <7849b142e073b20f033e5124a39080f59e5f19d2.1680108414.git.johannes.thumshirn@wdc.com>
 <CGME20230331122046eucas1p247e0cd2d06229a6b7cae9cb26ea43d5b@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 01/19] swap: use __bio_add_page to add page
 to bio
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
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
 Damien Le Moal <damien.lemoal@wdc.com>, cluster-devel@redhat.com,
 Chaitanya Kulkarni <kch@nvidia.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Song Liu <song@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
 Mike Snitzer <snitzer@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Matthew Wilcox <willy@infradead.org>, Ming Lei <ming.lei@redhat.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com,
 David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org, Bob
 Peterson <rpeterso@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 29, 2023 at 10:05:47AM -0700, Johannes Thumshirn wrote:
> The swap code only adds a single page to a newly created bio. So use
> __bio_add_page() to add the page which is guaranteed to succeed in this
> case.
> 
> This brings us closer to marking bio_add_page() as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Looks good,
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

