Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ACA7C43219
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:24:03 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-u05yEcA2P5SKPEor1VuKiw-1; Fri, 29 Apr 2022 04:23:54 -0400
X-MC-Unique: u05yEcA2P5SKPEor1VuKiw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C53D32811785;
	Fri, 29 Apr 2022 08:23:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ADA3B146894A;
	Fri, 29 Apr 2022 08:23:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 81BBA1947050;
	Fri, 29 Apr 2022 08:23:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9C4081947041
 for <dm-devel@listman.corp.redhat.com>; Wed, 27 Apr 2022 14:31:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8E4C3C27E81; Wed, 27 Apr 2022 14:31:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A06CC2811F
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 14:31:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 711AF18A6583
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 14:31:08 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-580-HVc5FG4DMWKwHbc4D206TQ-1; Wed, 27 Apr 2022 10:31:06 -0400
X-MC-Unique: HVc5FG4DMWKwHbc4D206TQ-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20220427143103epoutp047ed5f002221ce11bbe2af5b58da544b8~px0sK49oi1834418344epoutp04a
 for <dm-devel@redhat.com>; Wed, 27 Apr 2022 14:31:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20220427143103epoutp047ed5f002221ce11bbe2af5b58da544b8~px0sK49oi1834418344epoutp04a
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20220427143102epcas5p29b596e5d8e6e014fbed587a068543a20~px0rRj7Yu2595925959epcas5p2B;
 Wed, 27 Apr 2022 14:31:02 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4KpLlR0WZ2z4x9Pp; Wed, 27 Apr
 2022 14:30:59 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 46.88.09762.2A359626; Wed, 27 Apr 2022 23:30:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20220427125500epcas5p189ef3a038115f13840f8992a79fb2e3d~pwg002FDZ1031610316epcas5p1G;
 Wed, 27 Apr 2022 12:55:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220427125500epsmtrp18381e20d6e38ffd4eb28b8ea3234fa63~pwg0y5X4H2300323003epsmtrp1O;
 Wed, 27 Apr 2022 12:55:00 +0000 (GMT)
X-AuditID: b6c32a4b-1fdff70000002622-70-626953a2579d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 0D.34.08853.42D39626; Wed, 27 Apr 2022 21:55:00 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220427125459epsmtip19208f23035104a9c8446a86c8c32dcd3~pwgzmZAtj1493614936epsmtip1J;
 Wed, 27 Apr 2022 12:54:58 +0000 (GMT)
