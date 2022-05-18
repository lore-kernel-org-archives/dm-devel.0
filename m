Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9920C433EF
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 07:01:59 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-CbSSgiCCM3mxEHyhEsVvtg-1; Fri, 20 May 2022 03:01:57 -0400
X-MC-Unique: CbSSgiCCM3mxEHyhEsVvtg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EAE9F1C04B55;
	Fri, 20 May 2022 07:01:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A28C1492C3B;
	Fri, 20 May 2022 07:01:55 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1B755194705A;
	Fri, 20 May 2022 07:01:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 64A661947068
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 20:38:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 38826400DFAB; Wed, 18 May 2022 20:38:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3126540CF8F0
 for <dm-devel@redhat.com>; Wed, 18 May 2022 20:38:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 18B86382ECCF
 for <dm-devel@redhat.com>; Wed, 18 May 2022 20:38:23 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com
 (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-cVZlfdzrN4K2ezBNWcEoIA-1; Wed, 18 May 2022 16:38:21 -0400
X-MC-Unique: cVZlfdzrN4K2ezBNWcEoIA-1
Received: from SN6PR06MB4495.namprd06.prod.outlook.com (2603:10b6:805:92::24)
 by MWHPR06MB2623.namprd06.prod.outlook.com (2603:10b6:300:47::18)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 20:38:18 +0000
Received: from SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::397c:6fd3:92be:8efe]) by SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::397c:6fd3:92be:8efe%3]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 20:38:18 +0000
From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Thread-Topic: [PATCH] multipath-tools: add ETERNUS AB/HB (relabeled NetApp
 E-Series) NVMe to hardware table
