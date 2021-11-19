Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB336C433F5
	for <dm-devel@archiver.kernel.org>; Fri, 19 Nov 2021 21:41:04 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-321-YOZzPicIOEiN5tloOlxK1Q-1; Fri, 19 Nov 2021 16:41:00 -0500
X-MC-Unique: YOZzPicIOEiN5tloOlxK1Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E067388EF23;
	Fri, 19 Nov 2021 21:40:40 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C86A5C1A1;
	Fri, 19 Nov 2021 21:40:40 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E16C94A703;
	Fri, 19 Nov 2021 21:40:37 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1AJLXmTQ019078 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 19 Nov 2021 16:33:48 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 57FC051E2; Fri, 19 Nov 2021 21:33:48 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4EE7D51E1
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 21:33:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D35FBA09A3B
	for <dm-devel@redhat.com>; Fri, 19 Nov 2021 21:33:44 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-128-HC1bMjZfPlqVcJElwnqoyA-1; Fri, 19 Nov 2021 16:33:43 -0500
X-MC-Unique: HC1bMjZfPlqVcJElwnqoyA-1
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
	(mail-ve1eur01lp2050.outbound.protection.outlook.com [104.47.1.50]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-31-1IrmJdR5PPW-StvP7JXuVw-1; Fri, 19 Nov 2021 22:33:40 +0100
X-MC-Unique: 1IrmJdR5PPW-StvP7JXuVw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5066.eurprd04.prod.outlook.com (2603:10a6:10:1c::10) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26;
	Fri, 19 Nov 2021 21:33:39 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c445:c7a6:f796:5e65%3]) with mapi id 15.20.4690.027;
	Fri, 19 Nov 2021 21:33:39 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] multipathd: avoid unnecessary path read-only reloads
