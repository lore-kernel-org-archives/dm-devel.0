Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E32A1C77B7A
	for <dm-devel@archiver.kernel.org>; Wed, 31 May 2023 15:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685546968;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A58iiZjSoW6HX4t+tlH9t+nhyhzPoKPe1Xr+8rxcyVY=;
	b=J3zpsKQWWrV42t8Jipi0Pk+KuX+R92osp2n46Su/RM+h7YxflcHG2JZN5u7OG1R4UTl7bn
	jCLkf1IW1Gz6cqhe1YTfKAl7qaSw4LEfCzbq7Xq4mJ4Nu+mzqYBMrZKeRgaFqi8mJYKWVY
	ACb9Tqclb5+uVfcopikuoIFq7bFU340=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-QUD4PArMOYuUwm55tLSQ3Q-1; Wed, 31 May 2023 11:29:25 -0400
X-MC-Unique: QUD4PArMOYuUwm55tLSQ3Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F7DC8039C2;
	Wed, 31 May 2023 15:29:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1A5DE40C6EC4;
	Wed, 31 May 2023 15:29:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BD18F19465A2;
	Wed, 31 May 2023 15:29:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6D1A21946595
 for <dm-devel@listman.corp.redhat.com>; Wed, 31 May 2023 15:21:42 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 41F34112132D; Wed, 31 May 2023 15:21:37 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 39A23112132C
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:21:37 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 183031C0ED03
 for <dm-devel@redhat.com>; Wed, 31 May 2023 15:21:37 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04on2087.outbound.protection.outlook.com [40.107.7.87]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-270-xseaFoTzNjSpbN8MC_fU3g-1; Wed, 31 May 2023 11:21:32 -0400
X-MC-Unique: xseaFoTzNjSpbN8MC_fU3g-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by AS8PR04MB8183.eurprd04.prod.outlook.com (2603:10a6:20b:3f1::11)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 15:21:26 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::2947:7809:4229:a8af%4]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 15:21:26 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/5] libmultipath: add ALUA tpg path wildcard
Thread-Index: AQHZiqX5zbfsRBhFDku0j1MBg380a690kdSA
Date: Wed, 31 May 2023 15:21:26 +0000
Message-ID: <41a5d2dddff4a9f014fa24ee05b75431e291c28e.camel@suse.com>
References: <1684537332-23033-1-git-send-email-bmarzins@redhat.com>
 <1684537332-23033-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1684537332-23033-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|AS8PR04MB8183:EE_
