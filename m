Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 145FAC4332F
	for <dm-devel@archiver.kernel.org>; Wed, 23 Nov 2022 13:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1669211383;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=Yq9RWza/RBgmW88F2WQCDSlp+jsW9S8P2QBEg4VdSjA=;
	b=iY4x1zPcXjHjQzgJjEGIemYeDgtWrQYcfXD+WeQKKfah3sz3DRFPilVjgGHQJXm9coG24V
	a/Ym+OW//vSXT1BjvIulFQQrmcGrKbz3Y5oyQaCYDR1Ya3SNNj7Q1Gp7qJsnB4YBNOedX1
	8JO8TErwvTfvp7IVHBWGtFgzq+wsglU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-4UhNmdPlOHSYpaYYvheOmg-1; Wed, 23 Nov 2022 08:49:40 -0500
X-MC-Unique: 4UhNmdPlOHSYpaYYvheOmg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 70276811E87;
	Wed, 23 Nov 2022 13:49:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0E49E1121320;
	Wed, 23 Nov 2022 13:49:38 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A50831946589;
	Wed, 23 Nov 2022 13:49:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 87AE11946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 23 Nov 2022 12:13:52 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6BB0D4EA55; Wed, 23 Nov 2022 12:13:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 631FC4EA4A
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 12:13:52 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F9CF85A5B6
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 12:13:52 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-626-nuwzhFKiMpOng42rJC020w-1; Wed, 23 Nov 2022 07:13:50 -0500
X-MC-Unique: nuwzhFKiMpOng42rJC020w-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20221123121347epoutp0148a8a19e4070bdd1c8a566b0bfb9dc26~qNayrmJfx1428414284epoutp01Y
 for <dm-devel@redhat.com>; Wed, 23 Nov 2022 12:13:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20221123121347epoutp0148a8a19e4070bdd1c8a566b0bfb9dc26~qNayrmJfx1428414284epoutp01Y
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p2.samsung.com (KnoxPortal) with ESMTP id
 20221123121346epcas5p27e8a210b1d5d58d29f70054e9bcf62ab~qNaxiqq473009530095epcas5p2j;
 Wed, 23 Nov 2022 12:13:46 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4NHKm829xrz4x9Pp; Wed, 23 Nov
 2022 12:13:44 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 FF.35.39477.87E0E736; Wed, 23 Nov 2022 21:13:44 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20221123095047epcas5p1ae1143d6f36df2887dc6d0e89e0a3296~qLd75q69K2353123531epcas5p1I;
 Wed, 23 Nov 2022 09:50:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20221123095047epsmtrp27172fc6e6ab539e4aea9cb2292b33c37~qLd73Wqop0501205012epsmtrp2J;
 Wed, 23 Nov 2022 09:50:47 +0000 (GMT)
X-AuditID: b6c32a4a-007ff70000019a35-7b-637e0e78390c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 DD.3D.18644.7FCED736; Wed, 23 Nov 2022 18:50:47 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20221123095044epsmtip297accf117a7980fa5c8ce38286643dea~qLd48Wj5X3271432714epsmtip2g;
 Wed, 23 Nov 2022 09:50:44 +0000 (GMT)
