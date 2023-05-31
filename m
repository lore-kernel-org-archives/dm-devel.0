Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FDCBC77B73
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 16:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685551617;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=RKTOkLF2GCYBTmcCW3PKVbs5fJFhC+OaNUokVccO/co=;
	b=M3VqDWr63cO70JU1qfyPFO1M+alOSVtEJLmv3LwHlgiHBT52UML2SNWZqOJeR6q6zxCtqs
	hG1V3GSGKSzIwOq6ISgGB3bCJW62egsqhl8INC5bTrfkVxhJ8G1C7ZrJXt+wz+A6bU8YCQ
	DmmPwRzQoqyRBjmxQmbn3BzduzQCg4E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-v-VTCeeQMPO56_3X935sRg-1; Wed, 31 May 2023 12:46:56 -0400
X-MC-Unique: v-VTCeeQMPO56_3X935sRg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4C22F1C04B57;
	Wed, 31 May 2023 16:46:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3243F40C6EC4;
	Wed, 31 May 2023 16:46:54 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id CEBAC19465A2;
	Wed, 31 May 2023 16:46:46 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A107F1946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 16:27:37 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 73521492B0D; Wed, 31 May 2023 16:27:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B201492B0B
 for <dm-devel@redhat.com>; Wed, 31 May 2023 16:27:37 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 304F9185A791
 for <dm-devel@redhat.com>; Wed, 31 May 2023 16:27:37 +0000 (UTC)
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04on2072.outbound.protection.outlook.com [40.107.8.72]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-ANntB6ffNyC1nh-HDcSTXw-1; Wed, 31 May 2023 12:27:33 -0400
X-MC-Unique: ANntB6ffNyC1nh-HDcSTXw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS8PR04MB7493.eurprd04.prod.outlook.com (2603:10a6:20b:293::7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 16:27:30 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:27:30 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/5] multipathd: reload map if the path groups are out of
 order
Thread-Index: AQHZjpZ2q6vNqLfPoUixhg0FPwfDKa90nGiA
Date: Wed, 31 May 2023 16:27:30 +0000
Message-ID: <76217148d8069829795fb1d8608d5c5da60402e2.camel@suse.com>
References: <1684970472-28669-1-git-send-email-bmarzins@redhat.com>
 <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684970472-28669-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS8PR04MB7493:EE_
