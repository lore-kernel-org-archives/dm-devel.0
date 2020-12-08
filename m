Return-Path: <SRS0=ZVdP=FM=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8585BC433FE
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 08:41:14 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id C4F97239E5
	for <dm-devel@archiver.kernel.org>; Tue,  8 Dec 2020 08:41:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4F97239E5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-496-eHiPanFdM7iRDpW4ZjMXfQ-1; Tue, 08 Dec 2020 03:41:09 -0500
X-MC-Unique: eHiPanFdM7iRDpW4ZjMXfQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A1858797DC;
	Tue,  8 Dec 2020 08:41:04 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B597F6E519;
	Tue,  8 Dec 2020 08:41:02 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8D8795002C;
	Tue,  8 Dec 2020 08:40:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B88erkQ020557 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Dec 2020 03:40:54 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id C770E2166B2D; Tue,  8 Dec 2020 08:40:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BEC5B2166B27
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 08:40:49 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 308BF100FBC8
	for <dm-devel@redhat.com>; Tue,  8 Dec 2020 08:40:49 +0000 (UTC)
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-348-1-IyqrdEMRKsHBs8zaHTog-1; Tue, 08 Dec 2020 03:40:46 -0500
X-MC-Unique: 1-IyqrdEMRKsHBs8zaHTog-1
IronPort-SDR: tojNOJt2/GDmvfTULsY7Ex+RMhlRTsTML9USz2vIZiyw6YP0ug5Nj0LiYqSToLVdZnfbnlJ01C
	Zqq4GN+UDmAnj55Z252fju5xUXm31QJ2qlPJTCCAXNmtfLbbbpVz3umjXYMsDDMCX21IZu2sx+
	xV12+JBmTtddJYCPBndQDKz5+3hLqCMfq6flxBC3gPh+XZjSBPR/Cjko3rXN/bQUTlhWKylA1E
	UA6ocLNWddRQ9DHKyDFFjlWK6/af/txty7pFPRtx+G0RAoLUxJYcyR+KcSWLcOaB6LgfqytMEh
	Sio=
X-IronPort-AV: E=Sophos;i="5.78,402,1599494400"; d="scan'208";a="155882990"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO
	NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
	by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2020 16:40:44 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4685.namprd04.prod.outlook.com
	(2603:10b6:805:b1::23) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17;
	Tue, 8 Dec 2020 08:40:42 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%6]) with mapi id 15.20.3589.038;
	Tue, 8 Dec 2020 08:40:41 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: =?iso-8859-1?Q?Javier_Gonz=E1lez?= <javier@javigon.com>, Hannes Reinecke
	<hare@suse.de>
Thread-Topic: [RFC PATCH v2 0/2] add simple copy support
Thread-Index: AQHWyi08xMuKL73ZZUaIarInYKlQvg==
Date: Tue, 8 Dec 2020 08:40:41 +0000
Message-ID: <SN4PR0401MB35988951265391511EBC8C6E9BCD0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
	<20201204094659.12732-1-selvakuma.s1@samsung.com>
	<20201207141123.GC31159@lst.de>
	<01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
	<20201207192453.vc6clbdhz73hzs7l@mpHalley>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e6232f46-9985-4873-c699-08d89b54f26b
