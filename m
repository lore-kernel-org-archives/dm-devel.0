Return-Path: <SRS0=ptSP=PX=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2FBFC433F5
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 22:11:00 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 3BDAD61220
	for <dm-devel@archiver.kernel.org>; Thu,  4 Nov 2021 22:11:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3BDAD61220
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-FL8kLHt-NNiJYw5MyBkTVw-1; Thu, 04 Nov 2021 18:10:55 -0400
X-MC-Unique: FL8kLHt-NNiJYw5MyBkTVw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3F6A8042CF;
	Thu,  4 Nov 2021 22:10:50 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 295D360BF1;
	Thu,  4 Nov 2021 22:10:50 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 1C41E4A703;
	Thu,  4 Nov 2021 22:10:49 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
	[10.11.54.2])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 1A4MAj9X032093 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 4 Nov 2021 18:10:46 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D0F66400F3C6; Thu,  4 Nov 2021 22:10:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBB1B401A993
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:10:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ACE0A18A01A0
	for <dm-devel@redhat.com>; Thu,  4 Nov 2021 22:10:45 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-329-rsjdQW9VNdSRqVl6hp1vxA-1;
	Thu, 04 Nov 2021 18:10:44 -0400
X-MC-Unique: rsjdQW9VNdSRqVl6hp1vxA-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2051.outbound.protection.outlook.com [104.47.14.51])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-31-4riXJ7sHOkyBe0VOz-JamA-1; Thu, 04 Nov 2021 23:10:20 +0100
X-MC-Unique: 4riXJ7sHOkyBe0VOz-JamA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4476.eurprd04.prod.outlook.com (2603:10a6:5:36::25) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15;
	Thu, 4 Nov 2021 22:10:18 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::d0d9:a949:8409:bbc7%3]) with mapi id 15.20.4649.019;
	Thu, 4 Nov 2021 22:10:18 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 5/7] multipathd: fully initialize paths added by
	update_pathvec_from_dm
Thread-Index: AQHXxebeV4GFGv0wyUqQuLf4uivcTKv0BbIA
Date: Thu, 4 Nov 2021 22:10:18 +0000
Message-ID: <2a319ae1e5eba66db17ab6372c95ac81f75a92e2.camel@suse.com>
References: <1634757322-6015-1-git-send-email-bmarzins@redhat.com>
	<1634757322-6015-6-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1634757322-6015-6-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9e0cbf6-91dd-4e25-e96e-08d99fdfe345