Date: Wed, 23 Nov 2022 15:09:24 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Guixin Liu <kanie@linux.alibaba.com>
Message-ID: <20221123093924.GA31595@test-zns>
MIME-Version: 1.0
In-Reply-To: <482586a3-f45d-a17b-7630-341fb0e1ee96@linux.alibaba.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHPfeW2wsbeq0gh7IhK1kmKEgR6mWDaXgsV+cMGWPLhIU17V1h
 wG1pCyoSqAOygfISyVwxDtzYeBjIkPGuA4TxkIeIFAthQARlGkFAJo4Ia7ll4b/P73u+3/x+
 53dycJRXzOXjUYyaVjLiGAFmxam95eLidnp7ssTj0eTrZFXPnyj5Te4rlKwYz8HI1b4BlNTN
 FVqQhpYGhCyr6EDIpuIFhOxYf4qRU89HOWR+ZjcgL7bpATkzrEVI3eg+slnXzSGHGq9g5I+/
 zHDJvM4bFmT99DlALpWkccnKJ/McsmvUgRx41WlxxI7STvRhVIN2nEsN/PUbhxrqi6eqyzOM
 0pQPdePnFKrJoMGorNQ5o5I+YUHN3xzGqOyackAtVTtS37acR6jq6adI8I6T0b6RtFhKK51o
 RiKXRjEyP8GHIREBEd4iD6Gb0Ic8JHBixLG0nyDweLDbB1Exxh0InBLEMfFGKVisUgkOvO+r
 lMeraadIuUrtJ6AV0hiFl8JdJY5VxTMyd4ZWvyv08PD0Nhq/jI68O/aa4lLo6f6Sh1wNuBuQ
 CSxxSHjBMX0NZmIe0QTgSAk/E1gZeRHA+cIZlC2WAGwoqkM3E2Wld8wHjQCOaQswtngI4My1
 rg0Xh3gbjuU/52QCHMeIffD2Om6SbYi9cDy/BpgYJTQcOGMgTJZdxCfw73lbE1oTbvDqoNTk
 sCZ2wu4fpjkmtiSC4PLszY1BbQln2FLbiZi6QuKWJczOegzY2QLhbF+qec5d8HFnDZdlPlya
 02Esn4Jll0oxNpwGoHZEaw4fhuk9OSg7WySs7Js0h9+EBT2VCKtvh1mr0wirW8P6q5vsDK9X
 FZkb2EP9i3NmpmC7/nuE3c+/AC5f60RywR7tlttpt/TTGheAEi6wqvEAK++Bqb8XoqzsAH9d
 w7c4igBWDuxphSpWRqu8FZ4Mfer/l5fIY6vBxl9xPVYPpiafubcBBAdtAOKowMY65WiShGct
 FZ9JpJXyCGV8DK1qA97GV8tD+bYSufGzMeoIoZePh5dIJPLyOSgSCuysf7rsKuERMrGajqZp
 Ba3czCG4JV+D5ON583k7HrSHOOa2Lob1+nc12fFs9LXyunRDRlza7Fcfl0gbo3bvXnEsuHN2
 wv+YaLr3xHj/R7ojsn8W6rIuM4lnQr2XmwPVDfHLDFK68/OS9TWvT5OtYven9dTPnUiPG3w0
 CJmI4/RbreEuvtHV94P7p7QvrjhHC18OF2gk4W6a1ncCPiseSvsuaCC4ZlQhLU6VjuQ53v7D
 IagqATjLDh+9MMp9GZZk9UYNbLyXUbBt0X/FYK9PCS0bvNiBZ/PutW+zwsLcdE+4SysVYfJK
 /jPPr/c2dyYlD/kvHkQS9xsSg052zCTg2eFrvbEeDgtxORfOavTvGe4f+iKE+2D1elW2gKOK
 FAtdUaVK/B/Hwv8RtAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0hTYRjG+c45OzsuVqeZ9amZNdHCappZfVlUEtrpBhVBJQtbejDJTdtm
 96HZXVlqEtY0s6x2EQvNlmWWzNSZTO1ioaYmzTK7LNEulHM5R+R/P57n4cf7x0vhggHCi4qX
 KVm5TJIgJHmEsUboO//nZ1VM8Kme6ej20zocpWXZcVTcmUmiP5ZmHFV9zeOgtur7GNIX12Ko
 8uoAhmodX0jUM9ROoJz0BoDOm14B1NuqwVBV+1z0sKqBQC8e5JPoys1eLsquv8NBFdZjAA3e
 OMFFtz7ZCGRu90bN9nrOqmmMpttCMvc1nVymuauUYF5Ykpkyw9nRqGcpc+d6ClPZlkoy6uNf
 R5OT3RzG9qiVZM6VGwAzWDaDOV2dgTFl1i/YpklRvOWxbEL8flYetGIXb88bg5mTZNxy8KXW
 QaaCrPB04EZBOhTqdS14OuBRAroCwDrTZ46r8IQ37U9wF7tD/cgHrmtkBTB3UEc4C4L2hx05
 Q6NMUSQ9FzY6KGc8hZ4DO3PKgXOP02kELHjVQTo37vRW+NHm4UQ+PR8WPIt1KX8DaCotGVPy
 6cmw4ZJ1jHF6NhwueI479zjtDbUjlCv2hcfv5o2d5kZHwO99j0gne9B+sNpYj2UBgWacSTPO
 pPlv0owzFQLCADzZJIU0TqpYkBQiYw+IFBKpIlkWJ4pJlJaBsa8IDKwADw3fRCaAUcAEIIUL
 p/BT1h6NEfBjJYcOs/LEaHlyAqswAW+KEE7jt6Q3RAvoOImS3cuySaz8X4tRbl6pmIr1DVE3
 RQWEXAw7pszEbRFeomHVTBXy2Tn8qzhYatthXZJGLF+zTuXRqi3UbpzV1M095U+UXkm9bG+a
 +KYxuGbZohJvpSMxck5F5+aol+sziiI9JxSNGIOK3y0Wv450dJ9LuOavU5mnrs8/UQSG3529
 Wz5gCY/ok9Fs9vk14l0pOn182GPK56RiRREUH9nS1dWvnrcXiH9sz13cMWQKXclp7Bf52Un7
 79DCy+tW79a9X7iv7m3AUveW1YE2bUaT+cKtAOGSaIfSU+23VRmmvvcgv8a4UXnIN/4Mg1p8
 Tmda7crgtpCSIZGdU1my7XWz/rHFzNsQHnngmti/pjdOSCj2SBYE4nKF5C88pAyphAMAAA==
