Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3CBC2BA4C
	for <dm-devel@archiver.kernel.org>; Wed, 26 Jan 2022 07:47:24 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-414-axbMkm5xMn-uaCC0882NtA-1; Wed, 26 Jan 2022 02:47:20 -0500
X-MC-Unique: axbMkm5xMn-uaCC0882NtA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58C16654;
	Wed, 26 Jan 2022 07:47:15 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 25D055E48C;
	Wed, 26 Jan 2022 07:47:14 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 90F6F1809CB8;
	Wed, 26 Jan 2022 07:47:11 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20Q7l9vU010819 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 26 Jan 2022 02:47:09 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7C23A1120AC8; Wed, 26 Jan 2022 07:47:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74E541120AC3
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 07:47:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1421B803C9F
	for <dm-devel@redhat.com>; Wed, 26 Jan 2022 07:47:06 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-588-4X604LgzN8WNAD6pumEaKA-1; Wed, 26 Jan 2022 02:47:03 -0500
X-MC-Unique: 4X604LgzN8WNAD6pumEaKA-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2168.outbound.protection.outlook.com [104.47.17.168])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-37-VpyF7v3kM0GQZNQ4NxmujA-1; Wed, 26 Jan 2022 08:47:00 +0100
X-MC-Unique: VpyF7v3kM0GQZNQ4NxmujA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AS4PR04MB9243.eurprd04.prod.outlook.com (2603:10a6:20b:4e2::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15;
	Wed, 26 Jan 2022 07:46:59 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::11e7:5ef4:4a27:62a9%6]) with mapi id 15.20.4909.017;
	Wed, 26 Jan 2022 07:46:59 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH] libmultipath: use asprintf() to allocate prefixed_uuid