Thread-Index: AQHYaFzZ1bNkKLzomUKwibwV8VDd6q0lG/tg
Date: Wed, 18 May 2022 20:38:18 +0000
Message-ID: <SN6PR06MB449521624D788931B0714B078CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
References: <20220515130812.189374-1-xose.vazquez@gmail.com>
In-Reply-To: <20220515130812.189374-1-xose.vazquez@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1dbc619a-1b5d-49a1-d5b3-08da390e578d
x-ms-traffictypediagnostic: MWHPR06MB2623:EE_
x-microsoft-antispam-prvs: <MWHPR06MB2623EA8AFDFECBA44E04F16B8CD19@MWHPR06MB2623.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: wo/JOxnGgFRFK5STvNtDScgk5Wnp3GkNLlViLQ84DK2CYd2NjBWjcjvKfbee7W8z49jReXgyTLlLvnf2SvXbHyHET90aftWjfwQMf6Uw9j//7RBro/9+Qh1CCZDT/T3+bHTWuYN+mygxQd53YVMe2ZPW0wse+dWfMs37/Qbihwv5UIb9ZshIQ7PjZ6megVPgkm6UxDvhbWGsvYDQdz/Lj+9areMeNCzjgZ3t0EbaV+X6y69mmloyccrQfiq5/LvqL4tWkMNdgPuorhZXVP4i4iwZK2YepeIYZpDlccb8Jd1GeGw9lHRsh7gQDh31+d1Os0gwPnNTGfwq2+cniJOwjTXQW9dMixJWJ+QwEYPXH97w17SZVy4aLfn+H+0VMcm22q/fpbEt3H3+MYsORyNxY2tiKEMMXYeq9cKVUnNQqoSDMIfx3zgttjlE+LJnZ13uamTjx785AWnJwsuhlsYtF8MWlE1DAUbqmYttMZ1UsrOcIyuiWcol9WgHJlm0tu77sCeAXzAfVAcaNWZy30sgqcx+XeYzRcIhLRj/QSi6ZTGO67JS3dbvrOupFDAXPyOo29+OlqKKDepelBi5AJVYa63ejgpXpKZN3IoiYymljDP9XWd0EY5AyXw7X4+9ydnH9GeWV87pi7QsLPMbkMiUzp9H6vn5oZfUvrpJgNH4Gp0dUwmGCq0hQ9jvFsWKZ5oS1Myj62SlINgQVQJLic3Tfe5d4Sp9QuugiA2WpOcSxocSjCgiWg6Y3esjoabPxJxXgv/55lDVvc6uKmJ5SKas1f4zakfCu7MtCZQGUqXkcVI=
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SN6PR06MB4495.namprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(508600001)(66446008)(64756008)(316002)(2906002)(33656002)(55016003)(966005)(54906003)(6916009)(38100700002)(38070700005)(66946007)(66556008)(7696005)(8676002)(86362001)(122000001)(4326008)(66476007)(4744005)(26005)(71200400001)(9686003)(5660300002)(186003)(8936002)(52536014)(76116006)(6506007);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?A0JBott/PPnD+oqg9f5QCPJcMAm7zcTITmb2wzlEMKXtT2icKQRGXQE6xzmO?=
 =?us-ascii?Q?kmTsSvMbs/yO/UHryYs0pGDAsQeLujK+5B8KWxQWgwxljeJppZXMDxDZADfx?=
 =?us-ascii?Q?+Z3DPRAESskUamtmNgEysHSZgLRQktOlvQmpwpGUOUAXrQnzCLz/FVLIJoQH?=
 =?us-ascii?Q?VrYZSlnERISW3CM7ZMlQEBy/4Umt0U9wXDvk+4QuqYLSqSjf7dsTIY2voW5M?=
 =?us-ascii?Q?9yhDRUf4RCad5+0TF+Gz2tnP1X1pS/2bDe8aBfHrbLrbK6o4BmJBh/0S8Chv?=
 =?us-ascii?Q?nE+HurAQzeYxRLroeIhGXrUwwdipsCPdy1SU3Pxku2rds4Nf1Afs7WAAnXUN?=
 =?us-ascii?Q?0vo0HF9d6bIqGS3llPrcXJxJIh6jZ9PdpaEf2eWmvajaQNWd5qgxDHk6OrUV?=
 =?us-ascii?Q?cIB3MmzA93Ra1i6WlDUypppbAw5OzmYkCSzZVWy6xlBtOq1Tyg94Ul+sR/Ep?=
 =?us-ascii?Q?+oYvIOMXBBdBiAZvmo46dh/iZM/wzk5F/JbgF5JEJL9i/NVpL6VnoILijvgr?=
 =?us-ascii?Q?Cs9qlsGGQ4938QZDUyJFnPnF6OYihMp9Q7pMmLnmsyy+KluNNJ242x+rLfzz?=
 =?us-ascii?Q?oSQg2XpfFz4fhOgERIen0JKIrB7qMZZU5C2vcxAlzvqRV5Eyjq45QQTpu1+B?=
 =?us-ascii?Q?roLqgk9at53xDjpWmN2s4vOQfLJ09UOqEUr2GZlnlGrRzhqke4J3LaE3PuVD?=
 =?us-ascii?Q?vcASTtAh+dUrDMtq5Jh+fv1lhla8Ysio8BjoTQWm1sj9UxgB/ZjJFQbzZKUz?=
 =?us-ascii?Q?OGQDgTlqdgmDPq3mg6kc8ND8N98sfC9sl4tTbG4gN44kwyzcY5nBy+kfAtJa?=
 =?us-ascii?Q?ZP6YCO1wdF9CLhk+IJUgB0HQ0cJhqj1QRFdfRIXL4ZI8gPTcI0qS4rieu0PS?=
 =?us-ascii?Q?G824P+EiYvPZxgzcBk40Rhf6uPXIRz4t+H2rwLLWgpPVzfT0XVM9/ZsRt/+c?=
 =?us-ascii?Q?N7hEZ672SdM0wD7t5tiNuapU8Y+2TzBV1UUi+mSiajCMiPFqdVfPvKkEoedh?=
 =?us-ascii?Q?6GTJuAoDn4uyrfMoirprSy81kwY5mQKioSk1mrYGI1npbYEq5cTO4K3SuIP+?=
 =?us-ascii?Q?Ge573dlM3vCCj95Q3plJYLoJOtV+TnrIdjDNMqRdU2v54wnwn3FP9FZWibSo?=
 =?us-ascii?Q?nw+8WeZQCjFbMGjfb/J2/cTa0GgjrOeHjzS0ZMXUmMitLgVHEK3BqL3Wid4R?=
 =?us-ascii?Q?9seu+9BHXIwWtZiIdVsgMQnItlyX1MGA7j8DIdS6wZdAGhCAqBQYV/++pt8r?=
 =?us-ascii?Q?ku/NIeTrlIMei1YZsNl/PTxGjiA4Zh1bbIl0OGDlcXFARQ4Kg2bOrKPXi92S?=
 =?us-ascii?Q?IPjQUEXIi6W+2h+iOrhqDukkiHB2vEI+e2uJrImrOr1JfAgKEoPJlISO4HT0?=
 =?us-ascii?Q?ME3IpmQhWOT0cTP3dVLxjiB8SKrh8ozr/+jNK7NJxsJnCNF5Fsr5cnIPSGTM?=
 =?us-ascii?Q?N+2LfuM8iCnvLQp3k7nYF6UARNViWaMRVnLKX6rPPq4LDh1rYzESYJ9vN/OC?=
 =?us-ascii?Q?X9SglEii9z84N3zyaUYpvwxaXFwW6kk2Q1k4MkvYrSsKWL5n9JP/dvH/mU6x?=
 =?us-ascii?Q?nQem6n/wRBjKnt5dZik3mJV6zLbEx0FnWI3o5K+dnglyeiy3+uXmV/zCh+B5?=
 =?us-ascii?Q?LMjPBbf4SVwwOVx2v0nro4VwIrJgC+q54IbWfMblp/ePAjkXM0ROOjLijTCy?=
 =?us-ascii?Q?wDqf8nNLqWYvuzh1fxo+pNj86NZaGxdiVI3ZmVXeaH6OK75rCZ858ym2KRRv?=
 =?us-ascii?Q?PZP3l5eKXw=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR06MB4495.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dbc619a-1b5d-49a1-d5b3-08da390e578d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 20:38:18.7272 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rMNTGKeF5Gny4TH2La5WKhMzonP97zwoQcZuNzI2xaquQziOeJJtxHtxsfAHbeydEwUEqDW96OOhIRft+Qaf3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR06MB2623
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Mailman-Approved-At: Fri, 20 May 2022 07:01:49 +0000
Subject: Re: [dm-devel] [PATCH] multipath-tools: add ETERNUS AB/HB
 (relabeled NetApp E-Series) NVMe to hardware table
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
Cc: ng-eseries-upstream-maintainers
 <ng-eseries-upstream-maintainers@netapp.com>, Martin Wilck <mwilck@suse.com>,
 DM-DEVEL ML <dm-devel@redhat.com>,
 Christophe Varoqui <christophe.varoqui@opensvc.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Info from (page 88):
> https://sp.ts.fujitsu.com/dmsp/Publications/public/a3ca08733-a105-EN.pdf
> 
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
>  libmultipath/hwtable.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
> index 47ea5d3d..39daadc2 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -477,6 +477,15 @@ static struct hwentry default_hw[] = {
>                 .pgfailback    = -FAILBACK_IMMEDIATE,
>                 .no_path_retry = 30,
>         },
> +       {
> +               /* ETERNUS AB/HB NVMe */
> +               .vendor        = "NVME",
> +               .product       = "Fujitsu ETERNUS AB/HB Series",
> +               .pgpolicy      = GROUP_BY_PRIO,
> +               .prio_name     = PRIO_ANA,
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .no_path_retry = 30,
> +       },
>         /*
>          * Hitachi Vantara
>          *
> --
> 2.36.1

Nak. These settings are only supported in certain configurations.

Thanks,
Steve

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

