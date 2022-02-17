Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90B3DC433FE
	for <dm-devel@archiver.kernel.org>; Mon, 21 Feb 2022 06:07:10 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-Qa4xHKzrNuC9fboV7syBTg-1; Mon, 21 Feb 2022 01:07:05 -0500
X-MC-Unique: Qa4xHKzrNuC9fboV7syBTg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44AE51091DA1;
	Mon, 21 Feb 2022 06:07:00 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B21955DBA5;
	Mon, 21 Feb 2022 06:06:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5521A4A7C8;
	Mon, 21 Feb 2022 06:06:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21I50jOU032767 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 18 Feb 2022 00:00:46 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id A46752166B18; Fri, 18 Feb 2022 05:00:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9EC872166B2D
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 05:00:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 527C62B16870
	for <dm-devel@redhat.com>; Fri, 18 Feb 2022 05:00:42 +0000 (UTC)
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-581-19KJdPLzP2CgRb9ZDI-4vg-1; Fri, 18 Feb 2022 00:00:39 -0500
X-MC-Unique: 19KJdPLzP2CgRb9ZDI-4vg-1
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id
	20220218050036epoutp023b79452c35d4668bac8b1525c55b5a1d~UyLNr7NGA2938129381epoutp02W;
	Fri, 18 Feb 2022 05:00:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com
	20220218050036epoutp023b79452c35d4668bac8b1525c55b5a1d~UyLNr7NGA2938129381epoutp02W
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20220218050036epcas5p47dc1325db6e412d1dd5615722cab2134~UyLNRTZzn0649606496epcas5p4F;
	Fri, 18 Feb 2022 05:00:36 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4K0KJV622Hz4x9Pv;
	Fri, 18 Feb 2022 05:00:26 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C1.F4.06423.9E72F026; Fri, 18 Feb 2022 14:00:25 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20220217133547epcas5p305c93f10e815e275374ca2f41d75a2aa~Uljuy6HZZ1991119911epcas5p3t;
	Thu, 17 Feb 2022 13:35:47 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20220217133547epsmtrp21569afdc8d19e716eab1f6cdac5f9309~UljuxENvs1692816928epsmtrp2j;
	Thu, 17 Feb 2022 13:35:47 +0000 (GMT)
