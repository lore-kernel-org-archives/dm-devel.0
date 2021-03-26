Return-Path: <SRS0=sRxI=IY=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 554ADC433C1
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 17:16:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B9A8861A24
	for <dm-devel@archiver.kernel.org>; Fri, 26 Mar 2021 17:16:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B9A8861A24
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-UjbXWasZOUe_63OCEh-muA-1; Fri, 26 Mar 2021 13:16:38 -0400
X-MC-Unique: UjbXWasZOUe_63OCEh-muA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7716881425A;
	Fri, 26 Mar 2021 17:16:34 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 57A9A6A04E;
	Fri, 26 Mar 2021 17:16:34 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 245314A703;
	Fri, 26 Mar 2021 17:16:34 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 12QHGWMT008085 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 26 Mar 2021 13:16:32 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 7DD362026D48; Fri, 26 Mar 2021 17:16:32 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 768272026D11
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 17:16:29 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8C6D85A5B9
	for <dm-devel@redhat.com>; Fri, 26 Mar 2021 17:16:29 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-491-cBbO4k6XM6y_9RDtHGETIQ-1;
	Fri, 26 Mar 2021 13:16:27 -0400
X-MC-Unique: cBbO4k6XM6y_9RDtHGETIQ-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2055.outbound.protection.outlook.com [104.47.12.55])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-36-eQZ779z1MpGKzY_EyzxKTg-1; Fri, 26 Mar 2021 18:16:24 +0100
X-MC-Unique: eQZ779z1MpGKzY_EyzxKTg-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB8PR04MB6844.eurprd04.prod.outlook.com (2603:10a6:10:112::23)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26;
	Fri, 26 Mar 2021 17:16:23 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::69bd:c9ff:f910:faeb%7]) with mapi id 15.20.3977.026;
	Fri, 26 Mar 2021 17:16:23 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/4] multipathd: don't trigger uevent for partitions on
	wwid change
Thread-Index: AQHXIdpg8aD3JR0fiEm57UGQh6ZiDaqWg8iA
Date: Fri, 26 Mar 2021 17:16:23 +0000
Message-ID: <0706f9bb5d0a58b0490821a22d98c2e581285a1d.camel@suse.com>
References: <1616719966-10221-1-git-send-email-bmarzins@redhat.com>
	<1616719966-10221-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1616719966-10221-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.202.118.173]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dd93ef6-0512-48a8-4501-08d8f07ae1c8
