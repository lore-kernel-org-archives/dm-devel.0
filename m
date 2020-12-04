Return-Path: <SRS0=D9Ri=FI=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E6DC433FE
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 64E8422513
	for <dm-devel@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64E8422513
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-20GNeVMnMzm3W0OjH9PhGA-1; Thu, 03 Dec 2020 22:27:34 -0500
X-MC-Unique: 20GNeVMnMzm3W0OjH9PhGA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F5A6800D53;
	Fri,  4 Dec 2020 03:27:30 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 53A165D9CA;
	Fri,  4 Dec 2020 03:27:30 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 2BDAE4A7C6;
	Fri,  4 Dec 2020 03:27:30 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0B43RTMs011805 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 3 Dec 2020 22:27:29 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 5239610D1783; Fri,  4 Dec 2020 03:27:29 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4D1D210D1782
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 03:27:27 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEBC88007DF
	for <dm-devel@redhat.com>; Fri,  4 Dec 2020 03:27:26 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-386-9XnV_rdQMZ6rzAN3R5R_-A-1; Thu, 03 Dec 2020 22:27:24 -0500
X-MC-Unique: 9XnV_rdQMZ6rzAN3R5R_-A-1
IronPort-SDR: PmcBKIBiy8cwgufnfh5gBUM+2wsZa60Wi0lDtC6UKHN33juLQktYczJlIrfTdXryooePjxad+o
	UTgiGc5fseo+lv4tkW6r0waYadZITvINuWroJQcJtKvS6vATx2lCrkTD2iioZZdHx7+roX1Qns
	6VKe/NOWSPJnlyfDQsrUq3Y9CXgM9Qbju579jqrvBL1SF9/cArtpOpUvVsy5iWwoZoAzu9VSz3
	T0ZWIv3SzEqqxwmwOutpm6FT/lH3fdIAxyv+VlQ9Fp9lEjQxRx9qN6U/E7fDvgiuzOSYWPI6Gy
	AH4=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; d="scan'208";a="154367103"
