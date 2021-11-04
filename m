Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF115C433EF
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 22:13:11 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 7D1B461207
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 22:13:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 7D1B461207
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-DIniidaLMu6A8RI8R1QBOA-1; Thu, 04 Nov 2021 18:13:05 -0400
X-MC-Unique: DIniidaLMu6A8RI8R1QBOA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74FF2101F7A8;
	Thu,  4 Nov 2021 22:12:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B00E76608;
	Thu,  4 Nov 2021 22:12:59 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id F017B1806D03;
	Thu,  4 Nov 2021 22:12:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4MCkU0032199 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 18:12:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 05EA0400F3EC; Thu,  4 Nov 2021 22:12:46 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 012CA400F3C6
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:12:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D62598007B1
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:12:45 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-557-JnKeXbn7OwayQPmaF1Dwgg-1;
	Thu, 04 Nov 2021 18:12:44 -0400
X-MC-Unique: JnKeXbn7OwayQPmaF1Dwgg-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-40-fbef-R7kP-OhcZRGGTZMQg-1; Thu, 04 Nov 2021 23:12:42 +0100
X-MC-Unique: fbef-R7kP-OhcZRGGTZMQg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4476.eurprd04.prod.outlook.com (2603:10a6:5:36::25) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15;
	Thu, 4 Nov 2021 22:12:41 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 22:12:41 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 1/7] multipathd: remove missing paths on startup
