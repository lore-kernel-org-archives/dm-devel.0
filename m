Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A238C433EF
	for <dm-devel@archiver.kernel.org>; Wed,  2 Feb 2022 15:33:08 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-376-SdpDHfF7MZ2DUKfMy2dC2Q-1; Wed, 02 Feb 2022 10:32:59 -0500
X-MC-Unique: SdpDHfF7MZ2DUKfMy2dC2Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38F5E83DD22;
	Wed,  2 Feb 2022 15:32:54 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EC75E1F2F7;
	Wed,  2 Feb 2022 15:32:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 666A64BB7C;
	Wed,  2 Feb 2022 15:32:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
	[10.11.54.10])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 212FW2v3015261 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 2 Feb 2022 10:32:02 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 74C65401E2B; Wed,  2 Feb 2022 15:32:02 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FA64401DAD
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 15:32:02 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4CE5E185A7BA
	for <dm-devel@redhat.com>; Wed,  2 Feb 2022 15:32:02 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-518-MI9RBNfwMcq-6kQVIOQdsg-1; Wed, 02 Feb 2022 10:32:00 -0500
X-MC-Unique: MI9RBNfwMcq-6kQVIOQdsg-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-40-1Qb8R1JiNher4Wt1WPIyxg-1; Wed, 02 Feb 2022 16:31:57 +0100
X-MC-Unique: 1Qb8R1JiNher4Wt1WPIyxg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM9PR04MB8338.eurprd04.prod.outlook.com (2603:10a6:20b:3ec::18)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.20;
	Wed, 2 Feb 2022 15:31:55 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.012;
	Wed, 2 Feb 2022 15:31:55 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>,
	"muneendra.kumar@broadcom.com" <muneendra.kumar@broadcom.com>
