Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FBBFC7EE2F
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 15:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685548119;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wOwepSrKwN0aqv+VhtGPf1GoQ0OX5HHc9Uegy8g7Z/Q=;
	b=FMwGcD79ChLok2TN2VB8IVDh7chNJx7V7+Za6ACFtRNtodFPVbPQIghPivNDKj7eF/jLok
	BGkAHmkOrttFOnl8g+nbPqYNuLrb12rnWNrK5NOMOiE/Ddzj3Q9mLK1wGyqPTsexYg1xo/
	I0Ngc+KEFxgSnW1YfZpQpPNdb0AElGw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-XLUHs55cO5O9zqtfitwsng-1; Wed, 31 May 2023 11:48:38 -0400
X-MC-Unique: XLUHs55cO5O9zqtfitwsng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09E17185A78B;
	Wed, 31 May 2023 15:48:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AFCB2C154D7;
	Wed, 31 May 2023 15:48:29 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6CF4719465A8;
	Wed, 31 May 2023 15:48:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 09FC619465A2
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 15:45:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0E1E040CFD49; Wed, 31 May 2023 15:45:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 044FA40CFD48
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:45:05 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BC4991C06925
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:45:05 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2076.outbound.protection.outlook.com [40.107.20.76]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-215-kt4wPtu-MO-iE0pCtQTBLw-1; Wed, 31 May 2023 11:45:02 -0400
X-MC-Unique: kt4wPtu-MO-iE0pCtQTBLw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AM8PR04MB7329.eurprd04.prod.outlook.com (2603:10a6:20b:1d0::23)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 15:44:58 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:44:58 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 5/5] libmultipath: add "detect_pgpolicy" config option
Thread-Index: AQHZiqX75/wtl+ehlEeDU+M+1nFbx690mGeA
Date: Wed, 31 May 2023 15:44:58 +0000
Message-ID: <a84a184d9e7624a6377ecfcab4d9f7c01d06d975.camel@suse.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
 <1684537332-23033-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684537332-23033-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AM8PR04MB7329:EE_
