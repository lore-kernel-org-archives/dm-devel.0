Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71BC2C77B7A
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 16:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685550299;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gxrBl541FjfkleZWfJfEfmNrWG9KjYv3fdYS+lO5TE4=;
	b=OXo/LHQRitssYGLDdrirZ9nu+1u1+oRdS+/jrIYRvi7kuPdfROYk7hUv2voJrWZLA7yRhP
	gdnwfCyJz+/mJmdeLtJI/rWlRsGPC0Ur8g+Cugu55YzG2s44AT0y9uK0EKB9+yX8wjs4P1
	uqtSqJiuTsT8XkbysdGVM5Q4RVlV3xo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-RiCZNxX0PL-FnY9dE2MfTg-1; Wed, 31 May 2023 12:24:57 -0400
X-MC-Unique: RiCZNxX0PL-FnY9dE2MfTg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 65D873C0C89A;
	Wed, 31 May 2023 16:24:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 17980492B0A;
	Wed, 31 May 2023 16:24:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id EC8A719465A2;
	Wed, 31 May 2023 16:24:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A08CD1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 16:04:28 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 89AFF40C6CD6; Wed, 31 May 2023 16:04:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8164A40C6CD0
 for <dm-devel@redhat.com>; Wed, 31 May 2023 16:04:28 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5E6DE811E78
 for <dm-devel@redhat.com>; Wed, 31 May 2023 16:04:28 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04on2089.outbound.protection.outlook.com [40.107.6.89]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-kDtpMkgNP4qpucPiKVTRSA-1; Wed, 31 May 2023 12:04:24 -0400
X-MC-Unique: kDtpMkgNP4qpucPiKVTRSA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PA4PR04MB9246.eurprd04.prod.outlook.com (2603:10a6:102:2a1::16)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.22; Wed, 31 May
 2023 16:04:20 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:04:20 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/5] multipath-tools tests: add tests to verify PRIO_UDEF
 changes
