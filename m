Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 585B7C7618E
	for <dm-devel@archiver.kernel.org>; Wed, 26 Apr 2023 10:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682505090;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=8001f3sMG7DOdHpNEOUwRAh/G0hmrMyTybz95LH8F2E=;
	b=EgzUbOnuU8zAqd3YZdWUj5UldETmRl4gpJYVi80tzvfvOgJoHzXwQegvurvtrWvct94SNO
	rfEKpNRBUSkyXHwMRcqVC450+frXKu1Gd6Ujsz4GP7TM5gYqG/u6jUJxoKR7hcv/ysMLrM
	2D1T5eh2Z7CzxycywvtgQjX2Ism1Hgk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-TcKKDKJ3NUqaB0T6nIZxRQ-1; Wed, 26 Apr 2023 06:31:26 -0400
X-MC-Unique: TcKKDKJ3NUqaB0T6nIZxRQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1A6FA0F389;
	Wed, 26 Apr 2023 10:31:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9B9342166B47;
	Wed, 26 Apr 2023 10:31:24 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 773F11946A41;
	Wed, 26 Apr 2023 10:31:24 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D39E2194658D
 for <dm-devel@listman.corp.redhat.com>; Tue, 25 Apr 2023 08:38:21 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7AE3C2027045; Tue, 25 Apr 2023 08:38:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7202F2027043
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 08:38:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 528FD85A588
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 08:38:21 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-vMEPwjfsNr6gQ1e0okdbng-1; Tue, 25 Apr 2023 04:38:18 -0400
X-MC-Unique: vMEPwjfsNr6gQ1e0okdbng-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout4.samsung.com (KnoxPortal) with ESMTP id
 20230425083815epoutp047c3314c0fee2af91d2c85779faf1c3c4~ZILST9rTb1411714117epoutp04k
 for <dm-devel@redhat.com>; Tue, 25 Apr 2023 08:38:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com
 20230425083815epoutp047c3314c0fee2af91d2c85779faf1c3c4~ZILST9rTb1411714117epoutp04k
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p3.samsung.com (KnoxPortal) with ESMTP id
 20230425083815epcas5p39854738053985ff0e106a9043d4c4087~ZILRweSJ10616906169epcas5p3V;
 Tue, 25 Apr 2023 08:38:15 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4Q5Fks3DGcz4x9Px; Tue, 25 Apr
 2023 08:38:13 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 0F.2A.54880.57197446; Tue, 25 Apr 2023 17:38:13 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230425082930epcas5p1157cd2ebc608fe4d4247e8a7d860ba7c~ZIDo3arJ-0885208852epcas5p1T;
 Tue, 25 Apr 2023 08:29:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230425082930epsmtrp14bd10fb98c25a06f84d7e583df65c478~ZIDo0xR6v1984619846epsmtrp1J;
 Tue, 25 Apr 2023 08:29:30 +0000 (GMT)
X-AuditID: b6c32a49-b21fa7000001d660-ba-64479175ed5c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 71.4A.27706.96F87446; Tue, 25 Apr 2023 17:29:30 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230425082925epsmtip222d9f988a7e984bda383203b39ff8c6b~ZIDksCMmW2116121161epsmtip2B;
 Tue, 25 Apr 2023 08:29:25 +0000 (GMT)
