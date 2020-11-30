Return-Path: <SRS0=s6zu=FE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65709C63777
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 09:26:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 86EE72076E
	for <dm-devel@archiver.kernel.org>; Mon, 30 Nov 2020 09:26:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86EE72076E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=wdc.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-Q9qhuv0XMy2zUnv-Ga5sDA-1; Mon, 30 Nov 2020 04:26:36 -0500
X-MC-Unique: Q9qhuv0XMy2zUnv-Ga5sDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8569180A08A;
	Mon, 30 Nov 2020 09:26:32 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 683FE1E5;
	Mon, 30 Nov 2020 09:26:32 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 287744EBC6;
	Mon, 30 Nov 2020 09:26:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
	[10.11.54.5])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 0AU9KtSo010239 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 30 Nov 2020 04:20:55 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 788561131A; Mon, 30 Nov 2020 09:20:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 71C5A1120D
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 09:20:50 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[207.211.31.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CB42C103B808
	for <dm-devel@redhat.com>; Mon, 30 Nov 2020 09:20:50 +0000 (UTC)
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
	(Using TLS) by relay.mimecast.com with ESMTP id
	us-mta-107-130d7YR2OjWa_hkE2pHJwA-1; Mon, 30 Nov 2020 04:20:46 -0500
X-MC-Unique: 130d7YR2OjWa_hkE2pHJwA-1
IronPort-SDR: glaJzzFRbn7nTtk7W9c98S8aWKJhl82M3/co7MT23NvOJZCBOnqGx2TiV7VBXVoayw6ADWHeQM
	3fgrxezvWTk8f+8+R+Z68l+adnRfCJTt2+RYdy4+rcZcF2rFlLQnV84u7ai74jxhWwblrjVU4M
	avCuWtbZkrWpEG81gFmrl/ZFRdorolZqdYcNA/pXecY3RW68ZrJmfl2cFhqGqRl0/h/22mA2/T
	a6Vy64NlyjQ6WKiaqa9ndYC1k+sI1yTVYLJOkFkEV+5jHDqXuAJxr9uy0XI5Hw371HOPS6/qU7
	l10=
X-IronPort-AV: E=Sophos;i="5.78,381,1599494400"; d="scan'208";a="257475560"
Received: from mail-bn8nam12lp2168.outbound.protection.outlook.com (HELO
	NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.168])
	by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2020 17:29:34 +0800
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	(2603:10b6:803:47::21) by SA2PR04MB7594.namprd04.prod.outlook.com
	(2603:10b6:806:136::15) with Microsoft SMTP Server (version=TLS1_2,
	cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25;
	Mon, 30 Nov 2020 09:20:42 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98]) by
	SN4PR0401MB3598.namprd04.prod.outlook.com
	([fe80::65d7:592a:32d4:9f98%7]) with mapi id 15.20.3589.030;
	Mon, 30 Nov 2020 09:20:42 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Thread-Topic: [PATCH 02/45] filemap: consistently use ->f_mapping over
	->i_mapping
Thread-Index: AQHWxaGyr+5b4gA+mUCwb/eGRWLwDQ==
Date: Mon, 30 Nov 2020 09:20:42 +0000
Message-ID: <SN4PR0401MB359813D8023E2251B43B4ADA9BF50@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20201128161510.347752-1-hch@lst.de>
	<20201128161510.347752-3-hch@lst.de>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:a62:155d:1001:2c26:fc00:7c60:29b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 751e6574-9361-457f-762c-08d8951135c5
