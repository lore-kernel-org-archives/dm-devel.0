Return-Path: <SRS0=k/UL=QC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AD3C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:27:02 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7CF6D63215
	for <dm-devel@archiver.kernel.org>; Mon, 15 Nov 2021 16:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7CF6D63215
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-dyRm4tIENDS515S7AzcgDQ-1; Mon, 15 Nov 2021 11:26:57 -0500
X-MC-Unique: dyRm4tIENDS515S7AzcgDQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E394C875118;
	Mon, 15 Nov 2021 16:26:36 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 904135DEFB;
	Mon, 15 Nov 2021 16:26:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E90834E58E;
	Mon, 15 Nov 2021 16:26:35 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
	[10.11.54.1])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AFGO2fR028397 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 15 Nov 2021 11:24:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 6DB7540CFD07; Mon, 15 Nov 2021 16:24:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 670054010FE9
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 16:24:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47A55802A5E
	for <dm-devel@redhat.com>; Mon, 15 Nov 2021 16:24:02 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-345-1xZQ7h3ROgaYVP0UGY2sxg-1;
	Mon, 15 Nov 2021 11:24:00 -0500
X-MC-Unique: 1xZQ7h3ROgaYVP0UGY2sxg-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2054.outbound.protection.outlook.com [104.47.1.54])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-19-u7IppPiGNui9DDI-AGJf8A-1; Mon, 15 Nov 2021 17:23:58 +0100
X-MC-Unique: u7IppPiGNui9DDI-AGJf8A-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4747.eurprd04.prod.outlook.com (2603:10a6:10:18::12) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26;
	Mon, 15 Nov 2021 16:23:56 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4690.027;
	Mon, 15 Nov 2021 16:23:54 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/4] multipathd: pass in the type of reconfigure
Thread-Index: AQHXrnZDMDtkEBo0wEugXKg1rf0uoKwFHXAA
Date: Mon, 15 Nov 2021 16:23:54 +0000
Message-ID: <0b1c32c80fb5263df6263570f26b60247576f1b5.camel@suse.com>
References: <1632180076-9294-1-git-send-email-bmarzins@redhat.com>
	<1632180076-9294-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1632180076-9294-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 52bf791a-4360-4a56-ea44-08d9a854517f