Thread-Topic: [PATCH v2] multipathd: handle fpin events
Thread-Index: AQHYEOg3mopANcC4Q0mGZwXkYi8O26yAcjIA
Date: Wed, 2 Feb 2022 15:31:54 +0000
Message-ID: <09831bccc70c0b093b9d7128f3d198bc73cec66a.camel@suse.com>
References: <20220123231325.21126-1-muneendra.kumar@broadcom.com>
In-Reply-To: <20220123231325.21126-1-muneendra.kumar@broadcom.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e4fd63a-9939-46b8-6cea-08d9e66124a5
x-ms-traffictypediagnostic: AM9PR04MB8338:EE_
x-microsoft-antispam-prvs: <AM9PR04MB83386BA3492052177CF55CB5FC279@AM9PR04MB8338.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:635
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: CK43lCw5yvf9Ir5xAQmn20A53q1bPaxN3D7cXNMBSUUthcbnWXEqsPjh3L+36HOtih1tP0cYBiAvxmWo9X5hnUK/7f5T3JfvjrUL5k1XoD8MOwuD5c/sBi+jVg2fVkr6k7S3PmA2rHaLdZWU121WNw7TDuGJ1Kd5dtEbnukcf/1ltA34MVKtGxQm37athWg20E375jdTYr2YfmDiZHcJdZbNg8RB5tHN6y/c8tvqkASlBJg0Z290Zpux6DxhOt+j68ZHE8MlctoGegU4tILfskpT3aurSpnGqdx7+a56YZI0Db0qa+gX6qei14N5iStIuH4wILRmc+psoF+lb5NTEqYeUFR9PNym3loDNAvTajYbv/YOqdI+DlBEBd1JyhWk0g4SpbuvWqVRoyQhyELsSrutKRAo54PAylWJfKEfgaPQiArL6D7zpKz24cR+gxkZybG7JOPNSg92K7mKnikepQ66lmumWv3N9xWXR3LrVphQQxkmaUb1f4w/GRbplUt248oIFI4QlfiqZ0ZzAdxTUPGz0PTBnoBHK9VCQ3Z11MlQyVis0keFFyZ6MbKguxV9qkABu64TGyj61B7A7EZV8l08dU6b+kQzDu4bH46Q+koufUsfzYsRnHqA/ijkIUx3X0W6oYriUj/4X1nxxi5keLzjIaoQZN84152EHiTLayBOV03b0OexiFeR5rz61kexwPqFITnIr9ibD6uDRst9gA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(71200400001)(8936002)(66446008)(6486002)(38100700002)(5660300002)(66476007)(6512007)(30864003)(76116006)(91956017)(64756008)(86362001)(36756003)(508600001)(6506007)(66946007)(4326008)(316002)(110136005)(54906003)(8676002)(66556008)(186003)(122000001)(83380400001)(38070700005)(2616005)(44832011)(2906002)(26005)(559001)(579004);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?YLGFEfO7tW29iKkatlIchoCSrFSX/O79UXGxL2gVphIUXFYcbC/4S1s3j?=
	=?iso-8859-15?Q?NtTnGEyu/xmu005Xz5UTaiXjS5m9bgdfnUGK+8s4K9eXbkwQt3eKihKGd?=
	=?iso-8859-15?Q?0fkvqpBX5sypdSw+0lVmPVptIly+R0NLJ9ZS4Ra/bHkO75B66BSxcO2qX?=
	=?iso-8859-15?Q?MXTcz2w/HhHYHAacoscaUy+w20KYdcDVa6izRQFfuchVKZMdsdXEx4+yI?=
	=?iso-8859-15?Q?2HSBwxhcrPKol/J/l90B8FAIhwVcHjZeFA0Bs2bfp7dpbV3KDqv3NyqlW?=
	=?iso-8859-15?Q?FN4R8JtvXDaFkq7s76YMhF5hk5yfza8E6ktMLqSzh7y2C1d3qnQLxE7VT?=
	=?iso-8859-15?Q?F8dnF9jv31+OVJ3ZKNg89t7wMC5mwdyZ7NS0RORN9Pk+MBZmYQto3J9Hq?=
	=?iso-8859-15?Q?nqJRCsJjqpgIMMiojgpb8aPhqu71TtVHl4uzMlEo+at1Og3YFfuepElmo?=
	=?iso-8859-15?Q?na7NCcNObUsEMKNstSzcRk1sjNBSFIKWya00R3nS2oeJg3pBUasCzvj6z?=
	=?iso-8859-15?Q?eEdsHX1rieMBYHrBmzZ1Emd3mlZE56cYiBV0/1sY5lUNdcMGl249lKyKB?=
	=?iso-8859-15?Q?tK+W1WTL2qxd0swwOYzOpJd/MV2h1fGaFTJeGrxy2//13QDjlJVonyul8?=
	=?iso-8859-15?Q?kN9wxuzCm4VIYLR04/jrAbPaO6LTBVPhXGDnPUjJUqy8IUc8bW2zrJWqW?=
	=?iso-8859-15?Q?E2HRzETtta4T/JC4lf8wFQSyXRXiyYZtYub7KDw88drF8qxMuUZRDRb0d?=
	=?iso-8859-15?Q?qkfy75sWrg9TlQXUf85CakjLaipTgt4cDBtIj4ZaMCOo7xvc+bebrima6?=
	=?iso-8859-15?Q?dHRaPk/0SkbxAAVlssZaZJie+9kfTEYIwdq+XLxHBnJ4tq1LAT06Jzmtq?=
	=?iso-8859-15?Q?wbtupnmseywrKf4QF5/t1a3RG0Z9rVUmjtsGyQ9EVr3oKefL4luLgZuV6?=
	=?iso-8859-15?Q?kJgtvrKJVM/a5Z/AZteI9ii5JxkHVABYrohvlxFWWCi0kyWLJyRy/f/qH?=
	=?iso-8859-15?Q?GkNfBKjl0ve1vTJH/N3rISrnfCGnGtDdP/hmwu1zNK/izh234a9PqWq6b?=
	=?iso-8859-15?Q?GdSxuaJxGKYii/oRty0FbTOIPoGivRFQ3uK/CQqp299UafnG3ngbw2b+M?=
	=?iso-8859-15?Q?7qXUp5pEJLvXxMD7TQe9Q0M50MD5AQPcarhprApp9EzCLvNuHuLcuyYZJ?=
	=?iso-8859-15?Q?Me/SmCPaDjJh11kr1R/vlZJP77N1aWJQNEEO7e9ZC/4yGUhxfkEJmrI9i?=
	=?iso-8859-15?Q?MkevRmuriFuva+NyhR/ncdRdx0JIwTjMXpfKbFcw1KdR5nYgnfVNB9m7G?=
	=?iso-8859-15?Q?PFMKGNexwaec5ReIb0AJNMruPYdlO2HGv/YqhIdGQ/HclqUwenHLeVDrY?=
	=?iso-8859-15?Q?Vu2fHq2taHKH3L7BUyZX3w0k8PdCrDKjKYMdg3aJojw36liq0VPyaIaSi?=
	=?iso-8859-15?Q?OsulTGIYC+KiBvhVP5Iu9aY9NkUkVoRiBV72T6kCvkqJSw/NBDT0ciXsK?=
	=?iso-8859-15?Q?/BZ8Ks4yDGmctkbkgAGPZJtAkel16huZPY/0VwHWieUV59nAlimmT6c+J?=
	=?iso-8859-15?Q?33bdqyn+68D5+aWOnmjaL+iwMj4DjH+c1BFw9sEwEkhUIdJaQxkxVnzIs?=
	=?iso-8859-15?Q?ya88CSy19DpX2Do4nSITMe1HAm/KDL4E8C0JBrr4M26EvDTjLd9jtk2si?=
	=?iso-8859-15?Q?j6XJXT5Ph3d9kZVzP+UY1fHZiBsF70KVbpqfAil6yVXUf7M=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e4fd63a-9939-46b8-6cea-08d9e66124a5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2022 15:31:54.9266 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HydfFEp0xE7MHwHTju9X0uLGt+Stt5omErpmrFlPucThe+GKO7fSfZ1dCl6jJKa2p/AEZ9o15xc5xfrlVSf32A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8338
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 212FW2v3015261
X-loop: dm-devel@redhat.com
Cc: "mkumar@redhat.com" <mkumar@redhat.com>
Subject: Re: [dm-devel] [PATCH v2] multipathd: handle fpin events
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <07C2866AF4AF50458B7BC6C26E1511C1@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello Muneendra,