Thread-Index: AQHXxebbcpnEudogYk2u53XTfPmbfav0BlwA
Date: Thu, 4 Nov 2021 22:12:40 +0000
Message-ID: <b74a1ce64ba7dbd40b976905389ce14262406393.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1634757322-6015-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4211e36c-7f89-46fa-b382-08d99fe03803
x-ms-traffictypediagnostic: DB7PR04MB4476:
x-microsoft-antispam-prvs: <DB7PR04MB4476EFACD748D1E41CCE5ACAFC8D9@DB7PR04MB4476.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: qlODzdYpvPEvC5sX9P3o1s9YbZG+CWaJAjt2c80pUd+LhkkLIm0uJuEvRy4SoKOci64/N9pnaeekFYEim7XP/klFLP7DXzMtMl5KkNvlPz3hrwz73F1Z0mY1kdBfLtErdritluMddWFzlzyzBkSHZfeqhDHPYP74+JKl3QVQRX+wiOGX2H/j4qinjvm8cCwg0RLfVLXsztwPD2HxqPCzPX+JTg537OwOB+TKeJofJAEv2J1uLZSrBYwdYq5ZOsmO+1kM+qepVt3qUnqM+Y2WUeLDdd1ArQwzli2+M2XXVQ+fFV3uaIr4zkR0wpFSqYb5yb6YMQbKJ7Qr+rJaYTpKzQHGhsAzE6F/YtDE3zD4z2stQ1gNeEzo+hzxYcHLyMqG1dekCkLu3Ejvv75JeBI/16ANfE0tWMQ4Q7pA+PF6IgzZk4J+v+e/b8HnQOpRfgaJKRCQ0a19IYvfEqkzX7xcphQ52bAIejeU5Ke5xnFh6D+l9akRiI4I98DCR5D1awAhdy4BUh1Id0mp5Adi1LjF7pcugpzOv87d4YX4zkirf+QxaxpGawoOx7Jc3D9OdbJVLUb+dgyaSK8ouG6qjZNFKdqgLvH/tTYwA+A3LT4F8VqilL2sF/tugiLXrzAdh/BkKTW8rycprC7MGinQdMIqkbXpHqL6yCjiiOc546HjMbgBzui2Yf46cLOps9h7xgJ0W4uKTGh3dmlzY5jKlu5obA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(71200400001)(186003)(36756003)(86362001)(26005)(8676002)(508600001)(2616005)(6486002)(6506007)(76116006)(66946007)(91956017)(38070700005)(4326008)(316002)(44832011)(122000001)(4001150100001)(66446008)(2906002)(66556008)(5660300002)(38100700002)(8936002)(66476007)(64756008)(110136005)(6512007)(83380400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?y7vYIMe9QxLgwQYFIHovNSVbrhuO+NJo1jCpqXRy8Mksx3Eaa7/IggBG5?=
	=?iso-8859-15?Q?iNxLG4BWhjabtVBWQG9CnjPX3EowxpUL0BNVdcA3dl++RZROb4ViBeG2j?=
	=?iso-8859-15?Q?WCcmJW27Mg5++/6zptLsw6miJSQt8I4aEFQoVJoBC2HN8hd+v+Zo7pg2a?=
	=?iso-8859-15?Q?Z4X+ii5Z4CHxWFiSfR0j8aJH0fzdFBVIAxKomB7flGtJAZTlVJ1ja7WA/?=
	=?iso-8859-15?Q?bywtiClKxhbvqgNBm7pp4JfkCDMWuU5lXmHDjawo18tmU4DSDhhUyF51Y?=
	=?iso-8859-15?Q?6HTc/yDQgTGjRRjFjOlU/dAk29npPCF9bJZ/B7MEbTEuV+Ccbn3PhEeJb?=
	=?iso-8859-15?Q?LUKQ87Eow6DUjL+SYpa4TxDmaR8ZbxEeuIwv3UTjQ8mitlpicZhpQjiL2?=
	=?iso-8859-15?Q?yqmXhXCtaIohYt0O2q9bSscfX6faBPe+DdnGMHwAvtrN5qY6vZLEOKJrS?=
	=?iso-8859-15?Q?usrecRZb2l3zBXgvgGYQQfQ69hMGTQ+VVfKpWCoRJANzb7r/ZEFY9TcsL?=
	=?iso-8859-15?Q?w+XhETqVsAG8r7uLlPZ5OTJ104gmDLC2Gyaf0jAsOO0e5f9Bg+GBFbQEC?=
	=?iso-8859-15?Q?63G9C9lK3VUN/vqZm1t2qRah4L2FYbypG7Hg7UVBis8LCDC52f7LsdkO8?=
	=?iso-8859-15?Q?QMgiXabXhEy1FkuUqZmBASIoDWuEBz6gqr6WqL9OPHS9Hg3I7T6jCQBKy?=
	=?iso-8859-15?Q?GGUAfm8dRJC+tnHIwaDIk8cpeBCJogp8eVYWYMB4znSBE+XLHBkjQ7b+u?=
	=?iso-8859-15?Q?icIjJ10sdwPv2J87ROwSQwRQpAdq9wkUtyWqBOd0qW9kmbHI8AjJAVYop?=
	=?iso-8859-15?Q?S5RbMeb/Kx1Br45XMeJ+zu1i2WWfK82DHbwuWUxBJ17yJZp/bfvtYAoh3?=
	=?iso-8859-15?Q?4/+8+pR0xgw2xyn7yw8NzFhD1oYO0anWt+Q3oPblSxdQrUytx3Q7FO/LF?=
	=?iso-8859-15?Q?C/EY+yT7n4NOLo9W/osVwd9AO8fuUZ/LQ+NlfWt3DeLh9YbO9NVkH/MXF?=
	=?iso-8859-15?Q?TKI5hPm4uV4eyJZRhS1hPATSFxRoupa2/4ul/cZYdIzSDIOUrPo81xSeF?=
	=?iso-8859-15?Q?QmKq4nV9vkFJ/S9wavCIY+BKMklPT1qV7xNKH5RP4Uu+lJnMqA14ZowT1?=
	=?iso-8859-15?Q?oPn3oOBv6IZOVakVp0rHeuDBib0zv8JDzgKNAtLqJ3G0x0aNWu3Gtok8e?=
	=?iso-8859-15?Q?DYzHU/hSnkf22vUGkTpN2U1Z1g7NiuSnDweLp2kDNbfbmd4L52OwbXdT8?=
	=?iso-8859-15?Q?nPGDNXTNqqXm1sjjk8WLATvu+OShr7QDAMtHEpMmG4sFvhEaOpC+bo33F?=
	=?iso-8859-15?Q?j7JXEeVKMs958TCFhT5FmdTy4fDsizWInVng7VLONgwN8rf7bOUg1fCg7?=
	=?iso-8859-15?Q?UCOQ83q2WXB8CReQ0oqHwcywEj5cSLbIEwt/hf8wB5mX9ibIIGYsjd+Aq?=
	=?iso-8859-15?Q?wU0UUNwmrPB3eLW57T0H/wsIBF7xnGw5owETcMEg8s9jlFN0sdlr6oGNN?=
	=?iso-8859-15?Q?FfqsjIoYqlxjoii/mDC9Filhe1T4qTIsxXFDC5vsb0/Gi/fOHjYXqqpdZ?=
	=?iso-8859-15?Q?O5Ukh8ORd/ClPGvyvOQQc9twrhO/eCC2eEUH60INC6iAPOphWaHRNlQfM?=
	=?iso-8859-15?Q?+2kZyo5SjLU0OfEf+uIhoY8OG360D/YfOoH417lvGgFHZFXOfG5tOmmdV?=
	=?iso-8859-15?Q?9nRYyeJ+mCYMPSKPNcVe7IJ1IeLyKzBe9sa8B7T70lDCgOw=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4211e36c-7f89-46fa-b382-08d99fe03803
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 22:12:40.9763 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AIKCygy6tsiV709iLz2K3udBMF8XfMnRbnyL+bv/RKaD/mKAfkP5gUVJ6TGppOU25L/GX7m5ZM1AxmhlOaaZ+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4476
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4MCkU0032199
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/7] multipathd: remove missing paths on
	startup
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <CAB4C09C37A96C44B52679D06AE48807@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> If a path device was removed from the system while multipathd was not
> running, multipathd would not remove the path from the multipath
> table
> on start-up, or on a weak reconfigure. update_pathvec_from_dm() would
> return that a reload was necessary, but that information wasn't
> propigated back to where it could be used to reload the device.
>=20
> Multipath devices now remember if they need to be reloaded, and if
> so,
> force_reload is set in select_action().=A0 This means that even when
> configure is called with FORCE_RELOAD_WEAK, these devices will still
> be
> reloaded.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

