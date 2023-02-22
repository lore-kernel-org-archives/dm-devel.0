Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F371FC61DA4
	for <dm-devel@archiver.kernel.org>; Thu, 23 Feb 2023 07:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677138021;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=EfiHadIzoO63fdGs9+SN5Pu1ELcmBdeE8JxMpYfgoLg=;
	b=i6JwV8pJQXV0+P87LmQN9FVHSu9caC8uifltGD+TxsM0uqlayog9VxCimVULoFtocBL0pH
	Po5k6qJep8xpWqJOvd6MsYIPc/h43rq9N5VJmlug5mpUGVzDC7pRnkTsCZizPLWrWIawcc
	iQrUAUXW4Ra9dE5aRV6mHRdFesd0oQo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-DWSDvhUwPWq_rfEM5TlTOg-1; Thu, 23 Feb 2023 02:40:18 -0500
X-MC-Unique: DWSDvhUwPWq_rfEM5TlTOg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FB1485D065;
	Thu, 23 Feb 2023 07:40:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 22E1C492B00;
	Thu, 23 Feb 2023 07:40:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 00B721946A69;
	Thu, 23 Feb 2023 07:40:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A36E11946587
 for <dm-devel@listman.corp.redhat.com>; Wed, 22 Feb 2023 09:02:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0F34F492B01; Wed, 22 Feb 2023 09:02:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 07017492B00
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 09:02:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF53C85A588
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 09:02:36 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-aRenKyCVNMyjtVJFG4pPKw-1; Wed, 22 Feb 2023 04:02:34 -0500
X-MC-Unique: aRenKyCVNMyjtVJFG4pPKw-1
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
 by mailout1.samsung.com (KnoxPortal) with ESMTP id
 20230222090231epoutp01782fe87f4ae6387fc72c84f469faba11~GGgxrL3vb0678706787epoutp01h
 for <dm-devel@redhat.com>; Wed, 22 Feb 2023 09:02:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
 20230222090231epoutp01782fe87f4ae6387fc72c84f469faba11~GGgxrL3vb0678706787epoutp01h
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTP id
 20230222090231epcas5p13f234960738c0cf4e3206c3cfad2b69a~GGgxG-5S80161201612epcas5p1F;
 Wed, 22 Feb 2023 09:02:31 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
 epsnrtp3.localdomain (Postfix) with ESMTP id 4PM9CT4G7gz4x9Pr; Wed, 22 Feb
 2023 09:02:29 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
 epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
 59.81.06765.52AD5F36; Wed, 22 Feb 2023 18:02:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
 epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
 20230222061311epcas5p1668d0066e043e146e6bd7db32c010667~GEM7Fiiac1792017920epcas5p1E;
 Wed, 22 Feb 2023 06:13:11 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
 epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
 20230222061311epsmtrp20840e9dccad1f7846d8bb9d162a25aa3~GEM7Efrmo3190331903epsmtrp2G;
 Wed, 22 Feb 2023 06:13:11 +0000 (GMT)
X-AuditID: b6c32a4b-20fff70000011a6d-24-63f5da258277
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
 epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
 08.9C.05839.772B5F36; Wed, 22 Feb 2023 15:13:11 +0900 (KST)
Received: from green5 (unknown [107.110.206.5]) by epsmtip2.samsung.com
 (KnoxPortal) with ESMTPA id
 20230222061308epsmtip21ab9090b9fa12359e861e5637b8374cd~GEM3-5pBx1221112211epsmtip2d;
 Wed, 22 Feb 2023 06:13:08 +0000 (GMT)