Thread-Index: AQHYEnaUzlaN917bKk28ov5rb+SJhqx07N0A
Date: Wed, 26 Jan 2022 07:46:58 +0000
Message-ID: <e42ba93e5423fd686470c2ca47555792b6ccf7c4.camel@suse.com>
References: <1643175325-31046-1-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1643175325-31046-1-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65783371-65bd-4ae7-738d-08d9e0a00868
x-ms-traffictypediagnostic: AS4PR04MB9243:EE_
x-microsoft-antispam-prvs: <AS4PR04MB9243C74682D995BC279BD445FC209@AS4PR04MB9243.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: xt0oaizuGk9kBZqMEMHRDGDiz1FV2JNky0lWnjX0vl3p9QFHQR+uOrHMwKSmVBxAB259RlO94jfF2+2Vkhd212pCwfD+D7izXdBnZv/LTWbtlThcp/c45V+5ystQV7/jEwxj5qvTD3Y+n0YOExvxKH7IbaSgvEEmg/BiY9yVyvI19YtYEx73YSy97gG+EMyrogtN/aCr7jr+SPM2q29cUcGw6XfYO+5vw/+P61y/yef6gIU5PZfMLfOEGGJyRyb6ezhZ+/tCxnrO34h8DqGveWhmsYPUWct8sFP48rSzvkc53guv1HdP0AtlvQNZaUd2a5uLrdFrRfK8QkTKN+FRNojhWmxbCYcygQ54ZVf13PIDatnfLe5DbHoXQolKQQnUjOpnvz5VFIBTcWE8wuxzvYMTw9D/H93bSZ5zxXdDZdPAi/qhf/QPgW+MieeTNO1jvh07Uw8/NNsJZAuT3eX0L8i7wT4GDKu/of4APw+howpRP2G8ZdT7X7OPpIExq6Bs79o7ApOGmkEHu4o3Pbg3v8QsTLDpmR5gJsnbdDBQYS3/BX114alVSiOwI1gPVP6dXW4PJHKzGAhhJ7gFUllXaZFp//Fsrn3Qcy+NBP6YLQPH4eF9jDj2AeSKbCo3hNHNYbElaczWT+ZYB4Hlbjj/CupevUTxh3N/tstNltnyRl+hvUV5fPUxc2+bPlMRfns6CwCquYZOGPImeGeuUmCqvQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(6486002)(186003)(26005)(508600001)(44832011)(316002)(6512007)(110136005)(91956017)(5660300002)(86362001)(64756008)(66446008)(6506007)(2906002)(76116006)(66476007)(83380400001)(4326008)(8676002)(8936002)(38070700005)(66946007)(66556008)(38100700002)(71200400001)(2616005)(36756003)(122000001)(20210929001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?EM9BNyCRmtBHUaJbuB0WgTLviVn15bryYI7GB+BRYWLSDAOmgVLwvQBae?=
	=?iso-8859-15?Q?e39KyeOnC7fMidHExE1CRQg4BZtu2/Kgv+iQEId3fPsytmv+ai+JZ6V+w?=
	=?iso-8859-15?Q?qjsFe7dtWGs+Yjw6N91IqIO2SbunovjGB0SjbB9k6rIrZyzXmJaN2msLx?=
	=?iso-8859-15?Q?WZEvzwxzrD9LVYEVSXzP7QwJhh/4/ofgngyDX0DfarKK8au8OpXMcCZB1?=
	=?iso-8859-15?Q?Wve780QzEYeDfPZAAmUreyVFPDCUmIQkRRw2EJ06FSNbIPITpeC12lsxV?=
	=?iso-8859-15?Q?S2KbrnbA2MA8F/Rr5ENs3GjQWu7c3LaAhqRXqxmimPyZXwQRYWL8s8LID?=
	=?iso-8859-15?Q?FakoHFNGcAhuPIM/p8GGvLh1MgXroNvlc9s313KnqwexacWrnyl/NkzDL?=
	=?iso-8859-15?Q?Cqqf4vf+WPTS99OWlrFdqsK4VWJrWHyDzuzdf9wxHIwsmUtSQsg28XYe9?=
	=?iso-8859-15?Q?WsSlKD9c9ru7R9EsgNuc2SWGYnueBsTuo0kJyQOAP1lGQNv9Hi5L8iJIB?=
	=?iso-8859-15?Q?CkLIjeryzLeADa/q5VGCXRWqHgeRyfDnrQgOfq2W7l9Z9gnRsL50g3h2Z?=
	=?iso-8859-15?Q?7YtSDexruPNs5IKyWTo8nLZQUJQNaJHA+XoMVWE5cXw31vCw5jZjRIb2R?=
	=?iso-8859-15?Q?69vuxxLws/15aOYr2SnoYTxdvFpfa60x+22MqfA08rTE8Sv+i6NIgJruE?=
	=?iso-8859-15?Q?2m0yKgUk5FNwa4ClBnHgqEcwIm/M/lxG1RQqDGYpVgLwgPgrFiDs48r85?=
	=?iso-8859-15?Q?gxqk+FOEkPRYv7XTSrcT3gLWZPrztLASw7CRPSP5ENEcyW8Zb/etWFfTe?=
	=?iso-8859-15?Q?aBsCqyuHSwMjpzm+U8OAX08u4EeLDXiEKpXUjgnKvk/YB6TbPyaA1jQDD?=
	=?iso-8859-15?Q?NFOQygD+0/84r1zrgOwboZ0LYR9yvPzjczm3Z9+C1mzc8itVY5s8XAw4e?=
	=?iso-8859-15?Q?OcDvHZubbi/zaQyjRIf7u8fLxd7abyk62kVkmyYkCsO98O5ECN/CBVhV/?=
	=?iso-8859-15?Q?OUMMCQS94r6bEK1fnJ70UDi1X/lAWb8sWpAu5Lz2htKmhR0S7a5bd8R8K?=
	=?iso-8859-15?Q?bn8QMbvPiT34SwC49s+zVq7devZJh7DeYURsFYDXpX9xfCx7DDMxEHZVn?=
	=?iso-8859-15?Q?UcEyXLK+Fe33G1iOMN2g2BgjjuapDSp72Vw2fLs6cIUmGsK/K6w2tla58?=
	=?iso-8859-15?Q?adTgtUNJM22HJZ5BxFZBrnY0BqwUlobC4KKUIcvG0ezBNuSgqplgT18JW?=
	=?iso-8859-15?Q?Mhvl700fYFB5+eJBL3d/RwrGjybK4F3Wr51r2TfEPQE7DViLYCenrO8/4?=
	=?iso-8859-15?Q?3XRcEvsAUdeVV/HIq0h13Ls893/rxpNeIavI3hSBNaOjR9zm9i3t/NvkP?=
	=?iso-8859-15?Q?NaseUGGYoHa3hUHYnLzohCeQx9KbMZV/eobPMlEqVhP2eW1FGkiKaNvmz?=
	=?iso-8859-15?Q?vt8AKiYokBoxfRq2EjRLwiTtPlQm7osx/zObxLks+xGNDPLZXTqMNm2P2?=
	=?iso-8859-15?Q?7LAgSbS4I+/jiM45Iv8PEkb5ev6koh6icrhpSJ77cUGE8VmK15UtMxFyR?=
	=?iso-8859-15?Q?1sdhPd22BRY278H4U+zKqSo+j5EDA369jYes3tSm7z2VBFQkuyehYJCRo?=
	=?iso-8859-15?Q?sstEifcgd9ShXB2bYo5N1QENEnJIdpF9a7uoERsKJAMDVyk0IClj8GxUZ?=
	=?iso-8859-15?Q?vWXYLBixkW/UhM2XyavV0ub+VNJvpwdseoqXPgxTZQa0FxU=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65783371-65bd-4ae7-738d-08d9e0a00868
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jan 2022 07:46:58.9208 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lgTv65OxZGD32AH13DQxxK3KyHZd7qgz48VEF5TXXakbCtNeLEtg9WnUzDScat/TyOKNwoJEbcdxhNwYmrW/ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR04MB9243
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 20Q7l9vU010819
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH] libmultipath: use asprintf() to allocate
	prefixed_uuid
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
Content-ID: <64A523C1C6C6924B9B7AFD99EC3ED041@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-01-25 at 23:35 -0600, Benjamin Marzinski wrote:
> gcc 12.0.1 failed building libmultipath due to a format-overflow
> false
> positive on 32-bit architectures.=A0 This isn't so surprising as
> format-overflow=3D2 is very aggressive in the assumptions it makes
> about
> the arguments.=A0 Here, it assumes that mpp->wwid could take up all the
> space that a pointer could point to, even if I add code to this
> function
> to explicitly null terminate mpp->wwid to fit in WWID_SIZE.

