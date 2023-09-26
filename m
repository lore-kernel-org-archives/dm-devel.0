Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE41FE7D27F
	for <dm-devel@archiver.kernel.org>; Tue, 26 Sep 2023 11:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695726447;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=jS8WZUkKixiXyE46Umcbnja7Ww2uEMOi5x7Zosfv6CY=;
	b=T5yawwqNm0jKxdIjnqF1CO7D2w7ynOiWd2Q+njt436N9AMfdHdEx0Qj8olwQ9fYOHvyBCX
	utcSywDBTXfPI3HtvCgI1AqItIjw8FFCT4AiZvEah0IZoKxRsyS2utM8cgOntSC6aWdyfb
	OKL37EhOZlj2isIiNF1/pqyJ+PflhA0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-224-t4u6oRjtPtqU3m41qP1yGQ-1; Tue, 26 Sep 2023 07:07:18 -0400
X-MC-Unique: t4u6oRjtPtqU3m41qP1yGQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EF1DA85A5BA;
	Tue, 26 Sep 2023 11:07:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CD35E2156702;
	Tue, 26 Sep 2023 11:07:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A6836194658D;
	Tue, 26 Sep 2023 11:07:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F31E1194658C
 for <dm-devel@listman.corp.redhat.com>; Tue, 26 Sep 2023 10:58:39 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9B6D72026D68; Tue, 26 Sep 2023 10:58:39 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 935042026D4B
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 10:58:39 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73021185A78E
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 10:58:39 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-567-hN2AQC2LMuytNvpT75kXJw-1; Tue, 26 Sep 2023 06:58:37 -0400
X-MC-Unique: hN2AQC2LMuytNvpT75kXJw-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230926105833epoutp038212d50d1c969fb58080c6c4c445fefd~IbbwEZGIH1866118661epoutp03O
 for <dm-devel@redhat.com>; Tue, 26 Sep 2023 10:58:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230926105833epoutp038212d50d1c969fb58080c6c4c445fefd~IbbwEZGIH1866118661epoutp03O
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230926105833epcas5p39c4d5952102ceb27176b612d9882d254~Ibbvg8Iu21175911759epcas5p3X;
 Tue, 26 Sep 2023 10:58:33 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.175]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4RvxYg4YLfz4x9Pp; Tue, 26 Sep
 2023 10:58:31 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
 epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 EC.4A.09023.759B2156; Tue, 26 Sep 2023 19:58:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230926101329epcas5p2008e3144f177f1c88aeb2302a22488e8~Ia0Y6vcOg1077010770epcas5p2Y;
 Tue, 26 Sep 2023 10:13:29 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230926101329epsmtrp25d97cb68c034b365e2834f3b78c445c2~Ia0Y5ebse0140601406epsmtrp2x;
 Tue, 26 Sep 2023 10:13:29 +0000 (GMT)
X-AuditID: b6c32a44-c7ffa7000000233f-4e-6512b957578e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
 7C.7E.18916.8CEA2156; Tue, 26 Sep 2023 19:13:28 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230926101325epsmtip2cfcf64a0696d90208e1d465522eeae77~Ia0VrCoTp2661926619epsmtip2q;
 Tue, 26 Sep 2023 10:13:25 +0000 (GMT)
