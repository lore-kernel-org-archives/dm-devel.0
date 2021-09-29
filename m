Return-Path: <SRS0=53Ra=OT=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB71C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 29 Sep 2021 06:45:53 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8DD76613A7
	for <dm-devel@archiver.kernel.org>; Wed, 29 Sep 2021 06:45:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 8DD76613A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-253-p3BazIXCOvS_0LiRTcsi_A-1; Wed, 29 Sep 2021 02:45:49 -0400
X-MC-Unique: p3BazIXCOvS_0LiRTcsi_A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E218802947;
	Wed, 29 Sep 2021 06:45:45 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F177718EDF;
	Wed, 29 Sep 2021 06:45:44 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C02964EA30;
	Wed, 29 Sep 2021 06:45:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18T6jgRi021601 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 29 Sep 2021 02:45:43 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id CB9D2D7DFB; Wed, 29 Sep 2021 06:45:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C49ACD7E13
	for <dm-devel@redhat.com>; Wed, 29 Sep 2021 06:45:37 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A1DF811E78
	for <dm-devel@redhat.com>; Wed, 29 Sep 2021 06:45:37 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-562-_YU8z87qP1-8CKufTQSm4w-1; Wed, 29 Sep 2021 02:45:34 -0400
X-MC-Unique: _YU8z87qP1-8CKufTQSm4w-1
X-IronPort-AV: E=Sophos;i="5.85,331,1624291200"; d="scan'208";a="285072411"
Received: from mail-dm3nam07lp2043.outbound.protection.outlook.com (HELO
	NAM02-DM3-obe.outbound.protection.outlook.com) ([104.47.56.43])
	by ob1.hgst.iphmx.com with ESMTP; 29 Sep 2021 14:44:26 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7352.namprd04.prod.outlook.com (2603:10b6:510:1a::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15;
	Wed, 29 Sep 2021 06:44:22 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::5d0d:3d52:2041:885a]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::5d0d:3d52:2041:885a%4]) with mapi id 15.20.4566.015;
	Wed, 29 Sep 2021 06:44:22 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier.gonz@samsung.com>
Thread-Topic: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Thread-Index: AQHXRfrE+mT6pvaiwEOWn89Dsv4XaA==
Date: Wed, 29 Sep 2021 06:44:22 +0000
Message-ID: <PH0PR04MB7416C6D3E446DE6CFFABC5C39BA99@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
	<PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
	<CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
	<20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd3482f7-e6a0-4889-afce-08d98314921b