x-ms-traffictypediagnostic: DB7PR04MB4747:
x-microsoft-antispam-prvs: <DB7PR04MB47470D80B07ACCACEEC61521FC989@DB7PR04MB4747.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: KPdHrReGl49+BxbYylyocyCNEk6UDy+UNQNCr2q2hHw36qVl5Y2sqGea0j6Mks0stTGZIFIwi5yoI7jcohZ36B9K9lanC76X4GkW598sHsLQmHO6UROU7REjaQlw7gI8Ksl/G2Mx+dyXlJxBuDPfbMUYn3prdKAS6HQ4KOYPIJYGW5nQOnVm7MufvT9ThkKEe7XaWgxKsZvoTwJCgV4w30GnwY27bRHYrA7db5BZBqvKEjZ4N1b4ovYvc4Bt8+ZtUSLiKQDAEVEtqtnaBaWIYqLJ0dLQbS83SZePLJcEyRc6g6xVDZUXLsVWal25ACN4zjGA0VdnQGMiduO5SsLnPxzAGBe+2opXZF+k1lsmubAVvu0eSpDlFi6q9hehZADhyYOSd2x+6xCu43qdCVozLMWqGpS9nUwI6JrJYrpIlXFGEoafWtUamcrXCvOpjEGYwJ4hmTE9JkGnQvl5cysbOgHlb5kxwOeYCMrDLvZIoW8VwK4HmBB4TOd7kUqajIC8d54Ktc8g0sUeJGVWalT2vbwoaOShEqz9t04vb1+jfCtAbjAXnsVjV/I6rT/QHLyQBU2DbMPmpdnCUbZI3pzFhiXIj3EB/xP+plxF6kWCF/GPuIHTq2dp1h9MYrmV1U9v5bHJAFfYmy85v0gGGNZsZut1l8KsAoC55c+kS0XYBVcPwz7ceG8NylM1QVLOQw1M7PGwbK20R0eyNacPny05dA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(186003)(71200400001)(66476007)(4326008)(316002)(83380400001)(44832011)(110136005)(64756008)(66556008)(508600001)(66446008)(66946007)(8936002)(2616005)(5660300002)(26005)(36756003)(38070700005)(2906002)(8676002)(122000001)(6506007)(6512007)(38100700002)(91956017)(86362001)(76116006)(6486002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?ElcT32Af/KNxfVDy4jWimcp/NCkdbI7ezBZaup14PpTXE2a7EJdAG6NdH?=
	=?iso-8859-15?Q?BOUNzWoUcdAihTzFXqnaEl/BgT39ZiwZB8CaLS0FzObLoe4D3Xpa7ayp8?=
	=?iso-8859-15?Q?q9I8wFmNoUBycS8FqBAbsa8f6Ta/GkGNjqKSZ34M61T8G2gHWQU2J9jCm?=
	=?iso-8859-15?Q?/4DNMLDzMtOEQKZRzKrOXlkDUM45d6CcHBuhHOCto8KsnEgkPtdXSdtRF?=
	=?iso-8859-15?Q?YDTbL7+089bBsAvhXXTBycK43nliTaovsidtQEwuGVOlIVEenjk7bSJ4W?=
	=?iso-8859-15?Q?+5U68E0QJPHwu+SzSvT+0zTe28ZN1TChDuMVlsWDyRGEGwalm7ZRIzZXp?=
	=?iso-8859-15?Q?Dky5wFvrKlZUV29nkCvBRDFkDd2t60onzmFX6O1UxQ/sL7ge3lmJ8zaGm?=
	=?iso-8859-15?Q?ON8AoZIeKQ9lhGnf3d3OPAShuaPhate+3e3VN3Ro9K0HiQKALF9awTncg?=
	=?iso-8859-15?Q?ur/zfavCavhxd6/LcNqSkhOur5e2NWYZ6IrVIzAv0RQSPjFSr4AWSaAQi?=
	=?iso-8859-15?Q?rA4RuovWMnQr7VfIIHqBHvS7jFQDCrQIoGNIvXrOx8jKWB/t/kauK4lHg?=
	=?iso-8859-15?Q?A3BalcGkKVJsJ8cL2p6TRNK9hjgjKsSE3JWM1ivkHMMvs0yb5ZIO8Agii?=
	=?iso-8859-15?Q?VW5qmCVZeejJXHCz9AzGcp5AUtDx2/XNizmxbO5wdQEfWo1NZTOFauR6i?=
	=?iso-8859-15?Q?D3X8Q3pIlOlMjd+Gc0HM4lClx268BpJnumnAKW/+uyNhlZFRQmcZj5Gpu?=
	=?iso-8859-15?Q?1enN46mJlSzVVNrLvrSvZe5NOhJCXUCuwE7oqM/1U6LsTrv2SFCY5Sb8Y?=
	=?iso-8859-15?Q?tYpAXR5l0yB4D2dguqqJoeNYv0NvozphvQIbEFtvY9w4YqDBZzoIYqvvb?=
	=?iso-8859-15?Q?AD1aAXVyRB/cNmYGbX/mOpk69s8htoFz0dNkW4MOA13bFv5IogrRD3oyb?=
	=?iso-8859-15?Q?VIjCRm66oF58ikU6uZC+/Z2RUnQLCN+d4y02cv/6PXFfi5P62hfVhAKit?=
	=?iso-8859-15?Q?CjI6Mx0KlIcCQG5cLJL2sp6aXazWQ7S5F9oOuG8wzHfVhbN+4QeFvRbC/?=
	=?iso-8859-15?Q?Fz+6t0GPmdgzGEPypxoKaObcdJTawksiDdEgjfjwy846+m/MVVTNAiF6L?=
	=?iso-8859-15?Q?jZhmqoSZw3Y4W7AhMdYWCTD1jGErify5RzpgXQkZIJbnNsdFfxVbt/vw/?=
	=?iso-8859-15?Q?kaptY3el8O6ae3ab7HsLcPGuAdZs+SzCfknQ9RLyekgsPs3ogsPgdEInV?=
	=?iso-8859-15?Q?38pdD+SeWCIHwoP/dw2qoUeXz2SBJ5XJtobrzEToDc2P2jdgSbRvTjRAF?=
	=?iso-8859-15?Q?1PLnkvzBwGtOWYjJ0ousQ866evFpLRqzJkpsWOs339nfu9lpSZ5Ptul0k?=
	=?iso-8859-15?Q?zU/eE5Tzyx3MsITnCxEYHHTbEL6oJT7CiWyTnLnBXKLJgrrBrfLK8rKLE?=
	=?iso-8859-15?Q?ZqsaDb6VTJeGOUxVSv8xsw5oRQ41i/rf4q2GJnJ66GTBhcwSVooXyQY7X?=
	=?iso-8859-15?Q?Z3cT46mW/HKxyPRspyRkmBv3zTi5FLblwquOZVEzqMOh2bsDtyaR0V3bC?=
	=?iso-8859-15?Q?ehYW6Kldzpg3wZTjDMegVuWFyFQ1LjDvJOA/QjYMKxAcDCZSoXnxbq57R?=
	=?iso-8859-15?Q?NIR8F0D0wdIouy1kP4j3khREuGgEV9s16eCrHO2xLXXwDV5h0Gxy+xeqC?=
	=?iso-8859-15?Q?IIfG/alK4zr3cHEWPBjQSEqXZxVzeJCWMcTiexRo/iYjQOg=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52bf791a-4360-4a56-ea44-08d9a854517f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 16:23:54.6793 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bxx+n/yEm/+WXlsGi7Vf9ocIWvOysZGvDhZZVUkWtZOSxxVPjEb0jlKYe/uN1fHDWX5YYjh5qWWs3SvxdDOhbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4747
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AFGO2fR028397
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/4] multipathd: pass in the type of
	reconfigure
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <9ABD6AEDA89CBC4AA2F609C2D1DAC094@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2021-09-20 at 18:21 -0500, Benjamin Marzinski wrote:
> This code doesn't actually change how multipathd reconfigures. It still
> does a weak reconfigure at the start, and full reconfigures later.

