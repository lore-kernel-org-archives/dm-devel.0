Return-Path: <SRS0=vg7B=JR=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17672C433ED
	for <dm-devel@archiver.kernel.org>; Tue, 20 Apr 2021 01:35:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8DA7E61221
	for <dm-devel@archiver.kernel.org>; Tue, 20 Apr 2021 01:35:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8DA7E61221
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-3iem_39gO7qrj12NuoytUw-1; Mon, 19 Apr 2021 21:35:44 -0400
X-MC-Unique: 3iem_39gO7qrj12NuoytUw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1D4B93B;
	Tue, 20 Apr 2021 01:35:39 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0A61319172;
	Tue, 20 Apr 2021 01:35:39 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C23F71806D17;
	Tue, 20 Apr 2021 01:35:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13K1ZZIt032608 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 19 Apr 2021 21:35:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 221A020378E6; Tue, 20 Apr 2021 01:35:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 19C6420389E0
	for <dm-devel@redhat.com>; Tue, 20 Apr 2021 01:35:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 637EA80B921
	for <dm-devel@redhat.com>; Tue, 20 Apr 2021 01:35:31 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-376-xZtZuVirMIOXwxcMvCqo1g-1; Mon, 19 Apr 2021 21:35:26 -0400
X-MC-Unique: xZtZuVirMIOXwxcMvCqo1g-1
IronPort-SDR: lq3hOnSjbfl602vcd8q1ccLg6lvVv6Y6lWpbiymUa/mgilnlv94PMoN9UJz+N198SI5jRWZjty
	P52rfab5tPiqVVqT+/8Un6aGsMHVD3C/kukTj4TM0gSwOw0YtfG/HmRgmnIE0GIyikOyw7dZ80
	zZDvUWKJbajZFgVVFbWauI9cZkTL+hcNfygpL8Ch6VIZoKqtCmPpSqeVD5rqEQz6Gc1LNY/UxO
	gg9u3yz5uennl4V9UVFz/6YIEO71LT2UcfQJtej8PpMHCeb3PwNPQ3uZxBHeeEzpfL+w7LX2pw
	nGc=
X-IronPort-AV: E=Sophos;i="5.82,235,1613404800"; d="scan'208";a="164838428"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO
	NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
	by ob1.hgst.iphmx.com with ESMTP; 20 Apr 2021 09:35:25 +0800
Received: from BL0PR04MB6514.namprd04.prod.outlook.com (2603:10b6:208:1ca::23)
	by MN2PR04MB7008.namprd04.prod.outlook.com (2603:10b6:208:1ed::19)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.21;
	Tue, 20 Apr 2021 01:35:22 +0000
Received: from BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78]) by
	BL0PR04MB6514.namprd04.prod.outlook.com
	([fe80::8557:ab07:8b6b:da78%3]) with mapi id 15.20.4042.024;
	Tue, 20 Apr 2021 01:35:22 +0000
From: Damien Le Moal <Damien.LeMoal@wdc.com>
To: "dgilbert@interlog.com" <dgilbert@interlog.com>, Christoph Hellwig
	<hch@lst.de>
Thread-Topic: [PATCH v2 3/3] zonefs: fix synchronous write to sequential zone
	files
Thread-Index: AQHXMzIUD8ZVvai2c0OhPeRaKpo++w==
Date: Tue, 20 Apr 2021 01:35:21 +0000
Message-ID: <BL0PR04MB651451976F15C55D5578C131E7489@BL0PR04MB6514.namprd04.prod.outlook.com>
References: <20210417023323.852530-1-damien.lemoal@wdc.com>
	<20210417023323.852530-4-damien.lemoal@wdc.com>
	<20210419064529.GA19041@lst.de>
	<9a4d5090-1a70-129a-72f7-3699db0038a1@interlog.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2400:2411:43c0:6000:b085:266a:414b:c56a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bdc245fa-646d-4c17-52df-08d9039c9051
