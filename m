Return-Path: <SRS0=GC9A=EF=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65BDC00A89
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 21:16:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 2AA4520A8B
	for <dm-devel@archiver.kernel.org>; Fri, 30 Oct 2020 21:16:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2AA4520A8B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-3_rztrLDPDiOmhgtIDvcTg-1; Fri, 30 Oct 2020 17:16:25 -0400
X-MC-Unique: 3_rztrLDPDiOmhgtIDvcTg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72E98101F000;
	Fri, 30 Oct 2020 21:16:20 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 5283A55796;
	Fri, 30 Oct 2020 21:16:20 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2100B58127;
	Fri, 30 Oct 2020 21:16:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09ULCtWW019731 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 30 Oct 2020 17:12:55 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 73772200A7CD; Fri, 30 Oct 2020 21:12:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D4F8202278E
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 21:12:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EFAF101AA41
	for <dm-devel@redhat.com>; Fri, 30 Oct 2020 21:12:53 +0000 (UTC)
Received: from de-smtp-delivery-102.mimecast.com
	(de-smtp-delivery-102.mimecast.com [62.140.7.102]) (Using TLS) by
	relay.mimecast.com with ESMTP id us-mta-53-lz97BbhPMQ2yaS9eUVVvxg-1;
	Fri, 30 Oct 2020 17:12:51 -0400
X-MC-Unique: lz97BbhPMQ2yaS9eUVVvxg-1
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
	(mail-am6eur05lp2113.outbound.protection.outlook.com [104.47.18.113])
	(Using TLS) by relay.mimecast.com with ESMTP id
	de-mta-30-t6rsrqyoObCH-qOVpSpCvA-1; Fri, 30 Oct 2020 22:12:48 +0100
X-MC-Unique: t6rsrqyoObCH-qOVpSpCvA-1
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com (2603:10a6:10:103::20)
	by DB7PR04MB4074.eurprd04.prod.outlook.com (2603:10a6:5:25::27) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20;
	Fri, 30 Oct 2020 21:12:47 +0000
Received: from DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2]) by
	DB8PR04MB6555.eurprd04.prod.outlook.com
	([fe80::b1a6:e9db:2017:f2a2%4]) with mapi id 15.20.3499.029;
	Fri, 30 Oct 2020 21:12:47 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
	"christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>,
	"sschremm@netapp.com" <sschremm@netapp.com>
Thread-Topic: [PATCH 4/5] libmultipath: only read 0xc9 vpd page for devices
	with rdac checker
