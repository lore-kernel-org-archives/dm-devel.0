Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A80E9C433EF
	for <dm-devel@archiver.kernel.org>; Fri,  3 Dec 2021 08:27:50 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-593-kmpKR3ytOlqcvlcn3pdtnQ-1; Fri, 03 Dec 2021 03:27:46 -0500
X-MC-Unique: kmpKR3ytOlqcvlcn3pdtnQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D175A10862AC;
	Fri,  3 Dec 2021 08:27:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5A4FB10246F1;
	Fri,  3 Dec 2021 08:27:41 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C9F991809CB8;
	Fri,  3 Dec 2021 08:27:40 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1B38O7NP025888 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 3 Dec 2021 03:24:08 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id CBA021121315; Fri,  3 Dec 2021 08:24:07 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C66271121314
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 08:24:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAA6F185A79C
	for <dm-devel@redhat.com>; Fri,  3 Dec 2021 08:24:04 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-48-q-oCLgOlMayKUtmubuNBCg-1; Fri, 03 Dec 2021 03:24:01 -0500
X-MC-Unique: q-oCLgOlMayKUtmubuNBCg-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2170.outbound.protection.outlook.com [104.47.17.170])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-39-Wjbb4N1ZOReLrdVdNaJm8Q-1; Fri, 03 Dec 2021 09:23:58 +0100
X-MC-Unique: Wjbb4N1ZOReLrdVdNaJm8Q-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB3PR0402MB3900.eurprd04.prod.outlook.com (2603:10a6:8:e::14) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23;
	Fri, 3 Dec 2021 08:23:57 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%5]) with mapi id 15.20.4734.028;
	Fri, 3 Dec 2021 08:23:57 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/3] multipathd: update dm_info on multipath change events
Thread-Index: AQHX5+XogJCngVBBoE+0nABy3VZ6FKwgbm4A
Date: Fri, 3 Dec 2021 08:23:57 +0000
Message-ID: <b0ad54331f769e2e05e334606517c7048bb47a88.camel@suse.com>
References: <1638495252-15739-1-git-send-email-bmarzins@redhat.com>
	<1638495252-15739-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1638495252-15739-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 444b9acf-3e13-4d50-dda3-08d9b6364088
