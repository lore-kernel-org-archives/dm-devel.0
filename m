Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F508C4332F
	for <dm-devel@archiver.kernel.org>; Fri, 21 Oct 2022 07:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1666335906;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=NNvTptmISxSgiLZNyI4/E4oO4EMxMsaPiPInDuPdJZo=;
	b=FSqkd93HsXc02k8eJ9eNFN+Lkcr+3fKcJXJmIXjQq/jRJRGp25TjgIjejs3YhLEpNkWeuR
	T3cvU0K0AmqWAIm8/7uKUvzijHmV2FdF4B9m/WiHbsJ4ine4SC3fbbnEPWSj2OkC9gUymu
	8FiN3mAzUKWK8b0XT/BL7WmZ1MeCSnM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-sdSb_tR_OTKuc5xUT3AYBw-1; Fri, 21 Oct 2022 03:05:04 -0400
X-MC-Unique: sdSb_tR_OTKuc5xUT3AYBw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5AC2E8027F5;
	Fri, 21 Oct 2022 07:05:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4AE3140EBF3;
	Fri, 21 Oct 2022 07:05:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B48931946595;
	Fri, 21 Oct 2022 07:05:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id DCA0E1946587
 for <dm-devel@listman.corp.redhat.com>; Fri, 21 Oct 2022 07:05:01 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id C8EB61401CC9; Fri, 21 Oct 2022 07:05:01 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id BFE7B140EBF3
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 07:05:01 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DF80811E81
 for <dm-devel@redhat.com>; Fri, 21 Oct 2022 07:05:01 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-eopbgr60070.outbound.protection.outlook.com [40.107.6.70]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-FS77OBNOPDuUhmGCmifsqw-1; Fri, 21 Oct 2022 03:04:59 -0400
X-MC-Unique: FS77OBNOPDuUhmGCmifsqw-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DU2PR04MB8693.eurprd04.prod.outlook.com (2603:10a6:10:2dc::22)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Fri, 21 Oct
 2022 07:04:56 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::eec2:cac0:7732:8da%4]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 07:04:56 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/4] libmultipath: use regular array for field widths
