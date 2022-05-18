Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475CDC433F5
	for <dm-devel@archiver.kernel.org>; Fri, 20 May 2022 07:02:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-348-DV3FohhGOKyeWBKWc4NFhg-1; Fri, 20 May 2022 03:02:10 -0400
X-MC-Unique: DV3FohhGOKyeWBKWc4NFhg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 285F68117B0;
	Fri, 20 May 2022 07:02:08 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CE4DA112131B;
	Fri, 20 May 2022 07:02:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 50B8D194EB8C;
	Fri, 20 May 2022 07:02:07 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 18FF81947068
 for <dm-devel@listman.corp.redhat.com>; Wed, 18 May 2022 20:24:48 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id EE8D41121314; Wed, 18 May 2022 20:24:47 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id E89FB1121315
 for <dm-devel@redhat.com>; Wed, 18 May 2022 20:24:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD165811E75
 for <dm-devel@redhat.com>; Wed, 18 May 2022 20:24:47 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11on2078.outbound.protection.outlook.com [40.107.236.78]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-592-IRUlQ2pcN0ql5bZ08HJ7bQ-1; Wed, 18 May 2022 16:24:46 -0400
X-MC-Unique: IRUlQ2pcN0ql5bZ08HJ7bQ-1
Received: from SN6PR06MB4495.namprd06.prod.outlook.com (2603:10b6:805:92::24)
 by CO6PR06MB7748.namprd06.prod.outlook.com (2603:10b6:5:354::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 18 May
 2022 20:24:44 +0000
Received: from SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::397c:6fd3:92be:8efe]) by SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::397c:6fd3:92be:8efe%3]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 20:24:44 +0000
From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Thread-Topic: [PATCH 4/9] multipath-tools: add NetApp E-Series NVMe to
 hardware table
Thread-Index: AQHYZ+aiCmhVT7meYkS+M9Uf6jWdcq0lGSig
Date: Wed, 18 May 2022 20:24:44 +0000
Message-ID: <SN6PR06MB4495FAEC26D7A272C2DEDA498CD19@SN6PR06MB4495.namprd06.prod.outlook.com>
References: <20220514230148.139675-1-xose.vazquez@gmail.com>
 <20220514230148.139675-5-xose.vazquez@gmail.com>