x-ms-traffictypediagnostic: SN6PR04MB4685:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB468539606AEF3F2222671E649BCD0@SN6PR04MB4685.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 3LGgpj+gCMajQIOvXv6NE2Yvr+S+Q1P66exy7VZIj3v+SYh7buoJLneeyRfyXroNOn0ztxHnYA8vEr1ClPe0qtqyKg6zwndfc7fjEDhnH5PcwJ2Vqkre7QfkGd3FGHs43tmOlH+vxomkrEBmAlw4l8bLR1bdhC1K1BFV57Zz9cd4VVmBrVrZ7qIhTzjCioerRdgJhT4e3hYc4Xty/+N4Rm5BwoE1ni6660ItRIEY+LUNwJ9Nf3ePK+ogGWv/2zjIQQMnWUUET4vtDfakzNClhKVEAsPsbzKF5t6xUPv4W9RNkeJ9x+Za/NUlL/tMius2IdEHBpVPdaxQcDgOFsVi7Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(366004)(39860400002)(396003)(346002)(376002)(136003)(8936002)(83380400001)(66446008)(66556008)(316002)(53546011)(2906002)(33656002)(76116006)(26005)(5660300002)(6506007)(91956017)(64756008)(4744005)(55016002)(86362001)(66946007)(52536014)(54906003)(186003)(7696005)(66476007)(110136005)(71200400001)(8676002)(478600001)(7416002)(9686003)(4326008);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?zdk5Tt2WBtEqw48/dhHoSqKtOC7Mkap7mP7x02BhRb89x9Kz0r/A/dL+Hl?=
	=?iso-8859-1?Q?rMQJtq2xoyEAEAC3TH50VDGdKV68nYZgHE61YJmm2UwpotHzHfN2Wq3MLD?=
	=?iso-8859-1?Q?yMlanT8t0mNBPxLXulRU/JWfxISYV0/55ep+vEMLLskBC283HvHmw/QXxF?=
	=?iso-8859-1?Q?Ix6Q8BLzRZT4FH2KsXYdl547KhMIK/3PXYdayMBj/f6ZxY9EHdCIW38C3L?=
	=?iso-8859-1?Q?g1aH96mu9Y/l0ovlRxm9w4zSsGWSxdba8aNwwki7+njchhG0IbpyzbMPaf?=
	=?iso-8859-1?Q?Ayvegty6B08b3sCJwkGf2x5XgCsXpyegpyC476RKA2Z20V6Ck0W6aZNn4P?=
	=?iso-8859-1?Q?4rNGres69GcVpStqKpKeFziHwIJVSKL7ZLBPeyvezic/FKJsP0yXWUZM3Y?=
	=?iso-8859-1?Q?3M+E5vBO4FMgyRElazMRlcfYLHw/Os5FDDI6Thq6dAaguKL4aslRxGeiZd?=
	=?iso-8859-1?Q?c/5zNMd1Jg9Z6quL1+z6MbakacoBsBIosX9JJSANI2Gbe/pdyIU5VzkdEG?=
	=?iso-8859-1?Q?GyIth7tDCkEUMG62a7FKVD+ivUfYZ2NmdEo9B9ra2gFL7jeF1b5KanEw/Y?=
	=?iso-8859-1?Q?hXYMzUfdHIdFZjzeJhGZLwY730JhAP+mKFFiVHIFAmeiLlL1x9EIPCs0Qd?=
	=?iso-8859-1?Q?q+Uy38r8I8CyxPMi2AbWzGMjpE24lWeFScvSjE1pri5wMc8QmT+yCJyJb/?=
	=?iso-8859-1?Q?+EDO5md1Ra5bFA21pLUa9An45rfBkgzUWFeHftnS7VGTpx/Ye4VEHW/0vz?=
	=?iso-8859-1?Q?L0aS0WUfsS7kPq9ivP6hWjKRrAYD5Y/ez2lJx0pWMXe3ZFkoftJDAteUaG?=
	=?iso-8859-1?Q?/y/w02L7j9LfWvvEG3mBSeCdK3Co8sTCRpdo79HoK9BqS7UXsOqsIQ5I6B?=
	=?iso-8859-1?Q?diE8N0Uniq6A+RUKqWDTTEsl+rcOyeGEORBesZuv9fVXvRLfd/OhsgV806?=
	=?iso-8859-1?Q?xUdRZRc/aWJlPIWZdUpaRicDd30S6VPk9ydrqyTI7OSTn1JjPhCpa2E9W+?=
	=?iso-8859-1?Q?CAvpfN2l7wdsgkfWfyMxtFyoJfG6UsT3TTY60m?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6232f46-9985-4873-c699-08d89b54f26b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2020 08:40:41.8083 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G5f3SENs6K3SN1aPr2ineoVlrRSyV7/y9Og3cAswZBquhygTMpX45newZQyzpPDZnTOqJ4hXAboptAb7uqc4chBEDr7rMPngq6rkla6rsm8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4685
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B88erkQ020557
X-loop: dm-devel@redhat.com
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Damien Le Moal <Damien.LeMoal@wdc.com>,
	SelvaKumar S <selvakuma.s1@samsung.com>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"snitzer@redhat.com" <snitzer@redhat.com>,
	"selvajove@gmail.com" <selvajove@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"nj.shetty@samsung.com" <nj.shetty@samsung.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Patocka <mpatocka@redhat.com>, Mikulas,
	"joshi.k@samsung.com" <joshi.k@samsung.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"kbusch@kernel.org" <kbusch@kernel.org>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Christoph Hellwig <hch@lst.de>, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [dm-devel] [RFC PATCH v2 0/2] add simple copy support
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On 07/12/2020 20:27, Javier Gonz=E1lez wrote:
> Good point. We can share some performance data on how Simple Copy scales
> in terms of bw / latency and the CPU usage. Do you have anything else in
> mind?
>=20

With an emulation in the kernel, we could make the usd "backend"=20
implementation configurable. So if the emulation is faster, users can selec=
t
the emulation, if the device is faster then the device.

Kind of what the crypto and raid code do as well.

I'm really interested in this work, as BTRFS relocation/balance will have=
=20
potential benefits, but we need to get it right.



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

