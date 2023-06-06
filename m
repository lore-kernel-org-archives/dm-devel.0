Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E07FEC7EE24
	for <dm-devel@archiver.kernel.org>; Tue,  6 Jun 2023 16:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686069563;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=pLFqZ58EWzmRc/QjtPD+h+5daVCYPc/i0P/ePzeo2EE=;
	b=BEuwdW19UITXoIY9sIRvrJIkM5rbnLm0M09hvN06ck7Rdc3gtCtq9QUM9HqDkhomg+/q5I
	9VGZcH2+XBV3+v3rl4GxHarXD549lsqTSwH2LirctFJBAVj/6gmiQTG8pJ/wH35DVS5gL4
	DWZ+ZhPbLs2x4FUVm9PLSyWHMTZfSMk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-211-pWrruLe2NYqSynJCLeC_wg-1; Tue, 06 Jun 2023 12:39:20 -0400
X-MC-Unique: pWrruLe2NYqSynJCLeC_wg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F2EE02A59543;
	Tue,  6 Jun 2023 16:39:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9E4DA2166B25;
	Tue,  6 Jun 2023 16:39:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 6E1F219465BC;
	Tue,  6 Jun 2023 16:39:18 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7BE1819465BA
 for <dm-devel@listman.corp.redhat.com>; Tue,  6 Jun 2023 16:39:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 65C66C154D2; Tue,  6 Jun 2023 16:39:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5CD84C154D1
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 16:39:16 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3B80E80231B
 for <dm-devel@redhat.com>; Tue,  6 Jun 2023 16:39:16 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04on2083.outbound.protection.outlook.com [40.107.7.83]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-MfQvR2POOcmYnRweuugyyQ-1; Tue, 06 Jun 2023 12:39:14 -0400
X-MC-Unique: MfQvR2POOcmYnRweuugyyQ-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by GVXPR04MB9996.eurprd04.prod.outlook.com (2603:10a6:150:117::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 16:39:09 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 16:39:09 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/5] multipathd: reload map if the path groups are out of
 order
