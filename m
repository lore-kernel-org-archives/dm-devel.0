Return-Path: <SRS0=kuEZ=GQ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FC81C433DB
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 11:46:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5F44E233ED
	for <dm-devel@archiver.kernel.org>; Wed, 13 Jan 2021 11:46:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F44E233ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-oTZEnng9MLWw929-L3xVnQ-1; Wed, 13 Jan 2021 06:46:01 -0500
X-MC-Unique: oTZEnng9MLWw929-L3xVnQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B4C880667C;
	Wed, 13 Jan 2021 11:45:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id EE60260C69;
	Wed, 13 Jan 2021 11:45:55 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 19CE14BB7B;
	Wed, 13 Jan 2021 11:45:53 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 10DBjofT025445 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 13 Jan 2021 06:45:50 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 500122026D46; Wed, 13 Jan 2021 11:45:50 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 49C8F2026D49
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 11:45:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 71E89185A7BC
	for <dm-devel@redhat.com>; Wed, 13 Jan 2021 11:45:47 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [194.104.109.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-388-ilwfxqYtOSefeeLfA4DozA-1;
	Wed, 13 Jan 2021 06:45:45 -0500
X-MC-Unique: ilwfxqYtOSefeeLfA4DozA-1
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
	(mail-db3eur04lp2053.outbound.protection.outlook.com [104.47.12.53])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-23-Fna8dDtGPBer_aQVyCJ9Gw-1; Wed, 13 Jan 2021 12:45:42 +0100
X-MC-Unique: Fna8dDtGPBer_aQVyCJ9Gw-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DBAPR04MB7318.eurprd04.prod.outlook.com (2603:10a6:10:1ab::14)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10;
	Wed, 13 Jan 2021 11:45:41 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6]) by DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::c1ce:f675:7:30f6%3]) with mapi id 15.20.3742.012;
	Wed, 13 Jan 2021 11:45:41 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 2/3] multipathd: avoid io_err_stat crash during shutdown
Thread-Index: AQHW6T4Ww+TnLDoS3UO24MCTPd5AdaolcL8A
Date: Wed, 13 Jan 2021 11:45:41 +0000
Message-ID: <c7c2c7f15a236c117498b7c04978bd7413bd6f6b.camel@suse.com>
References: <1610495575-8177-1-git-send-email-bmarzins@redhat.com>
	<1610495575-8177-3-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1610495575-8177-3-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.2
