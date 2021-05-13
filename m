Return-Path: <SRS0=4utB=KI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1119C43461
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 20:13:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 70B01613B5
	for <dm-devel@archiver.kernel.org>; Thu, 13 May 2021 20:13:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70B01613B5
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-517-XQWsdz3sPbOZ-NcVbxm3_w-1; Thu, 13 May 2021 16:13:53 -0400
X-MC-Unique: XQWsdz3sPbOZ-NcVbxm3_w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8C7BB192AB86;
	Thu, 13 May 2021 20:13:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 734BE1054FC8;
	Thu, 13 May 2021 20:13:46 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 04E0F55344;
	Thu, 13 May 2021 20:13:45 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 14DKBNSK021365 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 13 May 2021 16:11:23 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 41BAC2077FCB; Thu, 13 May 2021 20:11:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C4DA2077FC9
	for <dm-devel@redhat.com>; Thu, 13 May 2021 20:11:19 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 55E1D1825064
	for <dm-devel@redhat.com>; Thu, 13 May 2021 20:11:19 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-523-J7KwzDwyNx6UtvF7ve-sBw-1;
	Thu, 13 May 2021 16:11:16 -0400
X-MC-Unique: J7KwzDwyNx6UtvF7ve-sBw-1
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
	(mail-vi1eur04lp2057.outbound.protection.outlook.com [104.47.14.57])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-38-lFpySlBbOEmWpXXOlE-dqQ-1; Thu, 13 May 2021 22:11:14 +0200
X-MC-Unique: lFpySlBbOEmWpXXOlE-dqQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB5067.eurprd04.prod.outlook.com (2603:10a6:10:1a::28) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26;
	Thu, 13 May 2021 20:11:13 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::cc21:35e2:da7c:1490%7]) with mapi id 15.20.4108.031;
	Thu, 13 May 2021 20:11:13 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 6/6] multipathd: use symbolic returns for
	ev_remove_path()
Thread-Index: AQHXSBzDup6B0itQcUqNWzSdQ67dzqrh2AMA
Date: Thu, 13 May 2021 20:11:13 +0000
Message-ID: <2b55188067c100090ac3783d4fea328d4db83518.camel@suse.com>
References: <1620926595-12029-1-git-send-email-bmarzins@redhat.com>
	<1620926595-12029-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1620926595-12029-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.4