Thread-Index: AQHZjpZ2q6vNqLfPoUixhg0FPwfDKa9+DacA
Date: Tue, 6 Jun 2023 16:39:09 +0000
Message-ID: <23d3fa4d7b4e96ed393c632aed019446fdc26fc2.camel@suse.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|GVXPR04MB9996:EE_
x-ms-office365-filtering-correlation-id: 2b9c52bb-4f28-4ba7-b711-08db66ac8d4e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: tHyxkk6CvxL5IVdNFWoY1DQekESx0mZBoJnhIEG0EMC3Nx9PZPfYe+EGJpR0bo8XhkOrxfsP/1I//vBIqJB+4M+s8rL+KnfY+y5RlHdCDZ0o/0VqQIseZbhK6jWpdC+ITFG2i6hI+kxB/y3SOw8mzx3wMDHr9L9HNZBQIZfpv2G6QO4zCU34F+TiLYk0vAchagusu+z4jdyRAV6DQExMBSbaAWbxDSQUokFHLuwakfZt2ehua/f49V+LZiocb7HTW0nBVsHGDog4OLCOxTHEyi/z/T9SwpuPgkoTEA4Hx+JgX0yAInbh8Q5vU47cBml3r4CTSvxynV5pTPCeOeQyE/dRzAR8dQCzjlROPoG5L2zNV2pejBn/XTpdEY4LSlwuj0WBG8gTIWUfH2IfXyv7lkPGQxIHQDruZbhQiRyWVCExU7eJhzeO7GMi1mOYDrQYJdo5H7TsGsClNcyC9RCpQYpnbEH6GjcCesIk6nCGLn3+9tLfFApETCkrTVfdpamNDvd7dbClq0ae/Cgf+e0vKFfaOqx3WUQrGQYZ2CMp3t4OkPA2hWCJnYEMBUKN6az8k9vJHgr65dn/oiJPCz7LCoBHk3NxcOttdSyKx0tCJmXh9qku2J2ofMa+Yaq6Jrq9
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(376002)(346002)(396003)(39860400002)(366004)(136003)(451199021)(71200400001)(66446008)(66556008)(122000001)(66476007)(76116006)(2906002)(6486002)(66946007)(64756008)(110136005)(8676002)(36756003)(38100700002)(8936002)(5660300002)(91956017)(38070700005)(86362001)(44832011)(4326008)(41300700001)(316002)(478600001)(2616005)(6512007)(26005)(6506007)(186003)(83380400001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?O6ZSQQYB9MnxMja90AvPmCDuKxa6WMDlHtIufIbtbqiQUeclVfhVwqGIf?=
 =?iso-8859-15?Q?6uyxbHyu4tOR83yuLzFT6viEz7c5FqCAO3d9+yyu9XUJtbUB52dgqGjlq?=
 =?iso-8859-15?Q?ApGNsz71ek6LjT4+Ty8agjd8QiU3G33lSb4R4PLHjVblZ+g9OHD5IgS/e?=
 =?iso-8859-15?Q?GtJXi8B0ITuN0qajUJV2KQNZnYiaw28uBJ+Frc7EtKOLYTF3/TPcnHFP+?=
 =?iso-8859-15?Q?pGnBxUvcMulWvcGruP3ePziyjeYU0c3hWIO+6ju+4jDNdKR65q3c5/Vjp?=
 =?iso-8859-15?Q?6Q4Op1iMNlU0NAeooPX8Pr1TqFlcRnxrLvrDBNjk7nv+XoMkkqiEF+WNk?=
 =?iso-8859-15?Q?/TxNb6pLOtCUhPb8VRpE/Rs7/QHIvVWjZabGUzX5M10XZkgvGb17y+kJD?=
 =?iso-8859-15?Q?onZwBK5uAIS/mdUnT2Y/nn7QKz4eMUn4sim7XuIxvHdIoxrqWHUkIPr8s?=
 =?iso-8859-15?Q?6ZJqRAznvHPYCAOUHF9Q86H3CXI5Lq3gK2CCrBjv11YQaalWr2QBQplJA?=
 =?iso-8859-15?Q?z6sGjiYJ4dLgdmhiI7AS1l+BAzCmP0eqJ8qzUH2+Qfk6Z8xDRJLS02l1v?=
 =?iso-8859-15?Q?xFFjgjBJcF8uFle47iOfgkPljPe/A3hpUkKFBgSMi45u4KMgSJ9ZmaSBS?=
 =?iso-8859-15?Q?SuNxSi++W/lh5sj5hPql9ld8k9YF+vpPlBiLpkn1OqNp3i6pT1Pic/5Np?=
 =?iso-8859-15?Q?WiuY+UvdnNB0ZJEHpzd0E7NAPl2bZJdb1RQiWp79B8paqknij/hO326Nl?=
 =?iso-8859-15?Q?PgJc1zBoGku5oep0y9DiQaJARHlp8MH29sUuTYrAjM6QGSHSAwZ5I5GIG?=
 =?iso-8859-15?Q?JmP8lq5m/6+qDweyBZNMjJ4WyiFVik3GkKgLcjA8+Pg376OJfj1yQP4Eg?=
 =?iso-8859-15?Q?G/DaY0Wmuu7z0rMOtiC+KSXAZZNl+57Ji+QCEPZOwhBS3JQd0cqJXk/92?=
 =?iso-8859-15?Q?ZTSP14kDOMT9rpb8PFUoHtIEqN1tZasUDmQANh9HL4AnP+tE4qkmAY995?=
 =?iso-8859-15?Q?Gy9zMG7U+tJxITi0UYaPopRPHgP0K1UonJcwBiZPmua5ZEztx7sXG4+T3?=
 =?iso-8859-15?Q?6hX96/du10+0C6/yByevfR9zmUGymnaM9yB2sQKTGyABqpEd8B+wrYeJa?=
 =?iso-8859-15?Q?Wc6P71+ZQ+LFQLLTSs4lBAPN5dw332uNX+dMpCwjp52cxA8VkWrVudJzF?=
 =?iso-8859-15?Q?oxDgpjrXUvDSpva7WN4lQZ4MQKzFCUFzX3zI6hUfVsAEdcQJ1Z53QD0BO?=
 =?iso-8859-15?Q?a8zKyccaNsJewRi6wVN/bTlqS0Cu9xbQ6o/ybaT3IkG3Ug47CzqKH5T5b?=
 =?iso-8859-15?Q?U1TXfA951oIDsh6igi39qVH3L6MKvRv2t+nGqxCmlrwxzD2kjdA9wgzHu?=
 =?iso-8859-15?Q?B5y1IT4Mu1Ns4QhvFSPmRF+cm8pnkf45NsO1ZV1299hQVzSRqUpYYq6Co?=
 =?iso-8859-15?Q?kma/VqdWk86EZwhn+z66jqRw93ITmegk4Z/P3+WW8NFa7ii0Bd1YKFGOY?=
 =?iso-8859-15?Q?NEpKoPFRk57is3H0sMZ6+X1OJw8HdTWRcODEmeGStAPxriDSFw72/b0kF?=
 =?iso-8859-15?Q?QSHr+WIPn60YHNoJcXBrpem78QF8AjsAT4RJ9vzYHWK2F0tisPhmkrmFm?=
 =?iso-8859-15?Q?6TSzBW+9R16yJjhxDOf6GzHoQtpEG7YLXjzh999Jckk7IGtyEpYLNDeEB?=
 =?iso-8859-15?Q?m144?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b9c52bb-4f28-4ba7-b711-08db66ac8d4e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 16:39:09.4115 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DKOU5MkHAEgwEeNETSDXWMZ67CA9QVQo9f54Lv0P9bf2ScD5i5WZ1oF8uRw6f5zm6nQxuRvcrAk6sGi26/iZhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB9996
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: Re: [dm-devel] [PATCH 4/5] multipathd: reload map if the path
 groups are out of order
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <EA727A547EE13649A76335A7F1E3AB2C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2023-05-24 at 18:21 -0500, Benjamin Marzinski wrote:
> need_switch_pathgroup() only checks if the currently used pathgroup
> is
> not the highest priority pathgroup. If it isn't, all multipathd does
> is
> instruct the kernel to switch to the correct pathgroup.=A0 However, the
> kernel treats the pathgroups as if they were ordered by priority.
> When
> the kernel runs out of paths to use in the currently selected
> pathgroup,
> it will start checking the pathgroups in order until it finds one
> with
> usable paths.
>=20
> need_switch_pathgroup() should also check if the pathgroups are out
> of
> order, and if so, multipathd should reload the map to reorder them
> correctly.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/libmultipath.version |=A0 5 ++++
> =A0libmultipath/switchgroup.c=A0=A0=A0=A0=A0=A0=A0 | 27 +++++++++++++++++=
+++++
> =A0libmultipath/switchgroup.h=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 38=
 +++++++++++++++++++++--------
> --
> =A04 files changed, 59 insertions(+), 12 deletions(-)
>=20
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index 8f72c452..38074699 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -237,3 +237,8 @@ global:
> =A0local:
> =A0=A0=A0=A0=A0=A0=A0=A0*;
> =A0};
> +
> +LIBMULTIPATH_19.1.0 {
> +global:
> +=A0=A0=A0=A0=A0=A0=A0path_groups_in_order;
> +} LIBMULTIPATH_19.0.0;
> diff --git a/libmultipath/switchgroup.c b/libmultipath/switchgroup.c
> index b1e1f39b..b1180839 100644
> --- a/libmultipath/switchgroup.c
> +++ b/libmultipath/switchgroup.c
> @@ -7,6 +7,33 @@
> =A0#include "structs.h"
> =A0#include "switchgroup.h"
> =A0
> +bool path_groups_in_order(struct multipath *mpp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int i;
> +=A0=A0=A0=A0=A0=A0=A0struct pathgroup *pgp;
> +=A0=A0=A0=A0=A0=A0=A0bool seen_marginal_pg =3D false;
> +=A0=A0=A0=A0=A0=A0=A0int last_prio =3D INT_MAX;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (VECTOR_SIZE(mpp->pg) < 2)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return true;
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mpp->pg, pgp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* skip pgs with PRIO_UNDEF=
, since this is likely
> temporary */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!pgp->paths || pgp->pri=
ority =3D=3D PRIO_UNDEF)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->marginal && !seen_=
marginal_pg) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0las=
t_prio =3D INT_MAX;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
tinue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (seen_marginal_pg && !pg=
p->marginal)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn false;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pgp->priority > last_pr=
io)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn false;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0last_prio =3D pgp->priority=
;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return true;
> +}
> +

I stared at this code again while we were discussing, and I figured I
don't quite understand it. First of all, you never update
seen_marginal_pg. I suppose you want to set it in the if (pgp->marginal
&& !seen_marginal_pg) code block. But then, why set last_prio =3D
INT_MAX? If any non-marginal GP would follow, you would return false
anyway.

Martin

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

