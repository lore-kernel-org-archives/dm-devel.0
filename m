Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3695EC47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:19:59 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BF44C6136D
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:19:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF44C6136D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-OxBhbATOPLifQ9kj5XT4cw-1; Tue, 08 Jun 2021 14:19:56 -0400
X-MC-Unique: OxBhbATOPLifQ9kj5XT4cw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E142180FD64;
	Tue,  8 Jun 2021 18:19:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E6FF5D9C6;
	Tue,  8 Jun 2021 18:19:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2870744A59;
	Tue,  8 Jun 2021 18:19:50 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158IJm0V031292 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 14:19:48 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1E7F9208DDB2; Tue,  8 Jun 2021 18:19:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18BED207AD3B
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:19:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C6B1B1825064
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:19:44 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-261-UPY_00fZMbqbVqcxxavGQA-1; Tue, 08 Jun 2021 14:19:41 -0400
X-MC-Unique: UPY_00fZMbqbVqcxxavGQA-1
IronPort-SDR: +fHlzF2yXWplSemJ6dhsII8kPzEu/8ZDHsX2UrS1Yj+P4+ghpak9VdbBulhYxHRrw5fH0lC4M7
	nrUWCFl6OftbV4u2ppVxOeZrROtEcupG67NOZiPpXptDMJwDU4coXWzGpTCS3Wf0kG6Yj9AnXw
	k5/DqCcKJOglqAwQrwCu7neMIB684TNlEzPhdyH1U3B7StR9wDcpd5XUzrqwMbKv70Tcyb8OkW
	MDyV8ytJt4s3zlu4Mc1mSjCNfthBWo7WRaeCAs+2fQisBjNcb7dQ9eYDeLSJml4W0eFakaqAeH
	/pY=
X-IronPort-AV: E=Sophos;i="5.83,259,1616428800"; d="scan'208";a="171733800"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
	by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2021 02:19:39 +0800
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
	DM6PR04MB6282.namprd04.prod.outlook.com (2603:10b6:5:1ec::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4219.20; Tue, 8 Jun 2021 18:19:37 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f]) by DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f%7]) with mapi id 15.20.4195.030;
	Tue, 8 Jun 2021 18:19:37 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 06/16] block: use memzero_page in zero_fill_bio
