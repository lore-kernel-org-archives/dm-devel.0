Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E3CC64E7B
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 11:27:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B343320679
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 11:27:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B343320679
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-HLi0QFahPjGT94bHpQju4g-1; Mon, 30 Nov 2020 06:27:00 -0500
X-MC-Unique: HLi0QFahPjGT94bHpQju4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 00D8380F04B;
	Mon, 30 Nov 2020 11:26:55 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D42AB10016F4;
	Mon, 30 Nov 2020 11:26:53 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0C637180954D;
	Mon, 30 Nov 2020 11:26:52 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AUBQnhS027061 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 06:26:49 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 781DE2166B2E; Mon, 30 Nov 2020 11:26:49 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 7136D2166B2C
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 11:26:47 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A8C980120A
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 11:26:47 +0000 (UTC)
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-251-vL5c_V1uMTmgWYP5OLVd6g-1; Mon, 30 Nov 2020 06:26:44 -0500
X-MC-Unique: vL5c_V1uMTmgWYP5OLVd6g-1
IronPort-SDR: OmjVBp2+/KVjZgsE5EXdXaIUXOv6X+0D8CTji+Ef1cZD3U/WQHnV1R77gfGQb1aMokp5XgiegP
	FwJYRxMxsKbCSUNq5vDYQoBww/X6JRrz3NSqxeWUNegXe42c/0gGKmp97ZBVpGN2yw4G2x+BVU
	cJbHZCwIjKabeS9bZ4cHcIq+5ZP0KotugabmP9srf+w+WsJ8E5CLVtWXMVbCxGw9XLauWahaNs
	ry1B/mH4H1A47aL8RKQsUZsbGb0jmeZHH+mNrn/7FyUixY43JOnfRNhPGiaFygqSm77Sug/uCm
	I20=
X-IronPort-AV: E=Sophos;i="5.78,381,1599494400"; d="scan'208";a="153875405"
Received: from mail-co1nam11lp2176.outbound.protection.outlook.com (HELO
	NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.176])
	by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2020 19:26:42 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SA0PR04MB7436.namprd04.prod.outlook.com
	(2603:10b6:806:e0::15) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.25;
	Mon, 30 Nov 2020 11:26:41 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.030;
	Mon, 30 Nov 2020 11:26:40 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 07/45] loop: do not call set_blocksize
