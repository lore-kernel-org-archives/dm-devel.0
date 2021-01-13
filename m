Return-Path: <SRS0=kuEZ=GQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892B7C433E6
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 11:46:08 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id BCD82233ED
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 11:46:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BCD82233ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-XRv79XZ7OMCh1nK5aWgouw-1; Wed, 13 Jan 2021 06:46:04 -0500
X-MC-Unique: XRv79XZ7OMCh1nK5aWgouw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80F338145E0;
	Wed, 13 Jan 2021 11:45:59 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id DBCF71042A40;
	Wed, 13 Jan 2021 11:45:58 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5F8844A7C6;
	Wed, 13 Jan 2021 11:45:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10DBju7I025455 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Jan 2021 06:45:56 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id EAA6B2166B2B; Wed, 13 Jan 2021 11:45:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E4BB32166B2A
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 11:45:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C4B6800969
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 11:45:53 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-256-riytTRbeNF65aBJUmWgDkQ-1;
	Wed, 13 Jan 2021 06:45:51 -0500
X-MC-Unique: riytTRbeNF65aBJUmWgDkQ-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-33-p51fH0SbNxe9CMKHCPPwKQ-1; Wed, 13 Jan 2021 12:45:49 +0100
X-MC-Unique: p51fH0SbNxe9CMKHCPPwKQ-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7318.eurprd04.prod.outlook.com (2603:10a6:10:1ab::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10;
	Wed, 13 Jan 2021 11:45:48 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3742.012;
	Wed, 13 Jan 2021 11:45:48 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 3/3] multipathd: avoid io_err_stat ABBA deadlock
Thread-Index: AQHW6T4W7PGiLkl0wUybjsaV3jI5U6olcMeA
Date: Wed, 13 Jan 2021 11:45:48 +0000
Message-ID: <923b6228698abbd5ec368e9eea25a8013f01fc97.camel@suse.com>
References: <1610495575-8177-1-git-send-email-bmarzins@redhat.com>
	<1610495575-8177-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1610495575-8177-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 77f6a833-e893-43e2-4b2c-08d8b7b8c552