Date: Tue, 26 Sep 2023 15:37:18 +0530
From: Nitesh Jagadeesh Shetty <nj.shetty@samsung.com>
To: Jinyoung Choi <j-young.choi@samsung.com>
Message-ID: <20230926100718.wcptispc2zhfi5eh@green245>
MIME-Version: 1.0
In-Reply-To: <20230922130815epcms2p631fc5fc5ebe634cc948fef1992f83a38@epcms2p6>
User-Agent: NeoMutt/20171215
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf0xTVxTHvX2P18JWffJjXH5sNCUmw43SOlouBKYbiG9KGJuZJssWeNIX
 SiiltEVk2SaUMX4NC4iIZRswfglO0CqGH5YREFGcA0P41YwtSqkGIiBCTEDYWgrG/z7nm+85
 555z7+Vgzga2JydRoWFUClrOJ5zwG31+7/of73BmhHmjPqh18DaGnq2s4UhbvI6hS1M6As31
 LQFk7skFyDhf6YAmezpYqOlSPwsV6doIVNo7BtDMqJ6FjKb3UM2PdTi6abyLo5HOnwlU1TDD
 RoXj7QRqHNhgoYniGYDazVkAtcwt4OiOyQtNF+YBNLQ+4HDAg+rQT7GpoX+u4tTI/TTK0JxP
 UNfqTlNdk5kEVXvmrANVlD1PUM9mTDi10D1KUGeuNwPqueEdymB+yorhfpkUKmNoKaPiMYr4
 FGmiIiGMf+RobHisWCIU+YuCURCfp6CTmTB+RFSMf2Si3LoEPu8kLU+zSjG0Ws0P+DBUlZKm
 YXiyFLUmjM8opXJloFKgppPVaYoEgYLRhIiEwn1iqzEuSfbkfBemnN916uG5HnYmWH2zADhy
 IBkIH/3WiBcAJ44z2QXg3GMLYQ+WADw/u8p+FSzeXgDbKTOdVVuuDgC1SyNbgQXA6juTbJsL
 J/fA5db/cBsTpBh2Xc22MofjSr4Pc5p9bX6MrObA7vHLm1V3kPuhYdCw6XchQ2Gb7ibb5ueS
 Eph1y8Umc8nd8O4F86bFkYyGL2uLCBu7kd6won4Fs9WE5F+O0PTn5a2TRsDSyUmWnV3g7MB1
 tp094fN5I2HndNhUdpGwJ/8AoH5cv5W8H+YM6jAbY6QMDuZpcbv+Njw32MKy6zth0Zp5qwEX
 tv+6zb7w99bqrQYecOxFFmEbBpIUzL7ytX1ZLwBsWKwAxYCnf204/Wvt7BwC8xe1Dnb2gdlt
 lZjeWgojvWDjBseOfrC1M6AaEM3Ag1GqkxOYeLFSpGDSX72E+JRkA9j8PHsj2sFE1YagF7A4
 oBdADsZ35a5adjLOXCmd8Q2jSolVpckZdS8QW++wBPN0i0+x/j6FJlYUGCwMlEgkgcEfSER8
 d+5czi9SZzKB1jBJDKNkVNt5LI6jZybLYjpUl1p6xPuCJFdOJziZSm598tgpIH1p2OfQk28/
 DqYulrP27DTum1+WZXlMxVe6X5nr1ZoeYILhlZVOJmhAW3bYuHsy5DB6OEa/LAGP1u753+uv
 r9Hsarj/hv5f43dnJZ7XnAbzYhOjDNEwKLTz0/b6qMVUS7NefkITzv+sKtK84C70WZeqvhju
 T8gUYHGuT9mp47N9otMnE3O+51EbuqaDVMGJsgcDx8SkpU9mKTwA3JZrjFVffS7THfP33dES
 R9JN/WErSx7mGMn6jQz3Cqib/kMQzB9am/b7W8nxrT0e/ZE0OfxUt69Xfu5PR2MmMiLdyrve
 Chvz1rS0NZTzcbWMFu3FVGr6f5m9k7TFBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsWy7bCSvO6JdUKpBj3PrCzWnzrGbPHx628W
 i6YJf5ktVt/tZ7N4ffgTo8WTA+2MFnvfzWa1uHlgJ5PFytVHmSx6+7eyWUw6dI3R4unVWUwW
 e29pWyxsW8JisWfvSRaLy7vmsFnMX/aU3aL7+g42i+XH/zFZ3JjwlNFix5NGRot1r9+zWJy4
 JW3xuLuD0eL83+OsDpIeO2fdZfc4f28ji8fls6Uem1Z1snlsXlLvsftmA5vH4r7JrB69ze/Y
 PD4+vcXi8X7fVTaPvi2rGD0+b5Lz2PTkLVMAbxSXTUpqTmZZapG+XQJXxpLDF5kK/vNU/Js1
 h6mBcQVXFyMnh4SAicTTXfPZuhi5OIQEtjNKzHvUxgaRkJRY9vcIM4QtLLHy33N2iKInjBJn
 /lxkBEmwCKhKfFn/nwXEZhMwldi9sRnI5uAQEdCRaF2lDFLPLLCCQ2Lhoh9gNQwC9hKbTm0C
 s4UFbCS29u9hB6nnFTCTaDwiDDH/O6NEz8IlYDW8AoISJ2c+AbOZgWrmbX7IDFLPLCAtsfwf
 B0RYXqJ562ywOzkF/CT+LO4Fu19UQEZixtKvzBMYhWchmTQLyaRZCJNmIZm0gJFlFaNoakFx
 bnpucoGhXnFibnFpXrpecn7uJkZw+tAK2sG4bP1fvUOMTByMhxglOJiVRHh/PeNLFeJNSays
 Si3Kjy8qzUktPsQozcGiJM6rnNOZIiSQnliSmp2aWpBaBJNl4uCUamByOCGwwpBBocPW5HPP
 rjkiNfdviSx9vG158ucZaxwihD45Vhq6FMWntsiHxxrPYP6dZ/lJwvm0qXSuZEm9x0Opji+f
 PrLUcoXv/nPi6/PibbWv4r1XvPy89M9WRb+JFV5PeasLqsNvvj2lzn7GaPrjfA/BZ9p23Bqc
 FjM1Xew9zQPUDpifu//8WcrHDQGn5FLqlKy3nWKffaK1TtXhlG+2T7Ditkbpn7kVSVOeFwnG
 P5q8xLUo0dD27YNQJ/mQ0723v85tO8HL5r84Yw1PYvUWRutlUkW6OoEr81aej+/mVwwI5biw
 tY7haqqjSf3HGW/Uj/1OaC+Y+d7kQx3jxD/2WrcuZ3CUrfqlus2FSYmlOCPRUIu5qDgRAGGm
 ZFGOAwAA