x-ms-traffictypediagnostic: DB7PR04MB4476:
x-microsoft-antispam-prvs: <DB7PR04MB447606E2D925A35283640996FC8D9@DB7PR04MB4476.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: O9XoXSrkoei2+IpXLpRztCTYgZIgiAGWgKJUep+BoI1sLSnw6+L6dSDSqpha1kkQdSBAcw/qqND0ljwU9vgvo7aDTxeQAGZ8JuIOoafyP3Bg/xLbjfrcaawCNwfTGq7dft2Rdf5Y11mApw2sk6naPXpGxzGv316I/LCw6PQAGEndLOXpy3AnR7IO6GKyQTOT9+ocmL/pQaJke42JlxLXyBIaEEZCXV4mtmcFoi9S3XN/ZCbxOjm2ggQqh8jHzhL4IDsmqTJxRsT33d46UfkBdqPbAQuzN/9r4xwGfGJkwJlOfjuB+sqExmOhQ7ueNLSxlm1DkREz7cfDqQLOcf0eDTAiKxokjNrcnt0mVCDc0FkJkXjYp1Z3DEDxCdZYT7BP+kBGkfPmhW68sQVAu+ELoYD5SxBOl28sQS3K8XmLyWR1yytqycjxsDhkJh88rsdpQZKRxQuBhMfDE8LtKbcT6YQ17RsKS26scMnhScedhdifAIp3wOqTFrklr4ITCVshAceaV1TAXbloIWhwAU8Q12bccJmSfx+2Sk0DicemEWTf1rOm4BsbcJaK0b4aMS201a5qFKJtowQyymsKezxOxYtgNr5/U+9fnLB9j0J2z4v7l6x6Uq2esgI2MXRae7pFyd8p+2MCu18Z2rOdiefrE3Yw1gnCjVpJlmtmWY4M7SKl+Xi4sNSlCbMlgU3ti6eSXyw2mgkghxzvHwBeMo/ZHQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(71200400001)(186003)(15650500001)(36756003)(86362001)(26005)(8676002)(508600001)(2616005)(6486002)(6506007)(76116006)(66946007)(91956017)(38070700005)(4326008)(316002)(44832011)(122000001)(4001150100001)(66446008)(2906002)(66556008)(5660300002)(38100700002)(8936002)(66476007)(64756008)(110136005)(6512007)(83380400001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?shBCb72tDxycGuvGrV+6GFJOHmcTCqPyJvrDV/bv+OerRInlSjuVDIawt?=
	=?iso-8859-15?Q?pf0Ebmup8UQg1yhmENqFRTpRdeAA8DZx8qTQUAhUNtiXioKJ8EcvFYITm?=
	=?iso-8859-15?Q?xt5/vsLkW/2qhJumVT2DSpniJ4qU4yFIsvCIGM4X3yGv+CHPoORuoW23x?=
	=?iso-8859-15?Q?xA5mhAW7HXpX0IVXnFUZsEOpqQyIdyVqo1b5aEvgMCTeoU+38V1Yofxtf?=
	=?iso-8859-15?Q?nT6bhUZyYeXDNGvVUkCFlaD79FFNEavGB77LsOTMH0sUvvwcZrljTUdOM?=
	=?iso-8859-15?Q?Lh45o42YyV2kZz/4Qk2yNbp7Tnsd9KiOaKkaLOs+h4nUOmPTM8pc62Pxq?=
	=?iso-8859-15?Q?G5PkgDo1h7hfCzA+oGgl/XP3axGgv50eQp6vOH6NbEWzFnVgsjWNifzp3?=
	=?iso-8859-15?Q?IyX9iVhgtalJVHVABtUXcUa+o7WQs2CrKYG+UM0Y8YochZU07MicE/RSL?=
	=?iso-8859-15?Q?/k5Wjxd139BgdGxrhozMhZ/wm6S0ihjClDIY7Zyw0B7iguM+y8Saj6Fh0?=
	=?iso-8859-15?Q?1shLhS4ROp9+pzEHRYoG/p79gH8VWM73gc14oEoH6ZGo13sc883SikS2C?=
	=?iso-8859-15?Q?y086E01vKfwueiLFiMRZzzNgcOCQxgy+hmOIPC5cLCX2cHEZsHYV+eadw?=
	=?iso-8859-15?Q?1VVnWV1I/vbtkaYfsT1Ap4pSZgefwSWHPEwmv/hUY4LJHLl9YYKpOb3DY?=
	=?iso-8859-15?Q?PFfXTzdfM73PLdkaYoUSybF0nnzQRruekzZRa8nNylzIR7Xf6LtQisXXG?=
	=?iso-8859-15?Q?4tOOo5KXgRpcmi30TijUwRUjqAYgIpAFhYvJ2dZoWX3/6Vnunk4qgKwpk?=
	=?iso-8859-15?Q?oCFjf7X6+qprIw5UyqyGfIuCQ8otvfUE/LbTJbX3fsPWl6DkpKSPtAxWM?=
	=?iso-8859-15?Q?pd1j3CKf2w6lRuoeoMGF6ENbv/AuV1/XM3yNYdT8GOGPMyWgq9mmbNFgx?=
	=?iso-8859-15?Q?yNGUKR9k/UCmcQc0FL72LQOT0caKUeUWzx9PANAePH647oiGBmhq31lkL?=
	=?iso-8859-15?Q?LjVz1LcLpOgurwtwObHYnno/PyOxRDgDpqWLUiDi28JW+tM6L7sfyGaSk?=
	=?iso-8859-15?Q?uLzds1MVn9c7rH9vdOlPhy4IakY6o2vmhclpFM4D5AMZaE11fbpH4RDzz?=
	=?iso-8859-15?Q?IWfIfAYopSvv7r8NvmcaNT5tNFV0QF9O4JeBEE7zmLozg5A/sMpVYBRSi?=
	=?iso-8859-15?Q?/oyTT61aobKv7ugGKkXhwy5ZVnFYT27F0uR8fIzyVjRKKsbxzistl2Bke?=
	=?iso-8859-15?Q?jUG1uIZ57e1Fjv+NTUNB/mlkVlYqrp6tarcO0IvlNRY37Tq10G6s7IrD0?=
	=?iso-8859-15?Q?M2Sp5ka5Yb+KSwSJ1tQjpJcqeESK53+nQLBfRRz3HgJBhO9iOaSjX1guv?=
	=?iso-8859-15?Q?8p0pRqK6zDyu+2bWC5RsB3cAZWVwuya+q03nNVzVTYW3ursgqkrTrBE76?=
	=?iso-8859-15?Q?YG1D4Fistwe6pMREVNckAzkYPYuEcMM60kLighWLQXOiluVrPtM1AImct?=
	=?iso-8859-15?Q?8PfXBbJ9O7hFDGI9Z+WDlNmkp+8WgmviKI5l62KfHzYwVHsZq8DvJgWL3?=
	=?iso-8859-15?Q?KpqOpvM1oFGzzzpSzbcUNacIQnRZD/HxjeZ30vMTcObhhnwdPLNeJkL7+?=
	=?iso-8859-15?Q?HuN65AGxprtXrY/OwJE0X+AkYyxaf8W3SY8aoETF54nwIbPJHCXbk0CPZ?=
	=?iso-8859-15?Q?GQ3tLwbXv7yDwZ2LagzpYP3S6oUwHsm9ytq5ts94Q9hy6n4=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9e0cbf6-91dd-4e25-e96e-08d99fdfe345
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 22:10:18.8419 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qV7SryLSquU96yAyfMvdEs3trr3Q9jRr05rxuVWmeDW2+EC8yU5SJAHO1pW6r9Phaa3UQ7ylzf7hSIw25ZmUgA==
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 1A4MAj9X032093
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 5/7] multipathd: fully initialize paths added
 by update_pathvec_from_dm
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <6F937901AF45324F95B9C997AE0414BB@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2021-10-20 at 14:15 -0500, Benjamin Marzinski wrote:
> When paths are added by update_pathvec_from_dm(), udev may not have
> initialized them. This means that it's possible that they are
> supposed
> to be blacklisted by udev properties, but weren't.=A0 Also, in order to
> avoid doing potentially stalling IO, update_pathvec_from_dm() doesn't
> get all the path information in pathinfo(). These paths end up in the
> unexpected state of INIT_MISSING_UDEV or INIT_NEW, but with their mpp
> and wwid set.
>=20
> If udev has already initialized the path, but multipathed wasn't
> monitoring it, the blacklist checks and wwid determination in
> update_pathvec_from_dm() will work correctly, so paths added by it
> are
> safe, but not completely initialized. The most likely reason why this
> would happen is if the path was manually removed from multipathd
> monitoring with "multipathd del path".