Thread-Index: AQHY3bvdNudt1Ixlw0ahWnEoffd7oq4Ye18A
Date: Fri, 21 Oct 2022 07:04:55 +0000
Message-ID: <306b876895770fc11229ea43418e3766282ee4e5.camel@suse.com>
References: <1665525183-27377-1-git-send-email-bmarzins@redhat.com>
 <1665525183-27377-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1665525183-27377-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.46.0
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DU2PR04MB8693:EE_
x-ms-office365-filtering-correlation-id: 852fffa7-7bf1-4ee5-958e-08dab3328f70
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eeu18xJ7Ewp36BXut5kWpKHqW6f7F89qycyJr0/qSrm9UFcpitR3eDStN8uInb4fif8UDesKkHUoxFXmL7e8gM4XOaKiHNuYEYQVGD4lnAkincfqIs8P2QabG4h14jl3iPb/88y9wvmCHgvlRmBi6ucgpJJN4epz84cFO4+6f+hWpy3x/CRLZTRP4i5gYsyzFlVoXyIYLnoVOSXt5k+19qAXg5mImMFPLrvggn859YFejjS+t/3fCQXRyiR+x2Y6r0l14HDgRsGogtv2D0c+C+GeB2xsEBz0R/vsylbysQ/BFGlHh3Y0H8og+Sc+P2dl4t2ZMM9bi58/2suEaDz+9yo9VCPDrGgApB/jWoSe2gtjQL7WizPWVCbMPupSLjzMByVB2ptdSUIBvPsj8BzeoDAUkVdLtemtai+9C9iWw2K+2QxZ49Z2ojUjSDk/p8eqn5VIsMKHccTs6Q0svf4fHeEnE82p4WitUQ3owZuvvCRMnveDBpfeVQpCtJbqhKWQTlg1CfSz2FVLXXLfKKt80dCDfBmEe3mpcrOFGLaMNDDOM943+Y1Zsms3RfoxTjB69feo/GRyRqcJGSb+nXUdEGowLigutzcJtLGGa9gGlrXIMJfYikFFSYzTpwtrwcsCS+SmTg2W6w8U3YFPoRmQwv5Oi8a8ns8j+Lm5ADuFppRRumiaNKulnFul0tu1M9ualruDmFh2GIXZDDgwLELkbS4iLCtIy/UMqshSqm/rEEp+kY5vrUD3GVtP5+6eYCVaXfjgj2oTS1qkzugaLv8RdQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230022)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199015)(478600001)(6486002)(38070700005)(122000001)(71200400001)(110136005)(316002)(26005)(91956017)(66556008)(64756008)(76116006)(66946007)(66476007)(4326008)(8676002)(66446008)(6506007)(36756003)(41300700001)(6512007)(5660300002)(8936002)(2906002)(4001150100001)(38100700002)(186003)(86362001)(83380400001)(2616005)(44832011)(30864003);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?x3n/dZx9wLowwAiPIczd0v13Pl/9VQBVDGslLxa5rpxKk1AuQ3DE8iGv7?=
 =?iso-8859-15?Q?sF08G2Rj843bN5d+PxjOZ8q6HeJ/R2m8P6Gp6Odu/KZpmLGwcCYyy/lSG?=
 =?iso-8859-15?Q?NGXPLXwwo2sAsURa3ImCG2yWlH5D8WkgSIwGHqxt2ZM9FXyvUnBkRGwu5?=
 =?iso-8859-15?Q?sIrXKL4QNAjaKngczke9IhQQgR6gbt4v7SURvlsSHtTHgZqy+PRFVBuK+?=
 =?iso-8859-15?Q?ljrigDM8Eyd0H/IIgZITkrW3gdysEWCn/xYOIIe7r21k4qrK93N3OWT3f?=
 =?iso-8859-15?Q?w8xPkR3IrdKyWCojmYRL4LDaNtdR6LHsvJbvulsb6jLUWnC/7XvHGT8J4?=
 =?iso-8859-15?Q?dyg4a48b/kGzHmj5HOg5SlBhx/R5s5tAvhyMEa/wHYco6M/3bYeVSxfVa?=
 =?iso-8859-15?Q?siN0gefklVhymYkbselBoFtFrjvWfP13y+zuKX0EG1Xr/Z1y355t6NzIX?=
 =?iso-8859-15?Q?CiZpEtL2g4YzmS6tDUHacJ9uN1fyc251+1VLWG/ASX7+Iq994MpzV0wi6?=
 =?iso-8859-15?Q?8AfH8ZGRlbyW69ROidVFqedaNSPM7ZnSrJ+9VWsrbhsTve9uZCiu0qAIE?=
 =?iso-8859-15?Q?WuasueDWb1b3jB2yKSXJ3i66vIYyFzPIlkXLIdv8RmxSp34n/Oio4MoaC?=
 =?iso-8859-15?Q?k9jJvCLTP3VY0nr1Du+f1kFb5mhz6y7G+JT3LjivwuzAwKoZmDCpJzVFM?=
 =?iso-8859-15?Q?HJGVp/WtufFG/TTKFyKR7WduagXjhgayapBAS7ITx0XiDJVyDLlM8BhrV?=
 =?iso-8859-15?Q?YYjjhpLQ4AlQFUzQmV+LcMiMIAeZuiGuuDIyYGcLzVK635YJMiMpLR2uZ?=
 =?iso-8859-15?Q?qnEqTTEbiMOvNL02vxj7czsBGYsXRHEmozFvwIaLydpTKogvw9F/nN21E?=
 =?iso-8859-15?Q?1Bdn8pmGOqIA7Ij+WC9eTWDV+P0aCMFxZZl3AmqzT2cMZPAv9y3hovUiR?=
 =?iso-8859-15?Q?DEunPuDWazNVTqDyhpD1HAX9O/EbV4bIlSw+DuyOWPCzdBsEE/1qkB+Wt?=
 =?iso-8859-15?Q?axlzM7XrRabDfX6O2Qpt7eRv8bgRQLJaw98zdXF9b6X2VkL7TgBsbylwo?=
 =?iso-8859-15?Q?giFcvkdJoe1kQeI3ycFBpE/gtuPFHxJcRuv6ulJugH1xTXw3p3hhEDr1Z?=
 =?iso-8859-15?Q?5WvWHrzh9Pb911IFBk5aZMQHmBDHA97fbaCWHx/9qOyUadzyJbGNcW0mg?=
 =?iso-8859-15?Q?vDxupHLqafIE4eresBJRYRiWXzAE9ZYS+KDItMngkSJNy0T0tiGjOWr2F?=
 =?iso-8859-15?Q?q992Mr/5V9oQmfxb86qoAWaQ0qp9DCjdmtt8h4bt3ZZ3yDbQfg1R7EWjZ?=
 =?iso-8859-15?Q?q+TxaAZO6CwH7tGBBIWW3NdKZGb6R1AJzje/H7voWymzBTeXXCGW96kp+?=
 =?iso-8859-15?Q?k9Dg8Zpzt5xZjagG7hnbLKjAaPiGr8bAcboxPyHDDNnUzgC6Y5H6VykdZ?=
 =?iso-8859-15?Q?atuwOlhxEM1bPNZWksbXMBsGDY5EPqBaUQhESamL5NKhP3ABwp/WmRzE9?=
 =?iso-8859-15?Q?WJH0krmm5jMLPiPrUum40JC5I1494abqXpeDAmCTmhVar8t2mGVVgpV4G?=
 =?iso-8859-15?Q?WAVYXJeKsGWlBYbeGJJpbxLcdDLmj2GBXeD0Pfh6Y5USfowQaEBXXkhLw?=
 =?iso-8859-15?Q?f+31tW03GNjWFCV0iB2GE/+ES/Oi5lZtJFlsamicw2OYE6ExDJVtEC+y0?=
 =?iso-8859-15?Q?U+nO40JkSHXSeJa+v9y7anj0cQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 852fffa7-7bf1-4ee5-958e-08dab3328f70
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 07:04:56.2290 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ZRh74DPm8CoWvqgM8p2eVEZ8a8wY0yXijPm9dS81l/marF9y9IoeRHl/lg0JjSQD3PQc8TtYTWAUrwzFpfJog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8693
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: Re: [dm-devel] [PATCH 3/4] libmultipath: use regular array for
 field widths
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <7EEF0EB148E9D44CB90B2AA5C3D58139@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2022-10-11 at 16:53 -0500, Benjamin Marzinski wrote:
> We know the size of these arrays, so we can just allocate them on the
> stack. Also, show_path() doesn't use the width, so don't initialize
> it
> in the first place.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