X-CMS-MailID: 20230926101329epcas5p2008e3144f177f1c88aeb2302a22488e8
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081458epcas5p3a3e12d8b5661b5d6f4420316630b02e1
References: <20230920080756.11919-5-nj.shetty@samsung.com>
 <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081458epcas5p3a3e12d8b5661b5d6f4420316630b02e1@epcms2p6>
 <20230922130815epcms2p631fc5fc5ebe634cc948fef1992f83a38@epcms2p6>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH v16 04/12] block: add emulation for copy
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
Cc: Vincent Kang Fu <vincent.fu@samsung.com>,
 "anuj1072538@gmail.com" <anuj1072538@gmail.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, SSDR Gost Dev <gost.dev@samsung.com>,
 "nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----LAXCzQHOdZ.PJY8ISgkP8Kui-li3V03FA_f8OYW0UVQARYhI=_21324_"

------LAXCzQHOdZ.PJY8ISgkP8Kui-li3V03FA_f8OYW0UVQARYhI=_21324_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 write_bio->bi_i=
ter.bi_size =3D chunk;
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D submit_=
bio_wait(write_bio);
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(write_bio=
);
>
>blk_mq_map_bio_put(write_bio) ?
>or bio_uninit(write_bio); kfree(write_bio)?
>
>hmm...
>It continuously allocates and releases memory for bio,
>Why don't you just allocate and reuse bio outside the loop?
>

Agree, we will update this in next version.

>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (ret)
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 break;
>> +
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pos_in +=3D chu=
nk;
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 pos_out +=3D ch=
unk;
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 cio->status =3D ret;
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 kvfree(emulation_io->buf);
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 kfree(emulation_io);
>
>I have not usually seen an implementation that releases memory for
>itself while performing a worker. ( I don't know what's right. :) )
>
The worker is already executing at this point.
We think releasing the reference after it starts executing should not
be an issue, and it didn't come-up in any of our testing too.

>Since blkdev_copy_emulation() allocates memory for the emulation
>and waits for it to be completed, wouldn't it be better to proceed
>with the memory release for it in the same context?
>
>That is, IMO, wouldn't it be better to free the memory related to
>emulation in blkdev_copy_wait_io_completion()?
>

Above mentioned design works for synchronous IOs. But for asynchronous
IOs emulation job is punted to worker and submitter task returns.
Submitter doesn't wait for emulation to complete and memory is freed
later by worker.

Thank you,
Nitesh Shetty

------LAXCzQHOdZ.PJY8ISgkP8Kui-li3V03FA_f8OYW0UVQARYhI=_21324_
Content-Type: text/plain; charset="utf-8"


------LAXCzQHOdZ.PJY8ISgkP8Kui-li3V03FA_f8OYW0UVQARYhI=_21324_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------LAXCzQHOdZ.PJY8ISgkP8Kui-li3V03FA_f8OYW0UVQARYhI=_21324_--