x-originating-ip: [2.206.153.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 958991fa-8f85-4537-4e0e-08d9164b41ed
x-ms-traffictypediagnostic: DB7PR04MB5067:
x-microsoft-antispam-prvs: <DB7PR04MB50672001ABBF45DF3B8E3795FC519@DB7PR04MB5067.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: lYyWZc6KWMsf9Tm1AveCXNThtaDGSubbBCao5AzudWDRI3wssOYwfenldYxUCgx+Za+53FU+v8c5dXuhMkdjocgDKnbWYyYgND1a31z+6wIt2Tm3tgL3eJhNkEN7kTUE4okHEJcp05u5L9yx+z+ForJ/4fdPcoGcW7QquYDIRoKeZx6s0uNhCuReGhxtAiHDls/MO5w573EBnY70l3jn5xtc/24/DB+hYGsqBXLFJPi649U+AmtY3RaimAG/Yqlj4O+KOuBtd2ak4Pc6dBzJFN6CUv2ondbNB99aOArbCAn9ci9CHCd4wVx376ZSaG4W2iLHZX/ahWGy7kVgnpO3E3KxoLexxXp7JyHUEhSmIeFZxyISGkr614+fVTBQRRqUYbySCTmMoZEmD1DySkG7bnBY7iEeufKSUzJ8sahmdrIT0sQvGTHoeaohxpMY3UtNphjOZ+ANnpfFTbcGKwLgZnOoQ06Hn7b4PVIkIxVgcX/FCYdY4P3UFFFGLWTA6lxOb8/qD9aHjU/r77wsKVsz1yQxnn0uWhGE3cTzQXJ61LdNz79sfC0nezIfSL0SgW05CoADctMhfS+kmzkQEGFpt/h3SbdQ+YrSg0fYZDs/oNM=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(396003)(39850400004)(376002)(346002)(136003)(86362001)(478600001)(66946007)(26005)(5660300002)(71200400001)(6512007)(44832011)(83380400001)(2906002)(122000001)(6506007)(110136005)(8936002)(2616005)(64756008)(66476007)(8676002)(316002)(66556008)(66446008)(186003)(4326008)(6486002)(36756003)(76116006)(91956017)(38100700002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?B6Fu2iQkDKHsgVH+BUOJZstp+BN5HJC05lgTH8zkUzPWoC7/YR9OurnV+?=
	=?iso-8859-15?Q?35wyDbklNSIFqg4tVBSAJeKS8mhmLQj20EZxvhKSmUbGwJnpwbfxvJXZ4?=
	=?iso-8859-15?Q?SaZWiVLmPcq8hTgIE1HtWR4U+G/jTVgrxJuMFyj/G6y/v3SL76eY0P3hw?=
	=?iso-8859-15?Q?3BTj7AGrDwHV/So0n9f4S5D7RqtxM+YUyAz2juRWBylDG63RV31HJcipZ?=
	=?iso-8859-15?Q?yzdXSOyiikNBI4vEmDcTUOwl85Rww4RF5DT5OWWBATIcousegvPIC8rIG?=
	=?iso-8859-15?Q?S6kJT9cmB3BpsdOk1GCtKG0zp2uoFVc7BW0wc6nk3ZGvH0fo5SJsEpcsq?=
	=?iso-8859-15?Q?tBIWDWnGDJBynrtwtYV53JzJdTIHruEB7FmCcglMNZ61Zov/LYPTzF/pB?=
	=?iso-8859-15?Q?0uLIDyZcKd+CX4WA0+h/3SYeKC9EmeXU/ZT+Hr+TSWuPrKd03gyKg6A11?=
	=?iso-8859-15?Q?lPFri6J7UAgTd8JiVhQniRC4wsLUIs97dA6qsk9OTBm4gDOChym/cO9XZ?=
	=?iso-8859-15?Q?iTDjkg5crl0anoX2jQaL3MPLa7R6A2i6MhUozWXHnq9NEiLiyYLppu6HZ?=
	=?iso-8859-15?Q?QpS2kQFsXegE1ETHW2x0/jwX9IadXfD0Ut8iG/BIzXt41qsmmK5CSGbpD?=
	=?iso-8859-15?Q?gZ2uPOya9KWILT7Anung3QFiW5CJ9SGDl3hCkMtk20JMUOokb2ajevILz?=
	=?iso-8859-15?Q?MIo3jJKDWZNO65GdaUNMI7eT3D2/h0uhjEc/8MmeQ8uY0Rh827YvOgvoL?=
	=?iso-8859-15?Q?sNSafRMfPca7Lse+kP/qcQALeEAnZl/WZiyPXPLMHVF1/3s6/W7H5oIgv?=
	=?iso-8859-15?Q?se2HSE40sNFOWhJy5c4FqvrV6+90E6CX9rDwhfmSNSukyfW1XqKXOOQjS?=
	=?iso-8859-15?Q?lTnBfZNvaiGQNl0oAiyR4zxyJknbJAUmWLGs/dDQM6UnSlQHI3rHf3oHR?=
	=?iso-8859-15?Q?CfiBRE+uoT99XQt0bp5C/aHkrO5W55+64K0vSNE7W0nzmov/hme+VMPVy?=
	=?iso-8859-15?Q?jV8eZBHVBeXzTenKy9v4m+C7vO5g9+R/WHWq2WvaCX6xqjagszOvZsCzh?=
	=?iso-8859-15?Q?ngZb9hmJFibbVS93m0hrQ09DKxEVw6PyllhKwSui1UCWAGZK6VNFe8s9G?=
	=?iso-8859-15?Q?Ct03UEJqO+qaTJtGi0AdRjmhr0QzlHb2U57CeqM04x9JCwfCIVF3B7wtT?=
	=?iso-8859-15?Q?SLGyzy5YZ/OrMPeolafPxcmuFu9R95bYjjSQxZ1XMcnbR2Q74KHmSayZw?=
	=?iso-8859-15?Q?C6vTUOdKVB65BSBxzQwCXk2WYMSG0dg1CyyeoV0JWCfg6r/B69H1QHqPG?=
	=?iso-8859-15?Q?GRJRK8eIwubPSu7n2h7R5kaFH+WsvBFnu06aSwdRTRrrkzxlQAucBic0o?=
	=?iso-8859-15?Q?GQEEWdcHc5d3u8q8bmbIeGU/o7XHbI/Ux?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 958991fa-8f85-4537-4e0e-08d9164b41ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 20:11:13.2576 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pcR7m+/givxp1SQbCFcSJZhcNARaxq8bOOAwdvYT0YiH5W47Drm9fi6u9LAFkA+xnQ94dBK/xaGWtTXi8nLJew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5067
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 14DKBNSK021365
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 6/6] multipathd: use symbolic returns for
 ev_remove_path()
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <1A1298AA112B564B9EA150F86998D1BF@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-05-13 at 12:23 -0500, Benjamin Marzinski wrote:
> There are many possible outcomes of calling ev_remove_path(), and not
> all callers agree on which outcomes are a success and which are a
> failure. So ev_remove_path() should simply return a different value
> for
> each outcome, and the callers can decide how to deal with them.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0multipathd/cli_handlers.c | 14 ++++++++++++--
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0 | 35 +++++++++++++++++++----=
------------
> =A0multipathd/main.h=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 9 +++++++++
> =A03 files changed, 40 insertions(+), 18 deletions(-)
>=20
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 1de6ad8e..1462ea84 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -752,7 +752,8 @@ cli_add_path (void * v, char ** reply, int * len,
> void * data)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/* Have the checker reinstate this
> path asap */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->tick =3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} e=
lse if (!ev_remove_path(pp, vecs, true))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} e=
lse if (ev_remove_path(pp, vecs, true) &
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 REMOVE_PATH_SUCCESS)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/* Path removed in ev_remove_path()
> */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp =3D NULL;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0e=
lse {
> @@ -813,6 +814,7 @@ cli_del_path (void * v, char ** reply, int * len,
> void * data)
> =A0=A0=A0=A0=A0=A0=A0=A0struct vectors * vecs =3D (struct vectors *)data;
> =A0=A0=A0=A0=A0=A0=A0=A0char * param =3D get_keyparam(v, PATH);
> =A0=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> +=A0=A0=A0=A0=A0=A0=A0int ret;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0param =3D convert_dev(param, 1);
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: remove path (operator)", param);
> @@ -821,7 +823,15 @@ cli_del_path (void * v, char ** reply, int *
> len, void * data)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: path alre=
ady removed", param);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0return ev_remove_path(pp, vecs, 1);
> +=A0=A0=A0=A0=A0=A0=A0ret =3D ev_remove_path(pp, vecs, 1);
> +=A0=A0=A0=A0=A0=A0=A0if (ret =3D=3D REMOVE_PATH_DELAY) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*reply =3D strdup("delayed\=
n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*len =3D strlen(*reply) + 1=
;
> +=A0=A0=A0=A0=A0=A0=A0} else if (ret =3D=3D REMOVE_PATH_MAP_ERROR) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*reply =3D strdup("map relo=
ad error. removed\n");
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*len =3D strlen(*reply) + 1=
;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return (ret =3D=3D REMOVE_PATH_FAILURE);
> =A0}
> =A0
> =A0int
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 4bdf14bd..72fb7e38 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -838,7 +838,7 @@ handle_path_wwid_change(struct path *pp, struct
> vectors *vecs)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0udd =3D udev_device_ref(pp->udev);
> -=A0=A0=A0=A0=A0=A0=A0if (ev_remove_path(pp, vecs, 1) !=3D 0 && pp->mpp) =
{
> +=A0=A0=A0=A0=A0=A0=A0if (!(ev_remove_path(pp, vecs, 1) & REMOVE_PATH_SUC=
CESS) &&
> pp->mpp) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dmstate =3D PSTATE_FA=
ILED;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->ali=
as, pp->dev_t);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> @@ -948,8 +948,8 @@ uev_add_path (struct uevent *uev, struct vectors
> * vecs, int need_do_map)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 * Make another attempt to remove the
> path
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->mpp =3D prev_mpp;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0ret =3D ev_remove_path(pp, vecs, true);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (ret !=3D 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0if (!(ev_remove_path(pp, vecs, true)
> &
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 REMOVE_PATH_SUCCESS)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Failure in ev_remove_pat=
h
> will keep
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * path in pathvec in
> INIT_REMOVED state
> @@ -960,6 +960,7 @@ uev_add_path (struct uevent *uev, struct vectors
> * vecs, int need_do_map)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dm_fail_path(pp->mpp->alias=
,
> pp->dev_t);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s: failed to r=
e-
> add path still mapped in %s",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp-=
>dev, pp->mpp-
> >alias);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0} else if (r =3D=3D PATHINFO_OK)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Path successfully freed,
> move on to
> @@ -1167,7 +1168,7 @@ static int
> =A0uev_remove_path (struct uevent *uev, struct vectors * vecs, int
> need_do_map)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct path *pp;
> -=A0=A0=A0=A0=A0=A0=A0int ret;
> +=A0=A0=A0=A0=A0=A0=A0int ret =3D 0;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: remove path (uevent)", uev->kerne=
l);
> =A0=A0=A0=A0=A0=A0=A0=A0delete_foreign(uev->udev);
> @@ -1176,8 +1177,8 @@ uev_remove_path (struct uevent *uev, struct
> vectors * vecs, int need_do_map)
> =A0=A0=A0=A0=A0=A0=A0=A0lock(&vecs->lock);
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_testcancel();
> =A0=A0=A0=A0=A0=A0=A0=A0pp =3D find_path_by_dev(vecs->pathvec, uev->kerne=
l);
> -=A0=A0=A0=A0=A0=A0=A0if (pp)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D ev_remove_path(pp, =
vecs, need_do_map);
> +=A0=A0=A0=A0=A0=A0=A0if (pp && ev_remove_path(pp, vecs, need_do_map) =3D=
=3D
> REMOVE_PATH_FAILURE)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret =3D 1;
> =A0=A0=A0=A0=A0=A0=A0=A0lock_cleanup_pop(vecs->lock);
> =A0=A0=A0=A0=A0=A0=A0=A0if (!pp) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* Not an error; path mig=
ht have been purged earlier
> */
> @@ -1191,7 +1192,7 @@ int
> =A0ev_remove_path (struct path *pp, struct vectors * vecs, int
> need_do_map)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> -=A0=A0=A0=A0=A0=A0=A0int i, retval =3D 0;
> +=A0=A0=A0=A0=A0=A0=A0int i, retval =3D REMOVE_PATH_SUCCESS;
> =A0=A0=A0=A0=A0=A0=A0=A0char params[PARAMS_SIZE] =3D {0};
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> @@ -1245,7 +1246,6 @@ ev_remove_path (struct path *pp, struct vectors
> * vecs, int need_do_map)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0condlog(2, "%s: removed map after"
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0" removing all paths",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0alias);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0retval =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0/* flush_map() has freed the path */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> @@ -1262,11 +1262,14 @@ ev_remove_path (struct path *pp, struct
> vectors * vecs, int need_do_map)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mpp->wait_for_udev) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0m=
pp->wait_for_udev =3D 2;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
val =3D REMOVE_PATH_DELAY;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!need_do_map)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (!need_do_map) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
val =3D REMOVE_PATH_DELAY;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * reload the map
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> @@ -1275,7 +1278,7 @@ ev_remove_path (struct path *pp, struct vectors
> * vecs, int need_do_map)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(0, "%s: failed in domap for "
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0"removal of path %s",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias, pp->dev);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
val =3D 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
val =3D REMOVE_PATH_FAILURE;