Date: Tue, 25 Apr 2023 13:56:34 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20230425082634.GA23150@green245>
MIME-Version: 1.0
In-Reply-To: <77ed029d-4058-b7f9-8dd1-6bc4b1c2b0dc@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Tf1STVRjHue873g2PW6+AchmonFlylJibjXEh8Udx5PXYOVJZHTmdQ3N7
 49fY1sYgKmoIqFAImlgOSCwqBg2U3zAmNkPip50IwZ0DakC/PPxM8CggbXul+u9zv8/3uc99
 7nMeDu5pZPM5CaoUWquSKQXEGlbjtW2BwfrTUQqR+ScvVNN9HUfHCpdxVDVSQKB71+YAOjfz
 EEfT34+5ozvte5B1qtgd3bragqG2L89gyFTVgSHLxVkMdaxMEuiM7SZAVnsQarN2sdBAawmB
 LnwzwUa2T7Mw1DyeCVD1vWkW+tHuh24sd7rv9aEGfjlIGW/3EVSLcYRN3Ri9zKIG+vRUbWUu
 QdWVf0RZbhkIKj9riqCmrwwS1Kn6SkDV9bxP/V27iaodn8SieTFJu+JpmYLWBtAquVqRoIqL
 EBx8NfbF2BCpSBwsDkOhggCVLJmOEES+FB28P0HpaF4QkCpT6h1StEynE+zYvUur1qfQAfFq
 XUqEgNYolBqJRqiTJev0qjihik4JF4tEO0McxreS4s118+6abvm7n8+usA3AfigPcDiQlMCZ
 S755YA3Hk7QAuLI8wGIOcwDacttx5rAA4OK4CV/NGM7R5AEPh24Fjmw+4/kNwJHGWcIZYJHP
 wPyOJZbTT5BBsGeF45S9SSEctA+znX6cvMuG5t9LWM6AF/kKPDYzhjmZSwbDwlPFLIbXwa7z
 4y72IHfDR+2fuHg9uQVebezEnBdB0uIBc5fMrgAkI+Hi/MAT9oJ/ddazGebDPwuOP+E0aDpb
 QTDJ2QAah4yACeyBOd0Fri5xMh4O25MYeSMs6q52PQ4neTB/cRxjdC5s/mKVt8DvasoIhn3h
 zQeZBPNZFOxt4zIfNA3g15ceuReCzcb/9Wb8r5rRVUEIh4vOEgxvhlkNxThj8YPfPuYwuA3W
 tO4oA0Ql8KU1uuQ4WheiEavotH8nL1cn1wLXkmw/0AxG7swIbQDjABuAHFzgzeWmRyk8uQpZ
 +nu0Vh2r1StpnQ2EOMZ2Guevl6sdW6ZKiRVLwkQSqVQqCXtOKhb4cAMjuuSeZJwshU6iaQ2t
 Xc3DOB58A0ZcbDIZDEpbZsVnPvxeFu/wUi5aqD+neDs/9MH90gb/D9vnjzTczk4Nf7NII0t2
 C/qjaow3Wnc3Y/HED/7Wh9LjJkXqG0/HlHPN1e0Zm/JivK+c2F8/VDMYGLM1vXzrUNDzE1Nl
 k2H2THmi25z/kb4mHiofJhTmk+UneQa1MDvm2REOT9n7QUsA7/W0npzzPW7v7B2NkiWu8MRY
 2lHRU32hlb9O88luqiv/hdTSwBJuf9mhw/vWWiYWhBTuI8xo21Dq93PXBr5JF96EwpYk/ZZ1
 glav8NzRQDZHael57fLL8ONZRVV/nHnZqr5gLzr6OKEx8itr4r7rOzfeb05dW3FAwNLFy8Tb
 ca1O9g+wEbW/rQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNIsWRmVeSWpSXmKPExsWy7bCSvG5Wv3uKwZJOJov1p44xWzRN+Mts
 sfpuP5vF68OfGC2mffjJbPH+4GNWiwf77S32vpvNanHzwE4miz2LJjFZrFx9lMli98KPTBZH
 /79ls5h06Bqjxd5b2hZ79p5ksbi8aw6bxfxlT9ktDk1uZrLY8aSR0WLd6/csFiduSVuc/3uc
 1UHc4/IVb49Z98+yeeycdZfd4/y9jSwel8+Wemxa1cnmsXlJvcfumw1sHr3N79g83u+7yubR
 t2UVo8fm09UenzfJeWx68pYpgC+KyyYlNSezLLVI3y6BK+POuk7GgucJFQsmnmVvYJzs28XI
 wSEhYCJxo7Wgi5GLQ0hgN6PEzDefmLoYOYHikhLL/h5hhrCFJVb+e84OUfSEUeL+++msIAkW
 AVWJ3qN/WEAGsQloS5z+zwESFhHQk7h66wZYPbPAS3aJ3wsngQ0SFgiSmPBuHpjNK6ArMaFv
 NgvE0PeMEhfe90MlBCVOznzCAmIzC+hI7Nx6hw1kAbOAtMTyfxwQYXmJ5q2zwco5Bewkfu3v
 ASsXFVCWOLDtONMERqFZSCbNQjJpFsKkWUgmLWBkWcUomVpQnJueW2xYYJiXWq5XnJhbXJqX
 rpecn7uJEZwetDR3MG5f9UHvECMTB+MhRgkOZiURXt5K9xQh3pTEyqrUovz4otKc1OJDjNIc
 LErivBe6TsYLCaQnlqRmp6YWpBbBZJk4OKUamNizl86ck+Zx6WZ6RsZc9+dPC5fdmfxup2WK
 SWLH/vN9f/9G7M0RdZn3VMa5Q7ZUXVh+7VuVGTsKO7bdCbm03jLxbWB2ftmkmQkaotmT1weK
 MAnlCHuJhZ44Pc/4huvp5O1xdjZ/zA8c1AhJY9qqOuXT0oJPH//t2uwTxH/A2vB079Y5uQeM
 Vxny/RUPEFHUejjx+0LzpH1V3rF3D3bPmvlKR/vlxXeqijXHsj4JTouSnNvapMcRzRMmMbNf
 Y9edpAhjwWCNpHj74zsnLBVg9hWe6Tz98YN0DzXlji2CHzv3HDpumrPd+aHMrKgqRTmn+ZM0
 /CS50xbJ75XT/GfOZZ8mUO3cw5Rg63mx4iWLEktxRqKhFnNRcSIAIDigr34DAAA=