x-originating-ip: [2.203.204.191]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47b52fc6-3caa-413c-503c-08d8b7b8c116
x-ms-traffictypediagnostic: DBAPR04MB7318:
x-microsoft-antispam-prvs: <DBAPR04MB731806848619A143299C0BC9FCA90@DBAPR04MB7318.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: bB8myr+WwzcNyOGk3T3eq5esm0A95a8keEii7OANcfDUIUM70SmrncFRzN82jgA9bu1Ia+PUfnFm8Yk3sKbBAJEnjStiIA4G6744RDWFstpZTOKA+29wSvXF/Wzehw8YafXTmRO2i7adJx7a/mJ/qRVXSByLQH4KAccyMP+LJS4pu1fNSDFvEMH68hLvKL7XW+5J76FF0BCX8gUCVsKDJ2K+LAIQ7s7FN7PK/cz8ToV8EpObO0+a4B7x2Qa3er8EFY/8kGw07/n8CU3Cy8vCj5WWFMP5yLaKT2Vt/yTJ3tqdWt9eJRoKO44WU5pL5LMv3V/kRccH4UP1d+oEHzrkoLhCr1RCsU5LWn5uQFhMa1PzLyrG6f3/Ha8Jrl7f76ENUX4BkCX6uwaX+Dp4M2NGcQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(376002)(366004)(396003)(39860400002)(136003)(346002)(71200400001)(6486002)(44832011)(26005)(110136005)(316002)(2616005)(36756003)(91956017)(66446008)(66556008)(66946007)(478600001)(76116006)(8936002)(5660300002)(2906002)(186003)(86362001)(4326008)(64756008)(6506007)(66574015)(8676002)(66476007)(83380400001)(6512007);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-15?Q?uhm9H3N2bC5NTHIEwUVQcjTIPxbkizyeorqbYM5s0Y9yiELoSECIxrchf?=
	=?iso-8859-15?Q?IgWceR2bFK9zUFpYMXuxAIueq8ysC61ob0eQWpFH9YhLNrjrKgQnFkpHo?=
	=?iso-8859-15?Q?luaF3pbCsbEYxJfnURd8SF21KNFcDnA+5J+qZOtCqRsOmfzJWjSxS3R8y?=
	=?iso-8859-15?Q?O4gDquwFy/yjqLsBhYlWir3gQ+mlwajvNLcz7XgR7kmzes7l4Vnb22LED?=
	=?iso-8859-15?Q?1gzx2mGiWhVdGk+LhWb4CyfkHocGl3cpgeEObhy4t1e2xa5B8d0FKxPuW?=
	=?iso-8859-15?Q?HLPMsogvzLbreDlp0hnGkZ9gAgh5E1LOlJgE56zCoPci2Dm4y7FYZFmvR?=
	=?iso-8859-15?Q?vBMJSAunNZbQh1Y9GGr4VlankW9CCUZGT8hc9Fknwro4XVLMgIzDn1aNn?=
	=?iso-8859-15?Q?cEdJQjpF7mvMmsZX/bvEIhS6t33pe+vRt/yya83vLTbgVJTSU9BcrvIfB?=
	=?iso-8859-15?Q?54ds75Ce2X+c50xNiYQY5dmSoyG9+OOGZaZeMeXGCk61cfhQqvfoKhB7M?=
	=?iso-8859-15?Q?DoUvRrXHv824uHt/87TEupXrh9xb5DXEjer0Dox7pvG1tPGf1ezVfgva0?=
	=?iso-8859-15?Q?ypypst2W1PYCk4fSK7pFEQrV2smKw3pCB9zmcxQ5pSFgIP0VE/W9eW3ch?=
	=?iso-8859-15?Q?oLZf+0e0E2suDC91UHthJfmzH+BOa/io3gNvQMdj+nOfiL79oZHnmbQzw?=
	=?iso-8859-15?Q?n3K6xbYfhYMBBy+ihonoVfGoneNFxoraEL90F+1JwZd/bbE8Z1y0ex7I9?=
	=?iso-8859-15?Q?SMYizng0g5jPjbIaA5li03ot/Jk5sWOOCs0zPB05+msAihjaBLc5oINkD?=
	=?iso-8859-15?Q?OLbKzk1tZH4q3mxQGF4z2E/gxpohFveWIgs+OTXQ5WoSpRv/bpJGYMyi/?=
	=?iso-8859-15?Q?x/TlzYdRC3vFIO9HZX8yhgLm93dcXFc0rLgIgsLRuFkSVVF3YuEhM/qn8?=
	=?iso-8859-15?Q?J8vkjP7PMY56fEZMJYlZOqLjgNVrRorB9DRlZo1ycXswTZppQdW6RWFjw?=
	=?iso-8859-15?Q?iyUtzDrRlyZVzqwU9wE47Xbzg2wAMiyA7zVd+hQAMIm/bWKxcOem64I?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47b52fc6-3caa-413c-503c-08d8b7b8c116
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jan 2021 11:45:41.3666 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T3M1sKdqBKVMai3GbnyknGs9TNliFB6CnYEb6zBCC32n1qIYpcoIRbcNa1Z5LjMu3t4CBjY+wW0fUsExlRJYxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7318
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 10DBjofT025445
X-loop: dm-devel@redhat.com
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/3] multipathd: avoid io_err_stat crash
	during shutdown
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
Content-ID: <37965F158E152946AFE0C51489A36EA3@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2021-01-12 at 17:52 -0600, Benjamin Marzinski wrote:
> The checker thread is reponsible for enqueueing paths for the
> io_err_stat thread to check. During shutdown, the io_err_stat thread
> is
> shut down and cleaned up before the checker thread.=A0 There is no code
> to make sure that the checker thread isn't accessing the io_err_stat
> pathvec or its mutex while they are being freed, which can lead to
> memory corruption crashes.
>=20
> To solve this, get rid of the io_err_stat_pathvec structure, and
> statically define the mutex.=A0 This means that the mutex is always
> valid
> to access, and the io_err_stat pathvec can only be accessed while
> holding it.=A0 If the io_err_stat thread has already been cleaned up
> when the checker tries to access the pathvec, it will be NULL, and
> the
> checker will simply fail to enqueue the path.
>=20
> This change also fixes a bug in free_io_err_pathvec(), which
> previously
> only attempted to free the pathvec if it was not set, instead of when
> it
> was set.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks good to me. A few minor notes below.

