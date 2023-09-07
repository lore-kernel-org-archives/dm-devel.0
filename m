Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C438EE14D4
	for <dm-devel@archiver.kernel.org>; Thu,  7 Sep 2023 08:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1694074187;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=kD7aNxb/vJ+Ee5RmRcjDVknYtGo751Yr4u7dvkPw1xI=;
	b=RInQ49DRq6Uqhog899SL7Zyo3HKea2K5ry5iy6bZphya03zeTJurIDfEQx5Zy+sBEwvxRT
	4pyRjDyTjxZDA/k1EDU6n7dMy7kequ8D86h0WNiQjat9BtDIvoqfLGuz9FsHR1ZsC2KYaw
	kyICOra+5MoqJreoRSgzfikDFJzcEMQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-eVHsokHVNjauILBiuRdifg-1; Thu, 07 Sep 2023 04:09:43 -0400
X-MC-Unique: eVHsokHVNjauILBiuRdifg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 788E8101A529;
	Thu,  7 Sep 2023 08:09:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 679606B5AA;
	Thu,  7 Sep 2023 08:09:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 17847194658F;
	Thu,  7 Sep 2023 08:09:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7F7A194658C
 for <dm-devel@listman.corp.redhat.com>; Thu,  7 Sep 2023 08:09:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C7EC321EE56B; Thu,  7 Sep 2023 08:09:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C083321EE56A
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 08:09:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A3099381495A
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 08:09:39 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-IV8hdnfkNLOhVHzdoU-BoQ-1; Thu, 07 Sep 2023 04:09:36 -0400
X-MC-Unique: IV8hdnfkNLOhVHzdoU-BoQ-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230907080933epoutp04c197e33973c75884da40ff3c3c7cf705~Cj3wgZzc90228002280epoutp046
 for <dm-devel@redhat.com>; Thu,  7 Sep 2023 08:09:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230907080933epoutp04c197e33973c75884da40ff3c3c7cf705~Cj3wgZzc90228002280epoutp046
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20230907080932epcas5p29191997c30b6c069da4ec6098457f9ed~Cj3v7N0E82859528595epcas5p27;
 Thu,  7 Sep 2023 08:09:32 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4RhBjQ5pMQz4x9Q6; Thu,  7 Sep
 2023 08:09:30 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 61.40.09638.A3589F46; Thu,  7 Sep 2023 17:09:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230907071936epcas5p1ae555e75c8ee278f08e4537d0839cc72~CjMJf8lev2653926539epcas5p1y;
 Thu,  7 Sep 2023 07:19:36 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230907071936epsmtrp17265aa18f417f5e035967b86ea7c0b17~CjMJe6os_1235812358epsmtrp1B;
 Thu,  7 Sep 2023 07:19:36 +0000 (GMT)
X-AuditID: b6c32a4a-92df9700000025a6-ff-64f9853a35a9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 D0.0D.18916.88979F46; Thu,  7 Sep 2023 16:19:36 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230907071933epsmtip2c2f2ef6298194cfcf6c7db10e2733a19~CjMGmu15-2489124891epsmtip2B;
 Thu,  7 Sep 2023 07:19:32 +0000 (GMT)