This isn't wrong, but I'm not sure what it actually achieves except a
few less NULL checks (I'm sure you're aware that this doesn't mean
better protection against out-of-memory situations). It comes at the
cost of an ABI change.=A0I understand that the intention is to eliminate
__attribute__((cleanup())). But if we agree we don't want to do that
everywhere, I see no particular reason to do it in this code path.

I'm not totally against it, but I'm not enthusiastic, either.

Regards,
Martin



> ---
> =A0libmultipath/foreign.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 5 ++--
> =A0libmultipath/libmultipath.version |=A0 4 +--
> =A0libmultipath/print.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 32 +++++=
++++++-------------
> =A0libmultipath/print.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 4 +--
> =A0multipath/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=
=A0 5 ++--
> =A0multipathd/cli_handlers.c=A0=A0=A0=A0=A0=A0=A0=A0 | 41 ++++++++++++---=
--------------
> --
> =A06 files changed, 38 insertions(+), 53 deletions(-)
>=20
> diff --git a/libmultipath/foreign.c b/libmultipath/foreign.c
> index 8981ff58..4cc2a8e3 100644
> --- a/libmultipath/foreign.c
> +++ b/libmultipath/foreign.c
> @@ -550,10 +550,9 @@ void print_foreign_topology(int verbosity)
> =A0=A0=A0=A0=A0=A0=A0=A0struct strbuf buf =3D STRBUF_INIT;
> =A0=A0=A0=A0=A0=A0=A0=A0struct foreign *fgn;
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanup_=
ucharp)))
> =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[path_layout_size()];
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_path_layout()) =3D=3D NULL)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +=A0=A0=A0=A0=A0=A0=A0memset(width, 0, sizeof(width));
> =A0=A0=A0=A0=A0=A0=A0=A0rdlock_foreigns();
> =A0=A0=A0=A0=A0=A0=A0=A0if (foreigns =3D=3D NULL) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0unlock_foreigns(NULL);
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index 8a447f7f..af7c5ed2 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -38,9 +38,7 @@ global:
> =A0=A0=A0=A0=A0=A0=A0=A0add_map_with_path;
> =A0=A0=A0=A0=A0=A0=A0=A0adopt_paths;
> =A0=A0=A0=A0=A0=A0=A0=A0alloc_multipath;
> -=A0=A0=A0=A0=A0=A0=A0alloc_multipath_layout;
> =A0=A0=A0=A0=A0=A0=A0=A0alloc_path;
> -=A0=A0=A0=A0=A0=A0=A0alloc_path_layout;
> =A0=A0=A0=A0=A0=A0=A0=A0alloc_path_with_pathinfo;
> =A0=A0=A0=A0=A0=A0=A0=A0change_foreign;
> =A0=A0=A0=A0=A0=A0=A0=A0check_alias_settings;
> @@ -126,6 +124,7 @@ global:
> =A0=A0=A0=A0=A0=A0=A0=A0libmultipath_exit;
> =A0=A0=A0=A0=A0=A0=A0=A0libmultipath_init;
> =A0=A0=A0=A0=A0=A0=A0=A0load_config;
> +=A0=A0=A0=A0=A0=A0=A0multipath_layout_size;
> =A0=A0=A0=A0=A0=A0=A0=A0need_io_err_check;
> =A0=A0=A0=A0=A0=A0=A0=A0orphan_path;
> =A0=A0=A0=A0=A0=A0=A0=A0parse_prkey_flags;
> @@ -133,6 +132,7 @@ global:
> =A0=A0=A0=A0=A0=A0=A0=A0path_discovery;
> =A0=A0=A0=A0=A0=A0=A0=A0path_get_tpgs;
> =A0=A0=A0=A0=A0=A0=A0=A0pathinfo;
> +=A0=A0=A0=A0=A0=A0=A0path_layout_size;
> =A0=A0=A0=A0=A0=A0=A0=A0path_offline;
> =A0=A0=A0=A0=A0=A0=A0=A0print_all_paths;
> =A0=A0=A0=A0=A0=A0=A0=A0print_foreign_topology;
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 97f9a177..87d6a329 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -805,6 +805,12 @@ static const struct multipath_data mpd[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{'g', "vpd page data", snprint_multipath_vpd_data=
},
> =A0};
> =A0
> +
> +int multipath_layout_size(void)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return ARRAY_SIZE(mpd);
> +}
> +
> =A0static const struct path_data pd[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{'w', "uuid",=A0=A0=A0=A0=A0=A0=A0=A0=A0 snprint_=
path_uuid},
> =A0=A0=A0=A0=A0=A0=A0=A0{'i', "hcil",=A0=A0=A0=A0=A0=A0=A0=A0=A0 snprint_=
hcil},
> @@ -834,6 +840,11 @@ static const struct path_data pd[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{'L', "LUN hex",=A0=A0=A0=A0=A0=A0 snprint_path_l=
unhex},
> =A0};
> =A0
> +int path_layout_size(void)
> +{
> +=A0=A0=A0=A0=A0=A0=A0return ARRAY_SIZE(pd);
> +}
> +
> =A0static const struct pathgroup_data pgd[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{'s', "selector",=A0=A0=A0=A0=A0 snprint_pg_selec=
tor},
> =A0=A0=A0=A0=A0=A0=A0=A0{'p', "pri",=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 snprin=
t_pg_pri},
> @@ -871,10 +882,6 @@ int snprint_wildcards(struct strbuf *buff)
> =A0=A0=A0=A0=A0=A0=A0=A0return get_strbuf_len(buff) - initial_len;
> =A0}
> =A0
> -fieldwidth_t *alloc_path_layout(void) {
> -=A0=A0=A0=A0=A0=A0=A0return calloc(ARRAY_SIZE(pd), sizeof(fieldwidth_t))=
;
> -}
> -
> =A0void get_path_layout(vector pathvec, int header, fieldwidth_t
> *width)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0vector gpvec =3D vector_convert(NULL, pathvec, st=
ruct path,
> @@ -929,11 +936,6 @@ void _get_path_layout (const struct _vector
> *gpvec, enum layout_reset reset,
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0}
> =A0
> -fieldwidth_t *alloc_multipath_layout(void) {
> -
> -=A0=A0=A0=A0=A0=A0=A0return calloc(ARRAY_SIZE(mpd), sizeof(fieldwidth_t)=
);
> -}
> -
> =A0void get_multipath_layout (vector mpvec, int header, fieldwidth_t
> *width) {
> =A0=A0=A0=A0=A0=A0=A0=A0vector gmvec =3D vector_convert(NULL, mpvec, stru=
ct multipath,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dm_multipath_to_gen);
> @@ -1187,12 +1189,11 @@ int _snprint_pathgroup(const struct
> gen_pathgroup *ggp, struct strbuf *line,
> =A0void _print_multipath_topology(const struct gen_multipath *gmp, int
> verbosity)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct strbuf buff =3D STRBUF_INIT;
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *p_width
> __attribute__((cleanup(cleanup_ucharp))) =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t p_width[ARRAY_SIZE(pd)] =3D {0};
> =A0=A0=A0=A0=A0=A0=A0=A0const struct gen_pathgroup *gpg;
> =A0=A0=A0=A0=A0=A0=A0=A0const struct _vector *pgvec, *pathvec;
> =A0=A0=A0=A0=A0=A0=A0=A0int j;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0p_width =3D alloc_path_layout();
> =A0=A0=A0=A0=A0=A0=A0=A0pgvec =3D gmp->ops->get_pathgroups(gmp);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (pgvec !=3D NULL) {
> @@ -1236,14 +1237,11 @@ int _snprint_multipath_topology(const struct
> gen_multipath *gmp,
> =A0=A0=A0=A0=A0=A0=A0=A0const struct gen_pathgroup *gpg;
> =A0=A0=A0=A0=A0=A0=A0=A0struct strbuf style =3D STRBUF_INIT;
> =A0=A0=A0=A0=A0=A0=A0=A0size_t initial_len =3D get_strbuf_len(buff);
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanup_=
ucharp)))
> =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[ARRAY_SIZE(mpd)] =3D {0};
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (verbosity <=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_multipath_layout()) =3D=3D NUL=
L)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return -ENOMEM;
> -
> =A0=A0=A0=A0=A0=A0=A0=A0if (verbosity =3D=3D 1)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return _snprint_multipath=
(gmp, buff, "%n", width);
> =A0
> @@ -2027,7 +2025,7 @@ static void print_all_paths_custo(vector
> pathvec, int banner, const char *fmt)
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> =A0=A0=A0=A0=A0=A0=A0=A0struct strbuf line =3D STRBUF_INIT;
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanup_=
ucharp)))
> =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[ARRAY_SIZE(pd)] =3D {0};
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (!VECTOR_SIZE(pathvec)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (banner)
> @@ -2035,8 +2033,6 @@ static void print_all_paths_custo(vector
> pathvec, int banner, const char *fmt)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_path_layout()) =3D=3D NULL)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> =A0=A0=A0=A0=A0=A0=A0=A0get_path_layout(pathvec, 1, width);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push_cast(reset_strbuf, &line);
> diff --git a/libmultipath/print.h b/libmultipath/print.h
> index 52f5b256..4e50827d 100644
> --- a/libmultipath/print.h
> +++ b/libmultipath/print.h
> @@ -16,11 +16,11 @@ enum layout_reset {
> =A0};
> =A0
> =A0/* fieldwidth_t is defined in generic.h */
> -fieldwidth_t *alloc_path_layout(void);
> +int multipath_layout_size(void);
> +int path_layout_size(void);
> =A0void _get_path_layout (const struct _vector *gpvec, enum
> layout_reset,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fieldw=
idth_t *width);
> =A0void get_path_layout (vector pathvec, int header, fieldwidth_t
> *width);
> -fieldwidth_t *alloc_multipath_layout(void);
> =A0void _get_multipath_layout (const struct _vector *gmvec, enum
> layout_reset,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 fieldwidth_t *width);
> =A0void get_multipath_layout (vector mpvec, int header, fieldwidth_t
> *width);
> diff --git a/multipath/main.c b/multipath/main.c
> index 7b69a3ce..f4c85409 100644
> --- a/multipath/main.c
> +++ b/multipath/main.c
> @@ -457,7 +457,7 @@ configure (struct config *conf, enum mpath_cmds
> cmd,
> =A0=A0=A0=A0=A0=A0=A0=A0int di_flag =3D 0;
> =A0=A0=A0=A0=A0=A0=A0=A0char * refwwid =3D NULL;
> =A0=A0=A0=A0=A0=A0=A0=A0char * dev =3D NULL;
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanup_=
ucharp)))
> =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[path_layout_size()];
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> =A0=A0=A0=A0=A0=A0=A0=A0 * allocate core vectors to store paths and multi=
paths
> @@ -544,8 +544,7 @@ configure (struct config *conf, enum mpath_cmds
> cmd,
> =A0=A0=A0=A0=A0=A0=A0=A0if (libmp_verbosity > 2)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0print_all_paths(pathvec, =
1);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_path_layout()) =3D=3D NULL)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> +=A0=A0=A0=A0=A0=A0=A0memset(width, 0, sizeof(width));
> =A0=A0=A0=A0=A0=A0=A0=A0get_path_layout(pathvec, 0, width);
> =A0=A0=A0=A0=A0=A0=A0=A0foreign_path_layout(width);
> =A0
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 5b8f647b..ddc807a1 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -38,11 +38,10 @@ show_paths (struct strbuf *reply, struct vectors
> *vecs, char *style, int pretty)
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0=A0=A0=A0=A0=A0=A0=A0struct path * pp;
> =A0=A0=A0=A0=A0=A0=A0=A0int hdr_len =3D 0;
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanup_=
ucharp)))
> =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[path_layout_size()];
> =A0
> +=A0=A0=A0=A0=A0=A0=A0memset(width, 0, sizeof(width));
> =A0=A0=A0=A0=A0=A0=A0=A0if (pretty) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_path_l=
ayout()) =3D=3D NULL)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0get_path_layout(vecs->pat=
hvec, 1, width);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0foreign_path_layout(width=
);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> @@ -50,10 +49,10 @@ show_paths (struct strbuf *reply, struct vectors
> *vecs, char *style, int pretty)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(vecs->pathvec, pp, i) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (snprint_path(reply, sty=
le, pp, width) < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (snprint_path(reply, sty=
le, pp, pretty? width :
> NULL) < 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 1;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0if (snprint_foreign_paths(reply, style, width) < 0)
> +=A0=A0=A0=A0=A0=A0=A0if (snprint_foreign_paths(reply, style, pretty? wid=
th : NULL)
> < 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (pretty && get_strbuf_len(reply) =3D=3D (size_=
t)hdr_len)
> @@ -67,12 +66,7 @@ static int
> =A0show_path (struct strbuf *reply, struct vectors *vecs, struct path
> *pp,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 char *style)
> =A0{
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanup_=
ucharp)))
> =3D NULL;
> -
> -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_path_layout()) =3D=3D NULL)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> -=A0=A0=A0=A0=A0=A0=A0get_path_layout(vecs->pathvec, 1, width);
> -=A0=A0=A0=A0=A0=A0=A0if (snprint_path(reply, style, pp, 0) < 0)
> +=A0=A0=A0=A0=A0=A0=A0if (snprint_path(reply, style, pp, NULL) < 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> @@ -95,10 +89,9 @@ show_maps_topology (struct strbuf *reply, struct
> vectors * vecs)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *p_width
> __attribute__((cleanup(cleanup_ucharp))) =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t p_width[path_layout_size()];
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if ((p_width =3D alloc_path_layout()) =3D=3D NULL)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0memset(p_width, 0, sizeof(p_width));
> =A0=A0=A0=A0=A0=A0=A0=A0get_path_layout(vecs->pathvec, 0, p_width);
> =A0=A0=A0=A0=A0=A0=A0=A0foreign_path_layout(p_width);
> =A0
> @@ -258,10 +251,9 @@ cli_list_map_topology (void *v, struct strbuf
> *reply, void *data)
> =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> =A0=A0=A0=A0=A0=A0=A0=A0struct vectors * vecs =3D (struct vectors *)data;
> =A0=A0=A0=A0=A0=A0=A0=A0char * param =3D get_keyparam(v, MAP);
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *p_width
> __attribute__((cleanup(cleanup_ucharp))) =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t p_width[path_layout_size()];
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if ((p_width =3D alloc_path_layout()) =3D=3D NULL)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0memset(p_width, 0, sizeof(p_width));
> =A0=A0=A0=A0=A0=A0=A0=A0get_path_layout(vecs->pathvec, 0, p_width);
> =A0=A0=A0=A0=A0=A0=A0=A0param =3D convert_dev(param, 0);
> =A0=A0=A0=A0=A0=A0=A0=A0mpp =3D find_mp_by_str(vecs->mpvec, param);
> @@ -357,11 +349,10 @@ show_maps (struct strbuf *reply, struct vectors
> *vecs, char *style,
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0=A0=A0=A0=A0=A0=A0=A0struct multipath * mpp;
> =A0=A0=A0=A0=A0=A0=A0=A0int hdr_len =3D 0;
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanup_=
ucharp)))
> =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[multipath_layout_size()];
> =A0
> +=A0=A0=A0=A0=A0=A0=A0memset(width, 0, sizeof(width));
> =A0=A0=A0=A0=A0=A0=A0=A0if (pretty) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_multip=
ath_layout()) =3D=3D NULL)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn 1;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0get_multipath_layout(vecs=
->mpvec, 1, width);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0foreign_multipath_layout(=
width);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> @@ -374,10 +365,11 @@ show_maps (struct strbuf *reply, struct vectors
> *vecs, char *style,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
--;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (snprint_multipath(reply=
, style, mpp, width) < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (snprint_multipath(reply=
, style, mpp,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pretty? width : NULL) < 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn 1;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0if (snprint_foreign_multipaths(reply, style, width)=
 < 0)
> +=A0=A0=A0=A0=A0=A0=A0if (snprint_foreign_multipaths(reply, style, pretty=
? width :
> NULL) < 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (pretty && get_strbuf_len(reply) =3D=3D (size_=
t)hdr_len)
> @@ -416,10 +408,9 @@ cli_list_map_fmt (void *v, struct strbuf *reply,
> void *data)
> =A0=A0=A0=A0=A0=A0=A0=A0struct vectors * vecs =3D (struct vectors *)data;
> =A0=A0=A0=A0=A0=A0=A0=A0char * param =3D get_keyparam(v, MAP);
> =A0=A0=A0=A0=A0=A0=A0=A0char * fmt =3D get_keyparam(v, FMT);
> -=A0=A0=A0=A0=A0=A0=A0fieldwidth_t *width __attribute__((cleanup(cleanup_=
ucharp)))
> =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0fieldwidth_t width[multipath_layout_size()];
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if ((width =3D alloc_multipath_layout()) =3D=3D NUL=
L)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0memset(width, 0, sizeof(width));
> =A0=A0=A0=A0=A0=A0=A0=A0get_multipath_layout(vecs->mpvec, 1, width);
> =A0=A0=A0=A0=A0=A0=A0=A0param =3D convert_dev(param, 0);
> =A0=A0=A0=A0=A0=A0=A0=A0mpp =3D find_mp_by_str(vecs->mpvec, param);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

