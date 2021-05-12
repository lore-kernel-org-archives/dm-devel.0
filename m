Return-Path: <SRS0=/P3g=KH=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC67AC433B4
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 09:16:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id EAB4F6127A
	for <dm-devel@archiver.kernel.org>; Wed, 12 May 2021 09:16:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAB4F6127A
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-eJs8hkHlOICLWKiVIB5-Ew-1; Wed, 12 May 2021 05:16:33 -0400
X-MC-Unique: eJs8hkHlOICLWKiVIB5-Ew-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7F1D6107ACC7;
	Wed, 12 May 2021 09:16:29 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id ED44F6091A;
	Wed, 12 May 2021 09:16:28 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 4A99455341;
	Wed, 12 May 2021 09:16:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14C9GQkU001639 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 12 May 2021 05:16:26 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 15CD8112D403; Wed, 12 May 2021 09:16:26 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BB61112D19F
	for <dm-devel@redhat.com>; Wed, 12 May 2021 09:16:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 99D349124C6
	for <dm-devel@redhat.com>; Wed, 12 May 2021 09:16:22 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-9-HBYxEublOsqRj9ZD5XzIjw-1;
	Wed, 12 May 2021 05:16:18 -0400
X-MC-Unique: HBYxEublOsqRj9ZD5XzIjw-1
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur03lp2053.outbound.protection.outlook.com [104.47.10.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-23-1Ny7pbObMm-f0ZowHklJDw-1; Wed, 12 May 2021 11:16:16 +0200
X-MC-Unique: 1Ny7pbObMm-f0ZowHklJDw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5068.eurprd04.prod.outlook.com (2603:10a6:10:14::30) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25;
	Wed, 12 May 2021 09:16:14 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Wed, 12 May 2021 09:16:14 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/5] multipathd: remove duplicate orphan_paths in
	flush_map
Thread-Index: AQHXRrx9UCiUy34VMESpxuFCQdCdE6rfkW+A
Date: Wed, 12 May 2021 09:16:14 +0000
Message-ID: <f66c192cdae3625b99b981c9e37c9d03703d8509.camel@suse.com>
References: <1620775324-23984-1-git-send-email-bmarzins@redhat.com>
	<1620775324-23984-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620775324-23984-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95bed888-5e28-4762-afcc-08d9152697be