x-ms-traffictypediagnostic: PH0PR04MB7352:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB735289F97E18FAFC64A65DC69BA99@PH0PR04MB7352.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: XgIOrqvE/Cc2h7XPGFM8SHpVE8xFu139tuBEj70o//6OYcjYpSabJJKs8vskNAE8KM+alH5G+pkgQkqASqeCEk6k8a390sg3fCK1rcVULO3Q2XVDs0H8fqXHN+ryvRR8ldKyisJDyxifWIqDlsRUNnx99eJ2yEfAq3ULGBtlZwY/TjySt59+QqsqIAtdJ02c0DwRb5K/QwdnTtefY+uo+/6X1q03qehK9SJvJdZsU61CNUonsDTvQ/8oXuL3Ea1vjPopMs2dGtzjam0ZE4AVAwcB8A4OcCZsZEpsvtK0qJLAn7tIywXmwqOHEXPIEEKmYPz5Ui1GxahG4EKNMQojZiDZxLDM0W/t0p2/GuysaJ9qo6q6kuwb8nIroCC7L2EDzmF1AndjX/SGm4bepsaWIZbPNwfQC031oqTY7Z9dOHV2l88dNTVUULOHZsc/MFS1Nd4kM3LgmY+A/B/HqodBoth78oVgSmE4CwEDonpJOUn+ZClB5a7AOQXQuNhop/U0upBR9xMuaBclwgLkqlZshAwqUypDAd915TSerfN+a5apliuOeWNFDehbMmgWaMTfTOX/sQwl7D+3tV0cwTIlCjl2H2Ayt+Pxx0+h82EuGU1jSOW2hxtr/QToaCEOB58zVg4/RBwoSx0aDHIKlIhDZ7BDRmoH8sPrt6m1Myjd+judsQfqvyAnxx/Wg73DHMwuOWXHfbPSexbR2CMUIO5qXA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(4326008)(8936002)(91956017)(6506007)(186003)(54906003)(316002)(53546011)(71200400001)(76116006)(8676002)(86362001)(2906002)(5660300002)(66446008)(66476007)(66556008)(64756008)(122000001)(52536014)(508600001)(38100700002)(7416002)(4744005)(7696005)(6916009)(38070700005)(55016002)(33656002)(66946007)(9686003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?3zfCM9fxj5Ip3evj7FIt1xvlD3T2pEczqwvU2iyf+L9FylO8r/PWggLFZ0?=
	=?iso-8859-1?Q?F3yjxixO5wh3vSPb3OouMhL3Fh0Edugz+4d8VMHtRKSOKqgAXPZ0Z7i0rr?=
	=?iso-8859-1?Q?odGOU6w0Ytbdj33j1BXFe/1quUANcsWSz7ujo58v0jytCjTSF+Tb8yaFIA?=
	=?iso-8859-1?Q?lzTXzgDjGiJFnN8c4R0Z5d0HuiKljEbYf/XFw8PaxCTpuKQaH6OYuAQa0R?=
	=?iso-8859-1?Q?IVWRsk0/HLyB++r9ICf3PX/+ZwDuWaJDtHabfzpybhz0kz2mdmPFziB5HH?=
	=?iso-8859-1?Q?LmwmySHbaOdYpfwY8P743DhAIz/3lwtWYhA+aTb96CAEe0XhVYdaNoQt/p?=
	=?iso-8859-1?Q?KkZgTXT7er6RqZiL2DHyG4zY2zlbp49ig/0JTtiXxcAP7pQS4pLOlEijUL?=
	=?iso-8859-1?Q?BeqoZAuO5RxgCELLxwi0Pb7HHkbwn6fPgrkFTT2Q81YuGWoNTxjmvJkEQC?=
	=?iso-8859-1?Q?nRwAGjFCrQ+3x3nduKsQHXj5POlWfR8Jl98lp8jIFbouklsHAc8cdefL25?=
	=?iso-8859-1?Q?5Ao/6rQ+BK8hSVKcMyZrERaAoEM9rXF7JoQi3wFrz8FmESu+ISmckNG95o?=
	=?iso-8859-1?Q?2vgAH4YIJN0vbWuecb3Ty6qNXKMm53a7QyhoSy9EsjglHvuycrGcOmlj2c?=
	=?iso-8859-1?Q?65wzj7ycBiYAwzuhUoIj59zvYS6Qu7sLWHpC3Yh3GtxSqT3xxJIxU+voZr?=
	=?iso-8859-1?Q?0PdqVsM1FTuWWstq8Z+iIIEAgkgqTe0zw/6csCtbfNsNa+CvC9m4j7/JKg?=
	=?iso-8859-1?Q?guxZhMgR7xMVi8tFnjy6wNMNi6ZggBTDBCimUz1h2ELZPSSqK49fw0mSp1?=
	=?iso-8859-1?Q?4hfXaSoUp09KlFSkt/5jwF7jaebpMxlIFyFwUkGlEaXvca9NgzCTAhjLUO?=
	=?iso-8859-1?Q?3ImAL4gx60WVyHGZiOBHklt9Ct+8DTkV/zP0cKWxIOWdRoyve/3x5r2yOk?=
	=?iso-8859-1?Q?LG9Li4/T8oIO1PvNmYiGgDGGzgSjiRpyUXHnApYvTuvJBrhkmNu2ZSnu+T?=
	=?iso-8859-1?Q?1irFze/+/bH/gzrYeMdzXR0dMviqisn+5vFm30bLPkGZx3ass2QdH8uJHR?=
	=?iso-8859-1?Q?bUTbEufDynXIm1uD4FiituW5DXq4mr4JSHTIh2o46zM4brH2XBwV2sIwXm?=
	=?iso-8859-1?Q?DGejF732H+5gDHzEAKPROT6fqCc40wpGZmn1n2Ouz+3/Vc//d6I69U4jXE?=
	=?iso-8859-1?Q?8BGIow+748JTMAfkGVrGAhXWL4SF7+66tjPYgj9qsgWH45i8yfeUwGeavN?=
	=?iso-8859-1?Q?fqji5Y1jKCSLHVMUP5538CWqxrj1dMfiQPUxyBmwi9PHNaKCVe5ju1WkAE?=
	=?iso-8859-1?Q?sU6P1TUOZK5Fcu7pGrsqvLnKsnu5n5KPCc6bonMr6dwt7z23Hz+7LWy2hz?=
	=?iso-8859-1?Q?zuVQxcjLeqyw9YwZGJHF8jv1VA1ChDZQc99kGdqTaJB7QFZTVnEWPS/byM?=
	=?iso-8859-1?Q?lOe5FmOwwbPiS9PCdFAqASlq5tFUdrK01y0sdw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3482f7-e6a0-4889-afce-08d98314921b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2021 06:44:22.1208 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CqT0HiC8Tmmp0wANKmEU2jWJwK40hwfut+1VBNn7LflXYlh5nf/nixeOh37O2HQuIhmdinODpDDXZniqlDKKohC7zvzUmyl053Qwc0yT928=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7352
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 18T6jgRi021601
X-loop: dm-devel@redhat.com
Cc: Nitesh, Fu <vincent.fu@samsung.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Adam Manzanares <a.manzanares@samsung.com>,
	"osandov@fb.com" <osandov@fb.com>,
	"msnitzer@redhat.com" <msnitzer@redhat.com>,
	"bvanassche@acm.org" <bvanassche@acm.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	"hch@lst.de" <hch@lst.de>,
	"roland@purestorage.com" <roland@purestorage.com>,
	Shetty <nj.shetty@samsung.com>, "zach.brown@ni.com" <zach.brown@ni.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"mpatocka@redhat.com" <mpatocka@redhat.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>, Vincent,
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 28/09/2021 21:13, Javier Gonz=E1lez wrote:
> Since we are not going to be able to talk about this at LSF/MM, a few of
> us thought about holding a dedicated virtual discussion about Copy
> Offload. I believe we can use Chaitanya's thread as a start. Given the
> current state of the current patches, I would propose that we focus on
> the next step to get the minimal patchset that can go upstream so that
> we can build from there.
>=20
> Before we try to find a date and a time that fits most of us, who would
> be interested in participating?

I'd definitively be interested in participating.



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