Thread-Index: AQHWqYGm1ba+s8gN/kCXi+qIM5RPBqmwr8+A
Date: Fri, 30 Oct 2020 21:12:46 +0000
Message-ID: <acd021d7918335d91fac742da1f7e604ed3e2ee6.camel@suse.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603487708-12547-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5
x-originating-ip: [90.186.0.80]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4cbc5b87-5cfe-46b6-fa53-08d87d188d01
x-ms-traffictypediagnostic: DB7PR04MB4074:
x-microsoft-antispam-prvs: <DB7PR04MB4074ADA2EBECAE0D9F593EF9FC150@DB7PR04MB4074.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: z61EGEP06sXH1ZZ9eP3+zKnYgw3lDmN6BbfHOPsnIcb5mNVAzl1zAX6EabYTR6D0rB0/NQJIyxtv6jGzrEAdwTZx4+2bV4CwBxhQE90K5uUG3hSN4p14/NxhIspFeu1PRMRhPL7wIlvKOpz972MwFd57L+1Dq1xsqY5hSXUcIPw3BtAssHInk2nfHMZOhrb+awq0S3uG+u0BG7Mn51PZ8cT9u4F7V1zPbcqPH+ZrPoctlyXKjhCEtolZeEfGreoN9x6AUcShGK9fDGCg7COqcc06kXV8n3Gavb7sEXbnhVO9BsjBPhCqvIGQGyAO0Wi7cHYPbqQ/TLKsRT0yFcu61A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DB8PR04MB6555.eurprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(396003)(376002)(366004)(39860400002)(136003)(346002)(66556008)(91956017)(76116006)(66476007)(86362001)(54906003)(186003)(478600001)(83380400001)(8936002)(64756008)(4326008)(66446008)(5660300002)(66574015)(44832011)(6506007)(2906002)(6512007)(26005)(316002)(8676002)(2616005)(36756003)(110136005)(4001150100001)(66946007)(71200400001)(6486002);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: UX4ZyxZ26Ro4p4yxDuQ9GHmm1b4W5CMfRB/mAmCfOB0To43qFxPE2Bm+1rnzXEL5JYqy9NvzkJktZqoiRZx/AnxT7ckMdfK+Q6OL/FbLgvDuKF/SwmQp94aTq0ef0ZcfoUPf9+UqY18o/1JylmHl6u1QBis1x71fV8PQDsgggIYivzw6cJaXPW3axsm+++a/0wtfBp07w/Ez6Euc+7c6Q/W5W1U2zMZly7HVLbig1h6ZOeikTcZp0S+EAjFbl5xr+G6bxOxEN9wbGROige5JOX+TqT2P79ZjomjfcBmWkgWxx1w9tl8Wo2koY27V7CP06PaE/+sgD8MiUwzvBDc4+U1GsP7mXxVhcAaraNgMoZEHmgG9CDHHD1IXFeLRYAzh6M5TMeIYUy95Gw4eY1Rei1O//YuyAYhXAwE0l2/tEVBnDtnHxC2O7Uu4cwEfy9K4p56R43MHsBbEuNLiTCkfc+AGMfgc7pHt3V2dDh1w+Bd9TAeRY46HUvQLEM0p+Oy1qQYi2jSog0qJtOv0GKgbltLcZWz/EgjgcX85cbWp+/6CoBRBhqaB7JYrheDN7Q+oNZfHfdo3Rq/w3bR5wbsXuD7PjPgXdIpGDPtZqM0XLCEjKJSckjLKpBxGTqdZWM0VtWQmL9A2k8mXBCstK0t+DA==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cbc5b87-5cfe-46b6-fa53-08d87d188d01
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2020 21:12:47.0070 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1KgOkr8NTsQFoCe0wfg4X1NNMkFjz5dJcHdaC4YT14XPBaIDk5L0zGIRY96Y8Hkb9d93f5JkrRuIQDy2M6CtaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4074
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09ULCtWW019731
X-loop: dm-devel@redhat.com
Cc: "ng-eseries-upstream-maintainers@netapp.com"
	<ng-eseries-upstream-maintainers@netapp.com>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [dm-devel] [PATCH 4/5] libmultipath: only read 0xc9 vpd page
 for devices with rdac checker
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-ID: <073C46925196A249B7CB0959F3F4AF84@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2020-10-23 at 16:15 -0500, Benjamin Marzinski wrote:
> Only rdac arrays support 0xC9 vpd page inquiries. All other arrays
> will
> return a failure. Since all rdac arrays in the the built-in device
> configuration explicitly set the RDAC path checker, and almost all
> other
> scsi arrays do not set a path checker, it makes sense to only do the
> rdac inquiry when detecting array capabilities if the array's path
> checker is explicitly set to rdac.
>=20
> Multipath was doing the check if either the path checker was set to
> rdac, or no path checker was set.  This means that for almost all
> non-rdac arrays, multipath was issuing a bad inquiry. This was
> annoying
> users.

This is sort of funny. We created the entire check_rdac() feature in
order to autodetect RDAC arrays. If we limit the autodetection to those
arrays that have "rdac" set already, why would we do this at all? We
could simply go with the hwtable / config file settings, as we used to
before check_rdac() was created. All we'd need to do is use "alua" prio
for arrays with "rdac" checker. What am I missing here?

I thought that this autodetection was intended because there are many
Netapp OEMs which we may not all have included in the hwtable (thus
having no path_checker set). For those, we'd choose the wrong settings
by default with this patch, only to avoid some error messages about
unsupported VPDs. I'm not convinced that that's a good idea.

Suggestion: we could try to retrieve VPD 0 (supported VPDs) before
checking VPD 0xc9. That would avoid the errors on non-Netapp hardware,
while still allowing us to autodetect RDAC systems that are missing in
the hwtable.

Regards
Martin

>=20
> Cc: Steve Schremmer <sschremm@netapp.com>
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/propsel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index fa4ac5d9..90a77d77 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -501,7 +501,7 @@ check_rdac(struct path * pp)
>  =09if (pp->bus !=3D SYSFS_BUS_SCSI)
>  =09=09return 0;
>  =09/* Avoid ioctl if this is likely not an RDAC array */
> -=09if (__do_set_from_hwe(checker_name, pp, checker_name) &&
> +=09if (!__do_set_from_hwe(checker_name, pp, checker_name) ||
>  =09    strcmp(checker_name, RDAC))
>  =09=09return 0;
>  =09len =3D get_vpd_sgio(pp->fd, 0xC9, 0, buff, 44);

--=20
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE  Software Solutions Germany GmbH
HRB 36809, AG N=FCrnberg GF: Felix
Imend=F6rffer



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