Date: Wed, 22 Feb 2023 11:42:36 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Minwoo Im <minwoo.im.dev@gmail.com>
Message-ID: <20230222061236.GA13158@green5>
MIME-Version: 1.0
In-Reply-To: <Y/VapDeE98+A6/G2@minwoo-desktop>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02TfVBUVRjGO/fuXhZ14YYfHHCSnUvGl7uwsrtdGqActK5RgWONYzXhtlw+
 l91lP8RkKkAwBRWEMNnSwBASkA1WCIQF21IEYmDkQ2UkoUEjCBCQ0GVk2+VC43+/8z7PO897
 3jOHg7p84+DOiVdoabVCKiewNaz6X328+FsH52UBmZUepKHjBkpm5D1DycqhXIw88+gpSi52
 daOkaepbNnn3WiNCNl/IR8hLldcRsqlkBiGvWycxMt88AMgH/XqENA36kc2mdhbZe/U7jPy+
 7IEDaS44gpCW42vJhtF0QFZPTLPIm4Obye5nbew3XKnevnBKf78Loxr1Qw5U9x81LKq3S0fV
 VhzHKGPpl1TT3TSMOnlkymbIus+mplv6MerUlQpAGTtTqbnaLVTt6CQS6fxhYnAcLY2m1Txa
 IVNGxytiQ4jwvVFhUWJJgJAvDCJfJXgKaRIdQux8J5L/ZrzctgGCd1Aq19lKkVKNhvAPDVYr
 dVqaF6fUaEMIWhUtV4lUAo00SaNTxAoUtPY1YUDAdrHNeCAx7pZ1BlPVrT3UnWEEaeC0YzZw
 5EBcBIfrppBssIbjgjcB+JWlFbMLLvgsgItFgYzwL4DVlaXIasfizXmMEUwADjwdYjOHUQCz
 OxuA3cXCt8Khy/m2Dg4Hw/1gp5VjL2/AvWDpcBmw+1G8gA3T7pSz7cJ6/G2YNV69nMC1+S01
 FpThF2F70SjLzo64AI4UTC/zRtwTXqtvW5nI4AiHag8yvBOOnW1Zqa+H421XHBh2h3NTJozh
 FHjp6x+XbwDxTAD1t/WAEV6HWR25y8EoHgcv/pXBZuovwcIOZjgUd4InF0dXAriw4fwqe8Iq
 Q/FKgBscWEhfYQoajg2zmA2NAHivvR3kAQ/9c5fTP5fH8DZY3DSL6W3LQ/HNsHyJw6APNFz1
 LwbsCuBGqzRJsbRGrApU0Cn/v7hMmVQLln+Ib3gD+HP4kcAMEA4wA8hBiQ1cK3dO5sKNln52
 mFYro9Q6Oa0xA7HtsU6j7htlStsXU2ijhKKgAJFEIhEFBUqEhCvXK6Rd5oLHSrV0Ik2raPVq
 H8JxdE9DuGLvD3wq+cEvj7y10Jw5Xh4/MWv5NKTF+MVRtoenqWRs/zpJKi9xtshPkEcTtDUt
 d6Cm1e/n+cWapcfKerdz595r5i9h6Uhq8gtOxvfzd4tCn+xI+O1OxCGkx5U34eKqTg1LhE9i
 E8AvWm3YxS0f9+R8Lv9kYVfy4l6iKKJCm+DtcLjyh7r582eRM3T9rebdM5v2GTPfzel7mOM9
 fmpHzFFEYBaP/R2zzVB2rPEe3MMlSn6yVP0OI7I6nGP8BwoPVBeirww07oreI15HfdQz49zh
 45xscEopO+G3aX9r6MPbk/vc+hp1/5Rf7k/Q+FpDq1SzWRf4N8rmM+Uemu3CHQmPCZYmTir0
 RdUa6X9EkgBuqgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJIsWRmVeSWpSXmKPExsWy7bCSvG75pq/JBnPniVusP3WM2aJpwl9m
 i9V3+9kspn34yWzx++x5Zou972azWtw8sJPJYs+iSUwWK1cfZbLYvfAjk8XR/2/ZLCYdusZo
 8fTqLCaLvbe0LfbsPclicXnXHDaL+cueslscmtzMZPGrk9tix5NGRot1r9+zWJy4JW1x/u9x
 Vgdxj8tXvD1m3T/L5rFz1l12j/P3NrJ4XD5b6rFpVSebx+Yl9R67bzawefQ2vwMqaL3P6vF+
 31U2j74tqxg9Np+u9vi8Sc5j05O3TAH8UVw2Kak5mWWpRfp2CVwZ/2b+Yy74ylHR9O4ZcwPj
 K7YuRk4OCQETid8nvgLZXBxCArsZJZ5sPsAEkZCUWPb3CDOELSyx8t9zdoiiR4wSL2e3MoIk
 WARUJe6unQTUwMHBJqAtcfo/B0hYREBdYsmDZYwg9cwC01kl3k8/CrZNWMBLovXVOrAFvED1
 vzb+YoYY+pBR4vOxM6wQCUGJkzOfsIDYzAJaEjf+vQRbwCwgLbH8H9gCTgE9iYeT34OViAoo
 SxzYdpxpAqPgLCTds5B0z0LoXsDIvIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzj2
 tTR3MG5f9UHvECMTB+MhRgkOZiUR3v+8n5OFeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkv
 JJCeWJKanZpakFoEk2Xi4JRqYFpw+l3OirXTymbemr7qykFuZlNOlZ/yQn6XTB0fubmaN1X+
 nbHfKCZGhlNhkoMrwy3xVps7SS73U+/82fBc28pq9QzlLM97Qolrt65pm2bdp/M8+Un8270p
 q7ck/WipSMjateiu/T3vJLt5FWecOFg4Tt2zX7eJVaio4hZncGJo+9WmF6UanW0WDny9i/ZG
 z6hxcBBKDTRqkWvrOaT323rK1bUvwmeq/Pzc6t92S6z2+72DLZ3RRTmPVhjEW/jpveeu5N9b
 ZPqwvMSOUXPvySnMNXLC0dPFHrIu3ejh/dwjz6TizaTo06fTHZ0fPF55dEehtMn6wHkZNQnh
 z6XkI8tDl938Zq/5TTDvUc4JJZbijERDLeai4kQA/vWOE2wDAAA=