This sounds like a bug in gcc which should be reported.

>=20
> To avoid this and simplify the function, switch from using calloc()
> and
> sprintf() to just using asprintf().
>=20
> For reference, the gcc build error that this fixes is:
>=20
> devmapper.c: In function 'dm_addmap.constprop.0':
> devmapper.h:27:21: error: '%s' directive writing up to 2147483644
> bytes into a region of size 2147483641 [-Werror=3Dformat-overflow=3D]
> =A0=A0 27 | #define UUID_PREFIX "mpath-"
> =A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 ^~~~~~~~
> devmapper.c:484:53: note: format string is defined here
> =A0 484 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sprintf(prefixe=
d_uuid, UUID_PREFIX "%s", mpp-
> >wwid);
> =A0=A0=A0=A0=A0 |=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^~
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/devmapper.c | 5 +----
> =A01 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
> index 36038150..2507f77f 100644
> --- a/libmultipath/devmapper.c
> +++ b/libmultipath/devmapper.c
> @@ -473,14 +473,11 @@ dm_addmap (int task, const char *target, struct
> multipath *mpp,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_task_set_ro(dmt);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (task =3D=3D DM_DEVICE_CREATE) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0prefixed_uuid =3D calloc(1,=
 UUID_PREFIX_LEN +
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 strlen(mpp->wwid) + 1);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!prefixed_uuid) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (asprintf(&prefixed_uuid=
, UUID_PREFIX "%s", mpp-
> >wwid) < 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "cannot create prefixed uuid :
> %s",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0strerror(errno));
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto addout;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sprintf(prefixed_uuid, UUID=
_PREFIX "%s", mpp->wwid);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!dm_task_set_uuid(dmt=
, prefixed_uuid))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto freeout;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_task_skip_lockfs(dmt);


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

