Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C605C433EF
	for <dm-devel@archiver.kernel.org>; Thu, 14 Apr 2022 07:28:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-ahgEvSnmM8-I3u4Y5q-0SQ-1; Thu, 14 Apr 2022 03:28:12 -0400
X-MC-Unique: ahgEvSnmM8-I3u4Y5q-0SQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 31EA13C01B82;
	Thu, 14 Apr 2022 07:28:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EE31B7774;
	Thu, 14 Apr 2022 07:28:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0D8F11940345;
	Thu, 14 Apr 2022 07:28:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 393FE1940344
 for <dm-devel@listman.corp.redhat.com>; Thu, 14 Apr 2022 07:28:05 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E03F640D2848; Thu, 14 Apr 2022 07:28:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DAD9440D282D
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 07:28:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B71B4185A7B2
 for <dm-devel@redhat.com>; Thu, 14 Apr 2022 07:28:04 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
 (de-smtp-delivery-102.mimecast.com [194.104.109.102]) by relay.mimecast.com
 with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-u_Pp8Z6eO_2K0Ze0imY2jA-1; Thu, 14 Apr 2022 03:28:02 -0400
X-MC-Unique: u_Pp8Z6eO_2K0Ze0imY2jA-1
Received: from EUR03-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur03lp2050.outbound.protection.outlook.com [104.47.8.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-39-VlAJNeuvOxuhB5lYMdEe7g-1; Thu, 14 Apr 2022 09:28:00 +0200
X-MC-Unique: VlAJNeuvOxuhB5lYMdEe7g-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
 by AM6PR04MB4296.eurprd04.prod.outlook.com (2603:10a6:209:50::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 07:27:59 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104]) by DB8PR04MB6555.eurprd04.prod.outlook.com
 ([fe80::a0b0:acf9:ab24:1104%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 07:27:59 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH v2 3/7] libmultipath: add a protocol subsection to
 multipath.conf
Thread-Index: AQHYT9EqcSnz75z3+k2AnKR1vLeofw==
Date: Thu, 14 Apr 2022 07:27:59 +0000
Message-ID: <e75e2e48f9d8ac2985f5995ede8d7d0d609929f5.camel@suse.com>
References: <1649910461-25263-1-git-send-email-bmarzins@redhat.com>
 <1649910461-25263-4-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1649910461-25263-4-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba0600c0-dd7e-4b34-b9b2-08da1de84d57
x-ms-traffictypediagnostic: AM6PR04MB4296:EE_
x-microsoft-antispam-prvs: <AM6PR04MB4296D766FE933AA8423F224FFCEF9@AM6PR04MB4296.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: aAWJN1d7rMIVaGtMqGqQXtyhnCDXfv5Uaeh75sakr8BGtt4kTRkXB/4mBS8+nG8HFyyZR9kAhoolvTCuaYx0MRGNd7s+aWQSmrj8+bjnnBYlB5YjdV6mdM9AxLGJ6kz0mtTxbwWoQJIvTeO26hxSD+o9Ou7UjBtH2emLQlf3yRj6AkFM4ti4SixTkJQYWDFEJ3X02tKML1aIXgBCciNU69/51nqQxr4vRVfbNfhu7yAu5LJm+r+5A1wuQ2i1G8/kTMrcPbFd1cGZGyAaL47wrNtBgDij87sRhkEd8z5258aTsYOcsbcwV6xSONEy7RqPkWd2/JuvJ7ZfIUM6FormoWN8+G9yU/+Lj8assnQcpIF5X+Rr4jQow8AkkZx/bZM2lIqHJGMLRcSPfHP9ep6B2nnVNGfOeadFTVBGa4668vkq6Nk6QsDEi5KnBQi7rpH32COz7Ddw+MvzhGFfb8AuRydwXHEJF5az+DZxrKzlvd/wIDwaMOrgtROMreo/ouphquI/IHhE41Wvm5T0fgxtm/E8LzZ2CuAa8AbGrhk/dfVTA3QcUCvwlC9u570UIVS+Mxr0Q3VAh+Rrvng1keeue62ZzKkZzTbeWtK/FOKc5OeOYVmnH7aBNPZ/cRRe6HWPI/otPADVP4RgjCr4B/Bsu57aHEEPgfygKUXY1RHv6jDLYzsD9amhlrLNOnpRZ++XRiirU490jQKpQt1XQZAeUg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(366004)(91956017)(186003)(6486002)(316002)(5660300002)(30864003)(6506007)(6512007)(4326008)(64756008)(66476007)(66556008)(44832011)(8676002)(76116006)(66946007)(71200400001)(83380400001)(2906002)(66446008)(38100700002)(508600001)(2616005)(36756003)(122000001)(38070700005)(86362001)(26005)(8936002)(110136005);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?XNrUJEIrD0MDo5H++tcwAgSQ0tvoUCf3rsKY5qS2rDd2QNuLzximf48Tf?=
 =?iso-8859-15?Q?menryR6qnTRkatjp4gDZ0ncGe3KnfGQyUK1dfSOkfb33KWuyMzMnkPfNz?=
 =?iso-8859-15?Q?ijToOmc9pOLGCCUnnM5psvxw8mRKuzwk3wAMjTQKtiTXeX24Oc5BwyANj?=
 =?iso-8859-15?Q?JG5Mh63+qzimZfXneDTilvhIvbnZMKofWGwPLAr6jFiXYVklH30sxy2bF?=
 =?iso-8859-15?Q?1Bj26ZNpBxEiWTdZg4wZ8/1uTpSbmFK/6L4eQef36glQHuSd0ZOfXIX6U?=
 =?iso-8859-15?Q?BR/qpMKGGUYMaHwO+YypHioLbNa/aJg4EkSVAY7tGGmKXTyiIHGNjgqS9?=
 =?iso-8859-15?Q?K6Sq5luSD0jFn/EhRUE3fEP5tF8tkc6yQnw7SUsmRF5FMIJgpgkx7oQoz?=
 =?iso-8859-15?Q?aaIUU6E85Mr+aIXVJIZR5JToot4dXiQ++QeBcvmyALpJlJEf+hJJCgV8Z?=
 =?iso-8859-15?Q?AkSVMzDUvIHa8YT0pRpQarazd0mnMM3w0CGJ2tYtBeh+O11L9dwYf1udT?=
 =?iso-8859-15?Q?EmSDpODKLmkFGTK1mq2IxNtzowWbgS5X+AXkVNoFYwEExh6oBaEQyvLik?=
 =?iso-8859-15?Q?JZCQ31Lk+ms0OxDEWxqrzqk+Urv9xmMCCx+acllz8KUJWfi6wDradd4/t?=
 =?iso-8859-15?Q?U6rk6k9e0ALAlIKdGf0gV4kQM6FFwkHAeZDw+19CQKEbeaif+ovl+rCln?=
 =?iso-8859-15?Q?UUaKxO3VR84pjrGtVlRbMHdweI64HJvTruMxdsS+bURYtliNGNj/uyEY8?=
 =?iso-8859-15?Q?Pd3S7wqpNGdCFP9iHUIwES0fsToqCfKoAG26kue0W1mQQMj+z8AJHX9f6?=
 =?iso-8859-15?Q?Vg5DTzBGQ46HKNrTYm/rtQErOpLND6nKWCinOUr+YOALY3OpRUZ2vP5mk?=
 =?iso-8859-15?Q?31aUtzETyWYjewDR/WtKN3FlvZtr09auyDc7RJIOXO9qfsdx6Zjhr8eHp?=
 =?iso-8859-15?Q?Y4HA2NheQz6Sb4deMx/liAGYl9u2ApJk+ct66Q46KXOShJtkViAOcn6xA?=
 =?iso-8859-15?Q?fsW7a8NHVsXnF6G2I2t5P6EKQdSKwTHv2bInqPgudLvJYMWAia4zLa+Ev?=
 =?iso-8859-15?Q?cCW2f1j3MmeX1Q2alcVHBPqlFz5fyS5oKrzDPsH7TiYpXJguQdb5atUty?=
 =?iso-8859-15?Q?berjRimtm9xP3TITJyHIMYqOhfb9bYYVoflTIxL1tPCmh4jB6JTrVY52G?=
 =?iso-8859-15?Q?ixKvLcgQMAY+ValnXUtxFneK+aDfIB+B82QDmqd/+khFIFmm/CCt11TAb?=
 =?iso-8859-15?Q?oKjhCffcR3v7BT+7ZTxLDzx8jPKL7ozo2/Ezy8h0p7ABx8nZthg1cvrTV?=
 =?iso-8859-15?Q?jCYhJDG+ClOzLMEEcS91bm6IaKYv7pU0C44/b20gQU5Tt5lUXzcX7JaEA?=
 =?iso-8859-15?Q?74DxYotnEFWQ4Av6DmXR4fgbK4K3ZIDrfJCFkNyUlFqSmcF6DtfwCGp3z?=
 =?iso-8859-15?Q?hxXzK+6TnnOpEJ45q5Z8cv0UMTp9HEmAPyfUZ9KQTY8dXWJHifOJBjWL+?=
 =?iso-8859-15?Q?KqAQDoGEvn0DOfS8hM89vPzb1iEIwzQabBa27FqXMc6sFeGtYZjMqU6q9?=
 =?iso-8859-15?Q?4Qh9Kkt+bdVVWWAJRBcYqvA8vLX91HLXWoAanYrYeC++93QIAAkkt5Vl8?=
 =?iso-8859-15?Q?PF8Og59mHm1Mz0XxtiXYffHAeEtzrRdXVFpKQdQi20tAgz/wg8MCwd3IQ?=
 =?iso-8859-15?Q?qdOk8fr59IDNBC/QDwwUgH3Rti2xsshht6NlTTHKHw53jKtPI6/NIG61z?=
 =?iso-8859-15?Q?nJ1YZpXnF2iwatyiQk9NAxw+jIdNN5yoU8bWSpiPyyA0zP5yLchv6owg7?=
 =?iso-8859-15?Q?/cfQlMMPB5ZWcEEKNvZ8C0LsiV6EWp7EF1LP+ovZXvIpV6O/9Qwx5SqsS?=
 =?iso-8859-15?Q?DTmM=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0600c0-dd7e-4b34-b9b2-08da1de84d57
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 07:27:59.2934 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y+5ZlwTnXoOo8g5DVWugUhD2faRxaemSTiNE8tz0q1kEPtwFJbZyG2kmh3y1ndNoD444X6hXJrEH2jUsOJ3Lrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4296
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v2 3/7] libmultipath: add a protocol
 subsection to multipath.conf
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
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <F5B81ED14474BB4588902E53A4668C90@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-04-13 at 23:27 -0500, Benjamin Marzinski wrote:
> Some storage arrays can be accessed using multiple protocols at the
> same
> time.=A0 In these cases, users may want to set path attributes
> differently, depending on the protocol that the path is using. To
> allow
> this, add a protocol subsection to the overrides section in
> multipath.conf, which allows select path-specific options to be set.
> This commit simply adds the subsection, and handles merging matching
> entries. Future patches will make use of the section.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Looks good, just a minor nit below.