Thread-Index: AQHX3M5WUEb/bxOK1E+H6voh4CAkfawLYJ6A
Date: Fri, 19 Nov 2021 21:33:39 +0000
Message-ID: <6444fd097cf43bdfe6b1947f42f270e958310fff.camel@suse.com>
References: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1637275667-13436-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ade89282-5753-4e10-00ef-08d9aba440aa
x-ms-traffictypediagnostic: DB7PR04MB5066:
x-microsoft-antispam-prvs: <DB7PR04MB50667D52E6F8225DA25E73CBFC9C9@DB7PR04MB5066.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: M5Xjz5mNQpnraEiJhYKzB2lidjLyfN0kJY4n/W5Wa0oACh5VSHZb8yLZ9lcwsIJZsYQp3SD+ybXekyy8hMwpahrhgUTRpr0ip+nLUCJGZRIaH+m6QqkNj+xOBPRoAax5dZ1V0naegqpCpsYMEJBPZ4AOY4UJNzC2gzJZcEH+PxCUp3p+NJQT1LujS+rjo+ogv925GemM3eruZUsZORB7GVhXJ82S4HDjF69nMq1cVBZeDbULamI6IZt9H/r2cCLKCJwqVlAVbHqHwLDrRTXYTvhFJ4RgUiETIwzyqgi+eD3qhadeqC//e8a010v+t2eqKduDBHKPA0NXOkTq+CQDyWGeP2DW7gchRLEJ5vb48h1zcmWsqADF+ozxukuffxysD1ddSImx9QwyI9UxWEWWaH/zTG9sDAES/bHvwE4eC7+gY53Gpl4JQJsIBufvOAJvQYTByHIVqUAlvsb/QL8zF63SbYgrbif6Z0JFHufld3twiVRAksBgK3T1pP9UZRO3x38yriOAGU3ze5OGTZq9giF7c7IShARrnIAPPPEsRs4zic0oyEiXNO7dbD2IDiZdpTNTn5XVxbzmC+V/zEB2pCCrk8lYm4Fm/YLC0N8GKQ+WtnNdUx19yid4vrrd+w3kth8QhTv2H6h3D6OLVsh6Ri6OF2FI2l9uxu5zeMqTBJB++Voh/hFT+Fp9zh1rC4MgooW3esTkZnmhzsNYaOLKGw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(26005)(36756003)(91956017)(508600001)(44832011)(66476007)(71200400001)(38100700002)(76116006)(66556008)(8936002)(122000001)(64756008)(6486002)(5660300002)(316002)(110136005)(66946007)(66446008)(38070700005)(4001150100001)(2616005)(2906002)(8676002)(6506007)(4326008)(6512007)(83380400001)(186003)(86362001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?d5WP5mGgynko1pG3/6Y8ajRBnwy/EVZ21lE28EYX1s8iBvKI7qOcS9si4?=
	=?iso-8859-15?Q?I3zntuFfQ8+GjIb6m1EDGWhENHmfXxw14Gf5WLmIalMewZwvjDo9NWrRZ?=
	=?iso-8859-15?Q?XZMCAVrTGmqBGmGFNlxN0mS0++vpGxXLsEiI3oNj27GOwuS1phgenWleC?=
	=?iso-8859-15?Q?qUcJIftavAuZgi3Re4bX1xhuwrs1TeW7OPOxyGJDNXzV400kD/j9QImxP?=
	=?iso-8859-15?Q?UT1f89q0Ky6wm7ixannA2lf0ncK0fdxbClL1MAzuq81c9sbksTg7rLAA1?=
	=?iso-8859-15?Q?wioCvwxcencJFn8F1KnhoDjKWLdV+zBCjGmR3HShNyKunJCx7v5ly5R1Q?=
	=?iso-8859-15?Q?ox0rLs9rsGsTTlqPQi34852zFbtPGx9PBoWp67Z08GkkK5TDu6V76l32/?=
	=?iso-8859-15?Q?vGG9y8A5Ka6QElepYIUCCKo6jNRg5jSiNA9a6MtOkIkI4mDWdTZJ4E/z2?=
	=?iso-8859-15?Q?Nox6C2JS32ryITrZc6PCHG4VIRIsnNpvHWCAtGeRm59bKunOUzAAzsh+S?=
	=?iso-8859-15?Q?NTjBJ14pXR2iOwHY8IDH+SfuMOYaAbipJkeMqQk2P7/qJBNX+Udb2+4ub?=
	=?iso-8859-15?Q?wA6qLBrtzWLo2JRrFTR48vsXaLeyZypbBC/M7VV32klSUL/zvYgRTzgC8?=
	=?iso-8859-15?Q?7pmb0BA0BJ50CntRVMSpNnDqM004vTofDFYVpvS1aag3TnrFfMunj1LwC?=
	=?iso-8859-15?Q?u3RXtJfRsPYmue/9c2ZdD2RM22E1Itp/Bd6+0g2vKd1tg5ozzYv7oFLEF?=
	=?iso-8859-15?Q?XjgqMjZ0lgcQiq1YIUtGTEIS8oZG4lSEgQW9+oZvtfu+VIjA+R2yt0dgi?=
	=?iso-8859-15?Q?+AdYAvoPQyG40VyInI9K0GUa4J2V5rUL31u9DiHmq0nSdNzXz7fPNmTVh?=
	=?iso-8859-15?Q?FSA5CLFj1O5DnkuJkO06cTgZDcOAGnXb7sU+W2D7BpYq8ltCUSp9SiZT5?=
	=?iso-8859-15?Q?092Tqm6OMN21yavQ3k1qMqmoFWqRMVYYbwLqrBVW7mrXVP1N6a3nas5bO?=
	=?iso-8859-15?Q?QNqJosf/MGZj8suZOKBvAH3ds1B8+T958omGZkLmvjJQegiM5WQm1bC9Q?=
	=?iso-8859-15?Q?UUQMbP/dSeUgLmMBJFnaNsp1pW3j74Pjj4Rh7m5dIwXmcs2IEKUW9iQHM?=
	=?iso-8859-15?Q?rmVvhUerlhfVBd4/K+YuXFa3hTG/lQ6Ae4pGKrxpog9dONte5QwaHVh4w?=
	=?iso-8859-15?Q?+MiIsesneJO2fQ6iqqyeMZdHcMHleQdssPVCjKn02bmHgsVBX4ve6Y/Ne?=
	=?iso-8859-15?Q?NQp0KFD8mIgJA0o+f/NJKv64cTy6QWjUFFUkVf1dPhwGG35dWpEX2ybDD?=
	=?iso-8859-15?Q?vAauCk2zj1rsco4oR4C+gRaivA09r49SO9WyaRnWtTDs41hWR5ntgsuSE?=
	=?iso-8859-15?Q?6Vk2jGbRm1ZQBxb7i4m8eK+ajyljwgW+hG2/xZiBvFd3VTVep6u3YqFnN?=
	=?iso-8859-15?Q?Q0Dq6KFr2ugxhe4FM5dTHrKK6c4qIIAQyseNYXVt10vGKLUp4RRHhCltV?=
	=?iso-8859-15?Q?+2zp/zukqH8uDWcjd9JmaKTuqJ8hjtmNPLcnhKZmq6P0RHi5B7i8KIyTq?=
	=?iso-8859-15?Q?vIPzqcbIwTqYOgfhuV5g4LH8vKeCnpk6dUKtfEdyU6Tnk+Ku06IbTDxej?=
	=?iso-8859-15?Q?VWOYiIUhkyQkta1bZ9Q+C2PyErX+CPeLONVNfE73IHTt7qrvBiGlSN/sr?=
	=?iso-8859-15?Q?mte0d6hCM4TDhQ70eSpB8KQb4j1heJDbFRtseWrQ03BTmB4=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ade89282-5753-4e10-00ef-08d9aba440aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2021 21:33:39.6875 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KTInyFv6haHB6OIED82BFXf6uhZ0eA8LPGEtef3wOUwjkqwLAQjBKmNtrhKinTiHpZZj2I6+S4PA0DghRT6Umg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5066
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1AJLXmTQ019078
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] multipathd: avoid unnecessary path read-only
	reloads
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
Content-ID: <E204240BA4688A489FC56B3A60D00289@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-11-18 at 16:47 -0600, Benjamin Marzinski wrote:
> A mulitpath device can only be reloaded read/write when all paths are
> read/write. Also, whenever a read-only device is rescanned, the scsi
> subsystem will first unconditionally issue a uevent with DISK_RO=3D0
> before checking the read-only status, and if it the device is still
> read-only, issuing another uevent with DISK_RO=3D1. These uevents cause
> pointless reloads when read-only paths are rescanned. To avoid this,
> check to see if all paths are read/write before changing a multipath
> device from read-only to read/write.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/libmultipath.version |=A0 5 +++++
> =A0libmultipath/sysfs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 22 +++++=
+++++++++++++++++
> =A0libmultipath/sysfs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 31
> ++++++++++++++++++++++++++++++-
> =A04 files changed, 58 insertions(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index 58a7d1be..ab4c7e30 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1440,6 +1440,35 @@ finish_path_init(struct path *pp, struct
> vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0return -1;
> =A0}
> =A0
> +static bool
> +needs_ro_update(struct multipath *mpp, int ro)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> +=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> +=A0=A0=A0=A0=A0=A0=A0unsigned int i, j;
> +=A0=A0=A0=A0=A0=A0=A0struct dm_info *dmi =3D NULL;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!mpp || ro < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> +=A0=A0=A0=A0=A0=A0=A0dm_get_info(mpp->alias, &dmi);

Why can't you just use mpp->dmi here?

> +=A0=A0=A0=A0=A0=A0=A0if (!dmi) /* assume we do need to reload the device=
 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;

Why that? I'd assume that if a DM_DEVICE_INFO ioctl fails on the
device, a RELOAD would almost certainly fail, too.

> +=A0=A0=A0=A0=A0=A0=A0if (dmi->read_only =3D=3D ro) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(dmi);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return false;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0free(dmi);
> +=A0=A0=A0=A0=A0=A0=A0if (ro =3D=3D 1)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (mpp->pg, pgp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (pgp->p=
aths, pp, j) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(sysfs_get_ro(pp) =3D=3D 1)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0return false;

I think you should also return false here if sysfs_get_ro() returns
error.

Regards,
Martin

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return true;
> +}
> +
> =A0static int
> =A0uev_update_path (struct uevent *uev, struct vectors * vecs)
> =A0{
> @@ -1512,7 +1541,7 @@ uev_update_path (struct uevent *uev, struct
> vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ro =3D uevent_get_disk_ro=
(uev);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp && ro >=3D 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (needs_ro_update(mpp, ro=
)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(2, "%s: update path write_protect to
> '%d' (uevent)", uev->kernel, ro);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (mpp->wait_for_udev)


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

