Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0026FC7EE23
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686164373;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=sOIj2Ac8JYUlwUmS5iBoqfPFzTOtC4SsloU5gLOHo5o=;
	b=FaihRoAEFkpf/BqbgzmH+nOxiKORHG6PPRiPsIPXl6rCBI1dyKbZab0crSoKKAZi4iPS48
	wXz7T6w1aPKyC8ivvcG2N31zNzw4DYGJw32B8P9mOJVnSHQki8q9yxZEUzVm8zrrWIfuYO
	mr19nmqrYa6DZL46sEvsOmPmMvJ/TZ8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-637-yYcq7eR-OKu-o3fAdj4CPw-1; Wed, 07 Jun 2023 14:59:30 -0400
X-MC-Unique: yYcq7eR-OKu-o3fAdj4CPw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0955811E88;
	Wed,  7 Jun 2023 18:59:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 63E912166B25;
	Wed,  7 Jun 2023 18:59:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 31DE019452C3;
	Wed,  7 Jun 2023 18:59:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 8BDD719465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 18:59:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7CE8D403375; Wed,  7 Jun 2023 18:59:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 747D8400F4E
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:59:26 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54D61801585
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:59:26 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on2089.outbound.protection.outlook.com [40.107.13.89]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-639-7j0HGXTRM9GW8eShvTLSxA-1; Wed, 07 Jun 2023 14:59:24 -0400
X-MC-Unique: 7j0HGXTRM9GW8eShvTLSxA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DBBPR04MB7996.eurprd04.prod.outlook.com (2603:10a6:10:1e3::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 18:59:21 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6455.034; Wed, 7 Jun 2023
 18:59:21 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 10/11] multipathd: reload map if the path groups are
 out of order
Thread-Index: AQHZmLNdbZ+/mwz+SUSF7mtwzetckK9/su0A
Date: Wed, 7 Jun 2023 18:59:21 +0000
Message-ID: <3c00f23075b5a15a0a514b176231ec9c388bf3c7.camel@suse.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
 <1686082391-29210-11-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686082391-29210-11-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DBBPR04MB7996:EE_
