Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB4FCC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 29 Apr 2022 08:24:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-fF8zHUClO5WhKnL1rwi55A-1; Fri, 29 Apr 2022 04:23:54 -0400
X-MC-Unique: fF8zHUClO5WhKnL1rwi55A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E8421881438;
	Fri, 29 Apr 2022 08:23:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6AC93463E09;
	Fri, 29 Apr 2022 08:23:50 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3F9F4194707A;
	Fri, 29 Apr 2022 08:23:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 45B561947046
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Apr 2022 08:19:17 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 12DDA2166B1A; Thu, 28 Apr 2022 08:19:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0D27B2166B4D
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 08:19:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1CE9E833976
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 08:19:06 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-330-QD4Nwp7oPfyQkKxK3AsEhQ-1; Thu, 28 Apr 2022 04:19:03 -0400
X-MC-Unique: QD4Nwp7oPfyQkKxK3AsEhQ-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20220428081900epoutp04dcba2c4fcb3c0194b26511fc0d4d14f9~qAZI8iR6o2900829008epoutp04M
 for <dm-devel@redhat.com>; Thu, 28 Apr 2022 08:19:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20220428081900epoutp04dcba2c4fcb3c0194b26511fc0d4d14f9~qAZI8iR6o2900829008epoutp04M
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20220428081859epcas5p19880ba6dfa6389f18098ac62ca74e360~qAZIA-u-l0467704677epcas5p1x;
 Thu, 28 Apr 2022 08:18:59 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4KppRg2W7Dz4x9QB; Thu, 28 Apr
 2022 08:18:55 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 E2.07.09827.EED4A626; Thu, 28 Apr 2022 17:18:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20220428075435epcas5p285a70634102f71440a283361657f4d9b~qAD0bnrr92164321643epcas5p2Q;
 Thu, 28 Apr 2022 07:54:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20220428075435epsmtrp1a9ee8d4d92953b0ff2d7f9b7559998a2~qAD0asRh-1575615756epsmtrp1S;
 Thu, 28 Apr 2022 07:54:35 +0000 (GMT)
X-AuditID: b6c32a4a-b3bff70000002663-dd-626a4deee6d4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 A6.BF.08924.B384A626; Thu, 28 Apr 2022 16:54:35 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20220428075434epsmtip13f509946fb1170bf6e1ff8e4df1f4948~qADzDll5X1873018730epsmtip1z;
 Thu, 28 Apr 2022 07:54:34 +0000 (GMT)
