Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40260C77B61
	for <dm-devel@archiver.kernel.org>; Thu, 30 Mar 2023 06:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1680157992;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=D4m/dXXKNBSTd80xvFXRk7ubwFBa7KNyD1i+5qBbkN0=;
	b=K1TtLLaUNaAHx8xEhNfanwu0cekAuaHF0R0c67Qgjffav+eeE4m60UmT97y1iIcQR0pg7Y
	ZKC6yVhjVy6vfpAbD4jnSQ9yTkx/IxOASvoFSN6AEideI7skTwJAcQBHA9jBqTwoduAuee
	jEEFc5wKmzXHmMglKtXaraNkhAbcOAg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-371-I-iUsVPqMb6M05-eIMHe_A-1; Thu, 30 Mar 2023 02:33:07 -0400
X-MC-Unique: I-iUsVPqMb6M05-eIMHe_A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BDB8D857FB9;
	Thu, 30 Mar 2023 06:33:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A88F1492B18;
	Thu, 30 Mar 2023 06:33:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 197CD19472DC;
	Thu, 30 Mar 2023 06:33:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 4FA17194658C
 for <dm-devel@listman.corp.redhat.com>; Wed, 29 Mar 2023 11:10:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2FA90492B01; Wed, 29 Mar 2023 11:10:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 271C5492B03
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 11:10:39 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C902F3C10C60
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 11:10:39 +0000 (UTC)
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-fAsA0rKENze8S14ixDWS9A-1; Wed, 29 Mar 2023 07:10:35 -0400
X-MC-Unique: fAsA0rKENze8S14ixDWS9A-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
 by mailout3.samsung.com (KnoxPortal) with ESMTP id
 20230329111032epoutp0367e23aee29e043620629660c34f6a210~Q31ioIjjo3195931959epoutp03Q
 for <dm-devel@redhat.com>; Wed, 29 Mar 2023 11:10:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com
 20230329111032epoutp0367e23aee29e043620629660c34f6a210~Q31ioIjjo3195931959epoutp03Q
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
 epcas5p4.samsung.com (KnoxPortal) with ESMTP id
 20230329111032epcas5p4d136e23b1114a6a012bd1dcdce095e8d~Q31iEcnFw1699116991epcas5p4P;
 Wed, 29 Mar 2023 11:10:32 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
 epsnrtp4.localdomain (Postfix) with ESMTP id 4PmkP23Ghsz4x9Q1; Wed, 29 Mar
 2023 11:10:30 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
 epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
 30.74.55678.6AC14246; Wed, 29 Mar 2023 20:10:30 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230329104226epcas5p1a6c8373304372ec2c02573ac59a7e8d8~Q3dAAFZeX0051700517epcas5p1L;
 Wed, 29 Mar 2023 10:42:26 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
 epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
 20230329104226epsmtrp142b1ba35c822a3a46a762710d3a53155~Q3c--A1i30671106711epsmtrp1c;
 Wed, 29 Mar 2023 10:42:26 +0000 (GMT)
X-AuditID: b6c32a4a-6a3ff7000000d97e-f4-64241ca6b704
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
 epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
 B4.0B.31821.21614246; Wed, 29 Mar 2023 19:42:26 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip1.samsung.com
 (KnoxPortal) with ESMTPA id
 20230329104223epsmtip1c86cdb99c232682a50f105b430b65e80~Q3c80kGNQ2021320213epsmtip1R;
 Wed, 29 Mar 2023 10:42:22 +0000 (GMT)