x-ms-office365-filtering-correlation-id: d475922c-f8b8-464d-9618-08db67894dee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 5FOwT6DBiDaceTG6iqVYpKwZG8+nwVbTcudtM/LbzBPk0BmjJR2Tp9/uJfDxwpj1Q50NdxINTvP65YBTPmUH7IpNITjw3JXxOyou5s5+/blUQEtE4y4OqrQ0yx0BjbDnK+Di+cocB2M76Qq89fvtUQPlzv3C3zEghvDHLGiTlwm+Fn4u/3DMpbwIuN7CLQ2CQYZxs4VpNvmAFIXtOxONXL7tv5GlWVhmdE457eBLaNYySTpC8jB7N/tncs4hs34t4B2Tb8oIjSJ+0XAn0s+1nN62ivF8qKWlW+BMAMcjgbBc/eWrd7S1VTGxLQTd6MC/zvJBJYPIzzzIjKE8JI2wo3EPuM7wBoCnGEBXYxWeA5KyRH8+iyTHNWV1U5MS9mYrpaAr3TKLeT8ZvDb0g1/VqmRdQEHcBO0KNnSwHj+5+yIuvfh1kPwXofCT6zIVqBZLExn8oOCqOfSXq4vQYccGunKw1Mw33UzQa9ApEgvl1WvwKd8GKhn4g3YoBlmjSmL80n38PSl6K0wjL88QmtIQel60NQ5hwTPcQOSNaWq1S8dJUecLeMkQdNwADcEf+tzFlUSa45c5uBwu8jB2T+YS/y3EDYQoy8R6g8ykFVAcaMLwYIKk++yYLgGlCnmWiqJP
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(136003)(39860400002)(376002)(396003)(366004)(346002)(451199021)(36756003)(2906002)(38070700005)(86362001)(44832011)(5660300002)(76116006)(83380400001)(6486002)(71200400001)(186003)(26005)(6506007)(6512007)(91956017)(478600001)(110136005)(66556008)(122000001)(66476007)(4326008)(38100700002)(316002)(66446008)(66946007)(2616005)(64756008)(8936002)(41300700001)(8676002);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?qNQcgEZsz7mPqdcI9Wz7jK89ufxRDoLLZESPgd6UhyUDTYeiMjGuuOTIW?=
 =?iso-8859-15?Q?eMQOMEKEM7wwrsbL6+NQNvyTN3VHtV3C+RDDb4+z6NGpo+CP39FVWBvRe?=
 =?iso-8859-15?Q?uXYQwvf8ghI8rggnfo/s4PQ2jhMZ7m4Ymn8qPTaFCrj3c48rC6Gl1jhVY?=
 =?iso-8859-15?Q?JFBrGlLd1renfxKYHlZgm/2Q6oEVoGN5J/SMkhQoDEzd6ZGS30ZvarskT?=
 =?iso-8859-15?Q?RqBF8DqF4WVy8JB/rBhvCx0ISgq7KPjSk68LS7g5KLzi2hk38IjwnJ6mz?=
 =?iso-8859-15?Q?08GgGa1bbr1UldDvltIM9ppQoafEAL4b7DSi6qVKiMDaDrxM3FBmSpMPS?=
 =?iso-8859-15?Q?3hYnxyQdhuYm6sl/N7V5jzNB1jtHzrdFDXdzj7lCAMlSrV49wVTdHiBh1?=
 =?iso-8859-15?Q?aOZXZp4/m3BjRkLpgX6LReWjRw/4omXpWcKGPUs/L5fjJgNb7MjpobrG3?=
 =?iso-8859-15?Q?6b82+tyPfxsDVrKAWorn1hHFJMDUtmg9V2/p/yRVP/H41kPCfpS9LBiSF?=
 =?iso-8859-15?Q?SdQKl99J+Jku/OafBh0QgM6T2GBFQ6XlD2OlJJosKhYbOEb/ArAuH/XUJ?=
 =?iso-8859-15?Q?gfqpdk8xo1m8/bE9i1xn3OUQRV4GAw6T+xtseHyjqN7w2AOAxm9gLhVS/?=
 =?iso-8859-15?Q?aEMOcIFJ18hHyLyWgOi/At7HPmTrvni0IhXJNbpRHWunz8KYisf8hZD8/?=
 =?iso-8859-15?Q?9RgI3hFVeGfasPa29s5258HRiWNTBrpCyOdRlwnJ9omekYC9jebKRL0NZ?=
 =?iso-8859-15?Q?5uMZx2CWU6Lbgh3Mw2sPBkVvyOBUfEzTcD5fcd0DjM8rBJZ/MlRUqfBUO?=
 =?iso-8859-15?Q?hW9ogetAz/CHnsCHhtIvyP0ck8O0cG5rQQdOuYZ10DB1C7xSSFvpGW066?=
 =?iso-8859-15?Q?oZ0lRjim3NZAzvixqfoXybzutZihOEOOJRlMkbCZfEyfq3n4EvJgICBKM?=
 =?iso-8859-15?Q?vp2pA/ODclAFKxcKkVQgVpdGh72TrtU+6EIacjYEM3U6q7EpT6UMJaKB2?=
 =?iso-8859-15?Q?wvY00v8UwS7vdim2tqUg/uI0D4PGaqcnd8ndkGRBaRlF+BEZSz5UEyBAm?=
 =?iso-8859-15?Q?Sm08mIvATvag5h5KNOkAMZUIVVUkoJHxiXfLiecvopGgSjs19LT4QwDsD?=
 =?iso-8859-15?Q?vizKSLxyT9uAo+nbuA0PgYDhWLBZV1Ws1er90+VFMPKvPRKi5CRoFWOxv?=
 =?iso-8859-15?Q?WPis2PX9uBDk7YQi/k5rnn4sx9r7WR6VjMx/V7LtvsptOta/+5cIKWBAW?=
 =?iso-8859-15?Q?szMZRqePnK97z+eNrPSmu/yU+iBqow53je7xkzqov5wDu0q9gb+PkMyLe?=
 =?iso-8859-15?Q?QaLdrDbFynsvsyOjx6vGJlnQDPXiIoOClAZD8GUhl6BVEM9rcRp6sgTD6?=
 =?iso-8859-15?Q?2xhRNQdku0NClMORy9ZE2gyXRqwTzEsrqMWQRuQA98J6sn5zEuhSJW8yH?=
 =?iso-8859-15?Q?FkwPBN5sS2FrgJNKYKVP0Ez3PM9DZBiRePaTpKo3ANxdVLvOkWqL1XsHw?=
 =?iso-8859-15?Q?iuaCqraC9Nnbu8/amQVabQWTF/UPNvnP8qj3DPs+f8pX8SFa9pfG/mfGp?=
 =?iso-8859-15?Q?x0sQ4bPpDQrXtCwY03mGe/iIe7aaz8X6u31Nu62iv9/5Rql5exPADZZ6L?=
 =?iso-8859-15?Q?OjQplMCYjpxRqHZ+nae4ADOXjl44GAioxloUjHtWehirqrPNCLI9yiyMv?=
 =?iso-8859-15?Q?9vet?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d475922c-f8b8-464d-9618-08db67894dee
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 18:59:21.8107 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l2YAvLjdrTJZQKVdQL0N8xF5nDofHUmpEg5z9Pleqr7EtltsbF4nrxN7TSpOiloQxFqyt81YlY5KH89b2vYpOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7996
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH V2 10/11] multipathd: reload map if the path
 groups are out of order
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <A847AD41BBE8EF4E8288A7FDBBF95A2D@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-06-06 at 15:13 -0500, Benjamin Marzinski wrote:
> need_switch_pathgroup() only checks if the currently used pathgroup
> is
> not the highest priority pathgroup. If it isn't, all multipathd does
> is
> instruct the kernel to switch to the correct pathgroup.=A0 However, the
> kernel treats the pathgroups as if they were ordered by priority.
> When
> the kernel runs out of paths to use in the currently selected
> pathgroup,
> it will start checking the pathgroups in order until it finds one
> with
> usable paths.
>=20
> need_switch_pathgroup() should also check if the pathgroups are out
> of
> order, and if so, multipathd should reload the map to reorder them
> correctly.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0multipathd/main.c | 69 ++++++++++++++++++++++++++++++++++++++-------
> --
> =A01 file changed, 57 insertions(+), 12 deletions(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index f603d143..05c74e9e 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -395,11 +395,46 @@ void
> put_multipath_config(__attribute__((unused)) void *arg)
> =A0=A0=A0=A0=A0=A0=A0=A0rcu_read_unlock();
> =A0}
> =A0
> +/*
> + * The path group orderings that this function finds acceptible are
> different
> + * from now select_path_group determines the best pathgroup. The
> idea here is
> + * to only trigger a kernel reload when it is obvious that the
> pathgroups would
> + * be out of order, even if all the paths were usable. Thus
> pathgroups with
> + * PRIO_UNDEF are skipped, and the number of enabled paths doesn't
> matter here.
> + */
> +bool path_groups_in_order(struct multipath *mpp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int i;
> +=A0=A0=A0=A0=A0=A0=A0struct pathgroup *pgp;
> +=A0=A0=A0=A0=A0=A0=A0bool seen_marginal_pg =3D false;
> +=A0=A0=A0=A0=A0=A0=A0int last_prio =3D INT_MAX;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (VECTOR_SIZE(mpp->pg) < 2)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mpp->pg, pgp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* skip pgs with PRIO_UNDEF=
, since this is likely
> temporary */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!pgp->paths || pgp->pri=
ority =3D=3D PRIO_UNDEF)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->marginal && !seen_=
marginal_pg) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0las=
t_prio =3D INT_MAX;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (seen_marginal_pg && !pg=
p->marginal)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn false;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->priority > last_pr=
io)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn false;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0last_prio =3D pgp->priority=
;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return true;
> +}