X-CMS-MailID: 20230425082930epcas5p1157cd2ebc608fe4d4247e8a7d860ba7c
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230411081332epcas5p257c090a0d1ea6abf98416ca687f6c1e1
References: <20230411081041.5328-1-anuj20.g@samsung.com>
 <CGME20230411081332epcas5p257c090a0d1ea6abf98416ca687f6c1e1@epcas5p2.samsung.com>
 <20230411081041.5328-7-anuj20.g@samsung.com>
 <77ed029d-4058-b7f9-8dd1-6bc4b1c2b0dc@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mailman-Approved-At: Wed, 26 Apr 2023 10:31:22 +0000
Subject: Re: [dm-devel] [PATCH v9 6/9] nvmet: add copy command support for
 bdev and file ns
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
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>,
 Alasdair Kergon <agk@redhat.com>, Sagi Grimberg <sagi@grimberg.me>,
 "gost.dev@samsung.com" <gost.dev@samsung.com>,
 "nitheshshetty@gmail.com" <nitheshshetty@gmail.com>,
 James Smart <james.smart@broadcom.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, "ming.lei@redhat.com" <ming.lei@redhat.com>,
 "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "dlemoal@kernel.org" <dlemoal@kernel.org>, Keith Busch <kbusch@kernel.org>,
 "bvanassche@acm.org" <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>,
 "joshi.k@samsung.com" <joshi.k@samsung.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----d4EnuX4PxHJ3dMseTbYmBkzD7TFyGjCVpggVcmKL0qRf9gu2=_43cbf_"

------d4EnuX4PxHJ3dMseTbYmBkzD7TFyGjCVpggVcmKL0qRf9gu2=_43cbf_
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 25, 2023 at 06:36:51AM +0000, Chaitanya Kulkarni wrote:
> On 4/11/23 01:10, Anuj Gupta wrote:
> > From: Nitesh Shetty <nj.shetty@samsung.com>
> >
> > Add support for handling target command on target.
>=20
> what is target command ?
>=20
> command that you have added is :nvme_cmd_copy
>

acked. It was supposed to be nvme_cmd_copy.

> > For bdev-ns we call into blkdev_issue_copy, which the block layer
> > completes by a offloaded copy request to backend bdev or by emulating t=
he
> > request.
> >
> > For file-ns we call vfs_copy_file_range to service our request.
> >
> > Currently target always shows copy capability by setting
> > NVME_CTRL_ONCS_COPY in controller ONCS.
>=20
> there is nothing mentioned about target/loop.c in commit log ?
>

acked, will add the description for loop device.

> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > ---
> >   drivers/nvme/target/admin-cmd.c   |  9 +++--
> >   drivers/nvme/target/io-cmd-bdev.c | 58 ++++++++++++++++++++++++++++++=
+
> >   drivers/nvme/target/io-cmd-file.c | 52 +++++++++++++++++++++++++++
> >   drivers/nvme/target/loop.c        |  6 ++++
> >   drivers/nvme/target/nvmet.h       |  1 +
> >   5 files changed, 124 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admi=
n-cmd.c
> > index 80099df37314..978786ec6a9e 100644
> > --- a/drivers/nvme/target/admin-cmd.c
> > +++ b/drivers/nvme/target/admin-cmd.c
> > @@ -433,8 +433,7 @@ static void nvmet_execute_identify_ctrl(struct nvme=
t_req *req)
> >   =09id->nn =3D cpu_to_le32(NVMET_MAX_NAMESPACES);
> >   =09id->mnan =3D cpu_to_le32(NVMET_MAX_NAMESPACES);
> >   =09id->oncs =3D cpu_to_le16(NVME_CTRL_ONCS_DSM |
> > -=09=09=09NVME_CTRL_ONCS_WRITE_ZEROES);
> > -
> > +=09=09=09NVME_CTRL_ONCS_WRITE_ZEROES | NVME_CTRL_ONCS_COPY);
> >   =09/* XXX: don't report vwc if the underlying device is write through=
 */
> >   =09id->vwc =3D NVME_CTRL_VWC_PRESENT;
> >  =20
> > @@ -536,6 +535,12 @@ static void nvmet_execute_identify_ns(struct nvmet=
_req *req)
> >  =20
> >   =09if (req->ns->bdev)
> >   =09=09nvmet_bdev_set_limits(req->ns->bdev, id);
> > +=09else {
> > +=09=09id->msrc =3D (u8)to0based(BIO_MAX_VECS - 1);
> > +=09=09id->mssrl =3D cpu_to_le16(BIO_MAX_VECS <<
> > +=09=09=09=09(PAGE_SHIFT - SECTOR_SHIFT));
> > +=09=09id->mcl =3D cpu_to_le32(le16_to_cpu(id->mssrl));
> > +=09}
> >  =20
> >   =09/*
> >   =09 * We just provide a single LBA format that matches what the
> > diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io=
-cmd-bdev.c
> > index c2d6cea0236b..0af273097aa4 100644
> > --- a/drivers/nvme/target/io-cmd-bdev.c
> > +++ b/drivers/nvme/target/io-cmd-bdev.c
> > @@ -46,6 +46,19 @@ void nvmet_bdev_set_limits(struct block_device *bdev=
, struct nvme_id_ns *id)
> >   =09id->npda =3D id->npdg;
> >   =09/* NOWS =3D Namespace Optimal Write Size */
> >   =09id->nows =3D to0based(bdev_io_opt(bdev) / bdev_logical_block_size(=
bdev));
> > +
> > +=09/*Copy limits*/
>=20
> above comment doesn't make any sense ...
>

acked, will remove it next version.

