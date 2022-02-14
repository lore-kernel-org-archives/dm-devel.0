Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A015C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 14 Feb 2022 19:19:29 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-336-UmPKtr4BNdmkJhRUTQAcIQ-1; Mon, 14 Feb 2022 14:19:24 -0500
X-MC-Unique: UmPKtr4BNdmkJhRUTQAcIQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 862EE814243;
	Mon, 14 Feb 2022 19:19:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9747B196F2;
	Mon, 14 Feb 2022 19:19:19 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id E99881806D03;
	Mon, 14 Feb 2022 19:19:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
	[10.11.54.8])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 21EJJG4B009584 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 14 Feb 2022 14:19:16 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id E3208C4C7A5; Mon, 14 Feb 2022 19:19:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DE32DC4C7A0
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 19:19:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C02DC106655E
	for <dm-devel@redhat.com>; Mon, 14 Feb 2022 19:19:15 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.111.102]) by
	relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-265-e8plKqflMAuvnzs6Ry6uIw-1; Mon, 14 Feb 2022 14:19:14 -0500
X-MC-Unique: e8plKqflMAuvnzs6Ry6uIw-1
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur05lp2169.outbound.protection.outlook.com [104.47.17.169])
	by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	de-mta-26-preACGe9NcKDeSzgnNR7xA-1; Mon, 14 Feb 2022 20:19:11 +0100
X-MC-Unique: preACGe9NcKDeSzgnNR7xA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by AM0PR04MB6515.eurprd04.prod.outlook.com (2603:10a6:208:16f::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19;
	Mon, 14 Feb 2022 19:19:10 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::4081:2960:b740:3d47%3]) with mapi id 15.20.4951.019;
	Mon, 14 Feb 2022 19:19:09 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "dm-devel@redhat.com" <dm-devel@redhat.com>, "maier@linux.ibm.com"
	<maier@linux.ibm.com>, "christophe.varoqui@opensvc.com"
	<christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 1/2] libmultipath: support host adapter name lookup
	for s390x ccw bus
Thread-Index: AQHYIdSXlneEaAZ3oESYoO1IvMaoxKyTa9KA
Date: Mon, 14 Feb 2022 19:19:09 +0000
Message-ID: <f122514cab837e0e613a105c90335a91f60a72d0.camel@suse.com>
References: <20220214185559.28363-1-maier@linux.ibm.com>
	<20220214185559.28363-2-maier@linux.ibm.com>
