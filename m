Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 478B6C433EF
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jul 2022 09:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1657704051;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=Kx4zTC3rDANvA5+CkM8swNWWrE+bHZUG1M7h8Y2Kx3U=;
	b=YuJS6B7CK31AzamYa21D9fca2uUTMtmECXR9onkIeXKRQ1DCI17g6uWQa2agDyeOqYHQj7
	8mWLai8oGvwgq3WpTb/HMOzdEl9X6h66vcRlzTCdQQSKoLUiXZC34VYBs8aGSwLw+KpvNz
	49vA6O1VPQ3Ak3Xbn0zTxbEb/nSBvPY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-148-1hVqxsa0Nee6PxSRErsoAw-1; Wed, 13 Jul 2022 05:20:43 -0400
X-MC-Unique: 1hVqxsa0Nee6PxSRErsoAw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AE83101A592;
	Wed, 13 Jul 2022 09:20:42 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B8DED18EBB;
	Wed, 13 Jul 2022 09:20:41 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 38DFA1947061;
	Wed, 13 Jul 2022 09:20:41 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6CFAA194705F
 for <dm-devel@listman.corp.redhat.com>; Wed, 13 Jul 2022 09:20:40 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 50A102166B2A; Wed, 13 Jul 2022 09:20:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BC342166B26
 for <dm-devel@redhat.com>; Wed, 13 Jul 2022 09:20:40 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 296B6185A7B2
 for <dm-devel@redhat.com>; Wed, 13 Jul 2022 09:20:40 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com
 (mail-eopbgr150050.outbound.protection.outlook.com [40.107.15.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-439-Sa8Y2ngpONe4HZeRPGsY2A-1; Wed, 13 Jul 2022 05:20:36 -0400
X-MC-Unique: Sa8Y2ngpONe4HZeRPGsY2A-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by VI1PR04MB5808.eurprd04.prod.outlook.com (2603:10a6:803:e4::33)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 09:20:33 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::e9df:371c:4db4:5dc4]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::e9df:371c:4db4:5dc4%4]) with mapi id 15.20.5438.012; Wed, 13 Jul 2022
 09:20:33 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: fix find_multipaths_timeout for unknown
 hardware