I still don't get the logic here. What's the point of using
seen_marginal_pg if it is always false? See my previous reply to v1 of
this patch.

Regards
Martin



> +
> =A0static int
> -need_switch_pathgroup (struct multipath * mpp)
> +need_switch_pathgroup (struct multipath * mpp, bool *need_reload)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int bestpg;
> =A0
> +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D false;
> =A0=A0=A0=A0=A0=A0=A0=A0if (!mpp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> @@ -411,10 +446,9 @@ need_switch_pathgroup (struct multipath * mpp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0mpp->bestpg =3D bestpg;
> -=A0=A0=A0=A0=A0=A0=A0if (mpp->bestpg !=3D mpp->nextpg)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D !path_groups_in_order(mpp);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0return (*need_reload || mpp->bestpg !=3D mpp->nextp=
g);
> =A0}
> =A0
> =A0static void
> @@ -1963,20 +1997,26 @@ ghost_delay_tick(struct vectors *vecs)
> =A0}
> =A0
> =A0static void
> -deferred_failback_tick (vector mpvec)
> +deferred_failback_tick (struct vectors *vecs)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int i;
> +=A0=A0=A0=A0=A0=A0=A0bool need_reload;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (mpvec, mpp, i) {
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (vecs->mpvec, mpp, i) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * deferred failback gett=
ing sooner
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->pgfailback > 0 &=
& mpp->failback_tick > 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->failback_tick--;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(!mpp->failback_tick &&
> need_switch_pathgroup(mpp))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(mpp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(!mpp->failback_tick &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 need_switch_pathgroup(mpp, &need_reload))
> {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (need_reload)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(mpp,
> vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(mpp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0}
> @@ -2219,6 +2259,7 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> =A0=A0=A0=A0=A0=A0=A0=A0int marginal_pathgroups, marginal_changed =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0int ret;
> +=A0=A0=A0=A0=A0=A0=A0bool need_reload;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (((pp->initialized =3D=3D INIT_OK || pp->initi=
alized =3D=3D
> INIT_PARTIAL ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->initialized =3D=3D INIT_REQUE=
STED_UDEV) && !pp->mpp) ||
> @@ -2548,13 +2589,17 @@ check_path (struct vectors * vecs, struct
> path * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: path prio=
rities changed. reloading",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->mpp->alias);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp->m=
pp, vecs);
> -=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pathgroup(pp->mpp)) {
> +=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_pathgroup(pp->mpp, &need_rel=
oad)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->mpp->pgfailback >=
 0 &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (new_path_up ||=
 pp->mpp->failback_tick <=3D 0))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->mpp->failback_tick =3D pp->mpp->pgfailback
> + 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (pp->mpp->pgfailb=
ack =3D=3D -FAILBACK_IMMEDIATE
> ||
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (c=
hkr_new_path_up &&
> followover_should_failback(pp)))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0swi=
tch_pathgroup(pp->mpp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (c=
hkr_new_path_up &&
> followover_should_failback(pp))) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(need_reload)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp->mpp, vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
e
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(pp->mpp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0}
> @@ -2680,7 +2725,7 @@ unlock:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(clea=
nup_lock, &vecs->lock);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0deferred_failback_tick(vecs=
->mpvec);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0deferred_failback_tick(vecs=
);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0retry_count_tick(vecs->mp=
vec);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0missing_uev_wait_tick(vec=
s);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ghost_delay_tick(vecs);



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

