Return-Path: <SRS0=NZHG=FV=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57C25C4361B
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 00:06:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BC22F23382
	for <dm-devel@archiver.kernel.org>; Thu, 17 Dec 2020 00:06:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC22F23382
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-0e5aFWmTOPeDcSztCbl8Hg-1; Wed, 16 Dec 2020 19:06:23 -0500
X-MC-Unique: 0e5aFWmTOPeDcSztCbl8Hg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56B00107ACE3;
	Thu, 17 Dec 2020 00:06:18 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id F02323A47;
	Thu, 17 Dec 2020 00:06:17 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 943695002D;
	Thu, 17 Dec 2020 00:06:16 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0BH06EqO023952 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 16 Dec 2020 19:06:14 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 58F37D7B06; Thu, 17 Dec 2020 00:06:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 524C8D7B09
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 00:06:11 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB017186E121
	for <dm-devel@redhat.com>; Thu, 17 Dec 2020 00:06:11 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-69-wd7JhB4pMPySeOfuiL9D9A-1;
	Wed, 16 Dec 2020 19:06:09 -0500
X-MC-Unique: wd7JhB4pMPySeOfuiL9D9A-1
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur03lp2051.outbound.protection.outlook.com [104.47.10.51])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-40-4FAQ3g_1PF-NSqv2CrHQKQ-1; Thu, 17 Dec 2020 01:06:07 +0100
X-MC-Unique: 4FAQ3g_1PF-NSqv2CrHQKQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB6PR04MB2997.eurprd04.prod.outlook.com (2603:10a6:6:a::16) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	15.20.3654.14; Thu, 17 Dec 2020 00:06:05 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3654.021;
	Thu, 17 Dec 2020 00:06:04 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>
Thread-Topic: [PATCH v2 5/6] libmultipath: limit reading 0xc9 vpd page
Thread-Index: AQHWsndY9jwtkD4B7E+vNuKCUocwI6n6fO4AgAAsRACAAAKwgA==
Date: Thu, 17 Dec 2020 00:06:04 +0000
Message-ID: <5d54449f15cde3ac2858238b556239b3b16655e5.camel@suse.com>
References: <1604472849-22422-1-git-send-email-bmarzins@redhat.com>
	<1604472849-22422-6-git-send-email-bmarzins@redhat.com>
	<8eab5c37addfd83366defd5c463d175ead90b7ec.camel@suse.com>
	<20201216235626.GR3103@octiron.msp.redhat.com>
