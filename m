Return-Path: <SRS0=qylv=OV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A80C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  1 Oct 2021 06:25:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 9E81161A57
	for <dm-devel@archiver.kernel.org>; Fri,  1 Oct 2021 06:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9E81161A57
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=samsung.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-igKDDU1_PNSmcVUuadMYgg-1; Fri, 01 Oct 2021 02:25:03 -0400
X-MC-Unique: igKDDU1_PNSmcVUuadMYgg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F2BC8010ED;
	Fri,  1 Oct 2021 06:24:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FAED5C1CF;
	Fri,  1 Oct 2021 06:24:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 808031803B30;
	Fri,  1 Oct 2021 06:24:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18U9rMJ8011332 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 30 Sep 2021 05:53:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id E9DFB10E60F0; Thu, 30 Sep 2021 09:53:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E507210E60ED
	for <dm-devel@redhat.com>; Thu, 30 Sep 2021 09:53:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D6D3800B26
	for <dm-devel@redhat.com>; Thu, 30 Sep 2021 09:53:19 +0000 (UTC)
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com
	[210.118.77.11]) (Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-6-YJpm2Bl8P4ydDzdkKh2HeA-1; Thu, 30 Sep 2021 05:53:17 -0400
X-MC-Unique: YJpm2Bl8P4ydDzdkKh2HeA-1
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id
	20210930095315euoutp01f7f0c45edc62df49cb8d19141675e6a0~pkNexe0-81056210562euoutp01J
	for <dm-devel@redhat.com>; Thu, 30 Sep 2021 09:53:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com
	20210930095315euoutp01f7f0c45edc62df49cb8d19141675e6a0~pkNexe0-81056210562euoutp01J
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTP id
	20210930095315eucas1p242b75713efbe09654512e314cb32f1e2~pkNeMkA8A1821518215eucas1p2E;
	Thu, 30 Sep 2021 09:53:15 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
	eusmges2new.samsung.com (EUCPMTA) with SMTP id 5B.EC.42068.B0985516;
	Thu, 30 Sep 2021 10:53:15 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20210930095314eucas1p10f56a3c7bc3cc167d93b3bd472c6852a~pkNdq_OAy1563315633eucas1p1X;
	Thu, 30 Sep 2021 09:53:14 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
	eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20210930095314eusmtrp2613aace3fff86eb43febc14d1c8711da~pkNdp4irE0109501095eusmtrp2p;
	Thu, 30 Sep 2021 09:53:14 +0000 (GMT)
X-AuditID: cbfec7f4-c89ff7000002a454-73-6155890b83b1
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
	eusmgms2.samsung.com (EUCPMTA) with SMTP id 5B.9B.20981.A0985516;
	Thu, 30 Sep 2021 10:53:14 +0100 (BST)
Received: from CAMSVWEXC02.scsc.local (unknown [106.1.227.72]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20210930095314eusmtip1eb040877616c6f8f18287fae83016cfe~pkNdeTsf-2640426404eusmtip1J;
	Thu, 30 Sep 2021 09:53:14 +0000 (GMT)
Received: from localhost (106.210.248.142) by CAMSVWEXC02.scsc.local
	(2002:6a01:e348::6a01:e348) with Microsoft SMTP Server (TLS) id
	15.0.1497.2; Thu, 30 Sep 2021 10:53:13 +0100
Date: Thu, 30 Sep 2021 11:53:12 +0200
From: Javier =?utf-8?B?R29uesOhbGV6?= <javier.gonz@samsung.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Message-ID: <20210930095312.jeipuaxzyyhd5e6e@mpHalley.local>
MIME-Version: 1.0
In-Reply-To: <c1b0f954-0728-e6ab-73ab-7b466a7d2eb7@nvidia.com>
X-Originating-IP: [106.210.248.142]
X-ClientProxiedBy: CAMSVWEXC01.scsc.local (2002:6a01:e347::6a01:e347) To
	CAMSVWEXC02.scsc.local (2002:6a01:e348::6a01:e348)
X-Brightmail-Tracker: H4sIAAAAAAAAA01SbUxTZxjde2+5vVTKLpXZN+LYVseyOAfqyPKyGXEfcZeI23SabN0yVuSm
	MsvH+iGicXSAswVaZyVDqkZkSoUqYvloG2w3MSvZAAdokRWpIOAI1arYJTIqjvbq5r9zznNO
	nuckD4kL9hKLyexcJSPPlchEBI/T5pr54/UF2i2SFY7jccg8vJ9AP96dwZFxyMdBdy6MRSCH
	/3AEGrM8wtD5WgOG6s2/YuhhmRdDho4BgBye19CxugkuKr9qI5DT58CRqXMOQwc0bgxdMgYJ
	dNHr5iBzEKH6mxia+vnLtc/Rl6+spw+U+Ln05R4VbWnQEnTziSL64KAJ0O1/qgn60HSAoK92
	WzFaV+In6HsTHg7dNqrj0nec7nlv1276viWe3vdLOfYxJeatzmJk2TsYedKar3jbWl3OiPx/
	eDsnK6YINWghy0AkCalkaBnz4WWARwqoUwCab13AWBIAUGN1RbDkPoD9pdeJJ5Hzdh0ewgLK
	BODha/H/mRp79ARLWgEc8VXPu0iSQyXAYl1UKEBQqbC/zhMOx1KJ0O0Z5Ib8ONUUCS21TeEN
	C6k0aGvaj4WyfGo1tHelh2Q+FQN/qx7nhDBOvQW1d4sjQhacioOmuXCdSGoNdDYPhWVILYWm
	qg3syXvg7y2ecDFIHeXBYY2Hww7eh0fagxiLF8KpzhYui5fAR/ZjjwMlAHafvoKzpALAoOEU
	YDe8DfXdMjbwDrRWjuKsHA0Hb8ewZ0ZDQ1vVY5kPNd8LWPcr0FbcCn4AS41PFTM+Vcz4f7Ea
	gDcAIaNS5EgZxapcpiBRIclRqHKliVvzcixg/lO75joDNmCaupfYATASdABI4qJY/gPhJxIB
	P0tSuIuR52XIVTJG0QHiSI5IyM9sOZ0hoKQSJbOdYfIZ+ZMpRkYuVmPVltTbn93ocy7ftFyZ
	VhjwoHdrHu5t1g8kyL3lMuwLoXDVqCvpTKo/s3K4RjdjbEwv7ak913dycqgdP2e3wudNM9KR
	zqzZa3vyQY6qdPyGdol3QjuR8upG8YdvBn/627e1oEH5edQ3ydJAyspNjUeTvhuaFvQd3+5f
	+8Eu66KXzOsq+9cpDC/ogC3rbCPmtd+MzetNcWRO+3e/8bJwB/h0xYP0OniCyfi2eCzZLD47
	vq+nUCM1iHe6lAl5Fw/pmy+VWjdsNtQXqYvU721ZZrxe0d2bPbBo8zODvQ3utIS/XjxzUBRz
	sv1WfupkdEm8umrkI//XUbPCjQXPxvjFfQv0I7MijmKbZOUyXK6Q/AvpltwAGAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsVy+t/xu7pcnaGJBkt3GVisvtvPZjHtw09m
	i1m3X7NYvD/4mNVi77vZrBaPN/1nstizaBKTxcrVR5ks/nbdY7KYdOgao8XeW9oW85c9Zbfo
	vr6DzWLf673MFsuP/2OymNhxlcni3Kw/bBaH711lsVj9x8Ji5TMmi1f74xxEPS5f8faY2PyO
	3ePy2VKPTas62Tw2L6n3mHxjOaPH7psNbB4zPn1h87h+ZjuTR2/zOzaPj09vsXhse9jL7vF+
	31Wg2tPVHp83yXm0H+hmChCI0rMpyi8tSVXIyC8usVWKNrQw0jO0tNAzMrHUMzQ2j7UyMlXS
	t7NJSc3JLEst0rdL0MvYemwfa8EvrooXPa/YGhi3cHQxcnJICJhI7NnZywxiCwksZZT4/dYe
	Ii4j8enKR3YIW1jiz7Uuti5GLqCaj4wSq27dYYZwtjJKdG+ZwtLFyMHBIqAq0dTLA9LAJmAv
	cWnZLbChIgJ6Eldv3WAHqWcW2MApsWnRBjaQhLCAp8SODf1MIL28AjYSO0/7QMz8zSSx+tt9
	sGZeAUGJkzOfsIDYzAIWEjPnn2cEqWcWkJZY/g/sAU4BO4l9m2+zgoQlBJQllk/3hbi5VuLz
	32eMExiFZyEZNAvJoFkIgxYwMq9iFEktLc5Nzy020itOzC0uzUvXS87P3cQITCzbjv3csoNx
	5auPeocYmTgYDzFKcDArifD+EA9OFOJNSaysSi3Kjy8qzUktPsRoCgyIicxSosn5wNSWVxJv
	aGZgamhiZmlgamlmrCTOa3JkTbyQQHpiSWp2ampBahFMHxMHp1QDk0zi7xmLNk5zy1/9ae0O
	00i33yzHmpesEmnaGrYvcq3aW4E332dm7jfef//ew9ffphrq+M1W25A/a4POvyVmL8WnXgqr
	lli9ofro/Ul26x26pnS9Cik7kGozK6bz890nllnTLktPDdqbYjnXJnRH/K6pTJdUPs37lRZr
	r+pumJqQHdAxL33CqzM9UreblCSWmqT1nLthtL1a8L6T+Gwmu9KQ+feVYnfd2Rk+JXHBzMSk
	BbNT//76vj3Or/X5h3UrNU/HmbRduHrt2y31e+qvJ/b/CBf24p5gKxg8+W7+m4XshoKbxI1F
	YkM0vqS21Lf+CuwOf3D81Lap8gx30xY777cMPn15ms30JE9jB6nT658psRRnJBpqMRcVJwIA
	sh+3PrUDAAA=
X-CMS-MailID: 20210930095314eucas1p10f56a3c7bc3cc167d93b3bd472c6852a
X-Msg-Generator: CA
X-RootMTR: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c1b0f954-0728-e6ab-73ab-7b466a7d2eb7@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 01 Oct 2021 02:24:53 -0400
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"rwheeler@redhat.com" <rwheeler@redhat.com>
Subject: Re: [dm-devel] [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy
	Offload
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 30.09.2021 09:43, Chaitanya Kulkarni wrote:
>Javier,
>
>>
>> Hi all,
>>
>> Since we are not going to be able to talk about this at LSF/MM, a few of
>> us thought about holding a dedicated virtual discussion about Copy
>> Offload. I believe we can use Chaitanya's thread as a start. Given the
>> current state of the current patches, I would propose that we focus on
>> the next step to get the minimal patchset that can go upstream so that
>> we can build from there.
>>
>
>I agree with having a call as it has been two years I'm trying to have
>this discussion.
>
>Before we setup a call, please summarize following here :-
>
>1. Exactly what work has been done so far.
>2. What kind of feedback you got.
>3. What are the exact blockers/objections.
>4. Potential ways of moving forward.
>
>Although this all information is present in the mailing archives it is
>scattered all over the places, looking at the long CC list above we need
>to get the everyone on the same page in order to have a productive call.
>
>Once we have above discussion we can setup a precise agenda and assign
>slots.

Sounds reasonable. Let me collect all this information and post it here.
I will maintain a list of people that has showed interest on joining.
For now:

   - Martin
   - Johannes
   - Fred
   - Chaitanya
   - Adam
   - Kanchan
   - Selva
   - Nitesh
   - Javier

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

