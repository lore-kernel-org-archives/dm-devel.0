Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85CDFC76196
	for <dm-devel@archiver.kernel.org>; Fri, 31 Mar 2023 12:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680265373;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Do8qhVTSstB2P/fZ2DZaR1d7eqpDEnisLz1zaBADJVw=;
	b=WfMvqbof1/ZVQEkGYOxIKCFQz1z4Ns4pAETcP2CzZ0hb9jLAxambIsBbwt600zynZxqV6b
	kGTeHMsXwMyc+EDk/f95hklW+slzuOh4owr6F1UuvqOGt6bfrW9VuFTj5BnnJ576FEX425
	uooN7iWiNZPou1H5Snez3KIwbAa8x/g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-E8Pfw0fcPoGRKqkxKbIjlg-1; Fri, 31 Mar 2023 08:22:50 -0400
X-MC-Unique: E8Pfw0fcPoGRKqkxKbIjlg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78DE7185A78F;
	Fri, 31 Mar 2023 12:22:48 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4922C492C3E;
	Fri, 31 Mar 2023 12:22:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CEF9419465BD;
	Fri, 31 Mar 2023 12:22:43 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 0198719465BD
 for <dm-devel@listman.corp.redhat.com>; Fri, 31 Mar 2023 12:22:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D6862492B00; Fri, 31 Mar 2023 12:22:41 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id CF4B4492C3E
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 12:22:41 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B3BDE858F0E
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 12:22:41 +0000 (UTC)
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com
 [210.118.77.12]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-393-dX9_Cj_hNXqWfmv6o3rBUQ-1; Fri, 31 Mar 2023 08:22:37 -0400
X-MC-Unique: dX9_Cj_hNXqWfmv6o3rBUQ-1
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id
 20230331122236euoutp02f88842cd3d68be646c5819647d9a2b07~RgHBuxuIw3035630356euoutp02V
 for <dm-devel@redhat.com>; Fri, 31 Mar 2023 12:22:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com
 20230331122236euoutp02f88842cd3d68be646c5819647d9a2b07~RgHBuxuIw3035630356euoutp02V
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
 eucas1p1.samsung.com (KnoxPortal) with ESMTP id
 20230331122235eucas1p1a9a510d4bc8face99a131261e67a3fe5~RgHBKw3Qm1948519485eucas1p10;
 Fri, 31 Mar 2023 12:22:35 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
 eusmges2new.samsung.com (EUCPMTA) with SMTP id CD.09.09966.B80D6246; Fri, 31
 Mar 2023 13:22:35 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
 eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
 20230331122235eucas1p2208286ce210d9b01ea36a26bd3897b72~RgHAr05g82770927709eucas1p2v;
 Fri, 31 Mar 2023 12:22:35 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
 eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230331122235eusmtrp26c22aae866cd012f4e7e50feaedb612a~RgHAqvH4p2795527955eusmtrp2U;
 Fri, 31 Mar 2023 12:22:35 +0000 (GMT)
X-AuditID: cbfec7f4-d39ff700000026ee-cd-6426d08b6c09
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
 eusmgms1.samsung.com (EUCPMTA) with SMTP id 82.16.08862.B80D6246; Fri, 31
 Mar 2023 13:22:35 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
 eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
 20230331122235eusmtip2507df0accd5c684b8609aeab0cf06795~RgHAeTKQh2975929759eusmtip2b;
 Fri, 31 Mar 2023 12:22:35 +0000 (GMT)