x-ms-office365-filtering-correlation-id: f6e4d129-770a-4bc6-dff6-08db61edfcf7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: PCvgqlmNz4tjQ64tOsGSUsXM+s5GX5LjsFMydEApp2udpvC8JKjKghTDalUKnm3b9L+pwOgt6rW5KChEI450PmE4XMW615PD9TYyYFKrZmyUbQxJXFN5wpe4LpkcwZ4qZawlPzPIVsDIYz0qrn2pxXZwbMntko+M11JOrCojMZasWl39kFTb3S4k1GFuvLIH8sHayTvVhCqdwnSvIH0GaoaqzkaczQDX3laMCcWuCqbgL7a+TlNJRGd1jDYo3GGtI1e8jgh+jX6TVZXjzrjRagDj6+8cXsIoW0eW6FMbQNrEVvhFC79UxLnHVSG0wIQmJr+MvsLoRNn6B5jBsyYNBrFPxilVB6w522hFFO8o9f+4rBjwLb+2q++TDb0dM/QcXJftzX22Qk0c4Eu3kH60wxF6nxqapkcben9GT1n4okF7X0POpwHITTE1jm/+9AMeUcxLMPOS4PwuX46npDOKtxwMvGgqKRKVqurqcGwZwGPY3jW6jDH+1bnXOn4pnyzZ4FsQcae5tS1i6LSPIo8qISQ2J7PR7cs16ZA8xgZnsWfKR3lNxHMHuI0yF0OlZ7cRrlTsgoLzQVoysGDveFZUDNbbocUCnMNS4COfWTVR2DERun8p0OuNDI7Iksu6V1Yu
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199021)(66446008)(66556008)(66946007)(66476007)(44832011)(64756008)(4326008)(8676002)(8936002)(86362001)(41300700001)(316002)(76116006)(91956017)(110136005)(5660300002)(38070700005)(2906002)(30864003)(478600001)(71200400001)(38100700002)(122000001)(83380400001)(186003)(26005)(6506007)(6512007)(6486002)(36756003)(2616005);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?NFyF+cB5dI4YKyX3dgIdKeKNuZqJphkYyXH6av/zfhVrPQkio3hQoMNFg?=
 =?iso-8859-15?Q?8N3aW6MLRfN91fVG4EU63NOGkqiwzDKFT5xNJUpWakF+xuzt0ljWVaZcj?=
 =?iso-8859-15?Q?NmG9LxjpHiY3xuRaI5pTU2ojBg1QuNd15V2F/dA4xVyBavwyGliCJNOTH?=
 =?iso-8859-15?Q?jx1Y2q7CKuuncQcLrLe6FHdN+lmqDSDI22VTtS2MQZQArSUfcvinqT/Oq?=
 =?iso-8859-15?Q?/+TsrvPj30HOI3xJIw4urA42n5ZESSpf0/ZGY/CtLAvv8eR+LeUNcsS49?=
 =?iso-8859-15?Q?NC6HPvj5xr2NXqf9nZd+bLEB8fYD5WC+Oj5JwBsZoqL52vTS3RClYqv8e?=
 =?iso-8859-15?Q?QYywAW0u1hCcrAck9UF3fgGiel/kE6S0BZPnyWg+9flG3j+ysAYZU/jY9?=
 =?iso-8859-15?Q?eDCi5cMyb7xX6XLfiSJCQ2HahLdjWAqPzOJEWVlLHIn6VkYNPnFWOdepo?=
 =?iso-8859-15?Q?4uSW+qWx9LzJBBZM8GUxQM6MimzY/IuCzjzoRKcw+Nvnl95PE0KP3o5m/?=
 =?iso-8859-15?Q?awO+JihSbG6xXsKWkn6vUD/R4A0u0FEiR6bFr5B5EI6lyxBwMa0gAG6t+?=
 =?iso-8859-15?Q?X6bWSQcwmG3zR3UbTAvBVElPfjz4ok7jqMSrWQEkH6uS7Ibh0AMQWYp8s?=
 =?iso-8859-15?Q?WGHgf7gtl2tr/dihl+EphP+JpON6fBfnyvj11jkEVnE5QH9NDrSXdHtwS?=
 =?iso-8859-15?Q?z1GaDclMSUCZWoY907dwqkZMRXkH8pp4QsfvE0O//COkSMu7ooHKhjFq9?=
 =?iso-8859-15?Q?mtzbk6RbAHP09OkHaTFuZxQZtsL0sRuAEQ7STXq9RSxJ2OAOm9c3wN9tF?=
 =?iso-8859-15?Q?SZ2yG/B64EvYfy2wQJFRMMSx7urBlfZCaJo1ViCYQKc3XPd5H/vppiOFG?=
 =?iso-8859-15?Q?a2plvll+7BTGaI9w/6gXSO/mKYMYzVQqd0y7ccGWTi+rmpsmGeQgLl6jd?=
 =?iso-8859-15?Q?cywR6ctuV2FMsZwE8V/4jdK0xg4L7hFQQfv9NbydmPFRy0x99bLi3yNfd?=
 =?iso-8859-15?Q?vq3Ri7dziHkIezIfJJ/cjbqvuPjiqhcf+//eY8MLTHRIrOvaw3unVINaT?=
 =?iso-8859-15?Q?QO6FeYes8tim6+EhPnPlXZ8N456LpqONmcISr0g75hDbjbgVCKqCGm1kj?=
 =?iso-8859-15?Q?sp7pZySrnb2/QtrlAHyYYurpyzo0EwnR7fk6HSXLpAhgy1d+NyFeuG3sS?=
 =?iso-8859-15?Q?P5QvIFAaBTDMYrq972EqcLvFAXeA936YezVuFK+l0Z9E8K+Pu3YH1tUey?=
 =?iso-8859-15?Q?/KWNcNKwLU8TBwTeArPxg3lrMKiFtRbrWwS7t8W9+CKX3OyUfBwT0cZdQ?=
 =?iso-8859-15?Q?PFqZK26700h8MDMRg6YvsR5IyEB8wUnrTOJaRUGsrX2OB75DHMlBNXUfx?=
 =?iso-8859-15?Q?MbLjomWFGHPvo+kjyQxdhIQVxZWYdhxUGKllLs0I2WeBoHqD6yky4Bl07?=
 =?iso-8859-15?Q?rdla491XlRa/T+G+Fq53IY6pYpSM2udFbW/2ncz1BsthF8zha3Iy4/Z0Y?=
 =?iso-8859-15?Q?+lrDNJ1G7+IbXrJoIW6fEOwNXaGjU8A1aoMePOqCGDWzuR8wrex5IS4sr?=
 =?iso-8859-15?Q?yO6WEsEeZjeEE8Q9l5RRzM8dMUnX/x63S1JE/wejmAH5+vZPh5PR7ac5m?=
 =?iso-8859-15?Q?Gc2dy+a6sdQLDFNZPxl99COl6Xa0v0zGqdTtDD4ZFzKMF8vw9yrA2qg10?=
 =?iso-8859-15?Q?x95j?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6e4d129-770a-4bc6-dff6-08db61edfcf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 15:44:58.1921 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TWllptvLSpm/LFd7C1m9Tvkdc1ZVSHXtxBhORVaveZQB/2Y7rb1ucg4TN0can3axca8yRvECfhE534TKLg+8Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7329
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: Re: [dm-devel] [PATCH 5/5] libmultipath: add "detect_pgpolicy"
 config option
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <A177338707D5C4468D06A37B353E4FE5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> This allows configuations to use "group_by_tpg" if alua is
> autodetected
> and another policy if it isn't, so they can work with detect_prio.

