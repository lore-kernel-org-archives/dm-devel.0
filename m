Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0379C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:55:32 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3D89260E98
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 20:55:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3D89260E98
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-Neec9RQQPjq4L4XjxXeeVA-1; Thu, 04 Nov 2021 16:55:28 -0400
X-MC-Unique: Neec9RQQPjq4L4XjxXeeVA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E4E048799E0;
	Thu,  4 Nov 2021 20:55:23 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFB615F4ED;
	Thu,  4 Nov 2021 20:55:23 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 9710B1819AC1;
	Thu,  4 Nov 2021 20:55:23 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4KtLs5024669 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 16:55:22 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BE500400F3C6; Thu,  4 Nov 2021 20:55:21 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B9276401A994
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:55:21 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A051C1078461
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 20:55:21 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-585-BHNtFlwNNoyrexOotMVAbQ-1;
	Thu, 04 Nov 2021 16:55:20 -0400
X-MC-Unique: BHNtFlwNNoyrexOotMVAbQ-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-1-BukDbF2OMnSRoFJ9lKTmVA-1; Thu, 04 Nov 2021 21:55:17 +0100
X-MC-Unique: BukDbF2OMnSRoFJ9lKTmVA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5227.eurprd04.prod.outlook.com (2603:10a6:10:17::11) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11;
	Thu, 4 Nov 2021 20:55:17 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 20:55:17 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/8] libmultipath: use typedef for keyword handler
	function
Thread-Index: AQHXuu1kDGurV8nh4kag3PPe9Da34Kv0Bq4A
Date: Thu, 4 Nov 2021 20:55:16 +0000
Message-ID: <64e337ba4f4a875f49dbcad43684aae5b1edf011.camel@suse.com>
References: <1633550663-25571-1-git-send-email-bmarzins@redhat.com>
	<1633550663-25571-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1633550663-25571-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32cd6d83-657d-4523-fab1-08d99fd567ff
