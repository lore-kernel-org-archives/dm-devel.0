Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F4141C05027
	for <dm-devel@archiver.kernel.org>; Thu,  2 Feb 2023 08:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675327508;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=O/9Y1bGgLXm1PXeFidarHem8nq7C+r0eMRATXEytE5E=;
	b=iVZvRc6V9kw6gma5O9LyWW1Hu4mU5e24h/MGxLV5go/rnohTdVBG9L3OInP6cYRf8kzdZm
	uDqn3X52mf36HFtw19xSch21VMsZGL8Ldgfx87jcKE3D1X8gST04nBEKWJUE+hpZw4O69L
	1BO5CwtPFqlYTWW8qgfUZ3Olqrbh3Lw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-yBd8mizQP5a_220fX09k3g-1; Thu, 02 Feb 2023 03:45:05 -0500
X-MC-Unique: yBd8mizQP5a_220fX09k3g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DF95800B24;
	Thu,  2 Feb 2023 08:45:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6BC13404CD80;
	Thu,  2 Feb 2023 08:45:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 09E16194658C;
	Thu,  2 Feb 2023 08:45:03 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 058BF1946586
 for <dm-devel@listman.corp.redhat.com>; Thu,  2 Feb 2023 08:45:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id DC1B6492C1B; Thu,  2 Feb 2023 08:45:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D2D51492C14
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 08:45:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A28C03C10EC2
 for <dm-devel@redhat.com>; Thu,  2 Feb 2023 08:45:00 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2080.outbound.protection.outlook.com [40.107.20.80]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-1Z31TgwVPcGUkN7Mg2anfg-1; Thu, 02 Feb 2023 03:44:57 -0500
X-MC-Unique: 1Z31TgwVPcGUkN7Mg2anfg-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS1PR04MB9655.eurprd04.prod.outlook.com (2603:10a6:20b:477::7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Thu, 2 Feb
 2023 08:44:54 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%9]) with mapi id 15.20.6043.028; Thu, 2 Feb 2023
 08:44:54 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 0/4] multipath: fix multipathd renaming issue
