Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A34FC4332F
	for <dm-devel@archiver.kernel.org>; Thu, 20 Oct 2022 14:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666277920;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=+uBbHw+wGfq9xj09e3dTp3/99vOJGzbHgjkzxwAY2ko=;
	b=HQNR2aWVwlJFYN+HeowUwyhwrKBSobF/iZgZMKPciBKikAVVhbh0zlrE2tlXUcXpCNotZM
	WbrXPilUv2Ji23VGa3ld9N/EuH73nIdKVMcuuAkGzx2q3Tog0WvkbVAL9SLywhRPgCBMZ8
	/4iCZ9Albm3mIDGdtENGzE3otuxW/Uk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-KFzw1mNDM6iy9lcOAbImzw-1; Thu, 20 Oct 2022 10:58:36 -0400
X-MC-Unique: KFzw1mNDM6iy9lcOAbImzw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75472382F1A8;
	Thu, 20 Oct 2022 14:58:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 62B0D1415113;
	Thu, 20 Oct 2022 14:58:34 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 328971946595;
	Thu, 20 Oct 2022 14:58:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9205C1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 20 Oct 2022 14:58:33 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 785BDFD48; Thu, 20 Oct 2022 14:58:33 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6F8537AE5
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:58:33 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 531AA800186
 for <dm-devel@redhat.com>; Thu, 20 Oct 2022 14:58:33 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-eopbgr80071.outbound.protection.outlook.com [40.107.8.71]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-45-WYgVj7I2P8ScqtqJNm9jiQ-1; Thu, 20 Oct 2022 10:58:31 -0400
X-MC-Unique: WYgVj7I2P8ScqtqJNm9jiQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DU0PR04MB9465.eurprd04.prod.outlook.com (2603:10a6:10:359::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Thu, 20 Oct
 2022 14:58:28 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Thu, 20 Oct 2022
 14:58:27 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/8] libmultipath: cleanup add_feature
Thread-Index: AQHY5JRp4HFCs2eY50ev8Wrpt7Lxsw==
Date: Thu, 20 Oct 2022 14:58:27 +0000
Message-ID: <8cabe57ff1a14216626c6b7b73ff0e5c1ee5d94f.camel@suse.com>
References: <1665164144-6716-1-git-send-email-bmarzins@redhat.com>
 <1665164144-6716-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665164144-6716-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DU0PR04MB9465:EE_
