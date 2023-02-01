Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6A55C05027
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 08:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675238437;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=eKnpzjsauUAM5tcdUvGIStCWIozFCRvDGRVg5TweD38=;
	b=i8Ory8sIff/vvYRfotKn1b9poUKuIfIP7ZW03wGF4VhKhTaV/d5Cl850IqjJLtSW2aRDTf
	0zXwtDszbKcUrk3fovki+7QdsISsS2JhUHSoSKSJxOtO4XBQ8D4Qj3FQUtAaezTC44n7VV
	K8cj6EqOb8NpCUsaAFZOduvacXePEVg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-mAxZcGLsPnSxMgI3DOqqLA-1; Wed, 01 Feb 2023 03:00:33 -0500
X-MC-Unique: mAxZcGLsPnSxMgI3DOqqLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DF302817234;
	Wed,  1 Feb 2023 08:00:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0771440C2064;
	Wed,  1 Feb 2023 08:00:32 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EDE001946595;
	Wed,  1 Feb 2023 08:00:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 50C611946595
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 08:00:31 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3BF9853A0; Wed,  1 Feb 2023 08:00:31 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 32D6A422AE
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 08:00:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0E514857A89
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 08:00:31 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04on2065.outbound.protection.outlook.com [40.107.6.65]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-144-gTFVG_ilOr2DQYdEJiL0OA-1; Wed, 01 Feb 2023 03:00:27 -0500
X-MC-Unique: gTFVG_ilOr2DQYdEJiL0OA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PAXPR04MB8475.eurprd04.prod.outlook.com (2603:10a6:102:1de::13)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Wed, 1 Feb
 2023 08:00:25 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%9]) with mapi id 15.20.6043.028; Wed, 1 Feb 2023
 08:00:25 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/4] libmultipath: keep renames from stopping other
 multipath actions
Thread-Index: AQHZNasNdibzGBrjF0a5rX6LpFB6fK65uyMA
Date: Wed, 1 Feb 2023 08:00:25 +0000
Message-ID: <75e8e7c39785a85b068f65c49f9c334f95fcaf24.camel@suse.com>
References: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
 <1675193661-1147-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675193661-1147-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PAXPR04MB8475:EE_