Date: Wed, 27 Apr 2022 18:19:51 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20220427124951.GA9558@test-zns>
MIME-Version: 1.0
In-Reply-To: <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDJsWRmVeSWpSXmKPExsWy7bCmpu6i4Mwkg3fbLS1+nz3PbLH33WxW
 i723tC327D3JYnF51xw2i/nLnrJbdF/fwWax40kjowOHx85Zd9k9Ni+p99jZep/V4/2+q2we
 nzfJBbBGZdtkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
 AF2ipFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwKdArTswtLs1L18tLLbEyNDAw
 MgUqTMjOmPj9CnPBOY6Knz1vGBsY+9i7GDk5JARMJF7e7WXsYuTiEBLYzSgxce1zVgjnE6PE
 8nX72SCcb4wSjZeuscK0tGw9B1W1l1Fi26zjUP3PGCWWte5nBKliEVCVWLRuPlMXIwcHm4C2
 xOn/HCBhEQFTibc9rSwg9cwCZxgl2t/vAjtEWMBMYnVnKxuIzSugI3Hzy19WCFtQ4uTMJywg
 NqeAm0THgUnMILaogLLEgW3HmUAGSQhM5ZA4sWsFC8R5LhIf7s1hhrCFJV4d3wL1qZTEy/42
 KLtcYnvbAqjmFkaJrlOnoJrtJS7u+csEYjMLZEj8fzkV6mdZiamn1kHF+SR6fz9hgojzSuyY
 B2MrS6xZv4ANwpaUuPa9Ecr2kNj5cSU0vE4Bg3jlHMYJjPKzkHw3C8m+WcAQYxbQlFi/Sx8i
 LC/RvHU2M0RYWmL5Pw4kFQsY2VYxSqYWFOempxabFhjnpZbDoz85P3cTIzjZannvYHz04IPe
 IUYmDsZDjBIczEoivF92ZyQJ8aYkVlalFuXHF5XmpBYfYjQFRtxEZinR5Hxgus8riTc0sTQw
 MTMzM7E0NjNUEuc9lb4hUUggPbEkNTs1tSC1CKaPiYNTqoFJ/sXyv8flM4vyjuwxY1rg5f7V
 /9PC2qtRz00K7tQGHgyfd79y+q5Vt3ZZqa4/z7Qjwv34g2nb7mf/KvrDs2J35YPFBls+phh5
 Kj4wmWk8c92//z4WkbdfvuB8+tAlU3BHDpfP2+OPuVJ+P9tsYnzRb3PUYo8jWy8zXz5fe2Ti
 FtsGP7Wgfr0snydfjEP/vps92+n9qjUCjnP89QRXz98z2dewxrpyqfUSO++Pcx7VzXEJsLQT
 +vRNM9tSM+ax6YE9b6eZRam4a00uF7nkk7i7eW765hPLglMWajFIRC/cp11Wuslml6sQX+xN
 qV/2CcdjHh0S1RCKq1l3x91Wdr3cJfbdPFuPX1bvWu5gOXtRmRJLcUaioRZzUXEiAJsamEE/
 BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWy7bCSnK6KbWaSwZMuIYvfZ88zW+x9N5vV
 Yu8tbYs9e0+yWFzeNYfNYv6yp+wW3dd3sFnseNLI6MDhsXPWXXaPzUvqPXa23mf1eL/vKpvH
 501yAaxRXDYpqTmZZalF+nYJXBnv1l9kLPjAWrGkYRZTA+MZli5GTg4JAROJlq3nWEFsIYHd
 jBJXf/pBxCUllv09wgxhC0us/PecvYuRC6jmCaNEx5HH7CAJFgFViUXr5jN1MXJwsAloS5z+
 zwESFhEwlXjb08oCUs8scIZRov39LrB6YQEzidWdrWwgNq+AjsTNL39ZIYaeYpTofHqRFSIh
 KHFy5hOw65gF1CX+zLvEDLKAWUBaYvk/DoiwvETz1tlgx3EKuEl0HJgEZosKKEsc2HacaQKj
 0Cwkk2YhmTQLYdIsJJMWMLKsYpRMLSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjhwtzR2M
 21d90DvEyMTBeIhRgoNZSYT3y+6MJCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeW
 pGanphakFsFkmTg4pRqY3E4HJove7NU0V7A9sZ11R157x+KgZU7PWx9lvNdqnSV0Katz3/bd
 qxRYBTvLRENTZxnWXox4ta7whvj/268VGQ23TZG9+Ovy0izWsn8LH2hrJ208VLHiIMukjZdf
 9Au12G5aLub9wmBp/ox8xxkX9JROneMWa826cC7U7v2Rf29EjD/Mjf7q8u7e9ZR4hXPJStwa
 bdcXLfU8YqS+VM9WKSJ8ncP5U5znSri7t5ntLJk/WXVnqaa52nEvD6+zhitE5z9oDbMJk9j+
 /KKyG4/iPNGIIp2zMpulRDnvb6lUS5Xjjt681vBMiceTFU7rvM5v+zVdvozz4vuXNw+q7fp2
 VODNqvlHDuVrcp976l+rqcRSnJFoqMVcVJwIAPtAlfYLAwAA
X-CMS-MailID: 20220427125500epcas5p189ef3a038115f13840f8992a79fb2e3d
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:40 +0000
Subject: Re: [dm-devel] [PATCH v4 00/10] Add Copy offload support
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
Cc: linux-scsi@vger.kernel.org, nitheshshetty@gmail.com,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, dm-devel@redhat.com,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_1770c_"

------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_1770c_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

O Wed, Apr 27, 2022 at 11:19:48AM +0900, Damien Le Moal wrote:
> On 4/26/22 19:12, Nitesh Shetty wrote:
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
> >     block and file backend)
>=20
> It would also be nice to have copy offload emulation in null_blk for test=
ing.
>

We can plan this in next phase of copy support, once this series settles do=
wn.

--
Nitesh Shetty

------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_1770c_
Content-Type: text/plain; charset="utf-8"


------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_1770c_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------SFNbypxiwiYv2mFj5qNI3mkL0EyMW--LFKYa8svGKq9OOQ6W=_1770c_--

