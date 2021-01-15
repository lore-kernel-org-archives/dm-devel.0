Return-Path: <SRS0=Ey+N=GS=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF21C433DB
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 13:55:33 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id D71A3208E4
	for <dm-devel@archiver.kernel.org>; Fri, 15 Jan 2021 13:55:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D71A3208E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-_ZYYiklyMNaF8fmp0HN4cw-1; Fri, 15 Jan 2021 08:55:29 -0500
X-MC-Unique: _ZYYiklyMNaF8fmp0HN4cw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FAD4190A7A0;
	Fri, 15 Jan 2021 13:55:24 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BE89260BF3;
	Fri, 15 Jan 2021 13:55:22 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id DE62C4BB7B;
	Fri, 15 Jan 2021 13:55:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10FDtHtG024826 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 15 Jan 2021 08:55:17 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 8AFA12166B2C; Fri, 15 Jan 2021 13:55:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 84A2C2166B2A
	for <dm-devel@redhat.com>; Fri, 15 Jan 2021 13:55:15 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 387D5101A579
	for <dm-devel@redhat.com>; Fri, 15 Jan 2021 13:55:15 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-435-F28-DtzGNBuaIUkL5ZZgow-1;
	Fri, 15 Jan 2021 08:55:13 -0500
X-MC-Unique: F28-DtzGNBuaIUkL5ZZgow-1
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
	(mail-db5eur03lp2050.outbound.protection.outlook.com [104.47.10.50])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-21-NuqMsuHAN1a6-fF6HGFFKQ-1; Fri, 15 Jan 2021 14:55:10 +0100
X-MC-Unique: NuqMsuHAN1a6-fF6HGFFKQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7317.eurprd04.prod.outlook.com (2603:10a6:10:1b3::15)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9;
	Fri, 15 Jan 2021 13:55:09 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3763.011;
	Fri, 15 Jan 2021 13:55:09 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 6/6] multipathd: cleanup logging for marginal paths
Thread-Index: AQHW6uUJA+wlLbm5f0CHXB2lpQQTeaootkcA
Date: Fri, 15 Jan 2021 13:55:09 +0000
Message-ID: <ee9749b44993cc007d0657488c98617fe69e4058.camel@suse.com>
References: <1610677227-23550-1-git-send-email-bmarzins@redhat.com>
	<1610677227-23550-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1610677227-23550-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9d6567c4-0eaa-4c61-ce88-08d8b95d2c16