(I found the subject of this patch somewhat disconcerting, because it
describes what your patch set is supposed to prevent - mistakenly
deleting paths. But I understand you meant *completely* missing paths,
i.e. paths that aren't present in sysfs).

> ---
> =A0libmultipath/configure.c=A0=A0 | 2 ++
> =A0libmultipath/devmapper.c=A0=A0 | 2 ++
> =A0libmultipath/structs.h=A0=A0=A0=A0 | 1 +
> =A0libmultipath/structs_vec.c | 1 +
> =A04 files changed, 6 insertions(+)
>=20
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index eb8ec1bd..f1a890af 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -715,6 +715,8 @@ void select_action (struct multipath *mpp, const
> struct _vector *curmp,
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0cmpp =3D find_mp_by_wwid(curmp, mpp->wwid);
> =A0=A0=A0=A0=A0=A0=A0=A0cmpp_by_name =3D find_mp_by_alias(curmp, mpp->ali=
as);
> +=A0=A0=A0=A0=A0=A0=A0if (mpp->need_reload || (cmpp && cmpp->need_reload)=
)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0force_reload =3D 1;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (!cmpp_by_name) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (cmpp) {
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index c05dc201..3e1a7260 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -522,6 +522,8 @@ freeout:
> =A0addout:
> =A0=A0=A0=A0=A0=A0=A0=A0dm_task_destroy (dmt);
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (r)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->need_reload =3D false;
> =A0=A0=A0=A0=A0=A0=A0=A0return r;
> =A0}
> =A0
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 399540e7..d0b266b7 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -355,6 +355,7 @@ struct multipath {
> =A0=A0=A0=A0=A0=A0=A0=A0int retain_hwhandler;
> =A0=A0=A0=A0=A0=A0=A0=A0int deferred_remove;
> =A0=A0=A0=A0=A0=A0=A0=A0bool in_recovery;
> +=A0=A0=A0=A0=A0=A0=A0bool need_reload;
> =A0=A0=A0=A0=A0=A0=A0=A0int san_path_err_threshold;
> =A0=A0=A0=A0=A0=A0=A0=A0int san_path_err_forget_rate;
> =A0=A0=A0=A0=A0=A0=A0=A0int san_path_err_recovery_time;
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index 85d97ac1..e52db0c4 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -237,6 +237,7 @@ bool update_pathvec_from_dm(vector pathvec,
> struct multipath *mpp,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free_pathgroup(pgp, KEEP_=
PATHS);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0must_reload =3D true;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0mpp->need_reload =3D mpp->need_reload || must_reloa=
d;
> =A0=A0=A0=A0=A0=A0=A0=A0return must_reload;
> =A0}
> =A0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