AFAICS it does change this, at least for the cases where reconfigure()
is called from ev_add_map() and missing_uev_wait_tick, where you call
schedule_reconfigure(false). The old code was using a static variable
and thus always doing a hard reconfigure when called more than once.

I'm find with this change (the old behavior was arguably wrong), but
the commit message should be clarified in this respect.

> But
> now schedule_reconfigure() takes the type of reconfigure to do, and
> that
> gets passed down to reconfigure(). If a full reconfigure has already
> been requested but not started, weak reconfigure requests will be
> upgraded. A future patch will enable users to control what kind of
> reconfigures happen.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/configure.c=A0 |=A0 2 +-
> =A0multipathd/cli_handlers.c |=A0 2 +-
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0 | 62 ++++++++++++++++++++---=
----------------
> =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 +-
> =A04 files changed, 35 insertions(+), 33 deletions(-)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 7edb355b..eb8ec1bd 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -1098,7 +1098,7 @@ out:
> =A0 * FORCE_RELOAD_NONE: existing maps aren't touched at all
> =A0 * FORCE_RELOAD_YES: all maps are rebuilt from scratch and (re)loaded
> in DM
> =A0 * FORCE_RELOAD_WEAK: existing maps are compared to the current conf
> and only
> - * reloaded in DM if there's a difference. This is useful during
> startup.
> + * reloaded in DM if there's a difference. This is normally
> sufficient.
> =A0 */
> =A0int coalesce_paths (struct vectors *vecs, vector mpvec, char *refwwid,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int force_reloa=
d, enum mpath_cmds cmd)
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index f59db3ab..b12a4e7e 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -1012,7 +1012,7 @@ cli_reconfigure(void * v, struct strbuf *reply,
> void * data)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reconfigure (operator)");
> =A0
> -=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure();
> +=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure(true);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 1ead0904..5c831e8d 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -162,13 +162,6 @@ static bool get_delayed_reconfig(void)
> =A0=A0=A0=A0=A0=A0=A0=A0return val;
> =A0}
> =A0
> -static void set_delayed_reconfig(bool val)
> -{
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&config_lock);
> -=A0=A0=A0=A0=A0=A0=A0__delayed_reconfig =3D val;
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&config_lock);
> -}
> -
> =A0/*
> =A0 * global copy of vecs for use in sig handlers
> =A0 */
> @@ -290,7 +283,18 @@ enum daemon_status wait_for_state_change_if(enum
> daemon_status oldstate,
> =A0}
> =A0
> =A0/* Don't access this variable without holding config_lock */
> -static bool reconfigure_pending;
> +static enum force_reload_types reconfigure_pending =3D
> FORCE_RELOAD_NONE;
> +/* Only set while changing to DAEMON_CONFIGURE, and only access while
> + * reconfiguring in DAEMON_CONFIGURE */
> +static volatile enum force_reload_types reload_type =3D
> FORCE_RELOAD_NONE;
> +
> +static void enable_delayed_reconfig(enum force_reload_types type)
> +{
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&config_lock);
> +=A0=A0=A0=A0=A0=A0=A0reconfigure_pending =3D type;
> +=A0=A0=A0=A0=A0=A0=A0__delayed_reconfig =3D true;
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&config_lock);
> +}
> =A0
> =A0/* must be called with config_lock held */
> =A0static void __post_config_state(enum daemon_status state)
> @@ -305,7 +309,8 @@ static void __post_config_state(enum daemon_status
> state)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * In either case, child(=
) will see DAEMON_CONFIGURE
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * again and start anothe=
r reconfigure cycle.
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (reconfigure_pending && =
state =3D=3D DAEMON_IDLE &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (reconfigure_pending !=
=3D FORCE_RELOAD_NONE &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 state =3D=3D DAEM=
ON_IDLE &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (old_state =3D=
=3D DAEMON_CONFIGURE ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 old_state =
=3D=3D DAEMON_RUNNING)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
*
> @@ -317,7 +322,8 @@ static void __post_config_state(enum daemon_status
> state)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
tate =3D DAEMON_CONFIGURE;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (state =3D=3D DAEMON_C=
ONFIGURE) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rec=
onfigure_pending =3D false;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rel=
oad_type =3D (reconfigure_pending =3D=3D
> FORCE_RELOAD_YES) ? FORCE_RELOAD_YES : FORCE_RELOAD_WEAK;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rec=
onfigure_pending =3D FORCE_RELOAD_NONE;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0_=
_delayed_reconfig =3D false;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0running_state =3D state;
> @@ -334,20 +340,25 @@ void post_config_state(enum daemon_status state)
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> =A0}
> =A0
> -void schedule_reconfigure(void)
> +void schedule_reconfigure(bool force_reload_yes)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&config_lock);
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(config_cleanup, NULL);
> +=A0=A0=A0=A0=A0=A0=A0enum force_reload_types type;
> +
> +=A0=A0=A0=A0=A0=A0=A0type =3D (reconfigure_pending =3D=3D FORCE_RELOAD_Y=
ES ||
> force_reload_yes) ?
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 FORCE_RELOAD_YES : FORCE_RELOAD_=
WEAK;
> =A0=A0=A0=A0=A0=A0=A0=A0switch (running_state)
> =A0=A0=A0=A0=A0=A0=A0=A0{
> =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_SHUTDOWN:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_IDLE:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reconfigure_pending =3D typ=
e;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0__post_config_state(DAEMO=
N_CONFIGURE);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_CONFIGURE:
> =A0=A0=A0=A0=A0=A0=A0=A0case DAEMON_RUNNING:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reconfigure_pending =3D tru=
e;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reconfigure_pending =3D typ=
e;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0default:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> @@ -812,7 +823,7 @@ ev_add_map (char * dev, const char * alias, struct
> vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (get_delayed_reconfig() &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 !need_to_delay_reconfig(vecs)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reconfigure (delayed)");
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure();
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure(false);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> @@ -1830,7 +1841,7 @@ missing_uev_wait_tick(struct vectors *vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0if (timed_out && get_delayed_reconfig() &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !need_to_delay_reconfig(vecs)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reconfigure (=
delayed)");
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure();
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure(false)=
;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0}
> =A0
> @@ -2588,14 +2599,13 @@ checkerloop (void *ap)
> =A0}
> =A0
> =A0int
> -configure (struct vectors * vecs)
> +configure (struct vectors * vecs, enum force_reload_types type)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> =A0=A0=A0=A0=A0=A0=A0=A0vector mpvec;
> =A0=A0=A0=A0=A0=A0=A0=A0int i, ret;
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> -=A0=A0=A0=A0=A0=A0=A0static int force_reload =3D FORCE_RELOAD_WEAK;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (!vecs->pathvec && !(vecs->pathvec =3D vector_=
alloc())) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "couldn't allo=
cate path vec in configure");
> @@ -2643,15 +2653,7 @@ configure (struct vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0if (should_exit())
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto fail;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0/*
> -=A0=A0=A0=A0=A0=A0=A0 * create new set of maps & push changed ones into =
dm
> -=A0=A0=A0=A0=A0=A0=A0 * In the first call, use FORCE_RELOAD_WEAK to avoi=
d making
> -=A0=A0=A0=A0=A0=A0=A0 * superfluous ACT_RELOAD ioctls. Later calls are d=
one
> -=A0=A0=A0=A0=A0=A0=A0 * with FORCE_RELOAD_YES.
> -=A0=A0=A0=A0=A0=A0=A0 */
> -=A0=A0=A0=A0=A0=A0=A0ret =3D coalesce_paths(vecs, mpvec, NULL, force_rel=
oad,
> CMD_NONE);
> -=A0=A0=A0=A0=A0=A0=A0if (force_reload =3D=3D FORCE_RELOAD_WEAK)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0force_reload =3D FORCE_RELO=
AD_YES;
> +=A0=A0=A0=A0=A0=A0=A0ret =3D coalesce_paths(vecs, mpvec, NULL, type, CMD=
_NONE);


Can we please rename this variable from "type" to "reload_type" here,
for the sake of readability? Likewise, in reconfigure()?

> =A0=A0=A0=A0=A0=A0=A0=A0if (ret !=3D CP_OK) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "configure fai=
led while coalescing paths");
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto fail;
> @@ -2729,7 +2731,7 @@ void rcu_free_config(struct rcu_head *head)
> =A0}
> =A0
> =A0int
> -reconfigure (struct vectors * vecs)
> +reconfigure (struct vectors * vecs, enum force_reload_types type)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct config * old, *conf;
> =A0
> @@ -2763,7 +2765,7 @@ reconfigure (struct vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0rcu_assign_pointer(multipath_conf, conf);
> =A0=A0=A0=A0=A0=A0=A0=A0call_rcu(&old->rcu, rcu_free_config);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0configure(vecs);
> +=A0=A0=A0=A0=A0=A0=A0configure(vecs, type);
> =A0
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> @@ -2815,7 +2817,7 @@ handle_signals(bool nonfatal)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0if (reconfig_sig) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reconfigure (=
signal)");
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure();
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0schedule_reconfigure(true);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0if (log_reset_sig) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "reset log (si=
gnal)");
> @@ -3274,9 +3276,9 @@ child (__attribute__((unused)) void *param)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0l=
ock(&vecs->lock);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
thread_testcancel();
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (!need_to_delay_reconfig(vecs))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0reconfigure(vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0reconfigure(vecs, reload_type);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0set_delayed_reconfig(true);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0enable_delayed_reconfig(reload_type);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0l=
ock_cleanup_pop(vecs->lock);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
ost_config_state(DAEMON_IDLE);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> diff --git a/multipathd/main.h b/multipathd/main.h
> index a1697a74..c8a1ce92 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -37,7 +37,7 @@ void exit_daemon(void);
> =A0const char * daemon_status(void);
> =A0enum daemon_status wait_for_state_change_if(enum daemon_status
> oldstate,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 unsigned long ms)=
;
> -void schedule_reconfigure(void);
> +void schedule_reconfigure(bool reconfig_all);

For consistency, please consider using an "enum force_reload_types" as
argument to schedule_reconfigure() rather than a boolean.

Otherwise, the patch looks good.

Cheers
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

