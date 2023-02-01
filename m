Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EF5AC38142
	for <dm-devel@archiver.kernel.org>; Wed,  1 Feb 2023 08:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675238402;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=fsqBPWER5M7GcX2vXo5fxcyxJ6hf072Mq2TH/a3eow8=;
	b=SKbGOY97PyYMAmR6lzYu9b3WKR14uMTAThO19EVZyH6Ymyj+5tMfpltFnsgx/yu+j6Jk4S
	pI3gIAb5XRlm1onrQDAwyrJzzti9o4LFjOJkYuxTK6pt6HdYJiKZBZmPY+6IsqvBCjdVU8
	oxPKQwgIDJhF4Crb6h7WifkUac+YMhc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-II4tMQ-JMMixRaMaKQtZiQ-1; Wed, 01 Feb 2023 02:59:58 -0500
X-MC-Unique: II4tMQ-JMMixRaMaKQtZiQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C96F885D18D;
	Wed,  1 Feb 2023 07:59:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 83CDA40C2004;
	Wed,  1 Feb 2023 07:59:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A4ECF19465BB;
	Wed,  1 Feb 2023 07:59:54 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D06EB1946595
 for <dm-devel@listman.corp.redhat.com>; Wed,  1 Feb 2023 07:59:53 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 93A87400EAD6; Wed,  1 Feb 2023 07:59:53 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B3A140C141B
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 07:59:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 68A331C05AA7
 for <dm-devel@redhat.com>; Wed,  1 Feb 2023 07:59:53 +0000 (UTC)
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01on2088.outbound.protection.outlook.com [40.107.13.88]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-221-5f-E9qwnNRC1pXk5lsMMCQ-1; Wed, 01 Feb 2023 02:59:51 -0500
X-MC-Unique: 5f-E9qwnNRC1pXk5lsMMCQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AM8PR04MB7202.eurprd04.prod.outlook.com (2603:10a6:20b:1da::12)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Wed, 1 Feb
 2023 07:59:49 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e1b6:3ede:547d:eb2f%9]) with mapi id 15.20.6043.028; Wed, 1 Feb 2023
 07:59:48 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/4] libmultipath: select resize action even if reload is
 forced
