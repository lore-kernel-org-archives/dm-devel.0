Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDDAC433EF
	for <dm-devel@archiver.kernel.org>; Mon,  2 May 2022 10:31:52 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-J8KRt14aM0m_oWV6HTB21Q-1; Mon, 02 May 2022 06:31:47 -0400
X-MC-Unique: J8KRt14aM0m_oWV6HTB21Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27C2A800882;
	Mon,  2 May 2022 10:31:46 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 7BDAAC27E89;
	Mon,  2 May 2022 10:31:44 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1EA1E194705E;
	Mon,  2 May 2022 10:31:44 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 63596194704A
 for <dm-devel@listman.corp.redhat.com>; Mon,  2 May 2022 10:31:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38778C27EAE; Mon,  2 May 2022 10:31:42 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32BF3C202D1
 for <dm-devel@redhat.com>; Mon,  2 May 2022 10:31:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 12DDD3C025D1
 for <dm-devel@redhat.com>; Mon,  2 May 2022 10:31:42 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.111.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-l4qCjo7KME6lAh_ckV8PPA-1; Mon, 02 May 2022 06:31:40 -0400
X-MC-Unique: l4qCjo7KME6lAh_ckV8PPA-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2052.outbound.protection.outlook.com [104.47.1.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-10-Kp3Rg456MrSwqlb7FclgyQ-1; Mon, 02 May 2022 12:31:38 +0200
X-MC-Unique: Kp3Rg456MrSwqlb7FclgyQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Mon, 2 May
 2022 10:31:36 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::21aa:a826:f438:827f]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::21aa:a826:f438:827f%7]) with mapi id 15.20.5206.012; Mon, 2 May 2022
 10:31:36 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] update HPE MSA builtin config