On Sun, 2022-01-23 at 15:13 -0800, Muneendra Kumar wrote:
> This patch incorporates the functionality to handle
> FPIN ELS events present as part of FCTransport daemon
> (available in EPEL8) into the multipathd. This helps us to
> reduce the response time to react and take the necessary actions
> on receiving the FPIN events.
>=20
> This patch currently support FPIN-Li Events.
>=20
> It adds a new thread to listen for ELS frames from driver and on
> receiving the frame payload, push the payload to a list and notify
> the
> fpin_els_li_consumer thread to process it.Once consumer thread is
> notified, it returns to listen for more ELS frames from driver.
>=20
> The consumer thread process the ELS frames and moves the devices
> paths
> which are affected due to link integrity to marginal path groups.
> This also sets the associated portstate to marginal.
> The paths which are set to marginal path group will be unset
> on receiving the RSCN events
>=20
> Signed-off-by: Muneendra Kumar <muneendra.kumar@broadcom.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>=20
> Notes:
> =A0=A0=A0 V2:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Removed the newly added config option a=
nd added a new
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 value "fpin" to the marginal_pathgroups=
 option.
> =A0=A0=A0=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Added support to handle the multipathd =
reconfigure case.
> =A0=A0=A0=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Addressed the review comments from Mart=
in
>=20
> =A0Makefile.inc=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 |=A0 13 +
> =A0libmultipath/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 5 +
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 56 =
++-
> =A0libmultipath/libmultipath.version |=A0=A0 1 +
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 47 ++-
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=A0 7 +
> =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0=A0 |=A0 19 +-
> =A0multipathd/Makefile=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 10 =
+
> =A0multipathd/fpin.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=
 20 ++
> =A0multipathd/fpin_handlers.c=A0=A0=A0=A0=A0=A0=A0 | 547
> ++++++++++++++++++++++++++++++
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0=
 43 ++-
> =A011 files changed, 752 insertions(+), 16 deletions(-)
> =A0create mode 100644 multipathd/fpin.h
> =A0create mode 100644 multipathd/fpin_handlers.c
>=20


This looks good. I only have a few minor remarks, see below.

Martin

> +/*set/unset the path state to marginal*/
> +static int fpin_set_pathstate(struct path *pp, bool set)
> +{
> +=A0=A0=A0=A0=A0=A0=A0const char *action =3D set ? "set" : "unset";
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!pp || !pp->mpp || !pp->mpp->alias)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -1;
> +
> +=A0=A0=A0=A0=A0=A0=A0condlog(3, "\n%s: %s=A0 marginal path %s (fpin)",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0action, pp->mpp->alias, pp-=
>dev_t);
> +=A0=A0=A0=A0=A0=A0=A0if (set)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->marginal =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->marginal =3D 0;

Nitpick: pp->marginal =3D set ?

> +
> +=A0=A0=A0=A0=A0=A0=A0pp->mpp->fpin_must_reload =3D true;
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +
> +}
> +
> +/* This will unset marginal state of a device*/
> +static void fpin_path_unsetmarginal(char *devname, struct vectors
> *vecs)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> +
> +=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_dev(vecs->pathvec, devname);
> +=A0=A0=A0=A0=A0=A0=A0if (!pp)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_devt(ve=
cs->pathvec, devname);
> +
> +=A0=A0=A0=A0=A0=A0=A0fpin_set_pathstate(pp, 0);

Nitpick: as you use bool for "set", you should be using "false" and
"true" when calling it.

> +}
> +
> +/*This will set the marginal state of a device*/
> +static int fpin_path_setmarginal(struct path *pp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return fpin_set_pathstate(pp, 1);
> +}
> +
> +/* Unsets all the devices in the list from marginal state */
> +static void
> +fpin_unset_marginal_dev(uint32_t host_num, struct vectors *vecs)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list *tmp_marg =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct list_head *current_node =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct list_head *temp =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct multipath *mpp;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0int i;
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li_marginal_dev_mutex);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_mutex,
> &fpin_li_marginal_dev_mutex);
> +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> +=A0=A0=A0=A0=A0=A0=A0if (list_empty(&fpin_li_marginal_dev_list_head)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "Marginal List i=
s empty\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto empty;
> +=A0=A0=A0=A0=A0=A0=A0}