Thread-Index: AQHZNlXFtyvZ2dg41EmFgpBob2oV7q67WI8A
Date: Thu, 2 Feb 2023 08:44:53 +0000
Message-ID: <5cfc86dfe02c991f1aacb75a6c2ccfce289f298b.camel@suse.com>
References: <1675266989-8281-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675266989-8281-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS1PR04MB9655:EE_
x-ms-office365-filtering-correlation-id: 922c8764-77dc-401d-2d5a-08db04f9c188
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: N/YMZbIqGooOlZyrJrXE86vpxWY29pHXcJMaWFLlhsrwgk7xl4pc2VLmOYQ8jtk/5HzgK/DvXZqVez9S9ycNHL66tTPBMRxwASphhHozW2lP/j5712iywZKWZ93W2kccbscx2ggbrSqbuOcO1rrV+H3pUv1PtSfbn5zGSzpsSvzKL9sKoDSByq54MmoGdEwNYJjMKKoFd6oq7sfszrPvBNXam3m5XaDQ3vtDz+wveXqcAUlcZGZY5ldY6Wd5rN69Cs4Pno38hCkOGMxBC/YHJJkjrAxdq0YJOSovtIA9LZv2CTlylGU+9d3tuYrUjXFvPwhccz6TS5018dVaa54CEFjJi8tfh225ul6MUhdKqWnPT8y9MyKsLIwbnKg9WpyheW4gLtGMojXSsETAVgD2tEV+s3KDoBVHqff5KjP7YIki6ssa1kjRAKIa6yXh3dAHKHEywZDhyG7tqLVIco4xPx5UZwzN8ZvEaahNRc6d4H7zsQstcdAQXJaI2cgRXNdzQOaqmfnKOtIBMOxbFiCAaPeNq4i6pM5KXH7SWHS6TNAmhzpW6ce9oZy7to3tq5CcoRDlOo2i+EPXD0W6rg3tQAzlRml/ozTy06lwzXQ6yXGIiPLj0O8wdrmNKVThbYpfzZeIRSPPsclLsymP0paVCtXLpMvWDlNTbxR/VwYsD5EK/gKrk1HTDtwtY9OYOvDf8GDhK1E3yBhp3h+KI2aXqg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199018)(4326008)(8936002)(110136005)(38070700005)(26005)(6512007)(186003)(2906002)(44832011)(36756003)(71200400001)(5660300002)(478600001)(316002)(86362001)(6486002)(66446008)(76116006)(66556008)(66946007)(66476007)(8676002)(64756008)(83380400001)(6506007)(122000001)(2616005)(41300700001)(38100700002)(91956017);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?XDK2VNmqlFeCBetawhYpADbWtRwdRZzADn6UmjhDfpQn/abUizQVAYTH1?=
 =?iso-8859-15?Q?0YBxcrQ79AFKzESNkSX484hLNduZpjKudz86A78bD63IAE4WYHpa2Tt7L?=
 =?iso-8859-15?Q?1dD5Mc7xlaKuEq8Shv+RtR7EbUJJHNwKU+YTvqiB4f/ozXBqZPSjSE+nZ?=
 =?iso-8859-15?Q?zL4PtpRjeqQV6xC7/vLtd+BtQB3cIdIStUtdY8/b4AjKc4qO3eQrxWBVf?=
 =?iso-8859-15?Q?icl9liCShrWJbwa6qnUDyKiS4I06NswCt7xn4Ut/fQZNTS/6lU8VmV2oA?=
 =?iso-8859-15?Q?nS1UmvWlCL5Bkzp+Qccy7MN3h6OjsC1okNoldTGf9suValPmt3MZavmF7?=
 =?iso-8859-15?Q?jT/j60m2NLxiRRQ2PrVfJeuca448nNP0EKdtekFWXEYXgDPxVqzOri9sO?=
 =?iso-8859-15?Q?MpbxunodEkbGHY2RVyj0ThYq2hX63Fx1hjWwdJ1BSG59xDaNh9rdOjKzj?=
 =?iso-8859-15?Q?0acOII9dEDVsFfJAb3uM4ng5OfUQgm1mb13DDFsC5AMG3Gd9PC92tUh+V?=
 =?iso-8859-15?Q?cj/qzob09TC7LhGo+doaUb335rHrWDoIt3l3Nr/Zm9FFzTnacWBtPc4z6?=
 =?iso-8859-15?Q?PV/OKoTdHL4Edd9AD1HVlZKSMMC/mjKEZJ4UyCXmtlXYHZ8Dkv6pCZdHL?=
 =?iso-8859-15?Q?EG4Ms9G7pjzlLNgQk+q31fCOA3XeYvLC7W2dzLjvup3R3rbX4Ur78bT6r?=
 =?iso-8859-15?Q?w99q4ZFnXVT6p2JSx5iT/yF/ZDVTKJXJ0UMHAfVZsJoH89nJTM3QN1f/H?=
 =?iso-8859-15?Q?hM/tfEvYQmy7unibJ1AIgyuCE9CLjo452eCAQ0PQ832Zs2cPyLcBlm6bL?=
 =?iso-8859-15?Q?7+90iPE9RpfNPt4BGYAvEfF5wV8rDdAxBBSeva9SKEZi0R2QqdFA8e+yM?=
 =?iso-8859-15?Q?o404stwWTXdCC0FaBJuwTKX3pvfC6/9xfe6xXI8EGlBc/3RUxizuvA8jz?=
 =?iso-8859-15?Q?RtKFs4w69i4TXOGHyn5RYg94l9IU2xP83ITHGbet1H/Ej+h+d+RcxVKYP?=
 =?iso-8859-15?Q?+vX1x/MWC3b6jEzfkM/mE/sAJGyBxkD2ggBCEedpyNEhqeVvJPjc1/xnK?=
 =?iso-8859-15?Q?crpNhlavxcbpaD5K+de0v/0ZHu2aNt+szTFfuqU18hHVMcsifZ1mhwSLf?=
 =?iso-8859-15?Q?TlDf+TfGHfGpPyn4/FuAUcYgciHw/kQipiXEP6T5Mv0SErUQai0mbXm6e?=
 =?iso-8859-15?Q?CQ3ijcly6vBlQddvQXo5Py5wuGkxGsXcCnYk8iqQBU0ppqf2yFZM3HBWd?=
 =?iso-8859-15?Q?/UAb4MDtBhHtP6Ug1leDFLJu4063V7VP7EwmsUTtHL4DR0Wo0vN66KJKn?=
 =?iso-8859-15?Q?hqCLdLsFkUTsbjHzcqPjiDXXM8uzSK0rPxXndA54bVCjRFmTY7k9hLf6a?=
 =?iso-8859-15?Q?Spd+93occ/kT1U2i1P6Xz6K0fuUjbDcuQskJMYGgQoXl9iatqCiBgtS7M?=
 =?iso-8859-15?Q?LgRnsX6PVBwQ/YsJE/ToURlI7nex/T77q3GD54jP9pNLJ3TOML6BlwRUC?=
 =?iso-8859-15?Q?L1oYGIJmL+vCpS3sMinMMwmicHKE4MW3954t8yEy9qiH5tpI9LnVodRNt?=
 =?iso-8859-15?Q?/hLtit5fxh6Xq5gHa9LkaVwW4ak0oxG3lm4gMlPV385euIWRFiryNzIlG?=
 =?iso-8859-15?Q?89KrllWBmOj6+YqxYWt847tK+nQqJMxjNdqpMLf9oimEBgq+ULVffgGAA?=
 =?iso-8859-15?Q?6sBhxFnMdCRLTmIq1MbX9Pr7Fw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 922c8764-77dc-401d-2d5a-08db04f9c188
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 08:44:54.2727 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5m5v3T/acUJKk6/8lGfCZcc2W8n7OOPPcwM+ebef0isLVF2zPh23Kllh7ebMOA4jbWfpn7RVUW5kIYNgGVUDwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9655
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [PATCH v2 0/4] multipath: fix multipathd renaming
 issue
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A256D6F4838FC64E8E2C46E9F3262B8B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-02-01 at 09:56 -0600, Benjamin Marzinski wrote:
> If a multipath device needs to be renamed and reloaded when
> multipathd
> starts, it will only get reloaded. This can happen if the multipath
> configuration is different between the initramfs and regular
> filesystem.
> The only thing that can happen along with a rename is a force reload.
>=20
> This patchset makes libmultipath also do all the other actions that
> are
> compatible with a rename.
>=20
> changes in v2 (as suggested by Martin Wilck)
> 0004: If the rename is impossible, multipath now checks for other
> =A0=A0=A0=A0=A0 actions, instead of always returning ACT_IMPOSSIBLE
>=20
> Benjamin Marzinski (4):
> =A0 libmultipath: use select_reload_action in select_action
> =A0 libmultipath: select resize action even if reload is forced
> =A0 libmultipath: cleanup ACT_CREATE code in select_action
> =A0 libmultipath: keep renames from stopping other multipath actions
>=20
> =A0libmultipath/configure.c | 107 +++++++++++++++++--------------------
> --
> =A0libmultipath/configure.h |=A0=A0 4 +-
> =A02 files changed, 49 insertions(+), 62 deletions(-)
>=20


For the series:

Reviewed-by: Martin Wilck <mwilck@suse.com>

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