In-Reply-To: <20220514230148.139675-5-xose.vazquez@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.500.17
dlp-reaction: no-action
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 21dc5d59-6c43-460a-8cef-08da390c7212
x-ms-traffictypediagnostic: CO6PR06MB7748:EE_
x-microsoft-antispam-prvs: <CO6PR06MB7748701876B8B3001061DAEB8CD19@CO6PR06MB7748.namprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: cY6L3lslXjQe7VDIX3OEzYCj1j/RtQvXRU8XapbQ42LFZSQvirtjR/kYL941b8yWMGKdboOO8CTr4ndnDksWaUVT9ntw9Dy5g6cO+ETGnp3vlCBjaDQDwzYiebmDQzdpRDguMVcQ6pfJSYxbgJxCVK6aDh2AExlY6TD4rS0UKGpHALWHhz0MbYu9l/bljgMv6/2fYosf4mddDXv0FiIU0haRJMHZGjhi3LJsPDMlXl9EJriljDwp8pNMjh8lhiCeIqjyy31aNoi11pZbgsDdklzXjhwJJU9tFzshbRIiwGe7v5pxrGhorr+8XL6mNngPD+/C93EKqmAVDDjBOGvXUhbSjV6tMxBVKDTZ7BmromSqZU8NgMnKEKDsSUB0gvO6nzcLJy0TSJaejxXOFEpG2tlE9H2eIDw6RJPvfO9mE8oYZyBFl5+3RpaOGtjhj0WtEHsnQgnKDTDh5B/SVLf0Bqu3adFz8KP7BaMhqrC6JTmDTcCPlydfS/XN7F006WRI1wBaYHpS3nu8RQdHgRa78S4R7zV3OGgl+SIwrNDhPTOEiw1HIriyZpFHRKs472r+vyAhTLZoYmqTt4hbfElQiQLp1CiBmIc228C5TASETRe+KnFBYbqUGyhMjh8z0hyOkHEpc0dZb2jTQ9diX2zyUFkIfsqicA6/2GKsNoYZnoIUxIsY4Lt1wvZ5620Gnqx54I4jt3576Wq8euVqRbOBkQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SN6PR06MB4495.namprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230001)(4636009)(366004)(6916009)(9686003)(54906003)(26005)(4744005)(86362001)(6506007)(316002)(186003)(52536014)(38100700002)(2906002)(76116006)(8676002)(64756008)(66556008)(66476007)(7696005)(8936002)(33656002)(38070700005)(122000001)(5660300002)(66446008)(4326008)(66946007)(71200400001)(55016003)(508600001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G5mIpTKDIz7lZ4kEc1m4WgegJhHtZJpMzpdl6NPvVneTW5mQPXUbbmXmLyv8?=
 =?us-ascii?Q?bGPonJlcrx2SzOAQzpk4pYrb/vtFe45i/KU0sJm32LTigTw3QWFF0wGC63hN?=
 =?us-ascii?Q?sKy2IPEu/t/w1qsjt6WBPf5ITGYWozy2lzaK1MwBvEsIlTqRym/u/WBsotxP?=
 =?us-ascii?Q?83o+8ectBW5wpnQjnqMXD8RJMjNb/0jl7jLq+KGYHaNKTxSeKUmlK4Db00y4?=
 =?us-ascii?Q?EHV+lOUV7vksu4PNmRvuYaTFdfbKxh3fdwhqPBARJz/ynjT5Gq98vVjCrwz6?=
 =?us-ascii?Q?z0TXEI6YZ95d3LsLLrOFU3QKhXCDgFjcRcl51/WfJUz6WW6UqT0UM3BQF8y1?=
 =?us-ascii?Q?QNGvB8tOUvuPGnVl4ikP/IEoDAHvTdzgSdhJvLS9ot24e7cMUc0FJwSSfYqB?=
 =?us-ascii?Q?t/wB5Mzy2KaLEmZEHm/iezdSlfa/yl5ytRYxf5c5WpcqsMvlL9CSZ69kBt0W?=
 =?us-ascii?Q?xQ1S0lmP3Ti7ayb5gz6jCr77W344kQAYIwELlVYegngOgr/8G5bLpMcwAnlR?=
 =?us-ascii?Q?N1ewYeposuiY+46x3q7niCjOVAR/+FRDyPJngYaYUQX+kGP98iswU4X8u90k?=
 =?us-ascii?Q?UwK7nZXAzojdA+mb7ntWhBk5ekgYwkFmkjVKUHpHMK9U18AQBDmy5gHTMFiq?=
 =?us-ascii?Q?p21j4XEDZ+o2u/rHRAKNrIhJ6EHsTkSDSzaIR7/PpR27VnXdFEe1dU64q/cd?=
 =?us-ascii?Q?gdXxQc4ZrEhpwdbQXzM2JdvRweoysY5SqjCTt1ty8rbAgBY6CdLcuyzdHoQV?=
 =?us-ascii?Q?rhwr2y02Nop72rVTYjZzhAkUl+/o1+kSehRclbtqcNqfu5qPPBvhyf7ZMRTe?=
 =?us-ascii?Q?u4IqIcU/TRAWgc9GK6punfUCXHjVAQEmTeiQz3GvYIP3uhbO56kQEBsU12VT?=
 =?us-ascii?Q?sd1Cc+vgwjoZxlOKiqyAbTK7HG9vacvsv/Ln3CB1cWtwWqs+jTXMbPqdaX6o?=
 =?us-ascii?Q?2mLTXfy4ivHW754ARIhWPwWDBvvfooGpSNnOA+MebnwbaB38GrqoQn2MN3K+?=
 =?us-ascii?Q?H2SbnI/UsSVDO65juQlrIPTWdnZ6yXNdV97IB1ZsKHe1XJw+WzMA1lPStSmP?=
 =?us-ascii?Q?31OXtnLzj6AHb67E0+lgaSuLw5MKLFCOYovgvFOE8E6sfsUQAH2FaXfygO/J?=
 =?us-ascii?Q?kFDvs/8z+werUZ51zO3ohkANSX8PSWcJNDhiCkLOVdOl9d2rtzlJV0WwTnnp?=
 =?us-ascii?Q?AK7z243avO03HYCfmBr4m1zDSg4dFPv3HXH9UCp6aKrQaBws+rOwBlOQbFFw?=
 =?us-ascii?Q?pFI5NnB+xEA9Wxbz4ivGkRc1x9ejCz39EJpCtIcrfIyw4+/EWhcKuLv65sBB?=
 =?us-ascii?Q?P88AncTkU9tot4sCJecUo8IvzJUB9IJFwlFYxx7tPnnT3OCKwlX6MvxmFQrA?=
 =?us-ascii?Q?4FWgsbK/bA+zSns1qBs05bJmz0TFkoRwJPuBuwd/v8iaYmfwxhJbIZPmNg/X?=
 =?us-ascii?Q?M0mn2hnSHBAe4ysfC0tjefRvoyh+ZAV9JWN75lgv3plXAoymrXOK5gRK6Xt6?=
 =?us-ascii?Q?fPpGnbKusoXHMI0OXLnYX0QmuSv0nEKPh22Grjuj5lMfQcresRLNewh1NHbR?=
 =?us-ascii?Q?ImZ3fzJBjs2gWgTN7ZdOz0/tG/DxXTmj6/RoB1aBeZtcPqG3xH3r+SsdkwRJ?=
 =?us-ascii?Q?AkWsgWf5Shu0xVtlthbZ2P74WNtuHcPbEf+HY0sjycI07WjXEU4iB7vPOLbg?=
 =?us-ascii?Q?LjljvSep/UPBc/eXe+ZwazsjA1iDqhO2i/+GuneyZLigrQ+VDB3fmIx/SZ8A?=
 =?us-ascii?Q?rszkmo/LgQ=3D=3D?=
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR06MB4495.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21dc5d59-6c43-460a-8cef-08da390c7212
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2022 20:24:44.2399 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y6ILr14iMTr5gODm7QvZsJibEePrlUQzNSbVW+p9/hIfGQnNDUFVc/3h0ydBlEFQzal++UEnELZQ9480wCCCVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR06MB7748
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Mailman-Approved-At: Fri, 20 May 2022 07:01:49 +0000
Subject: Re: [dm-devel] [PATCH 4/9] multipath-tools: add NetApp E-Series
 NVMe to hardware table
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
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: Xose Vazquez Perez <xose.vazquez@gmail.com>
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
> index 814e727a..61a5aa16 100644
> --- a/libmultipath/hwtable.c
> +++ b/libmultipath/hwtable.c
> @@ -845,6 +845,15 @@ static struct hwentry default_hw[] = {
>                 .pgpolicy      = MULTIBUS,
>                 .no_path_retry = NO_PATH_RETRY_QUEUE,
>         },
> +       {
> +               /* E-Series NVMe */
> +               .vendor        = "NVME",
> +               .product       = "NetApp E-Series",
> +               .pgpolicy      = GROUP_BY_PRIO,
> +               .prio_name     = PRIO_ANA,
> +               .pgfailback    = -FAILBACK_IMMEDIATE,
> +               .no_path_retry = 30,
> +       },
>         /*
>          * NEC
>          */
> --
> 2.36.1

Nak. NetApp E-Series only supports these settings in certain configurations, and we prefer to handle it via our installation documentation.

Thanks,
Steve

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