x-ms-traffictypediagnostic: DBAPR04MB7318:
x-microsoft-antispam-prvs: <DBAPR04MB7318EEAAF3527BFBD3FB1B2BFCA90@DBAPR04MB7318.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: A96tjKZ4hKni12iuiaQxpC0b75KV8wX1aqZJHfL00bAadPoJqnXcoCekGXLauV49lW46pidAF7mkvtg0oniTX2qlwOoQM/zCqDLmBbO3RsKwjWTILl36A2aYDKHkpFiOVV3Wl/xYYVQCvMO4y+ZLeXcdIMmAzWsEV2Ktz+VaxLW65Fs1KvKCzCNW36JqaCH1dvktKe0i8ayi9mVl/XHfROcdFCGy7yFkwIyO4tS+L04hv9WafYhgI/jKB4wcyq0BrYwl3Oqh3XSPE+RzzpzPRBk+pSbZaKT1FdiQHGmBrm+r7C1vze1QCwsO0zEYTRQNZRHxpvGCK1R7N/Uwu9kFg9mxjzvICkGi7Ou+gA7zjCkiqpMUnudKpTYNmrGLi+MnVvi+W0PB1YEd2HEna5forw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(366004)(396003)(39860400002)(136003)(346002)(71200400001)(6486002)(44832011)(26005)(110136005)(316002)(2616005)(36756003)(91956017)(66446008)(66556008)(66946007)(478600001)(76116006)(8936002)(5660300002)(2906002)(186003)(86362001)(4326008)(64756008)(6506007)(66574015)(8676002)(66476007)(83380400001)(6512007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?dODfLDWOkq9OUeqZsQvyPsE7t83OAjnqxvmTC8uKtmh4K4s9AvEk7LGvk?=
	=?iso-8859-15?Q?4m+mNun6LOQ8Qhj2EHO7ZGsdu02AkmEQzI7vIAHGYaqw6IV2JZXPA99U5?=
	=?iso-8859-15?Q?2K3/1tUo60+/gA1SrHT0qu1Iy158LAeth41bySSS6K8wuYb6ocnaSKk7E?=
	=?iso-8859-15?Q?mUDBCv6DNv/7DxFEPsAdtn+sd0nCNVnIKOoSI/vjQSEWHGFWghJBLjWad?=
	=?iso-8859-15?Q?hIijmG6XQsuJ5kLCDVhNGZkZezjo+ASGm6uU24em5h143anqwm3A37PRc?=
	=?iso-8859-15?Q?TCr/7Tpb6ihspYd0K/OPCcAuvtBd5xFuWZN7tYWC0bp2xzAKxSo6zcolq?=
	=?iso-8859-15?Q?IuGgXR73puS8FlybRmjk5XneqpoK0ULupDxHTs1WFgkhoZAkyuGYWnDEk?=
	=?iso-8859-15?Q?EyEQk5A/1keyzpqnodYkfJPVc8c1PjdwPDCcs8t29rGvRRFy1iSG+hw5G?=
	=?iso-8859-15?Q?y/K86eoG8FUhKtCE3sXjSFVeMYTXQ9FHEhzhx8/i2DIHzljV6RKyLDvyF?=
	=?iso-8859-15?Q?UOR4YozR9qbDN7joPfHVlVWhQma5vzH+6S8pWOvE8VEhI3sW42+PSTL2D?=
	=?iso-8859-15?Q?aE4v0k/lyQ5mrjo1qVpgACmwmsr1ZLdmGqbM7xpJl+CF5KQczrQlFZ0s4?=
	=?iso-8859-15?Q?K9xVZraww//gLC9AGRFwFZVUzmh11yGyid0tIDyHDBy8gFGNzBwioIjWy?=
	=?iso-8859-15?Q?9SHI1Ch2NMEQ6cn7LsYXZBFJKjSAam8e8ZXnLhDqwjz0sxWARPv1gA6d0?=
	=?iso-8859-15?Q?35tIMjFPG4fC/grn3CB7Ff4hhMZ41CI1Mou6mrzZC+PUf9tmKz2YiTcVU?=
	=?iso-8859-15?Q?Hq0iJpYhv82hpOv5nXpvw9PFgvnEQ69pXKpx3/EZzpNQsZcSg9Ano3Fww?=
	=?iso-8859-15?Q?fLwJFOyp7Q6lR7mxn5yCWQtheWsfCuZcq5PW7WESapKPnscEWoIHm42LF?=
	=?iso-8859-15?Q?R3wzxy92zEm7lLyD1e+gyokAZNcA63eaR4gXY2+vcWVbQyBzNqz5A2ICz?=
	=?iso-8859-15?Q?AF3or1ZhBoJHwULhNvN/z7n6L7xjWbZ0QNzr5loT62/QnUpprOM3Zu9?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f6a833-e893-43e2-4b2c-08d8b7b8c552
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 11:45:48.4815 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bVfR1cKIgIpc7XKuv9TtOiIbVWpq9P4U3n3oumSZLNF7LLUhsUbihmso+BJ1vpBs8bnGTQDfCt64M8IZgdVWSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7318
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10DBju7I025455
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 3/3] multipathd: avoid io_err_stat ABBA
	deadlock
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <10A3888CF1B1E444B5648715A013E76C@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-01-12 at 17:52 -0600, Benjamin Marzinski wrote:
> When the checker thread enqueues paths for the io_err_stat thread to
> check, it calls enqueue_io_err_stat_by_path() with the vecs lock
> held.
> start_io_err_stat_thread() is also called with the vecs lock held.
> These two functions both lock io_err_pathvec_lock. When the
> io_err_stat
> thread updates the paths in vecs->pathvec in poll_io_err_stat(), it
> has
> the io_err_pathvec_lock held, and then locks the vecs lock. This can
> cause an ABBA deadlock.
>=20
> To solve this, service_paths() no longer updates the paths in
> vecs->pathvec with the io_err_pathvec_lock held.=A0 It does this by
> moving
> the io_err_stat_path from io_err_pathvec to a local vector when it
> needs
> to update the path. After releasing the io_err_pathvec_lock, it goes
> through this temporary vector, updates the paths with the vecs lock
> held, and then frees everything.
>=20
> This change fixes a bug in service_paths() where elements were being
> deleted from io_err_pathvec, without the index being decremented,
> causing the loop to skip elements. Also, service_paths() could be
> cancelled while holding the io_err_pathvec_lock, so it should have a
> cleanup handler.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks good. Only two nits below.

