Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C84A8C433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 09:42:10 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-1Bs5Q9UaNEC0uFLgEmA91g-1; Fri, 04 Feb 2022 04:42:06 -0500
X-MC-Unique: 1Bs5Q9UaNEC0uFLgEmA91g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25E63839A44;
	Fri,  4 Feb 2022 09:42:02 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 04B9D1F2FB;
	Fri,  4 Feb 2022 09:42:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id CE91C1809CBF;
	Fri,  4 Feb 2022 09:42:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 213Mrb5t022242 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 17:53:38 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 510BF40F9D76; Thu,  3 Feb 2022 22:53:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C7C340F9D75
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 22:53:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27D8E1044560
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 22:53:37 +0000 (UTC)
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com
	[211.189.100.12]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-591-w7cH8TDjPBSEGki03P4TdQ-1; Thu, 03 Feb 2022 17:53:35 -0500
X-MC-Unique: w7cH8TDjPBSEGki03P4TdQ-1
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id
	20220203225335usoutp0262d19d5493a26b0a4c1ffc024bdcfd37~QaIwmwB3Q1807918079usoutp02E;
	Thu,  3 Feb 2022 22:53:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com
	20220203225335usoutp0262d19d5493a26b0a4c1ffc024bdcfd37~QaIwmwB3Q1807918079usoutp02E
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
	[203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20220203225334uscas1p1549c0f1a4417c55925d56f53cbff11c6~QaIwb8ss40411504115uscas1p10;
	Thu,  3 Feb 2022 22:53:34 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
	ussmges2new.samsung.com (USCPEMTA) with SMTP id DC.33.10104.EEC5CF16;
	Thu, 3 Feb 2022 17:53:34 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20220203225334uscas1p2cb08fa69376935551d792df32e67acdc~QaIwHlPgw1507515075uscas1p2L;
	Thu,  3 Feb 2022 22:53:34 +0000 (GMT)
X-AuditID: cbfec36f-315ff70000002778-d5-61fc5ceecc28
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.146]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id CF.C7.09657.EEC5CF16;
	Thu, 3 Feb 2022 17:53:34 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
	SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2242.4; Thu, 3 Feb 2022 14:52:43 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
	SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
	15.01.2242.008; Thu, 3 Feb 2022 14:52:43 -0800
From: Adam Manzanares <a.manzanares@samsung.com>
To: Mikulas Patocka <mpatocka@redhat.com>, "joshi.k@samsung.com"
	<joshi.k@samsung.com>
