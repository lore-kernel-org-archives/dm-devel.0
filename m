Return-Path: <SRS0=IN2R=QG=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C39FC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 16:22:51 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C3D5F6124B
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 16:22:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C3D5F6124B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=acm.org
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-vz_QpwkFNDiwg_NcSv88WA-1; Fri, 19 Nov 2021 11:22:45 -0500
X-MC-Unique: vz_QpwkFNDiwg_NcSv88WA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDF6C1006AA2;
	Fri, 19 Nov 2021 16:22:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 161FC77E26;
	Fri, 19 Nov 2021 16:22:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 08EE71832E88;
	Fri, 19 Nov 2021 16:22:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AJGLUt7024578 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Nov 2021 11:21:30 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6CE594010FDD; Fri, 19 Nov 2021 16:21:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 67D794010E8A
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 16:21:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D859181E060
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 16:21:30 +0000 (UTC)
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com
	[209.85.216.53]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-479-BlAFn3BXOe-2rOlwQVrAPQ-1; Fri, 19 Nov 2021 11:21:26 -0500
X-MC-Unique: BlAFn3BXOe-2rOlwQVrAPQ-1
Received: by mail-pj1-f53.google.com with SMTP id
	n15-20020a17090a160f00b001a75089daa3so11385718pja.1; 
	Fri, 19 Nov 2021 08:21:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=1e100.net; s=20210112;
	h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
	:content-language:to:cc:references:from:in-reply-to
	:content-transfer-encoding;
	bh=dYLRPwJpMIma+7I/gXS8Fe5+Xg8Jtu68cLUUk/7i+NA=;
	b=bfNBstXoQ4CMeXIDnNoGJa/4ekf273SaMzH7XCGG1p5xuPbf79xPW8Ll9hnZ+kCpVb
	ScDJoGi4tab2CQcQ2N5jgpMdQl8VPWnLmOvDqcsNbAP9D1poVSkcPn2bQz8ejIknOrt6
	H4V87+HlUoe6GQDMy+jirhYPBpJysLeP3L8+aNV9IeKyMIIKLeHUicOZc6Z9wqLgk0Ee
	IF+LuFxPtwfXz7muVfXnsrenQpiWBXRtt/77lgRPSj1pzxLZmv9LlSfUhXEpxXEUxzVa
	pVMxjl/N6y/uGwqkxgzu7uD/doBpFzuDYjcwYzowuLs3wM+QWEXSUjkGzXhGqZc8/Gom
	zHdA==
X-Gm-Message-State: AOAM53398UozALHPGbFEeFOgxNXvJ5ufRGTHIplHGtp5eAp4k3ltgxAf
	RwGNxkyObJrbFMz7/VYzAwQ=
X-Google-Smtp-Source: ABdhPJw16jjqfIprCHt2mG+Ksck30kqntK4sVEg0T0pyn+4kYe1d4XjIzZ1UNiSmcyxOlOBtUI890Q==
X-Received: by 2002:a17:90a:f00e:: with SMTP id
	bt14mr927761pjb.219.1637338884999; 
	Fri, 19 Nov 2021 08:21:24 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd?
	([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
	by smtp.gmail.com with ESMTPSA id j1sm172775pfu.47.2021.11.19.08.21.23
	(version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
	Fri, 19 Nov 2021 08:21:24 -0800 (PST)
Message-ID: <bbe942b4-3239-6c54-2e16-431ac8056afa@acm.org>
Date: Fri, 19 Nov 2021 08:21:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
	Thunderbird/91.3.0
To: Kanchan Joshi <joshiiitr@gmail.com>, =?UTF-8?Q?Javier_Gonz=c3=a1lez?=
	<javier@javigon.com>
References: <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
	<c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
	<20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
	<fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
	<20211008064925.oyjxbmngghr2yovr@mpHalley.local>
	<2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
	<20211029081447.ativv64dofpqq22m@ArmHalley.local>
	<20211103192700.clqzvvillfnml2nu@mpHalley-2>
	<20211116134324.hbs3tp5proxootd7@ArmHalley.localdomain>
	<CA+1E3rJRT+89OCyqRtb5BFbez0BfkKvCGijd=nObMEB3_v6MyA@mail.gmail.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CA+1E3rJRT+89OCyqRtb5BFbez0BfkKvCGijd=nObMEB3_v6MyA@mail.gmail.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-loop: dm-devel@redhat.com
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
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
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"

On 11/19/21 02:47, Kanchan Joshi wrote:
> Given the multitude of things accumulated on this topic, Martin
> suggested to have a table/matrix.
> Some of those should go in the initial patchset, and the remaining are
> to be staged for subsequent work.
> Here is the attempt to split the stuff into two buckets. Please change
> if something needs to be changed below.
> 
> 1. Driver
> *********
> Initial: NVMe Copy command (single NS)
> Subsequent: Multi NS copy, XCopy/Token-based Copy
> 
> 2. Block layer
> **************
> Initial:
> - Block-generic copy (REQ_OP_COPY), with interface accommodating two block-devs
> - Emulation, when offload is natively absent
> - DM support (at least dm-linear)
> 
> 3. User-interface
> *****************
> Initial: new ioctl or io_uring opcode
> 
> 4. In-kernel user
> ******************
> Initial: at least one user
> - dm-kcopyd user (e.g. dm-clone), or FS requiring GC (F2FS/Btrfs)
> 
> Subsequent:
> - copy_file_range

Integrity support and inline encryption support are missing from the above
overview. Both are supported by the block layer. See also block/blk-integrity.c
and include/linux/blk-crypto.h. I'm not claiming that these should be supported
in the first version but I think it would be good to add these to the above
overview.

Thanks,

Bart.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