Not quite getting this - normally the path would be removed from maps,
too. Are you referring to the REMOVE_PATH_DELAY case?


>  The most common time when
> uninitialized paths would in be part of multipath devices is during
> boot, after the pivot root, but before the udev coldplug happens.
> These
> paths are not necessarily safe. It's possible that
> /etc/multipath.conf
> in the initramfs and regular filesystem differ, and they should now
> be
> either blacklisted by udev_property, or have a different wwid.
> However
> an "add" event should appear for them shortly.
>=20
> Multipath now has a new state to deal with these devices,
> INIT_PARTIAL.
> Devices in this state are treated mostly like INIT_OK devices, but
> when "multipathd add path" is called or an add/change uevent happens
> on these devices, multipathd will finish initializing them, and
> remove
> them if necessary.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Nice. Somehow in my mind the issue always look much more complex.
I like this, but I want to give it some testing before I finally ack
it.

Regards
Martin




> ---
> =A0libmultipath/structs.h=A0=A0=A0=A0 |=A0 6 +++++
> =A0libmultipath/structs_vec.c |=A0 5 ++--
> =A0multipathd/cli_handlers.c=A0 |=A0 4 ++++
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 48 ++++++++++++++++++++=
++++++++++++++--
> --
> =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A05 files changed, 58 insertions(+), 6 deletions(-)
>=20
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index d0b266b7..69409fd4 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -200,6 +200,12 @@ enum initialized_states {
> =A0=A0=A0=A0=A0=A0=A0=A0 * mapped by some multipath map because of map re=
load
> failure.
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0INIT_REMOVED,
> +=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0 * INIT_PARTIAL: paths added by update_pathvec_from=
_dm() will
> not
> +=A0=A0=A0=A0=A0=A0=A0 * be fully initialized. This will be handled when =
an add or
> +=A0=A0=A0=A0=A0=A0=A0 * change uevent is received.
> +=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0INIT_PARTIAL,
> =A0};
> =A0
> =A0enum prkey_sources {
> diff --git a/libmultipath/structs_vec.c b/libmultipath/structs_vec.c
> index fb26437a..1de9175e 100644
> --- a/libmultipath/structs_vec.c
> +++ b/libmultipath/structs_vec.c
> @@ -194,6 +194,7 @@ bool update_pathvec_from_dm(vector pathvec,
> struct multipath *mpp,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: adding new
> path %s",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp=
->alias, pp->dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->initialized =3D
> INIT_PARTIAL;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0store_path(pathvec, pp);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->tick =3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0}
> @@ -392,12 +393,12 @@ extract_hwe_from_path(struct multipath * mpp)
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "%s: searching paths for valid hwe", m=
pp->alias);
> =A0=A0=A0=A0=A0=A0=A0=A0/* doing this in two passes seems like paranoia t=
o me */
> =A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mpp->paths, pp, i) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->state =3D=3D PATH_U=
P &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->state =3D=3D PATH_U=
P && pp->initialized !=3D
> INIT_PARTIAL &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->initialized=
 !=3D INIT_REMOVED && pp->hwe)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto done;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mpp->paths, pp, i) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->state !=3D PATH_UP =