x-ms-traffictypediagnostic: DB3PR0402MB3900:
x-microsoft-antispam-prvs: <DB3PR0402MB390094D41572467338173A56FC6A9@DB3PR0402MB3900.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: LxLKZMt97IRV8tSVC/Mky40vEuIuHPyIauYm8zk1WBZrKI0/XwZQ5UTiNTp3nukyR03H4Wykv4HTSpBGN/DNDYgGzPN2MSkGBAUK91zmUtImPiMO95hQOq1FsZ564UnLbhAzgRK4ZleRdAGSbUTuFuMVjbgva36/fV7CMszYQrfTxsgf0DJgBnyJZFUgqyQ3ccRsdfgNHm7Pl54gr/VfEHbPhaQnGcqf9e32KfOAqCGgqkSwPlBr+CW42odBu6ECUo8dGJlded1S4roHXNu81HcSGjcrO4cASgbLvZl5pmuOQE/l473zN8p03sniLQVDcqCkJxqt914KYk0vZPhVPW02/70PLNA3485UFzwxNsjab1RhiPJzLaVki/0gPnH36nwLyEIn87MTg4mNLv822iXXTuz7fVo6erHfv5HG5PJKCF0GJ3kL0WljuAfitTdoWFa22S71Dp95iP6hQhv6cVUOgg9OgWTypGNqUt+2ec/D2pBEyVfZ7N9LUhVUJs1e53bxKSLbTnwkSyYKeM1WYGRycHS3NhEx4Ku7MVZOSMP6ssjR7YTAQNr4BJDwxgdIREdPq2P2n3WdlUhVIFeJ/7z5Htv17wzn2NJhTuatSLrZtE4aDNzpn9zE5I38I2369Q2/tNqThTEqtpk4gaoLNT+TQRzggL95hexRuj64CdmKU2N01LYXZGYwoqwI0Jd3I/Wre8H7kxBesMuW51NxGw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(38070700005)(26005)(6486002)(110136005)(71200400001)(122000001)(36756003)(8936002)(6506007)(8676002)(2906002)(38100700002)(44832011)(86362001)(6512007)(316002)(66476007)(66556008)(66446008)(66946007)(64756008)(2616005)(5660300002)(508600001)(83380400001)(15650500001)(4326008)(91956017)(76116006)(186003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?SorrZlrd+CoRJylXSPRLaBhlsDmbtPO8rPDeCnwufn/14b5iuid+MyTLe?=
	=?iso-8859-15?Q?v4uzjuoz0foP2Qez5zGDwIvobjpTeyt1sNRJBBbf8dAljs5yVsdaI3pN2?=
	=?iso-8859-15?Q?kEsdJR/TGOd3oLklrAD0pr+Z0SU8ofug1j1w02iOGxhyuKVDW14WP+4Nq?=
	=?iso-8859-15?Q?GxKXYzt7eTHXOZiQRm3eWtMNMugYELzeWiRQXngF38MZZnPWZgHy5Aohr?=
	=?iso-8859-15?Q?W3/NjNJD0TZxLJxnP1P59Rm1sptNxLYivOaMx9owpcY0TlSamWGZQ3aML?=
	=?iso-8859-15?Q?d1RNIrTD8a2890UjM8IusqGrRQM2Fj6Xs23l+FEYftyYJZPv4Z7gZHbv7?=
	=?iso-8859-15?Q?fzN0B7gosIAWbY0M5LVqjgA6MXPHcJYGg82DGF7hFWFWmanELZHjOGY+o?=
	=?iso-8859-15?Q?C/SPW7eIpVZwGTQDLgBJLcvU452UoQxqqs/7JR23bsnGsTzLaCsotYOeo?=
	=?iso-8859-15?Q?RiH58+YhTqockGgMAuf8hw6McHApgkf3i/ZLdkSjUxSYa4V8vqNgaeLCq?=
	=?iso-8859-15?Q?b8VjkAsA6T6YKonP4MNLUXtD9uXAGd2t0MlE/z+p9EOUsy9NfZkeuDM6h?=
	=?iso-8859-15?Q?4yASxNybly2sVSpsAqCz5s+5wmwGYScSMW/dWRgkYa/5QOmHITv7c3WS0?=
	=?iso-8859-15?Q?gvJwmIDyztkBj/04eEsVg+FCzRFTDioZrDsUb5F5nXcUhbTU14v5SoLkn?=
	=?iso-8859-15?Q?XJJbca7ni/n+OWVmThkWtpt8DOdbjjbyTaZoXw2+msMndeJkS2ZjHnl9M?=
	=?iso-8859-15?Q?AYOkZvXsfD0oK4MQx9zwKEqQD1hHD7ikEW1OxcbjMzClTr6o7871YBDYn?=
	=?iso-8859-15?Q?26dITYfoI8aA271lc8YtsW5v7QwgyoOfLMTtIIXpOzA8eBBktf2q/2o50?=
	=?iso-8859-15?Q?digYX1i/YV57Ab8bw3rlEspkWjePTP3an8yU1gkv+V3cTJCx+P69GC4QW?=
	=?iso-8859-15?Q?4Q2sRSnBrKmIdtCRrseYei/jBXv66EGTPWZuz+wX2Jni9Ct7n68NeyctY?=
	=?iso-8859-15?Q?1I0C4vvUw2B6uXqas7mFh2TRTiwr3YlvtDmbx0365+K+VYfbRo9G6T8/A?=
	=?iso-8859-15?Q?DYBGMTVOLb8CPL+ab35OQAItPxRQkb+rVub9ZUlLW4Cp0o8m0xlogocyX?=
	=?iso-8859-15?Q?nif65Fg1CkyInKaAjH2qPe+Gxz8+A9KDXsJbJ9H6yibGfczzriy+OZix2?=
	=?iso-8859-15?Q?+AOqVR+XcqPud/eNxPynv3S6GP7VHryOvcUkHGNgKDzjKPttiYDwJLI6v?=
	=?iso-8859-15?Q?4PYthdqDhuaLhQYZ0ppyvbwouJRAQgCPPDnvMD8FtvJ7LBR1WtOuYWanm?=
	=?iso-8859-15?Q?31F9ustN1kqkUqHj7Z1w3yiF3214N7MvJihDZ2G661Cn+vk1GfxLh5B6i?=
	=?iso-8859-15?Q?QSCrv7Pmh0mz27k6PEG1XfIGWBqSGTghjZNWX9STu+LelHfHG0ZPVEWz3?=
	=?iso-8859-15?Q?qSU+1U2UJkD1JIQhObmhult/AYxqYuYrqNDlnv1ogYP1CrtpS5F14AR9c?=
	=?iso-8859-15?Q?eYpt0WGKIPD8iH/MIFm+KGBYi58bIgICajdhhBbRudZTjHUakhYAcwGdY?=
	=?iso-8859-15?Q?fGXMnIbT/AnmhxkQV8AtflHMH8Q5iS/xhKkkZwtqAjCdC4VYyD7LygQmq?=
	=?iso-8859-15?Q?FS1HSXzXNuuFLQvHcePyYtmSVuBEkP1bh98fXS5xbBKBPV/+fahc1R9op?=
	=?iso-8859-15?Q?OvTkm9RBLzm4o8yNJrBijmmEIf5GolyotU+037OLLbXo6Z0=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 444b9acf-3e13-4d50-dda3-08d9b6364088
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2021 08:23:57.6076 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C0GwzNHkffcMNXT+wlRTAHdV1UsLFzQr8ELD6S+LivUSFKXeApSojf90gg6xMZUL/QJVHMqyr/LybYqLwUFaFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3900
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1B38O7NP025888
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/3] multipathd: update dm_info on multipath
	change events
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <A7DCD6962DD66249BF1BFD29F2361FE9@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-12-02 at 19:34 -0600, Benjamin Marzinski wrote:
> When multipathd gets a change event for a multipath device, the dm
> info
> may have changed, so update it.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0multipathd/main.c | 1 +
> =A01 file changed, 1 insertion(+)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 7a57a798..5cb70575 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -818,6 +818,7 @@ ev_add_map (char * dev, const char * alias,
> struct vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipath_co=
nfig();
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reassign_maps =3D conf->r=
eassign_maps;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0put_multipath_config(conf=
);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_get_info(mpp->alias, &mp=
p->dmi);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->wait_for_udev) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->wait_for_udev =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (get_delayed_reconfig() &&

Reviewed-by: Martin Wilck <mwilck@suse.com>

Note for future development: I just realized that dm_get_info() would
also get called in the dmevent handler. We currently do some duplicate
work in both handlers.

In theory at least, we could look at the event_nr field and see whether
this event has already been handled by ourselves. If the dmevent
handler sees that uevent kicked in first, it wouldn't need to do
anything. The uevent handler would only need to look at properties that
udev might have added, but wouldn't need to do a full setup_multipath()
any more.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