Thread-Index: AQHWxaG2UPoC+nZlKkGLQI6ts2xybw==
Date: Mon, 30 Nov 2020 11:26:40 +0000
Message-ID: <SN4PR0401MB35980299348BBA758C4B971F9BF50@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-8-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:155d:1001:2c26:fc00:7c60:29b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e1f9f9d8-ec50-4336-825c-08d89522cf28
x-ms-traffictypediagnostic: SA0PR04MB7436:
x-microsoft-antispam-prvs: <SA0PR04MB7436FFA28E0D85578A5EF6A79BF50@SA0PR04MB7436.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: C/fTD1l+S8WQ96C8pa8WdYKEZl5iM0kiZ6StblqfNPaXFSfpNi3xDBgKXj/2cMrzEU5d9b0N+4+E7Pj959cAnc4YGAegLLcotqVQuYga82OaFh5DRyKqw8d9g+ZNXYYgMIPYhHIsM0IuDpq9wENx4dW4l6vmrxL2x85YMDfCej1v1gTlha/2Nwm5BGLUSeK8bGYKghPMKXR4mvWUA/i1iGAHHPctFYt77Do5lkd5ss64xVKbH0fIiZH7ZYrCLFgFe+rBf/l4tSOxDOIot/AcS3SQMg8bRvjlQAlTlUAnYlmjE3l/sZfjqRk2a5iNCmMJa2qBZqrf6oWXhCeo85Cm0A==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(346002)(39860400002)(136003)(396003)(366004)(376002)(33656002)(64756008)(66446008)(316002)(55016002)(5660300002)(66556008)(76116006)(186003)(66946007)(110136005)(558084003)(19618925003)(54906003)(86362001)(52536014)(66476007)(8676002)(91956017)(7416002)(4326008)(71200400001)(8936002)(2906002)(478600001)(7696005)(6506007)(4270600006)(9686003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?arA84ct3CvUDHCx8N0pBqLNK7/MkKQ0M6UClHD8sGI8IgxHuzisG/vQwpj5f?=
	=?us-ascii?Q?lHOKlt+AakUbbLM2kw8mrC+kFyQg4TbAjzubEtH9FSUw3rdHw5faZqN7X4T2?=
	=?us-ascii?Q?8RrrBCGAhf27YIT5n75+6M3V4pINv0+2G1hLo3w8zNGXYxqKJEBvSrNJecgg?=
	=?us-ascii?Q?dW6y8I+OabNr5T5F2JOpmTeDpsMHw/yUC1x+6oFs+/+yCq3ymn/rbC7FDIag?=
	=?us-ascii?Q?9AziGT0SKSFkw7nEHKxP1kXegOb6vV7GHgmERi09gzyiX/e6c6Z+UZAqaqun?=
	=?us-ascii?Q?hacEWecBAIscwOHcELkJE8GQbfjuspyQ0RUsziZr7xBeHgrT/4nkBNDTmLxk?=
	=?us-ascii?Q?GcjL/h4tKtqXqcKYR2jrWxI83oaQNB6U3RfAa6WRlGWmNeE6/FTy7nxDp8Tv?=
	=?us-ascii?Q?uQJ/fOJehUCqRoq8+F9z6AHTgSy4zGSqVm50W09pFiHbVedkyv8ITsmgoy2P?=
	=?us-ascii?Q?CYh4HqTlGgb3mZ7LvxuP1eFjORWVWUwXebaJ5sLhc3PWPbFPOrZCf1bWFeUM?=
	=?us-ascii?Q?3owBmbDwGmqapN6zvyQ+EpRhbKWdPW5t6ZoNwjzp1HpMOulO7jjIqJ2xXmu+?=
	=?us-ascii?Q?6HYZEx8vV4YzRjslu6PkNJVQzXbwKkpbMLd2XgdNAy2halT7ohfctChTGjmZ?=
	=?us-ascii?Q?j/bbREokwQPplndMckjuamYhgTazBaLddgb7+IXXfc6baQiqgh6jf6Fk7HxT?=
	=?us-ascii?Q?wGBS+UVFTAKzojKljmKzVitfu012Q2fnF/4kUiTDAKKQTGEvd1auygpKaj+D?=
	=?us-ascii?Q?V9O8UTPdA4LJFXl6unBTDUcosyXBcJY1D/QlOJsvWFAlt2gy4c4Vy5w6nPsm?=
	=?us-ascii?Q?wcj1Cei9n/h7ur0MbPgLCgCGzcGka7zpg0XtoJk1RxngHHqUL21B6hVMNCBt?=
	=?us-ascii?Q?+8ntXKC6EWjz/Y4kPlP1hXTSpShya2ZNUqphmswpTRydE6uZ6AM/0NC4uLsF?=
	=?us-ascii?Q?8T9jB62tOr8568I0LNoy/OnJAQ6P8lNKEPC0XCQigGpWhG8xbz0XbNXwqke3?=
	=?us-ascii?Q?70STR4ZEW99NLQTtcbJEi2LBLmvP1SX8yeFK4Q8jsJ+lAgpqaEF8irYCD67j?=
	=?us-ascii?Q?1t5GdEDq?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f9f9d8-ec50-4336-825c-08d89522cf28
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 11:26:40.8311 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JluDZqeAyRCGF0BjtVqI+V0Hy+Bj86m859625whxYIDXRc/SwNiZ8casvh5/JoCtb7/asdYfl6DjtLvuzI9WnsbbQvcSAIY6S8vj99iPQ0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7436
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AUBQnhS027061
X-loop: dm-devel@redhat.com
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@suse.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 07/45] loop: do not call set_blocksize
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
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
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

