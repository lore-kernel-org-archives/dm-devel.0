Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6714BECAAA1
	for <dm-devel@archiver.kernel.org>; Fri,  9 Sep 2022 16:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1662740052;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=niUOmw7eTUUBXgu7T4wor5WIUlMeHTG24yc4TZHEvKk=;
	b=jLmayQs4p/1V5Vv6okmHdJ0zk1CtVMApZnuSoQKlbifeA9w80+tAqveo4yBUo8kAD1Q8XQ
	WWIU1ysPYd7LWdaoORKZL3vF8Tch6p9GvfpH2CTQGn5P8FJwhZNq2LJYS496emjOuk0m7v
	Gf/EriwI6B60DGEoGQnfVv1+pXT5QdQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-630-6B-bGqd6M42Yk5ZRDd0JlQ-1; Fri, 09 Sep 2022 12:14:08 -0400
X-MC-Unique: 6B-bGqd6M42Yk5ZRDd0JlQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4197438005E3;
	Fri,  9 Sep 2022 16:14:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B37F0492CA4;
	Fri,  9 Sep 2022 16:14:05 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 853C71946A42;
	Fri,  9 Sep 2022 16:14:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A866A1946A41
 for <dm-devel@listman.corp.redhat.com>; Fri,  9 Sep 2022 16:14:04 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 8C85D4010D42; Fri,  9 Sep 2022 16:14:04 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 880F4403D0E0
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 16:14:04 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 684861E68187
 for <dm-devel@redhat.com>; Fri,  9 Sep 2022 16:14:04 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12on2063.outbound.protection.outlook.com [40.107.237.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-226-6kKeNPptMMGZn3Awy9unQw-1; Fri, 09 Sep 2022 12:14:00 -0400
X-MC-Unique: 6kKeNPptMMGZn3Awy9unQw-1
Received: from SN6PR06MB4495.namprd06.prod.outlook.com (2603:10b6:805:92::24)
 by DM8PR06MB7799.namprd06.prod.outlook.com (2603:10b6:8:3c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 16:13:58 +0000
Received: from SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::6c7c:6b85:fb03:ed]) by SN6PR06MB4495.namprd06.prod.outlook.com
 ([fe80::6c7c:6b85:fb03:ed%5]) with mapi id 15.20.5588.010; Fri, 9 Sep 2022
 16:13:58 +0000