In-Reply-To: <20220214185559.28363-2-maier@linux.ibm.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.3
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4499aee-742d-462a-443f-08d9efeee0a2
x-ms-traffictypediagnostic: AM0PR04MB6515:EE_
x-microsoft-antispam-prvs: <AM0PR04MB651598D0CE5AB72B192769FEFC339@AM0PR04MB6515.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 6oKcuD8sszc2oikQLljBUtuDF5/YM8EqME/sINlkRER3nqycC/iD2MiseDOZ5mpWj1nNB4UQs6HiWBqtgjplpVMwZso6vIBSc2Jk+TAHIch7SrQ3XbgeADISjGPcypXtMhzZ0S+dKiwoCqUCSNkrMItfi9wia7a/cV52PwVwynsgmbg7MYop9g4Ak9RvSJS6rRBhKz5e1sxYgQchHaX2tqEINwNew7SA7X6HrPctsV58k90Xn9DPLM5DYtVVZIz9c5C1MCfhMQybBCvW1a5nrKsL+7V31Yg6G03yPBCoroIClzgAF1L1zGuPyoF9FxCs8ArX9VY/nl6o7wuwnDW6zpK3csLLiutSCiJ4MsZLMzhA0DJjbo61xD89SuY7WLp8laOP/i68FCdOIhtsj2QxG3owiQiluMP9NuNzmINFC/ht935gcddF2sxXRrjoyCgbRC8QA7eqWa9Xv4NmLx5jcgfQpT357exXGm4ynxfFwbA7xCrEXgsWSAZr8FWQokVv3J63HzF2rcTqCSgNkVcc6lDa7FF5AmInSBlNMHt1D16y4UY9/t3ufsbaJter9vHYa6NrKFRGvsp0j3fyVjPFvndNlGZC2MFX1dL5mmDHxpTZByTJOyXyfMM6nP7fKAem51iHQs3eP3i3VB/iRRrdFBAbx+QgrrgUVinmAtObZ3c9Pjvii425iDCwZvBQgmM3lCCZmoIskZ1FLlAlDUHqrg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(13230001)(366004)(6506007)(71200400001)(83380400001)(186003)(2906002)(36756003)(2616005)(6512007)(8936002)(38100700002)(44832011)(86362001)(5660300002)(54906003)(110136005)(6486002)(122000001)(76116006)(66946007)(66556008)(66476007)(64756008)(508600001)(66446008)(38070700005)(26005)(91956017)(8676002)(4326008)(316002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?NyXyhHfFBcGb8acck5ew/7mupUYOvrFw1xHkFqxZXHPOjGfr2Y1cZa2PX?=
	=?iso-8859-15?Q?YVNSgYa8P3Z1ZXQZe9A4AH2g9NvoHadKNlNRZUGCbIgIlsJuaDStOAJ3k?=
	=?iso-8859-15?Q?QpPeWrJraqbmrrbpG5gSpZ8F/r/zQBVtm6f3zcXzbECl+XrA9/zMP4uCT?=
	=?iso-8859-15?Q?bH+58k0fcnlcdnfPqlVWSHfuTnawAtex3FPwuYKWuBoICRiLcbSepYqWu?=
	=?iso-8859-15?Q?qLQ3N3zjk0B3fRCZB//5t34P5vFq2U3I6siUgN/C50pR/Ch7xxDC1dhU1?=
	=?iso-8859-15?Q?2BwpdE+LOtL6uPCcGgTk3dbzlVJhhf9ByUBdS/wcSfset/17GCID1Xmaa?=
	=?iso-8859-15?Q?wlh9y1lC2NoTFrJ79amYVGvH0BK/2oY8S5oO+Wmt74t/m/AKcg5VeB6KF?=
	=?iso-8859-15?Q?Ez5J2vBpCVlUhmUydJaRBvslVylwn01VF7wjJ2o5+biPEhjhlzUB8tCWM?=
	=?iso-8859-15?Q?6l4i+U7ZWVHo2w8/g2uZjM+6YQKRr3TIBL5GF+Ws8b/RpHH5VILdtw2xH?=
	=?iso-8859-15?Q?nQIPwIkuWFvdlv2w2Z2hgs4uy2QLcpZPEbTMiFjDFWRd/hKxK0n2dW2es?=
	=?iso-8859-15?Q?z/tg93Y3wHS/9RNIAAYhx2avo4tcYA0E6W6P/Xi1/lkTPmPwRDQnnRRFF?=
	=?iso-8859-15?Q?AOXYfbNsP3X/6x1r8aLSYLU2u4mNA1Or1gGGHNKgMtKv7xBK+BEN0vHuN?=
	=?iso-8859-15?Q?Ht775mZcP11+8Rv6aRHDsnUClQHKZzcu1ZRmYm/qWpgRa6LlgIOCWFez8?=
	=?iso-8859-15?Q?lHD5vFP26Q5yLxK80MKN0dq83ESnKZQn7x7579UDYkfSrdJnk/94QSfOx?=
	=?iso-8859-15?Q?5o8/Uqf7N+0uAAeKdHqG0lleiYn3JukIMR5eKVE4W7axxEUYK/TlM+Iep?=
	=?iso-8859-15?Q?GaELhYbRd3w2U5RElznXGCD+/HcLaC+bgD+OWHcY2UsUp6NHvJYARtI/M?=
	=?iso-8859-15?Q?MtAQpfm6Rs+cxqYcIFo5XXmEEbPoeeeJed4Ik/T5dt4j+/+vaoE+cCapZ?=
	=?iso-8859-15?Q?B2qz7MF4NaLcJCASAu2dLeRZPMFWLSYmDTKgiTKdo+0xgHuPsNgn1R4Xl?=
	=?iso-8859-15?Q?/H5Ts68NoHuydYolapm0Gu6MTRlif2kWMN+AF3qRwjOu9yODCBWx0YTNF?=
	=?iso-8859-15?Q?9DKvemKLG11qeuffVrcEJjARewDoZEz+7Qo5m08z4nJK0uBJk1HvY4tTr?=
	=?iso-8859-15?Q?aG9QzJnRtlAgLvlmr3afoo7zE3/rfXzfz6szXeBl4GVbLNbKafoplnrpQ?=
	=?iso-8859-15?Q?K2rC21fSSXuK2UKUwEC2fsYZJkgVQkncsfmFiV2aTQixImB5bFrAamI8l?=
	=?iso-8859-15?Q?RHntbrgjjRBzMq1FZwdIDky3i093aZ8rUK8npZa2zXoZloBdi1kDaT16q?=
	=?iso-8859-15?Q?HfEcZgE+sW0Gh9GaS3YqHr+zKHo2nkHWSrN9iVCaCZxUQrGWwQD9TItzn?=
	=?iso-8859-15?Q?X/mC9yagrZVipNrztzOTEh/X+a1OmkfL1+3JgUb8TC7E5N9yCqtADX615?=
	=?iso-8859-15?Q?81KFco5eJpIzmnO1RShE8Qj9mCEpJXfcrKVHQ3TTMca2jqXkdM/Y8SVwu?=
	=?iso-8859-15?Q?Dq887SqKlOHHXDtcwUZ2Pcfrf8iAodUujlleZqv7HWx85Q1rciI+3tp91?=
	=?iso-8859-15?Q?qshesGmWvAdsejGYEab8Js49bhje+SeKqOmLsAYWiuAPDizjcEK1nfj+s?=
	=?iso-8859-15?Q?NkVpmK7obAphARMn2QFzPKK6Ffkb1oqPEHM8Klpc40tTF7Q=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4499aee-742d-462a-443f-08d9efeee0a2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 19:19:09.9152 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aNk7i5IuOLb/JqBq7ToLQYlQqFm2hVeuS276jGr7QXk4grn7F1ERhXZ2twbiHn6frOXdz7nzjawEBwZDghfPwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6515
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 21EJJG4B009584
X-loop: dm-devel@redhat.com
Subject: Re: [dm-devel] [PATCH v2 1/2] libmultipath: support host adapter
 name lookup for s390x ccw bus
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
Content-ID: <CFC511024D165646B7544DDD6C8DC38B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-02-14 at 19:55 +0100, Steffen Maier wrote:
> There are also (FCP) HBAs that appear on a bus different from PCI.
>=20
> Complements v0.6.0 commit
> 01ab2a468ea2 ("libmultipath: Add additional path wildcards").
>=20
> With that we can easily get the full FCP addressing triplet
> (HBA, WWPN, LUN) from multipath tools without additional tools
> and correlation:
>=20
> $ multipathd -k'show paths format "%w|%i|%a|%r"'
> uuid=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 |hcil=A0=A0=A0=A0=A0=A0 |host adapter|target
> WWPN
> 36005076400820293e8000000000000a0|1:0:3:160=A0 |0.0.5080=A0=A0=A0
> |0x500507680b25c449
> 36005076400820293e8000000000000a0|1:0:4:160=A0 |0.0.5080=A0=A0=A0
> |0x500507680b25c448
> 36005076400820293e8000000000000a0|58:0:3:160 |0.0.50c0=A0=A0=A0
> |0x500507680b26c449
> 36005076400820293e8000000000000a0|58:0:4:160 |0.0.50c0=A0=A0=A0
> |0x500507680b26c448
>=20
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 ^^^^^^^^
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 instead of [undef]
>=20
> As a side effect this patch theoretically also enables group by
> host adapter for s390x based on v0.6.0 commit a28e61e5cc9a
> ("Crafted ordering of child paths for round robin path selector").
>=20
> Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
> Signed-off-by: Steffen Maier <maier@linux.ibm.com>
> ---
>=20
> Notes:
> =A0=A0=A0 Changes since v1:
> =A0=A0=A0 - Make sysfs_get_host_pci_name() static and generalize for
> adapters
> =A0=A0=A0=A0=A0 on different bus types, in order to reduce code duplicati=
on
> (Ben).
> =A0=A0=A0=A0=A0 The ancestor walk is always the same based on kernel driv=
er
> core
> =A0=A0=A0=A0=A0 with the only difference that PCI matches against driver =
name
> =A0=A0=A0=A0=A0 whereas CCW matches against subsystem name.
> =A0=A0=A0=A0=A0 Unfortunately, the diffstat increased because I had to mo=
ve the
> =A0=A0=A0=A0=A0 new static sysfs_get_host_bus_id() in front of its only u=
ser
> =A0=A0=A0=A0=A0 sysfs_get_host_adapter_name() [or else a strange upfront
> prototype
> =A0=A0=A0=A0=A0 would have been necessary].
>=20
> =A0libmultipath/discovery.c | 69 ++++++++++++++++++++++----------------
> --
> =A0libmultipath/discovery.h |=A0 1 -
> =A02 files changed, 38 insertions(+), 32 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 7d939ae08004..5aba7e8d495f 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
>=20
> [...]
> -
> -int sysfs_get_host_pci_name(const struct path *pp, char *pci_name)
> +static int sysfs_get_host_bus_id(const struct path *pp, char
> *bus_id)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct udev_device *hostdev, *parent;
> =A0=A0=A0=A0=A0=A0=A0=A0char host_name[HOST_NAME_LEN];
> -=A0=A0=A0=A0=A0=A0=A0const char *driver_name, *value;
> +=A0=A0=A0=A0=A0=A0=A0const char *driver_name, *subsystem_name, *value;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (!pp || !pci_name)
> +=A0=A0=A0=A0=A0=A0=A0if (!pp || !bus_id)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0sprintf(host_name, "host%d", pp->sg_id.host_no);

Nit: While at it, you could have changed sprintf() to snprintf().
But this is no requirement, can be done separately / later.

> @@ -525,10 +499,17 @@ int sysfs_get_host_pci_name(const struct path
> *pp, char *pci_name)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!strcmp(driver_name, =
"pcieport"))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0b=
reak;

