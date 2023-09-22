Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 417BFCE7A89
	for <dm-devel@archiver.kernel.org>; Sat, 23 Sep 2023 08:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695456805;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=zHTH0gZZr/PKGTnkqIuuBm+kObpXJC/GDwDi8heonsk=;
	b=Ikuiz9nnYRqXikfbk5Ne6WkoENYxx0vmYpKyTCP0H5IToPdjJPsyJtVjIjNLhA3KvNKn6F
	z5LuUA+/F0dSgewksYsv12ccqvXhYUfEPyt8Ob/SnsFFlVvU+s8I0UQdFLKNzNHj/rhtkh
	i5PhvYJUyqH3dlERQ5roTkS3udYzsRk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-6ANxtERPM3KfFDw2OcS58w-1; Sat, 23 Sep 2023 04:13:20 -0400
X-MC-Unique: 6ANxtERPM3KfFDw2OcS58w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87103185A78E;
	Sat, 23 Sep 2023 08:13:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3F4E971128B;
	Sat, 23 Sep 2023 08:13:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 07A2C19465B8;
	Sat, 23 Sep 2023 08:13:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 2E3601946586
 for <dm-devel@listman.corp.redhat.com>; Sat, 23 Sep 2023 08:13:15 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 1893440C2070; Sat, 23 Sep 2023 08:13:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1038C40C2064
 for <dm-devel@redhat.com>; Sat, 23 Sep 2023 08:13:15 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4D27811E7B
 for <dm-devel@redhat.com>; Sat, 23 Sep 2023 08:13:14 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-193-ijTA8vKbOOqHZqGWAOeJnQ-1; Sat, 23 Sep 2023 04:13:12 -0400
X-MC-Unique: ijTA8vKbOOqHZqGWAOeJnQ-1
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230923081305epoutp033c9b87a9f5a87c659f54fd004c73d749~HePaUL27a2328423284epoutp03H
 for <dm-devel@redhat.com>; Sat, 23 Sep 2023 08:13:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230923081305epoutp033c9b87a9f5a87c659f54fd004c73d749~HePaUL27a2328423284epoutp03H
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230923081303epcas5p1556a5e37929a332e7b59407ddb854315~HePY2SkX20487904879epcas5p1i;
 Sat, 23 Sep 2023 08:13:03 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.183]) by
 epsnrtp1.localdomain (Postfix) with ESMTP id 4Rt22449bnz4x9Pr; Sat, 23 Sep
 2023 08:13:00 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 20.26.09638.C0E9E056; Sat, 23 Sep 2023 17:13:00 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
 20230922111746epcas5p204bf631f0d45f43c5fb13bad26b2c798~HNHYET5c51000710007epcas5p2q;
 Fri, 22 Sep 2023 11:17:46 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230922111746epsmtrp22f04a152ad73f84d56629c97edbd2234~HNHYDC8w22146921469epsmtrp2S;
 Fri, 22 Sep 2023 11:17:46 +0000 (GMT)
X-AuditID: b6c32a4a-92df9700000025a6-78-650e9e0ca620
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 16.D3.08649.AD77D056; Fri, 22 Sep 2023 20:17:46 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230922111742epsmtip1dfbf7bb7f35d2f16f25d65543eb97821~HNHU3SCWc2955729557epsmtip1A;
 Fri, 22 Sep 2023 11:17:42 +0000 (GMT)