x-ms-traffictypediagnostic: DB7PR04MB5227:
x-microsoft-antispam-prvs: <DB7PR04MB5227F200AA032A691C0149DAFC8D9@DB7PR04MB5227.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: pqauHt+eS3HHKbHSrx6arCmOl4YXodZKVPABVf3C07jChjBG81ECqtQYM9jnoXdu5NTeoWi41vjjw5D1dXJWewW/r9CIoPetlIsLYB/KrIPkGsSc3tqAbqBCDmS3+ipBB72H10JLr9Rnt5+vF/8E2zsLvYzagayE6h48EO4gI46axb8YBI/aaF+2h59qAA37OsZBpmseyhk0c95/xzDUJkjyViKJeJkwDmuyeSbixaRb7xDHFdOKMYAdQKS4bxfopsIqtsT+HgPbp6o7+f3mIr0FJRJ6lIfCpwpLaeS1BKioSX2NtKafcEA7tZ8d/gAIqHbqGKFaviFLIncjH+eYP+JVTS7e4NEmKZ77C27nxc6kwJzUj7f++IJ5QEy7AI9xk1OWhZG85dFZpzY2twA28jPrFKO79e2/VRYSXLk5oKjnRNoEXVGqaCKfB+0+TmNnUKbmSzJlc+z9Xx5LPuPzW5weffKpUX+HeojXVMOdumiFEmDeJgmVibdq50i5t5e5Y6D2ksnFIQuFetJBDzMWat6iIGBnYEfuwqWTv6M1WIiQentEt7IYe+LjeAmn/ZYFlVAv7GIgbimVtGWvhge9X4G5g41hCTNoQhp5c05v/RFx3XGa7Qi+VJ27wkPiZh7Hqr3RuPIMssBPkeTF/PJqpP21UyL/pVIrpDyChyEq1dmhwdh8W3npz+02OIAvSzrGEcLhBPmpUALPMOM5cjJJmQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(316002)(71200400001)(6486002)(66946007)(86362001)(8676002)(5660300002)(91956017)(38100700002)(6506007)(2906002)(186003)(2616005)(38070700005)(110136005)(4744005)(508600001)(4326008)(122000001)(76116006)(64756008)(83380400001)(66476007)(66556008)(6512007)(44832011)(66446008)(26005)(8936002)(36756003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?NsMijRv5U+HfelAnNzscPtcjxc72yFfDebJpxpL8B19UHpw4Z8vSoyS53?=
	=?iso-8859-15?Q?fWypUakO4mFxrYUuK/gfF4KcY198umjMbza1M09JHsGDk5lw5M4PxJn0i?=
	=?iso-8859-15?Q?mxkPOCF3xRWpkzlBzZdzDaUAlbWMYtdwkWoqTz+bRUUqaJpSwD1jWBoXi?=
	=?iso-8859-15?Q?OY7/3sEZNkLZKK/DE/Gt/TXD7EAcCov0syxxNfN26imJKF1PXOYYyFRDz?=
	=?iso-8859-15?Q?dmdDEiZ+pEN1dNivOuNnjWZpGqrRVIBKsgYE3q6ba0GMaTqV9IJYVfdMz?=
	=?iso-8859-15?Q?xdsxmJU+8aLy/FonDSoswUZz4F1dzKO6Vix3gpIgK5sFBrceRue80Xr6O?=
	=?iso-8859-15?Q?lKrlze59+YvUdpOmA4B3LsPRJqHiQHIW2UanC5iOPlndiKTWxvzLJ7xFJ?=
	=?iso-8859-15?Q?N+Z8Fyz2glhsMtxxcWdx0k1hVKDt9G2yDYV6SyqE4kXwjZgA/EZ31V1IY?=
	=?iso-8859-15?Q?a9XDjNtq105xi2Gf7mlPiVFY355h7i2LrK5CL/tdre0mD36ssVigDZQg0?=
	=?iso-8859-15?Q?+i3qZv5Ojq7F0YiibL/UNaMKczP3XsakLHLQ9WQ1rg10Gzv83Njf+5fYP?=
	=?iso-8859-15?Q?nfHmXPSafIhnkm6QVwPLxJlFGJp9DmBWdnwqEXHZxgFIjIQbvk3iblWnR?=
	=?iso-8859-15?Q?MFkVGqFXa7W39uJ5gXgXiJ6ExBQ59kzbTwYCfx8OFU14dEsVcNpvdqZsG?=
	=?iso-8859-15?Q?NRPMU+B7WxZJLr3blgNvBuXt39qQD8fdhNEMeDB0UT4dwzQdWhbLK6WA8?=
	=?iso-8859-15?Q?1tujaUXVcK358WTrxCcP1TuuRx9Tc9K4GX58gGsO+TinndiD30iJ3D89M?=
	=?iso-8859-15?Q?tXuq0W/BP/ioI3vjfcir5g7CS/egTw7wbNrHs5QFfoYV+sgLLftlcBu9E?=
	=?iso-8859-15?Q?/wDs1AwVp/sS2NThPP5zNsVHGS3COAJuPFRBw9/BczoD4ett52RA+OaaX?=
	=?iso-8859-15?Q?EhzUez4FTJDA5Ncao+MAnJTVfwJmA2QD+s3TKSlX9wj7qUPMWFZzqXUPE?=
	=?iso-8859-15?Q?2P/uGkHQceRKVhRLtJQ913zRRsSg4Zw5e83thrFdAkuFBOX2tqpy1lruS?=
	=?iso-8859-15?Q?YPQm/gb5S6fDhOdRXLxgRsN2tU7acbAep6lh2GH+You+cZCzD7KrJR6vo?=
	=?iso-8859-15?Q?RDcgW2d+KPnIE93ZfoX76ulEiuyaQ2Uvc+DKo5ktVDXKsrhCxwSAwkpih?=
	=?iso-8859-15?Q?hFWfgJ30gVLmVN2XsQvz6zIsuQzuiVB0kiTW7q7U5N6goBGsHpQvYctSo?=
	=?iso-8859-15?Q?bFEAgnY0OnwZmo52ygaA5dAgWf5y6WVAIeKSdQUN5Wbe7pXrg0vVltRXr?=
	=?iso-8859-15?Q?fy7FI6BwAQXN23p3kWcnXHNfD9WAcwB9ByyDXjWBr8T84xlCFQ/cv+fcf?=
	=?iso-8859-15?Q?I26lIXUXCgyBjyjfddrpV4pRL+ewUCO16repxIdUjmyn0FtM/LynUKMyf?=
	=?iso-8859-15?Q?w/f7/fcu489YDv53qJZKaWupmsLreFyE5xWReIq8XNE6Z0E0tLk81hsRG?=
	=?iso-8859-15?Q?bd961f7nXVeEZBkiu+6DvE7wey0ZK3nC1l1QotmaoNvJIjqaeQ+r044Lh?=
	=?iso-8859-15?Q?5QPPCBRwxUhp2eNoqX3e3nbJIOjddiRh6GJVstnmiDxvP14xDy72CwjDV?=
	=?iso-8859-15?Q?qG4/ukIv9ReyXYLynQ8YLbIcF5Ia1s3xgfNcJkpG+gmRifoqO+Q//imVU?=
	=?iso-8859-15?Q?OQEY2GUWuyL9CeNjcbWrInFTt8dwEfuX0ZNP9xqfwIjsUVg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32cd6d83-657d-4523-fab1-08d99fd567ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 20:55:16.9936 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lmg7fXYJmTQnD2WoZBKNZu3ozx0Mb6NSWLaKyG3thy0KiseB6Z3EVcSBhORxJiUbz0nBadoq9oKfpS82KLEEuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5227
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4KtLs5024669
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/8] libmultipath: use typedef for keyword
 handler function
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
Content-ID: <AECB1B801AA04647BDA22FF4F17C2162@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-10-06 at 15:04 -0500, Benjamin Marzinski wrote:
> Don't keep writing out the function type.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/parser.c |=A0 6 +++---
> =A0libmultipath/parser.h | 15 ++++++---------
> =A02 files changed, 9 insertions(+), 12 deletions(-)


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

