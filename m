Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D595EB64DA
	for <dm-devel@archiver.kernel.org>; Fri, 30 Jun 2023 12:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688127158;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=VsK5ak5omLdl8j09E/xG85g0OCNxdcHC5WO63AxZQrc=;
	b=VA0bzF9a80jjQSIksmFxjjfVQXfYQuiz56Qo0QGuecoeyNgNXp0X55dXDDa1Q560CiFH//
	9PJbH/EhutaO9Rix4KfzKagEKrnab9spB2Nl+kSCH3X1fkDoNrihhyXXBopKQKZ2+yxPeJ
	gtem93UBUUif+1TldFgN+xW5RY/TJrE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-pkk9zhQjON6-wpbNnBunfQ-1; Fri, 30 Jun 2023 08:12:36 -0400
X-MC-Unique: pkk9zhQjON6-wpbNnBunfQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 421B9185A7A5;
	Fri, 30 Jun 2023 12:12:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BD5A240C2063;
	Fri, 30 Jun 2023 12:12:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8560C19465B3;
	Fri, 30 Jun 2023 12:12:29 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 560351946595
 for <dm-devel@listman.corp.redhat.com>; Fri, 30 Jun 2023 12:02:49 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 34F72C09A07; Fri, 30 Jun 2023 12:02:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2D759C00049
 for <dm-devel@redhat.com>; Fri, 30 Jun 2023 12:02:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0F955104458B
 for <dm-devel@redhat.com>; Fri, 30 Jun 2023 12:02:49 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-339-aKdP6D9zNf-FwMY8inbhVw-1; Fri, 30 Jun 2023 08:02:44 -0400
X-MC-Unique: aKdP6D9zNf-FwMY8inbhVw-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230630120241epoutp030fcb241a93b4867a7751f466088a8710~tbin09FO-1701617016epoutp030
 for <dm-devel@redhat.com>; Fri, 30 Jun 2023 12:02:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230630120241epoutp030fcb241a93b4867a7751f466088a8710~tbin09FO-1701617016epoutp030
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230630120240epcas5p3d08ca980d5065aa551daa2fd10006566~tbim_nHMD0126501265epcas5p3B;
 Fri, 30 Jun 2023 12:02:40 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.181]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4Qsv8H1L2xz4x9Pt; Fri, 30 Jun
 2023 12:02:39 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 4F.E6.06099.F54CE946; Fri, 30 Jun 2023 21:02:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230630112545epcas5p1746ef2fc966c04b3a8163e0dff21fb4b~tbCXgpz0S0278302783epcas5p18;
 Fri, 30 Jun 2023 11:25:45 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230630112545epsmtrp100ac18072070bde82f83c688a8d35218~tbCXeO08n3247532475epsmtrp1R;
 Fri, 30 Jun 2023 11:25:45 +0000 (GMT)
X-AuditID: b6c32a4b-cafff700000017d3-cb-649ec45f75e7
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 01.DC.34491.9BBBE946; Fri, 30 Jun 2023 20:25:45 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230630112540epsmtip25264414e861bfa35bbcaec8407f2f7ff~tbCTNRWsE1020410204epsmtip2Y;
 Fri, 30 Jun 2023 11:25:40 +0000 (GMT)