Date: Fri, 22 Sep 2023 16:41:41 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Jinyoung Choi <j-young.choi@samsung.com>
Message-ID: <20230922111141.GA14640@green245>
MIME-Version: 1.0
In-Reply-To: <20230922095650epcms2p8e25340eff5de01f8b3ce63ae81266881@epcms2p8>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Ta1AbVRTHvbvLJlBhFgp6oa8QhikPoaRCeqFA1aJuHzJ0HL/otJCBFRBI
 0jzEWrWJGJRSXi1YDYWCpKWkD8ojhT5SGQJEYBhUCBSQSiV0FAZog9KhLWjCUqfffud/z/+e
 e86Zy8U99BwfbrpYwcjEokw+6UJcMwUGhbxY6caEdVZ4o/qeLhw9/OcJgb4sXsbRxfEiEs2Y
 bABZ274GyDhX7oRG2q5j6NYPJzFUd7ETQwVFBhKdbB8CaMqixZBxNBhV5+oIdMvYTaCBG2dI
 dPb8FAflD7eSqNa8gqE7xVMAtVrVAF2ZmSfQT6MbUP+y2ek1b/q6dpxD999tIOiBPiXdqM8j
 6SbdMfrmiIqkawpPOdEFOXMk/XBqlKDnb1tIurBZD+im3qP0QuNmutE6iyW4vZ8RncaIUhgZ
 jxEnS1LSxakx/H3vJu5OjBCGCUIEkWgHnycWZTEx/Lj9CSFvpWfaB8HnfSzKVNqlBJFczt8W
 Gy2TKBUML00iV8TwGWlKpjRcGioXZcmV4tRQMaOIEoSFbY+wJyZlpI2MDRJSi+sni5NdmApo
 1h0HzlxIhcOWjnnsOHDhelA3ARw7YSHYwAbgX7OTOBssAriy1GJP465a1LOfsboRwJmSPzls
 cB9Ai6bHyXEvQfnDwrYywmEgqWDY+y/XgZ7UK1Cj93Ok45SFC+uWdcCRvp6KhcaKCY6DXakQ
 2GVuwFh2h93fWwkHO1PxMD+3k3SwF+UH266ZV58NqV+d4Y+LlzlsP3GwtL6DYHk9nDY3r+k+
 cGHOSLKcDetKL5Cs+SsAtcNawB7sgpqeItzBOJUGqwyDa+ZNsKznCsbqbrDgiRVjdVfYWvmM
 /eCl+qq1At5w6JF6jWnYp+lYG+MjADV3zZxisEX7XHfa5+qxHArvlJWSLG+BOYZyXGufHk5t
 gLUrXBYDYf2NbVWA1ANvRirPSmXkEdLtYib7/+0nS7IaweqnCdrbCu5NPAhtBxgXtAPIxfme
 rsk2F8bDNUV05FNGJkmUKTMZeTuIsC+uBPfxSpbYf51YkSgIjwwLFwqF4ZGvCgX8l11nNBUp
 HlSqSMFkMIyUkT3zYVxnHxX2+bmMYeneMMPhxyaf6taDns3nbg9dUI0nHzp9zFDEU0WRfceZ
 rQMpI9IXeny/2CeY9n2Qv6Qs+e1sXuLwh5yl2Z0V/o+jbLrdJ3IPtgR8kDjHCypTGKItObJ7
 0l1/cy5vVMcFwKtHevM+sjWW+/k3Ly/Z6g0G9/x37g81WLBfLIFtHeNjnm9+txFdOjxfm+Be
 VJyR9w01Yg2uqQowbXV7w+Np7Ns1uqSOmAp96B8HTh0YMlkLCo82CcnuQ5w9vpPZzi9p3dZN
 q3uf7ijoUKUaJN+OnFboDJ7qPf34VX7371VJ4z+bPJU74/fHD545vyCUvC6srJ7YvEk71GKt
 9Ip9T12r4BPyNJEgCJfJRf8BApbBjb0EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsWy7bCSnO6tct5Ug94+Vov1p44xW3z8+pvF
 omnCX2aL1Xf72SxeH/7EaPHkQDujxd53s1ktbh7YyWSxZ9EkJouVq48yWfT2b2WzmHToGqPF
 06uzmCz23tK2WNi2hMViz96TLBaXd81hs5i/7Cm7Rff1HWwWy4//Y7K4MeEpo8WOJ42MFute
 v2exOHFL2uL83+OsDpIeO2fdZfc4f28ji8fls6Uem1Z1snlsXlLvsftmA5vH4r7JrB69ze/Y
 PD4+vcXi8X7fVTaPvi2rGD02n672+LxJzmPTk7dMAXxRXDYpqTmZZalF+nYJXBnPXy9kK/jE
 VXH3eh9zA+M+ji5GDg4JAROJxrc1XYxcHEICuxklum4sYuxi5ASKS0os+3uEGcIWllj57zk7
 RNETRon9h06wgSRYBFQl+g5MZQEZxCagLXH6P9hMEQEdidZVyiDlzAK3OSSen+9lBSkXFrCT
 2Dv3ATuIzSugK3Hs+EYmiJnfGSU+z33NApEQlDg58wmYzQw0aOfWO2wgQ5kFpCWW/+OACMtL
 NG+dDXYbp4CfRHfbUbBzRAWUJQ5sO840gVFoFpJJs5BMmoUwaRaSSQsYWVYxSqYWFOem5yYb
 FhjmpZbrFSfmFpfmpesl5+duYgQnDS2NHYz35v/TO8TIxMF4iFGCg1lJhDf5E1eqEG9KYmVV
 alF+fFFpTmrxIUZpDhYlcV7DGbNThATSE0tSs1NTC1KLYLJMHJxSDUw8pTu/rag/wGq6M8Qo
 Z3a54I399ipzfzQd3fQyQJpxSzjLKl/l5UnGD++fnXtqQbHA7OgZj3jXyLpn7b/tPve7rVHj
 +s2bnn34lbdR98SW5wK2O9RXFXB0Sc7JWTvlRdu5zitrX79kqcmLzJOcMnfxh5dChgLRwt4b
 tW9Kh9mqfXFYalUTfKx8gpuA/8+vMvwG865f63qyfs6XinyR70t/NbQZPPh+dXZI+deT/au2
 pmU+3iFlyL5vDxszb8j3IL4FnzXnekQpXXlS05Ba+uWW65pXIZInTz7M9RB5dzlyV/tsEbGj
 HMYbOCzv3jywwlV70cOIa8f9lwa/ETi5OcDmjqLHtz05XCtjplXqGpeKK7EUZyQaajEXFScC
 AFPrTUWJAwAA
