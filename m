Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91CA9C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 21 Feb 2022 06:07:27 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-450-mXOF6MwnMB-C9sp-_rqckg-1; Mon, 21 Feb 2022 01:07:24 -0500
X-MC-Unique: mXOF6MwnMB-C9sp-_rqckg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 987D52F4A;
	Mon, 21 Feb 2022 06:07:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 79CB95DBA5;
	Mon, 21 Feb 2022 06:07:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 52CD71809CAB;
	Mon, 21 Feb 2022 06:07:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21I50vkt000324 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Feb 2022 00:00:57 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 2378076EE; Fri, 18 Feb 2022 05:00:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CBA3778B
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 05:00:51 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E7161C05ED3
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 05:00:51 +0000 (UTC)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-381-5L-UZkjmOSGY1ye-4tAXLQ-1; Fri, 18 Feb 2022 00:00:46 -0500
X-MC-Unique: 5L-UZkjmOSGY1ye-4tAXLQ-1
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id
	20220218050044epoutp01bf4c0b3d01fb43dd5e46da5d814c712e~UyLU2TkHx1045810458epoutp01t
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 05:00:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com
	20220218050044epoutp01bf4c0b3d01fb43dd5e46da5d814c712e~UyLU2TkHx1045810458epoutp01t
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20220218050043epcas5p2a4f639ec6d236b09980838ceba0554ad~UyLUK8HqW2406724067epcas5p2p;
	Fri, 18 Feb 2022 05:00:43 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4K0KJd5zjQz4x9QV;
	Fri, 18 Feb 2022 05:00:33 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	B3.C6.46822.BA62F026; Fri, 18 Feb 2022 13:55:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20220217132330epcas5p47a248871b8d1d9f7aaa4b0caf1b100c5~UlZBEV68H2815628156epcas5p44;
	Thu, 17 Feb 2022 13:23:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20220217132330epsmtrp2ed7507a8a072bce17dd595d876a39a30~UlZBCC2qF0924009240epsmtrp20;
	Thu, 17 Feb 2022 13:23:30 +0000 (GMT)
X-AuditID: b6c32a4a-de5ff7000000b6e6-ff-620f26abd6d4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1F.2E.29871.25C4E026; Thu, 17 Feb 2022 22:23:30 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20220217132326epsmtip234b5e87e0e8be80016deb77ba0ffa376~UlY9ZQ84v2210422104epsmtip2N;
	Thu, 17 Feb 2022 13:23:26 +0000 (GMT)