&&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((pp->state !=3D PATH_UP=
 || pp->initialized =3D=3D
> INIT_PARTIAL) &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->initialized=
 !=3D INIT_REMOVED && pp->hwe)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto done;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 58b9916c..8d37431e 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -526,6 +526,10 @@ cli_add_path (void *v, struct strbuf *reply,
> void *data)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->initialized =3D=3D =
INIT_PARTIAL &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 finish_path_init(=
pp, vecs) < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn 1;
> +
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->mpp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 0;
> =A0=A0=A0=A0=A0=A0=A0=A0} else if (pp) {
> diff --git a/multipathd/main.c b/multipathd/main.c
> index cc4a4a5d..4b8e2cde 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -976,12 +976,19 @@ check_path_wwid_change(struct path *pp)
> =A0=A0=A0=A0=A0=A0=A0=A0return false;
> =A0}
> =A0
> +/*
> + * uev_add_path can call uev_update_path, and uev_update_path can
> call
> + * uev_add_path
> + */
> +static int uev_update_path (struct uevent *uev, struct vectors *
> vecs);
> +
> =A0static int
> =A0uev_add_path (struct uevent *uev, struct vectors * vecs, int
> need_do_map)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> =A0=A0=A0=A0=A0=A0=A0=A0int ret =3D 0, i;
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> +=A0=A0=A0=A0=A0=A0=A0bool partial_init =3D false;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: add path (uevent)", uev->kernel);
> =A0=A0=A0=A0=A0=A0=A0=A0if (strstr(uev->kernel, "..") !=3D NULL) {
> @@ -1000,7 +1007,10 @@ uev_add_path (struct uevent *uev, struct
> vectors * vecs, int need_do_map)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int r;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct multipath *prev_mp=
p =3D NULL;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->initialized =3D=3D =
INIT_REMOVED) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->initialized =3D=3D =
INIT_PARTIAL) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0par=
tial_init =3D true;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o out;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (pp->initialized =
=3D=3D INIT_REMOVED) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(3, "%s: re-adding removed path", pp-
> >dev);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->initialized =3D INIT_NEW;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
rev_mpp =3D pp->mpp;
> @@ -1110,6 +1120,8 @@ uev_add_path (struct uevent *uev, struct
> vectors * vecs, int need_do_map)
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0out:
> =A0=A0=A0=A0=A0=A0=A0=A0lock_cleanup_pop(vecs->lock);
> +=A0=A0=A0=A0=A0=A0=A0if (partial_init)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return uev_update_path(uev,=
 vecs);