Date: Wed, 29 Mar 2023 16:11:42 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Message-ID: <20230329104142.GA11932@green5>
MIME-Version: 1.0
In-Reply-To: <e725768d-19f5-a78a-2b05-c0b189624fea@opensource.wdc.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xbdRTH87u3vS2Y6l0B91sZyMpDB8Ja1sLtAkIcwxsekcU5gwtCR69A
 gLbpw6FmjofoYOMxxCnVbMCAOVCYsCFQykiRUQqMRR4GtgFzJVPeA2WZBLBwi9l/n3PO9+S8
 ctgo91sWj50i11AquTSNj9kzmrv2e/vW7PWQCWqvvEw0mG+jRHbxOkrUPSjCiNmuZUBcXHqG
 EmsDgyhhWPiOSYx1tiJEe2UJQlyr60YIfcUThOjenMeIEuMoIKZHdAhhGPch2g29DGKo7XuM
 uFwzzSKMX+UgRIslCxD1s4sMwjTuTAyu9zBDd5NDw5GkbnIAI1t1D1jk4MTPDHJoQEs21uZh
 ZFPVGVI/lomRBTkLVkHuJJNc7BjByMIbtYBs6vuUXGl0JRst80jMS++nBiVTUhmlcqPkiQpZ
 ijwpmB/5TvzheHGAQOgrlBCBfDe5NJ0K5odFxfiGp6RZV8B3+0iaprW6YqRqNf/AG0EqhVZD
 uSUr1JpgPqWUpSlFSj+1NF2tlSf5ySnNIaFA4C+2ChNSkztyN1BlvjDj5sgVViYweeUDOzbE
 RXDueh6SD+zZXFwP4D+3h23GMoB3+6uZtLEC4NXrE8ydlDv9fbZAG4Bf3rrJog0LgH+PFm+r
 GLgnXDpXZWU2G8N9YN8me8vtiIvh/PlcxhajeA0TLt7fljvgx+DF4SnWFnOs8j9ulTFp3gV7
 yyzbejs8HP7Zt4BssRPuDjubexC6oQY7WN95nOYw+M05HUqzA5zpucGimQf/KvrCxqfgtdIf
 sK2eIf45gLrfdYAOhMBccxFKN5cCTUsbtgQX+LW5HqH9L8KCNYutMAe2XNphd/hjQzlG8x44
 +jTLxiQsXq+yLegZgJUPH4Ni8IruueF0z9Wj+XVYrl/GdNbdobgzvLrBpnE/bGg7UA6YtWAP
 pVSnJ1FqsdJfTp36/+KJivRGsP0i3hEt4OHUkp8RIGxgBJCN8h05a6N8GZcjk378CaVSxKu0
 aZTaCMTWW11AeU6JCuuPyTXxQpFEIAoICBBJDgYI+bs5rwb3JnLxJKmGSqUoJaXayUPYdrxM
 RDkoXo9KzZKYKo891herFQ4zH+TO3nUpFzafDq2Ouhfpqhh8z3ApPDb18MmGI8mqHO67C40V
 Gd4eVZxdKsOAZ8dy19m5gezQ0dDYJ79W+zadYMq0GZ5xhpCTjLWgOxGfOS5k/+vtuhl7hrs6
 L2EJIscTwjgtphOFb+/Lf1PgIivQT9+LDfQIv0DJSgrOjtknHA3sdz/qVejk8trIkcUa57hO
 jiI6rFnKdfY3dq/Ulf7GWY07dL+itqXt+Gr/o72rm2lPzTPc6DyvCVGHS4TxhcvRB0/zfPJK
 ois+nFvPlsSXDbeGTpkNvMn21kecEIeY0o5+zpSjGUnPMlne2vjlPPMnPkOdLBV6oyq19D/z
 ynCPqwQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWy7bCSnK6QmEqKwauvvBbrTx1jtmia8JfZ
 YvXdfjaL14c/MVpM+/CT2eL32fPMFnvfzWa1uHlgJ5PFnkWTmCxWrj7KZLF74Ucmi6P/37JZ
 TDp0jdHi6dVZTBZ7b2lb7Nl7ksXi8q45bBbzlz1ltzg0uZnJYseTRkaLda/fs1icuCVtcf7v
 cVYHcY/LV7w9Zt0/y+axc9Zddo/z9zayeFw+W+qxaVUnm8fmJfUeu282sHn0Nr8DKmi9z+rx
 ft9VNo++LasYPTafrvb4vEnOY9OTt0wB/FFcNimpOZllqUX6dglcGd1rTrAVHNer2PJ/GXsD
 4zyVLkZODgkBE4lzZ06zdjFycQgJ7GCU2PvsLCtEQlJi2d8jzBC2sMTKf8/ZIYoeMUrcfXQX
 rIhFQFXiQ/cSIJuDg01AW+L0fw6QsIiAqcTbnlYWEJtZYBWrxL1duiC2sECIxLQrD9hBbF6g
 8kf7Z0It/sko0TblHitEQlDi5MwnUM1aEjf+vWQCmc8sIC2x/B/YfE4BN4kXp98xgdiiAsoS
 B7YdZ5rAKDgLSfcsJN2zELoXMDKvYpRMLSjOTc8tNiwwykst1ytOzC0uzUvXS87P3cQIjn0t
 rR2Me1Z90DvEyMTBeIhRgoNZSYT39zWlFCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJ
 pCeWpGanphakFsFkmTg4pRqY1s3Qi+PIut/wauYp/2ftceuSPxhM/3RMgNvFySb3mYFUfvs+
 FjG+lmQOeWnn5+dlDy9Yzvj3aVvYgkcB28ReyDyXqwxmiuoXfZZfIOm0V0HuW69y+ler/W2H
 F9lm75515uT/BZuyrmtevBvF2V94MkrViTerPmjba86PmzN8Hy2Ya/1hA1vvj5K2eX5hX94v
 PGJx2POlyFPnicen2HwIa1njHnZe+4XAKqPupu3z2SsOLb1tdyCl+pSZxBFt7Zatx+V+501v
 kGjpuOh74HrNho4d5wvuZhb88fy5p0BI9OeGn2XH9jUlcFi9ZLulkBemqu/inLn16yPhgE6W
 udcLw51n3TrzPmi/aYjSBnVPJZbijERDLeai4kQARjFdhmwDAAA=