The context doesn't show it here, but above these lines, we have

=09=09if (!driver_name) {
=09=09=09parent =3D udev_device_get_parent(parent);
=09=09=09continue;
=09=09}

Is it certain that this condition can't cause a valid ccw device (where
the driver attribute isn't required) to be skipped with the "continue"
statement? Even if the answer is "yes", I'd prefer self-explanatory
code here, because not all of us are s390 / ccw experts.

Also, the code readability could be improved by changing the while loop
to a for loop and getting rid of the multiple
udev_device_get_parent(parent) calls. Like above, not a requirement,
but the change would be welcome.


> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0subsystem_name =3D udev_dev=
ice_get_subsystem(parent);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!subsystem_name) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0par=
ent =3D udev_device_get_parent(parent);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!strcmp(subsystem_name,=
 "ccw"))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0parent =3D udev_device_ge=
t_parent(parent);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0if (parent) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* pci_device found
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* pci_device or ccw fcp de=
vice found
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0value =3D udev_device_get=
_sysname(parent);
> =A0
> @@ -537,7 +518,7 @@ int sysfs_get_host_pci_name(const struct path
> *pp, char *pci_name)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strncpy(pci_name, value, SL=
OT_NAME_SIZE);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0strncpy(bus_id, value, SLOT=
_NAME_SIZE);

Again not mandatory, but we should replace strncpy() by strlcpy() when
we encounter it.

Regards,
Martin


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