x-ms-office365-filtering-correlation-id: a6a53441-718f-4506-bfc1-08db042a603c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: jBo+RRvaK/tV+JIOVUN0M5Tx7H7bD0Ywft5b4Qdvb2Mk9YXWo0H8aSDmDPNDLra65ZmbeW2Ue3JQE58y7THUo9UTEPxkKXJ3JU0JO1ufjbQA8TWR1wW1kkY/5YWOd3e3yh6RA9zuJ6yx8smruZtRxPt+ynHs/xcpYTTND1IlJcISWZUNaEO2HlTpJq7X0HndwQKhyzwoaEnKxFT4nsVTNDXy8X+5YlXSoxmm/Wl6vdrXYO32nFv2WyuObPeNfscGbMswjkQGY3iyDL9GkWhpFersvxgZ+3xv8VXfFH4XXTG8gQOnPL3ZZyRjg0RvYEO5dbFsOlY6jmTSTQlqOZkGhTgiPA4OOg81cNPofGd+yrvgzUnhZWCuQ09i752OA27+gkde8c5uyM0yUvFTEutN7hOBu7nuJ8Lurp7yIT3vpcTYWzjjIyXSpUL60OyskPDewWZdnQX1ZWy3iIcXMc0Om3LLXwSYKeczUgbeT5ccjSwCimC8aofmIYjPRNJQVdcxg3ebc7gr7fclWGpdC7/Qnf/BsGzwAp4n7bpUySGqitKpMveOfSrgZtzcdinN36YHhwov/K24TV+HerU8mrgC9V5+svdTD1bmHQEsduJQH/Pcbyv42IxXI2CxAhKhdEKJwNlIJdH/jyVrLdmNE5wZDy6kg8vCSCySboswcfkPVyR76Txg5bVnZPDJ6EuKZBO5WuuESJ0LNLQn4QSPsS5xKw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(136003)(346002)(366004)(396003)(39860400002)(376002)(451199018)(86362001)(36756003)(38070700005)(38100700002)(122000001)(110136005)(66946007)(64756008)(66556008)(66476007)(66446008)(76116006)(8936002)(4326008)(91956017)(316002)(8676002)(41300700001)(44832011)(2906002)(83380400001)(2616005)(478600001)(6486002)(186003)(26005)(6512007)(6506007)(71200400001)(5660300002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?a7dUS5O313Qqyj0n7fXUpSr5Pze/uZsS57JFH7HI1OGi8yOVSr+v5eFSm?=
 =?iso-8859-15?Q?FEumuwVjt5Xqv6DmEf2d61nOj2kdyCKEn8KMYgR/JVan80glI7nPauivM?=
 =?iso-8859-15?Q?GwG85QgC1sFvNTKnzzdTKEdN+UmNDl2ExZmMkR1OHCC16T5LP4vlKVc+/?=
 =?iso-8859-15?Q?wCfS7En2ox89Mn5IEul+AhpfZD1eW/aTLNEhrO9z+IEa/3tf2nATAX/kD?=
 =?iso-8859-15?Q?qFl0jy1a5wYpMfOiFE5AzpbVcvrmdlJRutBxTi0btlQYpU8w93f7uyS7H?=
 =?iso-8859-15?Q?3Nw5Dw6zyqgOuNtBRcKrLwp9Axy5RUDClujy2yfVAoIAS0r3Mo54vnvrS?=
 =?iso-8859-15?Q?DGytWcHhIHyeEmG911GCSjdrb6whgt/5bDr1NE2FVxqLH+KId35PgmoFB?=
 =?iso-8859-15?Q?ork/xvinHeOW3BgoW8m4wkLcWqX3UzCBzNGAJUWiqZLnTmE5NfJ8NADGe?=
 =?iso-8859-15?Q?aUJU0qCfi0O9gon31wNvRTCZiutmkd50VNDAPHesIfAyAX96qLvsA6BgF?=
 =?iso-8859-15?Q?Uf/shwE9Ibup3vbhr7UpfdgKCgtYkta9lOtuzApE6h2+fuUICwM2mrfXC?=
 =?iso-8859-15?Q?UnajI69VUOuERB/gALAt8mdBoaqJhar3dVc8EfjXR0CGaHpmTMeaiFOHe?=
 =?iso-8859-15?Q?0r4+C6o+DvVIvhqVf+Y7xAkmiRHY1f9p0xhpgy6stLOGi4XSaocdgFgGQ?=
 =?iso-8859-15?Q?JL+4WfQUedGcaY3ruHgTf0qOGcqidIRKlbN4UmiMkjHX0xcRBVNNTQom/?=
 =?iso-8859-15?Q?DS/2EyaJKNSfizo3eq/pmvB/Bwm4t4Wx3PpI9Y7WWfsVTjFv08Q93O8MR?=
 =?iso-8859-15?Q?3ZRYkLCkfMV4ThG+v37fhJB2arqJoEYJAuZa/15fodHU6mYCZGsL/5iMM?=
 =?iso-8859-15?Q?rro4+VSyG8mGKLDqRgiYC4iI3W8Z3e6zyfCTmjFHFZozTXYfd1SIAkwot?=
 =?iso-8859-15?Q?wLS8BDTqT0UBrDPI1uEpZ2rmJriPS3LcljTrYeSNgG9ZvJzDdPgdZfEnw?=
 =?iso-8859-15?Q?mtm8uB7rbQBkeXN4/U5PuHr4PchuiBSk0WsTGEimRmkXj4xsDlGCIpUPa?=
 =?iso-8859-15?Q?vFuWp4K0foz0qDsstOZDpGY0881SLH0sHqQzdnCQa8uR+d++a5kAJMEAA?=
 =?iso-8859-15?Q?MR7Em07QKfngjz8DzauoVEl8lm2/lDHTvCC0ObtmpuSW34t+LHcCHBLiW?=
 =?iso-8859-15?Q?W4WKXTJlJapjO1d1DqgYHTzwGEHJ3LHv8f3ntXqgUVu7CyagmIhZpcjZh?=
 =?iso-8859-15?Q?mavV6+smEKj7briVNWoLvFFgI8ggkn9q0bDc1anvz2cg0LC9E29DMn5bZ?=
 =?iso-8859-15?Q?smfHxifIbcC0hPUvqoaCn6PJ/xxmUbg8rU44JPkRBfmO8ncmemqgvya21?=
 =?iso-8859-15?Q?RAHdj1qSby0wiye7jKMY97gdXoXSdjlmqfJbbABwVcl3Jl9Hb88cDwAFo?=
 =?iso-8859-15?Q?4htI5Mvx287YTofAWeO1RRGGesp+R3pHrWruLwbJ2yNBRSQ0asP5P0/Kg?=
 =?iso-8859-15?Q?IwaFoqzk9rU8Rlrut66VcXXO5NeM1jc8+EXTO2NOQpElR8IM5bFP1snNj?=
 =?iso-8859-15?Q?HruqrUuDMUEJg1d5E2QD3krkKNOGWDBQb3OUsZ+JBcbnWf7YFL3xD5Pkx?=
 =?iso-8859-15?Q?1mqHEUtSqb5cBmGd91Jy+7+0xIPpPPEkQaLVDmK9TSTZ9Qt9G1jvNX9hl?=
 =?iso-8859-15?Q?usS1zS5dYU+WVLzpjoCKuTk9cg=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6a53441-718f-4506-bfc1-08db042a603c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 08:00:25.2163 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BxaesUgLfMVBY1JiI2pmClf74UI7yMsOQTUzKlisDWLLhL4A8pOrsoBkXOZP81pvTL4ycnrHTP57ih9pofMmJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8475
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: Re: [dm-devel] [PATCH 4/4] libmultipath: keep renames from stopping
 other multipath actions
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <554A732028950B4EAC56BAA29FC19FB0@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-01-31 at 13:34 -0600, Benjamin Marzinski wrote:
> If select_action() is called and a multipath device needs to be
> renamed,
> the code currently checks if force_reload is set, and if so, does the
> reload after the rename.=A0 But if force_reload isn't set, only the
> rename
> happens, regardless of what other actions are needed. This can happen
> if
> multipathd starts up and a device needs both a reload and a rename.
>=20
> Make multipath check for resize, reload, and switch pathgroup along
> with
> rename, and do both if necessary.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks good, but I have some questions below.

> ---
> =A0libmultipath/configure.c | 60 +++++++++++++++++---------------------
> --
> =A0libmultipath/configure.h |=A0 4 ++-
> =A02 files changed, 29 insertions(+), 35 deletions(-)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index e870e0f6..2228176d 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -670,7 +670,8 @@ static bool is_udev_ready(struct multipath *cmpp)
> =A0static void
> =A0select_reload_action(struct multipath *mpp, const char *reason)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_RELOAD;
> +=A0=A0=A0=A0=A0=A0=A0mpp->action =3D mpp->action =3D=3D ACT_RENAME ? ACT=
_RELOAD_RENAME :
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ACT_RELOAD;
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_RELOAD (%s)", mpp->alias,=
 reason);