X-CMS-MailID: 20230329104226epcas5p1a6c8373304372ec2c02573ac59a7e8d8
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230327084216epcas5p3945507ecd94688c40c29195127ddc54d
References: <20230327084103.21601-1-anuj20.g@samsung.com>
 <CGME20230327084216epcas5p3945507ecd94688c40c29195127ddc54d@epcas5p3.samsung.com>
 <20230327084103.21601-2-anuj20.g@samsung.com>
 <e725768d-19f5-a78a-2b05-c0b189624fea@opensource.wdc.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 30 Mar 2023 06:32:57 +0000
Subject: Re: [dm-devel] [PATCH v8 1/9] block: Introduce queue limits for
 copy-offload support
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
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com,
 Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>,
 Sagi Grimberg <sagi@grimberg.me>, gost.dev@samsung.com,
 nitheshshetty@gmail.com, James Smart <james.smart@broadcom.com>,
 Chaitanya Kulkarni <kch@nvidia.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>,
 Christian Brauner <brauner@kernel.org>, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: samsung.com
Content-Type: multipart/mixed;
 boundary="----KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_118142_"

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_118142_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Mar 29, 2023 at 05:40:09PM +0900, Damien Le Moal wrote:
> On 3/27/23 17:40, Anuj Gupta wrote:
> > From: Nitesh Shetty <nj.shetty@samsung.com>
> > 
> > Add device limits as sysfs entries,
> >         - copy_offload (RW)
> >         - copy_max_bytes (RW)
> >         - copy_max_bytes_hw (RO)
> > 
> > Above limits help to split the copy payload in block layer.
> > copy_offload: used for setting copy offload(1) or emulation(0).
> > copy_max_bytes: maximum total length of copy in single payload.
> > copy_max_bytes_hw: Reflects the device supported maximum limit.
> > 
> > Reviewed-by: Hannes Reinecke <hare@suse.de>
> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> > Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> > Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> > ---
> >  Documentation/ABI/stable/sysfs-block | 36 ++++++++++++++++
> >  block/blk-settings.c                 | 24 +++++++++++
> >  block/blk-sysfs.c                    | 64 ++++++++++++++++++++++++++++
> >  include/linux/blkdev.h               | 12 ++++++
> >  include/uapi/linux/fs.h              |  3 ++
> >  5 files changed, 139 insertions(+)
> > 
> > diff --git a/Documentation/ABI/stable/sysfs-block b/Documentation/ABI/stable/sysfs-block
> > index c57e5b7cb532..f5c56ad91ad6 100644
> > --- a/Documentation/ABI/stable/sysfs-block
> > +++ b/Documentation/ABI/stable/sysfs-block
> > @@ -155,6 +155,42 @@ Description:
> >  		last zone of the device which may be smaller.
> >  
> >  
> > +What:		/sys/block/<disk>/queue/copy_offload
> > +Date:		November 2022
> > +Contact:	linux-block@vger.kernel.org
> > +Description:
> > +		[RW] When read, this file shows whether offloading copy to
> > +		device is enabled (1) or disabled (0). Writing '0' to this
> 
> ...to a device...
> 
acked

> > +		file will disable offloading copies for this device.
> > +		Writing any '1' value will enable this feature. If device
> 
> If the device does...
> 
acked