Thread-Index: AQHZNasLkZOpAEzHl0OoyCzJPqRRL665uveA
Date: Wed, 1 Feb 2023 07:59:48 +0000
Message-ID: <3eadec4ad6ac5600dd8e8f6d2d5b4b57d13c58e3.camel@suse.com>
References: <1675193661-1147-1-git-send-email-bmarzins@redhat.com>
 <1675193661-1147-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1675193661-1147-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.3
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AM8PR04MB7202:EE_
x-ms-office365-filtering-correlation-id: d5f61e1a-d02d-4c95-a2eb-08db042a4a93
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GRNRUwSlwH5S21s8HPNK+Fw8Ju6RWifczOqyMb6jPr9TS1Y0mFubHOVN7gMAroiwrGGtLt7T7lel9vPI4I4obs0oc/AQmTeOXEbzon74tNYxNKdvJyncdE6Ua2ehLfmuChlsYtrkOXqoZaYJNAV7O7cpROXiniuJkM1n2RonLOCaAX2fzGYkRC4Yv0ISrRzand3fJNjggnK6VtMEDMpJWJ2Vf1VkY+Z07fwR5aFsAk0X3vabKj4vkdFhcFIgOBfvKKkI7LO0N6O7xr/HBYdDue3kOS7LCSAkI+ikpGKe7i0w9CILiqogvOz9bvnux7O3J7U9gGs/cOb42LMyPb6YKPnfw1KVh6kFuEMdq1qjld960Gg7xf/2We9lJStL5KaR3QYs9w0fBFhZ6Hj9iKLek7T0MHVRHI6/mVYyPpf8/X9SpHtV8xiwJZZDgmB+yhZtmkrfxIT7fFr7YXXXQ4mypwhEgOdtT8ktYBV+j28rUDA+KeETlkbmG+XP8h79bYrV45P17c7L6zmLmX+gwtjeYsJWr7CzN3Ly1c5qEpUbdVUr8UqEmb3rJ60mxRUlVSbBq7igQRiCQeysJz/CbpB895g0dWLCVTAxFxnvrz5TMJfs2E+hYVYf8C4kuA4v+GsDFlAD/IokV7V5GsaR44XKQxaEa/8nRXRTndCv93LWqitmHO8t1ME5cKlcrFoTBFOWJMMBjVsoB+3WpKnMtC0L1Q==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230025)(346002)(136003)(376002)(396003)(366004)(39860400002)(451199018)(38070700005)(36756003)(86362001)(122000001)(110136005)(66946007)(66476007)(38100700002)(66446008)(66556008)(64756008)(8936002)(76116006)(41300700001)(316002)(8676002)(91956017)(4326008)(44832011)(2906002)(5660300002)(2616005)(83380400001)(478600001)(186003)(6486002)(6512007)(26005)(6506007)(71200400001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?O/xRj4xLOGJSqQw4b+1m3HdCdZ4tC0jyTHPYR9+gNBiXtCkopiU6xnM1I?=
 =?iso-8859-15?Q?jHEVVJmWdCx5PLh42hYbS6MSFpvwzCB1gSAvlOUCj++Ng46VQ7QdSI71S?=
 =?iso-8859-15?Q?xUFuqlC4Kg38jqNtepd06aGYn6SBPMMr5on4cj5a233I/Lgm9LaTBNI5Z?=
 =?iso-8859-15?Q?993IuYSuvKeo+gmxLjT10Hp9xgzqTupteyZUZP+UJXDLP5x7zBhz0VTas?=
 =?iso-8859-15?Q?VUTwETqAymZuAe8kXN7jcTVyBWG8BmI6s1MBmbWU5o9kkaIAvyCdsD9z3?=
 =?iso-8859-15?Q?R2iNBR5cP4mBLA6hMaXJmz5jvNUrsrizYm/599TCFaJSR6fqiGBF9JGDi?=
 =?iso-8859-15?Q?J/6lxlW51C7KjUhsmY1MJH7+IAGLpeyDL6pcjyaUqmk3SaTbxoz8DAXAp?=
 =?iso-8859-15?Q?YQHu/XsXxZysxDGa7uhQbrtlR7mDGSd253kJUN2gfGDE/pZB4w8GEqf5K?=
 =?iso-8859-15?Q?ZW+1xHnwk7hCgntiYzY53QnNBGP1GsdVIU3YMtKiPhqHYIhqmQVRXGnL9?=
 =?iso-8859-15?Q?FSTJCZGgcRPpi3CHIQH/l66RQYJcvbfRtq39JBLnZFH4Ipd+vJyIq79WS?=
 =?iso-8859-15?Q?iG3UU2mnhls0ca9y7uTx82sTYnj2Mw4W+/eXlzhiRhLMd11m1qyFFFM7c?=
 =?iso-8859-15?Q?uvCNMDqIBh4j5CT+XIh4aCf9qY4Mogr6Y8pSNIaznJhWbOTqrnsxKLN3R?=
 =?iso-8859-15?Q?7vM/vUZx4IkRvWGOIGGXyFyHcpllETk1DsVaZEIf8ogr1Npl2f2AlBTOB?=
 =?iso-8859-15?Q?h8b12mViXMjbzHYZ6T8bH/GNvPlq5Tg3r/11wh4cH5RYDK82q159BORl+?=
 =?iso-8859-15?Q?0eQT1KWrC3NICpHTX3LAb2cuM/j+G8hCxKKNleompFTC2MUpQ3vtQBjbM?=
 =?iso-8859-15?Q?H4ei5ppFGWlnuV602s1jwOFe8ykRE+q08STWVAJOvLwroj1+dv12e0hrj?=
 =?iso-8859-15?Q?JewRRgAtqPfY3LIu8E2eD+Fq2g/bsXdpG/KvOVrposDcUCRhzBJ8rsLuX?=
 =?iso-8859-15?Q?xK4bvUy77XMH88RM+jiFnTODNMDbkrsar0rfVUS0EUEOoqHpQ67nn4rAN?=
 =?iso-8859-15?Q?2b3IDqC7M5PT0lu326Ci1Rdmg522abis3OaK7CteuRgAhGf3O8sngbrcK?=
 =?iso-8859-15?Q?44viqVgI3/NgJnJf2PJ7vc8TVZO1cc/aROxbvwGPXPWCRKoL6WVcx/5ub?=
 =?iso-8859-15?Q?6s1rb8a1/8k0SEmnVQO3hqnFxneThfAvWNfH1IP8w+xNG7HKLPVQvuwRM?=
 =?iso-8859-15?Q?En6hZKAmdRikPy1vb3oCblQWMED3gXthCh0VyEI3My05b2cRikWWi1Vb7?=
 =?iso-8859-15?Q?mQHATdl1kL6m5ppImSRhidCbtmu/Kwo35gQwVsLywV/1kOloM/XYqo56Y?=
 =?iso-8859-15?Q?Cq025p15WNLp2uMLf4SYn8WIXmDL+Xl8pHArnugTG7s1vyLzGrcI6q/e2?=
 =?iso-8859-15?Q?05l29uFw6zwTr05BTpEQw9OwqMhb8SDIXlrZoC4NPOw1XoUW0mjTlvVll?=
 =?iso-8859-15?Q?c2efiQxQfinTRTsnZYGZYighcV6wK4mNiPKIkEEIlp2OS1fouCWAAVenI?=
 =?iso-8859-15?Q?0SHKFVhaBH9Qf/wiY9TGkQgHhQGIPhdj36DSn1Z4afXUh+e5EKHbm9zND?=
 =?iso-8859-15?Q?ax9WVC6bvO6C9EPGRTxswuPMfOrGi/3nv/bjC/AZTebqgQ/c6zHclmWdo?=
 =?iso-8859-15?Q?xmAMq/lJgZbn3gY6+KyyakKq2A=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f61e1a-d02d-4c95-a2eb-08db042a4a93
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 07:59:48.9071 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i8CDLaOaWQ/fXC6V8WfYhcNkjI5d7RF2KTh6VAw6dJ7Q5KpPq9br77KyTWMUfM8a/emNMRWLE73wuCN4Fwr3QQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7202
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH 2/4] libmultipath: select resize action even
 if reload is forced
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
Content-ID: <DCC0218A6646C94083F140E8E81809D9@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-01-31 at 13:34 -0600, Benjamin Marzinski wrote:
> The ACT_RESIZE action is the same as the ACT_RELOAD action, except
> that
> it flushes outstanding IO because the device size is changing and
> the new size might be too small for some of the outstanding IO. If
> we've
> detected a size change, and a forced reload is requested, we still
> need
> to flush the IO because the reload will change the device size.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/configure.c | 11 ++++++-----
> =A01 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 050b984a..6811e661 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -727,11 +727,6 @@ void select_action (struct multipath *mpp, const
> struct _vector *curmp,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (force_reload) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->force_udev_reload =3D =
1;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0select_reload_action(mpp, "=
forced by user");
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> -=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0if (cmpp->size !=3D mpp->size) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->force_udev_reload =
=3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->action =3D ACT_RESIZ=
E;
> @@ -740,6 +735,12 @@ void select_action (struct multipath *mpp, const
> struct _vector *curmp,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (force_reload) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->force_udev_reload =3D =
1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0select_reload_action(mpp, "=
forced by user");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> =A0=A0=A0=A0=A0=A0=A0=A0if (!is_udev_ready(cmpp) && count_active_paths(mp=
p) > 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->force_udev_reload =
=3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0select_reload_action(mpp,=
 "udev incomplete");

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