> ---
> =A0libmultipath/config.c | 83 ++++++++++++++++++++++++++++++++++++
> =A0libmultipath/config.h | 10 +++++
> =A0libmultipath/dict.c=A0=A0 | 99
> +++++++++++++++++++++++++++++++++++++++++++
> =A0libmultipath/print.c=A0 | 50 ++++++++++++++++++++++
> =A04 files changed, 242 insertions(+)
>=20
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 612941b8..5fe71562 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -237,6 +237,18 @@ const char *get_mpe_wwid(const struct _vector
> *mptable, const char *alias)
> =A0=A0=A0=A0=A0=A0=A0=A0return NULL;
> =A0}
> =A0
> +static void
> +free_pctable (vector pctable)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int i;
> +=A0=A0=A0=A0=A0=A0=A0struct pcentry *pce;
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(pctable, pce, i)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(pce);
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_free(pctable);
> +}
> +
> =A0void
> =A0free_hwe (struct hwentry * hwe)
> =A0{
> @@ -282,6 +294,9 @@ free_hwe (struct hwentry * hwe)
> =A0=A0=A0=A0=A0=A0=A0=A0if (hwe->bl_product)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(hwe->bl_product);
> =A0
> +=A0=A0=A0=A0=A0=A0=A0if (hwe->pctable)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free_pctable(hwe->pctable);
> +
> =A0=A0=A0=A0=A0=A0=A0=A0free(hwe);
> =A0}
> =A0
> @@ -363,6 +378,15 @@ alloc_hwe (void)
> =A0=A0=A0=A0=A0=A0=A0=A0return hwe;
> =A0}
> =A0
> +struct pcentry *
> +alloc_pce (void)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct pcentry *pce =3D (struct pcentry *)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0calloc(1, sizeof(struct pcentry));
> +=A0=A0=A0=A0=A0=A0=A0pce->type =3D -1;