Date: Fri, 30 Jun 2023 16:52:27 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Ming Lei <ming.lei@redhat.com>
Message-ID: <20230630112227.6ctls2vt4cy7vbxo@green245>
MIME-Version: 1.0
In-Reply-To: <ZJ1B1k0KifZrGRIp@ovpn-8-26.pek2.redhat.com>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02TbUxTZxTHee69vS3EumuR+PCikOKyAQGpQPdAYAo6d5fuAwl+GQnild5R
 BNqmLbJhIqDAFAaoDDIrVFQcbwoIbOF1smIFMYwZBgisDLWgkw0QAnbjZWspLH77nZf/eZ5z
 Tg4PFzRxXXgJcg2rkjNJQtKB+KHby8s39r5O6n+nioPq+x7g6OzFNRzVGgtJNNO9AFDJ/N84
 MnV9BdCgaTuavHcAdc5e5aDRrlYMddy4jKHqWgOGLuuHAZoa0mKoc8wHXc+pIFBH50MCDbaV
 kujad1NclDfSQqLKnnUM6YvOYajFlAlQ3cwcgXrHXNHzvPMADaz1cNCKuZQ86EYP/iqhW7VG
 Lj0wcZegm6q86cH+FLqx5gJJN1Wk0+2jGSR9s6CIQ+efmyXp11NjBD334xBJFzTXALrp0Wl6
 sXEP3Wj6C4ukohNDZSwjZVUerDxOIU2Qx4cJJVGxh2KDxP4iX1Ew+kDoIWeS2TDh4U8jfY8k
 JFmmI/Q4xSSlWFyRjFot3PdhqEqRomE9ZAq1JkzIKqVJykCln5pJVqfI4/3krCZE5O+/P8iS
 eDxRtpRXzlW2v/NF5YtpbgaY3pYL7HmQCoTmxwOcXODAE1DtAPYuPN40FgBcLMzg2oxlAK/U
 FHC2JOONGYQt0AngvZf6jYCAmgbQ3MO3MkG9CyuHG7BcwOORlA989C/P6t5JCaHRWLtRFKca
 SGhu1QFrwJEKgf0tTzeYT4mh4Y6JtPEO+PCKibCyPRUMl1oLNnKcKDf47a0l3FoIUhP2cNE4
 RNp+dxhWzHUDGzvCVz3NXBu7wD8KczY5FVZ/U0XaxFkAake0m4IDMLuvELcyTslgaVfOZtHd
 sLivDrP5t8P8FRNm8/Nhi26LPeHt+vLNfGc4/CaTtHYPKRr+PHjINq1ZAMuyzOAicNe+1Zz2
 redsHAIvzJ/laC1ynHKFles8G3rB+rZ95YBTA5xZpTo5nlUHKQPkbOr/G49TJDeCjevxlrSA
 Z5PzfnqA8YAeQB4u3Mkf//OqVMCXMl+msSpFrColiVXrQZBlWZdwF6c4heX85JpYUWCwf6BY
 LA4MDhCLhLv4M9llUgEVz2jYRJZVsqotHcazd8nANA4nRj0V2n9eP2HuS4fpQ8y17OcnigPS
 QrcB2ctaQ0Xd57WrU8fOdBuIVrl+Ojy8Yeyzto71sdB6CbM3Ji0r3e6ozAeMjTwZdwrnJEDt
 s5xbxE9NveHQdfrosEi3WMyPaCgZmpw9VimOOZ3/0asju93PVHut+N3NNK7Z0+k6Ea7LFGZH
 /fbidqFZEfsLmHVE73F6eKsRhvdvzpRN1msT4DixMEDWudn9nvwxJ0CSejI6Ke+kU9GNXMpw
 3TPMrrtr//n2Zuc9gqf9S4IYgelg+C6qaHnCveT74xE7HpDmiYBTfsuhzXtDRJ9wJZdWdctz
 jYOi6PT5KMPMG8HXzgNCQi1jRN64Ss38B0n6FerGBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7bCSvO7O3fNSDC7d4bBYf+oYs0XThL/M
 Fqvv9rNZvD78idFi2oefzBZPDrQzWlx+wmfxYL+9xd53s1ktbh7YyWSxZ9EkJouVq48yWUw6
 dI3R4unVWUwWe29pWyxsW8JisWfvSRaLy7vmsFnMX/aU3aL7+g42i+XH/zFZHJrczGSx40kj
 o8W61+9ZLE7ckrZ43N3BaHH+73FWi98/5rA5yHhcvuLtsXPWXXaP8/c2snhsXqHlcflsqcem
 VZ1sHpuX1HvsvtnA5rG4bzKrR2/zOzaPj09vsXi833eVzaNvyypGj82nqz0+b5Lz2PTkLVOA
 QBSXTUpqTmZZapG+XQJXxvr+e2wFb3kqZu16ztrAuImri5GTQ0LAROL2pgaWLkYuDiGB3YwS
 Ddu+skEkJCWW/T3CDGELS6z895wdougJo0THuTlgRSwCqhLLr21g6mLk4GAT0JY4/Z8DJCwi
 oCRx9+5qsHpmgU1sEn/PvWQESQgLWEmc3fEQzOYVMJM4uvYJG8TQd4wSVy41MEEkBCVOznzC
 AmIzAxXN2/yQGWQBs4C0xPJ/YAs4BSwlvu7sA5sjKiAjMWPpV+YJjIKzkHTPQtI9C6F7ASPz
 KkbJ1ILi3PTcYsMCw7zUcr3ixNzi0rx0veT83E2M4JShpbmDcfuqD3qHGJk4GA8xSnAwK4nw
 3n4zO0WINyWxsiq1KD++qDQntfgQozQHi5I4r/iL3hQhgfTEktTs1NSC1CKYLBMHp1QDk7rf
 o41LXDk7Q6xd7wi3M/Qv4tP0F2fSWcqmyn15Q7P23BkLLn7RWj5p447Ne5/fudDZ+Oxcy8wO
 g9WNRcznxJeKHvFuuJj113Ll+tIviwL8Vdv3h2+6Wx4S3tAQt/Oq9GUR48nXfjy7sU/deMNN
 NiWXGl+uqTIT4v5vW8QcrTaxJ4UvvLL5+i1+PqWNhkEzlXfdE/T98ohLVHaGx+xzpnOb5Mv4
 1Bh2q1YdUgv6/+bXxJPHuW9PE3j/QfKft/JjbW3Fh4G8TtyPFgT1KX4SdJHuEGvhMhLT0/l0
 ZydPvNA1tetW96z8Z6jUa6fmH3Sc/mcpy+ntC1xqvR7t+Op+1Obws8wE1luBaq//lU6yV2Ip
 zkg01GIuKk4EAIi1iPiIAwAA