x-ms-traffictypediagnostic: DBAPR04MB7317:
x-microsoft-antispam-prvs: <DBAPR04MB73173231FC4E966B7D9F8352FCA70@DBAPR04MB7317.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:168
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: MqNuszAoZf9QFQwy9XNorcn7RVOOWwaLGkVDMMli5YhY4ZOa8Tzsx3712ysPOnZeYaWCeehGmtVJRa136Hl+TAxYNZZrlemmr6gWKb9xw0bRC3u+sikpQofxWCVqVtxxdioTh+jxwUhk4ymexXvxoBxLynYZaGa41kUUg31ii77srIRo+6aNkUF+ECtg14Jnjg2kaEsf0rt095BERQH+FqGLMjWKdvN92cKIatLnxA3/DWN9Oc7gf/+nll4uKBGba3efoeS1H8WBbV+cCh4rYkm4i9zxjP2jboK+tDuBKybasfkJV2nyzsvDzFCcsliJs91XkIxMj1OWa5eriZoVA8LaQQNsBK5f9dpTkZEfqBrO3MmYbqLDTACgnWH6gUGXKnObl8v5Xb0CrRDFrYnmCQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(366004)(396003)(136003)(346002)(39860400002)(376002)(478600001)(36756003)(6486002)(8936002)(8676002)(110136005)(71200400001)(6512007)(44832011)(4326008)(66476007)(2906002)(2616005)(76116006)(66556008)(66946007)(83380400001)(186003)(316002)(5660300002)(66446008)(64756008)(66574015)(91956017)(26005)(6506007)(86362001);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?qnr0xwlOtDmh5PZvmv4QJK9pKiBvhYsn2IDKwp52uDZu2Dslagkop+EmB?=
	=?iso-8859-15?Q?ycz2bknNhwCMbTp3bbDikmSkici85/q5NQj+FAK7cgkRRp5Lr7SH33vcq?=
	=?iso-8859-15?Q?RR4p5HNOS+9fdTUkOcaNey+QxBZt9KOFdkrNMqqJMI9zA5Z7Ee3uF/Oa6?=
	=?iso-8859-15?Q?Y6IpdLGObdeGekL6BqAVbAVFmOrgAjn9lk5UtcONfV/2h+0lsvrcFdBxC?=
	=?iso-8859-15?Q?jzSwXKCxU+ainlp1cn6NIV0BknuMU8eQ/5gVlQM2ECWvBqUNsaVEcfztp?=
	=?iso-8859-15?Q?McswgBLVrz2GoI/wOEXYb6JxF28xBoZ4MlFU8B9qhHWjP+vZl5SvL3Uc/?=
	=?iso-8859-15?Q?1oltWVM/e3agTeXyY6hnJgoVich3qlkJphP8xdQBqFDnbsu/3TSqu0J+A?=
	=?iso-8859-15?Q?sBNKHtDo1FESd9l/fOAsE00FrDn4EKf7PC+i06son9nLfO1yBbDCuRi6L?=
	=?iso-8859-15?Q?mAxSZGUQzgBAaR5hgAVf927DVZ0igNq2RJFrUnbuyByIjY8Zy2jYBYlI3?=
	=?iso-8859-15?Q?+uhk8/mKSkwaSgicXxuStDTcoEdaUEGKJQTeJbFR+pUvGNU2q6j0XYImi?=
	=?iso-8859-15?Q?A2Np5aCwgB/soFUwOz6XgbAvzI0NtFm1OODBAChjzfmqRB1PYOXZnjrFD?=
	=?iso-8859-15?Q?7Og5++u/a2lIbhHyY94ETihhItLjtLaQtwBTVZqzygVDxhM838tYFr9Df?=
	=?iso-8859-15?Q?22Tge1tHOw0XmYWxL7ekDXrYu88MLGvcA/03DfVufUKNmm5PxProhn875?=
	=?iso-8859-15?Q?yfvTgG0GC9f86rBQDUz5TPK+S7Yuhjhh0w5NKoeF4BuXXSXBlNwMfyDw3?=
	=?iso-8859-15?Q?+SXzJc+Xh0C/i5av2bZK5Koi1Rt5V/WvKBOr8LSG3TYdfL8QwaNx86iQd?=
	=?iso-8859-15?Q?8WL1LhnHqXoCHu3//ZjaZcYvDuA/7+oXuluMY1HERpadBa56OU53/s0Zb?=
	=?iso-8859-15?Q?QJ2LXzWLSg+bIPOm9froJAGd+dEiwQ+Q+b4gJBKoN2JBa98229s/Yp1F2?=
	=?iso-8859-15?Q?Y6xr8tN9T/l1uf1BkjFOy7oPB3t2de3pFupGHI368NpCZbOC3xlmPNN?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d6567c4-0eaa-4c61-ce88-08d8b95d2c16
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2021 13:55:09.4675 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CLH+Nh6hS6pDLDLxggYYSlw5/GffxcCxV3v7nDOJBcU9eelVIdeD6UHZPWZjRgLLI3wZnhThKRM36uSZ6fnHoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7317
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10FDtHtG024826
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH v2 6/6] multipathd: cleanup logging for
	marginal paths
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <D7B9F2EB8FEA4F468B1E6A705928FA2B@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Thu, 2021-01-14 at 20:20 -0600, Benjamin Marzinski wrote:
> io_err_stat logged at level 2 whenever it enqueued a path to check,
> which could happen multiple times while a path was marginal.=A0 On the
> other hand if marginal_pathgroups wasn't set, multipathd didn't log
> when
> paths were set to marginal. Now io_err_stat only logs at level 2 when
> something unexpected happens, but multipathd will always log when a
> path switches its marginal state.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
> =A0libmultipath/io_err_stat.c |=A0 7 +++----
> =A0multipathd/main.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 25 ++++++++++++++------=
-----
> =A02 files changed, 17 insertions(+), 15 deletions(-)
>=20
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index bf78a236..abdd0b4f 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -252,7 +252,7 @@ static int enqueue_io_err_stat_by_path(struct
> path *path)
> =A0=A0=A0=A0=A0=A0=A0=A0vector_set_slot(io_err_pathvec, p);
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&io_err_pathvec_lock);
> =A0
> -=A0=A0=A0=A0=A0=A0=A0io_err_stat_log(2, "%s: enqueue path %s to check",
> +=A0=A0=A0=A0=A0=A0=A0io_err_stat_log(3, "%s: enqueue path %s to check",
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
ath->mpp->alias, path->dev);
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> @@ -343,7 +343,7 @@ int need_io_err_check(struct path *pp)
> =A0=A0=A0=A0=A0=A0=A0=A0if (uatomic_read(&io_err_thread_running) =3D=3D 0=
)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0=A0=A0=A0=A0=A0=A0=A0if (count_active_paths(pp->mpp) <=3D 0) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0io_err_stat_log(2, "%s: rec=
over path early", pp-
> >dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0io_err_stat_log(2, "%s: no =
paths. recovering early",
> pp->dev);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto recover;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0if (pp->io_err_pathfail_cnt !=3D PATH_IO_ERR_WAIT=
ING_TO_CHECK)
> @@ -361,8 +361,7 @@ int need_io_err_check(struct path *pp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 * Or else,=A0 return 1 t=
o set path state to PATH_SHAKY
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 */
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (r =3D=3D 1) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0io_=
err_stat_log(3, "%s: enqueue fails, to
> recover",
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pp->dev);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0io_=
err_stat_log(2, "%s: enqueue failed.
> recovering early", pp->dev);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto recover;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0} else
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
p->io_err_pathfail_cnt =3D
> PATH_IO_ERR_IN_CHECKING;
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 92c45d44..99a89a69 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -2132,8 +2132,8 @@ check_path (struct vectors * vecs, struct path
> * pp, unsigned int ticks)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pathinfo(pp, conf, 0);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> -=A0=A0=A0=A0=A0=A0=A0} else if ((newstate !=3D PATH_UP && newstate !=3D =
PATH_GHOST) &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(pp=
->state =3D=3D PATH_DELAYED)) {
> +=A0=A0=A0=A0=A0=A0=A0} else if ((newstate !=3D PATH_UP && newstate !=3D =
PATH_GHOST &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 newstate !=3D PAT=
H_PENDING) && (pp->state =3D=3D
> PATH_DELAYED)) {

I think this is correct, but it needs to  be mentioned in the commit
message (or go into a separate patch).

Regards,
Martin


--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