This is a bit confusing. We might have introduced this kind of
autodetection without group_by_tpg; using group_by_prio for arrays with
ALUA support would have made quite a bit of sense.

What this patch really does is to make multipath-tools prefer
group_by_tpg over group_by_prio if it finds that ALUA is supported.=A0
Should this be a separate option, perhaps?

 - detect_pgpolicy: use an ALUA-based pgpolicy if available
 - detect_pgpolicy_prefer_tpg: prefer group_by_tpg over group_by_prio
   for arrays supporting ALUA.

This way users could benefit from ALUA autodetection without switching
to the TPG algorithm automatically.

Or do we have good arguments that group_by_tpg is always "better" than
group_by_prio if ALUA is supported? I guess it might be, but it still
needs to prove its usefulness it practice.

Also, if we add the auto-detection feature, I think it should default
to ON, at least upstream.

Regards,
Martin

>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 ++
> =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 ++
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/defaults.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 11 +++=
++++++++
> =A0libmultipath/hwtable.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/libmultipath.version | 10 +++-------
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 23 +++++++++=
+++++++++++++-
> =A0libmultipath/propsel.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 7 +++++++
> =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0=A0 | 12 ++++++++++++
> =A011 files changed, 63 insertions(+), 8 deletions(-)
>=20
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 5c5c0726..2e742373 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -452,6 +452,7 @@ merge_hwe (struct hwentry * dst, struct hwentry *
> src)
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(retain_hwhandler);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(detect_prio);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(detect_checker);
> +=A0=A0=A0=A0=A0=A0=A0merge_num(detect_pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(deferred_remove);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(delay_watch_checks);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(delay_wait_checks);
> @@ -617,6 +618,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
> =A0=A0=A0=A0=A0=A0=A0=A0hwe->retain_hwhandler =3D dhwe->retain_hwhandler;
> =A0=A0=A0=A0=A0=A0=A0=A0hwe->detect_prio =3D dhwe->detect_prio;
> =A0=A0=A0=A0=A0=A0=A0=A0hwe->detect_checker =3D dhwe->detect_checker;
> +=A0=A0=A0=A0=A0=A0=A0hwe->detect_pgpolicy =3D dhwe->detect_pgpolicy;
> =A0=A0=A0=A0=A0=A0=A0=A0hwe->ghost_delay =3D dhwe->ghost_delay;
> =A0=A0=A0=A0=A0=A0=A0=A0hwe->vpd_vendor_id =3D dhwe->vpd_vendor_id;
> =A0
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 87947469..014c6849 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -76,6 +76,7 @@ struct hwentry {
> =A0=A0=A0=A0=A0=A0=A0=A0int retain_hwhandler;
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_prio;
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_checker;
> +=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy;
> =A0=A0=A0=A0=A0=A0=A0=A0int deferred_remove;
> =A0=A0=A0=A0=A0=A0=A0=A0int delay_watch_checks;
> =A0=A0=A0=A0=A0=A0=A0=A0int delay_wait_checks;
> @@ -171,6 +172,7 @@ struct config {
> =A0=A0=A0=A0=A0=A0=A0=A0int retain_hwhandler;
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_prio;
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_checker;
> +=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy;
> =A0=A0=A0=A0=A0=A0=A0=A0int force_sync;
> =A0=A0=A0=A0=A0=A0=A0=A0int deferred_remove;
> =A0=A0=A0=A0=A0=A0=A0=A0int processed_main_config;
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 4a1c28bb..366b166f 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -304,6 +304,7 @@ int setup_map(struct multipath *mpp, char
> **params, struct vectors *vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(put_multipath_config, conf);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0select_pgfailback(conf, mpp);
> +=A0=A0=A0=A0=A0=A0=A0select_detect_pgpolicy(conf, mpp);
> =A0=A0=A0=A0=A0=A0=A0=A0select_pgpolicy(conf, mpp);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index a5e9ea0c..090baa5c 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -29,6 +29,7 @@
> =A0#define DEFAULT_RETAIN_HWHANDLER RETAIN_HWHANDLER_ON
> =A0#define DEFAULT_DETECT_PRIO=A0=A0=A0=A0DETECT_PRIO_ON
> =A0#define DEFAULT_DETECT_CHECKER=A0DETECT_CHECKER_ON
> +#define DEFAULT_DETECT_PGPOLICY=A0=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_O=
FF
> =A0#define DEFAULT_DEFERRED_REMOVE=A0=A0=A0=A0=A0=A0=A0=A0DEFERRED_REMOVE=
_OFF
> =A0#define DEFAULT_DELAY_CHECKS=A0=A0=A0NU_NO
> =A0#define DEFAULT_ERR_CHECKS=A0=A0=A0=A0=A0NU_NO
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index dddd3cd6..edd4923d 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -868,6 +868,14 @@ declare_ovr_snprint(detect_checker,
> print_yes_no_undef)
> =A0declare_hw_handler(detect_checker, set_yes_no_undef)
> =A0declare_hw_snprint(detect_checker, print_yes_no_undef)
> =A0
> +declare_def_handler(detect_pgpolicy, set_yes_no_undef)
> +declare_def_snprint_defint(detect_pgpolicy, print_yes_no_undef,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 DEFAULT_DETECT_PGPOLICY)
> +declare_ovr_handler(detect_pgpolicy, set_yes_no_undef)
> +declare_ovr_snprint(detect_pgpolicy, print_yes_no_undef)
> +declare_hw_handler(detect_pgpolicy, set_yes_no_undef)
> +declare_hw_snprint(detect_pgpolicy, print_yes_no_undef)
> +
> =A0declare_def_handler(force_sync, set_yes_no)
> =A0declare_def_snprint(force_sync, print_yes_no)
> =A0
> @@ -2112,6 +2120,7 @@ init_keywords(vector keywords)
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("retain_attached_hw_handler",
> &def_retain_hwhandler_handler, &snprint_def_retain_hwhandler);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_prio", &def_detect_prio_h=
andler,
> &snprint_def_detect_prio);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_checker",
> &def_detect_checker_handler, &snprint_def_detect_checker);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy",
> &def_detect_pgpolicy_handler, &snprint_def_detect_pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("force_sync", &def_force_sync_han=
dler,
> &snprint_def_force_sync);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("strict_timing", &def_strict_timi=
ng_handler,
> &snprint_def_strict_timing);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("deferred_remove",
> &def_deferred_remove_handler, &snprint_def_deferred_remove);
> @@ -2202,6 +2211,7 @@ init_keywords(vector keywords)
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("retain_attached_hw_handler",
> &hw_retain_hwhandler_handler, &snprint_hw_retain_hwhandler);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_prio", &hw_detect_prio_ha=
ndler,
> &snprint_hw_detect_prio);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_checker", &hw_detect_chec=
ker_handler,
> &snprint_hw_detect_checker);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy",
> &hw_detect_pgpolicy_handler, &snprint_hw_detect_pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("deferred_remove",
> &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_watch_checks",
> &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_wait_checks",
> &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
> @@ -2244,6 +2254,7 @@ init_keywords(vector keywords)
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("retain_attached_hw_handler",
> &ovr_retain_hwhandler_handler, &snprint_ovr_retain_hwhandler);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_prio", &ovr_detect_prio_h=
andler,
> &snprint_ovr_detect_prio);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_checker",
> &ovr_detect_checker_handler, &snprint_ovr_detect_checker);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy",
> &ovr_detect_pgpolicy_handler, &snprint_ovr_detect_pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("deferred_remove",
> &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_watch_checks",
> &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_wait_checks",
> &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 65bca744..803230c1 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -67,6 +67,7 @@
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.retain_hwhandler =3D RET=
AIN_HWHANDLER_ON,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_prio=A0=A0 =3D DE=
TECT_PRIO_ON,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_checker =3D DETEC=
T_CHECKER_ON,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_pgpolicy =3D DETECT=
_PGPOLICY_OFF,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.deferred_remove =3D DEFE=
RRED_REMOVE_OFF,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.delay_watch_checks =3D D=
ELAY_CHECKS_OFF,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.delay_wait_checks =3D DE=
LAY_CHECKS_OFF,
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index aba1a30e..8f72c452 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
> =A0=A0=A0=A0=A0=A0=A0=A0put_multipath_config;
> =A0};
> =A0
> -LIBMULTIPATH_18.0.0 {
> +LIBMULTIPATH_19.0.0 {
> =A0global:
> =A0=A0=A0=A0=A0=A0=A0=A0/* symbols referenced by multipath and multipathd=
 */
> =A0=A0=A0=A0=A0=A0=A0=A0add_foreign;
> @@ -116,6 +116,7 @@ global:
> =A0=A0=A0=A0=A0=A0=A0=A0get_refwwid;
> =A0=A0=A0=A0=A0=A0=A0=A0get_state;
> =A0=A0=A0=A0=A0=A0=A0=A0get_udev_device;
> +=A0=A0=A0=A0=A0=A0=A0get_uid;
> =A0=A0=A0=A0=A0=A0=A0=A0get_used_hwes;
> =A0=A0=A0=A0=A0=A0=A0=A0get_vpd_sgio;
> =A0=A0=A0=A0=A0=A0=A0=A0group_by_prio;
> @@ -141,6 +142,7 @@ global:
> =A0=A0=A0=A0=A0=A0=A0=A0pathcount;
> =A0=A0=A0=A0=A0=A0=A0=A0path_discovery;
> =A0=A0=A0=A0=A0=A0=A0=A0path_get_tpgs;
> +=A0=A0=A0=A0=A0=A0=A0pathinfo;
> =A0=A0=A0=A0=A0=A0=A0=A0path_offline;
> =A0=A0=A0=A0=A0=A0=A0=A0print_all_paths;
> =A0=A0=A0=A0=A0=A0=A0=A0print_foreign_topology;
> @@ -235,9 +237,3 @@ global:
> =A0local:
> =A0=A0=A0=A0=A0=A0=A0=A0*;
> =A0};
> -
> -LIBMULTIPATH_18.1.0 {
> -global:
> -=A0=A0=A0=A0=A0=A0=A0get_uid;
> -=A0=A0=A0=A0=A0=A0=A0pathinfo;
> -} LIBMULTIPATH_18.0.0;
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index d214281b..12f4825d 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -265,6 +265,21 @@ verify_alua_prio(struct multipath *mp)
> =A0=A0=A0=A0=A0=A0=A0=A0return true;
> =A0}
> =A0
> +int select_detect_pgpolicy(struct config *conf, struct multipath
> *mp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0const char *origin;
> +
> +=A0=A0=A0=A0=A0=A0=A0mp_set_ovr(detect_pgpolicy);
> +=A0=A0=A0=A0=A0=A0=A0mp_set_hwe(detect_pgpolicy);
> +=A0=A0=A0=A0=A0=A0=A0mp_set_conf(detect_pgpolicy);
> +=A0=A0=A0=A0=A0=A0=A0mp_set_default(detect_pgpolicy, DEFAULT_DETECT_PGPO=
LICY);
> +out:
> +=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: detect_pgpolicy =3D %s %s", mp->ali=
as,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(mp->detect_pgpolicy =3D=3D=
 DETECT_PGPOLICY_ON)? "yes" :
> "no",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 origin);
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +}
> +
> =A0int select_pgpolicy(struct config *conf, struct multipath * mp)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> @@ -275,13 +290,19 @@ int select_pgpolicy(struct config *conf, struct
> multipath * mp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D cmdline_origin=
;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if (mp->detect_pgpolicy =3D=3D DETECT_PGPOLICY_ON &=
&
> verify_alua_prio(mp)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D GROUP_BY_T=
PG;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D autodetect_origi=
n;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_mpe(pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_ovr(pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_hwe(pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_conf(pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
> =A0out:
> -=A0=A0=A0=A0=A0=A0=A0if (mp->pgpolicy =3D=3D GROUP_BY_TPG && !verify_alu=
a_prio(mp)) {
> +=A0=A0=A0=A0=A0=A0=A0if (mp->pgpolicy =3D=3D GROUP_BY_TPG && origin !=3D
> autodetect_origin &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !verify_alua_prio(mp)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D DEFAULT_=
PGPOLICY;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D "(setting: eme=
rgency fallback - not all
> paths use alua prio)";
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_prio =3D 1;
> diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> index 152ca44c..513ee6ac 100644
> --- a/libmultipath/propsel.h
> +++ b/libmultipath/propsel.h
> @@ -1,5 +1,6 @@
> =A0int select_rr_weight (struct config *conf, struct multipath * mp);
> =A0int select_pgfailback (struct config *conf, struct multipath * mp);
> +int select_detect_pgpolicy (struct config *conf, struct multipath *
> mp);
> =A0int select_pgpolicy (struct config *conf, struct multipath * mp);
> =A0int select_selector (struct config *conf, struct multipath * mp);
> =A0int select_alias (struct config *conf, struct multipath * mp);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 0eea19b4..682a7e17 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -143,6 +143,12 @@ enum detect_checker_states {
> =A0=A0=A0=A0=A0=A0=A0=A0DETECT_CHECKER_ON =3D YNU_YES,
> =A0};
> =A0
> +enum detect_pgpolicy_states {
> +=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_UNDEF =3D YNU_UNDEF,
> +=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_OFF =3D YNU_NO,
> +=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_ON =3D YNU_YES,
> +};
> +
> =A0enum deferred_remove_states {
> =A0=A0=A0=A0=A0=A0=A0=A0DEFERRED_REMOVE_UNDEF =3D YNU_UNDEF,
> =A0=A0=A0=A0=A0=A0=A0=A0DEFERRED_REMOVE_OFF =3D YNU_NO,
> @@ -389,6 +395,7 @@ enum prflag_value {
> =A0struct multipath {
> =A0=A0=A0=A0=A0=A0=A0=A0char wwid[WWID_SIZE];
> =A0=A0=A0=A0=A0=A0=A0=A0char alias_old[WWID_SIZE];
> +=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy;
> =A0=A0=A0=A0=A0=A0=A0=A0int pgpolicy;
> =A0=A0=A0=A0=A0=A0=A0=A0pgpolicyfn *pgpolicyfn;
> =A0=A0=A0=A0=A0=A0=A0=A0int nextpg;
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index b65a543d..9f8be510 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -242,6 +242,18 @@ The default is: \fBfailover\fR
> =A0.
> =A0.
> =A0.TP
> +.B detect_pgpolicy
> +If set to \fIyes\fR and all path devcices are configured with either
> the
> +\fIalua\fR or \fIsysfs\fR prioritizer, the multipath device will
> automatically
> +use the \fIgroup_by_tpg\fR path_grouping_policy. If set to \fIno\fR,
> the
> +path_grouping_policy will be selected as usual.
> +.RS
> +.TP
> +The default is: \fIno\fR
> +.RE
> +.
> +.
> +.TP
> =A0.B pg_timeout
> =A0(Deprecated) This option is not supported any more, and the value is
> ignored.
> =A0.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