Date: Thu, 28 Apr 2022 13:19:26 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20220428074926.GG9558@test-zns>
MIME-Version: 1.0
In-Reply-To: <c285f0da-ab1d-2b24-e5a4-21193ef93155@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBJsWRmVeSWpSXmKPExsWy7bCmpu5736wkgz+5Fr/Pnme22PtuNqvF
 3lvaFnv2nmSxuLxrDpvF/GVP2S26r+9gs9jxpJHRgcNj56y77B6bl9R77Gy9z+rxft9VNo/P
 m+QCWKOybTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
 DlFSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZ
 AhUmZGfcv7eFtaCfu+Lm7busDYztnF2MnBwSAiYSXe+2sYLYQgK7GSXmLI3uYuQCsj8xSsx/
 8IIVwvnMKHF8/Uk2mI75d6ayQyR2MUqcOz0XquoZo0TT/HnsIFUsAqoSD6Z2MXYxcnCwCWhL
 nP7PARIWETCVeNvTygJSzyxwhlGi/f0usHphATOJ1Z2tYBt4BXQkFs/fzQ5hC0qcnPmEBcTm
 FHCTmL3xG5gtKqAscWDbcSaIiyZySMyYmwqyS0LARaL5dTREWFji1fEt7BC2lMTL/jYou1xi
 e9sCJpAbJARaGCW6Tp1igUjYS1zc8xdsJrNAhsTsb2uhPpaVmHpqHVScT6L39xOovbwSO+bB
 2MoSa9YvgKqXlLj2vRHK9pDY+XElNIBWMkm8PH2IfQKj/Cwkv81Csm8W0A/MApoS63fpQ4Tl
 JZq3zmaGCEtLLP/HgaRiASPbKkbJ1ILi3PTUYtMCo7zUcnjcJ+fnbmIEJ1ktrx2MDx980DvE
 yMTBeIhRgoNZSYT3y+6MJCHelMTKqtSi/Pii0pzU4kOMpsBom8gsJZqcD0zzeSXxhiaWBiZm
 ZmYmlsZmhkrivKfTNyQKCaQnlqRmp6YWpBbB9DFxcEo1MHmYxBi3KS/r+5xXoHh/5e5/mpOK
 OLaz1QUJJm5LlWV+dGCy2qfIDR1bPTv4Cv8o7cuz5K+7k+o17+LTf7WP9Hb0x/PP1u849K1e
 9ECS25U/X77MfXHhdDCf6CKtxUE1cj17vjAr/U6ZkKPatTBKKu23yc1t05J0TR/EblD+sWFx
 0DPf6Q7i++QYDghltRZyCmdZbpQ0mbLf//CW7BVyO3Mj78a3hghMUJNqNAp1337257kTdWFK
 F5WF48I+LnzLVaHz1Wvq/N+HWwX5lVy6/OQDdXwTmyQOHOF9+P5ORO+1sxMfmJVUr1snvTy8
 Kfb+1bVvxTqdU/dcnR/13vrQ+u4M04X3O3s98v0vTXLvVmIpzkg01GIuKk4EAG3bN+s7BAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWy7bCSnK61R1aSQcdnPYvfZ88zW+x9N5vV
 Yu8tbYs9e0+yWFzeNYfNYv6yp+wW3dd3sFnseNLI6MDhsXPWXXaPzUvqPXa23mf1eL/vKpvH
 501yAaxRXDYpqTmZZalF+nYJXBkrtjkWbOSo2PbVroHxKFsXIyeHhICJxPw7U9m7GLk4hAR2
 MEp8aTrHApGQlFj29wgzhC0ssfLfc6iiJ4wSs+6vBetmEVCVeDC1i7GLkYODTUBb4vR/DpCw
 iICpxNueVhaQemaBM4wS7e93sYMkhAXMJFZ3toL18groSCyevxtq6Eomiff7V7JDJAQlTs58
 AnYFs4C6xJ95l5hBFjALSEss/8cBEZaXaN46G+w4TgE3idkbv4GViwooSxzYdpxpAqPQLCST
 ZiGZNAth0iwkkxYwsqxilEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAiOGy2tHYx7Vn3Q
 O8TIxMF4iFGCg1lJhPfL7owkId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwXuk7GCwmkJ5akZqem
 FqQWwWSZODilGphmNkSeu+/Zy/AzdJGv3sPXJ3sNLl4t7nK+dN/kX+8ctbV/eb6LrRTa9s+k
 YDWbSN7z4NI5On1n5fnNvWRuVogfPnn2Q/QKI/2ZvLOWpR5raFxyxPrm3G/zt/3jSAwIVNEV
 vlGj9r15qkzKnZTAabfNrOunnG56dvDkm55ZLamR00U/P9HWbLHer/0vbFnmhkXlsVeflx5I
 PvfhVElgVdO7F6tL4/72aE+82pMt+Icv6rLBBfXuw+1eMw7u+cD1b3uQ34IF52+4Sfkp/Ulg
 1VRZN3Ghe9+N0/Z2JkkWB4s/O9acPB8mtemFG6OJ8TmFi3pr5/kn6pxVuj8j33YeF+MJ4zdn
 HZjXyDM/fquzxWWKEktxRqKhFnNRcSIAWXgw9goDAAA=
X-CMS-MailID: 20220428075435epcas5p285a70634102f71440a283361657f4d9b
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
 <20220427124951.GA9558@test-zns>
 <c285f0da-ab1d-2b24-e5a4-21193ef93155@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mailman-Approved-At: Fri, 29 Apr 2022 08:23:41 +0000
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
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----MMcOyA4CJjQRgHhn55zXOrpiM0Dxers-aGNKdRjWa9MqQ0PV=_1cb6b_"

------MMcOyA4CJjQRgHhn55zXOrpiM0Dxers-aGNKdRjWa9MqQ0PV=_1cb6b_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 28, 2022 at 07:05:32AM +0900, Damien Le Moal wrote:
> On 4/27/22 21:49, Nitesh Shetty wrote:
> > O Wed, Apr 27, 2022 at 11:19:48AM +0900, Damien Le Moal wrote:
> >> On 4/26/22 19:12, Nitesh Shetty wrote:
> >>> The patch series covers the points discussed in November 2021 virtual=
 call
> >>> [LSF/MM/BFP TOPIC] Storage: Copy Offload[0].
> >>> We have covered the Initial agreed requirements in this patchset.
> >>> Patchset borrows Mikulas's token based approach for 2 bdev
> >>> implementation.
> >>>
> >>> Overall series supports =E2=80=93
> >>>
> >>> 1. Driver
> >>> - NVMe Copy command (single NS), including support in nvme-target (fo=
r
> >>>     block and file backend)
> >>
> >> It would also be nice to have copy offload emulation in null_blk for t=
esting.
> >>
> >=20
> > We can plan this in next phase of copy support, once this series settle=
s down.
>=20
> So how can people test your series ? Not a lot of drives out there with
> copy support.
>

Yeah not many drives at present, Qemu can be used to test NVMe copy.

--
Nitesh Shetty

------MMcOyA4CJjQRgHhn55zXOrpiM0Dxers-aGNKdRjWa9MqQ0PV=_1cb6b_
Content-Type: text/plain; charset="utf-8"


------MMcOyA4CJjQRgHhn55zXOrpiM0Dxers-aGNKdRjWa9MqQ0PV=_1cb6b_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------MMcOyA4CJjQRgHhn55zXOrpiM0Dxers-aGNKdRjWa9MqQ0PV=_1cb6b_--