Thread-Index: AQHYljsniZ5rbo+pNUq0aSnLlmakcK18ByMA
Date: Wed, 13 Jul 2022 09:20:33 +0000
Message-ID: <0edbefd22fe627457526f49a9df60b7422f1321f.camel@suse.com>
References: <1657663371-11080-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1657663371-11080-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.2
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fc1d50f0-90c2-48ac-3234-08da64b0f034
x-ms-traffictypediagnostic: VI1PR04MB5808:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 6ifT43edH2hZaHPeNty4kIfg1RkzpK2Msmaan31p49uwrK/CdThkQoTmEuQ7dvF6M0TClQBn0VqeTaxrshvKQ8jiHbisCDXPRhOG0EIXmIjz1Tr8akSI0EpcXwNLIxnHVLPeb3NHO9Fl8xX9PgKiJjHv+G3TqBq4ae2UQtPyrw4mt2WZ+2GftcT6j/4M6jGj152lt0GMteH5XuQoelA5M/bnhnhkcOT+lp598G0BbB6UYT9ILSLqyNBanikHCGAIDA1KzUZO8Of2fxoFqCpu4jafSUycT0Y1Q36zCB3y7wAEkHLsXyGmJd1pRMZfQCPJAVBS5wloUasbopldf9qpUfzh5EtLOby7XsrBIUUSnOwE4ZRhf5113zv7r7tE4JRhrCxkMzM4+6mMK8T/CMOycz9pjKNcEfknRZEGFek5jCQwh98iTPVCltvsuK2SHh0ZpNggIQ7krFoCk1WUHCMPnoKlXl/yU931m0zj7BVl7VdRLeH6/d8rVC+f6bIUJuijoiSrkhV4OuDRYfwnfdwwAurRIVu2PHWy7n1EvBjj7+nmMXpjXGMQV/+rKOd6Cd/ZXxal2AXm9tmwXV5B0MoPyVcTDhu3ZZOpcjhtHOJmIYsS5qK7+TCiBJCPYmlFsLKkYXqQmgioFwqieu5wWBbX2cIlQZIn3paxCv0Vh9rpDfDxNyGXOdKutebvuYl+ql5ta4x/XdiZ2Us3jCaMNZwJsaSWd0YHJ1Ih2FvfrRAetypm20MvmV1KCuGuoLDsYrL6YOPyvM3dzzKrLxqPIsPG/GBzhPX+cIN6/B6WKuGcVnwL9UB7vhYDtFpvVwPepzte
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(346002)(366004)(396003)(39860400002)(376002)(136003)(86362001)(2616005)(66446008)(66556008)(38100700002)(4326008)(8936002)(66476007)(64756008)(76116006)(41300700001)(5660300002)(26005)(186003)(8676002)(110136005)(91956017)(6506007)(71200400001)(6512007)(316002)(66946007)(6486002)(83380400001)(38070700005)(2906002)(478600001)(44832011)(122000001)(4744005)(36756003);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?MBxeBrGunauwecH96xZJp6fyzzsEPKpnKs5I47ToifOlrUyClMn8h3a8G?=
 =?iso-8859-15?Q?q+SzGzBJzn/qtmbefI3e6EAIBwjG2/BDH742cEpTEbo2QMsQ+3+rRYRn/?=
 =?iso-8859-15?Q?mrG0shO/dnivF29B/q370bsHKbVgdKh6dRPO9Tl+ArvXDazX2TEt3WlMZ?=
 =?iso-8859-15?Q?KofqevBxNylp9zwxFE9uVqrtLjjK8kznNJ0wLc4QtlzYNNdoITovhvOrH?=
 =?iso-8859-15?Q?Rbj3iss35/h7nFdjfZWPy1BAKQyUnhDYp981erG1hprL/2lRneME16KjT?=
 =?iso-8859-15?Q?eIRqkMa16rKC6NxtBlOBNBpny45WnVYy4XPAGTcZ2Hxe+ffTP/Ndxc5HY?=
 =?iso-8859-15?Q?xegVluwW4KeKIwqcQG9mWh3YkpPTbrpnUfeWQQFreRF059jH/HNQtzi16?=
 =?iso-8859-15?Q?FU3Ay+SCp6mkgOhhAsY1r7wHzFfxsfFM0Q69u5R4+SheKEN0g9svrPdKf?=
 =?iso-8859-15?Q?Pan1rCY8BRuTmkgLoydY1K3C0uXxttQBI7v2nKxQKeD5KV3JtCGaFRgFH?=
 =?iso-8859-15?Q?5EoFBu3dulGfdZlC+eE09G2/L5DQJlyiMgqwK6AjeBBHJvIcGsW8s5UYq?=
 =?iso-8859-15?Q?hshDwCStVWrRIrQRVnVDgC+f6cbiwA35wlWDOiYpjL7FAq6eJrzc/AWKx?=
 =?iso-8859-15?Q?OqOTctg3FM4F2WhjwW2QQpZM76nepOK8E5maycHNeCwmr12INH/j7i/GV?=
 =?iso-8859-15?Q?4qzVGXKZyd9WB/LszdsH/wKb2ENxvnbkxh3wmZpj6fVyNIzK14U7ClAWk?=
 =?iso-8859-15?Q?1ZOyRiWJEpgEoKN9Sza/Z2x+6/sRA4Svddo/35XVPaH6ivPCS2V5ttVdS?=
 =?iso-8859-15?Q?8VmOaW7FpViM1aBk8R7/WZc68FOhZ3nSCoi5hKxb5H84Z5zka+qb3ZbRS?=
 =?iso-8859-15?Q?hOmi83k2RjXvQzepHPDctBeeL4u2M64u8h9oam1NEAf61fbqkaWip26ST?=
 =?iso-8859-15?Q?NzolkubJpVTK/0vWxsXnWpIq0J2cKlDO++S1UYT7+LVyR+P8tJAUQKIL8?=
 =?iso-8859-15?Q?LxDQGY1WiIwGvtRaVVm/8mnXFe1TY7yNsBbdmw09EF0r2zLjCppME2JXp?=
 =?iso-8859-15?Q?r5iYLbCqqopyQmrvfemRYKWi1+oToNZr00FaN8G1ddVimadyK5qftTLq0?=
 =?iso-8859-15?Q?Rk6RZuFFY/e8QyMZ3XrwvD2ycfze3ptgSO28TNCiElIflbyJSSX+jGkM9?=
 =?iso-8859-15?Q?O3P9OspzyX+RW0Vf5ftr22v+y9iDRYPRIuLKk7HuRlPmwaOGLZIPqvysh?=
 =?iso-8859-15?Q?1KwexlMxXXDyKlpn7L5C2pFIyexpUxkX9G/NYw7qTsL4k6/s5dzM636pt?=
 =?iso-8859-15?Q?OLNPAWpcChi7t70k5MpIHJXjQ0aHDjoTysQtYOP/fwYXLCNzjfmZ9FsIz?=
 =?iso-8859-15?Q?eEsMzlQb/6SjoZ2vAk3ny5kqn9B7Nzku7WqEfL/T++uOHdq2c8Iny7Dxx?=
 =?iso-8859-15?Q?s14x2gG1KfcIh/WHuiRLXg38CG7shqYfAyS3OaAC8Z95jE7MIImUtzgbY?=
 =?iso-8859-15?Q?GuWc5k0uXcrxK7QEN5Kz4D68KNDuVxMKHAA4VMM7XfD6AvzUmKRY4JZLg?=
 =?iso-8859-15?Q?L61Hc6gPQn8ZvZ2BA4PIzf+V8Poey+bk0tk+z8jKtuagUI7TLK0JIP2m3?=
 =?iso-8859-15?Q?jZelbnd7pVAxlmnXaMmxH1PdMOXiodtHbr1ijcZb/QSK1alZ+3du8vrle?=
 =?iso-8859-15?Q?VbMtwoYQ3q/WFSxIhpJzpDLd0w=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc1d50f0-90c2-48ac-3234-08da64b0f034
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jul 2022 09:20:33.2695 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cwxIIhrZL3k+vZwpDQwML37UmbxecgDp3aOLc4j4zhs1Wi0Z4tr0bQGURGgUj53hLDrv4KfGwV721uxLVUGqRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5808
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Subject: Re: [dm-devel] [PATCH] libmultipath: fix find_multipaths_timeout
 for unknown hardware
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <CD2208ECC6C86444A40DF735BD33BC5F@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-07-12 at 17:02 -0500, Benjamin Marzinski wrote:
> pp->hwe is now a vector that will always be allocated for all path
> devices. Instead of checking if it is NULL, check if it is empty.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/propsel.c | 2 +-
> =A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 50d0b5c8..f782f251 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -1293,7 +1293,7 @@ out:
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0if (pp->find_multipaths_timeout < 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->find_multipaths_timeo=
ut =3D -pp-
> >find_multipaths_timeout;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!pp->hwe) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (VECTOR_SIZE(pp->hwe) =
=3D=3D 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->find_multipaths_timeout =3D
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0DEFAULT_UNKNOWN_FIND_MULTIPATHS_TIMEO
> UT;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0o=
rigin =3D "(default for unknown hardware)";

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