X-CMS-MailID: 20230630112545epcas5p1746ef2fc966c04b3a8163e0dff21fb4b
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230627184020epcas5p13fdcea52edead5ffa3fae444f923439e
References: <20230627183629.26571-1-nj.shetty@samsung.com>
 <CGME20230627184020epcas5p13fdcea52edead5ffa3fae444f923439e@epcas5p1.samsung.com>
 <20230627183629.26571-4-nj.shetty@samsung.com>
 <ZJ1B1k0KifZrGRIp@ovpn-8-26.pek2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH v13 3/9] block: add emulation for copy
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
Cc: Vincent Fu <vincent.fu@samsung.com>, linux-doc@vger.kernel.org,
 djwong@kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, linux-scsi@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, willy@infradead.org,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org,
 dlemoal@kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
 Keith Busch <kbusch@kernel.org>, bvanassche@acm.org,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 martin.petersen@oracle.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----zUAFM1k0MeHfMyR4CoO9aTysOnQiUYGsRe6BfqD0GhfqR3ws=_26e0b_"

------zUAFM1k0MeHfMyR4CoO9aTysOnQiUYGsRe6BfqD0GhfqR3ws=_26e0b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 23/06/29 04:33PM, Ming Lei wrote:
>Hi Nitesh,
>
>On Wed, Jun 28, 2023 at 12:06:17AM +0530, Nitesh Shetty wrote:
>> For the devices which does not support copy, copy emulation is added.
>> It is required for in-kernel users like fabrics, where file descriptor is
>
>I can understand copy command does help for FS GC and fabrics storages,
>but still not very clear why copy emulation is needed for kernel users,
>is it just for covering both copy command and emulation in single
>interface? Or other purposes?
>
>I'd suggest to add more words about in-kernel users of copy emulation.
>

As you mentioned above, we need a single interface for covering both
copy command and emulation.
This is needed in fabrics cases, as we expose any non copy command
supported target device also as copy capable, so we fallback to emulation
once we recieve copy from host/initator.
Agreed, we will add more description to covey the same info.

>> not available and hence they can't use copy_file_range.
>> Copy-emulation is implemented by reading from source into memory and
>> writing to the corresponding destination asynchronously.
>> Also emulation is used, if copy offload fails or partially completes.
>
>Per my understanding, this kind of emulation may not be as efficient
>as doing it in userspace(two linked io_uring SQEs, read & write with
>shared buffer). But it is fine if there are real in-kernel such users.
>

We do have plans for uring based copy interface in next phase,
once curent series is merged.
With current design we really see the advantage of emulation in fabrics case.

Thank you,
Nitesh Shetty

------zUAFM1k0MeHfMyR4CoO9aTysOnQiUYGsRe6BfqD0GhfqR3ws=_26e0b_
Content-Type: text/plain; charset="utf-8"


------zUAFM1k0MeHfMyR4CoO9aTysOnQiUYGsRe6BfqD0GhfqR3ws=_26e0b_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------zUAFM1k0MeHfMyR4CoO9aTysOnQiUYGsRe6BfqD0GhfqR3ws=_26e0b_--