Date: Thu, 17 Feb 2022 18:48:31 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Message-ID: <20220217131831.GC3781@test-zns>
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2202160830150.22021@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te1BUVRzHO3fv3l1U8ApYB9RkliEF5LG24EFBndHBW+wUjs3YFIkXuC4M
	y7LtoxAnWVqItzyyWFctVAZGHtEAAcE+FCVCwBRChKhAHhYlIDC8hRZ2afzvc36/8/3+fr/z
	4LJsf+A4cqMkCkYmocU8YgNec8d1t0fpG5vDvA0T9kjXM8VGpb9nE+jriXkWGr89yEZ52RoO
	6hyyQfqxy2z0YC4RQ4OVKxjSXc/D0M3SJgw9Lb4BUFrrAwwtDfBR08ozAuU1PgJI3+uOdPoW
	HH1bNMxBGd11BDL8o2eh4uZlDOWmdmHovnaJQHf+6MJR6RJCyZnzHDRqPHV4O9X5axCVqx7j
	UOqCPpzqbFdSlSVpBFVVmEB9+bgYUA09KoL6vK2JRWkmpwmqu60Wo7LUYwT1fLgXp2oGsjjU
	uKGLoC5Ul4Bg+w+i/SMZOoKROTGS8NiIKIkogBd0IvRIqI+vN9+D74f28ZwkdAwTwDsqDPYI
	jBKbzofn9AktVppCwbRczvM66C+LVSoYp8hYuSKAx0gjxFKB1FNOx8iVEpGnhFHs53t77/Ux
	bTwdHTnZOYNLUzbGpeZoMBUY46YDKy4kBTB5uh6kgw1cW7IBwLryYctiEsD+KS1uXswAOFyQ
	TKxLahtvss0JPYCG0SX2asKWHAGwSs9JB1wuTrrAqsvCVSRId9i6slbNnnSFHVf+XZOyyF4c
	aroHOKsJO/IAzF8sW7OxJvfAv0e6LLwFtlwawld9rMgP4d2mtRa2ks7wVk0ztuoDySdWcKzw
	C465t6PQmPSThe3gaHO1hR3h1JieMAsyAJxr+9Oi1gCozlFbJjsEH+peYKvMIiOhKn/Got4B
	v7r3nSVuA7MWhzBz3BrWfbPOzrCsosDi4wAfzSZamIIXrhotx9iFwZTMXiwH7NS+NJ32pXpm
	3gMLGiYJrWlqFrkNFi9zzegKK+q9CgC7BDgwUnmMiJH7SPdKmE//v/Hw2JhKsPZ/3N6uAwP9
	E56NAOOCRgC5LJ699cRt6zBb6wj6bDwjiw2VKcWMvBH4mC4rl+W4NTzW9AElilC+wM9b4Ovr
	K/B705fPe826VfQ9bUuKaAUTzTBSRrauw7hWjirsrelfFg6PnKmPmdms6s132fVcP5hzOr2C
	7U9yiuJT2p3fHz7xnnCkEJ9VlO9rJ/hPPR11dLKI1MK/is6/Gqk/0p+Mx0+dXUDjZ7YxCalX
	dB1BwqvsA0kuLddCPNyzDt37+LO+jpYMo1G9ZYaonhaYXkw9zN6FiRMfx/t3G+zVA5jmZMQi
	FihefPJOyMO45eb9CcDoJuTJusvmdt+YsyGuTW3/bdChnBS+EtKk3BH/etKs8C4M/3lUhEul
	PX4awzHtzkA743zfybiwlk0rm3rSggQ17Mxa1cGLFxfOnbp/yWvjcXseffyZg7fe2eB6/t2c
	W+eufzQcJxcG/agsepHEw+WRNN+NJZPT/wH/td5UyAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsWy7bCSvG6QD1+SwcItahZ7bn5mtVh9t5/N
	YtqHn8wW7w8+ZrWY1D+D3eLyEz6Lve9ms1pc+NHIZPF4038miz2LJjFZrFx9lMni+fLFjBad
	py8wWfx5aGhx9P9bNotJh64xWuy9pW2xZ+9JFov5y56yW3Rf38Fmse/1XmaL5cf/MVlM7LjK
	ZHFu1h82i8P3rrJYrP5jYdHa85Pd4tX+OAcZj8tXvD0mNr9j92hecIfF4/LZUo9NqzrZPDYv
	qfeYfGM5o8fumw1sHk1njjJ7zPj0hc3j+pntTB69ze/YPD4+vcXise1hL7vH+31X2Tz6tqxi
	DBCJ4rJJSc3JLEst0rdL4MrY8PcvS8Fxjoq7L54xNzAeZ+ti5OSQEDCR2H5oJWsXIxeHkMBu
	Romzm5ewQCQkJZb9PcIMYQtLrPz3nB2i6AmjRNf6WYxdjBwcLAKqEptn+4CYbALaEqf/c4CU
	iwhoSlya8wZsJrPAHRaJXX+egc0RFrCWmP57DSuIzSugI/Hy2VWoxVeZJF6+nwOVEJQ4OfMJ
	2BHMAloSN/69ZAJZwCwgLbH8HweIySkQLXHkKNj9ogLKEge2HWeawCg4C0nzLCTNsxCaFzAy
	r2KUTC0ozk3PLTYsMMxLLdcrTswtLs1L10vOz93ECE4ZWpo7GLev+qB3iJGJg/EQowQHs5II
	74eDvElCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwXEkhPLEnNTk0tSC2CyTJxcEo1MB3b
	GuS2MUzomsmpCT4MrGtOX7p499M0h8UiKWsTD8g9V5k+V2CRmOtuGUefnVN9p01xWdfkq7ws
	8LNXyIQL9kmuXcd4VKcYuqy3NZO8eH7N6dqQ3fzO6Ud5mU6nFexxK5vw+K3Kw+SPZ9VmOyjv
	mtX4rvbGs1mrVxy08eaPevDDouxcyzt+1Q3vX7zctltFrSfynOKTR1kPZiSdtMiN0vKzsTdU
	tgzSmSfLunydl+DxGgvL0J/vPgQXZrKtf/JddR1nX/F1B+EVt/8d8Zo9cQKnYUNC5oSyJR1z
	zKXPlv/mik46Y7S/NNqhNFclMsWI6f+eD/8u7Qrpcz687JJ62IJdKrwXpLbd0DV+Wizz67MS
	S3FGoqEWc1FxIgCHHo8LiAMAAA==