I don't think you need this. list_for_each_safe will be (almost) a noop
in this case. Also, no need to log at level 3. that you aren't doing
anything. Use level 4.

> +=A0=A0=A0=A0=A0=A0=A0list_for_each_safe(current_node, temp,
> &fpin_li_marginal_dev_list_head) {

why not use list_for_each_entry_safe() here?

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0tmp_marg =3D list_entry(cur=
rent_node,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0node);
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (tmp_marg->host_num !=3D=
 host_num)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, " unsetting marg=
inal dev: is %s %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0tmp_marg->dev_t, tmp_marg->host_num);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpin_path_unsetmarginal(tmp=
_marg->dev_t, vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_del(current_node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(tmp_marg);
> +=A0=A0=A0=A0=A0=A0=A0}
> +empty:
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot_backwards(vecs->mpvec, mpp, i) =
{

Any special reason why you walk the vector backwards?

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->fpin_must_reload) =
{
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
 =3D reload_and_sync_map(mpp, vecs, 0);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(ret =3D=3D 2)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(2, "map removed during
> reload");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
e
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0mpp->fpin_must_reload =3D false;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +}
> +
> +/*
> + * On Receiving the frame from HBA driver, insert the frame into
> link
> + * integrity frame list which will be picked up later by consumer
> thread for
> + * processing.
> + */
> +static int
> +fpin_els_add_li_frame(struct fc_nl_event *fc_event)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct els_marginal_list *els_mrg =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (fc_event->event_datalen > FC_PAYLOAD_MAXLEN)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -EINVAL;
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li_mutex);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_mutex, &fpin_li_mutex)=
;
> +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> +=A0=A0=A0=A0=A0=A0=A0els_mrg =3D calloc(sizeof(struct els_marginal_list)=
, 1);

It doesn't matter much, but the struct size is the 2nd arg to calloc.
I recommend "calloc(1, sizeof(*els_mrg))"

> +=A0=A0=A0=A0=A0=A0=A0if (els_mrg !=3D NULL) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_mrg->host_num =3D fc_ev=
ent->host_no;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_mrg->event_code =3D fc_=
event->event_code;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_mrg->length =3D fc_even=
t->event_datalen;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0memcpy(els_mrg->payload, &(=
fc_event->event_data),
> fc_event->event_datalen);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_add_tail(&els_mrg->nod=
e,
> &els_marginal_list_head);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cond_signal(&fpin_l=
i_cond);
> +=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D -ENOMEM;
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0return ret;
> +
> +}
> +
> +/*Sets the rport port_state to marginal*/
> +static void fpin_set_rport_marginal(struct udev_device *rport_dev)
> +{
> +=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(rport_dev, "port_state",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0"Marginal", strlen("Marginal"));
> +}
> +
> +/*Add the marginal devices info into the list*/
> +static void
> +fpin_add_marginal_dev_info(uint32_t host_num, char *devname)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list *newdev =3D NULL;
> +
> +=A0=A0=A0=A0=A0=A0=A0newdev =3D (struct marginal_dev_list *) calloc(1,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0siz=
eof(struct marginal_dev_list));

Nitpick: No need to cast here. Without the cast, the code fits on one
line ;-)

> +=A0=A0=A0=A0=A0=A0=A0if (newdev !=3D NULL) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0newdev->host_num =3D host_n=
um;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strlcpy(newdev->dev_t, devn=
ame, BLK_DEV_SIZE);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "\n%s hostno %d =
devname %s\n", __func__,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0host_num, newdev->dev_t);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li=
_marginal_dev_mutex);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_add_tail(&(newdev->nod=
e),
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0&fpin_li_marginal_dev_list_head);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&fpin_=
li_marginal_dev_mutex);
> +=A0=A0=A0=A0=A0=A0=A0}
> +}
> +
> +/*
> + * This function goes through the vecs->pathvec, and for
> + * each path, check that the host=A0 number,
> + * the target WWPN associated with the path matches
> + * with the els wwpn and sets the path and port state to
> + * Marginal
> + */
> +static int=A0 fpin_chk_wwn_setpath_marginal(uint16_t host_num,=A0 struct
> vectors *vecs,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uint64_t els_wwpn)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> +=A0=A0=A0=A0=A0=A0=A0struct multipath *mpp;
> +=A0=A0=A0=A0=A0=A0=A0int i, k;
> +=A0=A0=A0=A0=A0=A0=A0char rport_id[42];
> +=A0=A0=A0=A0=A0=A0=A0const char *value =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct udev_device *rport_dev =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0uint64_t wwpn;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_lock, &vecs->lock);
> +=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> +=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(vecs->pathvec, pp, k) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Checks the host number a=
nd also for the SCSI FCP
> */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pp->sg_id.proto_id !=3D=
 SCSI_PROTOCOL_FCP ||