x-ms-traffictypediagnostic: MN2PR04MB7008:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB70086E344A5C589F191CCCA0E7489@MN2PR04MB7008.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:4502
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: U4bcyF1KlDCACFTH0byril27zQ/UGlodb390pXRKdqHOKZ9Ik6fBGNMsTW1NoOBgNsP7TWvmK1H+xE3ai81m6iTpUw9tTwlMxoXHK6VNgfad1FbKrqRhX72sRm2+RAVLAC6JaXucUfG40qyHBK4EuQiSxe26HMz9WWCSz3U563/Ep/Uxl6swjKDzl0sfWolLI6vUTV0iqRzOV0cigvI3h6tm5oqb+GeZRpMRjwYN4dv3LhjcsevAWUhlUZZ1BDmiemfzWgPq4A60Td2CeOBGKh2fO60Kw5deFnyTHc7UUNh6ZZqyoQe5NI7B38QtNt9Yyliz1GeucQqkvCF841dfT17c9eEd5/Ts0SYxNeGZCrTpgZRhsAIQz3Stkd1X0em/7TGToSkrKNXpkjuoSR6r5+EsXmavTwDldm5N41zPY8Vf85n4ZBliCGuoJvXsCdyZ3N3WvQpwlIMHx6g1Jay575GTlDaS8E7/KsSpEllLbP1nd2GJEcMQ6OGr+2MD09LiCDK0owiW1mkE9ocTxpdXpLJ8I29tNbkXmsgewuvO/QaSiPTNa/YNpQd561oRPAKYNNmQJA3OQavrr7Va8auzTBggQrSzcQe8IZvWpuadIWQ=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BL0PR04MB6514.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(7696005)(53546011)(6506007)(8676002)(38100700002)(316002)(66476007)(64756008)(9686003)(76116006)(478600001)(2906002)(54906003)(66946007)(55016002)(91956017)(66556008)(122000001)(7416002)(110136005)(8936002)(66446008)(83380400001)(5660300002)(186003)(71200400001)(4326008)(33656002)(86362001)(52536014);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3EStXqiTBffkjQ3C7PGe0ee+qwuJF51+Eh75DitD3c4i8yBoI2uMoi0Tm8vE?=
	=?us-ascii?Q?9g9mxdAmSxAmRy1khL/435XT67f836aywmXcPIdkPF8arDn2CRjUV++EzIbN?=
	=?us-ascii?Q?ZU9V8uWZRw3ubxdbcSyNCHv89rKMN+CX1eJNfh9zDq7foRkhOp9T5S6TOAQ2?=
	=?us-ascii?Q?dUj39MJ41/V2DVZHdT5Uma8pswnKbTRrAqHaTvC6k+Z3Xugb0ukeLB64ndvu?=
	=?us-ascii?Q?P2Le6h6XOVs0JouZ+72gfx54AkXA57Dc+oFcbeBvlQq04e08r6SYGCEhMrLX?=
	=?us-ascii?Q?A2xrj3Fbl8ywp+cKbUtLfwgYWkYEEYZ4cH6pK4tYLLs0XDVG+SWtwquMobnL?=
	=?us-ascii?Q?SemUuJFzJYkAN3icE7Ka3X3mzbD6l7FgaW3wEsZu2NcKo6p+SzbaC1EAlUbu?=
	=?us-ascii?Q?4rgtN7u4QB6tySiwgVGFR0VzhgxIrv9/n+oYf1/h2lknKGekDBDXchxSKqsx?=
	=?us-ascii?Q?AN1I4ZPXtu8Pb6e1rxUWhvZJO5+3fmW6irQ7p+1HSKhXNzsjYw51cUUBEG9p?=
	=?us-ascii?Q?6KVKD82XzTKE+tIDTUbrcDJLaGbAH0vAKHlc7XfTjGnI5IfGZDp5iB0ABCul?=
	=?us-ascii?Q?L2d3Epduxpt9uQOXR8t4dVRI70K3lX+rDeq4zVUUK3U/S/n5ucDN2A4l87rx?=
	=?us-ascii?Q?bAWrtNNCe1iUgR+d3Yh5i5zD+YS6YMwiKgAFrXL0Vwdv+pKEzLhvnK9ydtlQ?=
	=?us-ascii?Q?KO8TbJ9O/svig9mKApuRJev0oMvAEJJK99uIDFfpcu0A+46io2AHFRwLO36E?=
	=?us-ascii?Q?8/1HX0cm373i+lkveg+3KrkIlOm+MoWRjidqFPO6au5AFgiHE1sgORajTmI5?=
	=?us-ascii?Q?BxUnslTnjqVsToyErMvIK2B90lXOpd2c5cha/sEjvV7sxa/l3DHF+me0wWmT?=
	=?us-ascii?Q?GAR5tjG7oEocbyfR4S7P72NwX+yLCYJ3i8Wp3hc5/XYc2/khnRBDdRcsP25s?=
	=?us-ascii?Q?zF4iLvYF0QQtfDEhGiLQ9MproeAw/jXkyFNmu+QA468IpmEaxYV2P3WzdQor?=
	=?us-ascii?Q?g2EhmvAohaGCljcGiwjFBaIeUS7gqRjOGRbY6rewq8pzUbGmkT2SpWGtIwGF?=
	=?us-ascii?Q?upGHMVq6ZbeRwRymLmhz1iK1AL83nJ2xTEA+s6QSA6PCqDJBCVn0JayFaxqG?=
	=?us-ascii?Q?KcgBrnEIh77uGUHadF5Fw5b2xrJGxSe337jIXyXHnLlnFo2tSU8qJpNmhRX2?=
	=?us-ascii?Q?D2zg7C1fxP9tE/N3Y8S3ehfsR1340gPHo1dX65Irs8BdDiJlimS2aNL0hkqY?=
	=?us-ascii?Q?DbCfX4xqLMhwXT5j6NqFjcx9CHLtHWPjHGTJz2iQupHIoaq2cmkCfalE2W9s?=
	=?us-ascii?Q?xDjpVoS28bGbpTKZ0Diin6w854tQMrszLtpS0faNmf2+TpjP7tykD1doa43i?=
	=?us-ascii?Q?DGisWkobsht4kH9+WOUH2UsdiZSvzSmfY7RHU2J0n3UgfDj4nQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR04MB6514.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdc245fa-646d-4c17-52df-08d9039c9051
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2021 01:35:21.9590 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VdwDmpU0srsXULzQJMEHRDRmuJMCLSYoLrXQ+/nBsUq7nAwfGOxV5lJwf97nUnc7QAsyYSaCvLrR59Pmi0bz5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7008
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13K1ZZIt032608
X-loop: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, "Martin K .
	Petersen" <martin.petersen@oracle.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [dm-devel] [PATCH v2 3/3] zonefs: fix synchronous write to
 sequential zone files
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
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 2021/04/20 10:20, Douglas Gilbert wrote:
> On 2021-04-19 2:45 a.m., Christoph Hellwig wrote:
>> On Sat, Apr 17, 2021 at 11:33:23AM +0900, Damien Le Moal wrote:
>>> Synchronous writes to sequential zone files cannot use zone append
>>> operations if the underlying zoned device queue limit
>>> max_zone_append_sectors is 0, indicating that the device does not
>>> support this operation. In this case, fall back to using regular write
>>> operations.
>>
>> Zone append is a mandatory feature of the zoned device API.
> 
> So a hack required for ZNS and not needed by ZBC and ZAC becomes
> a "mandatory feature" in a Linux API. Like many hacks, that one might
> come back to bite you :-)

Zone append is not a hack in ZNS. It is a write interface that fits very well
with the multi-queue nature of NVMe. The "hack" is the emulation in scsi.

We decided on having this mandatory for zoned devices (all types) to make sure
that file systems do not have to implement different IO paths for sequential
writing to zones. Zone append does simplify a lot of things and allows to get
the best performance from ZNS drives. Zone write locking/serialization of writes
per zones using regular writes is much harder to implement, make a mess of the
file system code, and would kill write performance on ZNS.


-- 
Damien Le Moal
Western Digital Research



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