In-Reply-To: <20201216235626.GR3103@octiron.msp.redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c4ad985-0610-4db1-f44a-08d8a21f8c03
x-ms-traffictypediagnostic: DB6PR04MB2997:
x-microsoft-antispam-prvs: <DB6PR04MB2997583A924411EF8DB18843FCC40@DB6PR04MB2997.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: LfGbP3FuvVvcRTyf5E8X1TPWo6DgMxeT/CXw+/23sTQ1eBySaEmSkybAV4kj80TX7lWsGqU5juhLKmcfj1frgmkiHCyCsI3d5eWJTyExaXbvTCGPhJ2us3vx631RmKmNGJ+PLKtEwnZ7c5AX7a3thWszpJ51KOuYJmM4gQSZfpw4EXP63fvlQQ4Ztt07c5UXzQHsv5+yFM6EjqtfdlVAlz+weQcP+bq2CSaV0v6qZhvBsW/ofKfP0mTBE4carMCv5zkM7TgsaYXaf/fBZMKjJ03DKlZP4kKc+t9G14wumePX+Cs/EiOIPU9dYGBvBzuTpoNZPT/Gq3DXUI6fSVeztg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(91956017)(71200400001)(316002)(186003)(6512007)(44832011)(478600001)(4326008)(6916009)(54906003)(2616005)(8936002)(66476007)(6506007)(4744005)(4001150100001)(2906002)(66446008)(6486002)(86362001)(66556008)(66946007)(64756008)(76116006)(26005)(5660300002)(36756003)(8676002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?BHn2REOI+0cLpE7dXasqimmP2CX6nzk0lC+UecKlIrEyzd3Wm07DCFM++?=
	=?iso-8859-15?Q?rFvCkmhO6094glZGnMsCOLZvQphCYBPNX4JhN1RTCGZOXYSZVppbkcORY?=
	=?iso-8859-15?Q?mywQll+Yk8203YmVFQETZhZvFJyxyzktUuUlgW0lidlfZNWix2q/+B/Ry?=
	=?iso-8859-15?Q?sprKKjBmd8p5MqCEpH+NKPhDdJrMcwQHSmKkZgGcHT+LGLVbUE63WrVxE?=
	=?iso-8859-15?Q?yW1Vu+xiGR7XAIOGA0WaQ2H960NkvIb/F6GUiDKQE6pcDW5yrYD5r8Zac?=
	=?iso-8859-15?Q?GjGb+9kHJ7bh/XPU2OIYLTrol4iPamTdnywDsd03auO+rCq7FpvoPfA3O?=
	=?iso-8859-15?Q?Ds550HlSo1IrGedKS9ZQ8YZMnndJfEntXpSYepgQI85ZOhSr3OntilZds?=
	=?iso-8859-15?Q?PVu3zN59smUxkqJf5tIDiyIamX3x4rd4Sl/mOktLQEVQ2X6ahDAhmJ3Tt?=
	=?iso-8859-15?Q?Q21x5WIkGzdk9yL32FnB3RSVvr/6sL8Djz8jxsvMQS+k14LtwFiKGRAhx?=
	=?iso-8859-15?Q?CEXY7XrqfwWmMyO6dZunPA5804NNY1dwc+qDwmoAr6phGKs9DRmRHhBAc?=
	=?iso-8859-15?Q?v7I559rBZSIbTy8A1EA9LM4CWUGaW8QhetGzQpV6Dg0h0kXXD08xCjNOP?=
	=?iso-8859-15?Q?v76nTjxq/afAUOoz7sH9as5JoS5Om43v08kXp42oHONaj87mbsHBKUlPi?=
	=?iso-8859-15?Q?yJRjd6vboAbc0x9pLSuwik6RXL8T1RIDPsSoOhQHpB14giEwA6IbumurJ?=
	=?iso-8859-15?Q?sbdgy2C+f4Ul3Opttuf07gas43GoNMEKyS9e6aR6ue8+m+boh3S/njSQe?=
	=?iso-8859-15?Q?vMhm3V38BBqaEOMeRZ6YgpYJWwZldXb2Sg5/+luUCJjn3onyI7VdK5Imb?=
	=?iso-8859-15?Q?nsg1sKyeaPwPNmUAnKMyIdDne6tWS74MTbRXJ6VQGHD/Y7zuZ944b7oSF?=
	=?iso-8859-15?Q?34G+Dwzh6Y96lVA/zbi+k1ZXHRfR5T7ajNBO0RDnvAH9Hc3OEPdg4h3Js?=
	=?iso-8859-15?Q?5+qxdS6Y/ybNHqkved20JX7n5Mlbntj6yaPHMSN/YQ7hOUJk+ddUwqM?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c4ad985-0610-4db1-f44a-08d8a21f8c03
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 00:06:04.8880 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w5BLoaJODNqSj5zeVyU0Fl0gCU1lib78hYr17y8MWgxt4TAN7LQmGTDkw3SSsgoJsz/PaN58rYjddn9t3dBuMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB2997
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0BH06EqO023952
X-loop: dm-devel@redhat.com
Cc: "ng-eseries-upstream-maintainers@netapp.com"
	<ng-eseries-upstream-maintainers@netapp.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"sschremm@netapp.com" <sschremm@netapp.com>
Subject: Re: [dm-devel] [PATCH v2 5/6] libmultipath: limit reading 0xc9 vpd
	page
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <39090CB802335348994937139C02C248@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2020-12-16 at 17:56 -0600, Benjamin Marzinski wrote:
> On Wed, Dec 16, 2020 at 09:18:01PM +0000, Martin Wilck wrote:
> >=20
> > Do we still need the name check after testing whether 0xc9 is
> > supported? Well I guess it doesn't harm.
>=20
> I understand that people could want to use the device section checker
> configuration as the fallback. But giving priority to an explicit
> checker configuration hasn't caused any problems here so far, so I
> think
> we should continue to do so.=20

ok.

Martin

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

