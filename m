Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E18C71153
	for <dm-devel@archiver.kernel.org>; Tue, 29 Aug 2023 19:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693338723;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=nhAi4rjgRRw994nTcUlzizJYBja71ZPZ4A4KzBYSZS8=;
	b=G5/UibdJR2hgtH+9/umw43vCUpV1casXlae6RO+Igj+n3jXoBdPFXpC31GtVNbu+b6eXiX
	lvaZLDX7cyx0vJm76sDivXEATjrGLQ5UZLls2Tgwk6C3JuBj839oxtH75wUaq5Xc/l8M6x
	y8U4ulueu6CNKy9gCRcd+7gVKmGTweQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-o0rYvdm3NW2P_UabrGa5vQ-1; Tue, 29 Aug 2023 15:52:01 -0400
X-MC-Unique: o0rYvdm3NW2P_UabrGa5vQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 444BC8028B2;
	Tue, 29 Aug 2023 19:51:59 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E4791C15BAE;
	Tue, 29 Aug 2023 19:51:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 9DD7419465B3;
	Tue, 29 Aug 2023 19:51:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id ED07B1946594
 for <dm-devel@listman.corp.redhat.com>; Tue, 29 Aug 2023 19:51:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B6264492C18; Tue, 29 Aug 2023 19:51:57 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AD13E492C13
 for <dm-devel@redhat.com>; Tue, 29 Aug 2023 19:51:57 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9174980027F
 for <dm-devel@redhat.com>; Tue, 29 Aug 2023 19:51:57 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05on2070.outbound.protection.outlook.com [40.107.20.70]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-Bkp_Vf6ONxCGh_HOiQcC3A-1; Tue, 29 Aug 2023 15:51:53 -0400
X-MC-Unique: Bkp_Vf6ONxCGh_HOiQcC3A-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by DUZPR04MB10016.eurprd04.prod.outlook.com (2603:10a6:10:4dd::5)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.34; Tue, 29 Aug
 2023 19:51:50 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::68cd:f684:ea5f:394e]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::68cd:f684:ea5f:394e%5]) with mapi id 15.20.6699.035; Tue, 29 Aug 2023
 19:51:50 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [RFC PATCH 1/4] libmultipath: don't bother to reset default
 timeout value