Thread-Topic: [RFC PATCH 3/3] nvme: add the "debug" host driver
Thread-Index: AQHYF5o0LMwUDmubDUu2kNRmd7lMHKyAS6yAgAI7QoCAAAKFAIAAN5GAgAAXUoCAACBXAA==
Date: Thu, 3 Feb 2022 22:52:43 +0000
Message-ID: <20220203225336.GA255651@bgt-140510-bm01>
In-Reply-To: <alpine.LRH.2.02.2202031532410.12071@file01.intranet.prod.int.rdu2.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
x-exchange-save: DSA
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xbdRTH+d1e7r3UMC8dwk+qWSRuJrJ1g4zltwXR6BJvNEsWwWl0zl7h
	jvGeLWyiRpnNCA8ZFIGVIo8ij61sA8scz46U7iHrRkoqa61DhgMU2MpjSnl0IOV2Sf/7nN/5
	npPPSX6UQGQgQqjEtAxOlsamhBJC/MqN/wZ2OA672F3KqQjUPFxEoPLZJQGaMTzwRSVFKhJZ
	xjYhvaPSF5kXT2HogW4NQz11JRg633wdQ383/QRQnsmMIddoOCrpuwuQ3h6GevT9OKppHCdR
	gbWDQFen9QLUdHMVQ7bicYCUuUMYGlC7CGT8cwhHzS6ETn+/RKKp3iNviBnLb+8ySoWDZBS1
	93DGcieT0WnzCKat/lvmB1sTYLp/zyaY725fFzCq+X8Jxnq7HWMKFQ6CmRu348yV0UKSmbk6
	RDAtl4fwg5s/EkbFcymJJzjZzmip8FiraoI83rbpC2NFbDY480w+8KMgvRuWrozgbhbR5wEc
	UezLB8J1Po1Bw6km8mno1p12gm9cBPDeTAPJF7MAVmobfPmiF0BdTvXGLoLeBVdu/ixwcyD9
	IVxeegjcIQHdIoTKkuH1BkVtpqOhZukdPvM6nDfWefKH4NzgAuZmnH4ZmgbqN9796UiYm79M
	uNmP/hguducCNwM6CDpvXdjIC+hgaB+rwXjtAFhX2SPgOQiudo0SPL8ER5yTntMC4SXnI4Kf
	lUBbWamHo+G1ajXOcxhs1Ex7HAJgf8UYzs8+Dw3nbLj7Lkh3CuHQ2VrP0v0wt2DCw2J49oLF
	E9ICWLqQQ/JFG4CqZTNWDLaqvczVXiZqLxO1l4nay6QW+GpBcKZcnprAySPSuJMSOZsqz0xL
	kMSlp+rA+i83rRrTO4DVPifpAxgF+gCkBKGB/snlK6zIP57N+pKTpX8qy0zh5H1ATOGhwf6N
	ia2siE5gM7hkjjvOyZ52McovJBuLjQlSpTum11RvTz58K8llLeNqtAWRP65JfYzF1+5HxQ1C
	S75ov2vn3b+6qt5/MrzyR1GcdSqpxejaF/h1PR6y5x9D1x770Vi5Jexx9GDZJ7LX4j+LujSc
	bE/Ip2K3Sqdnm1UHzL0VzrYAaaTm8Ij4m3bJ0kJDmOIxrqnISjxJdt04GBH3XusrJoe4aU05
	Mdm57YhOvmgu7f+qKJmazPklcuJo2a9odvuhKkP2cLh6PrWq27L38z6Ge1F/ZvdzSWqyfHt1
	TENKkoR9MtjSmfwo5uKJFY3UxzbvvJ9h2jLT8ewLfuIcbUDClvbqrBBHuKuQ/cB67nLmYljv
	mz5ReTu27Q3F5cfY8FcFMjn7P9xzj6VUBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTVxzHOffe3l66lF0e2qMsbkPnomydjRseE8bcHzN3YxnLNGoUcVe5
	gY6HpOWhhggbSqDTYnEQLDgfENhgQSkIhmdoNaQUHFJLa6c4B1XbanlsrrYgTGiX9L/P73e+
	j3OSQ+FhDt5qSpqZzcky2fQoUkBIC7Hy912J8+wmzZM1qOl+GYkqpz04muqf4KHysio+Mk6G
	oB5XNQ+NvPgeQxOaRQx1Xy7H0K9NNzH0uKEWoFLDCIbmH0pQuXYMoB5rNOru0RPoQr2Nj340
	XydRr7MHRw0DCxiynLEBpCoxYeiWep5EunETgZrmETp5ysNHjr6kbZGM8U48oypy8Zmii/cI
	xjicw2gaS0mmta6AOWtpAEzX3UKS+WHoJs5Uzf5DMuahDow5XeQimRmblWDaH57mM1O9JpK5
	0mYivg7fK4hN5tKluZzsg7hvBalXqx7xs1pDjujO7SwEytcUIJiC9IdwcLiDVAABFUY3Adg4
	ovQP0wDerXHyfEMfgPano2DJQtKb4NxAC77EEfQe6PU8BUsinL4igMNazysHRYXTcfCS5wuf
	5hM4q7vs1++CM7f/xZaYoNdBw6265b2Q/giWKLz+ZgsBHSfmlkXB9D74oqtkuRjQK6F78Lfl
	PU6LoHXyAuZ7Aw3run/HfbwC2icWeD5+Gz5w2/k+joDN7mekzyuGloqf/BwHb/ysJnwcDesv
	Of0XCoX6c5OEz7sK9v9iIc6AVeqAanVAlDogSh0QpQ6Iugh4jUCUI5dnpByRb87k8sRyNkOe
	k5kiPnQ4QwNefUfDgi7xOhi3zoi1AKOAFkAKj4oQplXOsWHCZPboMU52+IAsJ52Ta0EkRUSJ
	hMx+1YEwOoXN5tI4LouT/X+KUcGrCzGJQLrrTlW+yptvt2DiLt1W8bir5USxM9m++JL3+sag
	HddWCvftOJorquWfjxQFrSh451nIaGS95Bi2ffdiHF7T2XbyjVMP4iscurJiRXOf+3mewBi7
	Jzyk4qDnU7P3c5HdEbP9+Ft2c/ys8hvbQedC22dK6XjzVJKhseDjG2uPC6uzi3NDzR36BCKo
	c0uo/X5a6mgpZw3+S1KqbMkzTT3WxE8btf2sXihOfw89iWXa16zbOxB9L2tg7Or5GPfm9Rm1
	I7xHb24ZJFs3PH9Xsk1m0Fd+t9aWwM9W4kFbE7xj1VlDiV+9PFQXS+ljFAl/sI6df7f3bvgz
	SZXP3a6hvuyMIuSprGQjLpOz/wEQteiU/QMAAA==
