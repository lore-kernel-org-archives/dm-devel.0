Return-Path: <SRS0=cPWn=JN=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 388B5C43460
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 06:55:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 975306117A
	for <dm-devel@archiver.kernel.org>; Fri, 16 Apr 2021 06:55:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 975306117A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-602-8KJ0t0y6M8-p010FZRd1Tw-1; Fri, 16 Apr 2021 02:55:41 -0400
X-MC-Unique: 8KJ0t0y6M8-p010FZRd1Tw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17A7C8189C8;
	Fri, 16 Apr 2021 06:55:37 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BFB1D5D9C6;
	Fri, 16 Apr 2021 06:55:36 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8EDB91806D15;
	Fri, 16 Apr 2021 06:55:36 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 13G6tY93018881 for <dm-devel@listman.util.phx.redhat.com>;
	Fri, 16 Apr 2021 02:55:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id D61B1112D431; Fri, 16 Apr 2021 06:55:34 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D01C4112D42F
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 06:55:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49657811E93
	for <dm-devel@redhat.com>; Fri, 16 Apr 2021 06:55:32 +0000 (UTC)
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-99-dVhU_A1wNmWsK5ymJEQkqg-1; Fri, 16 Apr 2021 02:55:28 -0400
X-MC-Unique: dVhU_A1wNmWsK5ymJEQkqg-1
IronPort-SDR: XObSiK8eJtCESMuEYkJT66MmS/q61AfgxHyiD/rxgvvmz7tnIlBlnQTNgyJZCmD6EpNiTcIQ1Z
	gVMHJXMnNuczJRvKVpvcbDxS3wHTr8Oa2ZH9ISrgfSBazfnKYQiHciKrDV5+o4ERkflDNKykCo
	ocyYMQ8bDswq4EukER/E4fcYLR9u0OqKQxGip21HIIFdTNZLYRg4Ys1BV8OSiu0/5+b1hKYG3j
	qLFEO16XFJTkQ2o0BHnV1deCkEkZCO3KeYW12jyFjR3eIhXuoS1syelfx81GWFgKW8wmSHQlRs
	n0A=
X-IronPort-AV: E=Sophos;i="5.82,226,1613404800"; d="scan'208";a="164435572"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
	by ob1.hgst.iphmx.com with ESMTP; 16 Apr 2021 14:50:33 +0800
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	by PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
	with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18;
	Fri, 16 Apr 2021 06:50:15 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3]) by
	PH0PR04MB7416.namprd04.prod.outlook.com
	([fe80::99a5:9eaa:4863:3ef3%4]) with mapi id 15.20.4042.018;
	Fri, 16 Apr 2021 06:50:15 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Damien Le Moal <Damien.LeMoal@wdc.com>, "dm-devel@redhat.com"
	<dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe
	<axboe@kernel.dk>, "linux-nvme@lists.infradead.org"
	<linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@lst.de>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
	Petersen" <martin.petersen@oracle.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-btrfs@vger.kernel.org"
	<linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>, Josef Bacik
	<josef@toxicpanda.com>
Thread-Topic: [PATCH 4/4] zonefs: fix synchronous write to sequential zone
	files
Thread-Index: AQHXMm1m7H5bwoYRjkK0xFA15aMquw==
Date: Fri, 16 Apr 2021 06:50:15 +0000
Message-ID: <PH0PR04MB74163E5D0B2D9FFAB2AD74ED9B4C9@PH0PR04MB7416.namprd04.prod.outlook.com>
References: <20210416030528.757513-1-damien.lemoal@wdc.com>
	<20210416030528.757513-5-damien.lemoal@wdc.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:15ab:1:e10b:72a5:d443:5e5c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 40b16cf9-000a-4475-43f9-08d900a3e3f4