> host_num !=3D=A0 pp->sg_id.host_no)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sprintf(rport_id, "rport-%d=
:%d-%d",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0pp->sg_id.host_no, pp->sg_id.channel,
> pp->sg_id.transport_id);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rport_dev =3D
> udev_device_new_from_subsystem_sysname(udev,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0"fc_remote_ports", rport_id);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!rport_dev) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(2, "%s: No fc_remote_port device for
> '%s'", pp->dev,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0rport_id);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(_udev_=
device_unref, rport_dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0value =3D udev_device_get_s=
ysattr_value(rport_dev,
> "port_name");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!value)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o unref;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (value)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0wwp=
n =3D=A0 strtol(value, NULL, 16);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * If the port wwpn matches=
 sets the path and port
> state
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * to marginal
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (wwpn =3D=3D els_wwpn) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
 =3D fpin_path_setmarginal(pp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(ret < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0goto unref;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpi=
n_set_rport_marginal(rport_dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpi=
n_add_marginal_dev_info(host_num, pp-
> >dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +unref:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot_backwards(vecs->mpvec, mpp, i) =
{

Again, why backwards?

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->fpin_must_reload) =
{
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
 =3D reload_and_sync_map(mpp, vecs, 0);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(ret =3D=3D 2)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(2, "map removed during
> reload");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
e
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0mpp->fpin_must_reload =3D false;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0return ret;
> +}
> +
> +/*
> + * This function loops around all the impacted wwns received as part
> of els
> + * frame and sets the associated path and port states to marginal.
> + */
> +static int
> +fpin_parse_li_els_setpath_marginal(uint16_t host_num, struct
> fc_tlv_desc *tlv,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0struct vectors *vecs)
> +{
> +=A0=A0=A0=A0=A0=A0=A0uint32_t wwn_count =3D 0, iter =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0uint64_t wwpn;
> +=A0=A0=A0=A0=A0=A0=A0struct fc_fn_li_desc *li_desc =3D (struct fc_fn_li_=
desc *)tlv;
> +=A0=A0=A0=A0=A0=A0=A0int count =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0/* Update the wwn to list */
> +=A0=A0=A0=A0=A0=A0=A0wwn_count =3D be32_to_cpu(li_desc->pname_count);
> +=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got wwn count as %d\n", wwn_count);
> +
> +=A0=A0=A0=A0=A0=A0=A0for (iter =3D 0; iter < wwn_count; iter++) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0wwpn =3D be64_to_cpu(li_des=
c->pname_list[iter]);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D fpin_chk_wwn_setpat=
h_marginal(host_num, vecs,
> wwpn);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (ret < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(2, "failed to set the path marginal
> associated with wwpn: 0x%lx\n", wwpn);
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0count++;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return count;
> +}
> +
> +/*
> + * This function process the ELS frame received from HBA driver,
> + * and sets the path associated with the port wwn to marginal
> + * and also set the port state to marginal.
> + */
> +static int
> +fpin_process_els_frame(uint16_t host_num, char *fc_payload, struct
> vectors *vecs)
> +{
> +
> +=A0=A0=A0=A0=A0=A0=A0int count =3D -1;
> +=A0=A0=A0=A0=A0=A0=A0struct fc_els_fpin *fpin =3D (struct fc_els_fpin *)=
fc_payload;
> +=A0=A0=A0=A0=A0=A0=A0struct fc_tlv_desc *tlv;
> +
> +=A0=A0=A0=A0=A0=A0=A0tlv =3D (struct fc_tlv_desc *)&fpin->fpin_desc[0];
> +
> +=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0 * Parse the els frame and set the affected paths a=
nd port
> +=A0=A0=A0=A0=A0=A0=A0 * state to marginal
> +=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0count =3D fpin_parse_li_els_setpath_marginal(host_n=
um, tlv,
> vecs);
> +=A0=A0=A0=A0=A0=A0=A0if (count <=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Could not find =
any WWNs, ret =3D %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0count);
> +=A0=A0=A0=A0=A0=A0=A0return count;
> +}
> +
> +/*
> + * This function process the FPIN ELS frame received from HBA
> driver,
> + * and push the frame to appropriate frame list. Currently we have
> only FPIN
> + * LI frame list.
> + */
> +static int
> +fpin_handle_els_frame(struct fc_nl_event *fc_event)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D -1;
> +=A0=A0=A0=A0=A0=A0=A0uint32_t els_cmd;
> +=A0=A0=A0=A0=A0=A0=A0struct fc_els_fpin *fpin =3D (struct fc_els_fpin *)=
&fc_event-
> >event_data;
> +=A0=A0=A0=A0=A0=A0=A0struct fc_tlv_desc *tlv;
> +=A0=A0=A0=A0=A0=A0=A0uint32_t dtag;
> +
> +=A0=A0=A0=A0=A0=A0=A0els_cmd =3D (uint32_t)fc_event->event_data;
> +=A0=A0=A0=A0=A0=A0=A0tlv =3D (struct fc_tlv_desc *)&fpin->fpin_desc[0];
> +=A0=A0=A0=A0=A0=A0=A0dtag =3D be32_to_cpu(tlv->desc_tag);
> +=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got CMD in add as 0x%x fpin_cmd 0x%x dt=
ag
> 0x%x\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
_cmd, fpin->fpin_cmd, dtag);
> +
> +=A0=A0=A0=A0=A0=A0=A0if ((fc_event->event_code =3D=3D FCH_EVT_LINK_FPIN)=
 ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(fc=
_event->event_code =3D=3D FCH_EVT_LINKUP) ||
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(fc=
_event->event_code =3D=3D FCH_EVT_RSCN)) {
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (els_cmd =3D=3D ELS_FPIN=
) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
Check the type of fpin by checking the tag
> info
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
At present we are supporting only LI
> events
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(dtag =3D=3D ELS_DTAG_LNK_INTEGRITY) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0/*Push the Payload to FPIN frame
> queue. */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0ret =3D
> fpin_els_add_li_frame(fc_event);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (ret !=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "Failed to process
> LI frame with error %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} e=
lse {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(4, "Unsupported FPIN received
> 0x%x\n", dtag);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0return ret;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*P=
ush the Payload to FPIN frame queue. */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
 =3D fpin_els_add_li_frame(fc_event);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(ret !=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0condlog(0, "Failed to process
> Linkup/RSCN event with error %d evnt %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret, f=
c_event-
> >event_code);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Invalid command=
 received: 0x%x\n",
> els_cmd);
> +=A0=A0=A0=A0=A0=A0=A0return ret;
> +}
> +
> +/*cleans the global marginal dev list*/
> +void fpin_clean_marginal_dev_list(__attribute__((unused)) void *arg)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list *tmp_marg =3D NULL;
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li_marginal_dev_mutex);
> +=A0=A0=A0=A0=A0=A0=A0while (!list_empty(&fpin_li_marginal_dev_list_head)=
) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0tmp_marg=A0 =3D
> list_first_entry(&fpin_li_marginal_dev_list_head,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0struct marginal_dev_list, node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_del(&tmp_marg->node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(tmp_marg);
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&fpin_li_marginal_dev_mutex);
> +}
> +
> +/* Cleans the global els=A0 marginal list */
> +static void fpin_clean_els_marginal_list(void *arg)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct list_head *head =3D (struct list_head *)arg;
> +=A0=A0=A0=A0=A0=A0=A0struct els_marginal_list *els_marg;
> +
> +=A0=A0=A0=A0=A0=A0=A0while (!list_empty(head)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_marg=A0 =3D list_first_=
entry(head, struct
> els_marginal_list,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0list_del(&els_marg->node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(els_marg);
> +=A0=A0=A0=A0=A0=A0=A0}
> +}
> +
> +static void rcu_unregister(__attribute__((unused)) void *param)
> +{
> +=A0=A0=A0=A0=A0=A0=A0rcu_unregister_thread();
> +}
> +/*
> + * This is the FPIN ELS consumer thread. The thread sleeps on
> pthread cond
> + * variable unless notified by fpin_fabric_notification_receiver
> thread.
> + * This thread is only to process FPIN-LI ELS frames. A new thread
> and frame
> + * list will be added if any more ELS frames types are to be
> supported.
> + */
> +void *fpin_els_li_consumer(void *data)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct list_head marginal_list_head;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0uint16_t host_num;
> +=A0=A0=A0=A0=A0=A0=A0struct els_marginal_list *els_marg;
> +=A0=A0=A0=A0=A0=A0=A0uint32_t event_code;
> +=A0=A0=A0=A0=A0=A0=A0struct vectors *vecs =3D (struct vectors *)data;
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(rcu_unregister, NULL);
> +=A0=A0=A0=A0=A0=A0=A0rcu_register_thread();
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(fpin_clean_marginal_dev_list, =
NULL);
> +=A0=A0=A0=A0=A0=A0=A0INIT_LIST_HEAD(&marginal_list_head);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(fpin_clean_els_marginal_list,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0(void *)&marginal_list_head);
> +=A0=A0=A0=A0=A0=A0=A0for ( ; ; ) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li=
_mutex);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanu=
p_mutex, &fpin_li_mutex);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (list_empty(&els_margina=
l_list_head))

It is safer to use while (list_empty(...)) here, in case the wait is
interrupted somehow.

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pth=
read_cond_wait(&fpin_li_cond,
> &fpin_li_mutex);
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!list_empty(&els_margin=
al_list_head)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(4, "Invoke List splice tail\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lis=
t_splice_tail_init(&els_marginal_list_head
> , &marginal_list_head);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0while (!list_empty(&margina=
l_list_head)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
_marg=A0 =3D
> list_first_entry(&marginal_list_head,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0struct
> els_marginal_list, node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0hos=
t_num =3D els_marg->host_num;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0eve=
nt_code =3D els_marg->event_code;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
Now finally process FPIN LI ELS Frame */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(4, "Got a new Payload buffer,
> processing it\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
((event_code =3D=3D=A0 FCH_EVT_LINKUP) ||
> (event_code =3D=3D FCH_EVT_RSCN))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 fpin_unset_marginal_dev(host_num,
> vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els=
e {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0ret =3D
> fpin_process_els_frame(host_num, els_marg->payload, vecs);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (ret <=3D 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "ELS frame
> processing failed with ret %d\n", ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lis=
t_del(&els_marg->node);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fre=
e(els_marg);
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0return NULL;
> +}
> +
> +static void receiver_cleanup_list(__attribute__((unused)) void *arg)
> +{
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&fpin_li_mutex);
> +=A0=A0=A0=A0=A0=A0=A0fpin_clean_els_marginal_list(&els_marginal_list_hea=
d);
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&fpin_li_mutex);
> +}
> +
> +/*
> + * Listen for ELS frames from driver. on receiving the frame
> payload,
> + * push the payload to a list, and notify the fpin_els_li_consumer
> thread to
> + * process it. Once consumer thread is notified, return to listen
> for more ELS
> + * frames from driver.
> + */
> +void *fpin_fabric_notification_receiver(__attribute__((unused))void
> *unused)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int ret;
> +=A0=A0=A0=A0=A0=A0=A0long fd;
> +=A0=A0=A0=A0=A0=A0=A0uint32_t els_cmd;
> +=A0=A0=A0=A0=A0=A0=A0struct fc_nl_event *fc_event =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0struct sockaddr_nl fc_local;
> +=A0=A0=A0=A0=A0=A0=A0unsigned char buf[DEF_RX_BUF_SIZE]
> __attribute__((aligned(sizeof(uint64_t))));
> +=A0=A0=A0=A0=A0=A0=A0size_t plen =3D 0;
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(rcu_unregister, NULL);
> +=A0=A0=A0=A0=A0=A0=A0rcu_register_thread();
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(receiver_cleanup_list, NULL);
> +=A0=A0=A0=A0=A0=A0=A0fd =3D socket(PF_NETLINK, SOCK_DGRAM, NETLINK_SCSIT=
RANSPORT);
> +=A0=A0=A0=A0=A0=A0=A0if (fd < 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "fc socket error=
 %ld", fd);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(close_fd, (void *)fd);
> +=A0=A0=A0=A0=A0=A0=A0memset(&fc_local, 0, sizeof(fc_local));
> +=A0=A0=A0=A0=A0=A0=A0fc_local.nl_family =3D AF_NETLINK;
> +=A0=A0=A0=A0=A0=A0=A0fc_local.nl_groups =3D ~0;
> +=A0=A0=A0=A0=A0=A0=A0fc_local.nl_pid =3D getpid();
> +=A0=A0=A0=A0=A0=A0=A0ret =3D bind(fd, (struct sockaddr *)&fc_local,
> sizeof(fc_local));
> +=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D -1) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "fc socket bind =
error %d\n", ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0for ( ; ; ) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Waiting for ELS=
...\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D read(fd, buf, DEF_R=
X_BUF_SIZE);

You should check the return value of read().

> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got a new reque=
st %d\n", ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!NLMSG_OK((struct nlmsg=
hdr *)buf, ret)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "bad els frame read (%d)", ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Push the frame to approp=
riate frame list */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0plen =3D NLMSG_PAYLOAD((str=
uct nlmsghdr *)buf, 0);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fc_event =3D (struct fc_nl_=
event *)NLMSG_DATA(buf);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (plen < sizeof(*fc_event=
)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "too short (%d) to be an FC
> event", ret);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0els_cmd =3D (uint32_t)fc_ev=
ent->event_data;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(4, "Got host no as =
%d, event 0x%x, len %d
> evntnum %d evntcode %d\n",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0fc_event->host_no, els_cmd, fc_event-
> >event_datalen,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0fc_event->event_num, fc_event-
> >event_code);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpin_handle_els_frame(fc_ev=
ent);
> +=A0=A0=A0=A0=A0=A0=A0}
> +out:
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0return NULL;
> +}
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 44ca5b12..6bc5178d 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -16,6 +16,7 @@
> =A0#include <linux/oom.h>
> =A0#include <libudev.h>
> =A0#include <urcu.h>
> +#include "fpin.h"
> =A0#ifdef USE_SYSTEMD
> =A0#include <systemd/sd-daemon.h>
> =A0#endif
> @@ -132,9 +133,11 @@ static bool __delayed_reconfig;
> =A0pid_t daemon_pid;
> =A0static pthread_mutex_t config_lock =3D PTHREAD_MUTEX_INITIALIZER;
> =A0static pthread_cond_t config_cond;
> -static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr,
> dmevent_thr;
> +static pthread_t check_thr, uevent_thr, uxlsnr_thr, uevq_thr,
> dmevent_thr,
> +=A0=A0=A0=A0=A0=A0=A0fpin_thr, fpin_consumer_thr;
> =A0static bool check_thr_started, uevent_thr_started,
> uxlsnr_thr_started,
> -=A0=A0=A0=A0=A0=A0=A0uevq_thr_started, dmevent_thr_started;
> +=A0=A0=A0=A0=A0=A0=A0uevq_thr_started, dmevent_thr_started, fpin_thr_sta=
rted,
> +=A0=A0=A0=A0=A0=A0=A0fpin_consumer_thr_started;
> =A0static int pid_fd =3D -1;
> =A0
> =A0static inline enum daemon_status get_running_state(void)
> @@ -2879,7 +2882,9 @@ reconfigure (struct vectors * vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0conf->sequence_nr =3D old->sequence_nr + 1;
> =A0=A0=A0=A0=A0=A0=A0=A0rcu_assign_pointer(multipath_conf, conf);
> =A0=A0=A0=A0=A0=A0=A0=A0call_rcu(&old->rcu, rcu_free_config);
> -
> +#ifdef FPIN_EVENT_HANDLER
> +=A0=A0=A0=A0=A0=A0=A0fpin_clean_marginal_dev_list(NULL);
> +#endif
> =A0=A0=A0=A0=A0=A0=A0=A0configure(vecs);
> =A0
> =A0
> @@ -3098,6 +3103,11 @@ static void cleanup_threads(void)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(uevq_thr);
> =A0=A0=A0=A0=A0=A0=A0=A0if (dmevent_thr_started)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(dmevent_th=
r);
> +=A0=A0=A0=A0=A0=A0=A0if (fpin_thr_started)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(fpin_thr);
> +=A0=A0=A0=A0=A0=A0=A0if (fpin_consumer_thr_started)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(fpin_consume=
r_thr);
> +
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (check_thr_started)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(check_thr, N=
ULL);
> @@ -3109,6 +3119,11 @@ static void cleanup_threads(void)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(uevq_thr, NU=
LL);
> =A0=A0=A0=A0=A0=A0=A0=A0if (dmevent_thr_started)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(dmevent_thr,=
 NULL);
> +=A0=A0=A0=A0=A0=A0=A0if (fpin_thr_started)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(fpin_thr, NULL=
);
> +=A0=A0=A0=A0=A0=A0=A0if (fpin_consumer_thr_started)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_join(fpin_consumer_=
thr, NULL);
> +
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * As all threads are joined now, and we're in
> DAEMON_SHUTDOWN
> @@ -3202,6 +3217,7 @@ child (__attribute__((unused)) void *param)
> =A0=A0=A0=A0=A0=A0=A0=A0char *envp;
> =A0=A0=A0=A0=A0=A0=A0=A0enum daemon_status state;
> =A0=A0=A0=A0=A0=A0=A0=A0int exit_code =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0int fpin_marginal_paths =3D 0;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0init_unwinder();
> =A0=A0=A0=A0=A0=A0=A0=A0mlockall(MCL_CURRENT | MCL_FUTURE);
> @@ -3280,7 +3296,10 @@ child (__attribute__((unused)) void *param)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0setscheduler();
> =A0=A0=A0=A0=A0=A0=A0=A0set_oom_adj();
> -
> +#ifdef FPIN_EVENT_HANDLER
> +=A0=A0=A0=A0=A0=A0=A0if (conf->marginal_pathgroups =3D=3D MARGINAL_PATHG=
ROUP_FPIN)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpin_marginal_paths =3D 1;
> +#endif
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * Startup done, invalidate configuration
> =A0=A0=A0=A0=A0=A0=A0=A0 */
> @@ -3348,6 +3367,22 @@ child (__attribute__((unused)) void *param)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto failed;
> =A0=A0=A0=A0=A0=A0=A0=A0} else
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0uevq_thr_started =3D true=
;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (fpin_marginal_paths) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D pthread_create(=
&fpin_thr, &misc_attr,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpi=
n_fabric_notification_receiver, NULL))) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "failed to create the fpin
> receiver thread: %d", rc);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o failed;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpi=
n_thr_started =3D true;
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D pthread_create(=
&fpin_consumer_thr,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&mi=
sc_attr, fpin_els_li_consumer, vecs))) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "failed to create the fpin
> consumer thread thread: %d", rc);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0got=
o failed;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fpi=
n_consumer_thr_started =3D true;
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_attr_destroy(&misc_attr);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0while (1) {




--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