X-CMS-MailID: 20220217132330epcas5p47a248871b8d1d9f7aaa4b0caf1b100c5
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220207141930epcas5p2bcbff65f78ad1dede64648d73ddb3770
References: <CAOSviJ0HmT9iwdHdNtuZ8vHETCosRMpR33NcYGVWOV0ki3EYgw@mail.gmail.com>
	<20220207141348.4235-1-nj.shetty@samsung.com>
	<CGME20220207141930epcas5p2bcbff65f78ad1dede64648d73ddb3770@epcas5p2.samsung.com>
	<20220207141348.4235-6-nj.shetty@samsung.com>
	<alpine.LRH.2.02.2202160830150.22021@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 21 Feb 2022 01:04:54 -0500
Cc: djwong@kernel.org, linux-nvme@lists.infradead.org, clm@fb.com,
	dm-devel@redhat.com, osandov@fb.com, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org, hch@lst.de,
	roland@purestorage.com, zach.brown@ni.com, chaitanyak@nvidia.com,
	msnitzer@redhat.com, josef@toxicpanda.com,
	linux-block@vger.kernel.org, dsterba@suse.com, kbusch@kernel.org,
	Frederick.Knight@netapp.com, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com,
	arnav.dawn@samsung.com, jack@suse.com,
	linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Subject: Re: [dm-devel] [PATCH v2 05/10] block: add emulation for copy
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed;
	boundary="----w44XasAgibz0dH83sqZUwD2VszzvD0Z8603isFAMQ6N2NX8f=_8dd51_"

------w44XasAgibz0dH83sqZUwD2VszzvD0Z8603isFAMQ6N2NX8f=_8dd51_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Wed, Feb 16, 2022 at 08:32:45AM -0500, Mikulas Patocka wrote:
> 
> 
> On Mon, 7 Feb 2022, Nitesh Shetty wrote:
> 
> > +				goto retry;
> > +			return PTR_ERR(bio);
> > +		}
> > +
> > +		bio->bi_iter.bi_sector = sector >> SECTOR_SHIFT;
> > +		bio->bi_opf = op;
> > +		bio_set_dev(bio, bdev);
> > @@ -346,6 +463,8 @@ int blkdev_issue_copy(struct block_device *src_bdev, int nr,
> >  
> >  	if (blk_check_copy_offload(src_q, dest_q))
> >  		ret = blk_copy_offload(src_bdev, nr, rlist, dest_bdev, gfp_mask);
> > +	else
> > +		ret = blk_copy_emulate(src_bdev, nr, rlist, dest_bdev, gfp_mask);
> >  
> >  	return ret;
> >  }
> 
> The emulation is not reliable because a device mapper device may be 
> reconfigured and it may lose the copy capability between the calls to 
> blk_check_copy_offload and blk_copy_offload.
> 
> You should call blk_copy_emulate if blk_copy_offload returns an error.
> 
> Mikulas
> 
>

I agree, it was in our todo list to fallback to emulation for partial
copy offload failures. In next version we will add this.

--
Nitesh Shetty


------w44XasAgibz0dH83sqZUwD2VszzvD0Z8603isFAMQ6N2NX8f=_8dd51_
Content-Type: text/plain; charset="utf-8"


------w44XasAgibz0dH83sqZUwD2VszzvD0Z8603isFAMQ6N2NX8f=_8dd51_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
------w44XasAgibz0dH83sqZUwD2VszzvD0Z8603isFAMQ6N2NX8f=_8dd51_--