> > +=09if (bdev_max_copy_sectors(bdev)) {
> > +=09=09id->msrc =3D id->msrc;
> > +=09=09id->mssrl =3D cpu_to_le16((bdev_max_copy_sectors(bdev) <<
> > +=09=09=09=09SECTOR_SHIFT) / bdev_logical_block_size(bdev));
> > +=09=09id->mcl =3D cpu_to_le32(id->mssrl);
> > +=09} else {
> > +=09=09id->msrc =3D (u8)to0based(BIO_MAX_VECS - 1);
> > +=09=09id->mssrl =3D cpu_to_le16((BIO_MAX_VECS << PAGE_SHIFT) /
> > +=09=09=09=09bdev_logical_block_size(bdev));
> > +=09=09id->mcl =3D cpu_to_le32(id->mssrl);
> > +=09}
> >   }
> >  =20
> >   void nvmet_bdev_ns_disable(struct nvmet_ns *ns)
> > @@ -184,6 +197,19 @@ static void nvmet_bio_done(struct bio *bio)
> >   =09nvmet_req_bio_put(req, bio);
> >   }
> >  =20
> > +static void nvmet_bdev_copy_end_io(void *private, int comp_len)
> > +{
> > +=09struct nvmet_req *req =3D (struct nvmet_req *)private;
> > +
> > +=09if (comp_len =3D=3D req->copy_len) {
> > +=09=09req->cqe->result.u32 =3D cpu_to_le32(1);
> > +=09=09nvmet_req_complete(req, errno_to_nvme_status(req, 0));
> > +=09} else {
> > +=09=09req->cqe->result.u32 =3D cpu_to_le32(0);
> > +=09=09nvmet_req_complete(req, blk_to_nvme_status(req, BLK_STS_IOERR));
> > +=09}
> > +}
> > +
>=20
> please reduce calls for nvmet_req_complete().
>=20
> +static void nvmet_bdev_copy_end_io(void *private, int comp_len)
> +{
> +=09struct nvmet_req *req =3D (struct nvmet_req *)private;
> +=09u16 status;
> +
> +=09if (comp_len =3D=3D req->copy_len) {
> +=09=09req->cqe->result.u32 =3D cpu_to_le32(1);
> +=09=09status =3D errno_to_nvme_status(req, 0));
> +=09} else {
> +=09=09req->cqe->result.u32 =3D cpu_to_le32(0);
> +=09=09status =3D blk_to_nvme_status(req, BLK_STS_IOERR));
> +=09}
> +=09nvmet_req_complete(req, status);
> +}
> +
>

makes sense, will modify this snippet.

> >   #ifdef CONFIG_BLK_DEV_INTEGRITY
> >   static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bi=
o,
> >   =09=09=09=09struct sg_mapping_iter *miter)
> > @@ -450,6 +476,34 @@ static void nvmet_bdev_execute_write_zeroes(struct=
 nvmet_req *req)
> >   =09}
> >   }
> >  =20
> > +/* At present we handle only one range entry */
>=20
> please add explanation why ...
>
Because we aligned copy offload similar to copy_file_range in out recent
revisions, discarding multi range support.
Sure we will update comments to reflect the same.

> > +static void nvmet_bdev_execute_copy(struct nvmet_req *req)
> > +{
> > +=09struct nvme_copy_range range;
> > +=09struct nvme_command *cmnd =3D req->cmd;
>=20
> don't use cmnd, cmd is used everywhere and matches req->cmd,
> applies to everywhere in this patch...
>=20

acked

> > +=09int ret;
>=20
> wrong return type is should be u16 since nvmet_copy_from_sgl()
> returns u16 if I remember correctly.
>=20
> > +
> > +
>=20

acked

> no extra white line between declaration and body of functions
>

acked

> > +=09ret =3D nvmet_copy_from_sgl(req, 0, &range, sizeof(range));
> > +=09if (ret)
> > +=09=09goto out;
> > +
> > +=09ret =3D blkdev_issue_copy(req->ns->bdev,
> > +=09=09le64_to_cpu(cmnd->copy.sdlba) << req->ns->blksize_shift,
> > +=09=09req->ns->bdev,
> > +=09=09le64_to_cpu(range.slba) << req->ns->blksize_shift,
> > +=09=09(le16_to_cpu(range.nlb) + 1) << req->ns->blksize_shift,
> > +=09=09nvmet_bdev_copy_end_io, (void *)req, GFP_KERNEL);
> > +=09if (ret) {
> > +=09=09req->cqe->result.u32 =3D cpu_to_le32(0);
> > +=09=09nvmet_req_complete(req, blk_to_nvme_status(req, BLK_STS_IOERR));
> > +=09}
> > +
> > +=09return;
> > +out:
> > +=09nvmet_req_complete(req, errno_to_nvme_status(req, ret));
> > +}
> > +
>=20
> again one call to nvmet_req_complete() can do the same job.
> consider following totally untested=A0 :-
> /* TODO: add detailed comment here why you support one range ? */
> static void nvmet_bdev_execute_copy(struct nvmet_req *req)
> {
>  =A0=A0=A0=A0=A0=A0=A0 u32 blkshift =3D req->ns->blksize_shift;
>  =A0=A0=A0=A0=A0=A0=A0 struct nvme_command *cmnd =3D req->cmd;
>  =A0=A0=A0=A0=A0=A0=A0 struct nvme_copy_range range;
>  =A0=A0=A0=A0=A0=A0=A0 u16 status;
>=20
>  =A0=A0=A0=A0=A0=A0=A0 status =3D nvmet_copy_from_sgl(req, 0, &range, siz=
eof(range));
>  =A0=A0=A0=A0=A0=A0=A0 if (status) {
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 goto out;
>  =A0=A0=A0=A0=A0=A0=A0 }
>=20
>  =A0=A0=A0=A0=A0=A0=A0 ret =3D blkdev_issue_copy(req->ns->bdev,
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 le64_to_cpu(cmnd->copy.sdlba) << blkshift,
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 req->ns->bdev,
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 le64_to_cpu(range.slba) << blksize_shift,
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 (le16_to_cpu(range.nlb) + 1) <<=20
> blksize_shift,
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 nvmet_bdev_copy_end_io, (void *)req,=20
> GFP_KERNEL);
>  =A0=A0=A0=A0=A0=A0=A0 if (ret) {
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 req->cqe->result.u32 =3D c=
pu_to_le32(0);
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 status =3D blk_to_nvme_sta=
tus(req, BLK_STS_IOERR);
> out:
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvmet_req_complete(req, st=
atus);
>  =A0=A0=A0=A0=A0=A0=A0 }
> }
>=20

