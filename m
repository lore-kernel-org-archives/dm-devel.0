Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D697DC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 07:54:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-nNFPDhscOBmbjPrd0ah5og-1; Thu, 14 Apr 2022 03:54:04 -0400
X-MC-Unique: nNFPDhscOBmbjPrd0ah5og-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1855119705A7;
	Thu, 14 Apr 2022 07:54:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 059BEC3598E;
	Thu, 14 Apr 2022 07:54:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BDE881940345;
	Thu, 14 Apr 2022 07:54:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 05D481940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 07:54:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id D684D401E99; Thu, 14 Apr 2022 07:54:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2290416156
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 07:54:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B72E5802809
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 07:54:00 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-oZLOq6LBPJmJnNPw3-zo5w-1; Thu, 14 Apr 2022 03:53:59 -0400
X-MC-Unique: oZLOq6LBPJmJnNPw3-zo5w-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2052.outbound.protection.outlook.com [104.47.14.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-30-5TMWiiN1PBWw_J2saQWogQ-2; Thu, 14 Apr 2022 09:53:56 +0200
X-MC-Unique: 5TMWiiN1PBWw_J2saQWogQ-2
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM7PR04MB7079.eurprd04.prod.outlook.com (2603:10a6:20b:11d::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 07:53:55 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 07:53:55 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 7/7] libmultipath: Add documentation for the protocol
 subsection
Thread-Index: AQHYT7gGanzNf7mJU0+PEQwl2fpcvazvCiIA
Date: Thu, 14 Apr 2022 07:53:55 +0000
Message-ID: <55da8d77c2d26bb3f2efe7fc875f720a30692a1e.camel@suse.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
 <1649910461-25263-8-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-8-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14b5bb1a-24df-4912-a372-08da1debecb6
x-ms-traffictypediagnostic: AM7PR04MB7079:EE_
x-microsoft-antispam-prvs: <AM7PR04MB7079D84F7D02E4C974445B77FCEF9@AM7PR04MB7079.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: huhiKjxivy6NZPUEH5yb0oV7+dlEX2D23t8MVhEbIQib1RHYLRaa102CDAIEP0Ec4Bok2JVWA4dllnKrBitZ8ZnwokgXzyRq04jNjyVurv0j+hwLvamg0Vw2pnoZGfiPdw4MN8OWxhq+7EAVUSVRwYhwC8Coec8N0g1Gv/r2yfKC5gpwkr4Eos+qfP7fb1+Ji9irBXl47c8piW/SMyPNfmz5ugntA7tsGbRiFPC3c7CcO/QQxa1YI28+7PR/pxax7iqlj1RG7uzUBAtl19rzv6qjZr/RmaWg6xjqRdrzCDzD/jh+OebUNT0slZjPMPCoSnMDqIp3v4Av0A7wnHTMOrvwxNrU30Iy5u2NzBqA5WYmBqU8n1vvEyyub2vlcz74doE71XylSqJ533ke+93/jKA5lrkjY/Ci26j47UwugV/9k2sjDosNli6vDk602xKzcgCW5X6gajPfANy+347q8R3a+bKfWkczfuLS19xwhGgTqK/NvyL+LLur3/bK88nUKhugyHYdiQurF9upnjzn0EEkPccU1toUcMAD2ww1bZZf4KfQOr4T8U/grPywerLXyBJdwEecxoYOgN330U6+dzhF6h6Nmi8mKWW85Pu0jRcKpkGGgvFip5FMt/7XuvcYSMRHsHGADBFuaVBP6qc0hmFbD6/ox0L9oLSSJaBcougZ1GlFk3roXBqmRQ4VCVJGB9cSqhDwoiQszBdfABH+OQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(6486002)(2906002)(5660300002)(8936002)(71200400001)(508600001)(66946007)(64756008)(36756003)(66556008)(66476007)(8676002)(316002)(4326008)(86362001)(91956017)(76116006)(66446008)(38070700005)(38100700002)(558084003)(44832011)(110136005)(122000001)(186003)(2616005)(6512007)(26005)(6506007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?lbcCLNBtNXRZi2cHmOkfLOd5/Bzl9n+wHAWi2PkubzZCEmPlGcJ7E5yd3?=
 =?iso-8859-15?Q?7Z4ongkzYwY/x0KBz8GDKrDshBFn0N/vGEowj47Tl8JwEKqOp62nOyogD?=
 =?iso-8859-15?Q?uDPq86B68s6K3dDZEoLXKv/s3cZde1fZWEgMwrNyf3A1Ps5IW88f+N2q3?=
 =?iso-8859-15?Q?Ro8EXQ0AVXN9M8fwVeH43O6SOg5oOSopQ8THYBdHm2HWYW4fil9Dq2SA4?=
 =?iso-8859-15?Q?OaYMm/kJA177AJj4DvwnIynXdSqmAspIiqbU4MXD2JvK+YaXFI9jA244m?=
 =?iso-8859-15?Q?FXvfBigN/42bv6ibIoxsn8gaBCSOPRdU6inHPTfHYsT0MroTLvEbBwSE8?=
 =?iso-8859-15?Q?F2S7Tc8XsROWcUomEShRjUgdPLlgIvFYZm3SEzEfzoplP8WuihUw1MUYD?=
 =?iso-8859-15?Q?i6Gxq26MzwuYnUh4M3Q4litTfsXgQhQTtWdsQi6R32yzDg8z0Lf+w3elm?=
 =?iso-8859-15?Q?ypfhgpqjd+0GpFOOH05zFwjw47Y+J7uXD1rkxcd9QA/LePOD9eqni5g9v?=
 =?iso-8859-15?Q?PbfzUU177W6kibtQQ8Aay9tAnr2qceUOAZINvOaiFEEbvNgRwlyW7glMw?=
 =?iso-8859-15?Q?FrRIJ23wM3doaqqBm0qE1oO1uNdme4x10p2eMBg8qujeOrDAfwr5othNl?=
 =?iso-8859-15?Q?0ko/NAxRWT64UqBhohSWRGj5uKGCJafQUsXVNVBDLwztpEEphMG7BJCAO?=
 =?iso-8859-15?Q?r+gIchGaIX3V1nX4NecZcNfbVNBSPhf3PGHJ5Gh+e23qzbj40ZalazPjX?=
 =?iso-8859-15?Q?S4ae2Lp9fVVIoXTuE6jnhyYBuGZ+QI2F5ouyyP4rWaHDvQr+l4s7W+I57?=
 =?iso-8859-15?Q?jEZw34sKJW/IEPBBI3RM4Mxcnu96/9+ztpyBn73d3niZLbvabQ5A4ELi/?=
 =?iso-8859-15?Q?+xhC/Oi2RkK6MN0S591bj6elkKDLiUJMpqGCHnIPIp/CX75Gda+8nDbyo?=
 =?iso-8859-15?Q?DjRoufNWudWh7gsrpeS0qb6w/7g3n0ow1A3EDHuuIhBaFUsZSCM+hrBT5?=
 =?iso-8859-15?Q?5zhDs0x4ZGjKHe4LuJKZe0PVx1oApmqMa9SXuk3/1BLWGhKKLwYXw/gB4?=
 =?iso-8859-15?Q?odbdd5Fa+IQIKkG+4qVzPaUNkRWsaPknpqkcVVJ+TKrODayru8l7TR0ns?=
 =?iso-8859-15?Q?OHQDWNgo249ZewbHsBwXUuiceXd+ZVMvYImX5ip/ayTZussE/fTE1KU79?=
 =?iso-8859-15?Q?vGm0UG+Uqh3PFuPngF2Hq5bNpK1siq15IVRgMIuZC+qATjMHJRZHprd6S?=
 =?iso-8859-15?Q?dAfg9s+0dJc9mqsT+TmNbUxihS0uqtcnfTopOpjSyflSibb+AMC7qvxdo?=
 =?iso-8859-15?Q?0x89O4YuvRhgS5Pak2snV5OQhPRF3//ZYAHk6InURCSpcnF2Tm3lCvjyu?=
 =?iso-8859-15?Q?7TIlf4uFzSsVcMxJGhqocekyHK9ZjnjrAwVuv27+BJOkIQ/PhrZUtPYkV?=
 =?iso-8859-15?Q?Q5DaLwzssxg0j8NHPa31h+4s7//r01LpR7id1KGrTpDIL0eHmTDJHnh3q?=
 =?iso-8859-15?Q?Fk3Ggv1OAuplNrljPFJ9bmEmFpgue9x7TLi9gcXIrzcJWi8R/WiIOXr9K?=
 =?iso-8859-15?Q?o8hqrCnb6pCsv2/kYssvbrdppHXxoQfPykFMX6Ln2AlHlhkWa+x6xVpeO?=
 =?iso-8859-15?Q?3X0ozQ3DMomjyIk6xGjI8vP572Ix61NQXoECsqYN/YZzduF+zGOvBAMbo?=
 =?iso-8859-15?Q?vEUx0IMs1BmwRagMyAYRBor/RWG3RThoaAf6MPD/2lZywPO3g97xl39Y+?=
 =?iso-8859-15?Q?m9e06bTo94ldYC63muPz37piJurSp9dZ/T5UtzuA86SWSgc3vMCLr4pg/?=
 =?iso-8859-15?Q?6u8tSg4qo+ziaA7xGvD2Mq5cwcR20UmFNXg1VMSwViIPmYL51MVkGnWfZ?=
 =?iso-8859-15?Q?Nag4=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14b5bb1a-24df-4912-a372-08da1debecb6
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 07:53:55.1946 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BSpUNJb4LbShHG9GhcIz7QOc9z/YDFSxJPDKTAYgVlKG/L8TjpoPu/luEt8ktlBGAwQgFLOhePOivhQuAPTOuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB7079
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 7/7] libmultipath: Add documentation for
 the protocol subsection
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <891FE64F18730246B9A599A38C08F8C0@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, 2022-04-13 at 23:27 -0500, Benjamin Marzinski wrote:
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