Thread-Index: AQHXXIBUmy2U+nAl70mrg5B0bpc0fw==
Date: Tue, 8 Jun 2021 18:19:37 +0000
Message-ID: <DM6PR04MB4972C1D2BDAC6DD3E58078DE86379@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-7-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d24778ef-bfcf-4314-b542-08d92aa9f9bf
x-ms-traffictypediagnostic: DM6PR04MB6282:
x-microsoft-antispam-prvs: <DM6PR04MB62824F83457091758F77CD2A86379@DM6PR04MB6282.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4303
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 85OJgdQxhcDjEF7qO1pz2Zn2kqmwgjT+IuMQgPALiNTP9UGRnLhXQ9de405OPeiL89dVbw3+ZZ8hlsnVktJ0uc8PbGRPHSSr42wqujzy+tvUtCdKhffQgb58qsUf/kg/9V+xNGf+OQ8QY3arFkNYveDO/8sp02ajQs5DBNCLa9dD6FMy9OYcC3kPEfLpUyzXznr+Hcno2uUGp0V9Sl/Y4Te8YqgxXxt4+/b3AfsOwkwQpJAGoK/V8EhGj8UlH2K+CA+kHgecBo+5fd5yNAT8W79Sjvq8j4cDtG0axNL5C1FGY2ERnH3vfaB6qTz2IQv0hhJyBp5oLxqSgzu/EYYo+M7zDOaKBPr4cFuF1xuPmp9jgqdJVav6dqydikwWzXjEHtxtNRwNs9qHLH9Fq574YMtZ2wzYDOPDU4M3//0SdCXJ31eXe5M2muybVlXiyt5UawroDyrwmhIhAp2IzvSIBK0fVt5yngZ47qyQwgKFmRiMYutu3p9b7AoCJglYjS8NAlLZjSGYgX0+UI04fxOCToXI8jGWXBp5R917gVjSPQMU0wAHLwL7feQVqHyzml1pkleRc1mt8l2thRQSl7T4CsWJRKGtgfEzqpU7aRJlHRg=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB4972.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(366004)(39840400004)(136003)(346002)(376002)(66946007)(91956017)(76116006)(52536014)(7416002)(86362001)(558084003)(66556008)(33656002)(64756008)(54906003)(4326008)(66476007)(66446008)(38100700002)(5660300002)(316002)(110136005)(122000001)(6506007)(8936002)(9686003)(7696005)(55016002)(26005)(2906002)(478600001)(53546011)(8676002)(71200400001)(186003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hp3T8BSX3nBFvTSG1y6DETvLbLZFQT/eejvS6X8nIrU/5zstlFkj7epBQkAJ?=
	=?us-ascii?Q?6Jumm9kY90mHkPQP7cwQncXZYLmgiR45X/8oLCFuk66Eu9jcRoKWevaoRabv?=
	=?us-ascii?Q?DcRinoEysN8sSp1cg9zR5Mei+ySeXUTSvoow6o2tX+88H7izO0Kbl/KfAxId?=
	=?us-ascii?Q?XzgT7CLTEU7psACbLDWrVz2wn9h5qfv/Zm3Rfwox1zXIRFRThdL97g+DFP2c?=
	=?us-ascii?Q?fWrCuae0XvdHquW425TwgDdARELsbikFpzj960cJhCBcgGnFcUmgAUpglRwJ?=
	=?us-ascii?Q?VUkPDA/z1Sgr3mfDThmze0ngnQd1d6g+wrhVifaR9mzKJU3Q5fOzDXtI4rYQ?=
	=?us-ascii?Q?K9loksHh7zNu/zzsr2VaFkkcxz95Hkq+pU9h8+vSnm8/tB3hB99lZnHGXafv?=
	=?us-ascii?Q?tPE6hSrLNs9T4Oq6uMqrS31f/e/aXTGB4V545rXMrWUAaSoeBil+KnXIlK1B?=
	=?us-ascii?Q?5+mw29meiZv6Uu2/wgVkcoSqQW94TRlL+fIZJf84kfWTwHJyQv7nvJ2JVNIR?=
	=?us-ascii?Q?YIU/47HSab/btdIJkPX+fq9zm4PsKCJRbG6V3ZF7lZGRB/YMbrMvQeGWgtEV?=
	=?us-ascii?Q?37loYDWp9M7TczEcCmeoJV50hZlzOgTh1hhl19v3dRmo0CLfO16VlxasZex5?=
	=?us-ascii?Q?MSEIVCUSOzxHzzm0cVrlMPx//xsS6Xh/+89j6Z3cmSCzgR0AA+L/yKPNleKQ?=
	=?us-ascii?Q?l/NjBIYKbL7E12n6Rz+R6H1hIRLuGX+5CamdHWkUlN8xB6ck5Bm60trhhzkH?=
	=?us-ascii?Q?FkEX/Jw99DJj9o74l1c5SAEeoA3Fe0Cnh8nge692sNfaOFiSlixzwMmwuS69?=
	=?us-ascii?Q?fTRcqbUbTu+fVGPSufwZjvi8OnrxmS22500XAkAuaYDlBKuopRHs2J8qU3no?=
	=?us-ascii?Q?10VIZUNa59dXYDV+Y8Y7vmKywikm3L+Ldj+DsW6pmOAjR/SqKqJbi9kB63vL?=
	=?us-ascii?Q?1r9g7uZvSliFnXqpmvBxqESibuv0uJmygsWxcWNzpiQ7BSmUM90Xzf8H5qTh?=
	=?us-ascii?Q?8P47zbrJ+ENviodj5AWeqNiYM5EqRFp8mW2HNkPtLxKRxpYsUsACfqkWh/fc?=
	=?us-ascii?Q?b3KFxN2/lbKncRnHFxTdGm4QP04QbMJmvKwZXgqYzqZ+TsJNt4wacWolm1Gp?=
	=?us-ascii?Q?Q8Lh1/mOXlm3de2S6xQBG4KGA4h/U5suw4in1OPCPe4CbDzyWRf07q5ILyAI?=
	=?us-ascii?Q?AXh19FYDOTsnFiNvxtBQMj5C1cDobYrqH1t2l2826OwKK0F5nMqan53qzqg/?=
	=?us-ascii?Q?s7kDlq4mt4pmFCjJ9Q4GOXFfN+ouGF3obqAgwEgW1TNNSYU+MLY1V35hx+XK?=
	=?us-ascii?Q?bw31S1ytSk0LLaGrzgiU4ei9?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d24778ef-bfcf-4314-b542-08d92aa9f9bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 18:19:37.6176 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y3zuJWkkTGQfBpuTohCAXSfWjyUQiBndJzbV130rtAGe2JLR6pb90J463LWJpWNl8ZGbFB2qGgvSh/2BeYvS7/Px52fLJrqaCs5fgc6HhPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6282
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 158IJm0V031292
X-loop: dm-devel@redhat.com
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Mike Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>, Ira Weiny <ira.weiny@intel.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 06/16] block: use memzero_page in
	zero_fill_bio
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/8/21 09:07, Christoph Hellwig wrote:
> Use memzero_bvec to zero each segment in the bio instead of manually
> mapping and zeroing the data.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>





--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