x-ms-office365-filtering-correlation-id: c6ddf333-6122-4de8-51ce-08dab2ab8bac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: VHia0ZvgD0vltib3UMXUr41nzpB5J2O7GAwBADz5TGsPFuR6+EmrW/wWq7U0PpiaHtVd0oLOmRQW447UFYbXXaMNKrLlxMkH1k5yXJ2oq8IMVKAWcI1S691GUioHUrpKa20rVxEri2divlUtr3GGmm1Q6gGsVyqS6jMhzCOdMLaKV/bQLgnfCm99akMgUkew79L9yk0zqvBeI4UzL4e0e4lrh+Eb1Gow2VEZhWh9PPaPcwUO/lwcdr8ijo6Z/Wj+D/34ktZ0oY5au7gZ75W6QJ1EjTvu7iBEoxaIfhAID0bymVMprAwgHnkAWAQ9BKzIiCD5W7u1qXfVafCOBNRKS0g2lR/LY3BXThAyJV8nxppYVvZHpyeaxM94NGgBOTXI4D8Di5Gfry4JbrMjleoAhpY5HDDByje2M4GqHieQq1hnnYKpWzihLgiOAuY4H3OcPU9prnccT/8v2oIUOX2Wtxf0+4SeyvcpBMY3px5BX+LJbBuXt14A1fAeCvvafZT8F3V4rQ2NSnPJbQvvySQHUwsNN0Ga8vwodYNYkjjvu3zygMNmksGsnOVs3YqYQOLJgUZIWqAhygolJxF5g3EIkC8pVJvsfVrTPPt2myCYUCik6WjODSArlSv9TFTB3BxqRymRIPSZ3LfFeca3GiJuB3gThuufkMiQONr3kEG21aCVqqkiXkyWuFSDhFywAIU0W0q6YqoUgSa2c43pJ+U3E5o+FuHPneKFjKgoSnZbpuThkwVjXqrXutLxRB3lXvectv0p9boTH/3YAG5u0pGtzw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(396003)(39860400002)(366004)(376002)(346002)(136003)(451199015)(8936002)(478600001)(6506007)(110136005)(71200400001)(6486002)(66476007)(26005)(64756008)(5660300002)(6512007)(66556008)(66946007)(66446008)(8676002)(76116006)(41300700001)(2616005)(4326008)(44832011)(83380400001)(38070700005)(316002)(2906002)(38100700002)(122000001)(36756003)(86362001)(186003);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?+j0SpUYt52PTlXs1XSecWpbCz+CH6yalC51Rj1dH5V8Q7R5P6BWy9Sugu?=
 =?iso-8859-15?Q?J9266ZJb2JzKCCQEeMouG/r09bS6hjDb5LlwKl2Vt7YY8JKzVChX6m2Nm?=
 =?iso-8859-15?Q?0zHT3D9PYl4eg8OX+Kb0/9In8JYbwZr2fLsbPuA9CST2Yq0huW49LHHYs?=
 =?iso-8859-15?Q?8DdNrMQyEjyi/O9CHPbojPUQDjPgCl22rLkcEFIjZd5AhDZSxw7VWx963?=
 =?iso-8859-15?Q?gkaGIQuufcKfFjuuoXMW+hBiG0dyVI3KTUn9ECHqPJtMm5hhpDSLKl6LA?=
 =?iso-8859-15?Q?DW3Eev/w8u4J2bNLDVQ3zPuNPD6ncon1nCujK8Sa100Rv2LsuTMvjWQju?=
 =?iso-8859-15?Q?rXZRyBvt5M+OP0JRV7j9WINTPheoY7KV1nZdAl1rL3hPU77XxRq5eEIK3?=
 =?iso-8859-15?Q?9oTYaFIpgU/qNWpKyuHdE1cFcFI6KnF6ulS/TpkyLAOGHCIHmIKB+JDNj?=
 =?iso-8859-15?Q?ZOISbDHgwtJQn2H97y2osh6OxtVSflJFnv0ofh9xN7v78ZfXSqDS10AGa?=
 =?iso-8859-15?Q?1CwWfBRuVO8o4ZKX+G6WCZHS/yQjoCE6OrQZ8IB03lgseZcPyfFP9yhUr?=
 =?iso-8859-15?Q?c2tH9ccZ/gRCewsDIcx1yPhPf+mle0JqU4m4epFHi1v5yoQbZDOTknT8H?=
 =?iso-8859-15?Q?iAMT11hTNpK5ITPXqLIZiJUKp80S9DT0Bpc93RQNcTbRZLFwfAoMOLEDk?=
 =?iso-8859-15?Q?qOXkpcu3AUSnkslEfKpLD+IddEfJN/+h9g3nBRHEhh/8TYS+jqfYP+H6o?=
 =?iso-8859-15?Q?AY/qEDTom94ZhGq/3sfMsUEYMg4J9gPtF4eJUfvCkOqHVZVR/QqevjSZS?=
 =?iso-8859-15?Q?gzDUhxRHPHZBPfsE12bUg/ZJ9ox1sfxZcaJrnWpvqpkFkl3hVP2AiQsLo?=
 =?iso-8859-15?Q?478JBd8/6Od9s+qucQvVwtBcFBOS324TwSntHB3guX2ysWoQwOxqp4x/t?=
 =?iso-8859-15?Q?en4Olk160d5B41OYfM+KHcdMyH6+p0aM8thFIa1nStK17r3gOLbjpaxaj?=
 =?iso-8859-15?Q?BeqWXArFrffjqPIIbMhUE1AMkSHjVwbjMpySU1O7qEfvkZTG8uih84pf9?=
 =?iso-8859-15?Q?tWebb0GshL4gjpSXIacyHoUDFdbJEk+AbcaRapaQ/6XfsLvBXNMWHdVaV?=
 =?iso-8859-15?Q?bUCLHAoJsvD+Iex6vOM3B8W07MJOYuMWp33YT1VTxmnQdJeqE3jlwvV2d?=
 =?iso-8859-15?Q?NwygGbdlLy0CTVfDTl49/EREjN8vWoxVlihV5e6hsqBUMMtatMa/myAsN?=
 =?iso-8859-15?Q?nQgyZur5a1l7zcEt0RH0NcCH++EdEyEM1pdtUdK+suMeSLb3GGsN9OcA2?=
 =?iso-8859-15?Q?0dI4sKWnXLgo/e59JBcVCLoRp74vesLr4V3SzH5jpUPrnxiIw9CZGQoD1?=
 =?iso-8859-15?Q?xkSyK9z3UD9WLRSE2W2ws2meyYZDMSrt7yzN1jjKm2w0IBK8LDNGuGHfL?=
 =?iso-8859-15?Q?WEECA7tXbFORTR/fyxqh0wXf/dIKPiDbr4viTi5xadiXWOf07eNHZ7cyH?=
 =?iso-8859-15?Q?yPt3Jl610Er2hhu48M9Z7Rjbwc4u9AgY/5uJreu8ei//vGWgr2M8Ivqma?=
 =?iso-8859-15?Q?TQvfGTTBuTif2m7TA/yNjtaZk1qpN6JRIDECsNkfz3xLHk5hGUEkN0PzX?=
 =?iso-8859-15?Q?tewjZo+eN0qcwLg6arJEOEeM5sn44wNptpGLh4QVOyxRNmHZ0DfFnGy+M?=
 =?iso-8859-15?Q?NB/FX5aE5QZyohIXvC7W8w/L0g=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6ddf333-6122-4de8-51ce-08dab2ab8bac
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2022 14:58:27.8199 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hFQwAvXezxS6cadBWzANclUib/bPTuiV6vTAP6yGetBSB2wuO+I+NU6L62Puqq/uBnpQE7CQQliNbGTa5s1BiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9465
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 2/8] libmultipath: cleanup add_feature
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <934D441D2844624BB981C83410CE7936@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2022-10-07 at 12:35 -0500, Benjamin Marzinski wrote:
> add_feature() didn't correctly handle feature strings that used
> whitespace other than spaces, which the kernel allows. It also didn't
> allow adding features with multiple tokens. When it looked to see if
> the
> feature string to be added already existed, it didn't check if the
> match
> was part of a larger token. Finally, it did unnecessary work.=A0 By
> using
> asprintf() to create the string, the function can be signifcantly
> simplified.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

The same general remarks apply as for 01/08.

> ---
> =A0libmultipath/structs.c | 49 +++++++++++++++++++++-------------------
> --
> =A01 file changed, 24 insertions(+), 25 deletions(-)
>=20
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 1f9945e0..0f16c071 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -602,23 +602,33 @@ int add_feature(char **f, const char *n)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int c =3D 0, d, l;
> =A0=A0=A0=A0=A0=A0=A0=A0char *e, *t;
> +=A0=A0=A0=A0=A0=A0=A0const char *p;

Same remark as before about the variable naming.=20

> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (!f)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/* Nothing to do */
> -=A0=A0=A0=A0=A0=A0=A0if (!n || *n =3D=3D '0')
> +=A0=A0=A0=A0=A0=A0=A0if (!n || *n =3D=3D '\0')

ouch...

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