> =A0}
> =A0
> @@ -681,6 +682,7 @@ void select_action (struct multipath *mpp, const
> struct _vector *curmp,
> =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * cmpp_by_name;
> =A0=A0=A0=A0=A0=A0=A0=A0char * mpp_feat, * cmpp_feat;
> =A0
> +=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_NOTHING;
> =A0=A0=A0=A0=A0=A0=A0=A0cmpp =3D find_mp_by_wwid(curmp, mpp->wwid);
> =A0=A0=A0=A0=A0=A0=A0=A0cmpp_by_name =3D find_mp_by_alias(curmp, mpp->ali=
as);
> =A0=A0=A0=A0=A0=A0=A0=A0if (mpp->need_reload || (cmpp && cmpp->need_reloa=
d))
> @@ -705,14 +707,8 @@ void select_action (struct multipath *mpp, const
> struct _vector *curmp,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->alias);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strlcpy(mpp->alias_old, c=
mpp->alias, WWID_SIZE);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_RENAM=
E;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (force_reload) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->force_udev_reload =3D 1;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->action =3D ACT_FORCERENAME;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> -=A0=A0=A0=A0=A0=A0=A0}
> -
> -=A0=A0=A0=A0=A0=A0=A0if (cmpp !=3D cmpp_by_name) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* don't return here. Check=
 for other needed actions