> ---
> =A0libmultipath/io_err_stat.c | 55 +++++++++++++++++++++---------------
> --
> =A01 file changed, 31 insertions(+), 24 deletions(-)
>=20
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index 4c6f7f08..a222594e 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -385,20 +385,6 @@ recover:
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> -static int delete_io_err_stat_by_addr(struct io_err_stat_path *p)
> -{
> -=A0=A0=A0=A0=A0=A0=A0int i;
> -
> -=A0=A0=A0=A0=A0=A0=A0i =3D find_slot(io_err_pathvec, p);
> -=A0=A0=A0=A0=A0=A0=A0if (i !=3D -1)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_del_slot(io_err_path=
vec, i);
> -
> -=A0=A0=A0=A0=A0=A0=A0destroy_directio_ctx(p);
> -=A0=A0=A0=A0=A0=A0=A0free_io_err_stat_path(p);
> -
> -=A0=A0=A0=A0=A0=A0=A0return 0;
> -}
> -
> =A0static void account_async_io_state(struct io_err_stat_path *pp, int
> rc)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0switch (rc) {
> @@ -415,17 +401,26 @@ static void account_async_io_state(struct
> io_err_stat_path *pp, int rc)
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0}
> =A0
> -static int poll_io_err_stat(struct vectors *vecs, struct
> io_err_stat_path *pp)
> +static int io_err_stat_time_up(struct io_err_stat_path *pp)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct timespec currtime, difftime;
> -=A0=A0=A0=A0=A0=A0=A0struct path *path;
> -=A0=A0=A0=A0=A0=A0=A0double err_rate;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (clock_gettime(CLOCK_MONOTONIC, &currtime) !=
=3D 0)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;

This can't fail. Please change it to get_monotonic_time().

> =A0=A0=A0=A0=A0=A0=A0=A0timespecsub(&currtime, &pp->start_time, &difftime=
);
> =A0=A0=A0=A0=A0=A0=A0=A0if (difftime.tv_sec < pp->total_time)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0return 1;
> +}
> +
> +static void end_io_err_stat(struct io_err_stat_path *pp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct timespec currtime;
> +=A0=A0=A0=A0=A0=A0=A0struct path *path;
> +=A0=A0=A0=A0=A0=A0=A0double err_rate;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (clock_gettime(CLOCK_MONOTONIC, &currtime) !=3D =
0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0currtime =3D pp->start_time=
;

See above.


> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0io_err_stat_log(4, "%s: check end", pp->devname);
> =A0
> @@ -464,10 +459,6 @@ static int poll_io_err_stat(struct vectors
> *vecs, struct io_err_stat_path *pp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0pp->devname);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0lock_cleanup_pop(vecs->lock);
> -
> -=A0=A0=A0=A0=A0=A0=A0delete_io_err_stat_by_addr(pp);
> -
> -=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> =A0static int send_each_async_io(struct dio_ctx *ct, int fd, char *dev)
> @@ -639,17 +630,33 @@ static void process_async_ios_event(int
> timeout_nsecs, char *dev)
> =A0
> =A0static void service_paths(void)
> =A0{
> +=A0=A0=A0=A0=A0=A0=A0struct _vector _pathvec =3D {0};
> +=A0=A0=A0=A0=A0=A0=A0/* avoid gcc warnings that &_pathvec will never be =
NULL in
> vector ops */
> +=A0=A0=A0=A0=A0=A0=A0vector tmp_pathvec =3D &_pathvec;
> =A0=A0=A0=A0=A0=A0=A0=A0struct io_err_stat_path *pp;
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&io_err_pathvec_lock);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_unlock, &io_err_pathve=
c_lock);
> =A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(io_err_pathvec, pp, i) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0send_batch_async_ios(pp);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0process_async_ios_event(T=
IMEOUT_NO_IO_NSEC, pp-
> >devname);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0poll_async_io_timeout();
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0poll_io_err_stat(vecs, pp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (io_err_stat_time_up(pp)=
) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(!vector_alloc_slot(tmp_pathvec))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0continue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vec=
tor_del_slot(io_err_pathvec, i--);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vec=
tor_set_slot(tmp_pathvec, pp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&io_err_pathvec_lock);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot_backwards(tmp_pathvec, pp, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0end_io_err_stat(pp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_del_slot(tmp_pathvec=
, i);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0destroy_directio_ctx(pp);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free_io_err_stat_path(pp);
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0vector_reset(tmp_pathvec);
> =A0}
> =A0
> =A0static void cleanup_exited(__attribute__((unused)) void *arg)

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