X-CMS-MailID: 20220203225334uscas1p2cb08fa69376935551d792df32e67acdc
CMS-TYPE: 301P
X-CMS-RootMailID: 20220201183359uscas1p2d7e48dc4cafed3df60c304a06f2323cd
References: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
	<20220201102122.4okwj2gipjbvuyux@mpHalley-2>
	<alpine.LRH.2.02.2202011327350.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<CGME20220201183359uscas1p2d7e48dc4cafed3df60c304a06f2323cd@uscas1p2.samsung.com>
	<alpine.LRH.2.02.2202011333160.22481@file01.intranet.prod.int.rdu2.redhat.com>
	<20220202060154.GA120951@bgt-140510-bm01>
	<20220203160633.rdwovqoxlbr3nu5u@garbanzo>
	<20220203161534.GA15366@lst.de>
	<YfwuQxS79wl8l/a0@bombadil.infradead.org>
	<alpine.LRH.2.02.2202031532410.12071@file01.intranet.prod.int.rdu2.redhat.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 213Mrb5t022242
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Feb 2022 04:41:43 -0500
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>, Bart
	Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	=?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dsterba@suse.com" <dsterba@suse.com>, Keith Busch <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K.
	Petersen" <martin.petersen@oracle.com>,
	Luis Chamberlain <mcgrof@kernel.org>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
Subject: Re: [dm-devel] [RFC PATCH 3/3] nvme: add the "debug" host driver
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F9A50E2F9923F248A4158F3A5B0B3FDC@ssi.samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 03, 2022 at 03:57:55PM -0500, Mikulas Patocka wrote:
> 
> 
> On Thu, 3 Feb 2022, Luis Chamberlain wrote:
> 
> > On Thu, Feb 03, 2022 at 05:15:34PM +0100, Christoph Hellwig wrote:
> > > On Thu, Feb 03, 2022 at 08:06:33AM -0800, Luis Chamberlain wrote:
> > > > On Wed, Feb 02, 2022 at 06:01:13AM +0000, Adam Manzanares wrote:
> > > > > BTW I think having the target code be able to implement simple copy without 
> > > > > moving data over the fabric would be a great way of showing off the command.
> > > > 
> > > > Do you mean this should be implemented instead as a fabrics backend
> > > > instead because fabrics already instantiates and creates a virtual
> > > > nvme device? And so this would mean less code?
> > > 
> > > It would be a lot less code.  In fact I don't think we need any new code
> > > at all.  Just using nvme-loop on top of null_blk or brd should be all
> > > that is needed.
> > 
> > Mikulas,
> > 
> > That begs the question why add this instead of using null_blk with
> > nvme-loop?
> > 
> >   Luis
> 
> I think that nvme-debug (the patch 3) doesn't have to be added to the 
> kernel.
> 
> Nvme-debug was an old student project that was canceled. I used it because 
> it was very easy to add copy offload functionality to it - adding this 
> capability took just one function with 43 lines of code (nvme_debug_copy).
>

BTW Kanchan's group has looked at adding copy offload support to the target.
I'll let him respond on the timing of upstreaming, I'm under the assumption
that it is also a relatively small patch to the target code.

> I don't know if someone is interested in continuing the development of 
> nvme-debug. If yes, I can continue the development, if not, we can just 
> drop it.
> 
> Mikulas
> 


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