X-CMS-MailID: 20230222061311epcas5p1668d0066e043e146e6bd7db32c010667
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230220105441epcas5p49ffde763aae06db301804175e85f9472
References: <20230220105336.3810-1-nj.shetty@samsung.com>
 <CGME20230220105441epcas5p49ffde763aae06db301804175e85f9472@epcas5p4.samsung.com>
 <20230220105336.3810-3-nj.shetty@samsung.com>
 <Y/VapDeE98+A6/G2@minwoo-desktop>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Thu, 23 Feb 2023 07:39:58 +0000
Subject: Re: [dm-devel] [PATCH v7 2/8] block: Add copy offload support
 infrastructure
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
 Chaitanya Kulkarni <kch@nvidia.com>, anuj20.g@samsung.com,
 Mike Snitzer <snitzer@kernel.org>, ming.lei@redhat.com,
 linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 bvanassche@acm.org, Jens Axboe <axboe@kernel.dk>, joshi.k@samsung.com,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 damien.lemoal@opensource.wdc.com, Alexander Viro <viro@zeniv.linux.org.uk>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
 boundary="----yVjN9gd9kB_eEBqPP9-k1BSyTM5mTd6q7sagKps1_qiE1IrQ=_83a81_"

------yVjN9gd9kB_eEBqPP9-k1BSyTM5mTd6q7sagKps1_qiE1IrQ=_83a81_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Feb 22, 2023 at 08:58:28AM +0900, Minwoo Im wrote:
> > +/*
> > + * @bdev_in:	source block device
> > + * @pos_in:	source offset
> > + * @bdev_out:	destination block device
> > + * @pos_out:	destination offset
> 
> @len is missing here.
> 

acked

> > + * @end_io:	end_io function to be called on completion of copy operation,
> > + *		for synchronous operation this should be NULL
> > + * @private:	end_io function will be called with this private data, should be
> > + *		NULL, if operation is synchronous in nature
> > + * @gfp_mask:   memory allocation flags (for bio_alloc)
> > + *
> > + * Returns the length of bytes copied or a negative error value
> > + *
> > + * Description:
> > + *	Copy source offset from source block device to destination block
> > + *	device. length of a source range cannot be zero. Max total length of
> > + *	copy is limited to MAX_COPY_TOTAL_LENGTH
> > + */
> > +int blkdev_issue_copy(struct block_device *bdev_in, loff_t pos_in,
> > +		      struct block_device *bdev_out, loff_t pos_out, size_t len,
> > +		      cio_iodone_t end_io, void *private, gfp_t gfp_mask)
> 

------yVjN9gd9kB_eEBqPP9-k1BSyTM5mTd6q7sagKps1_qiE1IrQ=_83a81_
Content-Type: text/plain; charset="utf-8"


------yVjN9gd9kB_eEBqPP9-k1BSyTM5mTd6q7sagKps1_qiE1IrQ=_83a81_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

------yVjN9gd9kB_eEBqPP9-k1BSyTM5mTd6q7sagKps1_qiE1IrQ=_83a81_--