Thread-Index: AQHZwYaSQ5Q+Qhrmi06JCn9oJ5PlY7AB4XAA
Date: Tue, 29 Aug 2023 19:51:49 +0000
Message-ID: <86abcd0775e43b2bec01a73b6e1697d021e02763.camel@suse.com>
References: <1690571155-8283-1-git-send-email-bmarzins@redhat.com>
 <1690571155-8283-2-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1690571155-8283-2-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.4
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|DUZPR04MB10016:EE_
x-ms-office365-filtering-correlation-id: d211191f-9832-400b-5367-08dba8c962c7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: 21ai87pwCca03t1YurSlMVhevnMbRGN6yi3+t0GsemwkXzgQrrdNyFYcLVmRHhTybmqFqKugtJZouZKx+mk1UqdBMdOrMHMrtEZJ4GUV7tXef4dF1OgI9ftPhMvgGrTg3WQII+rDSy2kvAwD0XocJvB60L9FsmzmDDa/c4Dw2sPj76ZZaYT4Lqf/EGJgnPavIMLtLrxKmeSdlGUViNMfnxuaV59wCa7uF8Ar8GZr6ASPug60fCh6frjK1Pst9HBdYeFKNV53Xl6lIznwyVdppObGXxXnrDuSNXbqqnvvKtBpiw2rwqGntzokqO6HEfiqoKZQ1yakMO/68jmxSK9H+gHgpZafnJYqvE63vzG2qWle5OCEAjXx0za4DDVXwoWvB/t6XaAN3QAHulUL3WJkOCDGzDDwAkT/MDiA/ZRm07OPbRqhRpTLryZnLXh0PdFQbHP6gHS86IEktXQ26/ql9/GRfSslH3KN7cTKY4WNZcejJp0B3HNiNN2ca94E3YIrjqAzK0fjlZ1plbY9crHRfYtIhyO7bGV1rvzcCopBbRqGTWWdb+K7lHeMF4lUp6BKxAwyIjZPClzGJZ7Pr+qAEivtKLNClJLKQ9mbMsNuMSd/ulT6U7Ca3EuFNr4Ms8Wv
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230031)(376002)(346002)(39860400002)(396003)(366004)(136003)(451199024)(1800799009)(186009)(6486002)(71200400001)(6512007)(6506007)(478600001)(83380400001)(2906002)(26005)(66556008)(64756008)(316002)(66476007)(41300700001)(66946007)(44832011)(76116006)(5660300002)(91956017)(110136005)(8936002)(66446008)(2616005)(4326008)(8676002)(36756003)(86362001)(38100700002)(38070700005)(122000001)(66899024);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?yqKjBmEFA3fnJmRw2k6hR6nb5cQkLvrvEP0F8xMpf6POTsAtbBN4hD7WR?=
 =?iso-8859-15?Q?1bNBCpFIbd6/NozK/4629LMlCoLPxRuBXD/UFpD55ruXHH7qCtrO/bbkU?=
 =?iso-8859-15?Q?/V2hYN7eWAUv7ygZD6Z+9YGsIDAPJR5TuZlAvP7nCuCZ8glsrCtkTt2po?=
 =?iso-8859-15?Q?6LBp4kCI/Jc+7eoJ/nJvMX1sZPI5LAwK7uJa+NvO2zUvuvLc4llEcKbgX?=
 =?iso-8859-15?Q?9BdiE2fd8ZRovumOcjoN28nihivGezxT9WfA6335F8EFeW/SApiccBXi0?=
 =?iso-8859-15?Q?rynm9KdGZSBvkZFGTEL+Us3aJ/xz+qbBTjlOAxDEHBniI6rAl2ZWRDBH9?=
 =?iso-8859-15?Q?QK/zRW3fyDTTZ9S6WLDE2WzUXzU+voiUgz7pQQFDCr0p5Y5Lpgc6bjCgz?=
 =?iso-8859-15?Q?2I/DkOMNTGRFWRT71NPof/JxBuzAyoepGdky1/0t5YD2I7l36SKVm3Z3l?=
 =?iso-8859-15?Q?MBq+XZWPqzN4pDkYkYFSjLvyndI5mVg09g637U1fHWb6elJtA3u8RkeJL?=
 =?iso-8859-15?Q?wRMag23FJDILTVqyS/YKwuKbohHbYDQ9BEhXdHchd2TEuW7VOv6T+p8zb?=
 =?iso-8859-15?Q?KjkWYVxdZaJTAQh4B3xUd/IX5eBc/mWzJ81UWnzl62ik5uAKsKAQnxTq0?=
 =?iso-8859-15?Q?Bc1gTOJ+o1APCekmOR03k3ARQDz8/zcgkfuf0LjuGH+rJZhnxvUDYu73T?=
 =?iso-8859-15?Q?GGCmPypcGwY72S7gfuHQKuHOza5oPeTKPZkpoEHPL57iQUJfkeMjIFXlO?=
 =?iso-8859-15?Q?SLzQzuZWEkLcOmhZAOhn9Ozc1+V8F0Loxt4+L/zxT4DoGwJDL3KnJ3Ps+?=
 =?iso-8859-15?Q?pYHioYbn07vJLaQVkDN7168TBKuKCkey8SgfygFJuLUbJW7/FgHZqzqcs?=
 =?iso-8859-15?Q?Hdf/3bXeoJBYHmiKP2DdDgYjZU8w6Do4gVk8DZXGScUKJc3j17g2ILkk8?=
 =?iso-8859-15?Q?RPppedpcUp5Pwq9FuvywIA672BN2y5bqSSQTqDb7G2ZG87THToAyIlu42?=
 =?iso-8859-15?Q?7ajtgvcV5O7T+iNYxb8JXRUxmiyjhHuziKL+E1KAcla11MBiTZP4ocsgu?=
 =?iso-8859-15?Q?GJe7jPxXVywNnyhqWy8W0YuUetmlnn6lTK75Rx0juqVo9PKprT6HjidYa?=
 =?iso-8859-15?Q?ViS0zejeh8bm8loBtnhNf7Y7w50tFpaF4O8NrSVZZ+qj471qjx9sXMNjV?=
 =?iso-8859-15?Q?SVE2d4Nbw59dtxwjdxx45etXz+OTDtoQxdLmjA8UWt1Bn+g3MwXi0meXc?=
 =?iso-8859-15?Q?5tkmNyfiVFYzIkTNKDDUgOA0Zxr8+2Qhisg0LoA8kEtLl9saT3pLDtrXr?=
 =?iso-8859-15?Q?1M7cbsEWYPBsEDplHA5u9s5zdT0nkTk05ouuunBMY2eThohoSI7bTtO4i?=
 =?iso-8859-15?Q?EGI9P/c0xcMv7lsnSFogwTS+2YARkreOMWjVvIRkOJHXF82uUcQyUUkWs?=
 =?iso-8859-15?Q?wEpSs7hVBoZ66e12ES0tbYRC1a0KtFcKEl+KX21Yy2hD6tQiTExewBIgR?=
 =?iso-8859-15?Q?9eztTvHcscx8akAGrBj/cKF410ZFpkhQo56JLwdJwwxpM8JS84WwuhPsH?=
 =?iso-8859-15?Q?K3+b35WnP8wKwSQVboyWC6uHbw8Y1sVQCoHB79E93WRKq+8R94ZNtCiHu?=
 =?iso-8859-15?Q?4z690w45QHaC+T3KeVH+RKVHuqHPRVAecLNTQmZiwkL+xWzG0WEmYB3oo?=
 =?iso-8859-15?Q?JNPjTTM9a3QAuUZyu11Geyca2g=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d211191f-9832-400b-5367-08dba8c962c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2023 19:51:50.2019 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ItVdFd6CuigHA4h16oWjaGWewA+FrJsSASFh+XY65GRws9FZDT5pxs3OpWRmIYQMVQPNmTSeVM0ETr+M51yvxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB10016
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: Re: [dm-devel] [RFC PATCH 1/4] libmultipath: don't bother to reset
 default timeout value
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <6FACAE76F64BEF4B9493199BD09D2364@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Fri, 2023-07-28 at 14:05 -0500, Benjamin Marzinski wrote:
> by the time get_state() is rechecking the sysfs timeout value,
> c->timeout has already been set.=A0 The only reason why this check
> exists
> is to deal with the possiblity that the sysfs value has changed. If
> the
> sysfs value doesn't exist (which likely means that the device is not
> a
> scsi device), then there's no reason to reset the default value,
> since
> that can't have changed.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>