Date: Thu, 7 Sep 2023 12:46:11 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Hannes Reinecke <hare@suse.de>
Message-ID: <20230907071611.rgukw7fory2xh5sy@green245>
MIME-Version: 1.0
In-Reply-To: <b0f3d320-047b-4bd8-a6fc-25b468caf5b3@suse.de>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfVCTdRzA+z3Psxc8V09D7AdU0rC7kAM32uYzYuAp1z2XdQennlndwWKP
 jGNsuz0bYHY1UUC4YIoUMKlAKN6E5SCP9yMMgVHxh4GAQsIxDZD3GyIEtLHh+d/n+/52XzbK
 TWf5sBNUOkqrkil5zF3YrdsBAUGh6c/k/KKcAMJsvYMSaZc3UKJm1MgkZm4vAWKyIxMQbXPX
 GMRwRxNCtF7PQ4iqmi6EyOscBIRtwIQQbSOBRGlGOUa0tvVixN3mYibx4882FlHRvYkQQ5dt
 gKibmceInhFfon+jm3HYi+wfu4mRd//Uk5bqLCZZX/412TJsYJJluVcZZM6FOSa5aBvByPn2
 ASaZ21ANyPq+c+Sy5U3SMjmLRHE+SQxTUDI5pfWjVHFqeYIqXso7djzmaIxIzBcECSTEIZ6f
 SpZESXmRH0YFvZ+gdMzL80uWKfUOVZSMpnkHw8O0ar2O8lOoaZ2UR2nkSo1QE0zLkmi9Kj5Y
 RelCBXx+iMjhGJuoWMtewDRbrNTKrCamATxgZgMPNsSFMGtzGMsGu9hcvAXAjMe/sFzCEoDz
 tR3M54J9ogzZCbHPNCIuQxOABXPDLKeBiz8CsH5ht5MxfD+8uLHlcGKzmXgg7NtiO9V7cB5c
 zOzcroDi6Qy4VrO0ndQTD4cTK5sMJ3NwMZw5X4q6+FXYWzSJOdkDfw8aV8e3+/bCX4eFP9lR
 ZyKIF3jA8sJld3eRsLBpg+FiTzjd3cBysQ+cMma4OQVW5VcyXcEXATTdMwGXIQKmW43blVFc
 AZ9MjWIu/RvwW2sd4tK/DHPWJ93FOLDxhx32hzfMJe6tesPBp+fdTMLJp7XuDS0AaJg9chns
 M70wnOmFci4OhVkLaQyTY3ko7gsrNtkuDIDm5oMlgFENvCkNnRRP0SJNiIpKeX7xOHWSBWz/
 w4EPGsH4w4XgToCwQSeAbJS3hzO3b0XO5chlZ7+gtOoYrV5J0Z1A5DjWFdTHK07teCiVLkYg
 lPCFYrFYKHlXLOC9xplJ/17OxeNlOiqRojSUdicOYXv4GJCKa/nWM/cubJmjuoo2PFdQ6+/B
 x0kpdyTTctJ66I93vO/M7R8fM0R+XDAsT/4r9p/kmOK6hvw6USkbiCZ+WzxWzIe3lKsaq2BN
 n9N+OjmCHp2iLPd9bxR+FVGWUlVVuTeyR3Ip/mZT34DhvwKPElq43nzWOK1t7Xmr2Jb25Du7
 f8RLVv+EL0uiU/8+9XaYRa7g9knW1yOH8kJ7uNgle605rpKCD6dbVsnBX7m+it2nsgIrTCfO
 zfZa64zBA4+vPLDY+s+kfrRy+v7ecE7XSqv5aOx63pD18HUzEv5o6pV/2zLJT9ujk77xlEQf
 ORlSNPbs6mcnYtOW2+yoVPN5wqI0l4fRCpngAKqlZf8D0vdD9ZgEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsWy7bCSvG5H5c8Ug52beS3WnzrGbNE04S+z
 xeq7/WwWrw9/YrR4cqCd0WLvu9msFjcP7GSy2LNoEpPFytVHmSwmHbrGaPH06iwmi723tC0W
 ti1hsdiz9ySLxeVdc9gs5i97ym6x/Pg/JosbE54yWqx7/Z7F4sQtaYvzf4+zOoh6nL+3kcXj
 8tlSj02rOtk8Ni+p99h9s4HNY3HfZFaP3uZ3bB4fn95i8Xi/7yqbR9+WVYwem09Xe3zeJOex
 6clbpgDeKC6blNSczLLUIn27BK6M8613WAs2slYc3dnE1sC4gqWLkZNDQsBE4uvrHUxdjFwc
 QgLbGSWezX3KDJGQlFj29wiULSyx8t9zdhBbSOAJo8TyPVEgNouAikTL3/9AzRwcbALaEqf/
 c4CERQSUJD62H2IHmcks0M4q0b/gFSNIQljATuLRt3+sIDavgJnE68aFzBCLPzBKXNp+kxki
 IShxcuYTsOuYgYrmbX7IDLKAWUBaYvk/sAWcAtYS/T8esoHYogIyEjOWfmWewCg4C0n3LCTd
 sxC6FzAyr2IUTS0ozk3PTS4w1CtOzC0uzUvXS87P3cQIjmatoB2My9b/1TvEyMTBeIhRgoNZ
 SYT3nfy3FCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8yjmdKUIC6YklqdmpqQWpRTBZJg5OqQYm
 psVGUjocv0PKF1veYZ6r5CabX2m7J+v1ubSIoFPLQiZPSBackunI5m6f/aTmt5Csv8qiRuby
 fYdsMlgPZThaXf/x13umoG4Qw4d/i/+GRTnsZJJL6LmXxsCXyHo9dVXFIc2+2MaQsLOK2TJu
 PpdSXB5kHMvvPzlvW2GI8sPbpqpJX97oRK1JeV1W0H6U+bHzwvnch6cp5Vrcj/kRnBH4+O67
 NYI1D7eLP/68patKUlN/xY9p7d7HjtawHlBOenbhwTaeN+yZ91M29xubxqS6MoYobvfu3s0V
 zyAaJmBn9jk+MuJ4e8GM/+ZS3g8M1hmeuvL5/auvU9Yd5JrsviNBdkb5+4Rjfw7d4mRqalRi
 Kc5INNRiLipOBABGGkG3VQMAAA==