> > +		does not support offloading, then writing 1, will result in
> > +		error.
> > +
> > +
> > +What:		/sys/block/<disk>/queue/copy_max_bytes
> > +Date:		November 2022
> > +Contact:	linux-block@vger.kernel.org
> > +Description:
> > +		[RW] While 'copy_max_bytes_hw' is the hardware limit for the
> > +		device, 'copy_max_bytes' setting is the software limit.
> > +		Setting this value lower will make Linux issue smaller size
> > +		copies from block layer.
> 
> 		This is the maximum number of bytes that the block
>                 layer will allow for a copy request. Must be smaller than
>                 or equal to the maximum size allowed by the hardware indicated

Looks good.  Will update in next version. We took reference from discard. 

> 		by copy_max_bytes_hw. Write 0 to use the default kernel
> 		settings.
> 

Nack, writing 0 will not set it to default value. (default value is
copy_max_bytes = copy_max_bytes_hw)

> > +
> > +
> > +What:		/sys/block/<disk>/queue/copy_max_bytes_hw
> > +Date:		November 2022
> > +Contact:	linux-block@vger.kernel.org
> > +Description:
> > +		[RO] Devices that support offloading copy functionality may have
> > +		internal limits on the number of bytes that can be offloaded
> > +		in a single operation. The `copy_max_bytes_hw`
> > +		parameter is set by the device driver to the maximum number of
> > +		bytes that can be copied in a single operation. Copy
> > +		requests issued to the device must not exceed this limit.
> > +		A value of 0 means that the device does not
> > +		support copy offload.
> 
> 		[RO] This is the maximum number of kilobytes supported in a
>                 single data copy offload operation. A value of 0 means that the
> 		device does not support copy offload.
> 

Nack, value is in bytes. Same as discard.

> > +
> > +
> >  What:		/sys/block/<disk>/queue/crypto/
> >  Date:		February 2022
> >  Contact:	linux-block@vger.kernel.org
> > diff --git a/block/blk-settings.c b/block/blk-settings.c
> > index 896b4654ab00..350f3584f691 100644
> > --- a/block/blk-settings.c
> > +++ b/block/blk-settings.c
> > @@ -59,6 +59,8 @@ void blk_set_default_limits(struct queue_limits *lim)
> >  	lim->zoned = BLK_ZONED_NONE;
> >  	lim->zone_write_granularity = 0;
> >  	lim->dma_alignment = 511;
> > +	lim->max_copy_sectors_hw = 0;
> > +	lim->max_copy_sectors = 0;
> >  }
> >  
> >  /**
> > @@ -82,6 +84,8 @@ void blk_set_stacking_limits(struct queue_limits *lim)
> >  	lim->max_dev_sectors = UINT_MAX;
> >  	lim->max_write_zeroes_sectors = UINT_MAX;
> >  	lim->max_zone_append_sectors = UINT_MAX;
> > +	lim->max_copy_sectors_hw = ULONG_MAX;
> > +	lim->max_copy_sectors = ULONG_MAX;
> >  }
> >  EXPORT_SYMBOL(blk_set_stacking_limits);
> >  
> > @@ -183,6 +187,22 @@ void blk_queue_max_discard_sectors(struct request_queue *q,
> >  }
> >  EXPORT_SYMBOL(blk_queue_max_discard_sectors);
> >  
> > +/**
> > + * blk_queue_max_copy_sectors_hw - set max sectors for a single copy payload
> > + * @q:  the request queue for the device
> > + * @max_copy_sectors: maximum number of sectors to copy
> > + **/
> > +void blk_queue_max_copy_sectors_hw(struct request_queue *q,
> > +		unsigned int max_copy_sectors)
> > +{
> > +	if (max_copy_sectors >= MAX_COPY_TOTAL_LENGTH)
> 
> Confusing name as LENGTH may be interpreted as bytes. MAX_COPY_SECTORS would be
> better.
> 

Agreed, we will make MAX_COPY_TOTAL_LENGTH explicit to bytes.
We also check this limit against user payload length which is in bytes(patch 2).
So there is a inconsistency from our end (patch 1 and 2). We will fix this
in next version.

> > +		max_copy_sectors = MAX_COPY_TOTAL_LENGTH;
> > +
> > +	q->limits.max_copy_sectors_hw = max_copy_sectors;
> > +	q->limits.max_copy_sectors = max_copy_sectors;
> > +}
> > +EXPORT_SYMBOL_GPL(blk_queue_max_copy_sectors_hw);
> 
> 
> -- 
> Damien Le Moal
> Western Digital Research
> 
> 

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_118142_
Content-Type: text/plain; charset="utf-8"


------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_118142_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------KU2CxbTk4.ftA7vvsvzLW4bt.-m_7jRTbTuK1k18jgDVn8pS=_118142_--