Thread-Index: AQHZjpZ0s+1JkNfUz02VJmqlxzsfka90le+A
Date: Wed, 31 May 2023 16:04:20 +0000
Message-ID: <8eb67106d9313f225b499719f08a75aec31a9ce3.camel@suse.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684970472-28669-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PA4PR04MB9246:EE_
x-ms-office365-filtering-correlation-id: d5a1cbdc-1e4a-446a-8cc8-08db61f0b1ac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: CNauWNMqaeM1UVhF6R8x7jqHmlrrYA88i+jr/QqsFQzPPvTL99PlNMTFzqLzA+twMePwMSifmr6hTeNceyNa42dJ+nrUpGMs6Ym3f7qUuzXr6hgaT2CKcN2Xy0O/7Zufk8Ja7TAoeb5xQcRdUlSJxbFBq4PdnjB7ChbF+3yHEt9ac9YepXv2wnvAq5Gjf0yah4C0i6Hu5ccf61hY9vKa/GxS6YHpdrzRb/M7jIYAiaI7rXig3LUGnyCgQnXQJ9lRWdqGCg4F1A8dGAEkVmk4fSVy60EgLQqFB7+8c2wfonIo1iVGK78vbbK2ja5whXcdL4bmZpTvYJCdgeJIPg+nydZHdVkQynh6twffZJx/bjh0c0Td8XsobDHpEa2TlHCEs28CocnndjuMFNGpXmpWYjv//vVBH1qqh4EewQVSgMNjaqn8zuUmZrPr3BUPM4WRPdB4/j7uM5HXbgFQlRWdDk6Yba202Ffb2wLSKH8mw18/r2C20GOFlZtTXRGuFxFYDswjfMo9uk9csKdWU5jPFIWRJd+hc7vq9GdRBHvVbvxfU0hJG/zWgjXu0dQJjML677mcds244RMB4sVFBOTqMxdUwDusd9hw1Z+FOMEjHT2B+cabDxR15AXfFS6RHI3I
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199021)(86362001)(122000001)(38100700002)(4326008)(91956017)(38070700005)(2616005)(76116006)(66946007)(66476007)(66446008)(64756008)(83380400001)(66556008)(110136005)(478600001)(2906002)(71200400001)(6486002)(186003)(15650500001)(26005)(6512007)(316002)(6506007)(36756003)(41300700001)(44832011)(5660300002)(8676002)(8936002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?gfiR3xJ3lV0nzfxIzacDeTRhpiMCdgiNbGdj5paOZdRROghaZFMENOiRO?=
 =?iso-8859-15?Q?D55AoyfIdBOXwl1EsoZQ77NEfEjA2AmZnOcSt6zMJ0PSIrYsE3g/ZmNKE?=
 =?iso-8859-15?Q?RNdLXwRP0Aj+esPkr6uPHGe6eO3qGIS9PKajeYhJdCgd/cBzauFC2Fjh2?=
 =?iso-8859-15?Q?5j+r1t3z9awlHiRBOhGWXpYq+tLhVYft/YN5FXYT+bbR1gqc0p1K3qfea?=
 =?iso-8859-15?Q?EWFXEZAFyWLTbtjXzksPIeNc3negtaV53Dfkw3CKTN5fU6jNgmmgJAa/n?=
 =?iso-8859-15?Q?W+IxzhAh5l/Ey3ahjh+ozSEM1q8SnZQPW8KL8eq/8DMajIcGeWLyJs8xu?=
 =?iso-8859-15?Q?Da2dWdR9F5yvnWapUMqJvrmomB/eQePVUG4hr062ns0Nn9+3Re+EfxICN?=
 =?iso-8859-15?Q?au5RxlUYcJsgSiZMUckg9JBfh5fc8VCvK7CwZxO2jmhEOf7/YNlFychrT?=
 =?iso-8859-15?Q?QBGif6RYYE1V5anWt3fPuYzVyWWc21N/4/JflG7wZ8oZoCdPdeRjUxyOO?=
 =?iso-8859-15?Q?tVD8OjQsC0PA9AGcuL2kn1t42AVsKA1NRX3q2aGILKTUhy+iCO3Qgutno?=
 =?iso-8859-15?Q?p6xSq/AvjxMyWGyb5QbBZstdgmmdY4s49RAJtIm8pAAqk0Ck4dbGspNnT?=
 =?iso-8859-15?Q?FKzL7rLCG2RQWVN1XRb8cwOivsZ4dOeGN5ysGuNJ5F3pmlOZDsWBcdSw5?=
 =?iso-8859-15?Q?VgwU8h4Wr/iJ8zj18kAjR1JqHqlW8N1qJspDyg4xawM1BXydJ4HR1KcbI?=
 =?iso-8859-15?Q?zQVPnifIUL9R1dOzK7bmCTQq2w5ZuThq+zJDgZEKE5ClbuxE/5aa8A2eo?=
 =?iso-8859-15?Q?7LN49FK4jpuIGzGhEq0mT6Z2S5rz8sBwyTdeRTFWfjJjOy6OXHrTbsbyL?=
 =?iso-8859-15?Q?uiWnmdX/uQpuVJlK2KoKrIgqmhYyWQfjsfyTM3I2Yq7o2FKR/qPsKmVCC?=
 =?iso-8859-15?Q?EQwArjHzwgdhTDmL0PcHQDFQc8vjTkbYWad1cLATbmNqMD1jxvEgOeJvt?=
 =?iso-8859-15?Q?jJO2uJ1sCmSVyYgwFdvYCeopPOzjSuKRJx9oMOfWUNn0OtHGAUYV2Khj3?=
 =?iso-8859-15?Q?XSr0LaGZE2/RvtjeTgYZ28h8OeU3n428bo6CDYLuAczRGnCVoieABwjwo?=
 =?iso-8859-15?Q?XF/mBhAJJOkTBY8UTSrNW+MrGqxiiN9hy/KWusoLnW6RLjbn1aKTFxcj/?=
 =?iso-8859-15?Q?2tKM6Mj62mJ/A9H6xDuRj7WYY9A6DNxrFH/hcXTEJbVFT4D2nOe2WMyst?=
 =?iso-8859-15?Q?eexd5Bs2MNoSffB8TK68Jhj7wztcHjyvh35UvabfwXSjYEsFEZWK0+Puy?=
 =?iso-8859-15?Q?4HPKcztxYRtBuMe3bVwYrEMgJzteVh/QqjJl8RvAMvN5sIvHsf1B/wbki?=
 =?iso-8859-15?Q?zGQWbi+V950Z/3O5eOhVhy5kgWAd+nm9MbAGaRYnB74wzjtvH3R2nVud1?=
 =?iso-8859-15?Q?JOWEufaEvfj+roazF3F/xIYBcOK6tAYYzPQ/10sBRRDJKuTink1zlwcoM?=
 =?iso-8859-15?Q?UoQ8SPt/oFlMariOgrxzHV4kkhL4Dg/eyXqHbk2Zs9mQEE2Ge0t28s5jz?=
 =?iso-8859-15?Q?yOVSlQ40M5og1ZLCUag7YuQPXx5g6Ekv8RRWH58K1Tk+q6uuedVz0uZ3f?=
 =?iso-8859-15?Q?+bd6m7R2FS5xIvu+k6pkucD/y/zXpoeSoRtxmhgB/X7OmueFedi5pk9az?=
 =?iso-8859-15?Q?6/fe?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5a1cbdc-1e4a-446a-8cc8-08db61f0b1ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 16:04:20.3569 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R1RYCxhL3xMh4+CR3LasJEA8OOBjjmd6EmjOfc7aNl/ZHAWLZlHToRP7FaaPjnx8MXtA3BKQEU3sbaZJP22JWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB9246
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 2/5] multipath-tools tests: add tests to
 verify PRIO_UDEF changes
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <27851CC612E46846B3E953DEB787AC80@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> Make sure that pathgroups that include paths with a prio_UNDEF
> priority
> are properly sorted.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0tests/pgpolicy.c | 42 ++++++++++++++++++++++++++++++++++++++++++
> =A01 file changed, 42 insertions(+)
>=20
> diff --git a/tests/pgpolicy.c b/tests/pgpolicy.c
> index 85fa30ce..ccf29bc9 100644
> --- a/tests/pgpolicy.c
> +++ b/tests/pgpolicy.c
> @@ -648,6 +648,26 @@ static void
> test_group_by_prio_mixed_one_marginal8(void **state)
> =A0=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size,
> group_marginal, 7);
> =A0}
> =A0
> +static void test_group_by_prio_mixed_undef8(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int prio[] =3D {7,1,3,-1,5,2,8,2};
> +=A0=A0=A0=A0=A0=A0=A0int group0[] =3D {6};
> +=A0=A0=A0=A0=A0=A0=A0int group1[] =3D {0};
> +=A0=A0=A0=A0=A0=A0=A0int group2[] =3D {4};
> +=A0=A0=A0=A0=A0=A0=A0int group3[] =3D {2};
> +=A0=A0=A0=A0=A0=A0=A0int group4[] =3D {5,7};
> +=A0=A0=A0=A0=A0=A0=A0int group5[] =3D {1};
> +=A0=A0=A0=A0=A0=A0=A0int group6[] =3D {3};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {group0, group1, group2, group3,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 group4, group5, group6};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {1,1,1,1,2,1,1};
> +
> +=A0=A0=A0=A0=A0=A0=A0set_priority(p8, prio, 8);
> +=A0=A0=A0=A0=A0=A0=A0mp8.pgpolicyfn =3D group_by_prio;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp8, 0), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size, NUL=
L, 7);
> +}
> +
> =A0static void test_group_by_tpg_same8(void **state)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int paths[] =3D {0,1,2,3,4,5,6,7};
> @@ -828,6 +848,26 @@ static void
> test_group_by_tpg_mixed_one_marginal8(void **state)
> =A0=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size,
> group_marginal, 7);
> =A0}
> =A0
> +static void test_group_by_tpg_mixed_undef8(void **state)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int prio[] =3D {-1,2,3,-1,5,2,8,2};
> +=A0=A0=A0=A0=A0=A0=A0int tpg[] =3D {1,2,3,3,4,2,5,6};
> +=A0=A0=A0=A0=A0=A0=A0int group0[] =3D {6};
> +=A0=A0=A0=A0=A0=A0=A0int group1[] =3D {4};
> +=A0=A0=A0=A0=A0=A0=A0int group2[] =3D {2,3};
> +=A0=A0=A0=A0=A0=A0=A0int group3[] =3D {1,5};
> +=A0=A0=A0=A0=A0=A0=A0int group4[] =3D {7};
> +=A0=A0=A0=A0=A0=A0=A0int group5[] =3D {0};
> +=A0=A0=A0=A0=A0=A0=A0int *groups[] =3D {group0, group1, group2, group3,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 group4, group5};
> +=A0=A0=A0=A0=A0=A0=A0int group_size[] =3D {1,1,2,2,1,1};
> +
> +=A0=A0=A0=A0=A0=A0=A0set_priority(p8, prio, 8);
> +=A0=A0=A0=A0=A0=A0=A0set_tpg(p8, tpg, 8);
> +=A0=A0=A0=A0=A0=A0=A0mp8.pgpolicyfn =3D group_by_tpg;
> +=A0=A0=A0=A0=A0=A0=A0assert_int_equal(group_paths(&mp8, 0), 0);
> +=A0=A0=A0=A0=A0=A0=A0verify_pathgroups(&mp8, p8, groups, group_size, NUL=
L, 6);
> +}
> =A0
> =A0static void test_group_by_node_name_same8(void **state)
> =A0{
> @@ -1192,6 +1232,7 @@ int test_pgpolicies(void)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
prio_mixed_all_marginal, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
prio_mixed_half_marginal,
> 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
prio_mixed_one_marginal, 8),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_pr=
io_mixed_undef, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
tpg_same, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
tpg_different, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
tpg_mixed, 8),
> @@ -1203,6 +1244,7 @@ int test_pgpolicies(void)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
tpg_mixed_all_marginal, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
tpg_mixed_half_marginal, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
tpg_mixed_one_marginal, 8),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_tp=
g_mixed_undef, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
node_name_same, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
node_name_increasing, 8),
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0setup_test(test_group_by_=
node_name_3_groups, 8),

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

