Return-Path: <SRS0=sUON=EZ=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0541DC388F9
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:39:30 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 31B01246D1
	for <dm-devel@archiver.kernel.org>; Thu, 19 Nov 2020 08:39:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31B01246D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-tSlkcxTEOCWk9tX9lz6Snw-1; Thu, 19 Nov 2020 03:39:25 -0500
X-MC-Unique: tSlkcxTEOCWk9tX9lz6Snw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C82958143F3;
	Thu, 19 Nov 2020 08:39:21 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id A8D4B5D9E2;
	Thu, 19 Nov 2020 08:39:21 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 8040C86C09;
	Thu, 19 Nov 2020 08:39:21 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AJ8dJLY016442 for <dm-devel@listman.util.phx.redhat.com>;
	Thu, 19 Nov 2020 03:39:19 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 85271200E21F; Thu, 19 Nov 2020 08:39:19 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F8372064011
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:39:17 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1EAE080351B
	for <dm-devel@redhat.com>; Thu, 19 Nov 2020 08:39:17 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-389-YUcu5aF4M36V0p0yz7g00g-1; Thu, 19 Nov 2020 03:39:12 -0500
X-MC-Unique: YUcu5aF4M36V0p0yz7g00g-1
IronPort-SDR: 7kpecrLv1R+8Tn0CZmRF0yo+J7M5rxF63VVhvXMSVXhy0xPzBwLW9bRZ41RPQuFsLSPhrVgW2p
	Ynmljzaf5ROHMcakCa4XZ803Oubb8Irxuh0L0eAU6Q3z9Iwc6As0Dl5TYLU6rbLuzPURdwfoA9
	NBgF12olrN1laUNt5lJ46l/dLw+0nysf5AujmAWQE82XSaJMG8kn4XSl2u4WsXgxhx/Nq370hC
	DitD+xK1g8tiQSf/o/AMAAeHvZSa61iucXxhtjNy7psFUfQ8rmros+lKLLePsDMOIFyMc5QpEv
	Lp0=
X-IronPort-AV: E=Sophos;i="5.77,490,1596470400"; d="scan'208";a="256563203"
Received: from mail-bn7nam10lp2109.outbound.protection.outlook.com (HELO
	NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.109])
	by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2020 16:46:49 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SN6PR04MB4862.namprd04.prod.outlook.com
	(2603:10b6:805:90::27) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22;
	Thu, 19 Nov 2020 08:38:26 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.022;
	Thu, 19 Nov 2020 08:38:26 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 07/20] init: refactor name_to_dev_t
Thread-Index: AQHWvYgrYc1Qp0WgLEOTR53TfvPOSQ==
Date: Thu, 19 Nov 2020 08:38:26 +0000
Message-ID: <SN4PR0401MB35988935BAEBEC04C143EE759BE00@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201118084800.2339180-1-hch@lst.de>
	<20201118084800.2339180-8-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:157d:bf01:851e:5636:4e29:3e2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b730e505-bdff-4d92-45ab-08d88c667bb5
x-ms-traffictypediagnostic: SN6PR04MB4862:
x-microsoft-antispam-prvs: <SN6PR04MB4862C4EF0AEAA7A94CCC4D829BE00@SN6PR04MB4862.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: AYG6BnQlsuGA/acLvLJgD7cGr5/O+puH6AbW6Ju3ilicmeE2aoZVRwEBcJL8W8aHpanaHc8PRJyDum4B+H0jOgvDGD/rMvmlvtImEIktxVkuLuNFT4HUZNSHcSRjPusPZ2bo2XYdTh67fWzZvTAifSG9aOSwEKW9qAqJ5Y9aZZakuYlci1SV9LfPN05lKXRvygjeF/dKLfMFLrF3VwM3p4NNFkQwm6nLHd7nkqQtdj6Bq6P0EiGGhjJNs6jSXIUm+1kPjv2Euhf1k1OC92gcVCDrIY/6DjeLROMeEDlDPTIhaI8sR+zJZNo4tIxjgPes0DLo2qwiUKhorvU5EmOKrg==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(366004)(8936002)(71200400001)(19618925003)(4326008)(33656002)(7416002)(9686003)(55016002)(66946007)(76116006)(478600001)(66476007)(66446008)(64756008)(86362001)(54906003)(66556008)(91956017)(52536014)(558084003)(2906002)(186003)(8676002)(4270600006)(7696005)(316002)(6506007)(110136005)(5660300002);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: hA8+VzTCyu88zqp8ByagDd0VV9gn8kSx4RCMDL80KLf+qsSjq+JJ+bxL7h9DgMh0ZwH1/Hhzz24dfWQK6FvSCu2N2pODdFcZpmexlWvb43BEP7St9yobdcngjk3Lx23YjM1HMbAHTeBb0P7l1ZVhUM0+3BzwYQ3epRmAQhV+fdYJtfD4FNERaTCynw7pFA5B0GmOG2LWvsgbGA+FQ28CWZwmZ8HSz2yVlxB7oMiEt4oyfqDxdbDak+pMRivWO9tR1DX1RHpX1/lRr/ItsnPk2dguWy4anHW7zaImw/O6IIZT4sv3HbDpyH8j3bFI+Pi48foAdx8OazbcByGmP7l8WbieradKMX+tM+ZGCCqcwEW50guJ1Vnjpz+t7iXwUcvB3nW6FTXSjv+ERovMxV50QWObbeA6ZNDNMaucAYyMMejfC1z6KRC2TbfwNvBkfeynbCLY7kQj9a7md0DpP6tNT7E25J72eXrv6hhVxYOqxhvsNZnxZg1FpUlbkL5GRDCxaFgFofYR3IdLVebcBnr50AAiTO/o9WggMNLecfIc+ppyFZbur8YLgkersC1lMcL9QSzbG213UNIp6RuVTy/+FJlzDX9Gi27/XvknejmLj8VqY07T9dFYVsQZPclrWxlG0L889mu5DAIedBfF3TaUy2uAMoLTbmL2OsDxEH7c0w+XTm9Hqpv7dBhgiDMriKT2BXIVJXnQfgXxZHOaHgeBAw==
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b730e505-bdff-4d92-45ab-08d88c667bb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 08:38:26.2255 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CUJKjc+O7Uc5n1gkeDg58OBnuesd0SrFF3yd4avvUfbb7H6fsgi8DwfU5idErUdSk0MYdyD7R2wm2ECOP3+WegiNVulxDiOK0nUj9qsmyKo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4862
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AJ8dJLY016442
X-loop: dm-devel@redhat.com
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Mike,
	Snitzer <snitzer@redhat.com>, Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Richard Weinberger <richard@nod.at>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>, Konrad,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>,
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [dm-devel] [PATCH 07/20] init: refactor name_to_dev_t
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

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

