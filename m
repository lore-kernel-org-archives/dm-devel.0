Return-Path: <SRS0=BzfN=LC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F91C47082
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:18:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 44D5361376
	for <dm-devel@archiver.kernel.org>; Tue,  8 Jun 2021 18:18:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44D5361376
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-RPX47R6aN3OWiM74KqcbCQ-1; Tue, 08 Jun 2021 14:18:38 -0400
X-MC-Unique: RPX47R6aN3OWiM74KqcbCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 59E8D1927801;
	Tue,  8 Jun 2021 18:18:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D74AC5D6A8;
	Tue,  8 Jun 2021 18:18:33 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id A1B0C1800BB4;
	Tue,  8 Jun 2021 18:18:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 158IIV9E031072 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 8 Jun 2021 14:18:31 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 6C154208DDAA; Tue,  8 Jun 2021 18:18:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6678E208DDB3
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:18:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5341182506D
	for <dm-devel@redhat.com>; Tue,  8 Jun 2021 18:18:24 +0000 (UTC)
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-265-fJKBFuGkNlGc12fw--tjDA-1; Tue, 08 Jun 2021 14:18:22 -0400
X-MC-Unique: fJKBFuGkNlGc12fw--tjDA-1
IronPort-SDR: fn/NS5ty5hBQPitU3+ISghDbUEw7gtK1y1+W7nQuQRx4Lp23+aaPk9ALxlcFYx1RiG6C0iy+gv
	bVDRbeFl1kXOkfFqyNhJidc7oH6mQxSbIgpYtfprmzwErzIDuqDmE/OAR4lm3J/QbNG8r+h8yX
	Rg4aFZT1fkCbnu4WANhu7kpZ2AXzYaxIECDTZ6WDK3YIlv1xcrVhFQRh2Awg3Ncj1ocH3F5FVn
	wZCNjqeb03/hRmVJ5w4lVwaNGl/50m/i7d3bcb8oRqD0ll6rW0hvVs/V6UJZDNy8BlPx2AGGvd
	CGE=
X-IronPort-AV: E=Sophos;i="5.83,259,1616428800"; d="scan'208";a="175946742"
Received: from mail-bn7nam10lp2101.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.101])
	by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2021 02:18:19 +0800
Received: from DM6PR04MB4972.namprd04.prod.outlook.com (2603:10b6:5:fc::10) by
	DM6PR04MB6282.namprd04.prod.outlook.com (2603:10b6:5:1ec::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.4219.20; Tue, 8 Jun 2021 18:18:18 +0000
Received: from DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f]) by DM6PR04MB4972.namprd04.prod.outlook.com
	([fe80::8dc6:ecf:9d83:615f%7]) with mapi id 15.20.4195.030;
	Tue, 8 Jun 2021 18:18:18 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>
Thread-Topic: [PATCH 03/16] bvec: fix the include guards for bvec.h
Thread-Index: AQHXXIBJ8gtMXRQ3RES8eG+ChZZnug==
Date: Tue, 8 Jun 2021 18:18:18 +0000
Message-ID: <DM6PR04MB4972C71FEC48DECEAD05EA2B86379@DM6PR04MB4972.namprd04.prod.outlook.com>
References: <20210608160603.1535935-1-hch@lst.de>
	<20210608160603.1535935-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e298a76d-c2d0-4bd1-5e1d-08d92aa9caa4