x-ms-office365-filtering-correlation-id: 2a493894-908a-4e89-d3da-08db61f3ee66
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hvRJiFku8oWMrfDncailtXuDW0GjNnHmqBQGxaTP1g4Av88pfKLNfRzEMcu3FYaMsgfKQhzQ3/q3A/63CFij1Z+6KqX6ox8tzox9F74slR3NwRvl3XmYg3GimMvnGV5u6KL6fG6mr11sxMqEllL1NCYb4IyW4Fq9mqG2L41sbFYElbiBhH7JUmkBybKl4eFIlxjD9HorbQlgFbk776hz8PQciI11mAxDXvlx9hCRx+Xjd9BmjIEyW+h67lut/ExwglrYA7R01gHSYcWzIJ0zJRRh7vRfwBFIxbAsWvZrIGjJ2EmCb1OuODz8WbpUSz9HnSQGCRiPacIPrSnPTuXvpFHZVXYNZ43P+KWpnLweGEl1rQCO9T0iKBfxbCyZhClFlvBE5vCiP8uMrzBaJlvAnOpUoYdeOVFt8WbbIpoLh/MFBUDTfcot58woenMpc/qlL6Z8USS+DtCsxi/MfxqisRkgP9VvOg9bAXmaJ++gvF/RddKYf+ZSEFD6ffYmAUIMDbXuahq65PQe9JFv7z2WY72Hp/6bOLdgjmQ1DOLk+PKwIXZr754ffcUXC8VDb7U2mae2qgr/0WkWYDG6JPzjCtiSgESuXEO/rXETue3owJkvakI9tMHDzt4+CZXCufEB
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199021)(186003)(2616005)(110136005)(6506007)(26005)(2906002)(6512007)(478600001)(44832011)(83380400001)(38070700005)(6486002)(86362001)(8676002)(38100700002)(8936002)(122000001)(41300700001)(5660300002)(316002)(76116006)(66946007)(66556008)(64756008)(66476007)(36756003)(66446008)(71200400001)(91956017)(4326008);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?SonJDheXbUJsWr2rRoZSS+FN+32haXMLDGWUelwO6prXLowOJI0SL0rzE?=
 =?iso-8859-15?Q?XSaJRu0fvlfCM5UeqS21J/d/N6uKKxPHpkXa/S8rlLM1u/026eW4oJfYr?=
 =?iso-8859-15?Q?M+gLPsdhTrpJfrLzxz/K9oKsnuTTJRnOPI0S1xZKZgxHOuKWvU6IVb3fc?=
 =?iso-8859-15?Q?U+ENr9V1dXB4Q/rAwPlr2sHaj/Wvs99KttXNe4HGPPXNGTZB+Xh54ZpZ8?=
 =?iso-8859-15?Q?nfrEUsLFI48GT5+AmMJC0XMw1n/tBT1XmuUwpE2KfH+hNIFMJeK0HoXPK?=
 =?iso-8859-15?Q?SD6aaDEASUivMfuGknKVcXNChug38DgYd1N5sK9SzcUfBJaexQfy+Lwz7?=
 =?iso-8859-15?Q?0JHkUVRZdD08CEaXfiTh4KwspNcbx2Upcusc0bn+Ask4hm1a4XPrD9WJZ?=
 =?iso-8859-15?Q?9hGHGwHvbUHwX7PlfZlyS9WqRTlMzEx1VLejumHZ5yPD6/hme02FKDJXv?=
 =?iso-8859-15?Q?9wQHS5sVQ3/tDZrQpei0iqJBAhx1NVttSC9auPdAD+U76DnDXwsBHk35O?=
 =?iso-8859-15?Q?2AeL/JvqTM9gZO/8b4UfUJTMsqcum4T+BR3JXpLjOPmPGaLExU5bxBcX2?=
 =?iso-8859-15?Q?SUYFMUZVtG8/kzPz4XMSLHyE78tfZ1bC75r28nlphBYyvBeWprybh1jAI?=
 =?iso-8859-15?Q?OPBToPdaLn85A7CyWd/8FFu4eVl32WiGOPTpn5tvS+q+vszaQJnmMoFP8?=
 =?iso-8859-15?Q?WhcWnQ57wDQHWGyPEA/d1COSX0ypwgCqCDFwgRauDIdCF2a62sfWcMfE8?=
 =?iso-8859-15?Q?AVPT3kXWIriyz5Fqbysa1HKh6MidunyLKRpijYLqxAytGWrpqFnjBhucZ?=
 =?iso-8859-15?Q?BaE1Ji1K0VH/AXxOcuLN+zjUp7mqiMNHEvqp78pzok36cX4aART3G06HO?=
 =?iso-8859-15?Q?U4SGKxWZROweKTmzfx0CMn9fTU9lS6BBWz3lvEpbBc9Wk7wGij6O7rrx1?=
 =?iso-8859-15?Q?bbtkTRm1tAtIN/HBFxDmwCM//ykoBXunmg+400q+regsVt05qFajGNI4Z?=
 =?iso-8859-15?Q?tMC+8rK0vZxgMoJGKh1rdqRDo4sxQlykU3BhDpvCMOVeo664vm5yTCLIT?=
 =?iso-8859-15?Q?Ktdzed3FbEEzGadGL5oy70XQ74o7rX11mgZ7IeReHnf5ccupj1b2NPQpE?=
 =?iso-8859-15?Q?E9ldSqze55QhOvMcTX7cu8gGCeqp3Uy2k9rs6YHAi0+3uN3mQRxA+t5ok?=
 =?iso-8859-15?Q?qVDKoMLi5Cd55TkSSavyCYcKdmcIg31l0w9H0vWnOKjkYNvBZMoNpsihS?=
 =?iso-8859-15?Q?gzE5zXo1630JVUnVjMCg6uUAw1aK21Tld0CrP6PDuI9aXMMkf26ot6pGV?=
 =?iso-8859-15?Q?EbzOcdYs5MngZo4SC0QgRIJpJf1NhJercYccJ0WvBC3tUFnYt2iDmFPrV?=
 =?iso-8859-15?Q?ZEeNXaZMVePEIwd09Mv+KLeI31JS5iky6dyZvKFDWrrCbdXHmzeD5E8/h?=
 =?iso-8859-15?Q?hmmbTC6vikJqNKnIc2DYqoazquPEf74J07A7YMSHcb/Zoh4atYWxBik2T?=
 =?iso-8859-15?Q?M3DOWd7mEhKlI9ME4BX1B695PrhyGAOfZLyXjxj4H+L1uEtgj7ms/QScq?=
 =?iso-8859-15?Q?3LkoShdlZhyJiHb92V2ke1cr0RwGW0kZTGxqoStKVpluUS36JvFOEhS8n?=
 =?iso-8859-15?Q?ItXESNbXpBn6qhTbwtfCoxcAFzIpVi3ZUzt5rszfpLWUpucdT8XHDXjJz?=
 =?iso-8859-15?Q?d0mn?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a493894-908a-4e89-d3da-08db61f3ee66
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 16:27:30.7461 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: agZcauq0qBuwAX9fZaaKXuiIqep7bihyChB4cPsJDYFAC5qOswmlf/6S/ChTr/au160PA743f0P0Gg3HpRXOIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7493
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <C4FCE891E3A4AB46BB9645EECF493A3A@eurprd04.prod.outlook.com>
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
> =A0void path_group_prio_update(struct pathgroup *pgp)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> diff --git a/libmultipath/switchgroup.h b/libmultipath/switchgroup.h
> index 9365e2e2..43dbb6c9 100644
> --- a/libmultipath/switchgroup.h
> +++ b/libmultipath/switchgroup.h
> @@ -1,2 +1,3 @@
> =A0void path_group_prio_update (struct pathgroup * pgp);
> =A0int select_path_group (struct multipath * mpp);
> +bool path_groups_in_order(struct multipath *mpp);
> diff --git a/multipathd/main.c b/multipathd/main.c
> index e7c272ad..2ea7c76b 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -396,7 +396,7 @@ void put_multipath_config(__attribute__((unused))
> void *arg)
> =A0}
> =A0
> =A0static int
> -need_switch_pathgroup (struct multipath * mpp, int refresh)
> +need_switch_pathgroup (struct multipath * mpp, int refresh, bool
> *need_reload)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct pathgroup * pgp;
> =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> @@ -404,6 +404,7 @@ need_switch_pathgroup (struct multipath * mpp,
> int refresh)
> =A0=A0=A0=A0=A0=A0=A0=A0struct config *conf;
> =A0=A0=A0=A0=A0=A0=A0=A0int bestpg;
> =A0
> +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D false;
> =A0=A0=A0=A0=A0=A0=A0=A0if (!mpp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> @@ -430,10 +431,9 @@ need_switch_pathgroup (struct multipath * mpp,
> int refresh)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0mpp->bestpg =3D bestpg;
> -=A0=A0=A0=A0=A0=A0=A0if (mpp->bestpg !=3D mpp->nextpg)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0*need_reload =3D !path_groups_in_order(mpp);

This will start another loop over the path groups. Can we just
integrate the path_groups_in_order() logic into the loop right here?



> =A0
> -=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0return (*need_reload || mpp->bestpg !=3D mpp->nextp=
g);
> =A0}
> =A0
> =A0static void
> @@ -1982,20 +1982,26 @@ ghost_delay_tick(struct vectors *vecs)
> =A0}
> =A0
> =A0static void
> -deferred_failback_tick (vector mpvec)
> +deferred_failback_tick (struct vectors *vecs)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int i;
> +=A0=A0=A0=A0=A0=A0=A0bool need_reload;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (mpvec, mpp, i) {
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot (vecs->mpvec, mpp, i) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * deferred failback gett=
ing sooner
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->pgfailback > 0 &=
& mpp->failback_tick > 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->failback_tick--;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(!mpp->failback_tick &&
> need_switch_pathgroup(mpp, 1))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(mpp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(!mpp->failback_tick &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0 need_switch_pathgroup(mpp, 1,
> &need_reload)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (need_reload)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(mpp,
> vecs, 0);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(mpp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0}
> @@ -2579,6 +2585,7 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0int prio_changed =3D upda=
te_prio(pp, new_path_up);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bool need_refresh =3D (!n=
ew_path_up && prio_changed &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->priority !=3D PRIO_UNDEF);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bool need_reload;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (prio_changed &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pp->mpp->pgpoli=
cyfn =3D=3D (pgpolicyfn
> *)group_by_prio &&
> @@ -2586,15 +2593,22 @@ check_path (struct vectors * vecs, struct
> path * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(2, "%s: path priorities changed.
> reloading",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->alias);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eload_and_sync_map(pp->mpp, vecs,
> !new_path_up);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_path=
group(pp->mpp,
> need_refresh)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else if (need_switch_path=
group(pp->mpp,
> need_refresh,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 &need=
_reload)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (pp->mpp->pgfailback > 0 &&
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 (new_path_up || pp->mpp->failback_tick <=3D
> 0))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->failback_tick =3D
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp->pgfailback + 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse if (pp->mpp->pgfailback =3D=3D -
> FAILBACK_IMMEDIATE ||
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 (chkr_new_path_up &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 followover_should_failback(pp)))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(pp->mpp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 followover_should_failback(pp))) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (need_reload)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0reload_and_sync_map(pp->mpp,
> vecs,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0
> !need_refresh &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0
> !new_path_up);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0switch_pathgroup(pp->mpp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0return 1;
> @@ -2720,7 +2734,7 @@ unlock:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(clea=
nup_lock, &vecs->lock);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0deferred_failback_tick(vecs=
->mpvec);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0deferred_failback_tick(vecs=
);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0retry_count_tick(vecs->mp=
vec);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0missing_uev_wait_tick(vec=
s);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ghost_delay_tick(vecs);



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

