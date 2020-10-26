Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCB2AC55179
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 08:43:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 1A1812224E
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 08:43:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A1812224E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=netapp.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-akq58gifNXi2ljcFm0SCJw-1; Tue, 27 Oct 2020 04:43:12 -0400
X-MC-Unique: akq58gifNXi2ljcFm0SCJw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 873855F9DA;
	Tue, 27 Oct 2020 08:43:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 3F4155B4BB;
	Tue, 27 Oct 2020 08:43:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 60F821832FB8;
	Tue, 27 Oct 2020 08:43:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QFqwcc020358 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 11:52:59 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id BA3F2202348A; Mon, 26 Oct 2020 15:52:58 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B2FB9202278E
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 15:52:53 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 81F3F102F1E2
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 15:52:53 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
	(mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-573-VUR8JQzaMreIlBdtIw1nUw-1; Mon, 26 Oct 2020 11:52:51 -0400
X-MC-Unique: VUR8JQzaMreIlBdtIw1nUw-1
Received: from DM6PR06MB5276.namprd06.prod.outlook.com (2603:10b6:5:10e::20)
	by DM5PR0601MB3765.namprd06.prod.outlook.com (2603:10b6:4:7b::20) with
	Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.28;
	Mon, 26 Oct 2020 15:52:49 +0000
Received: from DM6PR06MB5276.namprd06.prod.outlook.com
	([fe80::cddc:5456:15de:61bb]) by
	DM6PR06MB5276.namprd06.prod.outlook.com
	([fe80::cddc:5456:15de:61bb%6]) with mapi id 15.20.3499.018;
	Mon, 26 Oct 2020 15:52:49 +0000
From: "Schremmer, Steven" <Steve.Schremmer@netapp.com>
To: Benjamin Marzinski <bmarzins@redhat.com>, Christophe Varoqui
	<christophe.varoqui@opensvc.com>
Thread-Topic: [PATCH 4/5] libmultipath: only read 0xc9 vpd page for devices
	with rdac checker
Thread-Index: AQHWqYGhCXEMRQe+r0GhhZnKHjbNT6mqDBhw
Date: Mon, 26 Oct 2020 15:52:49 +0000
Message-ID: <DM6PR06MB5276B4BFBB6865F33016B9068C190@DM6PR06MB5276.namprd06.prod.outlook.com>
References: <1603487708-12547-1-git-send-email-bmarzins@redhat.com>
	<1603487708-12547-5-git-send-email-bmarzins@redhat.com>
In-Reply-To: <1603487708-12547-5-git-send-email-bmarzins@redhat.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [98.187.40.65]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 489af52e-cc73-427c-42cd-08d879c730b1
x-ms-traffictypediagnostic: DM5PR0601MB3765:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR0601MB376527FCF9F08D775DEF81078C190@DM5PR0601MB3765.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: ixhoJbWVZQYrZzmFuTBQoQg09UZ4uQpe/l3+YwUXW5UGwCCnBbeAv/NUze0g7zywc8kUZNhMPsuyjkrq3eSEU9hRCpnUtfe/crCZbAs9UqzayA0iQfNxucbQJnTWZUubCVcwMSadj4PymXMiZg97fTYthgEy0ZaWkNePM0U9H2KGkoL6kb4bXSfG5rJNWAYrupZRw8GQ8RpMsQ8eVrjpo5MuXBqUWV9bc/ojYDiYjgElpNQDTH/HX6j7xY8qKdhB7EOr0qdR/808eHBxnE+TKAI3LwmgOhyDmPse0QQhWVVJKB7WILfxRKM08Zm0j8bI
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:DM6PR06MB5276.namprd06.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(376002)(396003)(39860400002)(136003)(366004)(2906002)(478600001)(33656002)(4744005)(54906003)(71200400001)(5660300002)(55016002)(76116006)(52536014)(66446008)(110136005)(316002)(4326008)(64756008)(66946007)(66476007)(66556008)(6506007)(7696005)(8936002)(83380400001)(26005)(186003)(8676002)(86362001)(9686003)(107886003);
	DIR:OUT; SFP:1101
x-ms-exchange-antispam-messagedata: VJHY2/pJO+tuSplT63dfTa/uP4p5Zc34NoG8fv87lX/mam72weewzV/4b9PlrUxQx0O1Y8xId7GCjNLTGEOB+otQ63ccfkgJF5qtQI3Kow7mhjCjtxn8Kfo4iZdBefT1EY6ONgbfUy1SdeUgt03mhCJZsFJK9jNOfmknWwwAU4f3Q+r9Et14uIcz8WRjyf16r+J3AOr1pcCgvnZ4uiTNjJCDRqpUMNyvYFUv/5op0NytjOt09aMhhmFgpJX37pnVq1OMXoZMGDD3Pv4AYt5aDLizTAb6Q4PFtPbCETGqtvMYGTjJnsSCPdOW7chCsCZZ23YBoOVS/aTMwQf+FM/9+o1SSKgWtMg9jzNP8JHkDjIFrCaQ+mUYRf9j5zST2PNH1hHngPnDxnuru7jqEzs9XFFQFutCa+us4cVKuQUG6T2AQZMnuykwh+s/BViYxla+udwyRp1EBl1J//af5/2QLuP5vYUG/vFnDlE6Zdxpp2WBrUKXPD7RgljdCWgZrw4FHnoe6qucyiLymqhc1NhVHqcJnoDJfygC0IMacRNm73zSPdxchTIiKau/SNn+rmTXLuFqYobniDGIQETAbMkf5Jr4SlQVkRNjZfwctLQF3tm6/TsGvo9yUOF4GLJyHZwiwAAim69TfnVbLSdZy9rk/A==
MIME-Version: 1.0
X-OriginatorOrg: netapp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR06MB5276.namprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 489af52e-cc73-427c-42cd-08d879c730b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 15:52:49.4371 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4b0911a0-929b-4715-944b-c03745165b3a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z3ZkLkOyNJ2T7mq+YdlVF3HDISulKD+holO23B2nW3AQZgK8xZtODDt1x/GWvXPz+1QsetrCjbH2q32V7bLZRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0601MB3765
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09QFqwcc020358
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 27 Oct 2020 04:42:30 -0400
Cc: ng-eseries-upstream-maintainers
	<ng-eseries-upstream-maintainers@netapp.com>,
	device-mapper development <dm-devel@redhat.com>,
	Martin Wilck <Martin.Wilck@suse.com>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

> From: Benjamin Marzinski <bmarzins@redhat.com>
> Sent: Friday, October 23, 2020 4:15 PM
> 
> Cc: Steve Schremmer <sschremm@netapp.com>
> Cc: NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/propsel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
> index fa4ac5d9..90a77d77 100644
> --- a/libmultipath/propsel.c
> +++ b/libmultipath/propsel.c
> @@ -501,7 +501,7 @@ check_rdac(struct path * pp)
>         if (pp->bus != SYSFS_BUS_SCSI)
>                 return 0;
>         /* Avoid ioctl if this is likely not an RDAC array */
> -       if (__do_set_from_hwe(checker_name, pp, checker_name) &&
> +       if (!__do_set_from_hwe(checker_name, pp, checker_name) ||
>             strcmp(checker_name, RDAC))
>                 return 0;
>         len = get_vpd_sgio(pp->fd, 0xC9, 0, buff, 44);
> --
> 2.17.2

Reviewed-by: Steve Schremmer <sschremm@netapp.com>

Thanks,
Steve


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