acked, thanks for sharing the snippet

> >   u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
> >   {
> >   =09switch (req->cmd->common.opcode) {
> > @@ -468,6 +522,10 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
> >   =09case nvme_cmd_write_zeroes:
> >   =09=09req->execute =3D nvmet_bdev_execute_write_zeroes;
> >   =09=09return 0;
> > +=09case nvme_cmd_copy:
> > +=09=09req->execute =3D nvmet_bdev_execute_copy;
> > +=09=09return 0;
> > +
> >   =09default:
> >   =09=09return nvmet_report_invalid_opcode(req);
> >   =09}
> > diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io=
-cmd-file.c
> > index 2d068439b129..69f198ecec77 100644
> > --- a/drivers/nvme/target/io-cmd-file.c
> > +++ b/drivers/nvme/target/io-cmd-file.c
> > @@ -322,6 +322,49 @@ static void nvmet_file_dsm_work(struct work_struct=
 *w)
> >   =09}
> >   }
> >  =20
> > +static void nvmet_file_copy_work(struct work_struct *w)
> > +{
> > +=09struct nvmet_req *req =3D container_of(w, struct nvmet_req, f.work)=
;
> > +=09int nr_range;
> > +=09loff_t pos;
> > +=09struct nvme_command *cmnd =3D req->cmd;
> > +=09int ret =3D 0, len =3D 0, src, id;
>=20
> reverse tree style for declaration ...
>=20

acked

> > +
> > +=09nr_range =3D cmnd->copy.nr_range + 1;
> > +=09pos =3D le64_to_cpu(req->cmd->copy.sdlba) << req->ns->blksize_shift=
;
>=20
> you have a cmd variable above and you are still using req->cmd ?
> why create a variable on stack then ? u don't need that variable
> anyways...
>

acked

> > +=09if (unlikely(pos + req->transfer_len > req->ns->size)) {
> > +=09=09nvmet_req_complete(req, errno_to_nvme_status(req, -ENOSPC));
> > +=09=09return;
> > +=09}
> > +
> > +=09for (id =3D 0 ; id < nr_range; id++) {
> > +=09=09struct nvme_copy_range range;
> > +
> > +=09=09ret =3D nvmet_copy_from_sgl(req, id * sizeof(range), &range,
> > +=09=09=09=09=09sizeof(range));
> > +=09=09if (ret)
> > +=09=09=09goto out;
> > +
> > +=09=09len =3D (le16_to_cpu(range.nlb) + 1) << (req->ns->blksize_shift)=
;
> > +=09=09src =3D (le64_to_cpu(range.slba) << (req->ns->blksize_shift));
> > +=09=09ret =3D vfs_copy_file_range(req->ns->file, src, req->ns->file,
> > +=09=09=09=09=09pos, len, 0);
>=20
> 5th paramaeter to vfs_copy_file_range() is size_t you have used int
> for len ? also
> vfs_copy_file_range() returns ssize_t you are catching it in int ?
>

acked, will change it to ssize_t.

> > +out:
> > +=09=09if (ret !=3D len) {
> > +=09=09=09pos +=3D ret;
> > +=09=09=09req->cqe->result.u32 =3D cpu_to_le32(id);
> > +=09=09=09nvmet_req_complete(req, ret < 0 ?
> > +=09=09=09=09=09errno_to_nvme_status(req, ret) :
> > +=09=09=09=09=09errno_to_nvme_status(req, -EIO));
>=20
> again plz don't add multiple nvmet_req_complete() calls
>

acked

> > +=09=09=09return;
> > +
> > +=09=09} else
> > +=09=09=09pos +=3D len;
> > +=09}
> > +
> > +=09nvmet_req_complete(req, 0);
> > +
> > +}
>=20
> wrt above comments consider following totally untested :-
>=20
> static void nvmet_file_copy_work(struct work_struct *w)
> {
>  =A0=A0=A0=A0=A0=A0=A0 struct nvmet_req *req =3D container_of(w, struct n=
vmet_req, f.work);
>  =A0=A0=A0=A0=A0=A0=A0 int nr_range =3D req->cmd->copy.nr_range + 1;
>  =A0=A0=A0=A0=A0=A0=A0 u16 status =3D 0;
>  =A0=A0=A0=A0=A0=A0=A0 int src, id;
>  =A0=A0=A0=A0=A0=A0=A0 ssize_t ret;
>  =A0=A0=A0=A0=A0=A0=A0 size_t len;
>  =A0=A0=A0=A0=A0=A0=A0 loff_t pos;
>=20
>  =A0=A0=A0=A0=A0=A0=A0 pos =3D le64_to_cpu(req->cmd->copy.sdlba) << req->=
ns->blksize_shift;
>  =A0=A0=A0=A0=A0=A0=A0 if (unlikely(pos + req->transfer_len > req->ns->si=
ze)) {
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 nvmet_req_complete(req, er=
rno_to_nvme_status(req,=20
> -ENOSPC));
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return;
>  =A0=A0=A0=A0=A0=A0=A0 }
>=20
>  =A0=A0=A0=A0=A0=A0=A0 for (id =3D 0 ; id < nr_range; id++) {
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct nvme_copy_range ran=
ge;
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 status =3D nvmet_copy_from=
_sgl(req, id * sizeof(range),=20
> &range,
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sizeof(range));
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (status)
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 go=
to out;
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 src =3D (le64_to_cpu(range=
.slba) <<=20
> (req->ns->blksize_shift));
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 len =3D (le16_to_cpu(range=
.nlb) + 1) <<=20
> (req->ns->blksize_shift);
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ret =3D vfs_copy_file_rang=
e(req->ns->file, src,=20
> req->ns->file,
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pos, len, 0);
>=20
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if (ret !=3D len) {
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 re=
q->cqe->result.u32 =3D cpu_to_le32(id);
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 if=
 (ret < 0)
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 status =3D errno_to_nvme_status(req, ret);
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 el=
se
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 status =3D errno_to_nvme_status(req, -EIO);
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 go=
to out;
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>  =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pos +=3D ret;
>  =A0=A0=A0=A0=A0=A0=A0 }
> out:
>  =A0=A0=A0=A0=A0=A0=A0 nvmet_req_complete(req, status);
> }
>=20
>

Thanks for snippet will update this in next version.
--
Nitesh Shetty

------d4EnuX4PxHJ3dMseTbYmBkzD7TFyGjCVpggVcmKL0qRf9gu2=_43cbf_
Content-Type: text/plain; charset="utf-8"


------d4EnuX4PxHJ3dMseTbYmBkzD7TFyGjCVpggVcmKL0qRf9gu2=_43cbf_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------d4EnuX4PxHJ3dMseTbYmBkzD7TFyGjCVpggVcmKL0qRf9gu2=_43cbf_--