x-ms-traffictypediagnostic: DB8PR04MB6844:
x-microsoft-antispam-prvs: <DB8PR04MB6844C0D23162A4CA286D8E56FC619@DB8PR04MB6844.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: GDPbb5dn1LrMmmvzcP8v6b5XRYxq4TcVm0Y0zFvie/3TljxsrH8CNOf5jp8PhPisM/RVGT0vzY5ar/BrFUyW5HIiz0Vm9AP82yerXwxuG4GtKF4UAvV9ENCRclZGiP8pOcldFidqxTNAzg82M9XNlTT0Rzgw7gbZGQeKevmdWBWf2GHKkaKUyaSlosvhJPzh2vEM1xuvmO7CciWBgK76OWFyT7JTkNL3Z5YGCCaXha58Iby12Ph7K4VaO8VqfOUr6L5RqypQkkFk+16c7SroRw46xSVJsPVeZQp1wJpr2vPaTfEEq/7MwXR7mDTCg9oqHZZBfzm60ufFtWVAql0OcMoLhrMhhJ9ZD5NhoJOb+JoEJRLeAQX1K/aEswxtl2nGzl8mx2ihGTS2HqM4hElB7+rzXdP+8czz7O5TM82HGb9PF2wJchbt4z3TdMZkSqjmReaOmqLtFG4ULuVR/uJFyPsa/MZ5Gf4+E79p00su4bm9Qq9vHm4LwN2NMv6wtw8b0FrrpcXpCBqb4m23y8M1sE67dWNnZrO3qmsEHNJEmKbHeqa9Xp71SwAcrSxMpNiWto5Yl8FA/HYz4cyA7ycJTUR/uavEWT/m5r5lPDl1ciHDLzaxY9zItDqnCq8RZUb5bTjBG2kKg1T4PNi2LQm8uGXZTWVs6aEjslzB8yU+ITM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(8936002)(316002)(186003)(478600001)(83380400001)(110136005)(2616005)(26005)(66574015)(36756003)(86362001)(8676002)(66446008)(2906002)(44832011)(71200400001)(66946007)(4744005)(76116006)(91956017)(6512007)(5660300002)(4326008)(38100700001)(6506007)(6486002)(64756008)(66556008)(66476007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?kStXBr7Xe9ABFN/V0Sq3jNPiBblYKWVQa8qQcAgrddHquVTGrkWNJyypR?=
	=?iso-8859-15?Q?BUSofP7HFid6OgX2iAsuEXuZfiLpD7kf6KtY/ZSgv3rgq4swaMkSDozS+?=
	=?iso-8859-15?Q?9rMnEXTLhVDSoRA/qWCfcnjEDOspXgoqMFxQHtHq6L/UKEjs9yPWQUPD8?=
	=?iso-8859-15?Q?jV5Vf7EU9q+h/3LihCEGidA7xZ/s8SloaP0B/lL0hmrOGFUYp9RgiuMGd?=
	=?iso-8859-15?Q?ba9jCIhDYvZscOOJup1avQ9DNZbXXHZCFx6mb4GG2eWTS8eiGtjpNy+gK?=
	=?iso-8859-15?Q?G2EoI90JJMz1r1DwS+EAHDnhG3r2j6QG3FxoF6KD/fqPhKOgDMWT2woMy?=
	=?iso-8859-15?Q?RUo/zPAXPa9kXMj4vo1gscmuepO4BgejJ9tJKL2qAXK/B3emnNlbI1+Rc?=
	=?iso-8859-15?Q?HJiLlm8uFTUfAbbDXMH+67d41h2CM5bwazzpCDWwIfQKOe9P7cM9xCkLh?=
	=?iso-8859-15?Q?bivNoQRdtA8fGO2vOqQLUcG2FBTK74G477x/Z+dflDiaaxmQgYF1togQv?=
	=?iso-8859-15?Q?Ot4XTCPkxE26yZ7mA7fLzBbZayUdBoL99UPsoZFG8aQBewYCOJPnCvzYD?=
	=?iso-8859-15?Q?YwdV87ILVOiY5nJyNVTd7RF/ZB6gxgdbRxPUcsMGO9VC7QnCJdwJ3lWnQ?=
	=?iso-8859-15?Q?5SVqalC5mcRN8La+75aFzQ+k4h1McxzbzsfIyLwvDwU/iOTavlSayNohc?=
	=?iso-8859-15?Q?kBHJOAbpuxJbT93kKaGOUlT1A4pduVWK8iigF/oF96tsgrNzx9AA+nI3I?=
	=?iso-8859-15?Q?64pTgkB9in8bfFaXSI8GlI0SC+T9KpBWKw1Suz3MAjUeVMud6MS3SOW+w?=
	=?iso-8859-15?Q?0Tn7gpLKLvc+5njHoUhmXlf7QRZBsm9LMHLwgpVuKIvurEeEkWW0dBjnC?=
	=?iso-8859-15?Q?rCP/aDXwWd8CexWD39bcaHdh6vVSOnxKF45uxCeZvMYNRmoaV37s2El4F?=
	=?iso-8859-15?Q?d3oZ1Fi000RLdl9zHwP4JfDn8UvN/ImNRi0m487CRVNL0vPvkP1zSi7Rp?=
	=?iso-8859-15?Q?7HDHmT659ihmltCxXMOXNgOOfhO3LZVA79+HJDjdw0r+B5DSXO9NbTi+O?=
	=?iso-8859-15?Q?1OWYt+ZlfuPINISuoJm89nO//UXiNhWYzTz/lMr1KKjGBV0A1D6cL2Z6D?=
	=?iso-8859-15?Q?hTpIUoBaEo21W01JzJH+86aL/h5EmNaRAY46aEntBF3zv0K7/veufy6bl?=
	=?iso-8859-15?Q?Ounzm7GuEJOqpgfBcujlfMDmSLnuEOvVbpTv/ZVxbfnrJK8jIX2uAfAuI?=
	=?iso-8859-15?Q?KESYvi5EucuMyEdh9+Ydr4IuHC6IFfqOnta94Vo/9OHT9qSR9UYt+GGUP?=
	=?iso-8859-15?Q?8LZ5fkAc0BeIQI8Yz91Pdvxd0wJn2USHgYWVyJW9xtAWBnUupEVr//hZh?=
	=?iso-8859-15?Q?oqfzK0nD9No3STSlSeFvo/9lRXpZ2oonN?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dd93ef6-0512-48a8-4501-08d8f07ae1c8
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 17:16:23.6370 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KAHigVjlTGKRuzSeny6HoFmhxNR2assRmUTict4I5FYdX4JHGGfQ9//oMM6KvzCBwy5Ux9V0J1JiZNYrNY9kXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6844
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 12QHGWMT008085
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/4] multipathd: don't trigger uevent for
 partitions on wwid change
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
Content-ID: <5994F8F69A48B0429833F09F36A33B33@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-03-25 at 19:52 -0500, Benjamin Marzinski wrote:
> If the wwid changed, the device is no longer the same, so sending add
> events to the devices partitions doesn't make any sense.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0multipathd/main.c | 1 -
> =A01 file changed, 1 deletion(-)
>=20
> diff --git a/multipathd/main.c b/multipathd/main.c
> index bc747d0e..3579bad7 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -845,7 +845,6 @@ handle_path_wwid_change(struct path *pp, struct
> vectors *vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0rescan_path(udd);
> =A0=A0=A0=A0=A0=A0=A0=A0sysfs_attr_set_value(udd, "uevent", "add", strlen=
("add"));
> -=A0=A0=A0=A0=A0=A0=A0trigger_partitions_udev_change(udd, "add", strlen("=
add"));
> =A0=A0=A0=A0=A0=A0=A0=A0udev_device_unref(udd);
> =A0}
> =A0


--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