Received: from mail-cys01nam02lp2050.outbound.protection.outlook.com (HELO
	NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.50])
	by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 11:26:18 +0800
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
	by BY5PR04MB7123.namprd04.prod.outlook.com (2603:10b6:a03:227::10)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17;
	Fri, 4 Dec 2020 03:26:17 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4]) by
	BYAPR04MB4965.namprd04.prod.outlook.com
	([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031;
	Fri, 4 Dec 2020 03:26:12 +0000
From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 3/5] block: remove the request_queue argument to the
	block_split tracepoint
Thread-Index: AQHWyZEFNTOeNzY5Jka6tRtodLuhyA==
Date: Fri, 4 Dec 2020 03:26:12 +0000
Message-ID: <BYAPR04MB4965387444860B94FD948AE186F10@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201203162139.2110977-1-hch@lst.de>
	<20201203162139.2110977-4-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4a7d405e-a0ae-453f-88db-08d89804597e
x-ms-traffictypediagnostic: BY5PR04MB7123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB712303C000180BFD3A96292886F10@BY5PR04MB7123.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: RFHzhOLqW0GqxvZrmMBcdXTA8LfMiMZmtA2cWCUE6IDuAcw9GSlys+2D29InI78l9XWEApiS9UQgooR6ArscENZGx20nJycLjc7DfhxJ/RRgxBnwW/fgIZWpFmDp0GSBh2jYNMNU4HboPgT/Yzwz1tUfbbyqJWbcsAhNxBlRcDT/YVGAfOB/0ziNYLHhvMn2E+fyd0Ue/qIrDuaBkIhjkAtJEeqSIKjqOCKiSpUm5xO3aiky7k1ntyA7KK3TzT1X1rAQHOUg/GKK/a/NBomilW2N48dCBiIP2/SJdqI0CgUZOAzGMuD3EnM/QRhjJlzZHWXNz7QUAn15syxx1oOsqw==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:BYAPR04MB4965.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(66476007)(66446008)(66946007)(64756008)(186003)(66556008)(4326008)(54906003)(316002)(110136005)(26005)(558084003)(2906002)(7696005)(33656002)(6506007)(86362001)(71200400001)(53546011)(5660300002)(76116006)(52536014)(8676002)(8936002)(55016002)(9686003)(83380400001);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?LNHdLRycY4VB3AN0+nc0o4o0Svn7f99vfSBbx2Mw+ERW3JAdlIplxF3T3Xu4?=
	=?us-ascii?Q?ZPPMPt4Z25xxzYNdHCPocOOSWQipXRMvE0QbLIqO+uDqiX9bS1XmRkbygIqR?=
	=?us-ascii?Q?snb2YlcKsiHayBQKEbk/eX4wGEJm+sPQ0/Ew0QX2N1oETfOM/JyVbV9E/s/G?=
	=?us-ascii?Q?c2on1guwOYMJXYGKjvh8oa/Zi8bM8vMr3ioHctS17OyFypYGbtfG/IZDzbb5?=
	=?us-ascii?Q?A1qfalxBfYeuPlmUWDGrB5PkGFUgnTY1qUJTEeeVwuk3YKHJ4XtZVyWBLgkj?=
	=?us-ascii?Q?y+7l2elWDuaVb0QltPmFrzinT7MAEJuDyjEvtjAJDyBJYR6P0zpClMQdwqol?=
	=?us-ascii?Q?kBBSeewi4tW7jYJlB4OP7/XvkiLLz9LBXS2c62st3NTm0xyDIVg70PuMBKef?=
	=?us-ascii?Q?nxh/O809Kjh6h/4bmQjfyCzoNivUdgbr9QPKVtKNmVU923PAMYtK3gqYxZiD?=
	=?us-ascii?Q?/fpFp4MO00PxwUIlmVdV0SovC011iuLMf5HIbXNBDpnMx5yYC4gA8gY6lIWv?=
	=?us-ascii?Q?qTMHME2k3KJCzg/PfWa8yr+u+dZycvYXxh2j4FxyhxpAN2FqEjrMEHt1a48W?=
	=?us-ascii?Q?Fb4/6kHK236ufrt1Riav5HC9VsQmn4XRy/dlla01rWXCpp1c/KC3ZNABjsor?=
	=?us-ascii?Q?TFH1/NEE1s/2SFMVwtXG0OGDodESS5QrVd8U0mFEnOG4hrtXpeOy//xEv9UX?=
	=?us-ascii?Q?AQBSTjmOQfdSyipij2k0o9QZjJjOMGsxqqlte9qDXC2InSXICsYv3yu5CQ5Z?=
	=?us-ascii?Q?A4bOwYUO+z8mANOOzZpshrA4czHiRn/lR/AVLU8pRxzTGD0yQ7CtaA7pjvMO?=
	=?us-ascii?Q?bb+YmSadkNr4p8JVaiaZYqCYuy0BVSZckiZB8FTpViCsyJFhAtwDiZYLkdTL?=
	=?us-ascii?Q?5CbC1efKgy8/IbtraHmJAq2A7Ju2lcd51i3YUHPv15t03Hv90RDHE+d0sF6O?=
	=?us-ascii?Q?si3FfRrm3bUhXx6rr/1LO911K3dUFWhYNpItMa9yV6bNqnCzni2BZ8b0/W+R?=
	=?us-ascii?Q?mS5N?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a7d405e-a0ae-453f-88db-08d89804597e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 03:26:12.1161 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h/VSoKtZI1d1V54y3qG5dsGa0QO4EUoEOD0YD/nWLXU/2Dwbr+2848oNPc0oZspSvhz1ipu/nA50SkdlkNtr3/aPAuY2knfxYIRKSWoHgko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7123
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0B43RTMs011805
X-loop: dm-devel@redhat.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	Damien Le Moal <Damien.LeMoal@wdc.com>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 3/5] block: remove the request_queue argument
 to the block_split tracepoint
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On 12/3/20 08:26, Christoph Hellwig wrote:
> The request_queue can trivially be derived from the bio.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---

Looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>




--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

