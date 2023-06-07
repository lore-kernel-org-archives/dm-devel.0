Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A78C7EE25
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686162693;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=57yvsaxa5WY+6q3+4yNfc+sh8VFuZA3fLeu6jy9JcsQ=;
	b=abEMCHKlv+v7ySPBf1b6hLna1iEetni3w3sJ/6z1DgKiysv6DKUwaIYUqz1vXGuK7kTw3P
	A+KaFpajul5WJ7qkX5FIfIbvH5o5qAVoKzhp1kDr5reZfT3IBjE0bKx9Im2FqXlgXWih/K
	5EmmW+CPTuIFvCQsDpMt5vgbEMfOZlg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-a3ZELFN-NYmHitQl0RaTCw-1; Wed, 07 Jun 2023 14:31:32 -0400
X-MC-Unique: a3ZELFN-NYmHitQl0RaTCw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D13D3850546;
	Wed,  7 Jun 2023 18:31:30 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8EB3340CFD46;
	Wed,  7 Jun 2023 18:31:28 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 438FE19452C3;
	Wed,  7 Jun 2023 18:31:28 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id B5B4B19465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 18:31:27 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8E9672026E10; Wed,  7 Jun 2023 18:31:27 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id D72272026D49
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:31:26 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-1.mimecast.com
 [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2AA2B280228C
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:31:26 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2066.outbound.protection.outlook.com [40.107.20.66]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-257-WvMfeYP2Ouu371SRBSHPow-1; Wed, 07 Jun 2023 14:31:22 -0400
X-MC-Unique: WvMfeYP2Ouu371SRBSHPow-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DB9PR04MB8204.eurprd04.prod.outlook.com (2603:10a6:10:240::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 18:31:20 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6455.034; Wed, 7 Jun 2023
 18:31:19 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 01/11] libmultipath: add group_by_tpg
 path_grouping_policy
Thread-Index: AQHZmW5AtrZeAUmm/ku68iiiZmPVFQ==
Date: Wed, 7 Jun 2023 18:31:19 +0000
Message-ID: <ba8f322db61002338353839fbd2d4921a5c11ebd.camel@suse.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
 <1686082391-29210-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686082391-29210-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DB9PR04MB8204:EE_
x-ms-office365-filtering-correlation-id: abf0c1bf-13a7-4a67-cce0-08db67856367
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: hekVtqbwl27IKeHmfr0W9GXdZB/xRMXZZwCxmGuL1W+/Rq3h2hjl1TJwOHxLZqUPwhuw9Xq4Awj3DPmP6CTYxfti6+xLaa1hCqT6UXRAweAEtIoe+sxbq09SopecblX2IKD+Uu7PuCKOSq4v/KzcvOshBOH8IIxa5oMMgJXF4Ql5opfCxF9M7HU8AAYxphmc2mw7K7dzzZ836ANfu8cmrhRy1qlGMBFPjUBQrA1vk11H9KYYNShNb2prELcrl9ZUtIMDIjV8Vn8euk8DtKlGfNdh4M+AM28OJRewnp7N7iQutwL3zbN8x3oNFbz77/9Np36A1boQ5RoFbFO0X75dlHA11HA1wu9+HqSigoVtkwamwLs8jkPvMwFgJL2uT5TfbDNGEkpJ815eOZnuLEjAhdlB34qc+HdWe+dQ5f5iGhww9Y3ce45FlmBHSYR6YTkDsV4M9jBNybeRIW59Uq5BngDfHKPF1ZUEndiaHqZG7M9rKFO5blBB1gB0ZxQVQKlSlm7NVPYwbnRgQjOLpmZ6D3SK8xIn6xLO3OBSP/N8maPWzkDklMCNw55WmT4oU74FXAXXJ3pyelN2+03mjwGa2P/iy4LTxMiPyeMWmukIa5j20pAfLrUZexSFLY2l6ujG
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(366004)(376002)(39860400002)(346002)(396003)(136003)(451199021)(478600001)(2906002)(6486002)(36756003)(71200400001)(38070700005)(2616005)(86362001)(26005)(122000001)(6512007)(38100700002)(186003)(6506007)(316002)(5660300002)(8936002)(8676002)(83380400001)(66946007)(91956017)(66556008)(4326008)(76116006)(66476007)(66446008)(64756008)(44832011)(110136005)(41300700001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?8ml6SiXVUZWVJJr4YjfNL4XHPR+V52KGjNbfQePGCWBibbdy87bBYrn6C?=
 =?iso-8859-15?Q?RcMO5ZtANagq3MAdb/co23+RM5y5DRfj60o0gj58qVduoXFtPEqLL/6fL?=
 =?iso-8859-15?Q?ZcCkIHeezUuRzYb6LFqe4Opt9NCaM4rKyRBDk/ZeOutPqxmnDOTxLQuhS?=
 =?iso-8859-15?Q?SL54mo2zbDtYjc0ssm+jdl2crdfmu6WhobXnzcXThqYuTLEHLKDv2U7JZ?=
 =?iso-8859-15?Q?hB13ar+HcBzE3JHqseQaRYwvw4lx7MxYI4VaC3TEljSjV+l5zKiuVFHv1?=
 =?iso-8859-15?Q?CElV3gYwnCiP++6QYzpXCmktNO8UuDY/f5xMzvyX1pA5z3PfFff+NxM/y?=
 =?iso-8859-15?Q?0nkb9+PFIt+vkK1QCE0FVXHHnVOocLVdsLnf7R+xeh6K7ErdKwTjQKYDT?=
 =?iso-8859-15?Q?CWpC+TgnXNT/SXmmC8tvOjqfEmfysEDsezuDTTvqgIkQFaYl4K/hvUWak?=
 =?iso-8859-15?Q?r+YM9wYNmyLLUNtNjK260wtgpML9o+5lNyNCg6iSJBJVPVXGMxoM4m2vD?=
 =?iso-8859-15?Q?w6IAXey9wfcQC1srX7M4vKIfeDxguhEKL74yLLjFZqqq3mvst79WQ78I5?=
 =?iso-8859-15?Q?U8XoZz8AXpAEyRv/AvThkCF02kxl3wY/NkbaJUvDX5MYLZJ8r1a/Poiud?=
 =?iso-8859-15?Q?rw3RoQtpJgi4Xom5AQiz8hdCD72Y1/qL7+Y47WHdRg+9NBjVDsxp84UNz?=
 =?iso-8859-15?Q?NEb4VLhiREW400WNbUTh44o/9iAVbcVSCBVQnAXBV5VJ1qW/pPeYZMCux?=
 =?iso-8859-15?Q?2rC9cAnx8Bd4jOoK9UM5eY90GHqo67yVKcb88x+LTWDXrE0n4wGUxs9st?=
 =?iso-8859-15?Q?OyCP9NYqBUW20WFemFU6cr/aZOigSMqXlxEWMKXhC/0ogsjC2ONsLJQ9r?=
 =?iso-8859-15?Q?5+yB9MpQmi4zJPelxVIFpVpr9ANUs3o/VkCSOnq3gXxD9tccNv8Mg07K2?=
 =?iso-8859-15?Q?MHWFbxeWL/Gpi0m/wK5d6jRu8Pgxj3wmuFNcBohS+kg4qQChnyWC1shN8?=
 =?iso-8859-15?Q?c171LS9nnSdamXfwbLE+k2JI7q+PdT9L8+/z06kmS3WTdk3yJAvlwCZDk?=
 =?iso-8859-15?Q?y3cEiuUmGZhYt0qA8QAUggcPu4MMzva1ucfbvniXugMSUJLE/Bv8oKmqn?=
 =?iso-8859-15?Q?ICSnyQitRVsxeGNjZaXjgWJdH8x/mISzVJ9DEEz0sUP9XFpLK2WzAJXMh?=
 =?iso-8859-15?Q?OZzH2IOWMyUb68/wnq/XTh6uis0dVgB9V45XFrTpGsEpePoyCg20ncB9j?=
 =?iso-8859-15?Q?RSyPoRkdFloGzM612d1NaDiC8FMkszRfev+FxMjxMio36BR5vSXoxr2Wj?=
 =?iso-8859-15?Q?Jg5qwIsPXV2vGlkAesP0bGlhHtniKHX0XpTshf7x1vGtACsh1BIIykmKs?=
 =?iso-8859-15?Q?KwRzMpoUwwvibOGXPIDeGqstdik72Tp2G45Sr47HBJ5/Cl5BpgZ/AfiIk?=
 =?iso-8859-15?Q?1mnUVuEc5VYtEvNrg5hC7l3zSPUJGYYu2NfhswgYPZgKacW3ghwRd5rP7?=
 =?iso-8859-15?Q?1mW3s4j4OvAZ0jk8tvN1Kr5shg/7xf30S/beYEYHcTdIFw9hyUC4FZgLT?=
 =?iso-8859-15?Q?P3CXgA/MQEv4wFi7jJMkrmwbdEqLfycmXc1Ppb06dNQpCEAWaSX0h6sl1?=
 =?iso-8859-15?Q?mlC5bTuGramAiAEmdHIV3goml0NS65JQUdoLXQ+Is68EEY5NomgqGrsel?=
 =?iso-8859-15?Q?A6YM?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abf0c1bf-13a7-4a67-cce0-08db67856367
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 18:31:19.8800 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HdYvO+G90iJaiwswtilSsUIzXSAZL2zpIY34trsCjxN+3xXzAMt3GEdru5ObL34kOw702jbxQ4joZdPDsFPSdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8204
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: Re: [dm-devel] [PATCH V2 01/11] libmultipath: add group_by_tpg
 path_grouping_policy
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <B0C6B35E4B9CF74AAEAEF41B1EF2CC8B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-06-06 at 15:13 -0500, Benjamin Marzinski wrote:
> When we group paths by prio and the priority changes, paths can end
> up
> temporarily in the wrong path groups.=A0 This usually happens when some
> paths are down, so their priority can't be updated. To avoid this for
> ALUA paths, group them by their target port group instead. The path
> groups chosen by this policy won't always match with those chosen by
> group_by_prio, since it is possible for multiple ALUA target port
> groups to have the same priority.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/discovery.c=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/pgpolicies.c=A0=A0=A0=A0=A0=A0=A0 | 19 ++++++++++++++++++=
+
> =A0libmultipath/pgpolicies.h=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +++-
> =A0libmultipath/prioritizers/alua.c |=A0 1 +
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 27 ++++++++++++=
+++++++++++++--
> =A0libmultipath/structs.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 3 +++
> =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 =
1 +
> =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0 |=A0 4 ++++
> =A09 files changed, 58 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 6865cd92..2dcafe5d 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1051,6 +1051,7 @@ detect_alua(struct path * pp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0pp->tpgs =3D tpgs;
> +=A0=A0=A0=A0=A0=A0=A0pp->tpg_id =3D ret;
> =A0}
> =A0
> =A0int path_get_tpgs(struct path *pp)
> diff --git a/libmultipath/pgpolicies.c b/libmultipath/pgpolicies.c
> index 10b44d37..e14da8cc 100644
> --- a/libmultipath/pgpolicies.c
> +++ b/libmultipath/pgpolicies.c
> @@ -25,6 +25,8 @@ int get_pgpolicy_id(char * str)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return GROUP_BY_PRIO;
> =A0=A0=A0=A0=A0=A0=A0=A0if (0 =3D=3D strncmp(str, "group_by_node_name", 1=
8))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return GROUP_BY_NODE_NAME=
;
> +=A0=A0=A0=A0=A0=A0=A0if (0 =3D=3D strncmp(str, "group_by_tpg", 12))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return GROUP_BY_TPG;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0return IOPOLICY_UNDEF;
> =A0}
> @@ -49,6 +51,9 @@ int get_pgpolicy_name(char * buff, int len, int id)
> =A0=A0=A0=A0=A0=A0=A0=A0case GROUP_BY_NODE_NAME:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "group_by_node_name=
";
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> +=A0=A0=A0=A0=A0=A0=A0case GROUP_BY_TPG:
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "group_by_tpg";
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> =A0=A0=A0=A0=A0=A0=A0=A0default:
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s =3D "undefined";
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0break;
> @@ -191,6 +196,12 @@ prios_match(struct path *pp1, struct path *pp2)
> =A0=A0=A0=A0=A0=A0=A0=A0return (pp1->priority =3D=3D pp2->priority);
> =A0}
> =A0
> +bool
> +tpg_match(struct path *pp1, struct path *pp2)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return (pp1->tpg_id =3D=3D pp2->tpg_id);
> +}
> +
> =A0int group_by_match(struct multipath * mp, vector paths,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 bool (*path_match_=
fn)(struct path *, struct path
> *))
> =A0{
> @@ -279,6 +290,14 @@ int group_by_prio(struct multipath *mp, vector
> paths)
> =A0=A0=A0=A0=A0=A0=A0=A0return group_by_match(mp, paths, prios_match);
> =A0}
> =A0
> +/*
> + * One path group per alua target port group present in the path
> vector
> + */
> +int group_by_tpg(struct multipath *mp, vector paths)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return group_by_match(mp, paths, tpg_match);
> +}
> +
> =A0int one_path_per_group(struct multipath *mp, vector paths)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> diff --git a/libmultipath/pgpolicies.h b/libmultipath/pgpolicies.h
> index 15927610..d3ab2f35 100644
> --- a/libmultipath/pgpolicies.h
> +++ b/libmultipath/pgpolicies.h
> @@ -16,7 +16,8 @@ enum iopolicies {
> =A0=A0=A0=A0=A0=A0=A0=A0MULTIBUS,
> =A0=A0=A0=A0=A0=A0=A0=A0GROUP_BY_SERIAL,
> =A0=A0=A0=A0=A0=A0=A0=A0GROUP_BY_PRIO,
> -=A0=A0=A0=A0=A0=A0=A0GROUP_BY_NODE_NAME
> +=A0=A0=A0=A0=A0=A0=A0GROUP_BY_NODE_NAME,
> +=A0=A0=A0=A0=A0=A0=A0GROUP_BY_TPG,
> =A0};
> =A0
> =A0int get_pgpolicy_id(char *);
> @@ -30,5 +31,6 @@ int one_group(struct multipath *, vector);
> =A0int group_by_serial(struct multipath *, vector);
> =A0int group_by_prio(struct multipath *, vector);
> =A0int group_by_node_name(struct multipath *, vector);
> +int group_by_tpg(struct multipath *, vector);
> =A0
> =A0#endif
> diff --git a/libmultipath/prioritizers/alua.c
> b/libmultipath/prioritizers/alua.c
> index 0ab06e2b..4888a974 100644
> --- a/libmultipath/prioritizers/alua.c
> +++ b/libmultipath/prioritizers/alua.c
> @@ -65,6 +65,7 @@ get_alua_info(struct path * pp, unsigned int
> timeout)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn -ALUA_PRIO_NOT_SUPPORTED;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -ALUA_PRIO_RTPG_FA=
ILED;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0pp->tpg_id =3D tpg;
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: reported target port group is %i"=
, pp->dev,