X-CMS-MailID: 20230907071936epcas5p1ae555e75c8ee278f08e4537d0839cc72
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230906164312epcas5p397662c68dde1dbc4dc14c3e80ca260b3
References: <20230906163844.18754-1-nj.shetty@samsung.com>
 <CGME20230906164312epcas5p397662c68dde1dbc4dc14c3e80ca260b3@epcas5p3.samsung.com>
 <20230906163844.18754-4-nj.shetty@samsung.com>
 <b0f3d320-047b-4bd8-a6fc-25b468caf5b3@suse.de>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH v15 03/12] block: add copy offload support
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
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 Chaitanya Kulkarni <kch@nvidia.com>, Sagi Grimberg <sagi@grimberg.me>,
 martin.petersen@oracle.com, Jonathan Corbet <corbet@lwn.net>,
 gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
 linux-doc@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 mcgrof@kernel.org, linux-nvme@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----1B4_PwnuBgjs5al8.ARo7bB9J1Y4sbiuOmsCUR3u7pWcBekA=_3ae06_"

------1B4_PwnuBgjs5al8.ARo7bB9J1Y4sbiuOmsCUR3u7pWcBekA=_3ae06_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 07/09/23 07:49AM, Hannes Reinecke wrote:
>On 9/6/23 18:38, Nitesh Shetty wrote:
>
>Hmm. That looks a bit odd. Why do you have to use wait_for_completion?

wait_for_completion is waiting for all the copy IOs to complete,
when caller does not pass endio handler.
Copy IO submissions are still async, as in previous revisions.

>Can't you submit the 'src' bio, and then submit the 'dst' bio from the 
>endio handler of the 'src' bio?
We can't do this with the current bio merging approach.
'src' bio waits for the 'dst' bio to arrive in request layer.
Note that both bio's should be present in request reaching the driver,
to form the copy-cmd.

Thank You,
Nitesh Shetty

------1B4_PwnuBgjs5al8.ARo7bB9J1Y4sbiuOmsCUR3u7pWcBekA=_3ae06_
Content-Type: text/plain; charset="utf-8"


------1B4_PwnuBgjs5al8.ARo7bB9J1Y4sbiuOmsCUR3u7pWcBekA=_3ae06_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------1B4_PwnuBgjs5al8.ARo7bB9J1Y4sbiuOmsCUR3u7pWcBekA=_3ae06_--

