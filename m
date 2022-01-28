Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88022C433EF
	for <dm-devel@archiver.kernel.org>; Mon, 31 Jan 2022 08:31:25 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-PlLGRIieM1m4pMW7yuxfLQ-1; Mon, 31 Jan 2022 03:31:01 -0500
X-MC-Unique: PlLGRIieM1m4pMW7yuxfLQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F22B1F2DA;
	Mon, 31 Jan 2022 08:30:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E613E60C38;
	Mon, 31 Jan 2022 08:30:56 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1E4F41802E34;
	Mon, 31 Jan 2022 08:30:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
	[10.11.54.7])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20SK91EB011414 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 28 Jan 2022 15:09:01 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 593CE141DEED; Fri, 28 Jan 2022 20:09:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54383141DEE5
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 20:09:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 332B228F03E2
	for <dm-devel@redhat.com>; Fri, 28 Jan 2022 20:09:01 +0000 (UTC)
Received: from mailout2.w2.samsung.com (mailout2.w2.samsung.com
	[211.189.100.12]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-5-BdXxPh5ZN0uAvUpTDXDoLA-1; Fri, 28 Jan 2022 15:08:59 -0500
X-MC-Unique: BdXxPh5ZN0uAvUpTDXDoLA-1
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
	by mailout2.w2.samsung.com (KnoxPortal) with ESMTP id
	20220128195958usoutp02c0e46ba47e68ca09cf1b84efe722349d~Oh5d5bkbw0963609636usoutp02e;
	Fri, 28 Jan 2022 19:59:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w2.samsung.com
	20220128195958usoutp02c0e46ba47e68ca09cf1b84efe722349d~Oh5d5bkbw0963609636usoutp02e
Received: from ussmges3new.samsung.com (u112.gpu85.samsung.co.kr
	[203.254.195.112]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
	20220128195958uscas1p274d56b7f5a807ecb3d259126017ce3ce~Oh5dupTS50535205352uscas1p2Y;
	Fri, 28 Jan 2022 19:59:58 +0000 (GMT)
Received: from uscas1p2.samsung.com ( [182.198.245.207]) by
	ussmges3new.samsung.com (USCPEMTA) with SMTP id CF.D2.09687.E3B44F16;
	Fri, 28 Jan 2022 14:59:58 -0500 (EST)
Received: from ussmgxs3new.samsung.com (u92.gpu85.samsung.co.kr
	[203.254.195.92]) by uscas1p1.samsung.com (KnoxPortal) with ESMTP id
	20220128195957uscas1p1ce366917e0e2702ea61957a5221ae739~Oh5dP7WPA0942509425uscas1p1A;
	Fri, 28 Jan 2022 19:59:57 +0000 (GMT)
X-AuditID: cbfec370-9c5ff700000025d7-0e-61f44b3e1725
Received: from SSI-EX4.ssi.samsung.com ( [105.128.2.146]) by
	ussmgxs3new.samsung.com (USCPEXMTA) with SMTP id FB.F1.09657.D3B44F16;
	Fri, 28 Jan 2022 14:59:57 -0500 (EST)
Received: from SSI-EX3.ssi.samsung.com (105.128.2.228) by
	SSI-EX4.ssi.samsung.com (105.128.2.229) with Microsoft SMTP Server
	(version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
	15.1.2242.4; Fri, 28 Jan 2022 11:59:47 -0800
Received: from SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36]) by
	SSI-EX3.ssi.samsung.com ([fe80::8d80:5816:c578:8c36%3]) with mapi id
	15.01.2242.008; Fri, 28 Jan 2022 11:59:47 -0800
From: Adam Manzanares <a.manzanares@samsung.com>
To: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHYE018isCsN3oz40OdcqzMcXhV7qx5YsQA
Date: Fri, 28 Jan 2022 19:59:47 +0000
Message-ID: <20220128195956.GA287797@bgt-140510-bm01>
In-Reply-To: <f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
x-exchange-save: DSA
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA02Se0xTVxzHd+69vb10K7l0nZzCErJumG248pAt5w9lyFy8g6m4sGxxEdfN
	O+gGlbTiNhcyNgUVRR4jK9YYBBloQXQ8yqtllseqKPIoBeyGCwNFIAKtAhZZme2tCf99vuf7
	/Z3f9ySHwkV6MoBSKA+wKqU8RUoKCP2fC71vRcU9kodZ215AVaN5JPp13omjOdM4DxXmFfOR
	ZcIXGWfP8FDf458wNF67iiFDWSGGLlZ1YWiy8jxAK2PhqLB9CCCjLQQZjNcJVFJxl49ODDeR
	qG3GiKNKswtDBcesGLqlXSFRxx0rgapWEMo66eSj6T8SoyWMZTCOKTg8y2csPelMre44ydSV
	/8j8MlIJmNbbmSTz880unCl2PCKZ4ZuNGJN7eJZk7HdtBKMfy+Uzc21WkrlcbyWYuhs/xIt2
	CzbtY1MUB1lVaNTnguSHphaQ1rn1O2ujHmSC+k05gKIgHQlnmgJzgIAS0RcBPFtWBDiRhcHx
	gU7wLFRq2smdXwIwW2fBOWEHsM9xlODEVQDzXPVPHR+KpMPgE/PvHhbTMmi1jfDdIZwu8IE1
	mgaP8SL9AWy6koe5V4jpWFg+GMHlI+ClhRzCzQQdDA1FLcDNQvptuNy97GEfOgrOzpXw3Azo
	dXCpuxpzM077Q9tEiYch7QfLzhhwjtdBV8sYyfEr8J+lKT7HYliz9IDkZjfAc60OL0fB3u4s
	750hsKJ0Buc6+MHrpycIblYCTRdGPI+HdIMA/q1v9C7YCpuPrXo5EGqqLd6QDsCixWw+J+oA
	LF7uw/JBsHZNc+2aJto1TbRrmmjXNDkHeDrgn65Wpyax6o1K9luZWp6qTlcmyb7cn1oLnn7t
	G66OtCZgs9ll7QCjQDuAFC4VC4trHXKRcJ/8+0Osav9eVXoKq24HgRQh9RdWKK7IRXSS/AD7
	DcumsapnLkb5BGRikuN73ghnpf9V+w5f2NYlapDglEa5YXQqf3vQ7dbJr4Ot52M/emxxxiVG
	bm6sdn2RH69q7Dy947JfasZnmo3kzMHi0r3P9atrol9/Qlp3Pd8BbTt8yxNwekhT5UwezEgI
	zNtiHn9AB+le+xd0+cYyh3wKgvUnHHMRZ4cysjLEL13TRE6tf8doejgQeurD3xZPdYdN58bw
	Epaz+wXrc9sFhvzJ1JCTZr7t43v37t9/d1Ec88lXzfidoMSp5vmBeaHBvmXPNUlP9MtmxvZ+
	b0D4rluKT0MpyWbBkXjjUcXo6m6ntlCsl84eQZPkyHvKqxKX0T7BvLotJaa/p2taFhS68JeU
	UCfLw9/EVWr5/295zJ5JBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHKsWRmVeSWpSXmKPExsWS2cA0SdfW+0uiwex2NYvVd/vZLKZ9+Mls
	8f7gY1aLSf0z2C0uP+Gz2PtuNqvFhR+NTBaPN/1nstizaBKTxcrVR5ksni9fzGjx56GhxaRD
	1xgt9t7Sttiz9ySLxfxlT9ktuq/vYLPY93ovs8Xy4/+YLCZ2XGWyODfrD5vF4XtXWSxW/7Gw
	aO35yW7xan+cg6TH5SveHhOb37F7XD5b6rFpVSebx+Yl9R6Tbyxn9Nh9s4HNo+nMUWaPGZ++
	sHlcP7OdyaO3+R2bx8ent1g8tj3sZfd4v+8qm8f6LVdZPDafrg4QiuKySUnNySxLLdK3S+DK
	+HxwF2PBEZeKq9u3MTYwbrHpYuTgkBAwkVh40L+LkZNDSGA1o8Tu0/VdjFxA9kdGid87zzBB
	OAcYJXq2NjKCVLEJGEj8Pr6RGcQWEdCTuHrrBjtIEbPARE6Jt73rmUASwgKeEjs29DOBbBAR
	8JJYcsUIot5IYu3XLhYQm0VAVWLPlF1gM3kFTCV+nfrFCLFsIqPE6a8/2EESnAJ2Eu/ez2cF
	sRkFxCS+n1oDNp9ZQFzi1pP5YLaEgIDEkj3nmSFsUYmXj/+xQtiKEve/v2SHsEUk1n1/ywbR
	qyOxYPcnKNtO4vypVqiZ2hLLFr5mhjhIUOLkzCcsEL2SEgdX3GCZwCg5C8nqWUhGzUIyahaS
	UbOQjFrAyLqKUby0uDg3vaLYOC+1XK84Mbe4NC9dLzk/dxMjMAme/nc4ZgfjvVsf9Q4xMnEw
	HmKU4GBWEuGdselTohBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFej9iJ8UIC6YklqdmpqQWpRTBZ
	Jg5OqQamzbtmbjb/7VsZYqqxfc0LrpMO2/VMntxYx8hXnrmr4OmCeA+Gp1P8HvAU72DtOLdQ
	7mx9vUhDSMOqDMvFJ9seuuzq+fZk8d3331SnysxYv9drtXHOm3KWh5yaPdqnuuc7n8k7+7HF
	vMLXamXj2mcn0uTWBXhOl1jyOF16Q8Xn+KxYria7gg3Tv9drfoiyuL/PflrKjd9G0nkL09Pq
	/FXeTTnaclDD5oj6IdnJrPM7duYXfuX+714fr5jc6fAi5Ps7vw08vEF7ZJQX7jmUPfH+Ko8X
	gv92+PIonJrkpyb0OTrj+5Uds79JHOUVXsB/tj58S3aC1zxXfS1HgfmrHYTkYp/4X7jYvkwn
	wo8pR+aiEktxRqKhFnNRcSIAbkztBfEDAAA=
X-CMS-MailID: 20220128195957uscas1p1ce366917e0e2702ea61957a5221ae739
CMS-TYPE: 301P
X-CMS-RootMailID: 20220127071544uscas1p2f70f4d2509f3ebd574b7ed746d3fa551
References: <CGME20220127071544uscas1p2f70f4d2509f3ebd574b7ed746d3fa551@uscas1p2.samsung.com>
	<f0e19ae4-b37a-e9a3-2be7-a5afb334a5c3@nvidia.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20SK91EB011414
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Mon, 31 Jan 2022 03:30:51 -0500
Cc: "djwong@kernel.org" <djwong@kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"clm@fb.com" <clm@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com >> msnitzer@redhat.com" <msnitzer@redhat.com>, Bart
	Van Assche <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	"zach.brown@ni.com" <zach.brown@ni.com>,
	"dsterba@suse.com" <dsterba@suse.com>,
	"josef@toxicpanda.com" <josef@toxicpanda.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbus >> Keith Busch" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	Jens Axboe <axboe@kernel.dk>, "tytso@mit.edu" <tytso@mit.edu>,
	"martin.petersen@oracle.com >> Martin K.
	Petersen" <martin.petersen@oracle.com>, "jack@suse.com" <jack@suse.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	"lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <795CC14C0A3B064B8E80D872868A1CF5@ssi.samsung.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Thu, Jan 27, 2022 at 07:14:13AM +0000, Chaitanya Kulkarni wrote:
> Hi,
> 
> * Background :-
> -----------------------------------------------------------------------
> 
> Copy offload is a feature that allows file-systems or storage devices
> to be instructed to copy files/logical blocks without requiring
> involvement of the local CPU.
> 
> With reference to the RISC-V summit keynote [1] single threaded
> performance is limiting due to Denard scaling and multi-threaded
> performance is slowing down due Moore's law limitations. With the rise
> of SNIA Computation Technical Storage Working Group (TWG) [2],
> offloading computations to the device or over the fabrics is becoming
> popular as there are several solutions available [2]. One of the common
> operation which is popular in the kernel and is not merged yet is Copy
> offload over the fabrics or on to the device.
> 
> * Problem :-
> -----------------------------------------------------------------------
> 
> The original work which is done by Martin is present here [3]. The
> latest work which is posted by Mikulas [4] is not merged yet. These two
> approaches are totally different from each other. Several storage
> vendors discourage mixing copy offload requests with regular READ/WRITE
> I/O. Also, the fact that the operation fails if a copy request ever
> needs to be split as it traverses the stack it has the unfortunate
> side-effect of preventing copy offload from working in pretty much
> every common deployment configuration out there.
> 
> * Current state of the work :-
> -----------------------------------------------------------------------
> 
> With [3] being hard to handle arbitrary DM/MD stacking without
> splitting the command in two, one for copying IN and one for copying
> OUT. Which is then demonstrated by the [4] why [3] it is not a suitable
> candidate. Also, with [4] there is an unresolved problem with the
> two-command approach about how to handle changes to the DM layout
> between an IN and OUT operations.
> 
> We have conducted a call with interested people late last year since 
> lack of LSFMMM and we would like to share the details with broader
> community members.

Was on that call and I am interested in joining this discussion.

> 
> * Why Linux Kernel Storage System needs Copy Offload support now ?
> -----------------------------------------------------------------------
> 
> With the rise of the SNIA Computational Storage TWG and solutions [2],
> existing SCSI XCopy support in the protocol, recent advancement in the
> Linux Kernel File System for Zoned devices (Zonefs [5]), Peer to Peer
> DMA support in the Linux Kernel mainly for NVMe devices [7] and
> eventually NVMe Devices and subsystem (NVMe PCIe/NVMeOF) will benefit
> from Copy offload operation.
> 
> With this background we have significant number of use-cases which are
> strong candidates waiting for outstanding Linux Kernel Block Layer Copy
> Offload support, so that Linux Kernel Storage subsystem can to address
> previously mentioned problems [1] and allow efficient offloading of the
> data related operations. (Such as move/copy etc.)
> 
> For reference following is the list of the use-cases/candidates waiting
> for Copy Offload support :-
> 
> 1. SCSI-attached storage arrays.
> 2. Stacking drivers supporting XCopy DM/MD.
> 3. Computational Storage solutions.
> 7. File systems :- Local, NFS and Zonefs.
> 4. Block devices :- Distributed, local, and Zoned devices.
> 5. Peer to Peer DMA support solutions.
> 6. Potentially NVMe subsystem both NVMe PCIe and NVMeOF.
> 
> * What we will discuss in the proposed session ?
> -----------------------------------------------------------------------
> 
> I'd like to propose a session to go over this topic to understand :-
> 
> 1. What are the blockers for Copy Offload implementation ?
> 2. Discussion about having a file system interface.
> 3. Discussion about having right system call for user-space.
> 4. What is the right way to move this work forward ?
> 5. How can we help to contribute and move this work forward ?
> 
> * Required Participants :-
> -----------------------------------------------------------------------
> 
> I'd like to invite file system, block layer, and device drivers
> developers to:-
> 
> 1. Share their opinion on the topic.
> 2. Share their experience and any other issues with [4].
> 3. Uncover additional details that are missing from this proposal.
> 
> Required attendees :-
> 
> Martin K. Petersen
> Jens Axboe
> Christoph Hellwig
> Bart Van Assche
> Zach Brown
> Roland Dreier
> Ric Wheeler
> Trond Myklebust
> Mike Snitzer
> Keith Busch
> Sagi Grimberg
> Hannes Reinecke
> Frederick Knight
> Mikulas Patocka
> Keith Busch
> 
> -ck
> 
> [1]https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=3933d1bc-66a8e8f3-39325af3-0cc47a30d446-55df181e6aabd8e8&q=1&e=c880f1d4-0275-4c86-ba38-205de0f24f69&u=https*3A*2F*2Fcontent.riscv.org*2Fwp-content*2Fuploads*2F2018*2F12*2FA-New-Golden-Age-for-Computer-Architecture-History-Challenges-and-Opportunities-David-Patterson-.pdf__;JSUlJSUlJSU!!EwVzqGoTKBqv-0DWAJBm!BhtIUewpIpaTRbAVe6VvjiRs-431N4ehiLybkoGuMxLiIvcuYlijJGJWlXVggCI71vV3$ 
> [2] https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=e9dc0639-b6473f76-e9dd8d76-0cc47a30d446-03d65bc9ad20d215&q=1&e=c880f1d4-0275-4c86-ba38-205de0f24f69&u=https*3A*2F*2Fwww.snia.org*2Fcomputational__;JSUlJQ!!EwVzqGoTKBqv-0DWAJBm!BhtIUewpIpaTRbAVe6VvjiRs-431N4ehiLybkoGuMxLiIvcuYlijJGJWlXVggLInnHhS$ 
> https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=13eb47ed-4c707ea2-13eacca2-0cc47a30d446-3d06014a33154497&q=1&e=c880f1d4-0275-4c86-ba38-205de0f24f69&u=https*3A*2F*2Fwww.napatech.com*2Fsupport*2Fresources*2Fsolution-descriptions*2Fnapatech-smartnic-solution-for-hardware-offload*2F__;JSUlJSUlJSU!!EwVzqGoTKBqv-0DWAJBm!BhtIUewpIpaTRbAVe6VvjiRs-431N4ehiLybkoGuMxLiIvcuYlijJGJWlXVggJJSlhVh$ 
>        https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=8ba72fbf-d43c16f0-8ba6a4f0-0cc47a30d446-359457fd63a1a13d&q=1&e=c880f1d4-0275-4c86-ba38-205de0f24f69&u=https*3A*2F*2Fwww.eideticom.com*2Fproducts.html__;JSUlJQ!!EwVzqGoTKBqv-0DWAJBm!BhtIUewpIpaTRbAVe6VvjiRs-431N4ehiLybkoGuMxLiIvcuYlijJGJWlXVggGCerEbv$ 
> https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=75b96fa9-2a2256e6-75b8e4e6-0cc47a30d446-0403b00d6ff1bab8&q=1&e=c880f1d4-0275-4c86-ba38-205de0f24f69&u=https*3A*2F*2Fwww.xilinx.com*2Fapplications*2Fdata-center*2Fcomputational-storage.html__;JSUlJSUl!!EwVzqGoTKBqv-0DWAJBm!BhtIUewpIpaTRbAVe6VvjiRs-431N4ehiLybkoGuMxLiIvcuYlijJGJWlXVggK0Hp6vG$ 
> [3] git://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git xcopy
> [4] https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=3a49563e-65d26f71-3a48dd71-0cc47a30d446-3cecc3d55115742b&q=1&e=c880f1d4-0275-4c86-ba38-205de0f24f69&u=https*3A*2F*2Fwww.spinics.net*2Flists*2Flinux-block*2Fmsg00599.html__;JSUlJSUl!!EwVzqGoTKBqv-0DWAJBm!BhtIUewpIpaTRbAVe6VvjiRs-431N4ehiLybkoGuMxLiIvcuYlijJGJWlXVggPvo936U$ 
> [5] https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=910e6991-ce9550de-910fe2de-0cc47a30d446-c412c0c3c4c51c2b&q=1&e=c880f1d4-0275-4c86-ba38-205de0f24f69&u=https*3A*2F*2Flwn.net*2FArticles*2F793585*2F__;JSUlJSUl!!EwVzqGoTKBqv-0DWAJBm!BhtIUewpIpaTRbAVe6VvjiRs-431N4ehiLybkoGuMxLiIvcuYlijJGJWlXVggIprHJMJ$ 
> [6] https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=0ab886e2-5523bfad-0ab90dad-0cc47a30d446-df0ae4acca6d59f2&q=1&e=c880f1d4-0275-4c86-ba38-205de0f24f69&u=https*3A*2F*2Fnvmexpress.org*2Fnew-nvmetm-specification-defines-zoned-__;JSUlJQ!!EwVzqGoTKBqv-0DWAJBm!BhtIUewpIpaTRbAVe6VvjiRs-431N4ehiLybkoGuMxLiIvcuYlijJGJWlXVggB4MUwfa$ 
> namespaces-zns-as-go-to-industry-technology/
> [7] https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=44a1a51b-1b3a9c54-44a02e54-0cc47a30d446-8577b144c92493eb&q=1&e=c880f1d4-0275-4c86-ba38-205de0f24f69&u=https*3A*2F*2Fgithub.com*2Fsbates130272*2Flinux-p2pmem__;JSUlJSU!!EwVzqGoTKBqv-0DWAJBm!BhtIUewpIpaTRbAVe6VvjiRs-431N4ehiLybkoGuMxLiIvcuYlijJGJWlXVggEa99Fso$ 
> [8] https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url?k=0745845d-58debd12-07440f12-0cc47a30d446-53178030a251a9d8&q=1&e=c880f1d4-0275-4c86-ba38-205de0f24f69&u=https*3A*2F*2Fkernel.dk*2Fio_uring.pdf__;JSUlJQ!!EwVzqGoTKBqv-0DWAJBm!BhtIUewpIpaTRbAVe6VvjiRs-431N4ehiLybkoGuMxLiIvcuYlijJGJWlXVggJUxR2B3$ 


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