x-ms-traffictypediagnostic: SA2PR04MB7594:
x-microsoft-antispam-prvs: <SA2PR04MB759492A7E419B97F1D8F7F739BF50@SA2PR04MB7594.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: JCgbtmaSTyy3DghIPfsx4eWEPuUvYAkkK3CJMebAF9KG1fR4+wE3x/kXVotNX5bW0q+bYjUApAgmG/EtUCrR7Nzn2NV0tpoUoSg/U7RUfBmH8wL/AItJWTZnslA+VUH/6DfCz8H8/G0ZVP4LhRFX2CWmzj6GX8TSLxcwcyhYae0Yu+1BAU+dWZR3FdT4PMDqWcb1CEDtY3VBSOcMZgjjXIcwpUt/+L1FYPi3tpSMDIzt7wW6CrPxjub7HGgwuyinozLnk8t+Sr2/tnZm4amEeFnCF/0QqvVQIpCpmOXEp/NgBWDhtpMqS163YNM2wUPi/E2EOaoBgf+/OFgLr6bkNA==
x-forefront-antispam-report: CIP:255.255.255.255; CTRY:; LANG:en; SCL:1; SRV:;
	IPV:NLI; SFV:NSPM; H:SN4PR0401MB3598.namprd04.prod.outlook.com;
	PTR:; CAT:NONE;
	SFS:(4636009)(376002)(366004)(346002)(136003)(39860400002)(396003)(5660300002)(6506007)(478600001)(186003)(4270600006)(558084003)(55016002)(66946007)(66446008)(91956017)(8936002)(9686003)(4326008)(2906002)(64756008)(76116006)(33656002)(19618925003)(71200400001)(52536014)(316002)(110136005)(66476007)(66556008)(86362001)(7696005)(8676002)(7416002)(54906003);
	DIR:OUT; SFP:1102
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?JEMIQOyNoSrdWEla6GFHQ+ytsmJzhNypCj0GGaVTQKlTdAusFiwEgcrHb805?=
	=?us-ascii?Q?9D+pw3ROiXzwtoifQqR5vkt5j/eor1BfvYmGzM0a5aFnH7jThY3/gn7LfA9Z?=
	=?us-ascii?Q?MRdKgx0bKzJsxcAjjlcg/vd2us0YlEtDQ3xADuIq5CabQTTj1tuDq/jO3F9y?=
	=?us-ascii?Q?PZ8rT2ZkJP9TKZ4AoTM4lRfhFFtK/UGtpyczfP6cUAURpGk0u+wJRHlo5cmG?=
	=?us-ascii?Q?c5P4glu3/TdCQCjEJyWMTnQktoQzipilkoe5XGFZ+4/D+rTr/l3nkV3GW+P2?=
	=?us-ascii?Q?Uv1kiUlcKjonIR+Lj1W2yDInjzVAMSJ9M+8uJ7m6Ttfl0eC5O34jnuIUYZ+7?=
	=?us-ascii?Q?/hvrsKtlXEXYPzlASE+yBZ5WdARlgvGM/hxVum7C+B/71WyloD0rmslT7CqW?=
	=?us-ascii?Q?ta/sLB0XKQbhPPHy7EjuLwleytOnmgVkAB8vMyVASkvvEg0aMgFw0a5VDKa3?=
	=?us-ascii?Q?gFlPNPAQIqATzi+B7H4S0Ruijmw1Hxbb7UnXXYqLhdvafve16p8ckP07ACuK?=
	=?us-ascii?Q?lfCJrrgfd8vRJOJLMMyyJ/pU3+14gXsXJNCfKr/jCqqdHivEGpSU8Vb1nc2p?=
	=?us-ascii?Q?vetm7NckLr1ab4rf3W9DFKUp18/5uH0lwe3E0NWdFiwoU34EcYTLaLg56jvE?=
	=?us-ascii?Q?JM3NgPtrYgfCGTlvg/4+o1CSSuiJWfIq9HbQqOrF6TxdRsiTjfvwU4tPL2vY?=
	=?us-ascii?Q?8HnledCWE66D97rozQfzgjOiWcLvH0xcDlxn75g9F8jFIWQfLZcrDCSIZL5+?=
	=?us-ascii?Q?gWV2uX5+4Ogp1Y34TIqrkqLZwS5584A00PmJxlwgkgtYmTrWPPWh0iMyloXp?=
	=?us-ascii?Q?6uX9/CXfZ8S0YPP4SUEV1+Ly5XiMhElytSe7JQL24p6VvTKd01Zs7Lw0Yeq7?=
	=?us-ascii?Q?PmxmWIN1P+Z9bBfS1YAAx/ueAlCwhR5lF973g5hFz2k6HoMmv7mIpx4xBrng?=
	=?us-ascii?Q?TUBtV8Cea1C7RZuvbz9INhFrUci5ooKh0czri0/4gYzI7F1JhMu4TatErG7R?=
	=?us-ascii?Q?uW/CzK7fBBQTHzq1wA+ZLrMIBObJ+y7Ex6gvanDWiKhmuw/5bQeZ4592PTrs?=
	=?us-ascii?Q?cVFYZFN9?=
x-ms-exchange-transport-forked: True
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 751e6574-9361-457f-762c-08d8951135c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2020 09:20:42.1141 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bBHBHbzgc5hL+/yxra90vBx/gdwLCOM8ei9yMZF49qzLb2FzdrakCUEatiTS2nyTta3rrhUlGMrK6vr7zKTmPzqy4pBvvxKMLgs5mWN5UVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR04MB7594
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 0AU9KtSo010239
X-loop: dm-devel@redhat.com
Cc: "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
	Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Matthew Wilcox <willy@infradead.org>, Coly Li <colyli@suse.de>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	"linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
	Jan Kara <jack@suse.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [dm-devel] [PATCH 02/45] filemap: consistently use ->f_mapping
 over ->i_mapping
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

Looks good,
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>



--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