I still think that we should log a change here. Perhaps we should keep
the existing condlog() and just use prio 2 if the tpg_id changed, and
prio 4 if it didn't (the current 3 clutters the logs quite a bit).

Regards
Martin



> tpg);
> =A0=A0=A0=A0=A0=A0=A0=A0rc =3D get_asymmetric_access_state(pp, tpg, timeo=
ut);
> =A0=A0=A0=A0=A0=A0=A0=A0if (rc < 0) {
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index a25cc921..841fa247 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -35,7 +35,8 @@ pgpolicyfn *pgpolicies[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0one_group,
> =A0=A0=A0=A0=A0=A0=A0=A0group_by_serial,
> =A0=A0=A0=A0=A0=A0=A0=A0group_by_prio,
> -=A0=A0=A0=A0=A0=A0=A0group_by_node_name
> +=A0=A0=A0=A0=A0=A0=A0group_by_node_name,
> +=A0=A0=A0=A0=A0=A0=A0group_by_tpg,
> =A0};
> =A0
> =A0#define do_set(var, src, dest,
> msg)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> @@ -249,10 +250,26 @@ out:
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> +static bool
> +verify_alua_prio(struct multipath *mp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int i;
> +=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(mp->paths, pp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0const char *name =3D prio_n=
ame(&pp->prio);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (strncmp(name, PRIO_ALUA=
, PRIO_NAME_LEN) &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 strncmp(name, PRI=
O_SYSFS, PRIO_NAME_LEN))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 re=
turn false;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return true;
> +}
> +
> =A0int select_pgpolicy(struct config *conf, struct multipath * mp)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> =A0=A0=A0=A0=A0=A0=A0=A0char buff[POLICY_NAME_SIZE];
> +=A0=A0=A0=A0=A0=A0=A0int log_prio =3D 3;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (conf->pgpolicy_flag > 0) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D conf->pg=
policy_flag;
> @@ -265,9 +282,15 @@ int select_pgpolicy(struct config *conf, struct
> multipath * mp)
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_conf(pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
> =A0out:
> +=A0=A0=A0=A0=A0=A0=A0if (mp->pgpolicy =3D=3D GROUP_BY_TPG && !verify_alu=
a_prio(mp)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D DEFAULT_PG=
POLICY;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D "(setting: emerg=
ency fallback - not all
> paths use alua prio)";
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_prio =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicyfn =3D pgpolicies[mp->pgpolicy];
> =A0=A0=A0=A0=A0=A0=A0=A0get_pgpolicy_name(buff, POLICY_NAME_SIZE, mp->pgp=
olicy);
> -=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: path_grouping_policy =3D %s %s", mp=
->alias,
> buff, origin);
> +=A0=A0=A0=A0=A0=A0=A0condlog(log_prio, "%s: path_grouping_policy =3D %s =
%s", mp-
> >alias, buff,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> diff --git a/libmultipath/structs.c b/libmultipath/structs.c
> index 87e84d5d..39504dca 100644
> --- a/libmultipath/structs.c
> +++ b/libmultipath/structs.c
> @@ -125,6 +125,7 @@ alloc_path (void)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->sg_id.proto_id =3D PR=
OTOCOL_UNSET;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->fd =3D -1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->tpgs =3D TPGS_UNDEF;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->tpg_id =3D GROUP_ID_UND=
EF;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->priority =3D PRIO_UND=
EF;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->checkint =3D CHECKINT=
_UNDEF;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0checker_clear(&pp->checke=
r);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index a1208751..0eea19b4 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -317,6 +317,8 @@ struct hd_geometry {
> =A0};
> =A0#endif
> =A0
> +#define GROUP_ID_UNDEF -1
> +
> =A0struct path {
> =A0=A0=A0=A0=A0=A0=A0=A0char dev[FILE_NAME_SIZE];
> =A0=A0=A0=A0=A0=A0=A0=A0char dev_t[BLK_DEV_SIZE];
> @@ -372,6 +374,7 @@ struct path {
> =A0=A0=A0=A0=A0=A0=A0=A0/* configlet pointers */
> =A0=A0=A0=A0=A0=A0=A0=A0vector hwe;
> =A0=A0=A0=A0=A0=A0=A0=A0struct gen_path generic_path;
> +=A0=A0=A0=A0=A0=A0=A0int tpg_id;
> =A0};
> =A0
> =A0typedef int (pgpolicyfn) (struct multipath *, vector);
> diff --git a/multipath/main.c b/multipath/main.c
> index 90f940f1..b78f3162 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -157,6 +157,7 @@ usage (char * progname)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . group_by_serial=A0=A0=A0=A0 one priority group
> per serial\n"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . group_by_prio=A0=A0=A0=A0=A0=A0 one priority group
> per priority lvl\n"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . group_by_node_name=A0 one priority group
> per target node\n"
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . group_by_tpg=A0=A0=A0=A0=A0=A0=A0 one priority group
> per ALUA target port group\n"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0 -v lvl=A0 verbosity =
level:\n"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . 0 no output\n"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 . 1 print created devmap names only\n"
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index b4dccd1b..b65a543d 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -233,6 +233,10 @@ per-multipath option in the configuration file.
> =A0One priority group per target node name. Target node names are
> fetched
> =A0in \fI/sys/class/fc_transport/target*/node_name\fR.
> =A0.TP
> +.I group_by_tpg
> +One priority group per ALUA target port group. In order to use this
> policy,
> +all paths in the multipath device must have \fIprio\fR set to
> \fBalua\fR.
> +.TP
> =A0The default is: \fBfailover\fR
> =A0.RE
> =A0.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