From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Thread-Topic: [PATCH v3] multipath-tools: add more info for NetApp RDAC arrays
Thread-Index: AQHYxFaFuUKfOeg3vkah/egKB/gTNK3XQulg
Date: Fri, 9 Sep 2022 16:13:57 +0000
Message-ID: <SN6PR06MB4495266835943AAE384090A98C439@SN6PR06MB4495.namprd06.prod.outlook.com>
References: <20220909141420.23188-1-xose.vazquez@gmail.com>
In-Reply-To: <20220909141420.23188-1-xose.vazquez@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.600.2
dlp-reaction: no-action
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20c20e8d-468c-49bf-3ffe-08da927e4cef
x-ms-traffictypediagnostic: DM8PR06MB7799:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: BmFi0+ER+db0D9dHsBVf0/Z6gaVeZDVsY7l6tykb9FNOeoeNAevcLhII+OA+pY+D6tBiqeHNbIM++3epUzu/OaLXHnRDTRryOn3ReKLLfgAwroVteafG3I3hrVCBq9Tkr2O60qq6lUAbSb9XYtyoj/Qw0LPGeZV8HnS+e3kGX+kmJuUqbnPnV553bNmRt/0zR0UGxQ0Vw600WQgCeZPsoqWYrSScUTSS6OY1dW1qQCdueyvLnOcAxPzZmqsuf7h6OTuMjLs6Qf9OHpX1IFI1Skd6A5zRtHvveQrCCr/pruuajdVqn2NBSWVKZxfS47ObcMq0ig5/HQHopTOPv98L44x83k9BvHKwiX+HJ7bh50xJc5QD4CaqdZFHom2ZkDQGEbcNlo8EJ5vafiWEwVrybsIXaHJY+zM8KaMAau/RaJDy25Hw81YrWNidKe8wBFCoO5LoOBqVIvocU4Rv/RFFo/8pVMdToxftPuCZz9LyRdjqCRY0+d+lJ46Vq1AHZQLPuMbBkSwxzULj719gUZIRTFUOjy0hNq/L2UhKqfsvs05UfqnFbSm9MPzZOgeOzMaPgqoskZIzv1xtS7fTu/0FsUZac1WiAwynoY3He+O0b3oEMGN2+pMZ/AcJSxb1oP8stM218E3bLc/LBECEIIH5SQugeCjkv3tEuNVQcgv9Joeezb7luqEExrBftnx+Z0xxxnAcsYylM6w+4jpt3ff9E8amHl38NuDw962qM475FqnAn0DDnYyFBGPj8ILalWVNYm9UQV1he/g6XRzMtpwvIlUA9gP63nm3QGLwNsjH5HMpPycd3qteT9rpeKMGMMzsgHvUW1vnoG5v19BP0oy/pQ==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
 IPV:NLI; SFV:NSPM; H:SN6PR06MB4495.namprd06.prod.outlook.com; PTR:; CAT:NONE;
 SFS:(13230016)(4636009)(39860400002)(136003)(376002)(366004)(346002)(396003)(7696005)(316002)(6506007)(71200400001)(8936002)(53546011)(122000001)(38100700002)(55016003)(66476007)(26005)(66946007)(76116006)(9686003)(966005)(64756008)(66556008)(8676002)(66446008)(4326008)(54906003)(6916009)(41300700001)(5660300002)(478600001)(52536014)(2906002)(186003)(33656002)(83380400001)(38070700005)(86362001);
 DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?GCKh7vEpgoeWPGccy8S0TR/l7eY/4SOnbXKLxOsZPMWP0j/LeY9X9ZOn9AYo?=
 =?us-ascii?Q?/zTPAyZOhHmDaBv25fAwCWHIRz+CNZtiu/BfC+3DaVBcnTVJIHcrYIqiWAEK?=
 =?us-ascii?Q?Y7DwZmxHT4ZDRRt8SK7GpRZXETZLRwbhN2MCFfeP0MkvsyuYfMoeg3O0DoNI?=
 =?us-ascii?Q?TIAyTJ3YH2tisfQYuGxaEW3eWncqWXLMaGsJz8ceMchkwniTIbXx9DPNkBQs?=
 =?us-ascii?Q?THby0HpwrkH71v3izmYyb1UsrdluM7J1S1/li4Cq2GSdMz6/FRYQI3UB/nol?=
 =?us-ascii?Q?/kkPZAoKTPaHk91ayuFOotIEoUdRH6OjAR3NlSOHDNXmqmueRU8i8X0KOcNF?=
 =?us-ascii?Q?T3lhZNPu/WeObhNnNJY1J2isZtoufrcnpwIoSrfWCCVqNgBcErBVVWjPNHtY?=
 =?us-ascii?Q?3fdHLEyWCIE1l7Z0DsSzee2I0gKZfo4sdcTdehehnZAYH/tWudQmKec3+qMu?=
 =?us-ascii?Q?Muya0FdLhZIKRR/U83WUpuAYOkkvCc6DdHcF+iK+TO5AP940kYdAflE7mx4l?=
 =?us-ascii?Q?8Hl86bmOONsgYETVcmb3DrdLjPmkfYJ6TBmWgKXJizpwjDyvZ3P1l9yzJE4+?=
 =?us-ascii?Q?8quMrbEi3wp1E+LWPR6d2D8MA6SQlo4hc1D81RuuUJdDCfHdKPU/Jzje0IG4?=
 =?us-ascii?Q?Nmuo44bXTCFP/o4d6CotBRachEGoPLIvKF2FO2qjdNFs+dSu0u+kbE/4dAn/?=
 =?us-ascii?Q?5qAF6d7srKXX95OuoUvChY1BnuUaa66sHUMhfJItuFo8JOH3Q3rGNTUnPQmQ?=
 =?us-ascii?Q?uMfT3kTA6zP+rSf5ywDlK9wsD3C0MGX7NzYPiRJwldK8nyuIs6/qLqhJjQX8?=
 =?us-ascii?Q?iBp/IxPC0NZniI4xF8r8O4EUgcsGTsRIfoGpcOhKuJvq9BU+FDEBhlc/xjvL?=
 =?us-ascii?Q?VYVU7ra6o8TOOZ0hcM++G/zbx28UwnBSTlyK3/boJSmN4cHHPuxZlTtftni5?=
 =?us-ascii?Q?wK0mxRy2CUagPy31t/mEno7o5cdjkm3Zw8GGHTDkOt4Mq46tao8GsvY6jytG?=
 =?us-ascii?Q?Dpw6sxXG32H9XH11SMOU7Qe0W/u99rZGDzifForZAr30gIMFXeqIs2HkXx/G?=
 =?us-ascii?Q?nvqH6dD8XtXmAoH0lkQ8FDuQfxmat4QcT4wOJvyUOf378TjyFDgAf3b8ikQn?=
 =?us-ascii?Q?Lv3fthSe+BbpNcsmDaOuPP3sy4MmbTAzKpBRFUpWig5RQxvvfB9d3iKEY/wQ?=
 =?us-ascii?Q?GNIXu9bvCfzwvfo7rN2S5Zs+VETdvHrGsrnGoNtWbK+Fwz0oxfNtQZBe8iZ/?=
 =?us-ascii?Q?S4Syg20SbE14b3FtZqrtuJDHrOP4lGSHY39AvCW2upaQAuppkPbmbHADw4Bq?=
 =?us-ascii?Q?3H2Pj5/VK0uWbPPiyeVuq+X8/u4vUjDvwE0usoqBhhYOqSpIpSMWgy8L+LDs?=
 =?us-ascii?Q?ru2Shw5aTOwMJw48TYEYSRSrghXLmOLWUbmJ54N7wC/HE4tPRa91BHGfORyl?=
 =?us-ascii?Q?ve9YoSdEDd2AmEzYfKHHporsKRhCsk/kQgPu20COMbYnK396nKmVrbSaGXbK?=
 =?us-ascii?Q?nHj1s+VBe329Ym/+PCQ48oTtSNe3EHqND84Mg7AgQCWIM1QAQNy+YNSToUYB?=
 =?us-ascii?Q?mAUyl+BtAKEOT6BRhlo4tRSWMCM6Mimr8F2HClWI?=
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR06MB4495.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c20e8d-468c-49bf-3ffe-08da927e4cef
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2022 16:13:58.0160 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RpIpnyTicnidrRMzJjKhvoEP05tmMLEEE2XecrdzOASogtoK6BCr8fKDkcvOvKUH/AjwiuVKntYQV3B1UAzbxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR06MB7799
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Subject: Re: [dm-devel] [PATCH v3] multipath-tools: add more info for NetApp
 RDAC arrays
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
 DM-DEVEL ML <dm-devel@redhat.com>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: Xose Vazquez Perez <xose.vazquez@gmail.com>