Thread-Index: AQHYXBXF8ZWLcvy5HUadA+386xOhQK0LZ2yA
Date: Mon, 2 May 2022 10:31:36 +0000
Message-ID: <dc486bce737a9784543af9d910cb4f4ea15e5260.camel@suse.com>
References: <1651270144-29953-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1651270144-29953-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba2f3655-942d-4b99-9db9-08da2c26ef74
x-ms-traffictypediagnostic: AM0PR04MB6452:EE_
x-microsoft-antispam-prvs: <AM0PR04MB6452DE654F09C00E1A2B89A4FCC19@AM0PR04MB6452.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: M9u0A8n656XFDJKJpNn6J/DVEeXUoJLLCUUBB1mMG45x2A1iD8+kUI9TXpp7r15vKCAmsiG8l/EqGid15ojKiFEXupNutrdJr9OZEhyl14wf3WXGqSvmMU7XpKTFdaonpSjYf3SAU/ps1CRuDDEZCZAlXI1/e/JnCpiyAQYS5igcqC/6JwVUkmQvgR46nZWoJoDDqke8psZU6h1he+QanpEsbEHg+vj9mj5qWWsUR/m6YQNPHy9TaO74VKAVHLGOaGZ0q+PCiVes80ZigyBKyRiXIasFSzhSC4+xPggF4uvZF0FVo84Qs33TWSnYpySrk4FsWeZC43YEurOU4teAsnKnrGSz+quFOGL4p0agbj8zaaVX0D0BUXsFEYJkXbtupVd6+obAhhAAdwMjxkrH9NS9eLzPWu4XmtKhuEg7nA5mzJ0vgPh2zFhgm3K9ywnT9G9TMReiEp/M3cqllItcUi9PCPVIQiTCP8iPGxdlUyMqC1POkSLE3CsDAhh03bOUXynJTVbZZzPZpu9bUaflh+tTFlIJQ86tevC9QGdJBW3H99u3EdMxF08HCpbbRH9cLMP9YPVR218ohW1Bqt0tow61RRdwteG1XbknxwZec7cQRETafic5bBLqu7LOyeo7jlEw3etvcxKlPmGHKwbeE1XbFP1vWxHbWbGf1FwKmmJVJU/0391EZ+X9TGawACEaJRGG1/l6GXdTum4TFk6Bqw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(4744005)(6512007)(44832011)(316002)(5660300002)(71200400001)(26005)(86362001)(2616005)(54906003)(110136005)(508600001)(6506007)(38100700002)(38070700005)(8936002)(6486002)(4326008)(36756003)(122000001)(186003)(83380400001)(66446008)(66476007)(91956017)(8676002)(66946007)(66556008)(2906002)(76116006)(64756008);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?8cfe3cvRDR6GruAy9f7680c9ClUYruGLmKyp/AWhzO0MKFuLmSPY/LP+v?=
 =?iso-8859-15?Q?7bqwpCj6pQ/5GkS7T8TaF39L/44TzynK3TAFSP0QCC7gS3THmvinzj7xC?=
 =?iso-8859-15?Q?p6zLV+46/4BRqoPLxxAPm/XMnUGTfHfA0ZWKU/qXWGbFo3ugG4aBTA+dn?=
 =?iso-8859-15?Q?cGaLVjJVBaRc2mvX7wuwh0kryVxGJKdv2wYkwGEoxZvgeUyqWgIhYGg8k?=
 =?iso-8859-15?Q?cgfAhztQyEmNttliwikxI3aEkEwwPRzOauhDXb0ZrtsQ628SjgiDf4Vbq?=
 =?iso-8859-15?Q?+LoyxrSPP8Y2BclMUkdsXH78jJPHhOMYm/pOyc35NTyJArJt6NFLLks2O?=
 =?iso-8859-15?Q?N+SwG6IurWZnVVzs6YPDil1BSZLiI/Gli3Sk5G3c1jGeexla1h+KvVMrq?=
 =?iso-8859-15?Q?Bwz1N1I9C3ULJIaQCmG0C/uqKpJ1/DT5corKt44VbXpG46yijWEnHFtHr?=
 =?iso-8859-15?Q?ImyMbqfcYfJ+7FyL4yM22FTX2l7/C5MPASbp8VBJZr7OlpmdyIqOwjDE8?=
 =?iso-8859-15?Q?3oaqXqwG4nxl1GxZf0UUqm5CDS7b+7RRejgEQWeKIvc5maNiBcPlL2/wU?=
 =?iso-8859-15?Q?LqNl39Ls7fy4Rc1xZ3QDmBkbzKmKQy+dVZuuQLyQioF62uppMZIAWjNyL?=
 =?iso-8859-15?Q?qhQ8yrhur6h+vLomY7FiaDNby2OGWzrEPR9k97BAggG6fox5Shq+IMVmo?=
 =?iso-8859-15?Q?0LFibMXdwTZUO09sjHeIxJsC89GA5taGuAo3v8Lh2hJJzzwtT0qmfU0oO?=
 =?iso-8859-15?Q?YF4ToDm4iN9IdPGAMhmXPyV9S3to3mwsTZlmD8+ekQRA4RsN9cS2VT7EU?=
 =?iso-8859-15?Q?wydAECwF4kvWqzdkbbju+idL9fy7Gaa6+7CL+9s3yXO5q72tBqZ0OKbrq?=
 =?iso-8859-15?Q?ijdGruzKY9ztnOqMWzzikmg7PsmByWp0g/gHZ/kVZEQ3hPKtnX+T+C35H?=
 =?iso-8859-15?Q?T7D3Y199T8s7BZ15hv88mP7Eil+5+ZRmD/mxCdo7bxq2K3gOc0q9SSpiF?=
 =?iso-8859-15?Q?vNxdyhr9kbsqbcGs85KzI3wyCKZWFxAoNl3VHcT5/cktvvBOGs2/WP2Qo?=
 =?iso-8859-15?Q?/cLRnsqCAsuVKS2DZAXDfCvQNJqnIPV2NkoeGPR6VFNDTPu/BaHe8Gg58?=
 =?iso-8859-15?Q?kDV6j4n7+CI0i0b3GVPsYgYlPuMfuYVjrNg8otilfl50SwINuW731rlo3?=
 =?iso-8859-15?Q?ebvwK1Y9Wn9gyOAJxQSFgajyCQDDiMgKE2jCHHV2JW1hR2VQwYUz+ZYsA?=
 =?iso-8859-15?Q?NNgdgVKCzP8GOAiiiU5R72Tia55lnyYF5RuE9dHpcxbq3YO5luyzvqZgH?=
 =?iso-8859-15?Q?TuHxQg+EgE65BJTH/QtyjuO0K09jYCY2wUliH+HvvF5iI6ITm6QHnEJAe?=
 =?iso-8859-15?Q?+OdF7j4pcLzUNfHbzJTGGeXCKQCuIwqbAn1QIhy3s1MPEW9n2z6vTJia9?=
 =?iso-8859-15?Q?uH77yKCI8y+09Y/Tq1ZcEWlcwgDPJQnCIW5Jlu+Fm5Etnq2B7gElH997a?=
 =?iso-8859-15?Q?X+cJIDsy42Wi2QCBfwKOsc3BxWJWd5r3bg3EJEfji6x/uhaUocqMWe63g?=
 =?iso-8859-15?Q?2QJO3lBupeUuc1XxYPqXEXq3RRErQUNFLBkaazfi/19sf9jXHPoVP3twT?=
 =?iso-8859-15?Q?svHFCrhJgOTtlwPu5eEYDamUK65xvS81mQODm5fP4DrRiENK3iEvmUAwx?=
 =?iso-8859-15?Q?agkEDlURrouafebmdCgBy7CmsnCXzePx/ZkzqPwkvZgGRhIUTaoT1r+Lq?=
 =?iso-8859-15?Q?6iz4tobdBVcOC5YNQW1q+NpAFZ4odnOJv16COc2q/KHHlxFM/xXp0CtKk?=
 =?iso-8859-15?Q?0rxVIxgKWUPtYHXYhc/BetlV/HRhK2/rH4IAc9Z4LokcBnu4hT8PIlS1g?=
 =?iso-8859-15?Q?f6yo=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba2f3655-942d-4b99-9db9-08da2c26ef74
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2022 10:31:36.3498 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aa3XRR1o9gGm80Rr5I7iPQoo9ToPValVJ3rnDsEmS4JR3mh6+zUkVSC1sQ26ny2GxRE3rvm4HdFEM/cMUn0a9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6452
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH] update HPE MSA builtin config
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "Jon.Paul@hpe.com" <Jon.Paul@hpe.com>,
 "xose.vazquez@gmail.com" <xose.vazquez@gmail.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <2E0E5D76D3DB5F4BB544ECFD197CE0D8@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-04-29 at 17:09 -0500, Benjamin Marzinski wrote:
> Make the config better align to MSA 4th, 5th and 6th Generation
> systems.
>=20
> Suggested-by: Jon Paul <Jon.Paul@hpe.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/hwtable.c | 4 ++--
> =A01 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 0e1c0a41..0f0795c3 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -182,8 +182,8 @@ static struct hwentry default_hw[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0},
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* MSA 1040, 1050, 1060, =
2040, 2050 and 2060 families
> */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "HP",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=A0 =
=3D "MSA [12]0[456]0 SA[NS]",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.vendor=A0=A0=A0=A0=A0=A0=
=A0 =3D "(HP|HPE)",

This changes nothing unless you use "^(HP|HPE)$", as our regex matching
is by substring.

Regards,
Martin


> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.product=A0=A0=A0=A0=A0=A0 =
=3D "MSA [12]0[456]0
> (SAN|SAS|FC|iSCSI)",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgpolicy=A0=A0=A0=A0=A0 =
=3D GROUP_BY_PRIO,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.pgfailback=A0=A0=A0 =3D =
-FAILBACK_IMMEDIATE,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.no_path_retry =3D 18,


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