Regards,
Martin



> ---
> =A0libmultipath/io_err_stat.c | 108 +++++++++++++++--------------------
> --
> =A01 file changed, 44 insertions(+), 64 deletions(-)
>=20
> diff --git a/libmultipath/io_err_stat.c b/libmultipath/io_err_stat.c
> index 2e48ee81..4c6f7f08 100644
> --- a/libmultipath/io_err_stat.c
> +++ b/libmultipath/io_err_stat.c
> @@ -46,12 +46,6 @@
> =A0#define io_err_stat_log(prio, fmt, args...) \
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(prio, "io error statistic: " fmt, ##args)
> =A0
> -
> -struct io_err_stat_pathvec {
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_t mutex;
> -=A0=A0=A0=A0=A0=A0=A0vector=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pathvec;
> -};
> -
> =A0struct dio_ctx {
> =A0=A0=A0=A0=A0=A0=A0=A0struct timespec=A0io_starttime;
> =A0=A0=A0=A0=A0=A0=A0=A0unsigned int=A0=A0=A0=A0blksize;
> @@ -75,9 +69,10 @@ static pthread_t=A0=A0=A0=A0=A0io_err_stat_thr;
> =A0
> =A0static pthread_mutex_t io_err_thread_lock =3D
> PTHREAD_MUTEX_INITIALIZER;
> =A0static pthread_cond_t io_err_thread_cond =3D PTHREAD_COND_INITIALIZER;
> +static pthread_mutex_t io_err_pathvec_lock =3D
> PTHREAD_MUTEX_INITIALIZER;
> =A0static int io_err_thread_running =3D 0;
> =A0
> -static struct io_err_stat_pathvec *paths;
> +static vector io_err_pathvec;
> =A0struct vectors *vecs;
> =A0io_context_t=A0=A0=A0ioctx;
> =A0
> @@ -207,46 +202,28 @@ static void free_io_err_stat_path(struct
> io_err_stat_path *p)
> =A0=A0=A0=A0=A0=A0=A0=A0FREE(p);
> =A0}
> =A0
> -static struct io_err_stat_pathvec *alloc_pathvec(void)
> +static void cleanup_unlock(void *arg)

Nitpick: we've got the cleanup_mutex() utility function for this now.

> =A0{
> -=A0=A0=A0=A0=A0=A0=A0struct io_err_stat_pathvec *p;
> -=A0=A0=A0=A0=A0=A0=A0int r;
> -
> -=A0=A0=A0=A0=A0=A0=A0p =3D (struct io_err_stat_pathvec *)MALLOC(sizeof(*=
p));
> -=A0=A0=A0=A0=A0=A0=A0if (!p)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> -=A0=A0=A0=A0=A0=A0=A0p->pathvec =3D vector_alloc();
> -=A0=A0=A0=A0=A0=A0=A0if (!p->pathvec)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out_free_struct_pathve=
c;
> -=A0=A0=A0=A0=A0=A0=A0r =3D pthread_mutex_init(&p->mutex, NULL);
> -=A0=A0=A0=A0=A0=A0=A0if (r)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out_free_member_pathve=
c;
> -
> -=A0=A0=A0=A0=A0=A0=A0return p;
> -
> -out_free_member_pathvec:
> -=A0=A0=A0=A0=A0=A0=A0vector_free(p->pathvec);
> -out_free_struct_pathvec:
> -=A0=A0=A0=A0=A0=A0=A0FREE(p);
> -=A0=A0=A0=A0=A0=A0=A0return NULL;
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock((pthread_mutex_t*) arg);
> =A0}
> =A0
> -static void free_io_err_pathvec(struct io_err_stat_pathvec *p)
> +static void free_io_err_pathvec(void)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct io_err_stat_path *path;
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0if (!p)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_destroy(&p->mutex);
> -=A0=A0=A0=A0=A0=A0=A0if (!p->pathvec) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(p->path=
vec, path, i) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0des=
troy_directio_ctx(path);
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fre=
e_io_err_stat_path(path);

Note: We should call destroy_directio_ctx() (only) from
free_io_err_stat_path().

> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_free(p->pathvec);
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&io_err_pathvec_lock);
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_push(cleanup_unlock, &io_err_pathve=
c_lock);
> +=A0=A0=A0=A0=A0=A0=A0if (!io_err_pathvec)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(io_err_pathvec, path, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0destroy_directio_ctx(path);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free_io_err_stat_path(path)=
;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0FREE(p);
> +=A0=A0=A0=A0=A0=A0=A0vector_free(io_err_pathvec);
> +=A0=A0=A0=A0=A0=A0=A0io_err_pathvec =3D NULL;
> +out:
> +=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> =A0}
> =A0
> =A0/*
> @@ -258,13 +235,13 @@ static int enqueue_io_err_stat_by_path(struct
> path *path)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0struct io_err_stat_path *p;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&paths->mutex);
> -=A0=A0=A0=A0=A0=A0=A0p =3D find_err_path_by_dev(paths->pathvec, path->de=
v);
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&io_err_pathvec_lock);
> +=A0=A0=A0=A0=A0=A0=A0p =3D find_err_path_by_dev(io_err_pathvec, path->de=
v);
> =A0=A0=A0=A0=A0=A0=A0=A0if (p) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&paths=
->mutex);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&io_er=
r_pathvec_lock);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&paths->mutex);
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&io_err_pathvec_lock);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0p =3D alloc_io_err_stat_path();
> =A0=A0=A0=A0=A0=A0=A0=A0if (!p)
> @@ -276,18 +253,18 @@ static int enqueue_io_err_stat_by_path(struct
> path *path)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (setup_directio_ctx(p))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto free_ioerr_path;
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&paths->mutex);
> -=A0=A0=A0=A0=A0=A0=A0if (!vector_alloc_slot(paths->pathvec))
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&io_err_pathvec_lock);
> +=A0=A0=A0=A0=A0=A0=A0if (!vector_alloc_slot(io_err_pathvec))
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto unlock_destroy;
> -=A0=A0=A0=A0=A0=A0=A0vector_set_slot(paths->pathvec, p);
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&paths->mutex);
> +=A0=A0=A0=A0=A0=A0=A0vector_set_slot(io_err_pathvec, p);
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&io_err_pathvec_lock);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0io_err_stat_log(2, "%s: enqueue path %s to check"=
,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0p=
ath->mpp->alias, path->dev);

Another note: This is not a level 2 log message. IMO the log levels of
the io_err_stat code are generally too "low"; the only messages we want
to see at 2 would be if a path's "marginal" status changes. Internals
of the algorithm should log at level 3 and 4.

> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> =A0unlock_destroy:
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&paths->mutex);
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&io_err_pathvec_lock);
> =A0=A0=A0=A0=A0=A0=A0=A0destroy_directio_ctx(p);
> =A0free_ioerr_path:
> =A0=A0=A0=A0=A0=A0=A0=A0free_io_err_stat_path(p);
> @@ -412,9 +389,9 @@ static int delete_io_err_stat_by_addr(struct
> io_err_stat_path *p)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0i =3D find_slot(paths->pathvec, p);
> +=A0=A0=A0=A0=A0=A0=A0i =3D find_slot(io_err_pathvec, p);
> =A0=A0=A0=A0=A0=A0=A0=A0if (i !=3D -1)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_del_slot(paths->path=
vec, i);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_del_slot(io_err_path=
vec, i);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0destroy_directio_ctx(p);
> =A0=A0=A0=A0=A0=A0=A0=A0free_io_err_stat_path(p);
> @@ -585,7 +562,7 @@ static void poll_async_io_timeout(void)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (clock_gettime(CLOCK_MONOTONIC, &curr_time) !=
=3D 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> -=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(paths->pathvec, pp, i) {
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(io_err_pathvec, pp, i) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0for (j =3D 0; j < CONCUR_=
NR_EVENT; j++) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
c =3D try_to_cancel_timeout_io(pp-
> >dio_ctx_array + j,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0&curr_time, pp->devname);
> @@ -631,7 +608,7 @@ static void handle_async_io_done_event(struct
> io_event *io_evt)
> =A0=A0=A0=A0=A0=A0=A0=A0int rc =3D PATH_UNCHECKED;
> =A0=A0=A0=A0=A0=A0=A0=A0int i, j;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(paths->pathvec, pp, i) {
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(io_err_pathvec, pp, i) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0for (j =3D 0; j < CONCUR_=
NR_EVENT; j++) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
t =3D pp->dio_ctx_array + j;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0i=
f (&ct->io =3D=3D io_evt->obj) {
> @@ -665,19 +642,14 @@ static void service_paths(void)
> =A0=A0=A0=A0=A0=A0=A0=A0struct io_err_stat_path *pp;
> =A0=A0=A0=A0=A0=A0=A0=A0int i;
> =A0
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&paths->mutex);
> -=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(paths->pathvec, pp, i) {
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&io_err_pathvec_lock);
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(io_err_pathvec, pp, i) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0send_batch_async_ios(pp);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0process_async_ios_event(T=
IMEOUT_NO_IO_NSEC, pp-
> >devname);

We should actually use pthread_cleanup_push() here (update: I see you
changed this in patch 3/3). We should also call pthread_testcancel()
before calling io_getevents(), which is not cancellation point but
might block.

> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0poll_async_io_timeout();
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0poll_io_err_stat(vecs, pp=
);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&paths->mutex);
> -}
> -
> -static void cleanup_unlock(void *arg)
> -{
> -=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock((pthread_mutex_t*) arg);
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&io_err_pathvec_lock);
> =A0}
> =A0
> =A0static void cleanup_exited(__attribute__((unused)) void *arg)
> @@ -736,9 +708,14 @@ int start_io_err_stat_thread(void *data)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0io_err_stat_log(4, "io_se=
tup failed");
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> -=A0=A0=A0=A0=A0=A0=A0paths =3D alloc_pathvec();
> -=A0=A0=A0=A0=A0=A0=A0if (!paths)
> +
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&io_err_pathvec_lock);
> +=A0=A0=A0=A0=A0=A0=A0io_err_pathvec =3D vector_alloc();
> +=A0=A0=A0=A0=A0=A0=A0if (!io_err_pathvec) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&io_er=
r_pathvec_lock);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto destroy_ctx;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&io_err_pathvec_lock);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0setup_thread_attr(&io_err_stat_attr, 32 * 1024, 0=
);
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&io_err_thread_lock);
> @@ -763,7 +740,10 @@ int start_io_err_stat_thread(void *data)
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0
> =A0out_free:
> -=A0=A0=A0=A0=A0=A0=A0free_io_err_pathvec(paths);
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_lock(&io_err_pathvec_lock);
> +=A0=A0=A0=A0=A0=A0=A0vector_free(io_err_pathvec);
> +=A0=A0=A0=A0=A0=A0=A0io_err_pathvec =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0pthread_mutex_unlock(&io_err_pathvec_lock);
> =A0destroy_ctx:
> =A0=A0=A0=A0=A0=A0=A0=A0io_destroy(ioctx);
> =A0=A0=A0=A0=A0=A0=A0=A0io_err_stat_log(0, "failed to start io_error stat=
istic
> thread");
> @@ -779,6 +759,6 @@ void stop_io_err_stat_thread(void)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0pthread_cancel(io_err_sta=
t_thr);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_join(io_err_stat_thr, NULL);
> -=A0=A0=A0=A0=A0=A0=A0free_io_err_pathvec(paths);
> +=A0=A0=A0=A0=A0=A0=A0free_io_err_pathvec();
> =A0=A0=A0=A0=A0=A0=A0=A0io_destroy(ioctx);
> =A0}

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel.=A0+49 (0)911 74053 2107
SUSE Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