X-CMS-MailID: 20221123095047epcas5p1ae1143d6f36df2887dc6d0e89e0a3296
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221123061031epcas5p3745558c2caffd2fd21d15feff00495e9
References: <20221123055827.26996-1-nj.shetty@samsung.com>
 <CGME20221123061031epcas5p3745558c2caffd2fd21d15feff00495e9@epcas5p3.samsung.com>
 <20221123055827.26996-7-nj.shetty@samsung.com>
 <482586a3-f45d-a17b-7630-341fb0e1ee96@linux.alibaba.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Wed, 23 Nov 2022 13:14:48 +0000
Subject: Re: [dm-devel] [PATCH v5 06/10] nvmet: add copy command support for
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
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com, hch@lst.de,
 agk@redhat.com, naohiro.aota@wdc.com, sagi@grimberg.me, gost.dev@samsung.com,
 damien.lemoal@opensource.wdc.com, james.smart@broadcom.com,
 p.raghav@samsung.com, kch@nvidia.com, anuj20.g@samsung.com, snitzer@kernel.org,
 linux-block@vger.kernel.org, viro@zeniv.linux.org.uk, kbusch@kernel.org,
 axboe@kernel.dk, joshi.k@samsung.com, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jth@kernel.org, nitheshshetty@gmail.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_666e9_"

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_666e9_
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 23, 2022 at 04:17:41PM +0800, Guixin Liu wrote:
>=20
> =E5=9C=A8 2022/11/23 13:58, Nitesh Shetty =E5=86=99=E9=81=93:
> > Add support for handling target command on target.
> > For bdev-ns we call into blkdev_issue_copy, which the block layer
> > completes by a offloaded copy request to backend bdev or by emulating t=
he
> > request.
> >=20
> > For file-ns we call vfs_copy_file_range to service our request.
> >=20
> > Currently target always shows copy capability by setting
> > NVME_CTRL_ONCS_COPY in controller ONCS.
> >=20
> > Signed-off-by: Nitesh Shetty<nj.shetty@samsung.com>
> > Signed-off-by: Anuj Gupta<anuj20.g@samsung.com>
> > ---
> >   drivers/nvme/target/admin-cmd.c   |  9 +++-
> >   drivers/nvme/target/io-cmd-bdev.c | 79 ++++++++++++++++++++++++++++++=
+
> >   drivers/nvme/target/io-cmd-file.c | 51 ++++++++++++++++++++
> >   drivers/nvme/target/loop.c        |  6 +++
> >   drivers/nvme/target/nvmet.h       |  2 +
> >   5 files changed, 145 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admi=
n-cmd.c
> > index c8a061ce3ee5..5ae509ff4b19 100644
> > --- a/drivers/nvme/target/admin-cmd.c
> > +++ b/drivers/nvme/target/admin-cmd.c
> > @@ -431,8 +431,7 @@ static void nvmet_execute_identify_ctrl(struct nvme=
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
> > @@ -534,6 +533,12 @@ static void nvmet_execute_identify_ns(struct nvmet=
_req *req)
> >   =09if (req->ns->bdev)
> >   =09=09nvmet_bdev_set_limits(req->ns->bdev, id);
> > +=09else {
> > +=09=09id->msrc =3D (u8)to0based(BIO_MAX_VECS - 1);
> > +=09=09id->mssrl =3D cpu_to_le16(BIO_MAX_VECS <<
> > +=09=09=09=09(PAGE_SHIFT - SECTOR_SHIFT));
> > +=09=09id->mcl =3D cpu_to_le32(le16_to_cpu(id->mssrl));
> > +=09}
> >   =09/*
> >   =09 * We just provide a single LBA format that matches what the
> > diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io=
-cmd-bdev.c
> > index c2d6cea0236b..01f0160125fb 100644
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
>=20
> Based on my understanding of the NVMe protocol 2.0,=C2=A0 the mssrl is th=
e max
> length per single range entry,
>=20
> the mcl is the total max copy length in one copy command, may I ask why m=
cl
> =3D msssrl? not mcl =3D mssrl * msrc?
>=20
> Best Regards,
>=20
> Guixin Liu
>

You are right, as per NVMe spec, mcl >=3D mssrl. Since we decided to make
copy offload generic for NVMe/Xcopy/copy across namespaces and all, we went
with 2 bio/bdev design, which is compatible with device mapper.
So effectively we are using 1 range(msrc), when using only 1 range, I
feel it makes sense to use one of the limits, so went with mssrl.

Thanks,
Nitesh

> >   }
> >   void nvmet_bdev_ns_disable(struct nvmet_ns *ns)
> > @@ -184,6 +197,23 @@ static void nvmet_bio_done(struct bio *bio)
> >   =09nvmet_req_bio_put(req, bio);
> >   }
> > +static void nvmet_bdev_copy_end_io(void *private, int status)
> > +{
> > +=09struct nvmet_req *req =3D (struct nvmet_req *)private;
> > +=09int id;
> > +
> > +=09if (status) {
> > +=09=09for (id =3D 0 ; id < req->nr_range; id++) {
> > +=09=09=09if (req->ranges[id].len !=3D req->ranges[id].comp_len) {
> > +=09=09=09=09req->cqe->result.u32 =3D cpu_to_le32(id);
> > +=09=09=09=09break;
> > +=09=09=09}
> > +=09=09}
> > +=09}
> > +=09kfree(req->ranges);
> > +=09nvmet_req_complete(req, errno_to_nvme_status(req, status));
> > +}
> > +
> >   #ifdef CONFIG_BLK_DEV_INTEGRITY
> >   static int nvmet_bdev_alloc_bip(struct nvmet_req *req, struct bio *bi=
o,
> >   =09=09=09=09struct sg_mapping_iter *miter)
> > @@ -450,6 +480,51 @@ static void nvmet_bdev_execute_write_zeroes(struct=
 nvmet_req *req)
> >   =09}
> >   }
> > +static void nvmet_bdev_execute_copy(struct nvmet_req *req)
> > +{
> > +=09struct nvme_copy_range range;
> > +=09struct range_entry *ranges;
> > +=09struct nvme_command *cmnd =3D req->cmd;
> > +=09sector_t dest, dest_off =3D 0;
> > +=09int ret, id, nr_range;
> > +
> > +=09nr_range =3D cmnd->copy.nr_range + 1;
> > +=09dest =3D le64_to_cpu(cmnd->copy.sdlba) << req->ns->blksize_shift;
> > +=09ranges =3D kmalloc_array(nr_range, sizeof(*ranges), GFP_KERNEL);
> > +
> > +=09for (id =3D 0 ; id < nr_range; id++) {
> > +=09=09ret =3D nvmet_copy_from_sgl(req, id * sizeof(range),
> > +=09=09=09=09=09&range, sizeof(range));
> > +=09=09if (ret)
> > +=09=09=09goto out;
> > +
> > +=09=09ranges[id].dst =3D dest + dest_off;
> > +=09=09ranges[id].src =3D le64_to_cpu(range.slba) <<
> > +=09=09=09=09=09req->ns->blksize_shift;
> > +=09=09ranges[id].len =3D (le16_to_cpu(range.nlb) + 1) <<
> > +=09=09=09=09=09req->ns->blksize_shift;
> > +=09=09ranges[id].comp_len =3D 0;
> > +=09=09dest_off +=3D ranges[id].len;
> > +=09}
> > +=09req->ranges =3D ranges;
> > +=09req->nr_range =3D nr_range;
> > +=09ret =3D blkdev_issue_copy(req->ns->bdev, req->ns->bdev, ranges, nr_=
range,
> > +=09=09=09nvmet_bdev_copy_end_io, (void *)req, GFP_KERNEL);
> > +=09if (ret) {
> > +=09=09for (id =3D 0 ; id < nr_range; id++) {
> > +=09=09=09if (ranges[id].len !=3D ranges[id].comp_len) {
> > +=09=09=09=09req->cqe->result.u32 =3D cpu_to_le32(id);
> > +=09=09=09=09break;
> > +=09=09=09}
> > +=09=09}
> > +=09=09goto out;
> > +=09} else
> > +=09=09return;
> > +out:
> > +=09kfree(ranges);
> > +=09nvmet_req_complete(req, errno_to_nvme_status(req, ret));
> > +}
> > +
> >   u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
> >   {
> >   =09switch (req->cmd->common.opcode) {
> > @@ -468,6 +543,10 @@ u16 nvmet_bdev_parse_io_cmd(struct nvmet_req *req)
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
> > index 64b47e2a4633..a81d38796e17 100644
> > --- a/drivers/nvme/target/io-cmd-file.c
> > +++ b/drivers/nvme/target/io-cmd-file.c
> > @@ -338,6 +338,48 @@ static void nvmet_file_dsm_work(struct work_struct=
 *w)
> >   =09}
> >   }
> > +static void nvmet_file_copy_work(struct work_struct *w)
> > +{
> > +=09struct nvmet_req *req =3D container_of(w, struct nvmet_req, f.work)=
;
> > +=09int nr_range;
> > +=09loff_t pos;
> > +=09struct nvme_command *cmnd =3D req->cmd;
> > +=09int ret =3D 0, len =3D 0, src, id;
> > +
> > +=09nr_range =3D cmnd->copy.nr_range + 1;
> > +=09pos =3D le64_to_cpu(req->cmd->copy.sdlba) << req->ns->blksize_shift=
;
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
> > +out:
> > +=09=09if (ret !=3D len) {
> > +=09=09=09pos +=3D ret;
> > +=09=09=09req->cqe->result.u32 =3D cpu_to_le32(id);
> > +=09=09=09nvmet_req_complete(req, ret < 0 ?
> > +=09=09=09=09=09errno_to_nvme_status(req, ret) :
> > +=09=09=09=09=09errno_to_nvme_status(req, -EIO));
> > +=09=09=09return;
> > +
> > +=09=09} else
> > +=09=09=09pos +=3D len;
> > +}
> > +=09nvmet_req_complete(req, ret);
> > +
> > +}
> >   static void nvmet_file_execute_dsm(struct nvmet_req *req)
> >   {
> >   =09if (!nvmet_check_data_len_lte(req, nvmet_dsm_len(req)))
> > @@ -346,6 +388,12 @@ static void nvmet_file_execute_dsm(struct nvmet_re=
q *req)
> >   =09queue_work(nvmet_wq, &req->f.work);
> >   }
> > +static void nvmet_file_execute_copy(struct nvmet_req *req)
> > +{
> > +=09INIT_WORK(&req->f.work, nvmet_file_copy_work);
> > +=09queue_work(nvmet_wq, &req->f.work);
> > +}
> > +
> >   static void nvmet_file_write_zeroes_work(struct work_struct *w)
> >   {
> >   =09struct nvmet_req *req =3D container_of(w, struct nvmet_req, f.work=
);
> > @@ -392,6 +440,9 @@ u16 nvmet_file_parse_io_cmd(struct nvmet_req *req)
> >   =09case nvme_cmd_write_zeroes:
> >   =09=09req->execute =3D nvmet_file_execute_write_zeroes;
> >   =09=09return 0;
> > +=09case nvme_cmd_copy:
> > +=09=09req->execute =3D nvmet_file_execute_copy;
> > +=09=09return 0;
> >   =09default:
> >   =09=09return nvmet_report_invalid_opcode(req);
> >   =09}
> > diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
> > index b45fe3adf015..55802632b407 100644
> > --- a/drivers/nvme/target/loop.c
> > +++ b/drivers/nvme/target/loop.c
> > @@ -146,6 +146,12 @@ static blk_status_t nvme_loop_queue_rq(struct blk_=
mq_hw_ctx *hctx,
> >   =09=09return ret;
> >   =09blk_mq_start_request(req);
> > +=09if (unlikely((req->cmd_flags & REQ_COPY) &&
> > +=09=09=09=09(req_op(req) =3D=3D REQ_OP_READ))) {
> > +=09=09blk_mq_set_request_complete(req);
> > +=09=09blk_mq_end_request(req, BLK_STS_OK);
> > +=09=09return BLK_STS_OK;
> > +=09}
> >   =09iod->cmd.common.flags |=3D NVME_CMD_SGL_METABUF;
> >   =09iod->req.port =3D queue->ctrl->port;
> >   =09if (!nvmet_req_init(&iod->req, &queue->nvme_cq,
> > diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
> > index dfe3894205aa..3b4c7d2ee45d 100644
> > --- a/drivers/nvme/target/nvmet.h
> > +++ b/drivers/nvme/target/nvmet.h
> > @@ -391,6 +391,8 @@ struct nvmet_req {
> >   =09struct device=09=09*p2p_client;
> >   =09u16=09=09=09error_loc;
> >   =09u64=09=09=09error_slba;
> > +=09struct range_entry *ranges;
> > +=09unsigned int nr_range;
> >   };
> >   extern struct workqueue_struct *buffered_io_wq;

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_666e9_
Content-Type: text/plain; charset="utf-8"


------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_666e9_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------GsYAgckb8ZPIB7TqR4NYyp-jgnPv5c.LE-kW9H5hDU_d1TDU=_666e9_--

