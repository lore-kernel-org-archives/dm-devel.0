Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28726C77B7A
	for <dm-devel@archiver.kernel.org>; Wed,  7 Jun 2023 18:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686163957;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=XTpAcO9EPb1tgYcM0493kYlhKjahH9pyq0jicKDlx0M=;
	b=bEEuKLQFq2jilcV8K4xnZNTIUkj+ltbi02sjNHi9dE7i2L58oEjRE0bxbGPfqbkTziyoFZ
	64YGcioxy6R/Mg813BU4tHkBb+T2czqIVWLZ2XCMVBn5deZn96HNgKs6M4TApmgr+29UGS
	aUp6YxHTe0SZsXbp5YQKGi6TgR4WbgM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-656-N2tVjh-6MT2L86IQ4fRKNQ-1; Wed, 07 Jun 2023 14:52:33 -0400
X-MC-Unique: N2tVjh-6MT2L86IQ4fRKNQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B569A3C02865;
	Wed,  7 Jun 2023 18:52:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 641B6492B00;
	Wed,  7 Jun 2023 18:52:31 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3352C19452C3;
	Wed,  7 Jun 2023 18:52:31 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E759119465BA
 for <dm-devel@listman.corp.redhat.com>; Wed,  7 Jun 2023 18:52:29 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B883A400F5F; Wed,  7 Jun 2023 18:52:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B0B004B3FEB
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:52:29 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 900F43C02866
 for <dm-devel@redhat.com>; Wed,  7 Jun 2023 18:52:29 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05on2082.outbound.protection.outlook.com [40.107.21.82]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-6-HVDjlcRNPK2Bm-HyXwTgeA-1; Wed, 07 Jun 2023 14:52:25 -0400
X-MC-Unique: HVDjlcRNPK2Bm-HyXwTgeA-1
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::22)
 by PA4PR04MB8014.eurprd04.prod.outlook.com (2603:10a6:102:c7::10)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Wed, 7 Jun
 2023 18:46:47 +0000
Received: from AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1]) by AS8PR04MB8040.eurprd04.prod.outlook.com
 ([fe80::e365:d65a:a200:40c1%4]) with mapi id 15.20.6455.034; Wed, 7 Jun 2023
 18:46:47 +0000
From: Martin Wilck <martin.wilck@suse.com>
To: "bmarzins@redhat.com" <bmarzins@redhat.com>,
 "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH V2 06/11] libmultipath: add "detect_pgpolicy_use_tpg"
 config option
Thread-Index: AQHZmXBpVx0jNeAni0+UwZqKxDRJjg==
Date: Wed, 7 Jun 2023 18:46:47 +0000
Message-ID: <1fdd659e8835a6bdfd3e09b7636351abb8b8dcb9.camel@suse.com>
References: <1686082391-29210-1-git-send-email-bmarzins@redhat.com>
 <1686082391-29210-7-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1686082391-29210-7-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.48.1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB8040:EE_|PA4PR04MB8014:EE_