X-CMS-MailID: 20230922111746epcas5p204bf631f0d45f43c5fb13bad26b2c798
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230920081447epcas5p144e631c5b8c72acf64d38b04d6c2c925
References: <20230920080756.11919-4-nj.shetty@samsung.com>
 <20230920080756.11919-1-nj.shetty@samsung.com>
 <CGME20230920081447epcas5p144e631c5b8c72acf64d38b04d6c2c925@epcms2p8>
 <20230922095650epcms2p8e25340eff5de01f8b3ce63ae81266881@epcms2p8>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH v16 03/12] block: add copy offload support
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
Cc: "anuj1072538@gmail.com" <anuj1072538@gmail.com>,
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
 Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "mcgrof@kernel.org" <mcgrof@kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----r74_f6S_OIQxXK41.4aq6v4zMY6akVoN.sMgyBemj3VfQZgP=_119e9_"

------r74_f6S_OIQxXK41.4aq6v4zMY6akVoN.sMgyBemj3VfQZgP=_119e9_
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 22, 2023 at 06:56:50PM +0900, Jinyoung Choi wrote:
> > +/*
> > + * This must only be called once all bios have been issued so that the=
 refcount
> > + * can only decrease. This just waits for all bios to complete.
> > + * Returns the length of bytes copied or error
> > + */
> > +static ssize_t blkdev_copy_wait_io_completion(struct blkdev_copy_io *c=
io)
>=20
> Hi, Nitesh,
>=20
> don't functions waiting for completion usually set their names to 'wait_f=
or_completion_'?
> (e.g. blkdev_copy_wait_for_completion_io)
>=20
>=20
> > +ssize_t blkdev_copy_offload(struct block_device *bdev, loff_t pos_in,
> > +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 loff_t pos_out=
, size_t len,
> > +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void (*endio)(=
void *, int, ssize_t),
> > +=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void *private,=
 gfp_t gfp)
> > +{
> > +=A0 =A0 =A0 =A0 struct blkdev_copy_io *cio;
> > +=A0 =A0 =A0 =A0 struct blkdev_copy_offload_io *offload_io;
> > +=A0 =A0 =A0 =A0 struct bio *src_bio, *dst_bio;
> > +=A0 =A0 =A0 =A0 ssize_t rem, chunk, ret;
> > +=A0 =A0 =A0 =A0 ssize_t max_copy_bytes =3D bdev_max_copy_sectors(bdev)=
 << SECTOR_SHIFT;
>=20
> wouldn't it be better to use size_t for variables that don't return?
> values such as chunk and max_copy_bytes may be defined as 'unsigned'.

Agree, we will keep ret as ssize_t and move others to size_t.
Acked for all other comments, will address them in next version.

Thank You,
Nitesh Shetty

------r74_f6S_OIQxXK41.4aq6v4zMY6akVoN.sMgyBemj3VfQZgP=_119e9_
Content-Type: text/plain; charset="utf-8"


------r74_f6S_OIQxXK41.4aq6v4zMY6akVoN.sMgyBemj3VfQZgP=_119e9_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------r74_f6S_OIQxXK41.4aq6v4zMY6akVoN.sMgyBemj3VfQZgP=_119e9_--