Thinking about it, I am not sure if it's wise to re-read the timeout
from sysfs every time we retrieve a path state. It's inefficient, and I
wonder if we even want to do this if someone modifies SCSI timeouts in
sysfs while multipathd is running. It would be cleaner to set
checker_timeout and reload multipathd.

But that's no reason to reject this patch.

> ---
> =A0libmultipath/discovery.c | 5 ++---
> =A01 file changed, 2 insertions(+), 3 deletions(-)
>=20
> diff --git a/libmultipath/discovery.c b/libmultipath/discovery.c
> index 5626d48d..2b1a11d5 100644
> --- a/libmultipath/discovery.c
> +++ b/libmultipath/discovery.c
> @@ -1965,9 +1965,8 @@ get_state (struct path * pp, struct config
> *conf, int daemon, int oldstate)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0checker_set_async(c);
> =A0=A0=A0=A0=A0=A0=A0=A0else
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0checker_set_sync(c);
> -=A0=A0=A0=A0=A0=A0=A0if (!conf->checker_timeout &&
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sysfs_get_timeout(pp, &(c->timeout)) <=3D=
 0)
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0c->timeout =3D DEF_TIMEOUT;
> +=A0=A0=A0=A0=A0=A0=A0if (!conf->checker_timeout)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 sysfs_get_timeout(pp, &(c->timeout));
> =A0=A0=A0=A0=A0=A0=A0=A0state =3D checker_check(c, oldstate);
> =A0=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: %s state =3D %s", pp->dev,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0checker_name(c), checker_=
state_name(state));

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