x-ms-office365-filtering-correlation-id: 7f52f66d-fa6a-42b3-6263-08db67878c5b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ykVyxNDYKJT4C5ednwcPCjmjpLv5byKDh+sGk02pEjftcLmH9v4YBWX1uJP8TAuQqGSMAsFuAsQ/OhaYOdEao1KtqeoDCKCvu5gVUH0M0xrqv8eGWUk2KUKeHEuN0mwiVdWR1eBmQV7p77Vl2fwIP7BK723+tg+IKabzhX4/tLNoKUkmgNRp3kY91EU6OuVcH5+DxdVueLLPDnuSwTb5HwJ++RBn6HU932xWUjgt7MUbPJGRjRHiRHsJhEWwSCzun73lupnNoh+Wcf6fNvybdTHXRbRxZyCl66H58EduKEM0xdqs1Dx4d7MUrOW2yXLFFgvJqBRdb599OaWWOS6lAesIXoozGkJCUYIwFQ0C6zatnPPHwKbwKCPeyRSj1GiZMJefO6YIO+uZEON0SDySRUF2vMw2yWloVrYpg20xD26mBsodydjX6WbmNFWP8koaBFCYcT4ndzgtkKiYzpex+t8IUZJggXYkF2u0lHpK1KRwcZ6yuf9zZ3dX4JfsyWzHJaLdSVASPoactm6Dkomi+26xVC4WpcLstqyfa57lQdzv5dmG0qmsdM4RlyvyUaeC0ECeJ7lXVXUK2nTRZMAdzulglOYTbMxwQ2JtY8D38qwrgz+mRx/7EFn2ZPmUEE3/
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:AS8PR04MB8040.eurprd04.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230028)(39860400002)(376002)(346002)(396003)(136003)(366004)(451199021)(6512007)(38100700002)(6506007)(2616005)(41300700001)(6486002)(26005)(186003)(83380400001)(71200400001)(478600001)(110136005)(66446008)(91956017)(66556008)(66476007)(76116006)(316002)(66946007)(64756008)(2906002)(122000001)(8676002)(8936002)(5660300002)(4326008)(44832011)(30864003)(86362001)(38070700005)(36756003);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-15?Q?TfvbXrwqUgFoYhoykaF6kDv3cG55hpa6omkJKmnZyd4L8AxBaSEmSxLWW?=
 =?iso-8859-15?Q?+E5BXW+9rk6m3aMrV3TjT2kfKCLvs+RRh0R1gdgC6rS7hOXTMKvhhG6QI?=
 =?iso-8859-15?Q?UT5kayWK+aMtzLEl+WW7BrBWjbBVSY1eQj856A23aivBBHU4iy5ONRnzo?=
 =?iso-8859-15?Q?+MVXTMaE7FvP6AZre2tFZ5NmVlD+ISFB6X3pbQ48wzvNcddAuhAjESIfX?=
 =?iso-8859-15?Q?HpjeWPXpSg0GUEhXRVq97xG9oDZhl4h+zOnJaNy1XsX7+l6TFTeql4FoZ?=
 =?iso-8859-15?Q?1k2Memv14KY7eLuZtrcJNK6XZ6kwbWdxzfIzlAakOT9T44banCqmTuSNq?=
 =?iso-8859-15?Q?yyjj6uSf/m2uUQoHK6W+swyJp1Js8YtaU4LHEK428Gd1x62iiTElXJGcQ?=
 =?iso-8859-15?Q?TaAmLtP92IT06Qv0Jkycj+VxonLDbzLaI1MBSc+km7TWT9decjCkabsgH?=
 =?iso-8859-15?Q?ym0yExB1slj1LXj+hJHRDlx3sI152+iFzFZTaj18EzhbftJhj2reF46GV?=
 =?iso-8859-15?Q?x/rIoueTffoq0mr+BI7znmhUmNaN03RmAtZyTHVuOqJRz+efmVbaCDZs0?=
 =?iso-8859-15?Q?jPrEYma2dUpqSz8NnBv4XVe1MWcbR/YWE+CCUnGc+w7fgWa8vnkVsFGWE?=
 =?iso-8859-15?Q?RL+Q/mJZtPsmltpv27m5CjgPhS/OoDB9dTGCpN3n6PeIwJ86mNlf88P5X?=
 =?iso-8859-15?Q?4C8tXpA6R1ZGDJ3HgtNAOIl8WZrI4cV/9qC0EFbJsggxAuSYRjxC0UfaN?=
 =?iso-8859-15?Q?E0SZomRY/eswHFHcdhVcvUWfejK/dLEk0pwZpP5eKZTAaM67bR3BZ2VTr?=
 =?iso-8859-15?Q?gBQZbAZIw/4FZEoGfv5wQWg1zyXswGT1/Z9rrhzW0I/q8sdl+RhVNhsZ7?=
 =?iso-8859-15?Q?I2GZlzIUOxaJbj2qbX9dPwNtQLHIkfeKQOUnAGo7L5mOAYEnIUyVVzQ0j?=
 =?iso-8859-15?Q?/mgHuFaGlWM1ToOXiT0FIDcfQkC6fd9GLQTJkMS8mWaKTyHyifzlJmsIg?=
 =?iso-8859-15?Q?0Dz4I6a5JXXYAdn4E52zhg1fC8hdYBGSXwMs3YxZ30ZDCsB0DMbvM/sbO?=
 =?iso-8859-15?Q?7q4QZrWIqTWG448/NTrjI1Ku5YU7H7FNMIUMU2SUDAjsEDu44d/STx/ya?=
 =?iso-8859-15?Q?L+tdV7hagb1iVSdxs8A00XMPYpSztnYLTXK5qvmdw9UIyvYtb+Mi7HL7W?=
 =?iso-8859-15?Q?eAQfUOS8fuCCiVH0kzKvcLnsd7zhWXWtaIPg351YrlmMiKnwmwy5fBQOQ?=
 =?iso-8859-15?Q?SkBNuxj5Onnlp4/P4oI0btXgb438EHT47VDxIB0SC3/sIoJ/3BsvVmL47?=
 =?iso-8859-15?Q?NTJxysG/z/rKomiv72rkOM5YE1zLfZRjPLh1etM1zDAN9xRkVfeTwjz4q?=
 =?iso-8859-15?Q?5El0yRczow90QqxQAuAd3HBDijvZJBNpLpHJ8qMSq55Gg2tZjUjaZkxQp?=
 =?iso-8859-15?Q?9EpcaH4Yb+kTf8gFcPwx2jm8g4m3N+smI/8PaqVThAW5my6atS7N44lZl?=
 =?iso-8859-15?Q?Vf299yaq5TJ8pB7VbgWFKu8Lb8WBlRfxqi2bpOZIqdbDat+Yiullo4Nak?=
 =?iso-8859-15?Q?AtkBiFVZ/YpnN911zYDiReAoMycoWEY3iJ4uUuD+V5Hv6TmyLo1TVKNZ5?=
 =?iso-8859-15?Q?D/Bd46FKvf1TWpljGnxyp1sP3MR9jSLsaCfdf7tttoOC3ZhVo0uXRUFic?=
 =?iso-8859-15?Q?lT3F?=