x-ms-traffictypediagnostic: DM6PR04MB6282:
x-microsoft-antispam-prvs: <DM6PR04MB62828E49D879FA2250E2143386379@DM6PR04MB6282.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1247
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: IAnJPJSUxWZDGM3Nj57Xx/af6xOWYOl7YHd5N+3B94G3XUGzCJq4YH9Q8DRv+EoyhFn9As/EKFQF3U5/6rv4NNPkmawMbOYVhm+Tn9kaRMtVNmSxxjSeQ5HGtIXRhOyYSBlJJtWTIhItPlPJSP8LHqSt9mkqVS11iA0Oz4JCAQNQPOb2JUtwRZD2/bA4xmtElt8TgzJ8Mc67lZo57mGWIk+84K00FQ7ftV969Nw65N/qI1S95mPQMi9P1OovX95U+Xm0So7d0bJ9DaZORf8eFrKbWul/V1fjsg0Un99+WhsYrL8D82VWl3y/LiJgivG3PLhN0t/0E7WykEz2Z5D109ETOebjLQjVKPZjoCowaRia+lwHB8/YJMFA3dHooHON0m3Cky/zOloRmXVJ9qkZR0/oRP/wjttBnA+L4n3u2HZvLR67E5jb95yVzEStFj6aHplvAf/a7r8SSd4EBewes3z9OTviGBCc2NtqLEjWu2tuYYdRjhpNkeQRM2tMh1lNw4jPt42s9pL7H8blQAGlRMi3Zm6624OICZ33mwcA/GIUKH/o1saHCdFybFB7Xl5LT40YiEHTbgxEvupV/ygNUoTYk9Sp5PNRj1pIy1Yqfpk=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR04MB4972.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(66946007)(91956017)(76116006)(52536014)(7416002)(86362001)(558084003)(66556008)(33656002)(64756008)(54906003)(4326008)(66476007)(66446008)(6916009)(38100700002)(5660300002)(316002)(122000001)(6506007)(8936002)(9686003)(7696005)(55016002)(26005)(2906002)(478600001)(53546011)(8676002)(71200400001)(186003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pKMms5Ale3Jodzz5sRXw2PDZXdq6GWzgAyUhc5ceah/4E8nSzj5URA9GTUuu?=
	=?us-ascii?Q?aSS/mc2WHXOqvO6COEqgczBMM5eLJ/NmBJ+aS0qlcWcWVhzoDLbOe5X9/HLz?=
	=?us-ascii?Q?4l81kSYUuz6Q/rs7QhX8ZDZyEbOtfS8wAxfECiVcyKdyG9n4+rnvE7PpLIvs?=
	=?us-ascii?Q?MkAVKJdyl6uyZKPaEgGi0IvHeRjHaTbSUqg3H3pTTUihMKrz9jJGC03ctIOR?=
	=?us-ascii?Q?FCarexV1LI5aHHC1md302+O0O4ZbfQ2sEht1p2N/Agc2+NWRssb0gI4KOZaT?=
	=?us-ascii?Q?tfyy/sINlfP0GZG/Ee+xYnKJl5kZOElmJckwg66Ql+PErSdUhMrGojNjFeeN?=
	=?us-ascii?Q?egpcxfJRUcJ9Z97zN89SK0CbN+Pc6UyQKQHgC9q5AwVQJ5nTBvJARPEjV12h?=
	=?us-ascii?Q?WqoXRCRT66KKoIh9SH/mEC149gB/aBuIK0y8Q9clWL3SY5pNDXuZJl7J37ak?=
	=?us-ascii?Q?LrErkAbFFrtqPyw9PSL+/v6u0MW5FL++B6G6sKv0VYSgHnK5gafMVdUa/yD+?=
	=?us-ascii?Q?/OQZExMgdIijVGFlHAwz9zriULyELDsbLZksRNxYJ/pY/pY/WEzLGePZDFDM?=
	=?us-ascii?Q?f7pK9Gjcz+kWYVJq+f2c5V2qceecQSVoVnm31+diXJIli03D6sL8qSc32s+m?=
	=?us-ascii?Q?jPUDCFKgtk+AF4pV+ksD2R6EYzgWGyKI+N3LQl844Ysd4OecCSd5jx0zzxRF?=
	=?us-ascii?Q?IHQNK7Nl0MYiupFvFavTMKrCtQk1bTyzOxp7OHcywm71kCr/SyyjfpTODROV?=
	=?us-ascii?Q?sZ6aAYnEUaG2R+aKYjRa4MoW0yJ1SchvUKy3iGd1gTj+cEVj47Fozs05ZR31?=
	=?us-ascii?Q?prxoJoMtUX5sEK1lqwZNoslZersxAV7zCemMD0aWY8709VjeS4vzADnR36ep?=
	=?us-ascii?Q?ezaB3gmbGVOvQCVv8dQ6IjmlbHHD1eaiR1U/t6kY1mXGXxS3EfpChHPxW69j?=
	=?us-ascii?Q?rJiRd+Dilxq6VHLCpLkWnywqbPRxf8BgCuvVW86tZDhrqmB0dh6+7eI3Czo7?=
	=?us-ascii?Q?4aPxlHVwUi9zZ5KeOZZrJdTEcoxAydSWH8PFrJG9Kwr6iOQGMYDMp4dbfZ3I?=
	=?us-ascii?Q?AVRBLmhtc+2ZXsyTCEqXnBJ9jEkX1kWFMPIWJARuxa7k8n2PGF9ceJAK4MPU?=
	=?us-ascii?Q?SHhc4JtWI7Qzj5oZizLzzy64LKMWm6Z2B76/oIrsnKQAth6Rzfq1kteDTRiI?=
	=?us-ascii?Q?FcVbpHKa8pBYGJFBe4Hjg8g+o3qYeH1tDSFdnqMNvNcAxWgOuFZT+Mb5R9hx?=
	=?us-ascii?Q?Vemyw4Cfdz+RcXm2XfoXAMQkm+X3arZGd6MwRe5Hqze/1EzdBNzy4kQCzSzT?=
	=?us-ascii?Q?Ce0OCaSB+n7f1bYcGLTZBh4m?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB4972.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e298a76d-c2d0-4bd1-5e1d-08d92aa9caa4
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jun 2021 18:18:18.6185 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /q1s6A0qhM8QT7bBYhktWUTeWl1HUxR+Rp1Mo1gscsWr3RSuxouLjVbK441E2WYetWyv5MYWJbhXWBChn3a8uZzSe/G3eS11HgVbhdlxynI=
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 158IIV9E031072
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Mike,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Snitzer <snitzer@redhat.com>, Geoff Levand <geoff@infradead.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	"linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>, Ira Weiny <ira.weiny@intel.com>,
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH 03/16] bvec: fix the include guards for bvec.h
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 6/8/21 09:06, Christoph Hellwig wrote:
> Fix the include guards to match the file naming.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