Hm. With the introduction of INIT_REMOVED, this failure isn't fatal any
more. As far as multipathd is concerned, the path is removed and will
be deleted from the map as soon as the reason for the domap() failure
(likely a problem with some other device in the map) is resolved.
There's no difference from the REMOVE_PATH_DELAY case wrt how the path
will be treated in the future.

So while I agree it's reasonable to distinguish this case from the
"delay without failure" cases above, I'm unsure if we should treat it
as an error in uev_remove_path() (or uev_trigger(), for that matter).


> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/=
*
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =
* update our state from kernel
> @@ -1283,12 +1286,12 @@ ev_remove_path (struct path *pp, struct
> vectors * vecs, int need_do_map)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
har devt[BLK_DEV_SIZE];
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
trlcpy(devt, pp->dev_t, sizeof(devt));
> +
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/* =
setup_multipath will free the path
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
regardless of whether it succeeds or
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
fails */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (setup_multipath(vecs, mpp))
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0return 0;
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0/*
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
Successful map reload without this path:
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * =
sync_map_state() will free it.
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0return REMOVE_PATH_MAP_ERROR;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0s=
ync_map_state(mpp);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ondlog(2, "%s: path removed from map %s",
> @@ -1307,7 +1310,7 @@ fail:
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(0, "%s: error removing path. removing map=
 %s", pp-
> >dev,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mpp->alias);
> =A0=A0=A0=A0=A0=A0=A0=A0remove_map_and_stop_waiter(mpp, vecs);
> -=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0return REMOVE_PATH_MAP_ERROR;
> =A0}
> =A0
> =A0static int
> diff --git a/multipathd/main.h b/multipathd/main.h
> index ddd953f9..24d050c8 100644
> --- a/multipathd/main.h
> +++ b/multipathd/main.h
> @@ -13,6 +13,15 @@ enum daemon_status {
> =A0=A0=A0=A0=A0=A0=A0=A0DAEMON_STATUS_SIZE,
> =A0};
> =A0
> +#define REMOVE_PATH_FAILURE 0x0 /* path was not removed */

We should add a remark that this is normally non-fatal, it's init state
is set to INIT_REMOVED, and that it will be removed at the next
possible occasion. The only thing that should be avoided is to try and
add another path with the same major/minor number.

Use an enum, maybe?

Regards,
Martin


> +#define REMOVE_PATH_SUCCESS 0x1 /* path was removed */
> +#define REMOVE_PATH_DELAY 0x2 /* path is set to be removed later. it
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 * currently still exists and is part
> of the
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0 * kernel map */
> +#define REMOVE_PATH_MAP_ERROR 0x5 /* map was removed because of
> error. value
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 * includes REMOVE_PATH_SUCCESS bit
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 * because the path was also
> removed */



> +
> =A0struct prout_param_descriptor;
> =A0struct prin_resp;
> =A0


--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