x-ms-office365-filtering-correlation-id: b87d271f-0428-4383-ac34-08db61eab35c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 7cD39iC9yAitqnnTMUEdOuOX03E38brVAJZBjX9Ek8cOVxHzOFWVFRQXO8N6KOhPOVjxDZrveuP2XpsxmuaEd/hy4TTHT3NffgAeMTvxVcFqV+a88nizrfUI38JZ0XtBoQbtqst4jDIacN6Fqbmnv91Ga0H4qOteoQn/wyVfn2V24ogLn+3HNGK1qaBxMPAlDlp3aDmJdl2K60DTVQMpkXYjqYlzJpMO2KQ5D30pZPXeP5VEzFJUzD7ltZUNfZQFsVdr7dZEIGoo5LLvu0qFhhBScNt9Fi78jiCC6CX7rOjdWo7k2jYBxcY1rn4U+roXbfJre/ZcdEtSo/N2AWw/ciL7ouIehr+VSlwMsR81UAgQ/Oo3RYnJTVZqlzSoL+bQC19GOz867CZJun0d7eeX+eBSgGjI36rsRpIxQLz9V+ZPdQjas1UWuLmluDPTHVVTWH1w1oItd3w5Yg4QzMDSpyOshJ8OxAl55pf/LUcXLCDaGPvZTQbDTaF1LEkMvaXPrIbHsNkb5qi0V0mCX6f4A2rbM8bdLrcO61B7oHjzeD9k07FsuAwDZuejWe6JzF8krp1f3/l2hFqvTwmu06kvIv3/ZtVyCMH3KCf06RDT8B4jUH4BlCbUpwISNycL24B8
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199021)(186003)(2616005)(38100700002)(41300700001)(6512007)(26005)(6506007)(6486002)(478600001)(110136005)(71200400001)(66476007)(66446008)(4326008)(66946007)(76116006)(66556008)(316002)(91956017)(5660300002)(122000001)(8936002)(8676002)(64756008)(44832011)(86362001)(2906002)(38070700005)(36756003);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?QmuqvpLYirGQ74DPwnW5faISkbZ7LbJhTPTm3JQjpb2NVP/SDAbGfs2S5?=
 =?iso-8859-15?Q?RIHJpxeaGmH/Nol859igDr/N8wo+8fzSEUg9e9E7ibiupIyqypJwgC0SU?=
 =?iso-8859-15?Q?vEB9isQEaPEdR9N2Ab8RJL7NJ9XThh7XlbaLuYmBB+bfBhz7D7NHyE+As?=
 =?iso-8859-15?Q?tuPtthNLn2l9fIdREYtpL0/wePFT48ANClLb/S8Vik9+G5n6PpajX1lpP?=
 =?iso-8859-15?Q?e958RfWmG8yrDnaLhbBxntq3VEsxaThzC5QWdmI2R4sFS1vZvwDqfjQjy?=
 =?iso-8859-15?Q?IvJlWhytMVTH+yW+YO/I0nLfuo+piT5IV7Zz5WXRWbdDO8M4A2kZ9w3s0?=
 =?iso-8859-15?Q?FKj1mvGcLginC08toCdmtxOQBeuh3m9k2usEOvFzBy/zM0nwcOt8ZLpIX?=
 =?iso-8859-15?Q?1tG6r5mlfnykltpl3xXygnqKP2BY6eBQYN4bn0+YxsdXpn/94p38BgBKZ?=
 =?iso-8859-15?Q?N/8W579oBaalLLSkeH8VMvvf0NXDtlef1k5yI3KlaKqM8LR84xd9YAdXD?=
 =?iso-8859-15?Q?SsORL2FObfgmV9Ib2GOpCi0Kq1S0pU+wobEBUfRW+cF30CgfU7shGRY2t?=
 =?iso-8859-15?Q?Ywi1DVHO2F3IGbZywr+pDBBBeJbpvwj7+xbFkbKjKSKxG7MijmsqNoef8?=
 =?iso-8859-15?Q?d36fm3aBhTnvflC70+qM40Cns/DJh6mpfDtFvIhNP1fqsLe9L4nFpNnZE?=
 =?iso-8859-15?Q?/7FHIz0std4b6dW1GBmPdgQn1ZoQ/Daz2aJRss1h6g0XuSLaZbCUmL0lO?=
 =?iso-8859-15?Q?cRdcy8io7HPCXR1FmZIO7rU54Mq2ptiU9G/du1BgmpEfS9dtgRaljlqKg?=
 =?iso-8859-15?Q?pp8Cb8uxK4pCRRpUdNF89psLTypOWz3bibSeucmIJ9KgsmzDirkvfi3Ei?=
 =?iso-8859-15?Q?EzD5lYFum4pOsz0o0ZWJwM70ufyKxjPecl6Zzr3dPdmyC2QMx34g6Akwk?=
 =?iso-8859-15?Q?KSjQTlph15jqipFuFzVI0iLhqhA0vCRB/pDweHkEMZrQxlwcdceCz5TGd?=
 =?iso-8859-15?Q?zqqW6XYxLYniPNeF7Yh1EHP5Ko/SJ5pmvlPtuvPxQsE/X8TvhRPclD8iK?=
 =?iso-8859-15?Q?F9j6qOijJp7QnO40hJGUFMPq/Q2THjlUulNgShMBk02XgaG3CLWnJVFpq?=
 =?iso-8859-15?Q?eSXgAblIt1425dpiNz0Xbh8i0+RFguahillqf/rKUT+J6eW4TZeFOHCCh?=
 =?iso-8859-15?Q?en1A2gLkbnQ0N6MccPE7eXjLYHE99sZ+/d3qvKVkf7Nqrq2YX9oeZp2CE?=
 =?iso-8859-15?Q?DuWWvCViZbbSeflWLEZG6AGpUSmd2cnhOyydYLMtKM4Hb9Y2ZNgx0o59s?=
 =?iso-8859-15?Q?BG5txsi/2slyJpS2d3rsuqcIlVibndohiZ0YQv3CxPZblqTldZG0Ymucr?=
 =?iso-8859-15?Q?boVu417P1cxRk+BNBK0VkRcSVJDiVxXy0x7/xp9/HSDauJ/JdRCe4Gqqm?=
 =?iso-8859-15?Q?Zlii/fMMw/6qvvMrizY4HoQJRLO4lcDb6YOcWEeiXP0+M++Ubt90BajQR?=
 =?iso-8859-15?Q?NzG7zDNpY7EICeKfLNpnvcgRsy92wcVzrNaxf8T4M3bn55ikEivRZzdcv?=
 =?iso-8859-15?Q?dGHqz/mLqOGImzNUCB55Ss/EsfEvGOuHWj8f851OdJ0Pd8OooezBl/wCA?=
 =?iso-8859-15?Q?QduFxf1gTxtv5y1jen6WUgSGQOFRph9+XF0njAjIPcfdZuSY5N+QSKxe0?=
 =?iso-8859-15?Q?AHf2?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b87d271f-0428-4383-ac34-08db61eab35c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 15:21:26.1942 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kFngpeDKu4kbcglX+YGbHE8bCNkY4aihdJ7OXT+yqeNg/+lpIMW36mkSYHUect7Yykl8S50yWxPjzyjDujLKyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8183
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: Re: [dm-devel] [PATCH 3/5] libmultipath: add ALUA tpg path wildcard
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
Content-ID: <8ED197CB064F0C488B863953280353D0@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-05-19 at 18:02 -0500, Benjamin Marzinski wrote:
> Make it possible to easily check a path's target port group.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
> =A0libmultipath/print.c | 9 +++++++++
> =A01 file changed, 9 insertions(+)
>=20
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 3193dbe0..360308d2 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -782,6 +782,14 @@ snprint_path_vpd_data(struct strbuf *buff, const
> struct path * pp)
> =A0=A0=A0=A0=A0=A0=A0=A0return append_strbuf_str(buff, "[undef]");
> =A0}
> =A0
> +static int
> +snprint_alua_tpg(struct strbuf *buff, const struct path * pp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0if (pp->tpg_id < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return append_strbuf_str(bu=
ff, "[undef]");
> +=A0=A0=A0=A0=A0=A0=A0return print_strbuf(buff, "0x%04x", pp->tpg_id);
> +}
> +
> =A0static const struct multipath_data mpd[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{'n', "name",=A0=A0=A0=A0=A0=A0=A0=A0=A0 snprint_=
name},
> =A0=A0=A0=A0=A0=A0=A0=A0{'w', "uuid",=A0=A0=A0=A0=A0=A0=A0=A0=A0 snprint_=
multipath_uuid},
> @@ -836,6 +844,7 @@ static const struct path_data pd[] =3D {
> =A0=A0=A0=A0=A0=A0=A0=A0{'P', "protocol",=A0=A0=A0=A0=A0 snprint_path_pro=
tocol},
> =A0=A0=A0=A0=A0=A0=A0=A0{'I', "init_st",=A0=A0=A0=A0=A0=A0 snprint_initia=
lized},
> =A0=A0=A0=A0=A0=A0=A0=A0{'L', "LUN hex",=A0=A0=A0=A0=A0=A0 snprint_path_l=
unhex},
> +=A0=A0=A0=A0=A0=A0=A0{'A', "TPG",=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 snprint_=
alua_tpg},
> =A0};
> =A0
> =A0static const struct pathgroup_data pgd[] =3D {

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