> */
> +=A0=A0=A0=A0=A0=A0=A0} else if (cmpp !=3D cmpp_by_name) {

Why does your "check for other needed actions" logic not apply for this
case? AFAICS, even if we can't rename the map, we might need to resize
or reload.=20


> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: unable to=
 rename %s to %s (%s is used
> by %s)",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->wwid, cmpp->alias, mpp->alias,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->alias, cmpp_by_name->wwid);
> @@ -725,7 +721,8 @@ void select_action (struct multipath *mpp, const
> struct _vector *curmp,
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (cmpp->size !=3D mpp->size) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->force_udev_reload =
=3D 1;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_RESIZE;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D mpp->action=
 =3D=3D ACT_RENAME ?
> ACT_RESIZE_RENAME :
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 ACT_RESIZE;


This code makes we wonder if we should transform the ACT_... enum into
a bitmap of required actions that would be ORed together.
At least ACT_RENAME is now orthogonal to the rest of the actions.

> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_R=
ESIZE (size change)",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->alias);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> @@ -801,14 +798,14 @@ void select_action (struct multipath *mpp,
> const struct _vector *curmp,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0if (cmpp->nextpg !=3D mpp->bestpg) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_SWITCHP=
G;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D mpp->action=
 =3D=3D ACT_RENAME ?
> ACT_SWITCHPG_RENAME :
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 ACT_SWITCHPG;

See above.

> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_S=
WITCHPG (next path group
> change)",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->alias);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_NOTHING;
> -=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_NOTHING (map unchanged)",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias);
> +=A0=A0=A0=A0=A0=A0=A0if (mpp->action =3D=3D ACT_NOTHING)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: set ACT_NOT=
HING (map unchanged)",
> mpp->alias);
> =A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0}
> =A0
> @@ -909,6 +906,17 @@ int domap(struct multipath *mpp, char *params,
> int is_daemon)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (mpp->action =3D=3D ACT_RENAME || mpp->action =
=3D=3D
> ACT_SWITCHPG_RENAME ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mpp->action =3D=3D ACT_RELOAD_RENAME ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 mpp->action =3D=3D ACT_RESIZE_RENAME) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipath_conf=
ig();
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(put_mu=
ltipath_config, conf);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_rename(mpp->alias_=
old, mpp->alias,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 conf->partition_delim, mpp-
> >skip_kpartx);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (r =3D=3D DOMAP_FAIL)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn r;
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0switch (mpp->action) {
> =A0=A0=A0=A0=A0=A0=A0=A0case ACT_REJECT:
> =A0=A0=A0=A0=A0=A0=A0=A0case ACT_NOTHING:
> @@ -916,6 +924,7 @@ int domap(struct multipath *mpp, char *params,
> int is_daemon)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return DOMAP_EXIST;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0case ACT_SWITCHPG:
> +=A0=A0=A0=A0=A0=A0=A0case ACT_SWITCHPG_RENAME:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_switchgroup(mpp->alias=
, mpp->bestpg);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * we may have avoided re=
instating paths because
> there where in
> @@ -942,6 +951,7 @@ int domap(struct multipath *mpp, char *params,
> int is_daemon)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0case ACT_RELOAD:
> +=A0=A0=A0=A0=A0=A0=A0case ACT_RELOAD_RENAME:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sysfs_set_max_sectors_kb(=
mpp, 1);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->ghost_delay_tick=
 > 0 && pathcount(mpp,
> PATH_UP))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->ghost_delay_tick =3D 0;
> @@ -949,6 +959,7 @@ int domap(struct multipath *mpp, char *params,
> int is_daemon)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0case ACT_RESIZE:
> +=A0=A0=A0=A0=A0=A0=A0case ACT_RESIZE_RENAME:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sysfs_set_max_sectors_kb(=
mpp, 1);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->ghost_delay_tick=
 > 0 && pathcount(mpp,
> PATH_UP))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->ghost_delay_tick =3D 0;
> @@ -956,29 +967,10 @@ int domap(struct multipath *mpp, char *params,
> int is_daemon)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0case ACT_RENAME:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipath_conf=
ig();
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(put_mu=
ltipath_config, conf);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_rename(mpp->alias_=
old, mpp->alias,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 conf->partition_delim, mpp-
> >skip_kpartx);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> -
> -=A0=A0=A0=A0=A0=A0=A0case ACT_FORCERENAME:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipath_conf=
ig();
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(put_mu=
ltipath_config, conf);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D dm_rename(mpp->alias_=
old, mpp->alias,
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0 conf->partition_delim, mpp-
> >skip_kpartx);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (r) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sys=
fs_set_max_sectors_kb(mpp, 1);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(mpp->ghost_delay_tick > 0 &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 pathcount(mpp, PATH_UP))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0mpp->ghost_delay_tick =3D 0;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =
=3D dm_addmap_reload(mpp, params, 0);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0default:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r =3D DOMAP_FAIL;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> diff --git a/libmultipath/configure.h b/libmultipath/configure.h
> index 2bf73e65..9d935db3 100644
> --- a/libmultipath/configure.h
> +++ b/libmultipath/configure.h
> @@ -18,9 +18,11 @@ enum actions {
> =A0=A0=A0=A0=A0=A0=A0=A0ACT_RENAME,
> =A0=A0=A0=A0=A0=A0=A0=A0ACT_CREATE,
> =A0=A0=A0=A0=A0=A0=A0=A0ACT_RESIZE,
> -=A0=A0=A0=A0=A0=A0=A0ACT_FORCERENAME,
> +=A0=A0=A0=A0=A0=A0=A0ACT_RELOAD_RENAME,
> =A0=A0=A0=A0=A0=A0=A0=A0ACT_DRY_RUN,
> =A0=A0=A0=A0=A0=A0=A0=A0ACT_IMPOSSIBLE,
> +=A0=A0=A0=A0=A0=A0=A0ACT_RESIZE_RENAME,
> +=A0=A0=A0=A0=A0=A0=A0ACT_SWITCHPG_RENAME,
> =A0};
> =A0
> =A0/*



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