Use a symbolic value, like PCE_INVALID?

> +=A0=A0=A0=A0=A0=A0=A0return pce;
> +}
> +
> =A0static char *
> =A0set_param_str(const char * str)
> =A0{
> @@ -396,6 +420,13 @@ set_param_str(const char * str)
> =A0=A0=A0=A0=A0=A0=A0=A0if (!dst->s && src->s) \
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0dst->s =3D src->s
> =A0
> +static void
> +merge_pce(struct pcentry *dst, struct pcentry *src)
> +{
> +=A0=A0=A0=A0=A0=A0=A0merge_num(fast_io_fail);
> +=A0=A0=A0=A0=A0=A0=A0merge_num(dev_loss);
> +=A0=A0=A0=A0=A0=A0=A0merge_num(eh_deadline);
> +}
> =A0
> =A0static void
> =A0merge_hwe (struct hwentry * dst, struct hwentry * src)
> @@ -602,6 +633,51 @@ out:
> =A0=A0=A0=A0=A0=A0=A0=A0return 1;
> =A0}
> =A0
> +static void
> +validate_pctable(struct hwentry *ovr, int idx, const char
> *table_desc)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct pcentry *pce;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!ovr || !ovr->pctable)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot_after(ovr->pctable, pce, idx) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (pce->type < 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0con=
dlog(0, "protocol section in %s missing
> type",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0table_desc);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vec=
tor_del_slot(ovr->pctable, idx--);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fre=
e(pce);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0if (VECTOR_SIZE(ovr->pctable) =3D=3D 0) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_free(ovr->pctable);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ovr->pctable =3D NULL;
> +=A0=A0=A0=A0=A0=A0=A0}
> +}
> +
> +static void
> +merge_pctable(struct hwentry *ovr)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct pcentry *pce1, *pce2;
> +=A0=A0=A0=A0=A0=A0=A0int i, j;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!ovr || !ovr->pctable)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return;
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(ovr->pctable, pce1, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0j =3D i + 1;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot_after(o=
vr->pctable, pce2, j) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if =
(pce1->type !=3D pce2->type)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0continue;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mer=
ge_pce(pce2,pce1);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0vec=
tor_del_slot(ovr->pctable, i--);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fre=
e(pce1);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +}
> +
> =A0static void
> =A0factorize_hwtable (vector hw, int n, const char *table_desc)
> =A0{
> @@ -750,6 +826,7 @@ process_config_dir(struct config *conf, char
> *dir)
> =A0=A0=A0=A0=A0=A0=A0=A0int i, n;
> =A0=A0=A0=A0=A0=A0=A0=A0char path[LINE_MAX];
> =A0=A0=A0=A0=A0=A0=A0=A0int old_hwtable_size;
> +=A0=A0=A0=A0=A0=A0=A0int old_pctable_size =3D 0;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0if (dir[0] !=3D '/') {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "config_dir '%=
s' must be a fully qualified
> path",
> @@ -776,11 +853,15 @@ process_config_dir(struct config *conf, char
> *dir)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c=
ontinue;
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0old_hwtable_size =3D VECT=
OR_SIZE(conf->hwtable);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0old_pctable_size =3D conf->=
overrides ?
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 VECTOR_SIZE(conf->overrides-
> >pctable) : 0;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0snprintf(path, LINE_MAX, =
"%s/%s", dir, namelist[i]-
> >d_name);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0path[LINE_MAX-1] =3D '\0'=
;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0process_file(conf, path);
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0factorize_hwtable(conf->h=
wtable, old_hwtable_size,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0 namelist[i]->d_name);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0validate_pctable(conf->over=
rides, old_pctable_size,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 namelist[i]->d_name);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0pthread_cleanup_pop(1);
> =A0}
> @@ -888,6 +969,7 @@ int _init_config (const char *file, struct config
> *conf)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0factorize_hwtable(conf->h=
wtable,
> builtin_hwtable_size, file);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0validate_pctable(conf->over=
rides, 0, file);
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0conf->processed_main_config =3D 1;
> @@ -988,6 +1070,7 @@ int _init_config (const char *file, struct
> config *conf)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0g=
oto out;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0
> +=A0=A0=A0=A0=A0=A0=A0merge_pctable(conf->overrides);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_mptable(conf->mptable);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_blacklist(conf->blist_devnode);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_blacklist(conf->blist_property);
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index c73389b5..b7bca9a8 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -40,6 +40,13 @@ enum force_reload_types {
> =A0=A0=A0=A0=A0=A0=A0=A0FORCE_RELOAD_WEAK,
> =A0};
> =A0
> +struct pcentry {
> +=A0=A0=A0=A0=A0=A0=A0int type;
> +=A0=A0=A0=A0=A0=A0=A0int fast_io_fail;
> +=A0=A0=A0=A0=A0=A0=A0unsigned int dev_loss;
> +=A0=A0=A0=A0=A0=A0=A0int eh_deadline;
> +};
> +
> =A0struct hwentry {
> =A0=A0=A0=A0=A0=A0=A0=A0char * vendor;
> =A0=A0=A0=A0=A0=A0=A0=A0char * product;
> @@ -85,6 +92,8 @@ struct hwentry {
> =A0=A0=A0=A0=A0=A0=A0=A0int vpd_vendor_id;
> =A0=A0=A0=A0=A0=A0=A0=A0int recheck_wwid;
> =A0=A0=A0=A0=A0=A0=A0=A0char * bl_product;
> +
> +=A0=A0=A0=A0=A0=A0=A0vector pctable;
> =A0};
> =A0
> =A0struct mpentry {
> @@ -284,6 +293,7 @@ const char *get_mpe_wwid (const struct _vector
> *mptable, const char *alias);
> =A0
> =A0struct hwentry * alloc_hwe (void);
> =A0struct mpentry * alloc_mpe (void);
> +struct pcentry * alloc_pce (void);
> =A0
> =A0void free_hwe (struct hwentry * hwe);
> =A0void free_hwtable (vector hwtable);
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index 26cbe785..8e11fd70 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -417,6 +417,29 @@ snprint_mp_ ## option (struct config *conf,
> struct strbuf *buff,=A0=A0=A0\
> =A0=A0=A0=A0=A0=A0=A0=A0return function(buff, mpe-
> >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> =A0}
> =A0
> +#define declare_pc_handler(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> +static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +pc_ ## option ## _handler (struct config *conf, vector
> strvec,=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 const char *file, int
> line_nr)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0struct pcentry
> *pce;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0if (!conf->overrides || !conf->overrides-
> >pctable)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0pce =3D VECTOR_LAST_SLOT(conf->overrides-
> >pctable);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0if
> (!pce)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return
> 1;=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return function (strvec, &pce->option, file,
> line_nr);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +}
> +
> +#define declare_pc_snprint(option,
> function)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0\
> +static
> int=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +snprint_pc_ ## option (struct config *conf, struct strbuf
> *buff,=A0=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const vo=
id
> *data)=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0\
> +{=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0
> =A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0const struct pcentry *pce=A0 =3D (const struct pcen=
try
> *)data;=A0=A0=A0=A0=A0=A0\
> +=A0=A0=A0=A0=A0=A0=A0return function(buff, pce-
> >option);=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0\
> +}
> +
> =A0static int checkint_handler(struct config *conf, vector strvec,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 const char *file, int line_nr)
> =A0{
> @@ -1046,6 +1069,8 @@ declare_ovr_handler(fast_io_fail,
> set_undef_off_zero)
> =A0declare_ovr_snprint(fast_io_fail, print_undef_off_zero)
> =A0declare_hw_handler(fast_io_fail, set_undef_off_zero)
> =A0declare_hw_snprint(fast_io_fail, print_undef_off_zero)
> +declare_pc_handler(fast_io_fail, set_undef_off_zero)
> +declare_pc_snprint(fast_io_fail, print_undef_off_zero)
> =A0
> =A0static int
> =A0set_dev_loss(vector strvec, void *ptr, const char *file, int
> line_nr)
> @@ -1083,6 +1108,8 @@ declare_ovr_handler(dev_loss, set_dev_loss)
> =A0declare_ovr_snprint(dev_loss, print_dev_loss)
> =A0declare_hw_handler(dev_loss, set_dev_loss)
> =A0declare_hw_snprint(dev_loss, print_dev_loss)
> +declare_pc_handler(dev_loss, set_dev_loss)
> +declare_pc_snprint(dev_loss, print_dev_loss)
> =A0
> =A0declare_def_handler(eh_deadline, set_undef_off_zero)
> =A0declare_def_snprint(eh_deadline, print_undef_off_zero)
> @@ -1090,6 +1117,8 @@ declare_ovr_handler(eh_deadline,
> set_undef_off_zero)
> =A0declare_ovr_snprint(eh_deadline, print_undef_off_zero)
> =A0declare_hw_handler(eh_deadline, set_undef_off_zero)
> =A0declare_hw_snprint(eh_deadline, print_undef_off_zero)
> +declare_pc_handler(eh_deadline, set_undef_off_zero)
> +declare_pc_snprint(eh_deadline, print_undef_off_zero)
> =A0
> =A0static int
> =A0set_pgpolicy(vector strvec, void *ptr, const char *file, int
> line_nr)
> @@ -1897,6 +1926,69 @@ declare_mp_snprint(wwid, print_str)
> =A0declare_mp_handler(alias, set_str_noslash)
> =A0declare_mp_snprint(alias, print_str)
> =A0
> +
> +static int
> +protocol_handler(struct config *conf, vector strvec, const char
> *file,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 int line_nr)
> +{
> +=A0=A0=A0=A0=A0=A0=A0struct pcentry *pce;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!conf->overrides)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!conf->overrides->pctable &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !(conf->overrides->pctable =3D vector_all=
oc()))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!(pce =3D alloc_pce()))
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!vector_alloc_slot(conf->overrides->pctable)) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0free(pce);
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0vector_set_slot(conf->overrides->pctable, pce);
> +
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +}
> +
> +static int
> +set_protocol_type(vector strvec, void *ptr, const char *file, int
> line_nr)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int *int_ptr =3D (int *)ptr;
> +=A0=A0=A0=A0=A0=A0=A0char *buff;
> +=A0=A0=A0=A0=A0=A0=A0int i;
> +
> +=A0=A0=A0=A0=A0=A0=A0buff =3D set_value(strvec);
> +
> +=A0=A0=A0=A0=A0=A0=A0if (!buff)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 1;
> +
> +=A0=A0=A0=A0=A0=A0=A0for (i =3D 0; i <=3D LAST_BUS_PROTOCOL_ID; i++) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (protocol_name[i] && !st=
rcmp(buff,
> protocol_name[i])) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*in=
t_ptr =3D i;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0bre=
ak;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0if (i > LAST_BUS_PROTOCOL_ID)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0condlog(1, "%s line %d, inv=
alid value for type:
> \"%s\"",
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0fil=
e, line_nr, buff);
> +
> +=A0=A0=A0=A0=A0=A0=A0free(buff);
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +}
> +
> +static int
> +print_protocol_type(struct strbuf *buff, int type)
> +{
> +=A0=A0=A0=A0=A0=A0=A0if (type < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return 0;
> +=A0=A0=A0=A0=A0=A0=A0return append_strbuf_quoted(buff, protocol_name[typ=
e]);
> +}
> +
> +declare_pc_handler(type, set_protocol_type)
> +declare_pc_snprint(type, print_protocol_type)
> +
> =A0/*
> =A0 * deprecated handlers
> =A0 */
> @@ -2138,6 +2230,13 @@ init_keywords(vector keywords)
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("ghost_delay", &ovr_ghost_delay_h=
andler,
> &snprint_ovr_ghost_delay);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("all_tg_pt", &ovr_all_tg_pt_handl=
er,
> &snprint_ovr_all_tg_pt);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("recheck_wwid", &ovr_recheck_wwid=
_handler,
> &snprint_ovr_recheck_wwid);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword_multi("protocol", &protocol_handler=
, NULL);
> +=A0=A0=A0=A0=A0=A0=A0install_sublevel();
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("type", &pc_type_handler, &snprint_=
pc_type);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("fast_io_fail_tmo", &pc_fast_io_fai=
l_handler,
> &snprint_pc_fast_io_fail);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("dev_loss_tmo", &pc_dev_loss_handle=
r,
> &snprint_pc_dev_loss);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("eh_deadline", &pc_eh_deadline_hand=
ler,
> &snprint_pc_eh_deadline);
> +=A0=A0=A0=A0=A0=A0=A0install_sublevel_end();
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword_root("multipaths", &multipaths_ha=
ndler);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword_multi("multipath", &multipath_han=
dler, NULL);
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 27c2cf1a..68a793e7 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -1406,6 +1406,52 @@ int snprint_multipath_topology_json (struct
> strbuf *buff,
> =A0=A0=A0=A0=A0=A0=A0=A0return get_strbuf_len(buff) - initial_len;
> =A0}
> =A0
> +static int
> +snprint_pcentry (const struct config *conf, struct strbuf *buff,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const struct pcentry *pce)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int i, rc;
> +=A0=A0=A0=A0=A0=A0=A0struct keyword *kw;
> +=A0=A0=A0=A0=A0=A0=A0struct keyword * rootkw;
> +=A0=A0=A0=A0=A0=A0=A0size_t initial_len =3D get_strbuf_len(buff);
> +
> +=A0=A0=A0=A0=A0=A0=A0rootkw =3D find_keyword(conf->keywords, NULL, "over=
rides");
> +=A0=A0=A0=A0=A0=A0=A0assert(rootkw && rootkw->sub);
> +=A0=A0=A0=A0=A0=A0=A0rootkw =3D find_keyword(conf->keywords, rootkw->sub=
,
> "protocol");
> +=A0=A0=A0=A0=A0=A0=A0assert(rootkw);
> +
> +=A0=A0=A0=A0=A0=A0=A0if ((rc =3D append_strbuf_str(buff, "\tprotocol {\n=
")) < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> +
> +=A0=A0=A0=A0=A0=A0=A0iterate_sub_keywords(rootkw, kw, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D snprint_keyword=
(buff, "\t\t%k %v\n", kw,
> pce)) < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn rc;
> +=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0if ((rc =3D append_strbuf_str(buff, "\t}\n")) < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> +=A0=A0=A0=A0=A0=A0=A0return get_strbuf_len(buff) - initial_len;
> +}
> +
> +static int
> +snprint_pctable (const struct config *conf, struct strbuf *buff,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 const struct _vector *pcta=
ble)
> +{
> +=A0=A0=A0=A0=A0=A0=A0int i, rc;
> +=A0=A0=A0=A0=A0=A0=A0struct pcentry *pce;
> +=A0=A0=A0=A0=A0=A0=A0struct keyword * rootkw;
> +=A0=A0=A0=A0=A0=A0=A0size_t initial_len =3D get_strbuf_len(buff);
> +
> +=A0=A0=A0=A0=A0=A0=A0rootkw =3D find_keyword(conf->keywords, NULL, "over=
rides");
> +=A0=A0=A0=A0=A0=A0=A0assert(rootkw);
> +
> +=A0=A0=A0=A0=A0=A0=A0vector_foreach_slot(pctable, pce, i) {
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D snprint_pcentry=
(conf, buff, pce)) < 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0ret=
urn rc;
> +=A0=A0=A0=A0=A0=A0=A0}
> +=A0=A0=A0=A0=A0=A0=A0return get_strbuf_len(buff) - initial_len;
> +}
> +
> =A0static int
> =A0snprint_hwentry (const struct config *conf,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 struct strbuf *buff, con=
st struct hwentry * hwe)
> @@ -1560,6 +1606,10 @@ static int snprint_overrides(const struct
> config *conf, struct strbuf *buff,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D snprint_keywo=
rd(buff, "\t%k %v\n", kw,
> NULL)) < 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0r=
eturn rc;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> +
> +=A0=A0=A0=A0=A0=A0=A0if (overrides->pctable &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 (rc =3D snprint_pctable(conf, buff, overr=
ides->pctable)) <
> 0)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;
> =A0out:
> =A0=A0=A0=A0=A0=A0=A0=A0if ((rc =3D append_strbuf_str(buff, "}\n")) < 0)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0return rc;

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

