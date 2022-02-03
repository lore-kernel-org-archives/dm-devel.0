Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C4CC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Feb 2022 09:41:56 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-37Vl77EMPtSjC3yEDCXQ8A-1; Fri, 04 Feb 2022 04:41:52 -0500
X-MC-Unique: 37Vl77EMPtSjC3yEDCXQ8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE23A1853022;
	Fri,  4 Feb 2022 09:41:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A569F78C1B;
	Fri,  4 Feb 2022 09:41:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 917531809CB8;
	Fri,  4 Feb 2022 09:41:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 213JloKs009269 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Feb 2022 14:47:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 3F5662027EB4; Thu,  3 Feb 2022 19:47:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 385CF202717A
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 19:47:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 97FEA296B00B
	for <dm-devel@redhat.com>; Thu,  3 Feb 2022 19:47:42 +0000 (UTC)
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com
	[211.189.100.12]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-182-p5eu_14TNF-pJuics07Haw-1; Thu, 03 Feb 2022 14:47:39 -0500
X-MC-Unique: p5eu_14TNF-pJuics07Haw-1
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id
	20220203194738usoutp0276ca491d2bad9d5cad29a04a45dee11e~QXmaResRH2527725277usoutp02N;
	Thu,  3 Feb 2022 19:47:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com
	20220203194738usoutp0276ca491d2bad9d5cad29a04a45dee11e~QXmaResRH2527725277usoutp02N
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
	[203.254.195.111]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20220203194738uscas1p133248633a850023d76c05f5fdc1b8fa2~QXmZ_kaDi3190531905uscas1p1o;
	Thu,  3 Feb 2022 19:47:38 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges2new.samsung.com (USCPEMTA) with SMTP id 33.6C.10104.A513CF16;
	Thu, 3 Feb 2022 14:47:38 -0500 (EST)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
	[203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20220203194737uscas1p2d97def35481ec0e965e6dc6a15398e77~QXmZdB1uH2691326913uscas1p2H;
	Thu,  3 Feb 2022 19:47:37 +0000 (GMT)
X-AuditID: cbfec36f-315ff70000002778-cb-61fc315a6040
Received: from SSI-EX3.ssi.samsung.com ( [105.128.2.145]) by
	ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id 8B.17.10042.9513CF16;
	Thu, 3 Feb 2022 14:47:37 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
	SSI-EX3.ssi.samsung.com (105.128.2.228) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2242.4; Thu, 3 Feb 2022 11:46:47 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
	SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
	15.01.2242.008; Thu, 3 Feb 2022 11:46:47 -0800
From: Adam Manzanares <a.manzanares@samsung.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Thread-Topic: [RFC PATCH 3/3] nvme: add the "debug" host driver
Thread-Index: AQHYF5o0LMwUDmubDUu2kNRmd7lMHKyAS6yAgAI7QoCAAAKFAIAAN5GAgAADtYA=
Date: Thu, 3 Feb 2022 19:46:47 +0000
Message-ID: <20220203194735.GA249665@bgt-140510-bm01>
In-Reply-To: <YfwuQxS79wl8l/a0@bombadil.infradead.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
x-exchange-save: DSA
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTVxzHd+69vb2UgJfH5Mz+MUu2acShKDYnyHDZFnP3iHFbMIMtjm7e
	AJFnW6Z1m7zCXGEdUJFhYZMCKQgKDBl20scAERGd3WoBO3USAQNMKDjpysvRXkz63+d3vt/v
	yfd3cig8sIvcQCWnyVlpmiQllBQQHVee3Hw1PmJJsj33exI13S0mUbnDhaOZrgc8pC6u4CPr
	qD8yTlfykOW/XAw9aHuKIUONGkNnm3ox9LC+FiDlgAVDSyMRSN09CJDRHoYMxn4CndGN8VHR
	kJ5Epikjjur7VjA0XDIGUOm3Ngz9rlkiUc89G4GalhAq+M7FR5Pmg68LGeutd5nS/Gk+k199
	h2CsN7KYtkYlyVyoy2ZODtcDpvN2DsnkXe/FmYq5f0lm6PpFjFHlT5PM7JidYDpGVHxmxmQj
	mZZ2G7E/KF4QfYhNSf6ClW6LSRAk3TEUYhnN1NH+wlIyB+jJQuBDQToSDhovrbKACqTPArjc
	psXdQiBdgMGfrKJnprzWWwRnOg/gwP0xHjc4AHwy2wm4hBnAE0OZbibp7XCx72fPTcH0Zmgq
	UWHuAE63C2DnuHJVoKggOgZqXe9wnj1wrqdmzb8PrszZeW4m6JegtfRHD/vRu2Cf8qrH40OL
	4R83zmBuBvR66Lx2zsM4HQLto9w5pANgTaUB53g9XLk0srayCP7tnOBzHAybnY9ILhsOh0+V
	rXEMrFqyERyHQZ12Cuc6BMD+06MEl30BdjUMe14F0r8KoHKihccJb8GZyco1kxAu39VhnKkR
	wLL5b/jccAHAigULVgJe1ng113g10Xg10Xg10Xg1qQa8RhCSJZOlJrKyHWnskXCZJFWWlZYY
	/nl6ahtY/eUDKz3pejBknw3vBhgFugGk8NBgv8Pli5JAv0MSxTFWmv6pNCuFlXUDIUWEhvjp
	klslgXSiRM4eZtkMVvpMxSifDTmYULx7wREgFxclUJnChwdUC1vfdlw+ZfksM1ahysYi9Tno
	r/7H2Ea5bkIdG3Hf9Bpubr44JfyqN1oo+uC4M0qi+m3yzeVUOPbhjriQcq1Pg2rzldppNoLX
	N1+VcPl8XoelrG45LS5KfHA4u1nvFMvNRXrtoCNDYR5v3fr1kczxj/0LWubbTj7+aN/TxSh1
	00K8uvNY/dWaSNUrorD9zzfEtT/aa3KIN61L8hXUmdO3GRJHX1Rs2RVNHff7hA7yNf7zXmxd
	9Q/PubpSemodhGI3Xewfadlp2xjkm1sANq2zB4iqvnzjWo2os2/nLwf8/7xnA+8n7Dm99/Y5
	V8iJm8VHoxdDCVmSJGILLpVJ/ge4EQJSVAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sb0xTVxjGd+69vb00q1wKyBGnid1czMwqOFxODAOXDL2iMo2ZCbC03sgV
	CFC0hU3dvwpZEIRAmRDW1UEFC1LogG0KWUGhMGRo1dRKrdXBaLOgG3/NKrOBWa5L+u13znme
	3/t+OBQumRJEU9nKAk6lZHOlpIjI1mDat1Nj/WzMP96tyPSwkkS1s4s4mumfFKDqyjohsntW
	od7p7wTo9rPTGJrsWsaQ5UI1hi6ZhjD0Z3MjQKWjtzHkn4hF1QP3AOp1bUaW3hEC1Ru9QnR2
	rJtEfU96cdQ8vIQhZ5UXIO0ZB4ZsOj+JrI8cBDL5Efq6fFGIHl+V71jL2O/uYbTF00KmuMFN
	MPabhUxXaynJ/Nj0FfONsxkwv9zXkEzRjSGcqZt/SjJjN65gTEXxNMnMeV0Ec3miQsjM9DlI
	5oefHMT+8DRRfAaXm/0Jp9qScFiU5baUYcfM1ImRMi2pAd1kGQihIB0HizruEmVAREloE4DW
	P1px/jALoN7oFgRSEvoqgO1n1wWYpGPg8+FOPMAR9CbYV1WBBQo43SWCz5Y9L7QUFU4nQMNi
	Mp9JhPPWCy/zKXBp3rXiJOg3oF17foXF9DY4XHod52eVELDp+4IAh9Dvwjs367EAA3o19P3W
	tsI4HQVdHv4e0jRsstzCeY6EU5NLAp43wN99U0KeI6DZ9zfJd2XQWXPuJSdAvd9B8LwZGg1P
	cH6fMDjyrYfgu2tgf4uTqAJrdEGjdUEqXZBKF6TSBakagKAVRBWq1XmZJ9RbldynMjWbpy5U
	ZsqO5Od1gRe/cXTJmt4NHrjmZAMAo8AAgBQujRDn1D5nJeIM9uQpTpWvUBXmcuoBsJYipFHi
	qTStQkJnsgVcDscd41T/v2JUSLQGe3//WLhk3JAy0ZTiuG4r/ywmwrOxeDlmt/zxzkZfUeuC
	K11u86QXbdmZ4zh1ZN36yyNHD/svjYvCVJ+nHkrMN7ftbe/Zt/5no1hvku9uTBhceLg9HpvF
	UsP27LpWkvT6O6dVghlzqHLouKukZZdhfN/9yM7Xki1P3YNtnfFGln60ITdr1RWDYRAJt2X8
	mxkn3Oi2jSJpkkBzL/yDuVCZf1LRUaN3th1/D+v4MNp7pibtVaVdIjt/0ZTUkzhad/Ci71fr
	dmfo0dp0vfOja5Fs+5dhYrmtR5F6YEflx/17H8jqV7e8InizgT4Zb/Yu551bqKvaVH3oi/I7
	qltko+KvxeQ4KaHOYmPfwlVq9j+0L3Ec/AMAAA==
X-CMS-MailID: 20220203194737uscas1p2d97def35481ec0e965e6dc6a15398e77
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
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 213JloKs009269
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Fri, 04 Feb 2022 04:41:43 -0500
Cc: Vincent Fu <vincent.fu@samsung.com>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	=?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>, Bart
	Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	Chaitanya Kulkarni <chaitanyak@nvidia.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Keith Busch <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com >> Martin K.
	Petersen" <martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9A646861F09CB74EAB344C543E341AB7@ssi.samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Feb 03, 2022 at 11:34:27AM -0800, Luis Chamberlain wrote:
> On Thu, Feb 03, 2022 at 05:15:34PM +0100, Christoph Hellwig wrote:
> > On Thu, Feb 03, 2022 at 08:06:33AM -0800, Luis Chamberlain wrote:
> > > On Wed, Feb 02, 2022 at 06:01:13AM +0000, Adam Manzanares wrote:
> > > > BTW I think having the target code be able to implement simple copy without 
> > > > moving data over the fabric would be a great way of showing off the command.
> > > 
> > > Do you mean this should be implemented instead as a fabrics backend
> > > instead because fabrics already instantiates and creates a virtual
> > > nvme device? And so this would mean less code?
> > 
> > It would be a lot less code.  In fact I don't think we need any new code
> > at all.  Just using nvme-loop on top of null_blk or brd should be all
> > that is needed.
> 
> Mikulas,
> 
> That begs the question why add this instead of using null_blk with
> nvme-loop?

I think the only thing missing would be a handler for the simple copy command.

> 
>   Luis


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