Received: from localhost (106.110.32.140) by CAMSVWEXC02.scsc.local
 (2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id 15.0.1497.2;
 Fri, 31 Mar 2023 13:22:34 +0100
Date: Fri, 31 Mar 2023 14:14:18 +0200
From: Pankaj Raghav <p.raghav@samsung.com>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Message-ID: <20230331121418.mch3y43pbt3pahc5@blixen>
MIME-Version: 1.0
In-Reply-To: <56321f8ef1e70e9e541074593575b74d3e25ade2.1680108414.git.johannes.thumshirn@wdc.com>
X-Originating-IP: [106.110.32.140]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
 CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOKsWRmVeSWpSXmKPExsWy7djPc7rdF9RSDI4907LYtm43u8Xqu/1s
 FidXP2azaG3/xmSx991sVosLPxqZLPYsmsRksXL1USaLix9bmSz+dt1jsnh6dRZQyS1ti0uP
 V7Bb7Nl7ksXi3pr/rBbt83cxWhya3Mxk0TW7lc3i9p0fzBYnbklbHF/+l83i9485bA5iHptX
 aHlcPlvqsWlVJ5vHpk+T2D12L/jM5LH7ZgObR2/zOzaP9/uusnms33KVxWPz6WqPz5vkPNoP
 dDMF8ERx2aSk5mSWpRbp2yVwZUy/dYa5YB1Lxd2pN9gaGI8xdzFycEgImEgs2u3RxcjFISSw
 glFiwcm5rBDOF0aJ843X2SCcz4wSUx8sZIHpeHbdEiK+nFFi66Q9LHBF2680MkI4WxglHm9Y
 wgjSwSKgKtF92QrEZBPQkmjsZO9i5OQQETCWuPJ9IVgvs8B9VolLR6aBlQsLhEqsWh8EUsML
 tKtzzltWCFtQ4uTMJywgNrOAjsSC3Z/YQMqZBaQllv/jAAlzCiRKnLkwC6xEQkBJomHzGSi7
 VuLUlltMIKskBP5xSkzZ844VIuEi0Ta/hRHCFpZ4dXwLO4QtI/F/53wmCLta4umN38wQzS2M
 Ev0717NBAsJaou9MDkSNo8T2xbcZIcJ8EjfeCkKcyScxadt0aEDzSnS0CUFUq0nsaNrKOIFR
 eRaSx2YheWwWwmMLGJlXMYqnlhbnpqcWG+WllusVJ+YWl+al6yXn525iBKbN0/+Of9nBuPzV
 R71DjEwcjIcYJTiYlUR4C41VU4R4UxIrq1KL8uOLSnNSiw8xSnOwKInzatueTBYSSE8sSc1O
 TS1ILYLJMnFwSjUwbZLscdAMvKSRfNrp6aT6Q89z9M4xi2vcLU7+sphJ/WPwP76uDyx6HgG5
 ey0CZn4TvMynYbrPwPjR7jCds86TVmoJeC6d28Po5rf55fYnyjwnL75Jux12NXhRju7rqLJt
 JmkJlhv9ti1i/Tr7VNvCGQcvTT4ufMA5QPFMUnCr4/1fsgcuFXF/U1TVFGfalcr9N2NxT6LO
 a//lp1iZ9j7y/fbCm2X/e62DgidFv05ZrjI1RLLpRZFpT84RRtup/LaVFhequqL3r2n2e3h0
 koTKj6zAFd+vtZnvPpD104HPlOtago60hUH1xqjPYbEaUryLerzl1ecr/Z5ledNt6+QJx6ra
 vcWv+XN86lIvYzVSYinOSDTUYi4qTgQA/sdKXgoEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t/xe7rdF9RSDHbc5bDYtm43u8Xqu/1s
 FidXP2azaG3/xmSx991sVosLPxqZLPYsmsRksXL1USaLix9bmSz+dt1jsnh6dRZQyS1ti0uP
 V7Bb7Nl7ksXi3pr/rBbt83cxWhya3Mxk0TW7lc3i9p0fzBYnbklbHF/+l83i9485bA5iHptX
 aHlcPlvqsWlVJ5vHpk+T2D12L/jM5LH7ZgObR2/zOzaP9/uusnms33KVxWPz6WqPz5vkPNoP
 dDMF8ETp2RTll5akKmTkF5fYKkUbWhjpGVpa6BmZWOoZGpvHWhmZKunb2aSk5mSWpRbp2yXo
 ZUy/dYa5YB1Lxd2pN9gaGI8xdzFycEgImEg8u27ZxcjFISSwlFFi8uoV7F2MnEBxGYlPVz5C
 2cISf651sUEUfWSUuHjmGhOEs4VR4uCEJnaQSSwCqhLdl61ATDYBLYnGTrBeEQFjiSvfF7KA
 lDML3GeVWPVlDhNIjbBAqMSq9UEgNbxAN3TOecsKMXIKo0RL9ycmiISgxMmZT1hAbGYBHYkF
 uz+xgfQyC0hLLP/HARLmFEiUOHNhFgvEnUoSDZvPQNm1Ep//PmOcwCg8C8mkWUgmzUKYtICR
 eRWjSGppcW56brGhXnFibnFpXrpecn7uJkZgAtl27OfmHYzzXn3UO8TIxMF4iFGCg1lJhLfQ
 WDVFiDclsbIqtSg/vqg0J7X4EKMpMCAmMkuJJucDU1heSbyhmYGpoYmZpYGppZmxkjivZ0FH
 opBAemJJanZqakFqEUwfEwenVAPThPJ5nAGnFlnq/50p4F7+Pvm5oDzze7HQLufooAPH5YSu
 TNeOdTHPOjFt23a33qaZjzJm/1b75Ts/djdHyp89mxfafj105NXLezzVYhvmd3QbHZ6ouv2u
 yR63AjsrjoetMzlndmxd8ztcu7bB9s66aVwS4Yl9Z4tmssSGbJP7tjH41/SZt1aInVJv/dY/
 /ZlF5YYZMzZsk3R0dT8jbiytWKvSKhswbeNkHf/CTeaeB0Wesbo/WpOo3rbOU+RhA0fB64uX
 GGc12J0WClvwjPHutcvygmVR10oeO/atlasK5/G+nF/AIZYx21DOcFLpin6/NpYbyw40n7l4
 T/1HQWbnj8AZwSJujJWNXp9ifK2UWIozEg21mIuKEwEieVEeqQMAAA==
X-CMS-MailID: 20230331122235eucas1p2208286ce210d9b01ea36a26bd3897b72
X-Msg-Generator: CA
X-RootMTR: 20230331122235eucas1p2208286ce210d9b01ea36a26bd3897b72
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20230331122235eucas1p2208286ce210d9b01ea36a26bd3897b72
References: <cover.1680108414.git.johannes.thumshirn@wdc.com>
 <56321f8ef1e70e9e541074593575b74d3e25ade2.1680108414.git.johannes.thumshirn@wdc.com>
 <CGME20230331122235eucas1p2208286ce210d9b01ea36a26bd3897b72@eucas1p2.samsung.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH 04/19] fs: buffer: use __bio_add_page to add
 single page to bio
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
Cc: Dave Kleikamp <shaggy@kernel.org>, jfs-discussion@lists.sourceforge.net,
 Song Liu <song@kernel.org>, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Andreas Gruenbacher <agruenba@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, cluster-devel@redhat.com,
 p.raghav@samsung.com, Chaitanya Kulkarni <kch@nvidia.com>,
 Mike Snitzer <snitzer@kernel.org>, Ming Lei <ming.lei@redhat.com>,
 linux-raid@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>,
 linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 29, 2023 at 10:05:50AM -0700, Johannes Thumshirn wrote:
> The buffer_head submission code uses bio_add_page() to add a page to a
> newly created bio. bio_add_page() can fail, but the return value is never
> checked.
> 
> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
> 
> This brings us a step closer to marking bio_add_page() as __must_check.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> ---

Looks good,
Reviewed-by: Pankaj Raghav <p.raghav@samsung.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