X-AuditID: b6c32a49-b13ff70000001917-2a-620f27e94992
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	F0.3F.29871.23F4E026; Thu, 17 Feb 2022 22:35:46 +0900 (KST)
Received: from test-zns (unknown [107.110.206.5]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20220217133542epsmtip2abd6e670ac9ebfdb75c8f643565fcf05~UljqV5HGc2615626156epsmtip2J;
	Thu, 17 Feb 2022 13:35:42 +0000 (GMT)
Date: Thu, 17 Feb 2022 19:00:46 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Message-ID: <20220217133046.GA13770@test-zns>
MIME-Version: 1.0
In-Reply-To: <20220217083631.34ii6gqdrknrmufv@garbanzo>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA02Te0xTVxzHc+69vS246h1QdmTKWJvFqRRa5XHYQJbozPWxDffIFpMNL3Bt
	FWibPhwj2aTijIhoYYNAZQ63uW5gAME5oJRJHTBEVEQQVF6jzEyhPHwACnQtrYv/fX6/8/29
	c3i4z21uAG+PQsuqFUyKkPQmzl9cvUr876plCZKG1mBUcakZR/W9DziorO84iQomZnE03jjM
	QXnHC7mo07YUWewnOOjajB5Dw1UODNX/kIehX8uaMHTX9CNA5lOTGMpqu4ahuSEpanKMkSjP
	2g3QSJcRQ5Zba1G9pZVAnXXFJPr+5xEuyr5ZQ6KG+xYcmVoWMNRjGAHoinGORDU2PUAX+7sI
	VH5/nED3Z1pJdOjsI4C+PjrLRVfnWzhviejOG9to40A7Sedm2rl0rbGPS1/tP0vQmSV3CLqz
	XUdXlWaRdPVP++lvekyANvdmkPSBy004XTj1kKRzMu0kPTlyi6DHG7rIOP+dydFylkli1UGs
	IlGZtEchixFu+yB+Y3x4hEQqlkahSGGQgkllY4SbtseJN+9JcS5RGLSPSdE5XXGMRiMM3RCt
	Vuq0bJBcqdHGCFlVUooqTBWiYVI1OoUsRMFq35BKJOvCncJdyfKC2XKgqiXTnnzXTWSAKs4R
	4MWDVBjsHysijwBvng9lBtCe8afHmALw9JM8wm08BrAjewJ7FtIyN8FxP1gAPHj9AO42/gHw
	jvUg7lIR1GtwtqrUmYvHI6m1sM3Bc7n9qNdhgyFnMRFOPSKhvjLUxb7URljssHFdzKfE0Hh7
	CLj5RdhaZCNc7EVFwqdt5xY1AkoEL5xvwVx1IZXvDU+P9gNXLUhtgqZ6tbtRX3ivxa2HVAB8
	YLeQbn02gDOXBzzBhQBmGjJJtyoWdtTPe7qTQ8tMvmfklTD/UrnHvxTmPLV5/HxYc/IZi+CZ
	ihJPnuWwe1rvYRrWDUx79jgKYHWOiTCAV4zPTWd8rp6bg2GJeYo0OgfCqZehaYHnxtWwoi60
	BHBKwXJWpUmVsZpwlVTBfv7/yROVqVVg8Zet2VID+gYnQqwA4wErgDxc6MefaOQn+PCTmC/S
	WbUyXq1LYTVWEO48Vi4eIEhUOr+pQhsvDYuShEVERIRFrY+QCl/it8kqGR9KxmjZZJZVsepn
	cRjPKyAD2+vN7JMd7m2P+f2C1eivGzrqM18WAmeTRCtOXz+Jr/uqlhGs/+z97k8NXyZEDjh2
	H+pM/6s79spHZ2qXCSO38reX7XxnSan+gHLrx4Gn+NF8xy/5d94Ujw3V2ScDE9d1mP2zRvG3
	ewcDCgSs8pi6790Z9blmETmwP91UUTT4mCq67hu5sXH3ZXlN4IqF4B2vzr1H4nJxdVT8ldvD
	az55YfPwLr1ZJIjawZ1bkisgTfAPv6wtem/s7/GbGut63+jGNK2m9TBdgjZ8e+OeSTIZu2q+
	uG9lz8PmcotBVwSSHSpHqXj6w7NxdSFDOb/tHT9xNVkwPBY6X9nOq7blpln7o+82CwmNnJGu
	wdUa5j+jLjDh7gQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02SX0xTZxjG951zenro1ua0MvwAM7K6GaWIQ9n2ZWHqsgsOEqMXBg2ZQJXT
	QoDa9IBTErdixYx/EatbpDpxQCAUkYkGcLSNLbIOu45GRIoDFmI7hh1tcWPaAGUrbJl3T97n
	+f2uXgqXXObFUYWqUlajkhdLSQHRMyBN2Lp9n+jIO8333kNd97/HkWn8Dx7qmDxHoq+CIRwF
	rE94SH/uEh+NeETI7L/MQ64XFRh60r2CIVOTHkPtHYMYmmlrBqj/m3kMVTlcGFqaTkGDK3Mk
	0tseAeQdNWDI/FiGTOYhAo18d4VEja1ePqoZ6yORxWfGUZs9jCF3vRegnwxLJOrzVAA0MDVK
	oBu+AIF8L4ZIdPbmAkCVtSE+Gl6283ZvZEYeZjKGX5wkc17n5zN3DJN8ZnjqJsHork0QzIiz
	jOk2VpHMrZbPmQvuNsD0j2tJ5vSPgzhz6dmfJFOn85PMvPcxwQQso+T+mGxBWj5bXHic1Wzb
	mScoGGi4T6hD+ImBmueEFtTg1SCKgnQqtC8FedVAQEnofgB7z/vItSIWti7f+3e0DraHZ/hr
	Iw+AU5W/YZGCoN+GoW7jPwBFkbQMOlaoyDma3gwt9XVYZI/TiyT06hdWRevoj+GVFQ8/koX0
	Vmj4eRpEsoT+HUCHJ23tLoZDDR4iknE6EbrDs1jEj9PxsC286o+i34eLjturmtfpjfBujx2r
	B2LDS7ThJdrwP30N4EYQy6q5EmUJl6JOUbGfJnPyEq5MpUw+eqykG6z+T+KWPtBrDCbbAEYB
	G4AULo0WBq3CIxJhvvxkOas5lqspK2Y5G4inCOl6oat6KFdCK+WlbBHLqlnNfy1GRcVpsc/w
	1CSbe/8hYP1Qedr10dyGtFD+00Xngz2ST6YDS/qE7WarNlZxfffzJHWaYlMjripIqKUPps8t
	y75W3j7QfOPo/FNFk+ZiI7dNGOO35pfKWi2db3wR1IWrCPNr4zmppUmmQ8Ge6eN/dc74xh4y
	lXcyXy3qbErNNs0Krg7vTFC0SB7ZLWepdy/kqpQXK2K4hTx8Ii66K+eUqyPr6r7huCJxRuDb
	nHi/usvTcvLLtyYaMvf+oMrY5a7VKURqerLO+asoe3TXm69UbZDJ19/d+yxvh1Ee5ZDv6NX6
	Dp85k16+eJDJmidnnbnlqqz0A36X+MGpwrET7VkfZIgH9RmJIinBFchTEnENJ/8blpJWdq4D
	AAA=
X-CMS-MailID: 20220217133547epcas5p305c93f10e815e275374ca2f41d75a2aa
X-Msg-Generator: CA
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220214080558epcas5p17c1fb3b659b956908ff7215a61bcc0c9
References: <20220214080002.18381-1-nj.shetty@samsung.com>
	<CGME20220214080558epcas5p17c1fb3b659b956908ff7215a61bcc0c9@epcas5p1.samsung.com>
	<20220214080002.18381-2-nj.shetty@samsung.com>
	<20220217083631.34ii6gqdrknrmufv@garbanzo>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 21 Feb 2022 01:04:54 -0500
Cc: Mike Snitzer <snitzer@redhat.com>, djwong@kernel.org,
	linux-nvme@lists.infradead.org, clm@fb.com, dm-devel@redhat.com,
	Chaitanya Kulkarni <kch@nvidia.com>, osandov@fb.com,
	Alasdair Kergon <agk@redhat.com>, javier@javigon.com,
	bvanassche@acm.org, linux-scsi@vger.kernel.org,
	nitheshshetty@gmail.com, Smart <james.smart@broadcom.com>,
	hch@lst.de, chaitanyak@nvidia.com,
	SelvaKumar S <selvakuma.s1@samsung.com>, msnitzer@redhat.com,
	josef@toxicpanda.com, linux-block@vger.kernel.org,
	dsterba@suse.com, kbusch@kernel.org, Frederick.Knight@netapp.com,
	Sagi Grimberg <sagi@grimberg.me>, axboe@kernel.dk, tytso@mit.edu,
	joshi.k@samsung.com, martin.petersen@oracle.com, James,
	linux-kernel@vger.kernel.org, arnav.dawn@samsung.com,
	jack@suse.com, linux-fsdevel@vger.kernel.org,
	lsf-pc@lists.linux-foundation.org, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [dm-devel] [PATCH v3 01/10] block: make bio_map_kern() non
	static
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
	boundary="----Fq-YzQe-sCxQ_.ALiW-8FMdnFblVNc8pE5kaYAan9Jc7INV.=_8df09_"

------Fq-YzQe-sCxQ_.ALiW-8FMdnFblVNc8pE5kaYAan9Jc7INV.=_8df09_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Thu, Feb 17, 2022 at 12:36:31AM -0800, Luis Chamberlain wrote:
> On Mon, Feb 14, 2022 at 01:29:51PM +0530, Nitesh Shetty wrote:
> > From: SelvaKumar S <selvakuma.s1@samsung.com>
> > 
> > Make bio_map_kern() non static
> > 
> > Signed-off-by: SelvaKumar S <selvakuma.s1@samsung.com>
> > Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
> 
> This patch makes no sense on its own. I'd just merge it with
> its first user.
> 
>   Luis
>

acked. I will do it next version.

--
Nitesh

------Fq-YzQe-sCxQ_.ALiW-8FMdnFblVNc8pE5kaYAan9Jc7INV.=_8df09_
Content-Type: text/plain; charset="utf-8"


------Fq-YzQe-sCxQ_.ALiW-8FMdnFblVNc8pE5kaYAan9Jc7INV.=_8df09_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel
------Fq-YzQe-sCxQ_.ALiW-8FMdnFblVNc8pE5kaYAan9Jc7INV.=_8df09_--