x-ms-traffictypediagnostic: DB7PR04MB5068:
x-microsoft-antispam-prvs: <DB7PR04MB5068F90B4BBFF0DD28154456FC529@DB7PR04MB5068.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:291
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: M7By7kR74jNTEn35Kxvecz4GV2lhCytYM0CYl1vex/5G5MNpNMqxkk7d+3MlNydtpMDzBFksfmv7WxZkBZUua0T9ITCwtLS1BkaT2Fq8Wnjiuxk0h1bUeHWm6P83myvS/OdPUCO9tNqGIoFjHLJbp3H/MOCi1anvbU3qVnlCLIIfukF6NZvhls1c7hCV7sAGCRQnFohVpYzGt5qmoZXZTfP0jS7QA0UWvESSjaqkJjM95ufhCxxUBebsAjIK54XjcY/hxUt1y3eFEFmUChA6mVR7X0Jh1qWMS1uL1oxmVxKBufP83CF/sOxZNHO8jBejAF1w/ePTl+b+1fCy+PTvLLaLI14FFbuWtZtisQDb76b/oC0slKtVrQVwomTxzhslIkz9MDxR+6upj0OfUWr7/u+hsHsOa68ZUxUrkoMOIoTz9EiVLPEHbrfSm1McGzMdkLx9nOOwz4bLcPAr2wKmmhjW+W+tZmPC1GPq89LdygHAMHWhbzdoUO+4z1Y2uHNK5qZOuKTSneB3jyZYh/R+EhgeQth6GC0Bq4t+QFVbJND8pATnoaQbhdRPUeWw62Lg1nQLQZr5TkdqiY4JpFX1V4OQfXdw+PRx1cmXVZ3yA1g=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(136003)(376002)(39860400002)(396003)(346002)(44832011)(66476007)(66446008)(66556008)(4744005)(64756008)(8676002)(71200400001)(38100700002)(110136005)(91956017)(2616005)(36756003)(76116006)(6506007)(186003)(316002)(6512007)(83380400001)(8936002)(5660300002)(4326008)(6486002)(478600001)(2906002)(122000001)(66946007)(86362001)(26005);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?XLCVRpMdVjr3uAIokldN4vkQjVoPFZmfD2vpNruV4jSzbTzKVoOz7JdQb?=
	=?iso-8859-15?Q?l5fYWIKl/kmQEb0q9t9fhdVpPTGLzmCVWrynhiFxW23UlD/xiySwxASsT?=
	=?iso-8859-15?Q?HsU6SMpTZ0dBkYpzkm+NQsky3MKHGbVht5Ph8nDjsKkLQyrz5CVTNGE4W?=
	=?iso-8859-15?Q?OqAK1OFAbCOwMYm0M5ySm1ra1/RCCcEFLE1orcn/qmZXgXHmSkpS2ZY9k?=
	=?iso-8859-15?Q?CpJQkjgDbmxQYXL39j8HyI/E/FKGktq6IzOAUczwK6mkR1ROWpfSfVL51?=
	=?iso-8859-15?Q?EMML+dtgEJBEFoUgKVu8OC9XQa1Z/kjLDDd72Rm/VUNRgE4OXYkrrCqwM?=
	=?iso-8859-15?Q?FFBiqSYoaZtN0ScjHd87RMXmfHrRMSvntsYZwITmnXv8gl87dcWg3jEsy?=
	=?iso-8859-15?Q?ppIPyrKltuunDkqfzTHTaVAFdOIplLL3RK3vrdmu57bpVoIO7TVibUS/G?=
	=?iso-8859-15?Q?dFWkCGQq/lnhKmU2Xb48OMAgGW2J+WVmL4A4YspyW6upz0fRopeoDJHGN?=
	=?iso-8859-15?Q?JUE4oF9JdpmQ/Xfx5BCTkpYwdJ0ZWgplQc5XC2FMUW9JYsjwUNnUP57W0?=
	=?iso-8859-15?Q?tXcOJJ1v4fe9uXZ7yReeqQpr6rO7psYdUe3dunpIG4v5UTVJuUVxO3IHt?=
	=?iso-8859-15?Q?qRyS4cYl7axbNehnW+pcl3HKKjFfeqcC7gNlUn3uadjE39w1sp6yOp591?=
	=?iso-8859-15?Q?/krmyne26fzQvFjy9yyVYUi+me3jpWHQTVqgxE0T86PA5ZO11GZBQKUTX?=
	=?iso-8859-15?Q?cPF29H23dgVVIxwJVYAAaKViWPQtHYAtaufonKf5rq6eT4zIrgxwi5fXR?=
	=?iso-8859-15?Q?+u7jtKRwSyg3Cod+3v6o1SjidbMpoY24S08Q9lZ47Up2Sl0mD6xjbxlTD?=
	=?iso-8859-15?Q?OKax3TFmHMUvi9cAqVqsf+Uvfos/fWmLaGu2FFJK6d++DsQ1+8B7L2FB/?=
	=?iso-8859-15?Q?L4Z3pF69vlQIDPE4Cn5VkaJd/tgak314BYA4O+e9HqNBNyzQyIzqGl3kR?=
	=?iso-8859-15?Q?98JGJK5sK8bpZ3rq5wRUeJ+jWNEz3pBP6g3+PMk8IE0Rn3v25IaD74Pcr?=
	=?iso-8859-15?Q?exiiL/g+uatfpU7X9t9GLeRHxsQqju2/LrqvbM4H6p6ugIL5vMsdQp2MR?=
	=?iso-8859-15?Q?Sea52FQDfBV2v1Zy/K6JjNP/CuVJT9ztCvV5kWdcxQ+YGGPYg4iXpCMHv?=
	=?iso-8859-15?Q?FI8zjTLvYuGjXo2HH8NfE3rdbcFp1HXjoI9C7g5m/T0vt/63+tb0QoBo0?=
	=?iso-8859-15?Q?PIWPBI5X6ntb15TCXaZm0q7DxUOrxStab4fAylVDAhpxhoDhk9ul8uT1H?=
	=?iso-8859-15?Q?vCWC4wuCMiLTsz/okQMmBpTYbTUntSCEujB5u5MTrpxwq4uhyeTCckhBv?=
	=?iso-8859-15?Q?A5UqdIzA3f8c9Ix05p18tJ9kE4ducfDNe?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95bed888-5e28-4762-afcc-08d9152697be
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 09:16:14.7953 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qX2Qju9P9nIrA3nExHtf7KmOWP3MGuGkVBk1hx8kVeGly+94OLDfQMl+2oYt3xpDv4dRo6gFclyPEmJcUfY5cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5068
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14C9GQkU001639
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/5] multipathd: remove duplicate
 orphan_paths in flush_map
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <770F7A401C4F5D42AF6FF11062BD3CA5@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-05-11 at 18:22 -0500, Benjamin Marzinski wrote:
> remove_map_and_stop_waiter() already calls orphan_paths() so
> flush_map()
> doesn't need to call orphan_paths() before calling
> remove_map_and_stop_waiter().
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0multipathd/main.c | 1 -
> =A01 file changed, 1 deletion(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 449ce384..6090434c 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -660,7 +660,6 @@ flush_map(struct multipath * mpp, struct vectors *
> vecs, int nopaths)
> =A0=A0=A0=A0=A0=A0=A0=A0else
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: map flush=
ed", mpp->alias);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0orphan_paths(vecs->pathvec, mpp, "map flushed");
> =A0=A0=A0=A0=A0=A0=A0=A0remove_map_and_stop_waiter(mpp, vecs);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