MIME-Version: 1.0
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB8040.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f52f66d-fa6a-42b3-6263-08db67878c5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 18:46:47.5788 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5hXzoTatlBMx0ygetyuky4aqUrsT4aRF/TslTR75QourlnfjkSpawYrQEOpW7Eh+e4npO33w9Fj83/wsbJJvNw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB8014
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH V2 06/11] libmultipath: add
 "detect_pgpolicy_use_tpg" config option
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: suse.com
Content-Language: en-US
Content-ID: <119A98EAB6566247B89A249146ED3990@eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

On Tue, 2023-06-06 at 15:13 -0500, Benjamin Marzinski wrote:
> If this and "detect_pgpolicy" are both selected and ALUA is
> autodetected, the multipath device will use the "group_by_tpg" policy
> instead of the "group_by_prio" policy.
>=20
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

One minor remark below.

> ---
> =A0libmultipath/config.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 ++
> =A0libmultipath/config.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 2 ++
> =A0libmultipath/configure.c=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/defaults.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/dict.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 11 +++=
++++++++
> =A0libmultipath/hwtable.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/libmultipath.version | 10 +++-------
> =A0libmultipath/propsel.c=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 | 24 +++++++++=
+++++++++++++--
> =A0libmultipath/propsel.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 1 +
> =A0libmultipath/structs.h=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 |=A0 7 +++++++
> =A0multipath/multipath.conf.5=A0=A0=A0=A0=A0=A0=A0 | 13 +++++++++++++
> =A011 files changed, 64 insertions(+), 9 deletions(-)
>=20
> diff --git a/libmultipath/config.c b/libmultipath/config.c
> index 2e742373..7b207590 100644
> --- a/libmultipath/config.c
> +++ b/libmultipath/config.c
> @@ -453,6 +453,7 @@ merge_hwe (struct hwentry * dst, struct hwentry *
> src)
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(detect_prio);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(detect_checker);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(detect_pgpolicy);
> +=A0=A0=A0=A0=A0=A0=A0merge_num(detect_pgpolicy_use_tpg);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(deferred_remove);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(delay_watch_checks);
> =A0=A0=A0=A0=A0=A0=A0=A0merge_num(delay_wait_checks);
> @@ -619,6 +620,7 @@ store_hwe (vector hwtable, struct hwentry * dhwe)
> =A0=A0=A0=A0=A0=A0=A0=A0hwe->detect_prio =3D dhwe->detect_prio;
> =A0=A0=A0=A0=A0=A0=A0=A0hwe->detect_checker =3D dhwe->detect_checker;
> =A0=A0=A0=A0=A0=A0=A0=A0hwe->detect_pgpolicy =3D dhwe->detect_pgpolicy;
> +=A0=A0=A0=A0=A0=A0=A0hwe->detect_pgpolicy_use_tpg =3D dhwe->detect_pgpol=
icy_use_tpg;
> =A0=A0=A0=A0=A0=A0=A0=A0hwe->ghost_delay =3D dhwe->ghost_delay;
> =A0=A0=A0=A0=A0=A0=A0=A0hwe->vpd_vendor_id =3D dhwe->vpd_vendor_id;
> =A0
> diff --git a/libmultipath/config.h b/libmultipath/config.h
> index 014c6849..0a2c297b 100644
> --- a/libmultipath/config.h
> +++ b/libmultipath/config.h
> @@ -77,6 +77,7 @@ struct hwentry {
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_prio;
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_checker;
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy;
> +=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy_use_tpg;
> =A0=A0=A0=A0=A0=A0=A0=A0int deferred_remove;
> =A0=A0=A0=A0=A0=A0=A0=A0int delay_watch_checks;
> =A0=A0=A0=A0=A0=A0=A0=A0int delay_wait_checks;
> @@ -173,6 +174,7 @@ struct config {
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_prio;
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_checker;
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy;
> +=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy_use_tpg;
> =A0=A0=A0=A0=A0=A0=A0=A0int force_sync;
> =A0=A0=A0=A0=A0=A0=A0=A0int deferred_remove;
> =A0=A0=A0=A0=A0=A0=A0=A0int processed_main_config;
> diff --git a/libmultipath/configure.c b/libmultipath/configure.c
> index 366b166f..ac99edc8 100644
> --- a/libmultipath/configure.c
> +++ b/libmultipath/configure.c
> @@ -305,6 +305,7 @@ int setup_map(struct multipath *mpp, char
> **params, struct vectors *vecs)
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0select_pgfailback(conf, mpp);
> =A0=A0=A0=A0=A0=A0=A0=A0select_detect_pgpolicy(conf, mpp);
> +=A0=A0=A0=A0=A0=A0=A0select_detect_pgpolicy_use_tpg(conf, mpp);
> =A0=A0=A0=A0=A0=A0=A0=A0select_pgpolicy(conf, mpp);
> =A0
> =A0=A0=A0=A0=A0=A0=A0=A0/*
> diff --git a/libmultipath/defaults.h b/libmultipath/defaults.h
> index 8f2d2f05..b3f11d4c 100644
> --- a/libmultipath/defaults.h
> +++ b/libmultipath/defaults.h
> @@ -30,6 +30,7 @@
> =A0#define DEFAULT_DETECT_PRIO=A0=A0=A0=A0DETECT_PRIO_ON
> =A0#define DEFAULT_DETECT_CHECKER=A0DETECT_CHECKER_ON
> =A0#define DEFAULT_DETECT_PGPOLICY=A0=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY=
_ON
> +#define
> DEFAULT_DETECT_PGPOLICY_USE_TPG=A0=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_US=
E_TPG_OFF
> =A0#define DEFAULT_DEFERRED_REMOVE=A0=A0=A0=A0=A0=A0=A0=A0DEFERRED_REMOVE=
_OFF
> =A0#define DEFAULT_DELAY_CHECKS=A0=A0=A0NU_NO
> =A0#define DEFAULT_ERR_CHECKS=A0=A0=A0=A0=A0NU_NO
> diff --git a/libmultipath/dict.c b/libmultipath/dict.c
> index edd4923d..6b3e04a3 100644
> --- a/libmultipath/dict.c
> +++ b/libmultipath/dict.c
> @@ -876,6 +876,14 @@ declare_ovr_snprint(detect_pgpolicy,
> print_yes_no_undef)
> =A0declare_hw_handler(detect_pgpolicy, set_yes_no_undef)
> =A0declare_hw_snprint(detect_pgpolicy, print_yes_no_undef)
> =A0
> +declare_def_handler(detect_pgpolicy_use_tpg, set_yes_no_undef)
> +declare_def_snprint_defint(detect_pgpolicy_use_tpg,
> print_yes_no_undef,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0 DEFAULT_DETECT_PGPOLICY_USE_TPG)
> +declare_ovr_handler(detect_pgpolicy_use_tpg, set_yes_no_undef)
> +declare_ovr_snprint(detect_pgpolicy_use_tpg, print_yes_no_undef)
> +declare_hw_handler(detect_pgpolicy_use_tpg, set_yes_no_undef)
> +declare_hw_snprint(detect_pgpolicy_use_tpg, print_yes_no_undef)
> +
> =A0declare_def_handler(force_sync, set_yes_no)
> =A0declare_def_snprint(force_sync, print_yes_no)
> =A0
> @@ -2121,6 +2129,7 @@ init_keywords(vector keywords)
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_prio", &def_detect_prio_h=
andler,
> &snprint_def_detect_prio);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_checker",
> &def_detect_checker_handler, &snprint_def_detect_checker);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy",
> &def_detect_pgpolicy_handler, &snprint_def_detect_pgpolicy);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy_use_tpg",
> &def_detect_pgpolicy_use_tpg_handler,
> &snprint_def_detect_pgpolicy_use_tpg);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("force_sync", &def_force_sync_han=
dler,
> &snprint_def_force_sync);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("strict_timing", &def_strict_timi=
ng_handler,
> &snprint_def_strict_timing);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("deferred_remove",
> &def_deferred_remove_handler, &snprint_def_deferred_remove);
> @@ -2212,6 +2221,7 @@ init_keywords(vector keywords)
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_prio", &hw_detect_prio_ha=
ndler,
> &snprint_hw_detect_prio);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_checker", &hw_detect_chec=
ker_handler,
> &snprint_hw_detect_checker);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy",
> &hw_detect_pgpolicy_handler, &snprint_hw_detect_pgpolicy);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy_use_tpg",
> &hw_detect_pgpolicy_use_tpg_handler,
> &snprint_hw_detect_pgpolicy_use_tpg);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("deferred_remove",
> &hw_deferred_remove_handler, &snprint_hw_deferred_remove);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_watch_checks",
> &hw_delay_watch_checks_handler, &snprint_hw_delay_watch_checks);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_wait_checks",
> &hw_delay_wait_checks_handler, &snprint_hw_delay_wait_checks);
> @@ -2255,6 +2265,7 @@ init_keywords(vector keywords)
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_prio", &ovr_detect_prio_h=
andler,
> &snprint_ovr_detect_prio);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_checker",
> &ovr_detect_checker_handler, &snprint_ovr_detect_checker);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy",
> &ovr_detect_pgpolicy_handler, &snprint_ovr_detect_pgpolicy);
> +=A0=A0=A0=A0=A0=A0=A0install_keyword("detect_pgpolicy_use_tpg",
> &ovr_detect_pgpolicy_use_tpg_handler,
> &snprint_ovr_detect_pgpolicy_use_tpg);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("deferred_remove",
> &ovr_deferred_remove_handler, &snprint_ovr_deferred_remove);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_watch_checks",
> &ovr_delay_watch_checks_handler, &snprint_ovr_delay_watch_checks);
> =A0=A0=A0=A0=A0=A0=A0=A0install_keyword("delay_wait_checks",
> &ovr_delay_wait_checks_handler, &snprint_ovr_delay_wait_checks);
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 0b3e7c49..9a98a7ba 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -68,6 +68,7 @@
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_prio=A0=A0 =3D DE=
TECT_PRIO_ON,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_checker =3D DETEC=
T_CHECKER_ON,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_pgpolicy =3D DETE=
CT_PGPOLICY_ON,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.detect_pgpolicy_use_tpg =
=3D
> DETECT_PGPOLICY_USE_TPG_ON,

This is supposed to be the default, i.e. DETECT_PGPOLICY_USE_TPG_OFF




> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.deferred_remove =3D DEFE=
RRED_REMOVE_OFF,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.delay_watch_checks =3D D=
ELAY_CHECKS_OFF,
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0.delay_wait_checks =3D DE=
LAY_CHECKS_OFF,
> diff --git a/libmultipath/libmultipath.version
> b/libmultipath/libmultipath.version
> index aba1a30e..8f72c452 100644
> --- a/libmultipath/libmultipath.version
> +++ b/libmultipath/libmultipath.version
> @@ -43,7 +43,7 @@ LIBMPATHCOMMON_1.0.0 {
> =A0=A0=A0=A0=A0=A0=A0=A0put_multipath_config;
> =A0};
> =A0
> -LIBMULTIPATH_18.0.0 {
> +LIBMULTIPATH_19.0.0 {
> =A0global:
> =A0=A0=A0=A0=A0=A0=A0=A0/* symbols referenced by multipath and multipathd=
 */
> =A0=A0=A0=A0=A0=A0=A0=A0add_foreign;
> @@ -116,6 +116,7 @@ global:
> =A0=A0=A0=A0=A0=A0=A0=A0get_refwwid;
> =A0=A0=A0=A0=A0=A0=A0=A0get_state;
> =A0=A0=A0=A0=A0=A0=A0=A0get_udev_device;
> +=A0=A0=A0=A0=A0=A0=A0get_uid;
> =A0=A0=A0=A0=A0=A0=A0=A0get_used_hwes;
> =A0=A0=A0=A0=A0=A0=A0=A0get_vpd_sgio;
> =A0=A0=A0=A0=A0=A0=A0=A0group_by_prio;
> @@ -141,6 +142,7 @@ global:
> =A0=A0=A0=A0=A0=A0=A0=A0pathcount;
> =A0=A0=A0=A0=A0=A0=A0=A0path_discovery;
> =A0=A0=A0=A0=A0=A0=A0=A0path_get_tpgs;
> +=A0=A0=A0=A0=A0=A0=A0pathinfo;
> =A0=A0=A0=A0=A0=A0=A0=A0path_offline;
> =A0=A0=A0=A0=A0=A0=A0=A0print_all_paths;
> =A0=A0=A0=A0=A0=A0=A0=A0print_foreign_topology;
> @@ -235,9 +237,3 @@ global:
> =A0local:
> =A0=A0=A0=A0=A0=A0=A0=A0*;
> =A0};
> -
> -LIBMULTIPATH_18.1.0 {
> -global:
> -=A0=A0=A0=A0=A0=A0=A0get_uid;
> -=A0=A0=A0=A0=A0=A0=A0pathinfo;
> -} LIBMULTIPATH_18.0.0;
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index 10b84948..df10a68f 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -280,6 +280,22 @@ out:
> =A0=A0=A0=A0=A0=A0=A0=A0return 0;
> =A0}
> =A0
> +int select_detect_pgpolicy_use_tpg(struct config *conf, struct
> multipath *mp)
> +{
> +=A0=A0=A0=A0=A0=A0=A0const char *origin;
> +
> +=A0=A0=A0=A0=A0=A0=A0mp_set_ovr(detect_pgpolicy_use_tpg);
> +=A0=A0=A0=A0=A0=A0=A0mp_set_hwe(detect_pgpolicy_use_tpg);
> +=A0=A0=A0=A0=A0=A0=A0mp_set_conf(detect_pgpolicy_use_tpg);
> +=A0=A0=A0=A0=A0=A0=A0mp_set_default(detect_pgpolicy_use_tpg,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 DEFAULT_=
DETECT_PGPOLICY_USE_TPG);
> +out:
> +=A0=A0=A0=A0=A0=A0=A0condlog(3, "%s: detect_pgpolicy_use_tpg =3D %s %s",=
 mp->alias,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0(mp->detect_pgpolicy_use_tp=
g =3D=3D
> DETECT_PGPOLICY_USE_TPG_ON)?
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0"yes" : "no", origin);
> +=A0=A0=A0=A0=A0=A0=A0return 0;
> +}
> +
> =A0int select_pgpolicy(struct config *conf, struct multipath * mp)
> =A0{
> =A0=A0=A0=A0=A0=A0=A0=A0const char *origin;
> @@ -291,7 +307,10 @@ int select_pgpolicy(struct config *conf, struct
> multipath * mp)
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> =A0=A0=A0=A0=A0=A0=A0=A0if (mp->detect_pgpolicy =3D=3D DETECT_PGPOLICY_ON=
 &&
> verify_alua_prio(mp)) {
> -=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D GROUP_BY_P=
RIO;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (mp->detect_pgpolicy_use=
_tpg =3D=3D
> DETECT_PGPOLICY_USE_TPG_ON)
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp-=
>pgpolicy =3D GROUP_BY_TPG;
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0else
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp-=
>pgpolicy =3D GROUP_BY_PRIO;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D autodetect_ori=
gin;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto out;
> =A0=A0=A0=A0=A0=A0=A0=A0}
> @@ -301,7 +320,8 @@ int select_pgpolicy(struct config *conf, struct
> multipath * mp)
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_conf(pgpolicy);
> =A0=A0=A0=A0=A0=A0=A0=A0mp_set_default(pgpolicy, DEFAULT_PGPOLICY);
> =A0out:
> -=A0=A0=A0=A0=A0=A0=A0if (mp->pgpolicy =3D=3D GROUP_BY_TPG && !verify_alu=
a_prio(mp)) {
> +=A0=A0=A0=A0=A0=A0=A0if (mp->pgpolicy =3D=3D GROUP_BY_TPG && origin !=3D
> autodetect_origin &&
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 !verify_alua_prio(mp)) {
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0mp->pgpolicy =3D DEFAULT_=
PGPOLICY;
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0origin =3D "(setting: eme=
rgency fallback - not all
> paths use alua prio)";
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0log_prio =3D 1;
> diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
> index 513ee6ac..73615c2f 100644
> --- a/libmultipath/propsel.h
> +++ b/libmultipath/propsel.h
> @@ -1,6 +1,7 @@
> =A0int select_rr_weight (struct config *conf, struct multipath * mp);
> =A0int select_pgfailback (struct config *conf, struct multipath * mp);
> =A0int select_detect_pgpolicy (struct config *conf, struct multipath *
> mp);
> +int select_detect_pgpolicy_use_tpg (struct config *conf, struct
> multipath * mp);
> =A0int select_pgpolicy (struct config *conf, struct multipath * mp);
> =A0int select_selector (struct config *conf, struct multipath * mp);
> =A0int select_alias (struct config *conf, struct multipath * mp);
> diff --git a/libmultipath/structs.h b/libmultipath/structs.h
> index 682a7e17..97f9de5a 100644
> --- a/libmultipath/structs.h
> +++ b/libmultipath/structs.h
> @@ -149,6 +149,12 @@ enum detect_pgpolicy_states {
> =A0=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_ON =3D YNU_YES,
> =A0};
> =A0
> +enum detect_pgpolicy_use_tpg_states {
> +=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_USE_TPG_UNDEF =3D YNU_UNDEF,
> +=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_USE_TPG_OFF =3D YNU_NO,
> +=A0=A0=A0=A0=A0=A0=A0DETECT_PGPOLICY_USE_TPG_ON =3D YNU_YES,
> +};
> +
> =A0enum deferred_remove_states {
> =A0=A0=A0=A0=A0=A0=A0=A0DEFERRED_REMOVE_UNDEF =3D YNU_UNDEF,
> =A0=A0=A0=A0=A0=A0=A0=A0DEFERRED_REMOVE_OFF =3D YNU_NO,
> @@ -396,6 +402,7 @@ struct multipath {
> =A0=A0=A0=A0=A0=A0=A0=A0char wwid[WWID_SIZE];
> =A0=A0=A0=A0=A0=A0=A0=A0char alias_old[WWID_SIZE];
> =A0=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy;
> +=A0=A0=A0=A0=A0=A0=A0int detect_pgpolicy_use_tpg;
> =A0=A0=A0=A0=A0=A0=A0=A0int pgpolicy;
> =A0=A0=A0=A0=A0=A0=A0=A0pgpolicyfn *pgpolicyfn;
> =A0=A0=A0=A0=A0=A0=A0=A0int nextpg;
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index 3b25b5d4..8a0ff0d8 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -254,6 +254,19 @@ The default is: \fIyes\fR
> =A0.
> =A0.
> =A0.TP
> +.B detect_pgpolicy_use_tpg
> +If both this and \fIdetect_pgpolicy\fR are set to \fIyes\fR and all
> path
> +devcices are configured with either the \fIalua\fR or \fIsysfs\fR
> prioritizer,
> +the multipath device will automatically use the \fIgroup_by_tpg\fR
> +path_grouping_policy. If set to \fIno\fR, the path_grouping_policy
> will be
> +selected by the method described for \fIdetect_pgpolicy\fR above.
> +.RS
> +.TP
> +The default is: \fIno\fR
> +.RE
> +.
> +.
> +.TP
> =A0.B pg_timeout
> =A0(Deprecated) This option is not supported any more, and the value is
> ignored.
> =A0.

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