> Sent: Friday, September 9, 2022 9:14 AM
> Subject: [PATCH v3] multipath-tools: add more info for NetApp RDAC arrays
> 
> To use ALUA mode:
> "Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10 or
> later)".
> 
> To use RDAC mode:
> "Select operating system:" should be changed to "Linux DM-MP (Kernel 3.9 or
> earlier)".
> 
> Info from:
>  https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-49E94674-
> 947F-4921-A1D1-CE9B42DCBA39.html
>  https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-CA17AE34-
> F5B2-4FF4-8FD4-4A7AA4238976.html
>  https://library.netapp.com/ecmdocs/ECMLP2439710/html/GUID-3DA657A9-
> FF4A-4237-90EC-BA8863B7431E.html
> 
> Add it to prio and hardware_handler.
> 
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Cc: Martin Wilck <mwilck@suse.com>
> Cc: Benjamin Marzinski <bmarzins@redhat.com>
> Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
> Cc: DM-DEVEL ML <dm-devel@redhat.com>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> v2: delete "Automatic Load Balancing option" obsolete info
> v3: a part of the body wa trimmed by git
> ---
>  README.md                  | 2 +-
>  multipath/multipath.conf.5 | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/README.md b/README.md
> index b05b1332..45234dc6 100644
> --- a/README.md
> +++ b/README.md
> @@ -165,7 +165,7 @@ To enable ALUA, the following options should be
> changed:
>     "LUN Affinity" and "ALUA" should be changed to "Enable", "Redundancy Type"
>     must be "Active-Active".
> 
> -- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and OEM
> arrays:
> +- LSI/Engenio/NetApp RDAC class, as NetApp SANtricity E/EF Series and
> rebranded arrays:
>     "Select operating system:" should be changed to "Linux DM-MP (Kernel 3.10
> or later)".
> 
>  - NetApp ONTAP:
> diff --git a/multipath/multipath.conf.5 b/multipath/multipath.conf.5
> index acdd1ae6..6018fa54 100644
> --- a/multipath/multipath.conf.5
> +++ b/multipath/multipath.conf.5
> @@ -320,7 +320,7 @@ Generate the path priority for NetApp ONTAP class, and
> rebranded arrays.
>  .I rdac
>  (Hardware-dependent)
>  Generate the path priority for LSI/Engenio/NetApp RDAC class as NetApp
> SANtricity
> -E/EF Series, and rebranded arrays.
> +E/EF Series and rebranded arrays, with "Linux DM-MP (Kernel 3.9 or earlier)"
> option.
>  .TP
>  .I hp_sw
>  (Hardware-dependent)
> @@ -1568,7 +1568,7 @@ with Failover Mode 1 (Passive Not Ready(PNR)).
>  .I 1 rdac
>  (Hardware-dependent)
>  Hardware handler for LSI/Engenio/NetApp RDAC class as NetApp SANtricity
> E/EF
> -Series, and rebranded arrays.
> +Series and rebranded arrays, with "Linux DM-MP (Kernel 3.9 or earlier)" option.
>  .TP
>  .I 1 hp_sw
>  (Hardware-dependent)
> --
> 2.37.3

These changes look okay. Just keep in mind that multipath on the Linux host
operates in the proper mode (alua v rdac) based on the E/EF Series behaviors,
without putting any special settings in multipath.conf.

Reviewed-by: Steve Schremmer <steve.schremmer@netapp.com>

Thanks,
Steve

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