> =A0=A0=A0=A0=A0=A0=A0=A0return ret;
> =A0}
> =A0
> @@ -1405,6 +1417,25 @@ fail:
> =A0=A0=A0=A0=A0=A0=A0=A0return REMOVE_PATH_MAP_ERROR;
> =A0}
> =A0
> +int
> +finish_path_init(struct path *pp, struct vectors * vecs)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int r;
> +=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> +
> +=A0=A0=A0=A0=A0=A0=A0conf =3D get_multipath_config();
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(put_multipath_config, conf);
> +=A0=A0=A0=A0=A0=A0=A0r =3D pathinfo(pp, conf, DI_ALL|DI_BLACKLIST);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +
> +=A0=A0=A0=A0=A0=A0=A0if (r =3D=3D PATHINFO_OK)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: error fully initializing path, remo=
ving", pp-
> >dev);
> +=A0=A0=A0=A0=A0=A0=A0ev_remove_path(pp, vecs, 1);
> +=A0=A0=A0=A0=A0=A0=A0return -1;
> +}
> +
> =A0static int
> =A0uev_update_path (struct uevent *uev, struct vectors * vecs)
> =A0{
> @@ -1443,7 +1474,7 @@ uev_update_path (struct uevent *uev, struct
> vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Don't deal with other =
types of failed
> initialization
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * now. check_path will h=
andle it */
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!strlen(pp->wwid))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!strlen(pp->wwid) && pp=
->initialized !=3D
> INIT_PARTIAL)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strcpy(wwid, pp->wwid);
> @@ -1451,12 +1482,20 @@ uev_update_path (struct uevent *uev, struct
> vectors * vecs)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (rc !=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
trcpy(pp->wwid, wwid);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (strncmp(wwid, pp->=
wwid, WWID_SIZE) !=3D 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else if (strlen(wwid) &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 st=
rncmp(wwid, pp->wwid, WWID_SIZE) !=3D 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "%s: path wwid changed from '%s'
> to '%s'",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0uev->kernel, wwid, pp->wwid);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
v_remove_path(pp, vecs, 1);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0n=
eeds_reinit =3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (pp->initialized =
=3D=3D INIT_PARTIAL) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ude=
v_device_unref(pp->udev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp-=
>udev =3D udev_device_ref(uev->udev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(finish_path_init(pp, vecs) < 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0retval =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0goto out;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0u=
dev_device_unref(pp->udev);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->udev =3D udev_device_ref(uev->udev);
> @@ -1507,6 +1546,7 @@ out:
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: spurious =
uevent, path not found",
> uev->kernel);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0/* pp->initalized must not be INIT_PARTIAL if needs=
_reinit is
> set */

Did you mean "cannot" here? At least for the "wwid changed" case this
is subtle, as it's set to INIT_REMOVED in ev_remove_path().

> =A0=A0=A0=A0=A0=A0=A0=A0if (needs_reinit)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0retval =3D uev_add_path(u=
ev, vecs, 1);
> =A0=A0=A0=A0=A0=A0=A0=A0return retval;
> @@ -2116,7 +2156,7 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0int marginal_pathgroups, marginal_changed =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0int ret;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (((pp->initialized =3D=3D INIT_OK ||
> +=A0=A0=A0=A0=A0=A0=A0if (((pp->initialized =3D=3D INIT_OK || pp->initial=
ized =3D=3D
> INIT_PARTIAL ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->initialized =3D=3D INIT_REQUE=
STED_UDEV) && !pp->mpp) ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->initialized =3D=3D INIT_REMOVED)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> diff --git a/multipathd/main.h b/multipathd/main.h
> index c8a1ce92..4acd1b8c 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -66,4 +66,5 @@ int reload_and_sync_map(struct multipath *mpp,
> struct vectors *vecs,
> =A0
> =A0void handle_path_wwid_change(struct path *pp, struct vectors *vecs);
> =A0bool check_path_wwid_change(struct path *pp);
> +int finish_path_init(struct path *pp, struct vectors * vecs);
> =A0#endif /* MAIN_H */


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