x-ms-traffictypediagnostic: PH0PR04MB7416:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR04MB741633E3A168CEAAA2781CD39B4C9@PH0PR04MB7416.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: WrDKmQYrw5Yy4sKEGHMRfpeoY0Na/G7VNJ1366PO+B94yQaI/8LpLdEkYmWqopBJWluZjrgFPh4lpnUXskwhhXjde5Mw2CUpL4Li5Qz7SfQQiYAkrzp126Gc+qJQd5ntHvGjhhGkpytHm213RAQG946l1a8hf476iUC0Z2GC2KdrNt51Vnt0b0Rko2/xLj0fUVY7mAaUeiHDenC39gQjoy3QArZ7Ob8YHRU6xr4oXWFd1bvdji7urwGhlOcAUGi5KllIOzEnzwn8GQboubmaoPitni3rgcbZe+uxecUGIDRsuT6UWkTd0M6IN8wfBm8hKtzJcRwkszEc7rQDatLB3Au944lfWnFL0aDnQ4X5JdD8U+xwhGiB7lvpqUoWRG1reXT0NFASX63QE70K4fi6JHWAbbAwMQ+4m+1gfiRXvUU7xA1uBeSA+pHR9a+Z2kZMpaFlWmfmxeeHWTlRdGrme8QIUty6FQZRGa3UOO+9X5GOqpHssPYNxipu03Z+DyhxsqkelCrFo/+s6pdWRVC2T6lYkNfamYGEGib1Kncl4kSV1onG8S94R9vdm9fWKqnAtpxuCL+z/BKAqKjUysOiVVW+Tv1LayZL8sqSW0ui7ffOzxtuJCj3+N/TZuylfL9+UxxHbmQq0lN1np1IIUeCBg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:PH0PR04MB7416.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(396003)(136003)(376002)(366004)(39860400002)(346002)(6506007)(4270600006)(55016002)(9686003)(52536014)(186003)(5660300002)(71200400001)(122000001)(66476007)(66946007)(66556008)(38100700002)(76116006)(86362001)(91956017)(66446008)(7416002)(8676002)(8936002)(558084003)(4326008)(64756008)(478600001)(7696005)(54906003)(19618925003)(110136005)(33656002)(316002)(2906002)(921005);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?11D44UkIl3ymG7H5mxIeCAv5yGiPWAXaZWo2erilNq6U+TuQWfhEBi1FVIMk?=
	=?us-ascii?Q?N9mM9tz4qADa4l7OUpaF5yjrMwP6gfZlJ2SdF+O0tQXASSFOcFgdYdF5F3dq?=
	=?us-ascii?Q?2Aql9UEvnMYv6+5XU5oKm8S8hWOWgdrwzAC4cvXtxhSAHHT4nB6qs0HC1aP0?=
	=?us-ascii?Q?L5JcjkGe8YAnQfb+zTbARnpbfw5GAqnN1YIjBPG5Sj5R24DrPis2RulTW51D?=
	=?us-ascii?Q?mxD89f1/TXd3swLW8RcYzbaZi1Qhyywge32bAbv2Hf8sDKHcJSUPVVOGhwa/?=
	=?us-ascii?Q?pa65btFLKz/fad4MG+3toxiROyJovHFnec90+nrTj7zHc8v8wHupWcL5MlMk?=
	=?us-ascii?Q?k4P92AVkq8JbnB+Sk3MUCddwDmEIShuY+xtYVT+5bvsi6aGlEQsY/UfhVOZk?=
	=?us-ascii?Q?a59n5blJoufkiQfqpjUsru96qAK4dmQyMkD+UO9Dcv6ZnFPgYWwNxcWm8GLk?=
	=?us-ascii?Q?5eaLExiwpWPZUamDxw+vSqE1KUarQ82UfoFbY2LWTWLsXO5ltanbZxvbsn1/?=
	=?us-ascii?Q?0KCsFdiVq1GuP1Eh4UTZ2UK4Lh1SCpTUlemNlTteS8kbkLhKPjCKq5PCBk6f?=
	=?us-ascii?Q?WLY8Dk2t0iSbmBFsCCbaqQ8xsiewUj+Y45oMl+Fzf9rac3C1HrURzhF40Kbf?=
	=?us-ascii?Q?AJnaifCL/I9V6QFCFK0NmuCBjIdhZrOOEG08ztT9v6T/j1z/Es5pSUvrWzLs?=
	=?us-ascii?Q?XA8Qo9LNfQVAZiSM5XWex/TX+KUB0ejD5T+2M7+6co+v6xqj2/bmFTXElaNE?=
	=?us-ascii?Q?vdCPGjDUm11np9nJwx/6LloSjWPenWlFdleU4S2eTkv4fnBTf0vXl004d6vE?=
	=?us-ascii?Q?m3abmUz9ajwo75YHaxBJtPb2bPL1rYpPlG+HzbhhGfZPXPsiTTbF2smhELB1?=
	=?us-ascii?Q?526Qw4eftUbaZgbfRqTcTzWRrikNl9VuaBSPQR1oqGernpspkRFDBOLx6hIQ?=
	=?us-ascii?Q?EkugQCX6Sj7zPIVW8cG5a/ScxP02gnfn2Xi7fzLQYC6Rz6fLB+JZc8MbJdGx?=
	=?us-ascii?Q?l3NQu6aVF7Paq7SA0D40hPnI8mkeUBfTQpfFelAqnjWm6KZsoRQd2+YCVjLX?=
	=?us-ascii?Q?G0HR+yuRtuelbvMx7d2ysNwQAnBrpbGb1ktNrbocG4riHVrFxZGbfZL7Q4aD?=
	=?us-ascii?Q?eoG1adDOQSrkN5/H6EovoNB8NdxiTeiLozUvrc+RR7tn8U7UMOzF2rRkw4Q4?=
	=?us-ascii?Q?yQfTWVUcDIOF4yMDcoXenKeyUXzHdsKrolTmWH8E9oFvVJI/uocRPqSAnfDE?=
	=?us-ascii?Q?FmThfLvys1CPKAD5YoZr7ALRyjWG6PJLwOQmBSpWRrM46tuKFkM12sIq7vq7?=
	=?us-ascii?Q?TIWvhfKOND2Xuwn9j8ie6Ey95ZRkTl6R4Ew1MRq494Wa7PKWbsRN2H4xuWW4?=
	=?us-ascii?Q?I66tSMtlUzDDNp9SirCVlwtZpsl0?=
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b16cf9-000a-4475-43f9-08d900a3e3f4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2021 06:50:15.1580 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QTrJp8UjEbTCW8Ch6nnDHSfTI100ZvESwpEFUmyvcUVEti7HZXCVjOwsPpLOLEp9Q5TgvxAjudQ42hRS8dAOpmFxwcDu1tThja4eLcpsn+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7416
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 13G6tY93018881
X-loop: dm-devel@redhat.com
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [dm-devel] [PATCH 4/4] zonefs: fix synchronous write to
 sequential zone files
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
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

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

